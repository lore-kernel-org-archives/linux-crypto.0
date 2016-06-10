From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 2/4] crypto: DRBG - use aligned buffers
Date: Fri, 10 Jun 2016 07:56:57 +0200
Message-ID: <1525370.lyuSIsxrou@positron.chronox.de>
References: <3932580.AnntHTzK82@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36230 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbcFJF7T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jun 2016 01:59:19 -0400
In-Reply-To: <3932580.AnntHTzK82@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hardware cipher implementation may require aligned buffers. All buffers
that potentially are processed with a cipher are now aligned.

At the time of the allocation of the memory, we have not yet allocated
the cipher implementations. Hence, we cannot obtain the alignmask for
the used cipher yet. Therefore, the DRBG code uses an alignment which
should satisfy all cipher implementations.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 25 +++++++++++++++----------
 include/crypto/drbg.h |  3 +++
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 4ee1a9c..0ac2f19 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1139,11 +1139,11 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	if (!drbg)
 		return;
 	kzfree(drbg->V);
-	drbg->V = NULL;
+	drbg->Vbuf = NULL;
 	kzfree(drbg->C);
-	drbg->C = NULL;
-	kzfree(drbg->scratchpad);
-	drbg->scratchpad = NULL;
+	drbg->Cbuf = NULL;
+	kzfree(drbg->scratchpadbuf);
+	drbg->scratchpadbuf = NULL;
 	drbg->reseed_ctr = 0;
 	drbg->d_ops = NULL;
 	drbg->core = NULL;
@@ -1157,6 +1157,8 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 {
 	int ret = -ENOMEM;
 	unsigned int sb_size = 0;
+/* Alignmask which should cover all cipher implementations */
+#define DRBG_ALIGN 8
 
 	switch (drbg->core->flags & DRBG_TYPE_MASK) {
 #ifdef CONFIG_CRYPTO_DRBG_HMAC
@@ -1179,12 +1181,14 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		goto err;
 	}
 
-	drbg->V = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
-	if (!drbg->V)
+	drbg->Vbuf = kmalloc(drbg_statelen(drbg) + DRBG_ALIGN, GFP_KERNEL);
+	if (!drbg->Vbuf)
 		goto err;
-	drbg->C = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
-	if (!drbg->C)
+	drbg->V = PTR_ALIGN(drbg->Vbuf, DRBG_ALIGN);
+	drbg->Cbuf = kmalloc(drbg_statelen(drbg) + DRBG_ALIGN, GFP_KERNEL);
+	if (!drbg->Cbuf)
 		goto err;
+	drbg->C = PTR_ALIGN(drbg->Cbuf, DRBG_ALIGN);
 	/* scratchpad is only generated for CTR and Hash */
 	if (drbg->core->flags & DRBG_HMAC)
 		sb_size = 0;
@@ -1198,9 +1202,10 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		sb_size = drbg_statelen(drbg) + drbg_blocklen(drbg);
 
 	if (0 < sb_size) {
-		drbg->scratchpad = kzalloc(sb_size, GFP_KERNEL);
-		if (!drbg->scratchpad)
+		drbg->scratchpadbuf = kzalloc(sb_size + DRBG_ALIGN, GFP_KERNEL);
+		if (!drbg->scratchpadbuf)
 			goto err;
+		drbg->scratchpad = PTR_ALIGN(drbg->scratchpadbuf, DRBG_ALIGN);
 	}
 
 	return 0;
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index b2fe15d..61580b1 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -108,13 +108,16 @@ struct drbg_test_data {
 struct drbg_state {
 	struct mutex drbg_mutex;	/* lock around DRBG */
 	unsigned char *V;	/* internal state 10.1.1.1 1a) */
+	unsigned char *Vbuf;
 	/* hash: static value 10.1.1.1 1b) hmac / ctr: key */
 	unsigned char *C;
+	unsigned char *Cbuf;
 	/* Number of RNG requests since last reseed -- 10.1.1.1 1c) */
 	size_t reseed_ctr;
 	size_t reseed_threshold;
 	 /* some memory the DRBG can use for its operation */
 	unsigned char *scratchpad;
+	unsigned char *scratchpadbuf;
 	void *priv_data;	/* Cipher handle */
 
 	struct crypto_skcipher *ctr_handle;	/* CTR mode cipher handle */
-- 
2.5.5
