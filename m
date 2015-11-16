From: rsahu@apm.com
Subject: [PATCH v2 0/3] dmaengine: Add supports for APM X-Gene SoC CRC32C accerlerator driver
Date: Mon, 16 Nov 2015 14:42:46 +0530
Message-ID: <1447665169-14003-1-git-send-email-rsahu@apm.com>
References: <rsahu@apm.com>
Cc: dmaengine@vger.kernel.org, arnd@arndb.de,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
	patches@apm.com, linux-crypto@vger.kernel.org,
	Rameshwar Prasad Sahu <rsahu@apm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	vinod.koul@intel.com, dan.j.williams@intel.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <rsahu@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rameshwar Prasad Sahu <rsahu@apm.com>

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
