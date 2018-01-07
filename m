From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 04/27] staging: ccree: remove GFP_DMA flag from mem allocs
Date: Sun,  7 Jan 2018 12:14:15 +0000
Message-ID: <1515327285-8948-5-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
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

Remove bogus GFP_DMA flag from memory allocations. ccree driver
does not operate over an ISA or similar limited bus.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c |  2 +-
 drivers/staging/ccree/ssi_hash.c   | 15 ++++++---------
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 6178d38..496eb19 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -166,7 +166,7 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 	ctx_p->drvdata = cc_alg->drvdata;
 
 	/* Allocate key buffer, cache line aligned */
-	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL | GFP_DMA);
+	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL);
 	if (!ctx_p->user.key)
 		return -ENOMEM;
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 3c28904..f178ffa 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -132,29 +132,27 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 	struct cc_hw_desc desc;
 	int rc = -ENOMEM;
 
-	state->buff0 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
+	state->buff0 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL);
 	if (!state->buff0)
 		goto fail0;
 
-	state->buff1 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL | GFP_DMA);
+	state->buff1 = kzalloc(CC_MAX_HASH_BLCK_SIZE, GFP_KERNEL);
 	if (!state->buff1)
 		goto fail_buff0;
 
 	state->digest_result_buff = kzalloc(CC_MAX_HASH_DIGEST_SIZE,
-					    GFP_KERNEL | GFP_DMA);
+					    GFP_KERNEL);
 	if (!state->digest_result_buff)
 		goto fail_buff1;
 
-	state->digest_buff = kzalloc(ctx->inter_digestsize,
-				     GFP_KERNEL | GFP_DMA);
+	state->digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL);
 	if (!state->digest_buff)
 		goto fail_digest_result_buff;
 
 	dev_dbg(dev, "Allocated digest-buffer in context ctx->digest_buff=@%p\n",
 		state->digest_buff);
 	if (ctx->hw_mode != DRV_CIPHER_XCBC_MAC) {
-		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE,
-						  GFP_KERNEL | GFP_DMA);
+		state->digest_bytes_len = kzalloc(HASH_LEN_SIZE, GFP_KERNEL);
 		if (!state->digest_bytes_len)
 			goto fail1;
 
@@ -164,8 +162,7 @@ static int cc_map_req(struct device *dev, struct ahash_req_ctx *state,
 		state->digest_bytes_len = NULL;
 	}
 
-	state->opad_digest_buff = kzalloc(ctx->inter_digestsize,
-					  GFP_KERNEL | GFP_DMA);
+	state->opad_digest_buff = kzalloc(ctx->inter_digestsize, GFP_KERNEL);
 	if (!state->opad_digest_buff)
 		goto fail2;
 
-- 
2.7.4
