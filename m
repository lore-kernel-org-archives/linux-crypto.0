Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6985171D
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 22:29:39 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8E4l-004jEc-AD; Wed, 29 Nov 2023 14:29:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 Nov 2023 14:29:44 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Wed, 29 Nov 2023 14:29:44 +0800
Subject: [PATCH 1/4] crypto: skcipher - Add internal state support
References: <ZWbZEnSPIP5aHydB@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Message-Id: <E1r8E4l-004jEc-AD@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Unlike chaining modes such as CBC, stream ciphers other than CTR
usually hold an internal state that must be preserved if the
operation is to be done piecemeal.  This has not been represented
in the API, resulting in the inability to split up stream cipher
operations.

This patch adds the basic representation of an internal state to
skcipher and lskcipher.  In the interest of backwards compatibility,
the default has been set such that existing users are assumed to
be operating in one go as opposed to piecemeal.

With the new API, each lskcipher/skcipher algorithm has a new
attribute called statesize.  For skcipher, this is the size of
the buffer that can be exported or imported similar to ahash.
For lskcipher, instead of providing a buffer of ivsize, the user
now has to provide a buffer of ivsize + statesize.

Each skcipher operation is assumed to be final as they are now,
but this may be overridden with a request flag.  When the override
occurs, the user may then export the partial state and reimport
it later.

