From: Tudor Ambarus <tudor.ambarus@gmail.com>
Subject: [v2 RFC PATCH 1/2] crypto: ecdh: fix concurrency on ecdh_ctx
Date: Wed, 28 Jun 2017 16:55:23 +0300
Message-ID: <1498658124-29780-2-git-send-email-tudor.ambarus@gmail.com>
References: <1498658124-29780-1-git-send-email-tudor.ambarus@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:48363 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdF1Nzk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 09:55:40 -0400
In-Reply-To: <1498658124-29780-1-git-send-email-tudor.ambarus@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tudor Ambarus <tudor.ambarus@microchip.com>

ecdh_ctx contained static allocated data for the shared secret,
for the public and private key.

When talking about shared secret and public key, they were
doomed to concurrency issues because they could be shared by
multiple crypto requests. The requests were generating specific
data to the same zone of memory without any protection.

The private key was subject to concurrency problems because
multiple setkey calls could fight to memcpy to the same zone
of memory.

Shared secret and public key concurrency is fixed by allocating
memory on heap for each request. In the end, the shared secret
and public key are computed for each request, there is no reason
to use shared memory.

Private key concurrency is fixed by allocating memory on heap
for each setkey call, by memcopying the parsed/generated private
key to the heap and by making the private key pointer from
ecdh_ctx to point to the newly allocated data.

On all systems running Linux, loads from and stores to pointers
are atomic, that is, if a store to a pointer occurs at the same
time as a load from that same pointer, the load will return either
the initial value or the value stored, never some bitwise mashup
of the two.

With this, the private key will always point to a valid key,
but to what setkey call it belongs, is the responsibility of the
caller, as it is now in all crypto framework.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecc.h  |  2 --
 crypto/ecdh.c | 96 +++++++++++++++++++++++++++++++++++++++++------------------
 2 files changed, 67 insertions(+), 31 deletions(-)

diff --git a/crypto/ecc.h b/crypto/ecc.h
index e4fd449..b35855b 100644
--- a/crypto/ecc.h
+++ b/crypto/ecc.h
@@ -26,8 +26,6 @@
 #ifndef _CRYPTO_ECC_H
 #define _CRYPTO_ECC_H
 
-#define ECC_MAX_DIGITS	4 /* 256 */
-
 #define ECC_DIGITS_TO_BYTES_SHIFT 3
 
 /**
diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 61c7708..e258ab3 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -19,9 +19,7 @@
 struct ecdh_ctx {
 	unsigned int curve_id;
 	unsigned int ndigits;
-	u64 private_key[ECC_MAX_DIGITS];
-	u64 public_key[2 * ECC_MAX_DIGITS];
-	u64 shared_secret[ECC_MAX_DIGITS];
+	const u64 *private_key;
 };
 
 static inline struct ecdh_ctx *ecdh_get_ctx(struct crypto_kpp *tfm)
@@ -42,8 +40,13 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 			   unsigned int len)
 {
 	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
+	u64 *private_key;
 	struct ecdh params;
 	unsigned int ndigits;
+	int ret;
+
+	/* clear the old private key, if any */
+	kzfree(ctx->private_key);
 
 	if (crypto_ecdh_decode_key(buf, len, &params) < 0)
 		return -EINVAL;
@@ -52,59 +55,92 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	if (!ndigits)
 		return -EINVAL;
 
+	private_key = kmalloc(ndigits << ECC_DIGITS_TO_BYTES_SHIFT, GFP_KERNEL);
+	if (!private_key)
+		return -ENOMEM;
+
 	ctx->curve_id = params.curve_id;
 	ctx->ndigits = ndigits;
 
-	if (!params.key || !params.key_size)
-		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
-				       ctx->private_key);
+	if (!params.key || !params.key_size) {
+		ret = ecc_gen_privkey(ctx->curve_id, ctx->ndigits, private_key);
+		if (ret)
+			goto err;
+		ctx->private_key = private_key;
+		return ret;
+	}
 
