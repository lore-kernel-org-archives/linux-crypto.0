From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 2/2] crypto: testmgr - constify all test vectors
Date: Fri, 24 Feb 2017 15:46:59 -0800
Message-ID: <20170224234659.89423-3-ebiggers3@gmail.com>
References: <20170224234659.89423-1-ebiggers3@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170224234659.89423-1-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Cryptographic test vectors should never be modified, so constify them to
enforce this at both compile-time and run-time.  This moves a significant
amount of data from .data to .rodata when the crypto tests are enabled.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c |  71 ++++----
 crypto/testmgr.h | 512 +++++++++++++++++++++++++++----------------------------
 2 files changed, 297 insertions(+), 286 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f9c378af3907..89f1dd1f4b13 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -83,47 +83,47 @@ struct tcrypt_result {
 
 struct aead_test_suite {
 	struct {
-		struct aead_testvec *vecs;
+		const struct aead_testvec *vecs;
 		unsigned int count;
 	} enc, dec;
 };
 
 struct cipher_test_suite {
 	struct {
-		struct cipher_testvec *vecs;
+		const struct cipher_testvec *vecs;
 		unsigned int count;
 	} enc, dec;
 };
 
 struct comp_test_suite {
 	struct {
-		struct comp_testvec *vecs;
+		const struct comp_testvec *vecs;
 		unsigned int count;
 	} comp, decomp;
 };
 
 struct hash_test_suite {
-	struct hash_testvec *vecs;
+	const struct hash_testvec *vecs;
 	unsigned int count;
 };
 
 struct cprng_test_suite {
-	struct cprng_testvec *vecs;
+	const struct cprng_testvec *vecs;
 	unsigned int count;
 };
 
 struct drbg_test_suite {
-	struct drbg_testvec *vecs;
+	const struct drbg_testvec *vecs;
 	unsigned int count;
 };
 
 struct akcipher_test_suite {
-	struct akcipher_testvec *vecs;
+	const struct akcipher_testvec *vecs;
 	unsigned int count;
 };
 
 struct kpp_test_suite {
-	struct kpp_testvec *vecs;
+	const struct kpp_testvec *vecs;
 	unsigned int count;
 };
 
@@ -145,7 +145,8 @@ struct alg_test_desc {
 	} suite;
 };
 
-static unsigned int IDX[8] = { IDX1, IDX2, IDX3, IDX4, IDX5, IDX6, IDX7, IDX8 };
+static const unsigned int IDX[8] = {
+	IDX1, IDX2, IDX3, IDX4, IDX5, IDX6, IDX7, IDX8 };
 
 static void hexdump(unsigned char *buf, unsigned int len)
 {
@@ -203,7 +204,7 @@ static int wait_async_op(struct tcrypt_result *tr, int ret)
 }
 
 static int ahash_partial_update(struct ahash_request **preq,
-	struct crypto_ahash *tfm, struct hash_testvec *template,
+	struct crypto_ahash *tfm, const struct hash_testvec *template,
 	void *hash_buff, int k, int temp, struct scatterlist *sg,
 	const char *algo, char *result, struct tcrypt_result *tresult)
 {
@@ -260,9 +261,9 @@ static int ahash_partial_update(struct ahash_request **preq,
 	return ret;
 }
 
-static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
-		       unsigned int tcount, bool use_digest,
-		       const int align_offset)
+static int __test_hash(struct crypto_ahash *tfm,
+		       const struct hash_testvec *template, unsigned int tcount,
+		       bool use_digest, const int align_offset)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_ahash_tfm(tfm));
 	size_t digest_size = crypto_ahash_digestsize(tfm);
@@ -538,7 +539,8 @@ static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 	return ret;
 }
 
-static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
+static int test_hash(struct crypto_ahash *tfm,
+		     const struct hash_testvec *template,
 		     unsigned int tcount, bool use_digest)
 {
 	unsigned int alignmask;
@@ -566,7 +568,7 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 }
 
 static int __test_aead(struct crypto_aead *tfm, int enc,
-		       struct aead_testvec *template, unsigned int tcount,
+		       const struct aead_testvec *template, unsigned int tcount,
 		       const bool diff_dst, const int align_offset)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_aead_tfm(tfm));
@@ -957,7 +959,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 }
 
 static int test_aead(struct crypto_aead *tfm, int enc,
-		     struct aead_testvec *template, unsigned int tcount)
+		     const struct aead_testvec *template, unsigned int tcount)
 {
 	unsigned int alignmask;
 	int ret;
@@ -990,7 +992,8 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 }
 
 static int test_cipher(struct crypto_cipher *tfm, int enc,
-		       struct cipher_testvec *template, unsigned int tcount)
+		       const struct cipher_testvec *template,
+		       unsigned int tcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_cipher_tfm(tfm));
 	unsigned int i, j, k;
@@ -1068,7 +1071,8 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 }
 
 static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
-			   struct cipher_testvec *template, unsigned int tcount,
+			   const struct cipher_testvec *template,
+			   unsigned int tcount,
 			   const bool diff_dst, const int align_offset)
 {
 	const char *algo =
@@ -1332,7 +1336,8 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 }
 
 static int test_skcipher(struct crypto_skcipher *tfm, int enc,
-			 struct cipher_testvec *template, unsigned int tcount)
+			 const struct cipher_testvec *template,
+			 unsigned int tcount)
 {
 	unsigned int alignmask;
 	int ret;
@@ -1364,8 +1369,10 @@ static int test_skcipher(struct crypto_skcipher *tfm, int enc,
 	return 0;
 }
 
-static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
-		     struct comp_testvec *dtemplate, int ctcount, int dtcount)
+static int test_comp(struct crypto_comp *tfm,
+		     const struct comp_testvec *ctemplate,
+		     const struct comp_testvec *dtemplate,
+		     int ctcount, int dtcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_comp_tfm(tfm));
 	unsigned int i;
@@ -1444,8 +1451,10 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 	return ret;
 }
 
-static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
-		      struct comp_testvec *dtemplate, int ctcount, int dtcount)
+static int test_acomp(struct crypto_acomp *tfm,
+		      const struct comp_testvec *ctemplate,
+		      const struct comp_testvec *dtemplate,
+		      int ctcount, int dtcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm));
 	unsigned int i;
@@ -1588,7 +1597,8 @@ static int test_acomp(struct crypto_acomp *tfm, struct comp_testvec *ctemplate,
 	return ret;
 }
 
-static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
+static int test_cprng(struct crypto_rng *tfm,
+		      const struct cprng_testvec *template,
 		      unsigned int tcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
@@ -1865,7 +1875,7 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 }
 
 
-static int drbg_cavs_test(struct drbg_testvec *test, int pr,
+static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 			  const char *driver, u32 type, u32 mask)
 {
 	int ret = -EAGAIN;
@@ -1939,7 +1949,7 @@ static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 	int err = 0;
 	int pr = 0;
 	int i = 0;
-	struct drbg_testvec *template = desc->suite.drbg.vecs;
+	const struct drbg_testvec *template = desc->suite.drbg.vecs;
 	unsigned int tcount = desc->suite.drbg.count;
 
 	if (0 == memcmp(driver, "drbg_pr_", 8))
@@ -1958,7 +1968,7 @@ static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 
 }
 
