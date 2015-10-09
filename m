From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH v3 5/5] crypto: marvell: factor out common import functions
Date: Fri, 09 Oct 2015 20:43:54 +0100
Message-ID: <E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:51418 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbbJIToE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 15:44:04 -0400
In-Reply-To: <20151009194309.GA7401@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As all the import functions are virtually identical, factor out their
common parts into a generic mv_cesa_import().  This performs the
actual import, and we pass the data pointers and current length into
this function.

We have to switch a % const operation to do_div() to avoid provoking
gcc to use the expensive 64-bit by 64-bit modulus operation.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 88 +++++++++++--------------------------------
 1 file changed, 21 insertions(+), 67 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index b7c2c05f1a01..4f328b2a3a22 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -822,12 +822,13 @@ static int mv_cesa_md5_export(struct ahash_request *req, void *out)
 	return 0;
 }
 
-static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
+static int mv_cesa_import(struct ahash_request *req, const void *hash, u64 len,
+			  const void *cache)
 {
-	const struct md5_state *in_state = in;
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	unsigned int digsize = crypto_ahash_digestsize(ahash);
+	unsigned int blocksize;
 	unsigned int cache_ptr;
 	int ret;
 
@@ -835,16 +836,17 @@ static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
 	if (ret)
 		return ret;
 
-	if (in_state->byte_count >= sizeof(in_state->block))
+	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(ahash));
+	if (len >= blocksize)
 		mv_cesa_update_op_cfg(&creq->op_tmpl,
 				      CESA_SA_DESC_CFG_MID_FRAG,
 				      CESA_SA_DESC_CFG_FRAG_MSK);
 
-	creq->len = in_state->byte_count;
-	memcpy(creq->state, in_state->hash, digsize);
+	creq->len = len;
+	memcpy(creq->state, hash, digsize);
 	creq->cache_ptr = 0;
 
-	cache_ptr = creq->len % sizeof(in_state->block);
+	cache_ptr = do_div(len, blocksize);
 	if (!cache_ptr)
 		return 0;
 
@@ -852,12 +854,20 @@ static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
 	if (ret)
 		return ret;
 
-	memcpy(creq->cache, in_state->block, cache_ptr);
+	memcpy(creq->cache, cache, cache_ptr);
 	creq->cache_ptr = cache_ptr;
 
 	return 0;
 }
 
+static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
+{
+	const struct md5_state *in_state = in;
+
+	return mv_cesa_import(req, in_state->hash, in_state->byte_count,
+			      in_state->block);
+}
+
 static int mv_cesa_md5_digest(struct ahash_request *req)
 {
 	int ret;
@@ -924,37 +934,9 @@ static int mv_cesa_sha1_export(struct ahash_request *req, void *out)
 static int mv_cesa_sha1_import(struct ahash_request *req, const void *in)
 {
 	const struct sha1_state *in_state = in;
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	unsigned int digsize = crypto_ahash_digestsize(ahash);
-	unsigned int cache_ptr;
-	int ret;
-
-	ret = crypto_ahash_init(req);
-	if (ret)
-		return ret;
-
-	if (in_state->count >= SHA1_BLOCK_SIZE)
-		mv_cesa_update_op_cfg(&creq->op_tmpl,
-				      CESA_SA_DESC_CFG_MID_FRAG,
-				      CESA_SA_DESC_CFG_FRAG_MSK);
 
-	creq->len = in_state->count;
-	memcpy(creq->state, in_state->state, digsize);
-	creq->cache_ptr = 0;
-
-	cache_ptr = creq->len % SHA1_BLOCK_SIZE;
-	if (!cache_ptr)
-		return 0;
-
-	ret = mv_cesa_ahash_alloc_cache(req);
-	if (ret)
-		return ret;
-
-	memcpy(creq->cache, in_state->buffer, cache_ptr);
-	creq->cache_ptr = cache_ptr;
-
-	return 0;
+	return mv_cesa_import(req, in_state->state, in_state->count,
+			      in_state->buffer);
 }
 
 static int mv_cesa_sha1_digest(struct ahash_request *req)
@@ -1034,37 +1016,9 @@ static int mv_cesa_sha256_export(struct ahash_request *req, void *out)
 static int mv_cesa_sha256_import(struct ahash_request *req, const void *in)
 {
 	const struct sha256_state *in_state = in;
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
-	unsigned int digsize = crypto_ahash_digestsize(ahash);
-	unsigned int cache_ptr;
-	int ret;
 
-	ret = crypto_ahash_init(req);
-	if (ret)
-		return ret;
-
-	if (in_state->count >= SHA256_BLOCK_SIZE)
-		mv_cesa_update_op_cfg(&creq->op_tmpl,
-				      CESA_SA_DESC_CFG_MID_FRAG,
-				      CESA_SA_DESC_CFG_FRAG_MSK);
-
-	creq->len = in_state->count;
-	memcpy(creq->state, in_state->state, digsize);
-	creq->cache_ptr = 0;
-
-	cache_ptr = creq->len % SHA256_BLOCK_SIZE;
-	if (!cache_ptr)
-		return 0;
-
-	ret = mv_cesa_ahash_alloc_cache(req);
-	if (ret)
-		return ret;
-
-	memcpy(creq->cache, in_state->buf, cache_ptr);
-	creq->cache_ptr = cache_ptr;
-
-	return 0;
+	return mv_cesa_import(req, in_state->state, in_state->count,
+			      in_state->buf);
 }
 
 struct ahash_alg mv_sha256_alg = {
-- 
2.1.0
