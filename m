From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 12/12] staging: ccree: remove whitespace before a quoted newline
Date: Thu, 13 Jul 2017 11:20:02 +0300
Message-ID: <1499934004-28513-13-git-send-email-gilad@benyossef.com>
References: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove unnecessary whitespace before a quoted newline in strings.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c |  6 +++---
 drivers/staging/ccree/ssi_hash.c   |  2 +-
 drivers/staging/ccree/ssi_sysfs.c  | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 06e6a89..e09fe03 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -614,14 +614,14 @@ ssi_blkcipher_create_data_desc(
 		break;
 #endif /*SSI_CC_HAS_MULTI2*/
 	default:
-		SSI_LOG_ERR("invalid flow mode, flow_mode = %d \n", flow_mode);
+		SSI_LOG_ERR("invalid flow mode, flow_mode = %d\n", flow_mode);
 		return;
 	}
 	/* Process */
 	if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)) {
-		SSI_LOG_DEBUG(" data params addr %pad length 0x%X \n",
+		SSI_LOG_DEBUG(" data params addr %pad length 0x%X\n",
 			      sg_dma_address(src), nbytes);
-		SSI_LOG_DEBUG(" data params addr %pad length 0x%X \n",
+		SSI_LOG_DEBUG(" data params addr %pad length 0x%X\n",
 			      sg_dma_address(dst), nbytes);
 		hw_desc_init(&desc[*seq_size]);
 		set_din_type(&desc[*seq_size], DMA_DLLI, sg_dma_address(src),
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 11bbbc3..713be20 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1552,7 +1552,7 @@ static int ssi_mac_finup(struct ahash_request *req)
 
 	SSI_LOG_DEBUG("===== finup xcbc(%d) ====\n", req->nbytes);
 	if (state->xcbc_count > 0 && req->nbytes == 0) {
-		SSI_LOG_DEBUG("No data to update. Call to fdx_mac_final \n");
+		SSI_LOG_DEBUG("No data to update. Call to fdx_mac_final\n");
 		return ssi_mac_final(req);
 	}
 
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
index 802fd49..0655658 100644
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ b/drivers/staging/ccree/ssi_sysfs.c
@@ -287,15 +287,15 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
 	int offset = 0;
 
 	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_SIGNATURE));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X  \n", "HOST_SIGNATURE       ", DX_HOST_SIGNATURE_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE       ", DX_HOST_SIGNATURE_REG_OFFSET, register_value);
 	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_IRR));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X  \n", "HOST_IRR             ", DX_HOST_IRR_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_IRR             ", DX_HOST_IRR_REG_OFFSET, register_value);
 	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(HOST_RGF, HOST_POWER_DOWN_EN));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X  \n", "HOST_POWER_DOWN_EN   ", DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_POWER_DOWN_EN   ", DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
 	register_value =  CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, AXIM_MON_ERR));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X  \n", "AXIM_MON_ERR         ", DX_AXIM_MON_ERR_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "AXIM_MON_ERR         ", DX_AXIM_MON_ERR_REG_OFFSET, register_value);
 	register_value = CC_HAL_READ_REGISTER(CC_REG_OFFSET(CRY_KERNEL, DSCRPTR_QUEUE_CONTENT));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X  \n", "DSCRPTR_QUEUE_CONTENT", DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET, register_value);
+	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "DSCRPTR_QUEUE_CONTENT", DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET, register_value);
 	return offset;
 }
 
-- 
2.1.4