-static int do_test_kpp(struct crypto_kpp *tfm, struct kpp_testvec *vec,
+static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 		       const char *alg)
 {
 	struct kpp_request *req;
@@ -2050,7 +2060,7 @@ static int do_test_kpp(struct crypto_kpp *tfm, struct kpp_testvec *vec,
 }
 
 static int test_kpp(struct crypto_kpp *tfm, const char *alg,
-		    struct kpp_testvec *vecs, unsigned int tcount)
+		    const struct kpp_testvec *vecs, unsigned int tcount)
 {
 	int ret, i;
 
@@ -2086,7 +2096,7 @@ static int alg_test_kpp(const struct alg_test_desc *desc, const char *driver,
 }
 
 static int test_akcipher_one(struct crypto_akcipher *tfm,
-			     struct akcipher_testvec *vecs)
+			     const struct akcipher_testvec *vecs)
 {
 	char *xbuf[XBUFSIZE];
 	struct akcipher_request *req;
@@ -2206,7 +2216,8 @@ static int test_akcipher_one(struct crypto_akcipher *tfm,
 }
 
 static int test_akcipher(struct crypto_akcipher *tfm, const char *alg,
-			 struct akcipher_testvec *vecs, unsigned int tcount)
+			 const struct akcipher_testvec *vecs,
+			 unsigned int tcount)
 {
 	const char *algo =
 		crypto_tfm_alg_driver_name(crypto_akcipher_tfm(tfm));
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index f85e51cf7dcc..2070f933323e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -34,9 +34,9 @@
 
 struct hash_testvec {
 	/* only used with keyed hash algorithms */
-	char *key;
-	char *plaintext;
-	char *digest;
+	const char *key;
+	const char *plaintext;
+	const char *digest;
 	unsigned char tap[MAX_TAP];
 	unsigned short psize;
 	unsigned char np;
@@ -63,11 +63,11 @@ struct hash_testvec {
  */
 
 struct cipher_testvec {
-	char *key;
-	char *iv;
-	char *iv_out;
-	char *input;
-	char *result;
+	const char *key;
+	const char *iv;
+	const char *iv_out;
+	const char *input;
+	const char *result;
 	unsigned short tap[MAX_TAP];
 	int np;
 	unsigned char also_non_np;
@@ -80,11 +80,11 @@ struct cipher_testvec {
 };
 
 struct aead_testvec {
-	char *key;
-	char *iv;
-	char *input;
-	char *assoc;
-	char *result;
+	const char *key;
+	const char *iv;
+	const char *input;
+	const char *assoc;
+	const char *result;
 	unsigned char tap[MAX_TAP];
 	unsigned char atap[MAX_TAP];
 	int np;
@@ -99,10 +99,10 @@ struct aead_testvec {
 };
 
 struct cprng_testvec {
-	char *key;
-	char *dt;
-	char *v;
-	char *result;
+	const char *key;
+	const char *dt;
+	const char *v;
+	const char *result;
 	unsigned char klen;
 	unsigned short dtlen;
 	unsigned short vlen;
@@ -111,24 +111,24 @@ struct cprng_testvec {
 };
 
 struct drbg_testvec {
-	unsigned char *entropy;
+	const unsigned char *entropy;
 	size_t entropylen;
-	unsigned char *entpra;
-	unsigned char *entprb;
+	const unsigned char *entpra;
+	const unsigned char *entprb;
 	size_t entprlen;
-	unsigned char *addtla;
-	unsigned char *addtlb;
+	const unsigned char *addtla;
+	const unsigned char *addtlb;
 	size_t addtllen;
-	unsigned char *pers;
+	const unsigned char *pers;
 	size_t perslen;
-	unsigned char *expected;
+	const unsigned char *expected;
 	size_t expectedlen;
 };
 
 struct akcipher_testvec {
-	unsigned char *key;
-	unsigned char *m;
-	unsigned char *c;
+	const unsigned char *key;
+	const unsigned char *m;
+	const unsigned char *c;
 	unsigned int key_len;
 	unsigned int m_size;
 	unsigned int c_size;
@@ -136,22 +136,22 @@ struct akcipher_testvec {
 };
 
 struct kpp_testvec {
-	unsigned char *secret;
-	unsigned char *b_public;
-	unsigned char *expected_a_public;
-	unsigned char *expected_ss;
+	const unsigned char *secret;
+	const unsigned char *b_public;
+	const unsigned char *expected_a_public;
+	const unsigned char *expected_ss;
 	unsigned short secret_size;
 	unsigned short b_public_size;
 	unsigned short expected_a_public_size;
 	unsigned short expected_ss_size;
 };
 
-static char zeroed_string[48];
+static const char zeroed_string[48];
 
 /*
  * RSA test vectors. Borrowed from openSSL.
  */
-static struct akcipher_testvec rsa_tv_template[] = {
+static const struct akcipher_testvec rsa_tv_template[] = {
 	{
 #ifndef CONFIG_CRYPTO_FIPS
 	.key =
@@ -538,7 +538,7 @@ static struct akcipher_testvec rsa_tv_template[] = {
 	}
 };
 
-struct kpp_testvec dh_tv_template[] = {
+static const struct kpp_testvec dh_tv_template[] = {
 	{
 	.secret =
 #ifdef __LITTLE_ENDIAN
@@ -755,7 +755,7 @@ struct kpp_testvec dh_tv_template[] = {
 	}
 };
 
-struct kpp_testvec ecdh_tv_template[] = {
+static const struct kpp_testvec ecdh_tv_template[] = {
 	{
 #ifndef CONFIG_CRYPTO_FIPS
 	.secret =
@@ -846,7 +846,7 @@ struct kpp_testvec ecdh_tv_template[] = {
 /*
  * MD4 test vectors from RFC1320
  */
-static struct hash_testvec md4_tv_template [] = {
+static const struct hash_testvec md4_tv_template[] = {
 	{
 		.plaintext = "",
 		.digest	= "\x31\xd6\xcf\xe0\xd1\x6a\xe9\x31"
@@ -887,7 +887,7 @@ static struct hash_testvec md4_tv_template [] = {
 	},
 };
 
-static struct hash_testvec sha3_224_tv_template[] = {
+static const struct hash_testvec sha3_224_tv_template[] = {
 	{
 		.plaintext = "",
 		.digest	= "\x6b\x4e\x03\x42\x36\x67\xdb\xb7"
@@ -912,7 +912,7 @@ static struct hash_testvec sha3_224_tv_template[] = {
 	},
 };
 
-static struct hash_testvec sha3_256_tv_template[] = {
+static const struct hash_testvec sha3_256_tv_template[] = {
 	{
 		.plaintext = "",
 		.digest	= "\xa7\xff\xc6\xf8\xbf\x1e\xd7\x66"
@@ -938,7 +938,7 @@ static struct hash_testvec sha3_256_tv_template[] = {
 };
 
 
-static struct hash_testvec sha3_384_tv_template[] = {
+static const struct hash_testvec sha3_384_tv_template[] = {
 	{
 		.plaintext = "",
 		.digest	= "\x0c\x63\xa7\x5b\x84\x5e\x4f\x7d"
@@ -970,7 +970,7 @@ static struct hash_testvec sha3_384_tv_template[] = {
 };
 
 
-static struct hash_testvec sha3_512_tv_template[] = {
+static const struct hash_testvec sha3_512_tv_template[] = {
 	{
 		.plaintext = "",
 		.digest	= "\xa6\x9f\x73\xcc\xa2\x3a\x9a\xc5"
@@ -1011,7 +1011,7 @@ static struct hash_testvec sha3_512_tv_template[] = {
 /*
  * MD5 test vectors from RFC1321
  */
-static struct hash_testvec md5_tv_template[] = {
+static const struct hash_testvec md5_tv_template[] = {
 	{
 		.digest	= "\xd4\x1d\x8c\xd9\x8f\x00\xb2\x04"
 			  "\xe9\x80\x09\x98\xec\xf8\x42\x7e",
@@ -1055,7 +1055,7 @@ static struct hash_testvec md5_tv_template[] = {
 /*
  * RIPEMD-128 test vectors from ISO/IEC 10118-3:2004(E)
  */
-static struct hash_testvec rmd128_tv_template[] = {
+static const struct hash_testvec rmd128_tv_template[] = {
 	{
 		.digest	= "\xcd\xf2\x62\x13\xa1\x50\xdc\x3e"
 			  "\xcb\x61\x0f\x18\xf6\xb3\x8b\x46",
@@ -1117,7 +1117,7 @@ static struct hash_testvec rmd128_tv_template[] = {
 /*
  * RIPEMD-160 test vectors from ISO/IEC 10118-3:2004(E)
  */
-static struct hash_testvec rmd160_tv_template[] = {
+static const struct hash_testvec rmd160_tv_template[] = {
 	{
 		.digest	= "\x9c\x11\x85\xa5\xc5\xe9\xfc\x54\x61\x28"
 			  "\x08\x97\x7e\xe8\xf5\x48\xb2\x25\x8d\x31",
@@ -1179,7 +1179,7 @@ static struct hash_testvec rmd160_tv_template[] = {
 /*
  * RIPEMD-256 test vectors
  */
-static struct hash_testvec rmd256_tv_template[] = {
+static const struct hash_testvec rmd256_tv_template[] = {
 	{
 		.digest	= "\x02\xba\x4c\x4e\x5f\x8e\xcd\x18"
 			  "\x77\xfc\x52\xd6\x4d\x30\xe3\x7a"
@@ -1245,7 +1245,7 @@ static struct hash_testvec rmd256_tv_template[] = {
 /*
  * RIPEMD-320 test vectors
  */
-static struct hash_testvec rmd320_tv_template[] = {
+static const struct hash_testvec rmd320_tv_template[] = {
 	{
 		.digest	= "\x22\xd6\x5d\x56\x61\x53\x6c\xdc\x75\xc1"
 			  "\xfd\xf5\xc6\xde\x7b\x41\xb9\xf2\x73\x25"
@@ -1308,7 +1308,7 @@ static struct hash_testvec rmd320_tv_template[] = {
 	}
 };
 
-static struct hash_testvec crct10dif_tv_template[] = {
+static const struct hash_testvec crct10dif_tv_template[] = {
 	{
 		.plaintext	= "abc",
 		.psize		= 3,
@@ -1358,7 +1358,7 @@ static struct hash_testvec crct10dif_tv_template[] = {
  * SHA1 test vectors  from from FIPS PUB 180-1
  * Long vector from CAVS 5.0
  */
-static struct hash_testvec sha1_tv_template[] = {
+static const struct hash_testvec sha1_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1548,7 +1548,7 @@ static struct hash_testvec sha1_tv_template[] = {
 /*
  * SHA224 test vectors from from FIPS PUB 180-2
  */
-static struct hash_testvec sha224_tv_template[] = {
+static const struct hash_testvec sha224_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1720,7 +1720,7 @@ static struct hash_testvec sha224_tv_template[] = {
 /*
  * SHA256 test vectors from from NIST
  */
-static struct hash_testvec sha256_tv_template[] = {
+static const struct hash_testvec sha256_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1891,7 +1891,7 @@ static struct hash_testvec sha256_tv_template[] = {
 /*
  * SHA384 test vectors from from NIST and kerneli
  */
-static struct hash_testvec sha384_tv_template[] = {
+static const struct hash_testvec sha384_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -2083,7 +2083,7 @@ static struct hash_testvec sha384_tv_template[] = {
 /*
  * SHA512 test vectors from from NIST and kerneli
  */
-static struct hash_testvec sha512_tv_template[] = {
+static const struct hash_testvec sha512_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -2290,7 +2290,7 @@ static struct hash_testvec sha512_tv_template[] = {
  * by Vincent Rijmen and Paulo S. L. M. Barreto as part of the NESSIE
  * submission
  */
-static struct hash_testvec wp512_tv_template[] = {
+static const struct hash_testvec wp512_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -2386,7 +2386,7 @@ static struct hash_testvec wp512_tv_template[] = {
 	},
 };
 
-static struct hash_testvec wp384_tv_template[] = {
+static const struct hash_testvec wp384_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -2466,7 +2466,7 @@ static struct hash_testvec wp384_tv_template[] = {
 	},
 };
 
-static struct hash_testvec wp256_tv_template[] = {
+static const struct hash_testvec wp256_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -2533,7 +2533,7 @@ static struct hash_testvec wp256_tv_template[] = {
 /*
  * TIGER test vectors from Tiger website
  */
-static struct hash_testvec tgr192_tv_template[] = {
+static const struct hash_testvec tgr192_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -2576,7 +2576,7 @@ static struct hash_testvec tgr192_tv_template[] = {
 	},
 };
 
-static struct hash_testvec tgr160_tv_template[] = {
+static const struct hash_testvec tgr160_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -2619,7 +2619,7 @@ static struct hash_testvec tgr160_tv_template[] = {
 	},
 };
 
-static struct hash_testvec tgr128_tv_template[] = {
+static const struct hash_testvec tgr128_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -2656,7 +2656,7 @@ static struct hash_testvec tgr128_tv_template[] = {
 	},
 };
 
-static struct hash_testvec ghash_tv_template[] =
+static const struct hash_testvec ghash_tv_template[] =
 {
 	{
 		.key	= "\xdf\xa6\xbf\x4d\xed\x81\xdb\x03"
@@ -2771,7 +2771,7 @@ static struct hash_testvec ghash_tv_template[] =
  * HMAC-MD5 test vectors from RFC2202
  * (These need to be fixed to not use strlen).
  */
-static struct hash_testvec hmac_md5_tv_template[] =
+static const struct hash_testvec hmac_md5_tv_template[] =
 {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
@@ -2851,7 +2851,7 @@ static struct hash_testvec hmac_md5_tv_template[] =
 /*
  * HMAC-RIPEMD128 test vectors from RFC2286
  */
-static struct hash_testvec hmac_rmd128_tv_template[] = {
+static const struct hash_testvec hmac_rmd128_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
 		.ksize	= 16,
@@ -2930,7 +2930,7 @@ static struct hash_testvec hmac_rmd128_tv_template[] = {
 /*
  * HMAC-RIPEMD160 test vectors from RFC2286
  */
-static struct hash_testvec hmac_rmd160_tv_template[] = {
+static const struct hash_testvec hmac_rmd160_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
 		.ksize	= 20,
@@ -3009,7 +3009,7 @@ static struct hash_testvec hmac_rmd160_tv_template[] = {
 /*
  * HMAC-SHA1 test vectors from RFC2202
  */
-static struct hash_testvec hmac_sha1_tv_template[] = {
+static const struct hash_testvec hmac_sha1_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
 		.ksize	= 20,
@@ -3090,7 +3090,7 @@ static struct hash_testvec hmac_sha1_tv_template[] = {
 /*
  * SHA224 HMAC test vectors from RFC4231
  */
-static struct hash_testvec hmac_sha224_tv_template[] = {
+static const struct hash_testvec hmac_sha224_tv_template[] = {
 	{
 		.key    = "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			"\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -3203,7 +3203,7 @@ static struct hash_testvec hmac_sha224_tv_template[] = {
  * HMAC-SHA256 test vectors from
  * draft-ietf-ipsec-ciph-sha-256-01.txt
  */
-static struct hash_testvec hmac_sha256_tv_template[] = {
+static const struct hash_testvec hmac_sha256_tv_template[] = {
 	{
 		.key	= "\x01\x02\x03\x04\x05\x06\x07\x08"
 			  "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
@@ -3338,7 +3338,7 @@ static struct hash_testvec hmac_sha256_tv_template[] = {
 	},
 };
 
-static struct hash_testvec aes_cmac128_tv_template[] = {
+static const struct hash_testvec aes_cmac128_tv_template[] = {
 	{ /* From NIST Special Publication 800-38B, AES-128 */
 		.key		= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
 				  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
@@ -3413,7 +3413,7 @@ static struct hash_testvec aes_cmac128_tv_template[] = {
 	}
 };
 
-static struct hash_testvec aes_cbcmac_tv_template[] = {
+static const struct hash_testvec aes_cbcmac_tv_template[] = {
 	{
 		.key		= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
 				  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
@@ -3473,7 +3473,7 @@ static struct hash_testvec aes_cbcmac_tv_template[] = {
 	}
 };
 
-static struct hash_testvec des3_ede_cmac64_tv_template[] = {
+static const struct hash_testvec des3_ede_cmac64_tv_template[] = {
 /*
  * From NIST Special Publication 800-38B, Three Key TDEA
  * Corrected test vectors from:
@@ -3519,7 +3519,7 @@ static struct hash_testvec des3_ede_cmac64_tv_template[] = {
 	}
 };
 
-static struct hash_testvec aes_xcbc128_tv_template[] = {
+static const struct hash_testvec aes_xcbc128_tv_template[] = {
 	{
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -3585,35 +3585,35 @@ static struct hash_testvec aes_xcbc128_tv_template[] = {
 	}
 };
 
-static char vmac_string1[128] = {'\x01', '\x01', '\x01', '\x01',
-				'\x02', '\x03', '\x02', '\x02',
-				'\x02', '\x04', '\x01', '\x07',
-				'\x04', '\x01', '\x04', '\x03',};
-static char vmac_string2[128] = {'a', 'b', 'c',};
-static char vmac_string3[128] = {'a', 'b', 'c', 'a', 'b', 'c',
-				'a', 'b', 'c', 'a', 'b', 'c',
-				'a', 'b', 'c', 'a', 'b', 'c',
-				'a', 'b', 'c', 'a', 'b', 'c',
-				'a', 'b', 'c', 'a', 'b', 'c',
-				'a', 'b', 'c', 'a', 'b', 'c',
-				'a', 'b', 'c', 'a', 'b', 'c',
-				'a', 'b', 'c', 'a', 'b', 'c',
-				};
+static const char vmac_string1[128] = {'\x01', '\x01', '\x01', '\x01',
+				       '\x02', '\x03', '\x02', '\x02',
+				       '\x02', '\x04', '\x01', '\x07',
+				       '\x04', '\x01', '\x04', '\x03',};
+static const char vmac_string2[128] = {'a', 'b', 'c',};
+static const char vmac_string3[128] = {'a', 'b', 'c', 'a', 'b', 'c',
+				       'a', 'b', 'c', 'a', 'b', 'c',
+				       'a', 'b', 'c', 'a', 'b', 'c',
+				       'a', 'b', 'c', 'a', 'b', 'c',
+				       'a', 'b', 'c', 'a', 'b', 'c',
+				       'a', 'b', 'c', 'a', 'b', 'c',
+				       'a', 'b', 'c', 'a', 'b', 'c',
+				       'a', 'b', 'c', 'a', 'b', 'c',
+				      };
 
-static char vmac_string4[17] = {'b', 'c', 'e', 'f',
-				'i', 'j', 'l', 'm',
-				'o', 'p', 'r', 's',
-				't', 'u', 'w', 'x', 'z'};
+static const char vmac_string4[17] = {'b', 'c', 'e', 'f',
+				      'i', 'j', 'l', 'm',
+				      'o', 'p', 'r', 's',
+				      't', 'u', 'w', 'x', 'z'};
 
-static char vmac_string5[127] = {'r', 'm', 'b', 't', 'c',
-				 'o', 'l', 'k', ']', '%',
-				 '9', '2', '7', '!', 'A'};
+static const char vmac_string5[127] = {'r', 'm', 'b', 't', 'c',
+				       'o', 'l', 'k', ']', '%',
+				       '9', '2', '7', '!', 'A'};
 
-static char vmac_string6[129] = {'p', 't', '*', '7', 'l',
-				 'i', '!', '#', 'w', '0',
-				 'z', '/', '4', 'A', 'n'};
+static const char vmac_string6[129] = {'p', 't', '*', '7', 'l',
+				       'i', '!', '#', 'w', '0',
+				       'z', '/', '4', 'A', 'n'};
 
-static struct hash_testvec aes_vmac128_tv_template[] = {
+static const struct hash_testvec aes_vmac128_tv_template[] = {
 	{
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -3691,7 +3691,7 @@ static struct hash_testvec aes_vmac128_tv_template[] = {
  * SHA384 HMAC test vectors from RFC4231
  */
 
-static struct hash_testvec hmac_sha384_tv_template[] = {
+static const struct hash_testvec hmac_sha384_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -3789,7 +3789,7 @@ static struct hash_testvec hmac_sha384_tv_template[] = {
  * SHA512 HMAC test vectors from RFC4231
  */
 
-static struct hash_testvec hmac_sha512_tv_template[] = {
+static const struct hash_testvec hmac_sha512_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -3894,7 +3894,7 @@ static struct hash_testvec hmac_sha512_tv_template[] = {
 	},
 };
 
-static struct hash_testvec hmac_sha3_224_tv_template[] = {
+static const struct hash_testvec hmac_sha3_224_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -3983,7 +3983,7 @@ static struct hash_testvec hmac_sha3_224_tv_template[] = {
 	},
 };
 
-static struct hash_testvec hmac_sha3_256_tv_template[] = {
+static const struct hash_testvec hmac_sha3_256_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -4072,7 +4072,7 @@ static struct hash_testvec hmac_sha3_256_tv_template[] = {
 	},
 };
 
-static struct hash_testvec hmac_sha3_384_tv_template[] = {
+static const struct hash_testvec hmac_sha3_384_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -4169,7 +4169,7 @@ static struct hash_testvec hmac_sha3_384_tv_template[] = {
 	},
 };
 
-static struct hash_testvec hmac_sha3_512_tv_template[] = {
+static const struct hash_testvec hmac_sha3_512_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -4278,7 +4278,7 @@ static struct hash_testvec hmac_sha3_512_tv_template[] = {
  * Poly1305 test vectors from RFC7539 A.3.
  */
 
-static struct hash_testvec poly1305_tv_template[] = {
+static const struct hash_testvec poly1305_tv_template[] = {
 	{ /* Test Vector #1 */
 		.plaintext	= "\x00\x00\x00\x00\x00\x00\x00\x00"
 				  "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -4523,7 +4523,7 @@ static struct hash_testvec poly1305_tv_template[] = {
 /*
  * DES test vectors.
  */
-static struct cipher_testvec des_enc_tv_template[] = {
+static const struct cipher_testvec des_enc_tv_template[] = {
 	{ /* From Applied Cryptography */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -4697,7 +4697,7 @@ static struct cipher_testvec des_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des_dec_tv_template[] = {
+static const struct cipher_testvec des_dec_tv_template[] = {
 	{ /* From Applied Cryptography */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -4807,7 +4807,7 @@ static struct cipher_testvec des_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des_cbc_enc_tv_template[] = {
+static const struct cipher_testvec des_cbc_enc_tv_template[] = {
 	{ /* From OpenSSL */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -4933,7 +4933,7 @@ static struct cipher_testvec des_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des_cbc_dec_tv_template[] = {
+static const struct cipher_testvec des_cbc_dec_tv_template[] = {
 	{ /* FIPS Pub 81 */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -5042,7 +5042,7 @@ static struct cipher_testvec des_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des_ctr_enc_tv_template[] = {
+static const struct cipher_testvec des_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
@@ -5188,7 +5188,7 @@ static struct cipher_testvec des_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des_ctr_dec_tv_template[] = {
+static const struct cipher_testvec des_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
@@ -5334,7 +5334,7 @@ static struct cipher_testvec des_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_enc_tv_template[] = {
+static const struct cipher_testvec des3_ede_enc_tv_template[] = {
 	{ /* These are from openssl */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\x55\x55\x55\x55\x55\x55\x55\x55"
@@ -5499,7 +5499,7 @@ static struct cipher_testvec des3_ede_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_dec_tv_template[] = {
+static const struct cipher_testvec des3_ede_dec_tv_template[] = {
 	{ /* These are from openssl */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\x55\x55\x55\x55\x55\x55\x55\x55"
@@ -5664,7 +5664,7 @@ static struct cipher_testvec des3_ede_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_cbc_enc_tv_template[] = {
+static const struct cipher_testvec des3_ede_cbc_enc_tv_template[] = {
 	{ /* Generated from openssl */
 		.key	= "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24"
 			  "\x44\x4D\x99\x5A\x12\xD6\x40\xC0"
@@ -5844,7 +5844,7 @@ static struct cipher_testvec des3_ede_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_cbc_dec_tv_template[] = {
+static const struct cipher_testvec des3_ede_cbc_dec_tv_template[] = {
 	{ /* Generated from openssl */
 		.key	= "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24"
 			  "\x44\x4D\x99\x5A\x12\xD6\x40\xC0"
@@ -6024,7 +6024,7 @@ static struct cipher_testvec des3_ede_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_ctr_enc_tv_template[] = {
+static const struct cipher_testvec des3_ede_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x9C\xD6\xF3\x9C\xB9\x5A\x67\x00"
 			  "\x5A\x67\x00\x2D\xCE\xEB\x2D\xCE"
@@ -6302,7 +6302,7 @@ static struct cipher_testvec des3_ede_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_ctr_dec_tv_template[] = {
+static const struct cipher_testvec des3_ede_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x9C\xD6\xF3\x9C\xB9\x5A\x67\x00"
 			  "\x5A\x67\x00\x2D\xCE\xEB\x2D\xCE"
@@ -6583,7 +6583,7 @@ static struct cipher_testvec des3_ede_ctr_dec_tv_template[] = {
 /*
  * Blowfish test vectors.
  */
-static struct cipher_testvec bf_enc_tv_template[] = {
+static const struct cipher_testvec bf_enc_tv_template[] = {
 	{ /* DES test vectors from OpenSSL */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.klen	= 8,
@@ -6775,7 +6775,7 @@ static struct cipher_testvec bf_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec bf_dec_tv_template[] = {
+static const struct cipher_testvec bf_dec_tv_template[] = {
 	{ /* DES test vectors from OpenSSL */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.klen	= 8,
@@ -6967,7 +6967,7 @@ static struct cipher_testvec bf_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec bf_cbc_enc_tv_template[] = {
+static const struct cipher_testvec bf_cbc_enc_tv_template[] = {
 	{ /* From OpenSSL */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\xf0\xe1\xd2\xc3\xb4\xa5\x96\x87",
@@ -7124,7 +7124,7 @@ static struct cipher_testvec bf_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec bf_cbc_dec_tv_template[] = {
+static const struct cipher_testvec bf_cbc_dec_tv_template[] = {
 	{ /* From OpenSSL */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\xf0\xe1\xd2\xc3\xb4\xa5\x96\x87",
@@ -7281,7 +7281,7 @@ static struct cipher_testvec bf_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec bf_ctr_enc_tv_template[] = {
+static const struct cipher_testvec bf_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -7693,7 +7693,7 @@ static struct cipher_testvec bf_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec bf_ctr_dec_tv_template[] = {
+static const struct cipher_testvec bf_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -8108,7 +8108,7 @@ static struct cipher_testvec bf_ctr_dec_tv_template[] = {
 /*
  * Twofish test vectors.
  */
-static struct cipher_testvec tf_enc_tv_template[] = {
+static const struct cipher_testvec tf_enc_tv_template[] = {
 	{
 		.key	= zeroed_string,
 		.klen	= 16,
@@ -8276,7 +8276,7 @@ static struct cipher_testvec tf_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_dec_tv_template[] = {
+static const struct cipher_testvec tf_dec_tv_template[] = {
 	{
 		.key	= zeroed_string,
 		.klen	= 16,
@@ -8444,7 +8444,7 @@ static struct cipher_testvec tf_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_cbc_enc_tv_template[] = {
+static const struct cipher_testvec tf_cbc_enc_tv_template[] = {
 	{ /* Generated with Nettle */
 		.key	= zeroed_string,
 		.klen	= 16,
@@ -8627,7 +8627,7 @@ static struct cipher_testvec tf_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_cbc_dec_tv_template[] = {
+static const struct cipher_testvec tf_cbc_dec_tv_template[] = {
 	{ /* Reverse of the first four above */
 		.key	= zeroed_string,
 		.klen	= 16,
@@ -8810,7 +8810,7 @@ static struct cipher_testvec tf_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_ctr_enc_tv_template[] = {
+static const struct cipher_testvec tf_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -9221,7 +9221,7 @@ static struct cipher_testvec tf_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_ctr_dec_tv_template[] = {
+static const struct cipher_testvec tf_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -9632,7 +9632,7 @@ static struct cipher_testvec tf_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_lrw_enc_tv_template[] = {
+static const struct cipher_testvec tf_lrw_enc_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	{
 		.key	= "\x45\x62\xac\x25\xf8\x28\x17\x6d"
@@ -9884,7 +9884,7 @@ static struct cipher_testvec tf_lrw_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_lrw_dec_tv_template[] = {
+static const struct cipher_testvec tf_lrw_dec_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -10137,7 +10137,7 @@ static struct cipher_testvec tf_lrw_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_xts_enc_tv_template[] = {
+static const struct cipher_testvec tf_xts_enc_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 {
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -10479,7 +10479,7 @@ static struct cipher_testvec tf_xts_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_xts_dec_tv_template[] = {
+static const struct cipher_testvec tf_xts_dec_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -10826,7 +10826,7 @@ static struct cipher_testvec tf_xts_dec_tv_template[] = {
  * Serpent test vectors.  These are backwards because Serpent writes
  * octet sequences in right-to-left mode.
  */
-static struct cipher_testvec serpent_enc_tv_template[] = {
+static const struct cipher_testvec serpent_enc_tv_template[] = {
 	{
 		.input	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -11002,7 +11002,7 @@ static struct cipher_testvec serpent_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tnepres_enc_tv_template[] = {
+static const struct cipher_testvec tnepres_enc_tv_template[] = {
 	{ /* KeySize=128, PT=0, I=1 */
 		.input	= "\x00\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00",
@@ -11052,7 +11052,7 @@ static struct cipher_testvec tnepres_enc_tv_template[] = {
 };
 
 
-static struct cipher_testvec serpent_dec_tv_template[] = {
+static const struct cipher_testvec serpent_dec_tv_template[] = {
 	{
 		.input	= "\x12\x07\xfc\xce\x9b\xd0\xd6\x47"
 			  "\x6a\xe9\x8f\xbe\xd1\x43\xa0\xe2",
@@ -11228,7 +11228,7 @@ static struct cipher_testvec serpent_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tnepres_dec_tv_template[] = {
+static const struct cipher_testvec tnepres_dec_tv_template[] = {
 	{
 		.input	= "\x41\xcc\x6b\x31\x59\x31\x45\x97"
 			  "\x6d\x6f\xbb\x38\x4b\x37\x21\x28",
@@ -11269,7 +11269,7 @@ static struct cipher_testvec tnepres_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_cbc_enc_tv_template[] = {
+static const struct cipher_testvec serpent_cbc_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -11410,7 +11410,7 @@ static struct cipher_testvec serpent_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_cbc_dec_tv_template[] = {
+static const struct cipher_testvec serpent_cbc_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -11551,7 +11551,7 @@ static struct cipher_testvec serpent_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_ctr_enc_tv_template[] = {
+static const struct cipher_testvec serpent_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -11962,7 +11962,7 @@ static struct cipher_testvec serpent_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_ctr_dec_tv_template[] = {
+static const struct cipher_testvec serpent_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -12373,7 +12373,7 @@ static struct cipher_testvec serpent_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_lrw_enc_tv_template[] = {
+static const struct cipher_testvec serpent_lrw_enc_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	{
 		.key	= "\x45\x62\xac\x25\xf8\x28\x17\x6d"
@@ -12625,7 +12625,7 @@ static struct cipher_testvec serpent_lrw_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_lrw_dec_tv_template[] = {
+static const struct cipher_testvec serpent_lrw_dec_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -12878,7 +12878,7 @@ static struct cipher_testvec serpent_lrw_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_xts_enc_tv_template[] = {
+static const struct cipher_testvec serpent_xts_enc_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 	{
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -13220,7 +13220,7 @@ static struct cipher_testvec serpent_xts_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_xts_dec_tv_template[] = {
+static const struct cipher_testvec serpent_xts_dec_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -13564,7 +13564,7 @@ static struct cipher_testvec serpent_xts_dec_tv_template[] = {
 };
 
 /* Cast6 test vectors from RFC 2612 */
-static struct cipher_testvec cast6_enc_tv_template[] = {
+static const struct cipher_testvec cast6_enc_tv_template[] = {
 	{
 		.key	= "\x23\x42\xbb\x9e\xfa\x38\x54\x2c"
 			  "\x0a\xf7\x56\x47\xf2\x9f\x61\x5d",
@@ -13735,7 +13735,7 @@ static struct cipher_testvec cast6_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_dec_tv_template[] = {
+static const struct cipher_testvec cast6_dec_tv_template[] = {
 	{
 		.key	= "\x23\x42\xbb\x9e\xfa\x38\x54\x2c"
 			  "\x0a\xf7\x56\x47\xf2\x9f\x61\x5d",
@@ -13906,7 +13906,7 @@ static struct cipher_testvec cast6_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_cbc_enc_tv_template[] = {
+static const struct cipher_testvec cast6_cbc_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -14047,7 +14047,7 @@ static struct cipher_testvec cast6_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_cbc_dec_tv_template[] = {
+static const struct cipher_testvec cast6_cbc_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -14188,7 +14188,7 @@ static struct cipher_testvec cast6_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_ctr_enc_tv_template[] = {
+static const struct cipher_testvec cast6_ctr_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -14345,7 +14345,7 @@ static struct cipher_testvec cast6_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_ctr_dec_tv_template[] = {
+static const struct cipher_testvec cast6_ctr_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -14502,7 +14502,7 @@ static struct cipher_testvec cast6_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_lrw_enc_tv_template[] = {
+static const struct cipher_testvec cast6_lrw_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\xf8\xd4\x76\xff\xd6\x46\xee\x6c"
 			  "\x23\x84\xcb\x1c\x77\xd6\x19\x5d"
@@ -14649,7 +14649,7 @@ static struct cipher_testvec cast6_lrw_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_lrw_dec_tv_template[] = {
+static const struct cipher_testvec cast6_lrw_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\xf8\xd4\x76\xff\xd6\x46\xee\x6c"
 			  "\x23\x84\xcb\x1c\x77\xd6\x19\x5d"
@@ -14796,7 +14796,7 @@ static struct cipher_testvec cast6_lrw_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_xts_enc_tv_template[] = {
+static const struct cipher_testvec cast6_xts_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x27\x18\x28\x18\x28\x45\x90\x45"
 			  "\x23\x53\x60\x28\x74\x71\x35\x26"
@@ -14945,7 +14945,7 @@ static struct cipher_testvec cast6_xts_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_xts_dec_tv_template[] = {
+static const struct cipher_testvec cast6_xts_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x27\x18\x28\x18\x28\x45\x90\x45"
 			  "\x23\x53\x60\x28\x74\x71\x35\x26"
@@ -15098,7 +15098,7 @@ static struct cipher_testvec cast6_xts_dec_tv_template[] = {
 /*
  * AES test vectors.
  */
-static struct cipher_testvec aes_enc_tv_template[] = {
+static const struct cipher_testvec aes_enc_tv_template[] = {
 	{ /* From FIPS-197 */
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -15270,7 +15270,7 @@ static struct cipher_testvec aes_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_dec_tv_template[] = {
+static const struct cipher_testvec aes_dec_tv_template[] = {
 	{ /* From FIPS-197 */
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -15442,7 +15442,7 @@ static struct cipher_testvec aes_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_cbc_enc_tv_template[] = {
+static const struct cipher_testvec aes_cbc_enc_tv_template[] = {
 	{ /* From RFC 3602 */
 		.key    = "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
 			  "\x51\x2e\x03\xd5\x34\x12\x00\x06",
@@ -15664,7 +15664,7 @@ static struct cipher_testvec aes_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_cbc_dec_tv_template[] = {
+static const struct cipher_testvec aes_cbc_dec_tv_template[] = {
 	{ /* From RFC 3602 */
 		.key    = "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
 			  "\x51\x2e\x03\xd5\x34\x12\x00\x06",
@@ -15886,7 +15886,7 @@ static struct cipher_testvec aes_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct aead_testvec hmac_md5_ecb_cipher_null_enc_tv_template[] = {
+static const struct aead_testvec hmac_md5_ecb_cipher_null_enc_tv_template[] = {
 	{ /* Input data from RFC 2410 Case 1 */
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15928,7 +15928,7 @@ static struct aead_testvec hmac_md5_ecb_cipher_null_enc_tv_template[] = {
 	},
 };
 
-static struct aead_testvec hmac_md5_ecb_cipher_null_dec_tv_template[] = {
+static const struct aead_testvec hmac_md5_ecb_cipher_null_dec_tv_template[] = {
 	{
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15970,7 +15970,7 @@ static struct aead_testvec hmac_md5_ecb_cipher_null_dec_tv_template[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 	{ /* RFC 3602 Case 1 */
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -16239,7 +16239,7 @@ static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha1_ecb_cipher_null_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha1_ecb_cipher_null_enc_tv_temp[] = {
 	{ /* Input data from RFC 2410 Case 1 */
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -16285,7 +16285,7 @@ static struct aead_testvec hmac_sha1_ecb_cipher_null_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha1_ecb_cipher_null_dec_tv_temp[] = {
+static const struct aead_testvec hmac_sha1_ecb_cipher_null_dec_tv_temp[] = {
 	{
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -16331,7 +16331,7 @@ static struct aead_testvec hmac_sha1_ecb_cipher_null_dec_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 	{ /* RFC 3602 Case 1 */
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -16614,7 +16614,7 @@ static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 	{ /* RFC 3602 Case 1 */
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -16953,7 +16953,7 @@ static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha1_des_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha1_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -17012,7 +17012,7 @@ static struct aead_testvec hmac_sha1_des_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha224_des_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha224_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -17071,7 +17071,7 @@ static struct aead_testvec hmac_sha224_des_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha256_des_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha256_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -17132,7 +17132,7 @@ static struct aead_testvec hmac_sha256_des_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha384_des_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha384_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -17197,7 +17197,7 @@ static struct aead_testvec hmac_sha384_des_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha512_des_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha512_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -17266,7 +17266,7 @@ static struct aead_testvec hmac_sha512_des_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha1_des3_ede_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha1_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -17327,7 +17327,7 @@ static struct aead_testvec hmac_sha1_des3_ede_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha224_des3_ede_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha224_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -17388,7 +17388,7 @@ static struct aead_testvec hmac_sha224_des3_ede_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha256_des3_ede_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha256_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -17451,7 +17451,7 @@ static struct aead_testvec hmac_sha256_des3_ede_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha384_des3_ede_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha384_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -17518,7 +17518,7 @@ static struct aead_testvec hmac_sha384_des3_ede_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha512_des3_ede_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha512_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -17589,7 +17589,7 @@ static struct aead_testvec hmac_sha512_des3_ede_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct cipher_testvec aes_lrw_enc_tv_template[] = {
+static const struct cipher_testvec aes_lrw_enc_tv_template[] = {
 	/* from http://grouper.ieee.org/groups/1619/email/pdf00017.pdf */
 	{ /* LRW-32-AES 1 */
 		.key    = "\x45\x62\xac\x25\xf8\x28\x17\x6d"
@@ -17842,7 +17842,7 @@ static struct cipher_testvec aes_lrw_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec aes_lrw_dec_tv_template[] = {
+static const struct cipher_testvec aes_lrw_dec_tv_template[] = {
 	/* from http://grouper.ieee.org/groups/1619/email/pdf00017.pdf */
 	/* same as enc vectors with input and result reversed */
 	{ /* LRW-32-AES 1 */
@@ -18096,7 +18096,7 @@ static struct cipher_testvec aes_lrw_dec_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec aes_xts_enc_tv_template[] = {
+static const struct cipher_testvec aes_xts_enc_tv_template[] = {
 	/* http://grouper.ieee.org/groups/1619/email/pdf00086.pdf */
 	{ /* XTS-AES 1 */
 		.key    = "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -18439,7 +18439,7 @@ static struct cipher_testvec aes_xts_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec aes_xts_dec_tv_template[] = {
+static const struct cipher_testvec aes_xts_dec_tv_template[] = {
 	/* http://grouper.ieee.org/groups/1619/email/pdf00086.pdf */
 	{ /* XTS-AES 1 */
 		.key    = "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -18783,7 +18783,7 @@ static struct cipher_testvec aes_xts_dec_tv_template[] = {
 };
 
 
-static struct cipher_testvec aes_ctr_enc_tv_template[] = {
+static const struct cipher_testvec aes_ctr_enc_tv_template[] = {
 	{ /* From NIST Special Publication 800-38A, Appendix F.5 */
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
 			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
@@ -19138,7 +19138,7 @@ static struct cipher_testvec aes_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_ctr_dec_tv_template[] = {
+static const struct cipher_testvec aes_ctr_dec_tv_template[] = {
 	{ /* From NIST Special Publication 800-38A, Appendix F.5 */
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
 			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
@@ -19493,7 +19493,7 @@ static struct cipher_testvec aes_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_ctr_rfc3686_enc_tv_template[] = {
+static const struct cipher_testvec aes_ctr_rfc3686_enc_tv_template[] = {
 	{ /* From RFC 3686 */
 		.key	= "\xae\x68\x52\xf8\x12\x10\x67\xcc"
 			  "\x4b\xf7\xa5\x76\x55\x77\xf3\x9e"
@@ -20625,7 +20625,7 @@ static struct cipher_testvec aes_ctr_rfc3686_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_ctr_rfc3686_dec_tv_template[] = {
+static const struct cipher_testvec aes_ctr_rfc3686_dec_tv_template[] = {
 	{ /* From RFC 3686 */
 		.key	= "\xae\x68\x52\xf8\x12\x10\x67\xcc"
 			  "\x4b\xf7\xa5\x76\x55\x77\xf3\x9e"
@@ -20716,7 +20716,7 @@ static struct cipher_testvec aes_ctr_rfc3686_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_ofb_enc_tv_template[] = {
+static const struct cipher_testvec aes_ofb_enc_tv_template[] = {
 	 /* From NIST Special Publication 800-38A, Appendix F.5 */
 	{
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
@@ -20745,7 +20745,7 @@ static struct cipher_testvec aes_ofb_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec aes_ofb_dec_tv_template[] = {
+static const struct cipher_testvec aes_ofb_dec_tv_template[] = {
 	 /* From NIST Special Publication 800-38A, Appendix F.5 */
 	{
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
@@ -20774,7 +20774,7 @@ static struct cipher_testvec aes_ofb_dec_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_enc_tv_template[] = {
+static const struct aead_testvec aes_gcm_enc_tv_template[] = {
 	{ /* From McGrew & Viega - http://citeseer.ist.psu.edu/656989.html */
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -20934,7 +20934,7 @@ static struct aead_testvec aes_gcm_enc_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_dec_tv_template[] = {
+static const struct aead_testvec aes_gcm_dec_tv_template[] = {
 	{ /* From McGrew & Viega - http://citeseer.ist.psu.edu/656989.html */
 		.key    = zeroed_string,
 		.klen	= 32,
@@ -21136,7 +21136,7 @@ static struct aead_testvec aes_gcm_dec_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_rfc4106_enc_tv_template[] = {
+static const struct aead_testvec aes_gcm_rfc4106_enc_tv_template[] = {
 	{ /* Generated using Crypto++ */
 		.key    = zeroed_string,
 		.klen	= 20,
@@ -21749,7 +21749,7 @@ static struct aead_testvec aes_gcm_rfc4106_enc_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_rfc4106_dec_tv_template[] = {
+static const struct aead_testvec aes_gcm_rfc4106_dec_tv_template[] = {
 	{ /* Generated using Crypto++ */
 		.key    = zeroed_string,
 		.klen	= 20,
@@ -22363,7 +22363,7 @@ static struct aead_testvec aes_gcm_rfc4106_dec_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_rfc4543_enc_tv_template[] = {
+static const struct aead_testvec aes_gcm_rfc4543_enc_tv_template[] = {
 	{ /* From draft-mcgrew-gcm-test-01 */
 		.key	= "\x4c\x80\xcd\xef\xbb\x5d\x10\xda"
 			  "\x90\x6a\xc7\x3c\x36\x13\xa6\x34"
@@ -22394,7 +22394,7 @@ static struct aead_testvec aes_gcm_rfc4543_enc_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_rfc4543_dec_tv_template[] = {
+static const struct aead_testvec aes_gcm_rfc4543_dec_tv_template[] = {
 	{ /* From draft-mcgrew-gcm-test-01 */
 		.key	= "\x4c\x80\xcd\xef\xbb\x5d\x10\xda"
 			  "\x90\x6a\xc7\x3c\x36\x13\xa6\x34"
@@ -22453,7 +22453,7 @@ static struct aead_testvec aes_gcm_rfc4543_dec_tv_template[] = {
 	},
 };
 
-static struct aead_testvec aes_ccm_enc_tv_template[] = {
+static const struct aead_testvec aes_ccm_enc_tv_template[] = {
 	{ /* From RFC 3610 */
 		.key	= "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
 			  "\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf",
@@ -22737,7 +22737,7 @@ static struct aead_testvec aes_ccm_enc_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_ccm_dec_tv_template[] = {
+static const struct aead_testvec aes_ccm_dec_tv_template[] = {
 	{ /* From RFC 3610 */
 		.key	= "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
 			  "\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf",
@@ -23069,7 +23069,7 @@ static struct aead_testvec aes_ccm_dec_tv_template[] = {
  * These vectors are copied/generated from the ones for rfc4106 with
  * the key truncated by one byte..
  */
-static struct aead_testvec aes_ccm_rfc4309_enc_tv_template[] = {
+static const struct aead_testvec aes_ccm_rfc4309_enc_tv_template[] = {
 	{ /* Generated using Crypto++ */
 		.key	= zeroed_string,
 		.klen	= 19,
@@ -23682,7 +23682,7 @@ static struct aead_testvec aes_ccm_rfc4309_enc_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_ccm_rfc4309_dec_tv_template[]	= {
+static const struct aead_testvec aes_ccm_rfc4309_dec_tv_template[]	= {
 	{ /* Generated using Crypto++ */
 		.key	= zeroed_string,
 		.klen	= 19,
@@ -24298,7 +24298,7 @@ static struct aead_testvec aes_ccm_rfc4309_dec_tv_template[]	= {
 /*
  * ChaCha20-Poly1305 AEAD test vectors from RFC7539 2.8.2./A.5.
  */
-static struct aead_testvec rfc7539_enc_tv_template[] = {
+static const struct aead_testvec rfc7539_enc_tv_template[] = {
 	{
 		.key	= "\x80\x81\x82\x83\x84\x85\x86\x87"
 			  "\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f"
@@ -24430,7 +24430,7 @@ static struct aead_testvec rfc7539_enc_tv_template[] = {
 	},
 };
 
-static struct aead_testvec rfc7539_dec_tv_template[] = {
+static const struct aead_testvec rfc7539_dec_tv_template[] = {
 	{
 		.key	= "\x80\x81\x82\x83\x84\x85\x86\x87"
 			  "\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f"
@@ -24565,7 +24565,7 @@ static struct aead_testvec rfc7539_dec_tv_template[] = {
 /*
  * draft-irtf-cfrg-chacha20-poly1305
  */
-static struct aead_testvec rfc7539esp_enc_tv_template[] = {
+static const struct aead_testvec rfc7539esp_enc_tv_template[] = {
 	{
 		.key	= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
 			  "\xf3\x33\x88\x86\x04\xf6\xb5\xf0"
@@ -24653,7 +24653,7 @@ static struct aead_testvec rfc7539esp_enc_tv_template[] = {
 	},
 };
 
-static struct aead_testvec rfc7539esp_dec_tv_template[] = {
+static const struct aead_testvec rfc7539esp_dec_tv_template[] = {
 	{
 		.key	= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
 			  "\xf3\x33\x88\x86\x04\xf6\xb5\xf0"
@@ -24749,7 +24749,7 @@ static struct aead_testvec rfc7539esp_dec_tv_template[] = {
  * semiblock of the ciphertext from the test vector. For decryption, iv is
  * the first semiblock of the ciphertext.
  */
-static struct cipher_testvec aes_kw_enc_tv_template[] = {
+static const struct cipher_testvec aes_kw_enc_tv_template[] = {
 	{
 		.key	= "\x75\x75\xda\x3a\x93\x60\x7c\xc2"
 			  "\xbf\xd8\xce\xc7\xaa\xdf\xd9\xa6",
@@ -24764,7 +24764,7 @@ static struct cipher_testvec aes_kw_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_kw_dec_tv_template[] = {
+static const struct cipher_testvec aes_kw_dec_tv_template[] = {
 	{
 		.key	= "\x80\xaa\x99\x73\x27\xa4\x80\x6b"
 			  "\x6a\x7a\x41\xa5\x2b\x86\xc3\x71"
@@ -24787,7 +24787,7 @@ static struct cipher_testvec aes_kw_dec_tv_template[] = {
  *     http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
  * Only AES-128 is supported at this time.
  */
-static struct cprng_testvec ansi_cprng_aes_tv_template[] = {
+static const struct cprng_testvec ansi_cprng_aes_tv_template[] = {
 	{
 		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
 			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
@@ -24883,7 +24883,7 @@ static struct cprng_testvec ansi_cprng_aes_tv_template[] = {
  * (Hash, HMAC, CTR) are tested with all permutations of use cases (w/ and
  * w/o personalization string, w/ and w/o additional input string).
  */
-static struct drbg_testvec drbg_pr_sha256_tv_template[] = {
+static const struct drbg_testvec drbg_pr_sha256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\x72\x88\x4c\xcd\x6c\x85\x57\x70\xf7\x0b\x8b\x86"
@@ -25041,7 +25041,7 @@ static struct drbg_testvec drbg_pr_sha256_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_pr_hmac_sha256_tv_template[] = {
+static const struct drbg_testvec drbg_pr_hmac_sha256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\x99\x69\xe5\x4b\x47\x03\xff\x31\x78\x5b\x87\x9a"
@@ -25199,7 +25199,7 @@ static struct drbg_testvec drbg_pr_hmac_sha256_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_pr_ctr_aes128_tv_template[] = {
+static const struct drbg_testvec drbg_pr_ctr_aes128_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\xd1\x44\xc6\x61\x81\x6d\xca\x9d\x15\x28\x8a\x42"
@@ -25323,7 +25323,7 @@ static struct drbg_testvec drbg_pr_ctr_aes128_tv_template[] = {
  * (Hash, HMAC, CTR) are tested with all permutations of use cases (w/ and
  * w/o personalization string, w/ and w/o additional input string).
  */
-static struct drbg_testvec drbg_nopr_sha256_tv_template[] = {
+static const struct drbg_testvec drbg_nopr_sha256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\xa6\x5a\xd0\xf3\x45\xdb\x4e\x0e\xff\xe8\x75\xc3"
@@ -25445,7 +25445,7 @@ static struct drbg_testvec drbg_nopr_sha256_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
+static const struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\xca\x85\x19\x11\x34\x93\x84\xbf\xfe\x89\xde\x1c"
@@ -25567,7 +25567,7 @@ static struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_nopr_ctr_aes192_tv_template[] = {
+static const struct drbg_testvec drbg_nopr_ctr_aes192_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\xc3\x5c\x2f\xa2\xa8\x9d\x52\xa1\x1f\xa3\x2a\xa9"
@@ -25591,7 +25591,7 @@ static struct drbg_testvec drbg_nopr_ctr_aes192_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_nopr_ctr_aes256_tv_template[] = {
+static const struct drbg_testvec drbg_nopr_ctr_aes256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\x36\x40\x19\x40\xfa\x8b\x1f\xba\x91\xa1\x66\x1f"
@@ -25615,7 +25615,7 @@ static struct drbg_testvec drbg_nopr_ctr_aes256_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
+static const struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\x87\xe1\xc5\x32\x99\x7f\x57\xa3\x5c\x28\x6d\xe8"
@@ -25704,7 +25704,7 @@ static struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
 };
 
 /* Cast5 test vectors from RFC 2144 */
-static struct cipher_testvec cast5_enc_tv_template[] = {
+static const struct cipher_testvec cast5_enc_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x12\x34\x56\x78"
 			  "\x23\x45\x67\x89\x34\x56\x78\x9a",
@@ -25865,7 +25865,7 @@ static struct cipher_testvec cast5_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast5_dec_tv_template[] = {
+static const struct cipher_testvec cast5_dec_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x12\x34\x56\x78"
 			  "\x23\x45\x67\x89\x34\x56\x78\x9a",
@@ -26026,7 +26026,7 @@ static struct cipher_testvec cast5_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast5_cbc_enc_tv_template[] = {
+static const struct cipher_testvec cast5_cbc_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
@@ -26164,7 +26164,7 @@ static struct cipher_testvec cast5_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast5_cbc_dec_tv_template[] = {
+static const struct cipher_testvec cast5_cbc_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
@@ -26302,7 +26302,7 @@ static struct cipher_testvec cast5_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast5_ctr_enc_tv_template[] = {
+static const struct cipher_testvec cast5_ctr_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
@@ -26453,7 +26453,7 @@ static struct cipher_testvec cast5_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast5_ctr_dec_tv_template[] = {
+static const struct cipher_testvec cast5_ctr_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
@@ -26607,7 +26607,7 @@ static struct cipher_testvec cast5_ctr_dec_tv_template[] = {
 /*
  * ARC4 test vectors from OpenSSL
  */
-static struct cipher_testvec arc4_enc_tv_template[] = {
+static const struct cipher_testvec arc4_enc_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -26673,7 +26673,7 @@ static struct cipher_testvec arc4_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec arc4_dec_tv_template[] = {
+static const struct cipher_testvec arc4_dec_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -26742,7 +26742,7 @@ static struct cipher_testvec arc4_dec_tv_template[] = {
 /*
  * TEA test vectors
  */
-static struct cipher_testvec tea_enc_tv_template[] = {
+static const struct cipher_testvec tea_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -26785,7 +26785,7 @@ static struct cipher_testvec tea_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec tea_dec_tv_template[] = {
+static const struct cipher_testvec tea_dec_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -26831,7 +26831,7 @@ static struct cipher_testvec tea_dec_tv_template[] = {
 /*
  * XTEA test vectors
  */
-static struct cipher_testvec xtea_enc_tv_template[] = {
+static const struct cipher_testvec xtea_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -26874,7 +26874,7 @@ static struct cipher_testvec xtea_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec xtea_dec_tv_template[] = {
+static const struct cipher_testvec xtea_dec_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -26920,7 +26920,7 @@ static struct cipher_testvec xtea_dec_tv_template[] = {
 /*
  * KHAZAD test vectors.
  */
-static struct cipher_testvec khazad_enc_tv_template[] = {
+static const struct cipher_testvec khazad_enc_tv_template[] = {
 	{
 		.key	= "\x80\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00",
@@ -26966,7 +26966,7 @@ static struct cipher_testvec khazad_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec khazad_dec_tv_template[] = {
+static const struct cipher_testvec khazad_dec_tv_template[] = {
 	{
 		.key	= "\x80\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00",
@@ -27016,7 +27016,7 @@ static struct cipher_testvec khazad_dec_tv_template[] = {
  * Anubis test vectors.
  */
 
-static struct cipher_testvec anubis_enc_tv_template[] = {
+static const struct cipher_testvec anubis_enc_tv_template[] = {
 	{
 		.key	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe",
@@ -27079,7 +27079,7 @@ static struct cipher_testvec anubis_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec anubis_dec_tv_template[] = {
+static const struct cipher_testvec anubis_dec_tv_template[] = {
 	{
 		.key	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe",
@@ -27142,7 +27142,7 @@ static struct cipher_testvec anubis_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec anubis_cbc_enc_tv_template[] = {
+static const struct cipher_testvec anubis_cbc_enc_tv_template[] = {
 	{
 		.key	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe",
@@ -27177,7 +27177,7 @@ static struct cipher_testvec anubis_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec anubis_cbc_dec_tv_template[] = {
+static const struct cipher_testvec anubis_cbc_dec_tv_template[] = {
 	{
 		.key	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe",
@@ -27215,7 +27215,7 @@ static struct cipher_testvec anubis_cbc_dec_tv_template[] = {
 /*
  * XETA test vectors
  */
-static struct cipher_testvec xeta_enc_tv_template[] = {
+static const struct cipher_testvec xeta_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -27258,7 +27258,7 @@ static struct cipher_testvec xeta_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec xeta_dec_tv_template[] = {
+static const struct cipher_testvec xeta_dec_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -27304,7 +27304,7 @@ static struct cipher_testvec xeta_dec_tv_template[] = {
 /*
  * FCrypt test vectors
  */
-static struct cipher_testvec fcrypt_pcbc_enc_tv_template[] = {
+static const struct cipher_testvec fcrypt_pcbc_enc_tv_template[] = {
 	{ /* http://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.klen	= 8,
@@ -27365,7 +27365,7 @@ static struct cipher_testvec fcrypt_pcbc_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec fcrypt_pcbc_dec_tv_template[] = {
+static const struct cipher_testvec fcrypt_pcbc_dec_tv_template[] = {
 	{ /* http://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.klen	= 8,
@@ -27429,7 +27429,7 @@ static struct cipher_testvec fcrypt_pcbc_dec_tv_template[] = {
 /*
  * CAMELLIA test vectors.
  */
-static struct cipher_testvec camellia_enc_tv_template[] = {
+static const struct cipher_testvec camellia_enc_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
@@ -27729,7 +27729,7 @@ static struct cipher_testvec camellia_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_dec_tv_template[] = {
+static const struct cipher_testvec camellia_dec_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
@@ -28029,7 +28029,7 @@ static struct cipher_testvec camellia_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_cbc_enc_tv_template[] = {
+static const struct cipher_testvec camellia_cbc_enc_tv_template[] = {
 	{
 		.key    = "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
 			  "\x51\x2e\x03\xd5\x34\x12\x00\x06",
@@ -28325,7 +28325,7 @@ static struct cipher_testvec camellia_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_cbc_dec_tv_template[] = {
+static const struct cipher_testvec camellia_cbc_dec_tv_template[] = {
 	{
 		.key    = "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
 			  "\x51\x2e\x03\xd5\x34\x12\x00\x06",
@@ -28621,7 +28621,7 @@ static struct cipher_testvec camellia_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_ctr_enc_tv_template[] = {
+static const struct cipher_testvec camellia_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -29288,7 +29288,7 @@ static struct cipher_testvec camellia_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_ctr_dec_tv_template[] = {
+static const struct cipher_testvec camellia_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -29955,7 +29955,7 @@ static struct cipher_testvec camellia_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_lrw_enc_tv_template[] = {
+static const struct cipher_testvec camellia_lrw_enc_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	{
 		.key	= "\x45\x62\xac\x25\xf8\x28\x17\x6d"
@@ -30207,7 +30207,7 @@ static struct cipher_testvec camellia_lrw_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_lrw_dec_tv_template[] = {
+static const struct cipher_testvec camellia_lrw_dec_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -30460,7 +30460,7 @@ static struct cipher_testvec camellia_lrw_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_xts_enc_tv_template[] = {
+static const struct cipher_testvec camellia_xts_enc_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 	{
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -30802,7 +30802,7 @@ static struct cipher_testvec camellia_xts_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_xts_dec_tv_template[] = {
+static const struct cipher_testvec camellia_xts_dec_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -31148,7 +31148,7 @@ static struct cipher_testvec camellia_xts_dec_tv_template[] = {
 /*
  * SEED test vectors
  */
-static struct cipher_testvec seed_enc_tv_template[] = {
+static const struct cipher_testvec seed_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -31190,7 +31190,7 @@ static struct cipher_testvec seed_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec seed_dec_tv_template[] = {
+static const struct cipher_testvec seed_dec_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -31232,7 +31232,7 @@ static struct cipher_testvec seed_dec_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec salsa20_stream_enc_tv_template[] = {
+static const struct cipher_testvec salsa20_stream_enc_tv_template[] = {
 	/*
 	* Testvectors from verified.test-vectors submitted to ECRYPT.
 	* They are truncated to size 39, 64, 111, 129 to test a variety
@@ -32401,7 +32401,7 @@ static struct cipher_testvec salsa20_stream_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec chacha20_enc_tv_template[] = {
+static const struct cipher_testvec chacha20_enc_tv_template[] = {
 	{ /* RFC7539 A.2. Test Vector #1 */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -32912,7 +32912,7 @@ static struct cipher_testvec chacha20_enc_tv_template[] = {
 /*
  * CTS (Cipher Text Stealing) mode tests
  */
-static struct cipher_testvec cts_mode_enc_tv_template[] = {
+static const struct cipher_testvec cts_mode_enc_tv_template[] = {
 	{ /* from rfc3962 */
 		.klen	= 16,
 		.key    = "\x63\x68\x69\x63\x6b\x65\x6e\x20"
@@ -33014,7 +33014,7 @@ static struct cipher_testvec cts_mode_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec cts_mode_dec_tv_template[] = {
+static const struct cipher_testvec cts_mode_dec_tv_template[] = {
 	{ /* from rfc3962 */
 		.klen	= 16,
 		.key    = "\x63\x68\x69\x63\x6b\x65\x6e\x20"
@@ -33132,7 +33132,7 @@ struct comp_testvec {
  * Params: winbits=-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
  */
 
-static struct comp_testvec deflate_comp_tv_template[] = {
+static const struct comp_testvec deflate_comp_tv_template[] = {
 	{
 		.inlen	= 70,
 		.outlen	= 38,
@@ -33168,7 +33168,7 @@ static struct comp_testvec deflate_comp_tv_template[] = {
 	},
 };
 
-static struct comp_testvec deflate_decomp_tv_template[] = {
+static const struct comp_testvec deflate_decomp_tv_template[] = {
 	{
 		.inlen	= 122,
 		.outlen	= 191,
@@ -33207,7 +33207,7 @@ static struct comp_testvec deflate_decomp_tv_template[] = {
 /*
  * LZO test vectors (null-terminated strings).
  */
-static struct comp_testvec lzo_comp_tv_template[] = {
+static const struct comp_testvec lzo_comp_tv_template[] = {
 	{
 		.inlen	= 70,
 		.outlen	= 57,
@@ -33247,7 +33247,7 @@ static struct comp_testvec lzo_comp_tv_template[] = {
 	},
 };
 
-static struct comp_testvec lzo_decomp_tv_template[] = {
+static const struct comp_testvec lzo_decomp_tv_template[] = {
 	{
 		.inlen	= 133,
 		.outlen	= 159,
@@ -33290,7 +33290,7 @@ static struct comp_testvec lzo_decomp_tv_template[] = {
  */
 #define MICHAEL_MIC_TEST_VECTORS 6
 
-static struct hash_testvec michael_mic_tv_template[] = {
+static const struct hash_testvec michael_mic_tv_template[] = {
 	{
 		.key = "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.ksize = 8,
@@ -33338,7 +33338,7 @@ static struct hash_testvec michael_mic_tv_template[] = {
 /*
  * CRC32 test vectors
  */
-static struct hash_testvec crc32_tv_template[] = {
+static const struct hash_testvec crc32_tv_template[] = {
 	{
 		.key = "\x87\xa9\xcb\xed",
 		.ksize = 4,
@@ -33770,7 +33770,7 @@ static struct hash_testvec crc32_tv_template[] = {
 /*
  * CRC32C test vectors
  */
-static struct hash_testvec crc32c_tv_template[] = {
+static const struct hash_testvec crc32c_tv_template[] = {
 	{
 		.psize = 0,
 		.digest = "\x00\x00\x00\x00",
@@ -34206,7 +34206,7 @@ static struct hash_testvec crc32c_tv_template[] = {
 /*
  * Blakcifn CRC test vectors
  */
-static struct hash_testvec bfin_crc_tv_template[] = {
+static const struct hash_testvec bfin_crc_tv_template[] = {
 	{
 		.psize = 0,
 		.digest = "\x00\x00\x00\x00",
@@ -34291,7 +34291,7 @@ static struct hash_testvec bfin_crc_tv_template[] = {
 
 };
 
-static struct comp_testvec lz4_comp_tv_template[] = {
+static const struct comp_testvec lz4_comp_tv_template[] = {
 	{
 		.inlen	= 70,
 		.outlen	= 45,
@@ -34306,7 +34306,7 @@ static struct comp_testvec lz4_comp_tv_template[] = {
 	},
 };
 
-static struct comp_testvec lz4_decomp_tv_template[] = {
+static const struct comp_testvec lz4_decomp_tv_template[] = {
 	{
 		.inlen	= 45,
 		.outlen	= 70,
@@ -34321,7 +34321,7 @@ static struct comp_testvec lz4_decomp_tv_template[] = {
 	},
 };
 
-static struct comp_testvec lz4hc_comp_tv_template[] = {
+static const struct comp_testvec lz4hc_comp_tv_template[] = {
 	{
 		.inlen	= 70,
 		.outlen	= 45,
@@ -34336,7 +34336,7 @@ static struct comp_testvec lz4hc_comp_tv_template[] = {
 	},
 };
 
-static struct comp_testvec lz4hc_decomp_tv_template[] = {
+static const struct comp_testvec lz4hc_decomp_tv_template[] = {
 	{
 		.inlen	= 45,
 		.outlen	= 70,
-- 
2.11.0.483.g087da7b7c-goog
