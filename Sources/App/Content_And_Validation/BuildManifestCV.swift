//
//  File.swift
//  
//
//  Created by Syed Qamar Abbas on 19/04/2021.
//

import Vapor
import Fluent

let plistTemp = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>items</key>
    <array>
        <dict>
            <key>assets</key>
            <array>
                <dict>
                    <key>kind</key>
                    <string>software-package</string>
                    <key>url</key>
                    <string>_IPA_URL_</string>
                </dict>
            </array>
            <key>metadata</key>
            <dict>
                <key>bundle-identifier</key>
                <string>_BUNDLE_ID_</string>
                <key>bundle-version</key>
                <string>_VERSION_</string>
                <key>kind</key>
                <string>software</string>
                <key>release-notes</key>
                <string>_RELEASE_NOTES_</string>
                <key>title</key>
                <string>_TITLE_</string>
            </dict>
        </dict>
    </array>
</dict>
</plist>
"""
extension Build {
    struct BuildManifest: Content {
        var manifest: Build.Manifest
        var build: Build?
        
        func plist() -> String {
            if let b = build {
                var plistStr = plistTemp
                plistStr.replace(str: "_IPA_URL_", with: manifest.url)
                plistStr.replace(str: "_RELEASE_NOTES_", with: b.release_notes)
                plistStr.replace(str: "_VERSION_", with: manifest.version)
                plistStr.replace(str: "_TITLE_", with: manifest.title)
                plistStr.replace(str: "_BUNDLE_ID_", with: manifest.bundle)
                return plistStr
            }
            return ""
        }
    }
}
