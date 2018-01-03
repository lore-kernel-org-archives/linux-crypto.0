From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 11/27] stating: ccree: revert "staging: ccree: fix leak of import() after init()"
Date: Wed,  3 Jan 2018 13:35:18 +0000
Message-ID: <1514986544-5888-12-git-send-email-gilad@benyossef.com>
References: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This reverts commit c5f39d07860c ("staging: ccree: fix leak of import()
after init()") and commit aece09024414 ("staging: ccree: Uninitialized
return in ssi_ahash_import()").

This is the wrong solution and ends up relying on uninitialized memory,
although it was not obvious to me at the time.

Cc: stable@vger.kernel.org
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index ffcd1f0..e05c87d 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -1673,7 +1673,7 @@ static int cc_hash_import(struct ahash_request *req, const void *in)
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	u32 tmp;
-	int rc = 0;
+	int rc;
 
 	memcpy(&tmp, in, sizeof(u32));
 	if (tmp != CC_EXPORT_MAGIC) {
@@ -1682,12 +1682,9 @@ static int cc_hash_import(struct ahash_request *req, const void *in)
 	}
 	in += sizeof(u32);
 
-	/* call init() to allocate bufs if the user hasn't */
-	if (!state->digest_buff) {
-		rc = cc_hash_init(req);
-		if (rc)
-			goto out;
-	}
+	rc = cc_hash_init(req);
+	if (rc)
+		goto out;
 
 	dma_sync_single_for_cpu(dev, state->digest_buff_dma_addr,
 				ctx->inter_digestsize, DMA_BIDIRECTIONAL);
-- 
2.7.4
