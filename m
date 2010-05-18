From: David Miller <davem@davemloft.net>
Subject: [PATCH 1/6] hifn_795x: Rename ablkcipher_walk to hifn_cipher_walk.
Date: Mon, 17 May 2010 22:22:31 -0700 (PDT)
Message-ID: <20100517.222231.214217001.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50942
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579Ab0ERFWW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 May 2010 01:22:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is in preparation for the generic ablkcipher_walk helpers that
will be added to the crypto layer.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/crypto/hifn_795x.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 73e8b17..16fce3a 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -638,7 +638,7 @@ struct hifn_crypto_alg
 
 #define ASYNC_FLAGS_MISALIGNED	(1<<0)
 
-struct ablkcipher_walk
+struct hifn_cipher_walk
 {
 	struct scatterlist	cache[ASYNC_SCATTERLIST_CACHE];
 	u32			flags;
@@ -657,7 +657,7 @@ struct hifn_request_context
 	u8			*iv;
 	unsigned int		ivsize;
 	u8			op, type, mode, unused;
-	struct ablkcipher_walk	walk;
+	struct hifn_cipher_walk	walk;
 };
 
 #define crypto_alg_to_hifn(a)	container_of(a, struct hifn_crypto_alg, alg)
@@ -1417,7 +1417,7 @@ static int hifn_setup_dma(struct hifn_device *dev,
 	return 0;
 }
 
-static int ablkcipher_walk_init(struct ablkcipher_walk *w,
+static int hifn_cipher_walk_init(struct hifn_cipher_walk *w,
 		int num, gfp_t gfp_flags)
 {
 	int i;
@@ -1442,7 +1442,7 @@ static int ablkcipher_walk_init(struct ablkcipher_walk *w,
 	return i;
 }
 
-static void ablkcipher_walk_exit(struct ablkcipher_walk *w)
+static void hifn_cipher_walk_exit(struct hifn_cipher_walk *w)
 {
 	int i;
 
@@ -1486,8 +1486,8 @@ static int ablkcipher_add(unsigned int *drestp, struct scatterlist *dst,
 	return idx;
 }
 
-static int ablkcipher_walk(struct ablkcipher_request *req,
-		struct ablkcipher_walk *w)
+static int hifn_cipher_walk(struct ablkcipher_request *req,
+		struct hifn_cipher_walk *w)
 {
 	struct scatterlist *dst, *t;
 	unsigned int nbytes = req->nbytes, offset, copy, diff;
@@ -1600,12 +1600,12 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	}
 
 	if (rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
-		err = ablkcipher_walk_init(&rctx->walk, idx, GFP_ATOMIC);
+		err = hifn_cipher_walk_init(&rctx->walk, idx, GFP_ATOMIC);
 		if (err < 0)
 			return err;
 	}
 
-	sg_num = ablkcipher_walk(req, &rctx->walk);
+	sg_num = hifn_cipher_walk(req, &rctx->walk);
 	if (sg_num < 0) {
 		err = sg_num;
 		goto err_out_exit;
@@ -1806,7 +1806,7 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 			kunmap_atomic(saddr, KM_SOFTIRQ0);
 		}
 
-		ablkcipher_walk_exit(&rctx->walk);
+		hifn_cipher_walk_exit(&rctx->walk);
 	}
 
 	req->base.complete(&req->base, error);
-- 
1.7.0.4
