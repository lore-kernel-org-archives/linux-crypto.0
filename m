From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH v5 0/3] Add Support for Cavium Cryptographic Acceleration Unit
Date: Mon, 30 Jan 2017 12:30:41 +0000
Message-ID: <1485779444-4332-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <david.daney@cavium.com>, <clabbe.montjoie@gmail.com>,
        <smueller@chronox.de>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>,
        George Cherian <george.cherian@cavium.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0055.outbound.protection.outlook.com ([104.47.36.55]:17959
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752845AbdA3MbM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2017 07:31:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series adds the support for Cavium Cryptographic Accelerarion Unit (CPT) 
CPT is available in Cavium's Octeon-Tx SoC series.                            
                                                                              
The series was tested with ecryptfs and dm-crypt for in kernel cryptographic
offload operations. This driver needs a firmware to work, I will be sending the
firmware to linux-firmware once the driver is accepted.

Changes v4 -> v5
	--Addressed Stephan Muller's comments.
		- Fix XTS key sizes.
		- Introduce a new fuction for xts setkey.
		- There was a key2 misalignment issue, the same is alos fixed
		  for aes_xts.
Changes v3 -> v4
	--Addressed Corentin Labbe's comments
		- Convert all pr_x to dev_x.
		- Fix Typo errors.
		- Fix the Double unlock.
		- Use sg_virt.
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
 drivers/crypto/cavium/cpt/cptpf_main.c       | 708 ++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptpf_mbox.c       | 163 +++++
 drivers/crypto/cavium/cpt/cptvf.h            | 135 ++++
 drivers/crypto/cavium/cpt/cptvf_algs.c       | 444 +++++++++++++
 drivers/crypto/cavium/cpt/cptvf_algs.h       | 113 ++++
 drivers/crypto/cavium/cpt/cptvf_main.c       | 948 +++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptvf_mbox.c       | 211 ++++++
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 593 +++++++++++++++++
 drivers/crypto/cavium/cpt/request_manager.h  | 147 +++++
 16 files changed, 4368 insertions(+)
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
