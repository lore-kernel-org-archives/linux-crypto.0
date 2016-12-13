From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH v2 0/3] Add Support for Cavium Cryptographic Accelerarion Unit
Date: Tue, 13 Dec 2016 14:03:18 +0000
Message-ID: <1481637801-1076-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        "George Cherian" <george.cherian@cavium.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


This series adds the support for Cavium Cryptographic Accelerarion Unit (CPT) 
CPT is available in Cavium's Octeon-Tx SoC series.                            
                                                                              
The series was tested with ecryptfs and dm-crypt for in kernel cryptographic  
offload operations.                                                           

Changes v1 -> v2                                                              
	-- Addressed a crash issue when more gather components are passed.
        -- Redo the cptvf request manager.                                    
   	     - Get rid of the un necessary buffer copies.                  
        -- s/uint*_t/u*                                                
        -- Remove unwanted Macro definitions                           
        -- Remove the redundant ROUNDUP* macros and use kernel function
        -- Select proper config option in Kconfig file.                
        -- Removed some of the unwanted header file inclusions                
        -- Miscellaneous Cleanup 

George Cherian (3):
  drivers: crypto: Add Support for Octeon-tx CPT Engine
  drivers: crypto: Add the Virtual Function driver for CPT
  drivers: crypto: Enable CPT options crypto for build

 drivers/crypto/Kconfig                       |   1 +
 drivers/crypto/Makefile                      |   1 +
 drivers/crypto/cavium/cpt/Kconfig            |  16 +
 drivers/crypto/cavium/cpt/Makefile           |   3 +
 drivers/crypto/cavium/cpt/cpt_common.h       | 166 +++++
 drivers/crypto/cavium/cpt/cpt_hw_types.h     | 736 ++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptpf.h            |  69 ++
 drivers/crypto/cavium/cpt/cptpf_main.c       | 733 ++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptpf_mbox.c       | 163 +++++
 drivers/crypto/cavium/cpt/cptvf.h            | 145 ++++
 drivers/crypto/cavium/cpt/cptvf_algs.c       | 424 ++++++++++++
 drivers/crypto/cavium/cpt/cptvf_algs.h       | 110 +++
 drivers/crypto/cavium/cpt/cptvf_main.c       | 971 +++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptvf_mbox.c       | 205 ++++++
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 581 ++++++++++++++++
 drivers/crypto/cavium/cpt/request_manager.h  | 147 ++++
 16 files changed, 4471 insertions(+)
 create mode 100644 drivers/crypto/cavium/cpt/Kconfig
 create mode 100644 drivers/crypto/cavium/cpt/Makefile
 create mode 100644 drivers/crypto/cavium/cpt/cpt_common.h
 create mode 100644 drivers/crypto/cavium/cpt/cpt_hw_types.h
 create mode 100644 drivers/crypto/cavium/cpt/cptpf.h
 create mode 100644 drivers/crypto/cavium/cpt/cptpf_main.c
 create mode 100644 drivers/crypto/cavium/cpt/cptpf_mbox.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf.h
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_algs.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_algs.h
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_main.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_mbox.c
 create mode 100644 drivers/crypto/cavium/cpt/cptvf_reqmanager.c
 create mode 100644 drivers/crypto/cavium/cpt/request_manager.h

-- 
2.1.4
