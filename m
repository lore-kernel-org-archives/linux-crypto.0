From: <george.cherian@cavium.com>
Subject: [PATCH v3 0/3] Add Support for Cavium Cryptographic Acceleration Unit
Date: Wed, 21 Dec 2016 11:56:10 +0000
Message-ID: <1482321373-407-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <david.daney@cavium.com>,
        George Cherian <george.cherian@cavium.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0069.outbound.protection.outlook.com ([104.47.34.69]:26048
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753154AbcLUL4l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2016 06:56:41 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: George Cherian <george.cherian@cavium.com>

This series adds the support for Cavium Cryptographic Accelerarion Unit (CPT) 
CPT is available in Cavium's Octeon-Tx SoC series.                            
                                                                              
The series was tested with ecryptfs and dm-crypt for in kernel cryptographic
offload operations. This driver needs a firmware to work, I will be sending the
firmware to linux-firmware once the driver is accepted.

Changes v2 -> v3
	-- Addressed David Daney's comments
		- There is not much difference in performance readq/writeq vs 
	readq_relaxed/writeq_relaxed, so switching to readq/writeq variant.
		- Removed the useless bitfield definitions.
		- Use GENMASK,dev_to_node() instead of custome functions.
		- Use module_pci_driver instead of module_init/exit.
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
 drivers/crypto/cavium/cpt/cpt_common.h       | 158 +++++
 drivers/crypto/cavium/cpt/cpt_hw_types.h     | 658 +++++++++++++++++++
 drivers/crypto/cavium/cpt/cptpf.h            |  69 ++
 drivers/crypto/cavium/cpt/cptpf_main.c       | 703 ++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptpf_mbox.c       | 163 +++++
 drivers/crypto/cavium/cpt/cptvf.h            | 135 ++++
 drivers/crypto/cavium/cpt/cptvf_algs.c       | 424 ++++++++++++
 drivers/crypto/cavium/cpt/cptvf_algs.h       | 110 ++++
 drivers/crypto/cavium/cpt/cptvf_main.c       | 945 +++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptvf_mbox.c       | 205 ++++++
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 581 ++++++++++++++++
 drivers/crypto/cavium/cpt/request_manager.h  | 147 +++++
 16 files changed, 4319 insertions(+)
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
