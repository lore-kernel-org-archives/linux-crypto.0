From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH 0/3] Introduce AMD Secure Processor device
Date: Thu, 22 Jun 2017 06:42:01 -0500
Message-ID: <20170622114204.4361-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: gary.hook@amd.com, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Brijesh Singh <brijesh.singh@amd.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0054.outbound.protection.outlook.com ([104.47.38.54]:58080
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750852AbdFVLmh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 07:42:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CCP device (drivers/crypto/ccp/ccp.ko) is part of AMD Secure Processor,
which is not dedicated solely to crypto. The AMD Secure Processor includes
CCP and PSP (Platform Secure Processor) devices.

This patch series adds a framework that allows functional component of the
AMD Secure Processor to be initialized and handled appropriately. The series
does not makes any logic modification into CCP - it refactors the code to
integerate CCP into AMD secure processor framework.

Brijesh Singh (3):
  crypto: ccp - Use devres interface to allocate PCI/iomap and cleanup
  crypto: ccp - Introduce the AMD Secure Processor device
  crypto: cpp - Abstract interrupt registeration

 drivers/crypto/Kconfig            |  10 +-
 drivers/crypto/ccp/Kconfig        |  43 ++++--
 drivers/crypto/ccp/Makefile       |   6 +-
 drivers/crypto/ccp/ccp-dev-v3.c   |  17 ++-
 drivers/crypto/ccp/ccp-dev-v5.c   |  12 +-
 drivers/crypto/ccp/ccp-dev.c      | 124 ++++++++++------
 drivers/crypto/ccp/ccp-dev.h      |  19 +--
 drivers/crypto/ccp/ccp-pci.c      | 264 ++++++++++++---------------------
 drivers/crypto/ccp/ccp-platform.c | 165 ++++++++-------------
 drivers/crypto/ccp/sp-dev.c       | 305 ++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sp-dev.h       | 133 +++++++++++++++++
 include/linux/ccp.h               |   3 +-
 12 files changed, 730 insertions(+), 371 deletions(-)
 create mode 100644 drivers/crypto/ccp/sp-dev.c
 create mode 100644 drivers/crypto/ccp/sp-dev.h

-- 
2.9.4
