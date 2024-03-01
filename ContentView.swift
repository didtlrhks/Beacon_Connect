//
//  ContentView.swift
//  beaconx
//
//  Created by sung yeol yang on 2/29/24.
//

import SwiftUI
import CoreBluetooth
// 블루투스 라이브러리
import MKBeaconXPlus
import Foundation

import Foundation
import Combine
import MKBeaconXPlus


struct ContentView: View {
    // 인스턴스 선언
    //@ObservedObject var beaconViewModel = BeaconViewModel()
    @StateObject var beaconViewModel = BeaconViewModel()
    var body: some View {
        VStack {
            Button(action: {
                beaconViewModel.startScanning()
            }, label: {
                Text("Start Scanning")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
            
//
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // ForEach를 사용하여 배열의 각 항목에 대해 Text 뷰를 생성합니다.
                    ForEach(beaconViewModel.discoveredBeacons, id: \.self) { beacon in
                        VStack(alignment: .leading) {
                            Text("Beacon ID: \(beacon.identifier)")
                            Text("RSSI: \(beacon.rssi)")
                            // 추가적인 비콘 정보를 여기에 표시할 수 있습니다.
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
                  }
        .onAppear {
         //   beaconViewModel.requestBluetoothPermission()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class BeaconViewModel: NSObject, ObservableObject, mk_bxp_centralManagerScanDelegate /*MKBXPCentralManagerDelegate*/ {
    func mk_bxp_receiveBeacon(_ beaconList: [MKBXPBaseBeacon]) {
        //메인쓰레두에서 돌리는거임
        DispatchQueue.main.async { [weak self] in
            // 스캔된 비콘 목록을 self.discoveredBeacons에 할당하려고함
            //그럼이제 계속 ui를 업뎃해줄수있음
            self?.discoveredBeacons = beaconList
        }
    }

    
    // MKBeaconXPlus 중앙 관리자
    private var manager: MKBXPCentralManager!
    
    // 스캔된 비콘을 저장할 배열
    @Published var discoveredBeacons: [MKBXPBaseBeacon] = []
    
    override init() {
        super.init()
        // MKBXPCentralManager의 shared 인스턴스를 가져옵니다.
        manager = MKBXPCentralManager.shared()
        // 이 ViewModel 인스턴스를 델리게이트로 설정합니다.
        manager.delegate = self
    }
    
    // 비콘 스캔을 시작하는 메서드
    func startScanning() {
        manager.startScan()
    }
    
    // 비콘 스캔을 중지하는 메서드
    func stopScanning() {
        manager.stopScan()
    }
    
    // MKBXPCentralManagerDelegate 메서드: 비콘을 발견했을 때 호출됩니다.
    func mk_bxp_centralManagerDidDiscover(_ manager: MKBXPCentralManager, beacon: MKBXPBaseBeacon) {
        // 발견된 비콘을 배열에 추가합니다.
        DispatchQueue.main.async { [weak self] in
            self?.discoveredBeacons.append(beacon)
        }
    }
    
    // MKBXPCentralManagerDelegate 메서드: 스캔이 중지되었을 때 호출됩니다.
    func bxp_centralManagerDidStopScan(_ manager: MKBXPCentralManager) {
        // 필요한 경우 스캔 중지 처리를 여기에 추가합니다.
        // 예를 들어, 사용자에게 상태를 알릴 수 있습니다.
    }
}
 
    



#Preview {
    ContentView()
}


