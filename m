From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v2 0/3] Introduce AMD Secure Processor device
Date: Fri, 23 Jun 2017 11:06:27 -0500
Message-ID: <20170623160630.63292-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: thomas.lendacky@amd.com, gary.hook@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Brijesh Singh <brijesh.singh@amd.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0069.outbound.protection.outlook.com ([104.47.33.69]:49048
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753611AbdFWQGw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Jun 2017 12:06:52 -0400
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

Changes since v1:
 - remove unused function [sp_get_device()]

Brijesh Singh (3):
  crypto: ccp - Use devres interface to allocate PCI/iomap and cleanup
  crypto: ccp - Introduce the AMD Secure Processor device
  crypto: cpp - Abstract interrupt registeration

 drivers/crypto/Kconfig            |  10 +-
 drivers/crypto/ccp/Kconfig        |  43 +++---
 drivers/crypto/ccp/Makefile       |   6 +-
 drivers/crypto/ccp/ccp-dev-v3.c   |  17 ++-
 drivers/crypto/ccp/ccp-dev-v5.c   |  12 +-
 drivers/crypto/ccp/ccp-dev.c      | 124 ++++++++++------
 drivers/crypto/ccp/ccp-dev.h      |  19 +--
 drivers/crypto/ccp/ccp-pci.c      | 264 ++++++++++++-----------------------
 drivers/crypto/ccp/ccp-platform.c | 165 ++++++++--------------
 drivers/crypto/ccp/sp-dev.c       | 287 ++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sp-dev.h       | 133 ++++++++++++++++++
 include/linux/ccp.h               |   3 +-
 12 files changed, 712 insertions(+), 371 deletions(-)
 create mode 100644 drivers/crypto/ccp/sp-dev.c
 create mode 100644 drivers/crypto/ccp/sp-dev.h

-- 
2.9.4
