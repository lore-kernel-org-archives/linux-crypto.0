From: David Miller <davem@davemloft.net>
Subject: [PATCH 6/7] n2_crypto: Make ahash parameterization explicit.
Date: Tue, 25 May 2010 17:43:46 -0700 (PDT)
Message-ID: <20100525.174346.102548117.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37734
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758463Ab0EZAng (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:43:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


All of the ahash ->digest() ops do essentially the same thing, just
using different parameters.

So instead, have a single n2_hash_async_digest() and use an
n2_ahash_alg container that provides the parameters.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/crypto/n2_core.c |  216 +++++++++++++++++++++-------------------------
 1 files changed, 99 insertions(+), 117 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 77939e4..d01a2af 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -239,6 +239,26 @@ static inline bool n2_should_run_async(struct spu_queue *qp, int this_len)
 }
 #endif
 
+struct n2_ahash_alg {
+	struct list_head	entry;
+	const char		*hash_zero;
+	const u32		*hash_init;
+	u8			hw_op_hashsz;
+	u8			digest_size;
+	u8			auth_type;
+	struct ahash_alg	alg;
+};
+
+static inline struct n2_ahash_alg *n2_ahash_alg(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct ahash_alg *ahash_alg;
+
+	ahash_alg = container_of(alg, struct ahash_alg, halg.base);
+
+	return container_of(ahash_alg, struct n2_ahash_alg, alg);
+}
+
 struct n2_hash_ctx {
 	struct crypto_ahash		*fallback_tfm;
 };
@@ -250,9 +270,6 @@ struct n2_hash_req_ctx {
 		struct sha256_state	sha256;
 	} u;
 
-	unsigned char			hash_key[64];
-	unsigned char			keyed_zero_hash[32];
-
 	struct ahash_request		fallback_req;
 };
 
@@ -374,9 +391,9 @@ static unsigned long submit_and_wait_for_tail(struct spu_queue *qp,
 	return hv_ret;
 }
 
-static int n2_hash_async_digest(struct ahash_request *req,
-				unsigned int auth_type, unsigned int digest_size,
-				unsigned int result_size, void *hash_loc)
+static int n2_do_async_digest(struct ahash_request *req,
+			      unsigned int auth_type, unsigned int digest_size,
+			      unsigned int result_size, void *hash_loc)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct cwq_initial_entry *ent;
@@ -462,114 +479,22 @@ out:
 	return err;
 }
 
