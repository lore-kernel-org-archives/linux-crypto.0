From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 2/2] crypto: caamhash.c: fix addressing of struct member
Date: Thu, 14 Aug 2014 13:51:57 +0300
Message-ID: <1408013517-15526-3-git-send-email-cristian.stoica@freescale.com>
References: <1408013517-15526-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<davem@davemloft.net>
To: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1408013517-15526-1-git-send-email-cristian.stoica@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

buf_0 and buf_1 in caam_hash_state are not next to each other.
Accessing buf_1 is incorrect from &buf_0 with an offset of only
size_of(buf_0). The same issue is also with buflen_0 and buflen_1

Cc: <stable@vger.kernel.org> # 3.13+
Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 061f3fb..f347ab7 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1417,9 +1417,9 @@ static int ahash_update_first(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
 		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
-	u8 *next_buf = state->buf_0 + state->current_buf *
-		       CAAM_MAX_HASH_BLOCK_SIZE;
-	int *next_buflen = &state->buflen_0 + state->current_buf;
+	u8 *next_buf = state->current_buf ? state->buf_1 : state->buf_0;
+	int *next_buflen = state->current_buf ?
+		&state->buflen_1 : &state->buflen_0;
 	int to_hash;
 	u32 *sh_desc = ctx->sh_desc_update_first, *desc;
 	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
-- 
1.8.3.1