-	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
-			     (const u64 *)params.key, params.key_size) < 0)
-		return -EINVAL;
+	ret = ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
+			       (const u64 *)params.key, params.key_size);
+	if (ret < 0)
+		goto err;
 
-	memcpy(ctx->private_key, params.key, params.key_size);
+	memcpy(private_key, params.key, params.key_size);
+	ctx->private_key = private_key;
 
 	return 0;
+err:
+	kzfree(private_key);
+	return ret;
 }
 
 static int ecdh_compute_value(struct kpp_request *req)
 {
-	int ret = 0;
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
-	size_t copied, nbytes;
+	u64 *public_key;
+	u64 *shared_secret = NULL;
 	void *buf;
+	size_t copied, nbytes, public_key_sz;
+	gfp_t gfp;
+	int ret = -ENOMEM;
 
 	nbytes = ctx->ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+	/* Public part is a point thus it has both coordinates */
+	public_key_sz = 2 * nbytes;
+
+	gfp = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL :
+							     GFP_ATOMIC;
+	public_key = kmalloc(public_key_sz, gfp);
+	if (!public_key)
+		return -ENOMEM;
 
 	if (req->src) {
-		copied = sg_copy_to_buffer(req->src, 1, ctx->public_key,
-					   2 * nbytes);
-		if (copied != 2 * nbytes)
-			return -EINVAL;
+		shared_secret = kmalloc(nbytes, gfp);
+		if (!shared_secret)
+			goto free_pubkey;
+
+		copied = sg_copy_to_buffer(req->src, 1, public_key,
+					   public_key_sz);
+		if (copied != public_key_sz) {
+			ret = -EINVAL;
+			goto free_all;
+		}
 
 		ret = crypto_ecdh_shared_secret(ctx->curve_id, ctx->ndigits,
-						ctx->private_key,
-						ctx->public_key,
-						ctx->shared_secret);
+						ctx->private_key, public_key,
+						shared_secret);
 
-		buf = ctx->shared_secret;
+		buf = shared_secret;
 	} else {
 		ret = ecc_make_pub_key(ctx->curve_id, ctx->ndigits,
-				       ctx->private_key, ctx->public_key);
-		buf = ctx->public_key;
-		/* Public part is a point thus it has both coordinates */
-		nbytes *= 2;
+				       ctx->private_key, public_key);
+		buf = public_key;
+		nbytes = public_key_sz;
 	}
 
 	if (ret < 0)
-		return ret;
+		goto free_all;
 
 	copied = sg_copy_from_buffer(req->dst, 1, buf, nbytes);
 	if (copied != nbytes)
-		return -EINVAL;
+		ret = -EINVAL;
 
+	/* fall through */
+free_all:
+	kzfree(shared_secret);
+free_pubkey:
+	kfree(public_key);
 	return ret;
 }
 
@@ -116,9 +152,11 @@ static unsigned int ecdh_max_size(struct crypto_kpp *tfm)
 	return ctx->ndigits << (ECC_DIGITS_TO_BYTES_SHIFT + 1);
 }
 
-static void no_exit_tfm(struct crypto_kpp *tfm)
+static void ecdh_exit_tfm(struct crypto_kpp *tfm)
 {
-	return;
+	struct ecdh_ctx *ctx = ecdh_get_ctx(tfm);
+
+	kzfree(ctx->private_key);
 }
 
 static struct kpp_alg ecdh = {
@@ -126,7 +164,7 @@ static struct kpp_alg ecdh = {
 	.generate_public_key = ecdh_compute_value,
 	.compute_shared_secret = ecdh_compute_value,
 	.max_size = ecdh_max_size,
-	.exit = no_exit_tfm,
+	.exit = ecdh_exit_tfm,
 	.base = {
 		.cra_name = "ecdh",
 		.cra_driver_name = "ecdh-generic",
-- 
2.7.4
