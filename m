From: Rameshwar Prasad Sahu <rsahu@apm.com>
Subject: [PATCH v2 0/3] dmaengine: Add supports for APM X-Gene SoC CRC32C accerlerator driver
Date: Sat,  7 Nov 2015 22:07:03 +0530
Message-ID: <1446914226-23402-1-git-send-email-rsahu@apm.com>
Cc: linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
	arnd@arndb.de, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	jcm@redhat.com, kgondkar@apm.com, patches@apm.com,
	Rameshwar Prasad Sahu <rsahu@apm.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.137.200.161] ([198.137.200.161]:36799 "EHLO
	denmail01.amcc.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753863AbbKGRLT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Nov 2015 12:11:19 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch implements support for APM X-Gene SoC CRC32C h/w accelerator driver
and adds CRC32C computations support in dmaengine framework. APM X-Gene SoC has
DMA engine capable of performing CRC32C computations.

v2 changes:
	1. Added helper function in dmaengine framework
	2. Documented CRC32C support in Documentations/dmaengine/provider.txt
	3. Fixed algo name
	4. Fixed coding style issues

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
---

Rameshwar Prasad Sahu (3):
  dmaengine: Add support for new feature CRC32C computations
  dmaengine: xgene-dma: Add support for CRC32C computations via DMA
    engine
  Crypto: Add support for APM X-Gene SoC CRC32C h/w accelerator driver

 Documentation/dmaengine/provider.txt |    3 +
 drivers/crypto/Kconfig               |    8 +
 drivers/crypto/Makefile              |    1 +
 drivers/crypto/xgene-crc32c.c        |  234 +++++++++++++++++++++++++
 drivers/dma/dmaengine.c              |    2 +
 drivers/dma/xgene-dma.c              |  314 ++++++++++++++++++++++++++++++++--
 include/linux/dmaengine.h            |   13 ++
 7 files changed, 560 insertions(+), 15 deletions(-)
 create mode 100755 drivers/crypto/xgene-crc32c.c
