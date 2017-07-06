From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v4 0/5] Introduce AMD Secure Processor device
Date: Thu,  6 Jul 2017 09:59:12 -0500
Message-ID: <20170706145917.98876-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: gary.hook@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, thomas.lendacky@amd.com,
        Brijesh Singh <brijesh.singh@amd.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0058.outbound.protection.outlook.com ([104.47.32.58]:2496
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750922AbdGFO7j (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2017 10:59:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CCP device (drivers/crypto/ccp/ccp.ko) is part of AMD Secure Processor,
which is not dedicated solely to crypto. The AMD Secure Processor includes
CCP and PSP (Platform Secure Processor) devices.

This patch series adds a framework that allows functional component of the
AMD Secure Processor to be initialized and handled appropriately. The series
does not makes any logic modification into CCP - it refactors the code to
integerate CCP into AMD secure processor framework.

---

Changes since v3:
 - guard sp_dev_resume and sp_dev_suspend with CONFIG_PM
 - update Kconfig description for AMD SP device

Changes since v2:
 - move the ccp->io_regs initialization before device setup().
 - maintain the original Kconfig hierarchy
 - rename ccp-{pci,platform}.c -> sp-{pci,platform}.c
 - do not fail the module_init() when ccp device is not found

Changes since v1:
 - remove unused function [sp_get_device()]

Brijesh Singh (5):
  crypto: ccp - Use devres interface to allocate PCI/iomap and cleanup
  crypto: ccp - Introduce the AMD Secure Processor device
  crypto: cpp - Abstract interrupt registeration
  crypto: ccp - rename ccp driver initialize files as sp device
  crypto: ccp - remove ccp_present() check from device initialize

 drivers/crypto/Kconfig            |   6 +-
 drivers/crypto/ccp/Kconfig        |  21 ++-
 drivers/crypto/ccp/Makefile       |   6 +-
 drivers/crypto/ccp/ccp-dev-v3.c   |  17 +-
 drivers/crypto/ccp/ccp-dev-v5.c   |  12 +-
 drivers/crypto/ccp/ccp-dev.c      | 124 ++++++++-----
 drivers/crypto/ccp/ccp-dev.h      |  25 +--
 drivers/crypto/ccp/ccp-pci.c      | 356 --------------------------------------
 drivers/crypto/ccp/ccp-platform.c | 293 -------------------------------
 drivers/crypto/ccp/sp-dev.c       | 277 +++++++++++++++++++++++++++++
 drivers/crypto/ccp/sp-dev.h       | 132 ++++++++++++++
 drivers/crypto/ccp/sp-pci.c       | 276 +++++++++++++++++++++++++++++
 drivers/crypto/ccp/sp-platform.c  | 252 +++++++++++++++++++++++++++
 include/linux/ccp.h               |   7 +-
 14 files changed, 1062 insertions(+), 742 deletions(-)
 delete mode 100644 drivers/crypto/ccp/ccp-pci.c
 delete mode 100644 drivers/crypto/ccp/ccp-platform.c
 create mode 100644 drivers/crypto/ccp/sp-dev.c
 create mode 100644 drivers/crypto/ccp/sp-dev.h
 create mode 100644 drivers/crypto/ccp/sp-pci.c
 create mode 100644 drivers/crypto/ccp/sp-platform.c

-- 
2.9.4
