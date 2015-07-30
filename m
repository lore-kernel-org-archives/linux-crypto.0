From: Rameshwar Prasad Sahu <rsahu@apm.com>
Subject: [PATCH v1 0/4] dmaengine: Add supports for APM X-Gene SoC CRC32C accerlerator driver
Date: Thu, 30 Jul 2015 17:47:40 +0530
Message-ID: <1438258660-3207-1-git-send-email-rsahu@apm.com>
Cc: linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
	arnd@arndb.de, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	jcm@redhat.com, patches@apm.com,
	Rameshwar Prasad Sahu <rsahu@apm.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:37694 "EHLO
	denmail01.amcc.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338AbbG3MSO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 08:18:14 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch implements support for APM X-Gene SoC CRC32C h/w accelerator driver
and adds CRC32C support in dmaengine framework. APM X-Gene SoC has DMA engine
capable of performing CRC32C.

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
---

Rameshwar Prasad Sahu (4):
  dmaengine: Add support for new feature CRC32C
  dmaengine: xgene-dma: Add support for CRC32C calculation via DMA
    engine
  Crypto: Add support for APM X-Gene SoC CRC32C h/w accelerator driver
  Crypto: tcrypt: Add test case for APM X-Gene SoC CRC32C algo

 crypto/tcrypt.c               |   4 +
 crypto/testmgr.c              |   9 ++
 drivers/crypto/Kconfig        |   8 ++
 drivers/crypto/Makefile       |   1 +
 drivers/crypto/xgene-crc32c.c | 244 ++++++++++++++++++++++++++++++++
 drivers/dma/dmaengine.c       |   2 +
 drivers/dma/xgene-dma.c       | 317 ++++++++++++++++++++++++++++++++++++++++--
 include/linux/dmaengine.h     |   5 +
 8 files changed, 575 insertions(+), 15 deletions(-)
 create mode 100755 drivers/crypto/xgene-crc32c.c

--
1.8.2.1