-static int n2_md5_async_digest(struct ahash_request *req)
-{
-	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
-	struct md5_state *m = &rctx->u.md5;
-
-	if (unlikely(req->nbytes == 0)) {
-		static const char md5_zero[MD5_DIGEST_SIZE] = {
-			0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
-			0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e,
-		};
-
-		memcpy(req->result, md5_zero, MD5_DIGEST_SIZE);
-		return 0;
-	}
-	m->hash[0] = cpu_to_le32(0x67452301);
-	m->hash[1] = cpu_to_le32(0xefcdab89);
-	m->hash[2] = cpu_to_le32(0x98badcfe);
-	m->hash[3] = cpu_to_le32(0x10325476);
-
-	return n2_hash_async_digest(req, AUTH_TYPE_MD5,
-				    MD5_DIGEST_SIZE, MD5_DIGEST_SIZE,
-				    m->hash);
-}
-
-static int n2_sha1_async_digest(struct ahash_request *req)
+static int n2_hash_async_digest(struct ahash_request *req)
 {
+	struct n2_ahash_alg *n2alg = n2_ahash_alg(req->base.tfm);
 	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
-	struct sha1_state *s = &rctx->u.sha1;
+	int ds;
 
+	ds = n2alg->digest_size;
 	if (unlikely(req->nbytes == 0)) {
-		static const char sha1_zero[SHA1_DIGEST_SIZE] = {
-			0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d, 0x32,
-			0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90, 0xaf, 0xd8,
-			0x07, 0x09
-		};
-
-		memcpy(req->result, sha1_zero, SHA1_DIGEST_SIZE);
-		return 0;
-	}
-	s->state[0] = SHA1_H0;
-	s->state[1] = SHA1_H1;
-	s->state[2] = SHA1_H2;
-	s->state[3] = SHA1_H3;
-	s->state[4] = SHA1_H4;
-
-	return n2_hash_async_digest(req, AUTH_TYPE_SHA1,
-				    SHA1_DIGEST_SIZE, SHA1_DIGEST_SIZE,
-				    s->state);
-}
-
-static int n2_sha256_async_digest(struct ahash_request *req)
-{
-	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
-	struct sha256_state *s = &rctx->u.sha256;
-
-	if (req->nbytes == 0) {
-		static const char sha256_zero[SHA256_DIGEST_SIZE] = {
-			0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14, 0x9a,
-			0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24, 0x27, 0xae,
-			0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c, 0xa4, 0x95, 0x99,
-			0x1b, 0x78, 0x52, 0xb8, 0x55
-		};
-
-		memcpy(req->result, sha256_zero, SHA256_DIGEST_SIZE);
-		return 0;
-	}
-	s->state[0] = SHA256_H0;
-	s->state[1] = SHA256_H1;
-	s->state[2] = SHA256_H2;
-	s->state[3] = SHA256_H3;
-	s->state[4] = SHA256_H4;
-	s->state[5] = SHA256_H5;
-	s->state[6] = SHA256_H6;
-	s->state[7] = SHA256_H7;
-
-	return n2_hash_async_digest(req, AUTH_TYPE_SHA256,
-				    SHA256_DIGEST_SIZE, SHA256_DIGEST_SIZE,
-				    s->state);
-}
-
-static int n2_sha224_async_digest(struct ahash_request *req)
-{
-	struct n2_hash_req_ctx *rctx = ahash_request_ctx(req);
-	struct sha256_state *s = &rctx->u.sha256;
-
-	if (req->nbytes == 0) {
-		static const char sha224_zero[SHA224_DIGEST_SIZE] = {
-			0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9, 0x47,
-			0x61, 0x02, 0xbb, 0x28, 0x82, 0x34, 0xc4, 0x15, 0xa2,
-			0xb0, 0x1f, 0x82, 0x8e, 0xa6, 0x2a, 0xc5, 0xb3, 0xe4,
-			0x2f
-		};
-
-		memcpy(req->result, sha224_zero, SHA224_DIGEST_SIZE);
+		memcpy(req->result, n2alg->hash_zero, ds);
 		return 0;
 	}
-	s->state[0] = SHA224_H0;
-	s->state[1] = SHA224_H1;
-	s->state[2] = SHA224_H2;
-	s->state[3] = SHA224_H3;
-	s->state[4] = SHA224_H4;
-	s->state[5] = SHA224_H5;
-	s->state[6] = SHA224_H6;
-	s->state[7] = SHA224_H7;
+	memcpy(&rctx->u, n2alg->hash_init, n2alg->hw_op_hashsz);
 
-	return n2_hash_async_digest(req, AUTH_TYPE_SHA256,
-				    SHA256_DIGEST_SIZE, SHA224_DIGEST_SIZE,
-				    s->state);
+	return n2_do_async_digest(req, n2alg->auth_type,
+				  n2alg->hw_op_hashsz, ds,
+				  &rctx->u);
 }
 
 struct n2_cipher_context {
@@ -1196,34 +1121,85 @@ static LIST_HEAD(cipher_algs);
 
 struct n2_hash_tmpl {
 	const char	*name;
-	int		(*digest)(struct ahash_request *req);
+	const char	*hash_zero;
+	const u32	*hash_init;
+	u8		hw_op_hashsz;
 	u8		digest_size;
 	u8		block_size;
+	u8		auth_type;
+};
+
+static const char md5_zero[MD5_DIGEST_SIZE] = {
+	0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
+	0xe9, 0x80, 0x09, 0x98, 0xec, 0xf8, 0x42, 0x7e,
+};
+static const u32 md5_init[MD5_HASH_WORDS] = {
+	cpu_to_le32(0x67452301),
+	cpu_to_le32(0xefcdab89),
+	cpu_to_le32(0x98badcfe),
+	cpu_to_le32(0x10325476),
+};
+static const char sha1_zero[SHA1_DIGEST_SIZE] = {
+	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d, 0x32,
+	0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90, 0xaf, 0xd8,
+	0x07, 0x09
+};
+static const u32 sha1_init[SHA1_DIGEST_SIZE / 4] = {
+	SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4,
+};
+static const char sha256_zero[SHA256_DIGEST_SIZE] = {
+	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14, 0x9a,
+	0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24, 0x27, 0xae,
+	0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c, 0xa4, 0x95, 0x99,
+	0x1b, 0x78, 0x52, 0xb8, 0x55
+};
+static const u32 sha256_init[SHA256_DIGEST_SIZE / 4] = {
+	SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3,
+	SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7,
+};
+static const char sha224_zero[SHA224_DIGEST_SIZE] = {
+	0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9, 0x47,
+	0x61, 0x02, 0xbb, 0x28, 0x82, 0x34, 0xc4, 0x15, 0xa2,
+	0xb0, 0x1f, 0x82, 0x8e, 0xa6, 0x2a, 0xc5, 0xb3, 0xe4,
+	0x2f
 };
+static const u32 sha224_init[SHA256_DIGEST_SIZE / 4] = {
+	SHA224_H0, SHA224_H1, SHA224_H2, SHA224_H3,
+	SHA224_H4, SHA224_H5, SHA224_H6, SHA224_H7,
+};
+
 static const struct n2_hash_tmpl hash_tmpls[] = {
 	{ .name		= "md5",
-	  .digest	= n2_md5_async_digest,
+	  .hash_zero	= md5_zero,
+	  .hash_init	= md5_init,
+	  .auth_type	= AUTH_TYPE_MD5,
+	  .hw_op_hashsz	= MD5_DIGEST_SIZE,
 	  .digest_size	= MD5_DIGEST_SIZE,
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
 	{ .name		= "sha1",
-	  .digest	= n2_sha1_async_digest,
+	  .hash_zero	= sha1_zero,
+	  .hash_init	= sha1_init,
+	  .auth_type	= AUTH_TYPE_SHA1,
+	  .hw_op_hashsz	= SHA1_DIGEST_SIZE,
 	  .digest_size	= SHA1_DIGEST_SIZE,
 	  .block_size	= SHA1_BLOCK_SIZE },
 	{ .name		= "sha256",
-	  .digest	= n2_sha256_async_digest,
+	  .hash_zero	= sha256_zero,
+	  .hash_init	= sha256_init,
+	  .auth_type	= AUTH_TYPE_SHA256,
+	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA256_DIGEST_SIZE,
 	  .block_size	= SHA256_BLOCK_SIZE },
 	{ .name		= "sha224",
-	  .digest	= n2_sha224_async_digest,
+	  .hash_zero	= sha224_zero,
+	  .hash_init	= sha224_init,
+	  .auth_type	= AUTH_TYPE_SHA256,
+	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA224_DIGEST_SIZE,
 	  .block_size	= SHA224_BLOCK_SIZE },
 };
 #define NUM_HASH_TMPLS ARRAY_SIZE(hash_tmpls)
 
-struct n2_ahash_alg {
-	struct list_head	entry;
-	struct ahash_alg	alg;
-};
 static LIST_HEAD(ahash_algs);
 
 static int algs_registered;
@@ -1297,12 +1273,18 @@ static int __devinit __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 	if (!p)
 		return -ENOMEM;
 
+	p->hash_zero = tmpl->hash_zero;
+	p->hash_init = tmpl->hash_init;
+	p->auth_type = tmpl->auth_type;
+	p->hw_op_hashsz = tmpl->hw_op_hashsz;
+	p->digest_size = tmpl->digest_size;
+
 	ahash = &p->alg;
 	ahash->init = n2_hash_async_init;
 	ahash->update = n2_hash_async_update;
 	ahash->final = n2_hash_async_final;
 	ahash->finup = n2_hash_async_finup;
-	ahash->digest = tmpl->digest;
+	ahash->digest = n2_hash_async_digest;
 
 	halg = &ahash->halg;
 	halg->digestsize = tmpl->digest_size;
-- 
1.7.0.4
