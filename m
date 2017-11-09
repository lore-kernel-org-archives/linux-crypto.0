From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 09/10] staging: ccree: remove braces for single statement
Date: Thu,  9 Nov 2017 09:16:17 +0000
Message-ID: <1510218980-3549-10-git-send-email-gilad@benyossef.com>
References: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510218980-3549-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove necessary braces for single statement blocks to
improve code readabilty.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 29ef046..bfabb5b 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -1491,9 +1491,8 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
 		/* add the src data to the sg_data */
 		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src, nbytes,
 				0, true, &areq_ctx->mlli_nents);
-		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params))) {
+		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params)))
 			goto fail_unmap_din;
-		}
 	}
 	/* change the buffer index for the unmap function */
 	areq_ctx->buff_index = (areq_ctx->buff_index ^ 1);
@@ -1610,9 +1609,8 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
 		cc_add_sg_entry(dev, &sg_data, areq_ctx->in_nents, src,
 				(update_data_len - *curr_buff_cnt), 0, true,
 				&areq_ctx->mlli_nents);
-		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params))) {
+		if (unlikely(cc_generate_mlli(dev, &sg_data, mlli_params)))
 			goto fail_unmap_din;
-		}
 	}
 	areq_ctx->buff_index = (areq_ctx->buff_index ^ swap_index);
 
-- 
2.7.4