For lskcipher operations this is reversed.  All operations are
not final and the state will be exported unless the FINAL bit is
set.  However, the CONT bit still has to be set for the state
to be used.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/arc4.c             |    2 -
 crypto/cbc.c              |    6 ++--
 crypto/ecb.c              |   10 ++++--
 crypto/lskcipher.c        |   14 +++++----
 include/crypto/skcipher.h |   67 ++++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 84 insertions(+), 15 deletions(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index eb3590dc9282..2150f94e7d03 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -23,7 +23,7 @@ static int crypto_arc4_setkey(struct crypto_lskcipher *tfm, const u8 *in_key,
 }
 
 static int crypto_arc4_crypt(struct crypto_lskcipher *tfm, const u8 *src,
-			     u8 *dst, unsigned nbytes, u8 *iv, bool final)
+			     u8 *dst, unsigned nbytes, u8 *iv, u32 flags)
 {
 	struct arc4_ctx *ctx = crypto_lskcipher_ctx(tfm);
 
diff --git a/crypto/cbc.c b/crypto/cbc.c
index 28345b8d921c..eedddef9ce40 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -51,9 +51,10 @@ static int crypto_cbc_encrypt_inplace(struct crypto_lskcipher *tfm,
 }
 
 static int crypto_cbc_encrypt(struct crypto_lskcipher *tfm, const u8 *src,
-			      u8 *dst, unsigned len, u8 *iv, bool final)
+			      u8 *dst, unsigned len, u8 *iv, u32 flags)
 {
 	struct crypto_lskcipher **ctx = crypto_lskcipher_ctx(tfm);
+	bool final = flags & CRYPTO_LSKCIPHER_FLAG_FINAL;
 	struct crypto_lskcipher *cipher = *ctx;
 	int rem;
 
@@ -119,9 +120,10 @@ static int crypto_cbc_decrypt_inplace(struct crypto_lskcipher *tfm,
 }
 
 static int crypto_cbc_decrypt(struct crypto_lskcipher *tfm, const u8 *src,
-			      u8 *dst, unsigned len, u8 *iv, bool final)
+			      u8 *dst, unsigned len, u8 *iv, u32 flags)
 {
 	struct crypto_lskcipher **ctx = crypto_lskcipher_ctx(tfm);
+	bool final = flags & CRYPTO_LSKCIPHER_FLAG_FINAL;
 	struct crypto_lskcipher *cipher = *ctx;
 	int rem;
 
diff --git a/crypto/ecb.c b/crypto/ecb.c
index cc7625d1a475..e3a67789050e 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -32,22 +32,24 @@ static int crypto_ecb_crypt(struct crypto_cipher *cipher, const u8 *src,
 }
 
 static int crypto_ecb_encrypt2(struct crypto_lskcipher *tfm, const u8 *src,
-			       u8 *dst, unsigned len, u8 *iv, bool final)
+			       u8 *dst, unsigned len, u8 *iv, u32 flags)
 {
 	struct crypto_cipher **ctx = crypto_lskcipher_ctx(tfm);
 	struct crypto_cipher *cipher = *ctx;
 
-	return crypto_ecb_crypt(cipher, src, dst, len, final,
+	return crypto_ecb_crypt(cipher, src, dst, len,
+				flags & CRYPTO_LSKCIPHER_FLAG_FINAL,
 				crypto_cipher_alg(cipher)->cia_encrypt);
 }
 
 static int crypto_ecb_decrypt2(struct crypto_lskcipher *tfm, const u8 *src,
-			       u8 *dst, unsigned len, u8 *iv, bool final)
+			       u8 *dst, unsigned len, u8 *iv, u32 flags)
 {
 	struct crypto_cipher **ctx = crypto_lskcipher_ctx(tfm);
 	struct crypto_cipher *cipher = *ctx;
 
-	return crypto_ecb_crypt(cipher, src, dst, len, final,
+	return crypto_ecb_crypt(cipher, src, dst, len,
+				flags & CRYPTO_LSKCIPHER_FLAG_FINAL,
 				crypto_cipher_alg(cipher)->cia_decrypt);
 }
 
diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index 9edc89730951..51bcf85070c7 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -88,7 +88,7 @@ EXPORT_SYMBOL_GPL(crypto_lskcipher_setkey);
 static int crypto_lskcipher_crypt_unaligned(
 	struct crypto_lskcipher *tfm, const u8 *src, u8 *dst, unsigned len,
 	u8 *iv, int (*crypt)(struct crypto_lskcipher *tfm, const u8 *src,
-			     u8 *dst, unsigned len, u8 *iv, bool final))
+			     u8 *dst, unsigned len, u8 *iv, u32 flags))
 {
 	unsigned ivsize = crypto_lskcipher_ivsize(tfm);
 	unsigned bs = crypto_lskcipher_blocksize(tfm);
@@ -119,7 +119,7 @@ static int crypto_lskcipher_crypt_unaligned(
 			chunk &= ~(cs - 1);
 
 		memcpy(p, src, chunk);
-		err = crypt(tfm, p, p, chunk, tiv, true);
+		err = crypt(tfm, p, p, chunk, tiv, CRYPTO_LSKCIPHER_FLAG_FINAL);
 		if (err)
 			goto out;
 
@@ -143,7 +143,7 @@ static int crypto_lskcipher_crypt(struct crypto_lskcipher *tfm, const u8 *src,
 				  int (*crypt)(struct crypto_lskcipher *tfm,
 					       const u8 *src, u8 *dst,
 					       unsigned len, u8 *iv,
-					       bool final))
+					       u32 flags))
 {
 	unsigned long alignmask = crypto_lskcipher_alignmask(tfm);
 	struct lskcipher_alg *alg = crypto_lskcipher_alg(tfm);
@@ -156,7 +156,7 @@ static int crypto_lskcipher_crypt(struct crypto_lskcipher *tfm, const u8 *src,
 		goto out;
 	}
 
-	ret = crypt(tfm, src, dst, len, iv, true);
+	ret = crypt(tfm, src, dst, len, iv, CRYPTO_LSKCIPHER_FLAG_FINAL);
 
 out:
 	return crypto_lskcipher_errstat(alg, ret);
@@ -198,7 +198,7 @@ static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
 				     int (*crypt)(struct crypto_lskcipher *tfm,
 						  const u8 *src, u8 *dst,
 						  unsigned len, u8 *iv,
-						  bool final))
+						  u32 flags))
 {
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct crypto_lskcipher **ctx = crypto_skcipher_ctx(skcipher);
@@ -210,7 +210,9 @@ static int crypto_lskcipher_crypt_sg(struct skcipher_request *req,
 
 	while (walk.nbytes) {
 		err = crypt(tfm, walk.src.virt.addr, walk.dst.virt.addr,
-			    walk.nbytes, walk.iv, walk.nbytes == walk.total);
+			    walk.nbytes, walk.iv,
+			    walk.nbytes == walk.total ?
+			    CRYPTO_LSKCIPHER_FLAG_FINAL : 0);
 		err = skcipher_walk_done(&walk, err);
 	}
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index ea18af48346b..0cfbe86f957b 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -15,6 +15,17 @@
 #include <linux/string.h>
 #include <linux/types.h>
 
+/* Set this bit if the lskcipher operation is a continuation. */
+#define CRYPTO_LSKCIPHER_FLAG_CONT	0x00000001
+/* Set this bit if the lskcipher operation is final. */
+#define CRYPTO_LSKCIPHER_FLAG_FINAL	0x00000002
+/* The bit CRYPTO_TFM_REQ_MAY_SLEEP can also be set if needed. */
+
+/* Set this bit if the skcipher operation is a continuation. */
+#define CRYPTO_SKCIPHER_REQ_CONT	0x00000001
+/* Set this bit if the skcipher operation is not final. */
+#define CRYPTO_SKCIPHER_REQ_NOTFINAL	0x00000002
+
 struct scatterlist;
 
 /**
@@ -91,6 +102,7 @@ struct crypto_istat_cipher {
  *	    IV of exactly that size to perform the encrypt or decrypt operation.
  * @chunksize: Equal to the block size except for stream ciphers such as
  *	       CTR where it is set to the underlying block size.
+ * @statesize: Size of the internal state for the algorithm.
  * @stat: Statistics for cipher algorithm
  * @base: Definition of a generic crypto algorithm.
  */
@@ -99,6 +111,7 @@ struct crypto_istat_cipher {
 	unsigned int max_keysize;	\
 	unsigned int ivsize;		\
 	unsigned int chunksize;		\
+	unsigned int statesize;		\
 					\
 	SKCIPHER_ALG_COMMON_STAT	\
 					\
@@ -141,6 +154,17 @@ struct skcipher_alg_common SKCIPHER_ALG_COMMON;
  *	     be called in parallel with the same transformation object.
  * @decrypt: Decrypt a single block. This is a reverse counterpart to @encrypt
  *	     and the conditions are exactly the same.
+ * @export: Export partial state of the transformation. This function dumps the
+ *	    entire state of the ongoing transformation into a provided block of
+ *	    data so it can be @import 'ed back later on. This is useful in case
+ *	    you want to save partial result of the transformation after
+ *	    processing certain amount of data and reload this partial result
+ *	    multiple times later on for multiple re-use. No data processing
+ *	    happens at this point.
+ * @import: Import partial state of the transformation. This function loads the
+ *	    entire state of the ongoing transformation from a provided block of
+ *	    data so the transformation can continue from this point onward. No
+ *	    data processing happens at this point.
  * @init: Initialize the cryptographic transformation object. This function
  *	  is used to initialize the cryptographic transformation object.
  *	  This function is called only once at the instantiation time, right
@@ -170,6 +194,8 @@ struct skcipher_alg {
 	              unsigned int keylen);
 	int (*encrypt)(struct skcipher_request *req);
 	int (*decrypt)(struct skcipher_request *req);
+	int (*export)(struct skcipher_request *req, void *out);
+	int (*import)(struct skcipher_request *req, const void *in);
 	int (*init)(struct crypto_skcipher *tfm);
 	void (*exit)(struct crypto_skcipher *tfm);
 
@@ -200,6 +226,9 @@ struct skcipher_alg {
  *	     may be left over if length is not a multiple of blocks
  *	     and there is more to come (final == false).  The number of
  *	     left-over bytes should be returned in case of success.
+ *	     The siv field shall be as long as ivsize + statesize with
+ *	     the IV placed at the front.  The state will be used by the
+ *	     algorithm internally.
  * @decrypt: Decrypt a number of bytes. This is a reverse counterpart to
  *	     @encrypt and the conditions are exactly the same.
  * @init: Initialize the cryptographic transformation object. This function
@@ -215,9 +244,9 @@ struct lskcipher_alg {
 	int (*setkey)(struct crypto_lskcipher *tfm, const u8 *key,
 	              unsigned int keylen);
 	int (*encrypt)(struct crypto_lskcipher *tfm, const u8 *src,
-		       u8 *dst, unsigned len, u8 *iv, bool final);
+		       u8 *dst, unsigned len, u8 *siv, u32 flags);
 	int (*decrypt)(struct crypto_lskcipher *tfm, const u8 *src,
-		       u8 *dst, unsigned len, u8 *iv, bool final);
+		       u8 *dst, unsigned len, u8 *siv, u32 flags);
 	int (*init)(struct crypto_lskcipher *tfm);
 	void (*exit)(struct crypto_lskcipher *tfm);
 
@@ -496,6 +525,40 @@ static inline unsigned int crypto_lskcipher_chunksize(
 	return crypto_lskcipher_alg(tfm)->co.chunksize;
 }
 
+/**
+ * crypto_skcipher_statesize() - obtain state size
+ * @tfm: cipher handle
+ *
+ * Some algorithms cannot be chained with the IV alone.  They carry
+ * internal state which must be replicated if data is to be processed
+ * incrementally.  The size of that state can be obtained with this
+ * function.
+ *
+ * Return: state size in bytes
+ */
+static inline unsigned int crypto_skcipher_statesize(
+	struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg_common(tfm)->statesize;
+}
+
+/**
+ * crypto_lskcipher_statesize() - obtain state size
+ * @tfm: cipher handle
+ *
+ * Some algorithms cannot be chained with the IV alone.  They carry
+ * internal state which must be replicated if data is to be processed
+ * incrementally.  The size of that state can be obtained with this
+ * function.
+ *
+ * Return: state size in bytes
+ */
+static inline unsigned int crypto_lskcipher_statesize(
+	struct crypto_lskcipher *tfm)
+{
+	return crypto_lskcipher_alg(tfm)->co.statesize;
+}
+
 static inline unsigned int crypto_sync_skcipher_blocksize(
 	struct crypto_sync_skcipher *tfm)
 {
