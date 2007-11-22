From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/11] [CRYPTO] aead: Add givcrypt operation
Date: Thu, 22 Nov 2007 16:49:12 +0800
Message-ID: <E1Iv7kG-00021s-00@gondolin.me.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4697 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751551AbXKVItQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:49:16 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7kH-0008Ev-EG
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:49:13 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] aead: Add givcrypt operation

This patch adds the crypto_aead_givcrypt and associated support elements.
The rationale is identical to that of the block cipher givcrypt operation,
i.e., sometimes only the algorithm knows how the IV should be generated.

The aead_request structure gains two new elements to support this operation.
They are seq and giv.  The seq field should contain a strictly increasing
64-bit integer which may be used by certain IV generators as an input value.
The giv field will be used to store the generated IV.  It does not need to
obey the alignment requirements of the algorithm because it's not used
during the operation.

The existing iv field must still be available as it will be used to store
intermediate IVs and the output IV if chaining is desired.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c          |    1 +
 include/linux/crypto.h |   14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 84a3501..44442ec 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -69,6 +69,7 @@ static int crypto_init_aead_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 
 	crt->setkey = setkey;
 	crt->encrypt = alg->encrypt;
+	crt->givcrypt = alg->givcrypt;
 	crt->decrypt = alg->decrypt;
 	crt->ivsize = alg->ivsize;
 	crt->authsize = alg->authsize;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index cdbd251..9ef5b38 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -134,7 +134,9 @@ struct ablkcipher_request {
  *	@base: Common attributes for async crypto requests
  *	@assoclen: Length in bytes of associated data for authentication
  *	@cryptlen: Length of data to be encrypted or decrypted
- *	@iv: Initialisation vector
+ *	@seq: Sequence number for IV generation
+ *	@giv: Generated IV
+ *	@iv: Input IV for encrypt and Output IV for both encrypt and givcrypt
  *	@assoc: Associated data
  *	@src: Source data
  *	@dst: Destination data
@@ -146,6 +148,9 @@ struct aead_request {
 	unsigned int assoclen;
 	unsigned int cryptlen;
 
+	u64 seq;
+	u8 *giv;
+
 	u8 *iv;
 
 	struct scatterlist *assoc;
@@ -196,6 +201,7 @@ struct aead_alg {
 	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
 	              unsigned int keylen);
 	int (*encrypt)(struct aead_request *req);
+	int (*givcrypt)(struct aead_request *req);
 	int (*decrypt)(struct aead_request *req);
 
 	unsigned int ivsize;
@@ -338,6 +344,7 @@ struct aead_tfm {
 	int (*setkey)(struct crypto_aead *tfm, const u8 *key,
 	              unsigned int keylen);
 	int (*encrypt)(struct aead_request *req);
+	int (*givcrypt)(struct aead_request *req);
 	int (*decrypt)(struct aead_request *req);
 	unsigned int ivsize;
 	unsigned int authsize;
@@ -789,6 +796,11 @@ static inline int crypto_aead_encrypt(struct aead_request *req)
 	return crypto_aead_crt(crypto_aead_reqtfm(req))->encrypt(req);
 }
 
+static inline int crypto_aead_givcrypt(struct aead_request *req)
+{
+	return crypto_aead_crt(crypto_aead_reqtfm(req))->givcrypt(req);
+}
+
 static inline int crypto_aead_decrypt(struct aead_request *req)
 {
 	return crypto_aead_crt(crypto_aead_reqtfm(req))->decrypt(req);
