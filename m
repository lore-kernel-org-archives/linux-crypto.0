From: George Cherian <george.cherian@cavium.com>
Subject: [PATCH v6 0/3] Add Support for Cavium Cryptographic Acceleration Unit
Date: Tue, 7 Feb 2017 14:51:12 +0000
Message-ID: <1486479075-1813-1-git-send-email-george.cherian@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <david.daney@cavium.com>, <clabbe.montjoie@gmail.com>,
        <smueller@chronox.de>, <levinsasha928@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        George Cherian <george.cherian@cavium.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0044.outbound.protection.outlook.com ([104.47.32.44]:49760
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753836AbdBGOvl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Feb 2017 09:51:41 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series adds the support for Cavium Cryptographic Accelerarion Unit (CPT) 
CPT is available in Cavium's Octeon-Tx SoC series.                            
                                                                              
The series was tested with ecryptfs and dm-crypt for in kernel cryptographic
offload operations. This driver needs a firmware to work, I will be sending the
firmware to linux-firmware once the driver is accepted.

Cahnges v5 -> v6
	-- Addressed Sasha Levin's comments.
		- Remove open coding of hlist_for_each_entry_safe, instead use
		  the same.
		- Remove the direct access of hlist members
		- Remove unwanted argument checks.
Changes v4 -> v5
	--Addressed Stephan Muller's comments.
		- Fix XTS key sizes.
		- Introduce a new fuction for xts setkey.
		- There was a key2 misalignment issue, the same is also fixed
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

 MAINTAINERS                                  |   7 +
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
 drivers/crypto/cavium/cpt/cptvf_main.c       | 936 +++++++++++++++++++++++++++
 drivers/crypto/cavium/cpt/cptvf_mbox.c       | 211 ++++++
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 593 +++++++++++++++++
 drivers/crypto/cavium/cpt/request_manager.h  | 147 +++++
 17 files changed, 4363 insertions(+)
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
