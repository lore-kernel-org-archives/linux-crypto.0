From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 8/8] staging: ccree: remove braces for single statement
Date: Tue,  7 Nov 2017 09:40:04 +0000
Message-ID: <1510047606-5589-9-git-send-email-gilad@benyossef.com>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Remove necessary braces for single statement blocks to
improve code readabilty.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 838e973..3418c64 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -1490,9 +1490,8 @@ int cc_map_hash_request_final(struct ssi_drvdata *drvdata, void *ctx,
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
@@ -1609,9 +1608,8 @@ int cc_map_hash_request_update(struct ssi_drvdata *drvdata, void *ctx,
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
