From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] crypto: cavium: remove dead MSI-X related define
Date: Wed, 15 Feb 2017 08:18:41 +0100
Message-ID: <20170215071843.30108-2-hch@lst.de>
References: <20170215071843.30108-1-hch@lst.de>
Cc: David Daney <david.daney@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170215071843.30108-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/crypto/cavium/cpt/cpt_common.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cpt_common.h b/drivers/crypto/cavium/cpt/cpt_common.h
index ede612f306d3..225078d03773 100644
--- a/drivers/crypto/cavium/cpt/cpt_common.h
+++ b/drivers/crypto/cavium/cpt/cpt_common.h
@@ -20,12 +20,10 @@
 #define CPT_81XX_PCI_VF_DEVICE_ID 0xa041
 
 /* flags to indicate the features supported */
-#define CPT_FLAG_MSIX_ENABLED BIT(0)
 #define CPT_FLAG_SRIOV_ENABLED BIT(1)
 #define CPT_FLAG_VF_DRIVER BIT(2)
 #define CPT_FLAG_DEVICE_READY BIT(3)
 
-#define cpt_msix_enabled(cpt) ((cpt)->flags & CPT_FLAG_MSIX_ENABLED)
 #define cpt_sriov_enabled(cpt) ((cpt)->flags & CPT_FLAG_SRIOV_ENABLED)
 #define cpt_vf_driver(cpt) ((cpt)->flags & CPT_FLAG_VF_DRIVER)
 #define cpt_device_ready(cpt) ((cpt)->flags & CPT_FLAG_DEVICE_READY)
-- 
2.11.0
