From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH] crypto: ecdh: fix concurrency on shared secret and pubkey
Date: Thu, 20 Jul 2017 10:37:39 +0300
Message-ID: <20170720073739.8680-1-tudor.ambarus@microchip.com>
References: <20170719070421.GA9426@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:20707 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933883AbdGTHib (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jul 2017 03:38:31 -0400
In-Reply-To: <20170719070421.GA9426@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ecdh_ctx contained static allocated data for the shared secret
and public key.

The shared secret and the public key were doomed to concurrency
issues because they could be shared by multiple crypto requests.

The concurrency is fixed by replacing per-tfm shared secret and
public key with per-request dynamically allocated shared secret
and public key.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/ecdh.c | 51 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 61c7708..4271fc7 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -20,8 +20,6 @@ struct ecdh_ctx {
 	unsigned int curve_id;
 	unsigned int ndigits;
 	u64 private_key[ECC_MAX_DIGITS];
-	u64 public_key[2 * ECC_MAX_DIGITS];
-	u64 shared_secret[ECC_MAX_DIGITS];
 };
 
 static inline struct ecdh_ctx *ecdh_get_ctx(struct crypto_kpp *tfm)
@@ -70,41 +68,58 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 
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
+	int ret = -ENOMEM;
 
 	nbytes = ctx->ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
+	/* Public part is a point thus it has both coordinates */
+	public_key_sz = 2 * nbytes;
+
+	public_key = kmalloc(public_key_sz, GFP_KERNEL);
+	if (!public_key)
+		return -ENOMEM;
 
 	if (req->src) {
-		copied = sg_copy_to_buffer(req->src, 1, ctx->public_key,
-					   2 * nbytes);
-		if (copied != 2 * nbytes)
-			return -EINVAL;
+		shared_secret = kmalloc(nbytes, GFP_KERNEL);
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
 
-- 
2.9.4
