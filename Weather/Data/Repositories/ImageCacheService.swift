//
//  ImageCacheService.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

protocol ImageCacheServiceProtocol {
    func loadImage(for iconCode: String) async throws -> Data
}

final class ImageCacheService: ImageCacheServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let memoryCache = NSCache<NSString, NSData>()
    private let fileManager = FileManager.default
    
    private var cacheDirectory: URL? {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("WeatherIcons")
    }
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        createCacheDirectoryIfNeeded()
    }
    
    func loadImage(for iconCode: String) async throws -> Data {
        let cacheKey = NSString(string: iconCode)
        
        // 1. Check memory cache
        if let cachedData = memoryCache.object(forKey: cacheKey) {
            return cachedData as Data
        }
        
        // 2. Check disk cache
        if let diskData = loadFromDisk(iconCode: iconCode) {
            memoryCache.setObject(diskData as NSData, forKey: cacheKey)
            return diskData
        }
        
        // 3. Download from network
        guard let url = APIEndpoint.weatherIcon(code: iconCode).url else {
            throw WeatherError.networkError
        }
        
        let data = try await networkService.downloadData(from: url)
        
        // Cache in both layers
        memoryCache.setObject(data as NSData, forKey: cacheKey)
        saveToDisk(data: data, iconCode: iconCode)
        
        return data
    }
    
    // MARK: - Private Disk Cache Helpers
    
    private func createCacheDirectoryIfNeeded() {
        guard let directory = cacheDirectory else { return }
        if !fileManager.fileExists(atPath: directory.path) {
            try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
    }
    
    private func loadFromDisk(iconCode: String) -> Data? {
        guard let filePath = cacheDirectory?.appendingPathComponent("\(iconCode).png") else {
            return nil
        }
        return try? Data(contentsOf: filePath)
    }
    
    private func saveToDisk(data: Data, iconCode: String) {
        guard let filePath = cacheDirectory?.appendingPathComponent("\(iconCode).png") else {
            return
        }
        try? data.write(to: filePath)
    }
}

