//
//  UIView+.swift
//  PhotoPlanner
//
//  Created by Stepan Ostapenko on 17.04.2021.
//

import UIKit

extension UIView {
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor),
            leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor),
        ])
    }
    
    func pinLeft(to superView: UIView, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: CGFloat(const ?? 0)),
        ])
    }
    
    func pinLeft(to anchor: NSLayoutXAxisAnchor, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: anchor, constant: CGFloat(const ?? 0)),
        ])
    }
    
    func pinRight(to superView: UIView, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -CGFloat(const ?? 0)),
        ])
    }
    
    func pinRight(to anchor: NSLayoutXAxisAnchor, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalTo: anchor, constant: -CGFloat(const ?? 0)),
        ])
    }
    
    func pinTop(to superView: UIView, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.topAnchor, constant: CGFloat(const ?? 0)),
        ])
    }
    
    func pinTop(to anchor: NSLayoutYAxisAnchor, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: anchor, constant: CGFloat(const ?? 0)),
        ])
    }
    
    func pinBottom(to superView: UIView, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -CGFloat(const ?? 0)),
        ])
    }
    
    func pinBottom(to anchor: NSLayoutYAxisAnchor, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: anchor, constant: -CGFloat(const ?? 0)),
        ])
    }
    
    func setWidth(to width: Int) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
    }
    
    func setHeight(to width: Int) {
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
    }
    
    func pinWidth(to width: NSLayoutDimension, mult: Double? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthAnchor.constraint(equalTo: width, multiplier: CGFloat(mult ?? 0)).isActive = true
    }
    
    func pinHeight(to width: NSLayoutDimension, mult: Double? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalTo: width, multiplier: CGFloat(mult ?? 0)).isActive = true
    }
    
    func pinCenter(to superView: UIView, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: CGFloat(const ??  0)).isActive = true
        centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: CGFloat(const ??  0)).isActive = true
    }
    
    func pinCenter(to xAnchor: NSLayoutXAxisAnchor, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: xAnchor, constant: CGFloat(const ??  0)).isActive = true
    }
    
    func pinCenter(to yAnchor: NSLayoutYAxisAnchor, const: Int? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: yAnchor, constant: CGFloat(const ??  0)).isActive = true
    }
}
