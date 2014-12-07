From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 14/25] crypto: tcrypt - Add const qualifiers all over the test code.
Date: Sun,  7 Dec 2014 07:26:22 -0500
Message-ID: <f1943d57494540ed1dcde96709f7302f2cfc4b89.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:25741 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753161AbaLGM1F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:05 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Huge diff, but simple.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/tcrypt.c  |  46 +++----
 crypto/tcrypt.h  |  30 ++--
 crypto/testmgr.c |  58 ++++----
 crypto/testmgr.h | 410 +++++++++++++++++++++++++++----------------------------
 4 files changed, 276 insertions(+), 268 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 890449e6..38a57ad0 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -63,7 +63,7 @@ static u32 mask;
 static int mode;
 static char *tvmem[TVMEMSIZE];
 
-static char *check[] = {
+static const char * const check[] = {
 	"des", "md5", "des3_ede", "rot13", "sha1", "sha224", "sha256",
 	"blowfish", "twofish", "serpent", "sha384", "sha512", "md4", "aes",
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
@@ -211,8 +211,8 @@ out:
 	return ret;
 }
 
-static u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
-static u32 aead_sizes[] = { 16, 64, 256, 512, 1024, 2048, 4096, 8192, 0 };
+static const u32 block_sizes[] = { 16, 64, 256, 1024, 8192, 0 };
+static const u32 aead_sizes[] = { 16, 64, 256, 512, 1024, 2048, 4096, 8192, 0 };
 
 #define XBUFSIZE 8
 #define MAX_IVLEN 32
@@ -266,9 +266,9 @@ static void sg_init_aead(struct scatterlist *sg, char *xbuf[XBUFSIZE],
 }
 
 static void test_aead_speed(const char *algo, int enc, unsigned int secs,
-			    struct aead_speed_template *template,
+			    const struct aead_speed_template *template,
 			    unsigned int tcount, u8 authsize,
-			    unsigned int aad_size, u8 *keysize)
+			    unsigned int aad_size, const u8 *keysize)
 {
 	unsigned int i, j;
 	struct crypto_aead *tfm;
@@ -284,7 +284,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 	char *xbuf[XBUFSIZE];
 	char *xoutbuf[XBUFSIZE];
 	char *axbuf[XBUFSIZE];
-	unsigned int *b_size;
+	const unsigned int *b_size;
 	unsigned int iv_len;
 
 	if (aad_size >= PAGE_SIZE) {
@@ -412,8 +412,8 @@ out_noxbuf:
 }
 
 static void test_cipher_speed(const char *algo, int enc, unsigned int secs,
-			      struct cipher_speed_template *template,
-			      unsigned int tcount, u8 *keysize)
+			      const struct cipher_speed_template *template,
+			      unsigned int tcount, const u8 *keysize)
 {
 	unsigned int ret, i, j, iv_len;
 	const char *key;
@@ -421,7 +421,7 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int secs,
 	struct crypto_blkcipher *tfm;
 	struct blkcipher_desc desc;
 	const char *e;
-	u32 *b_size;
+	const u32 *b_size;
 
 	if (enc == ENCRYPT)
 	        e = "encryption";
@@ -513,7 +513,7 @@ out:
 
 static int test_hash_jiffies_digest(struct hash_desc *desc,
 				    struct scatterlist *sg, int blen,
-				    char *out, int secs)
+				    u8 *out, int secs)
 {
 	unsigned long start, end;
 	int bcount;
@@ -533,7 +533,7 @@ static int test_hash_jiffies_digest(struct hash_desc *desc,
 }
 
 static int test_hash_jiffies(struct hash_desc *desc, struct scatterlist *sg,
-			     int blen, int plen, char *out, int secs)
+			     int blen, int plen, u8 *out, int secs)
 {
 	unsigned long start, end;
 	int bcount, pcount;
@@ -565,7 +565,7 @@ static int test_hash_jiffies(struct hash_desc *desc, struct scatterlist *sg,
 }
 
 static int test_hash_cycles_digest(struct hash_desc *desc,
-				   struct scatterlist *sg, int blen, char *out)
+				   struct scatterlist *sg, int blen, u8 *out)
 {
 	unsigned long cycles = 0;
 	int i;
@@ -608,7 +608,7 @@ out:
 }
 
 static int test_hash_cycles(struct hash_desc *desc, struct scatterlist *sg,
-			    int blen, int plen, char *out)
+			    int blen, int plen, u8 *out)
 {
 	unsigned long cycles = 0;
 	int i, pcount;
@@ -681,7 +681,7 @@ static void test_hash_sg_init(struct scatterlist *sg)
 }
 
 static void test_hash_speed(const char *algo, unsigned int secs,
-			    struct hash_speed *speed)
+			    const struct hash_speed *speed)
 {
 	struct scatterlist sg[TVMEMSIZE];
 	struct crypto_hash *tfm;
@@ -773,7 +773,7 @@ static inline int do_one_ahash_op(struct ahash_request *req, int ret)
 }
 
 static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
-				     char *out, int secs)
+				     u8 *out, int secs)
 {
 	unsigned long start, end;
 	int bcount;
@@ -793,7 +793,7 @@ static int test_ahash_jiffies_digest(struct ahash_request *req, int blen,
 }
 
 static int test_ahash_jiffies(struct ahash_request *req, int blen,
-			      int plen, char *out, int secs)
+			      int plen, u8 *out, int secs)
 {
 	unsigned long start, end;
 	int bcount, pcount;
@@ -825,7 +825,7 @@ static int test_ahash_jiffies(struct ahash_request *req, int blen,
 }
 
 static int test_ahash_cycles_digest(struct ahash_request *req, int blen,
-				    char *out)
+				    u8 *out)
 {
 	unsigned long cycles = 0;
 	int ret, i;
@@ -863,7 +863,7 @@ out:
 }
 
 static int test_ahash_cycles(struct ahash_request *req, int blen,
-			     int plen, char *out)
+			     int plen, u8 *out)
 {
 	unsigned long cycles = 0;
 	int i, pcount, ret;
@@ -920,7 +920,7 @@ out:
 }
 
 static void test_ahash_speed(const char *algo, unsigned int secs,
-			     struct hash_speed *speed)
+			     const struct hash_speed *speed)
 {
 	struct scatterlist sg[TVMEMSIZE];
 	struct tcrypt_result tresult;
@@ -1075,8 +1075,8 @@ out:
 }
 
 static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
-			       struct cipher_speed_template *template,
-			       unsigned int tcount, u8 *keysize)
+			       const struct cipher_speed_template *template,
+			       unsigned int tcount, const u8 *keysize)
 {
 	unsigned int ret, i, j, k, iv_len;
 	struct tcrypt_result tresult;
@@ -1085,7 +1085,7 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
 	struct ablkcipher_request *req;
 	struct crypto_ablkcipher *tfm;
 	const char *e;
-	u32 *b_size;
+	const u32 *b_size;
 
 	if (enc == ENCRYPT)
 		e = "encryption";
@@ -1204,7 +1204,7 @@ out:
 
 static void test_available(void)
 {
-	char **name = check;
+	const char * const *name = check;
 
 	while (*name) {
 		printk("alg %s ", *name);
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 6c7e21a0..f042476a 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -38,7 +38,7 @@ struct hash_speed {
  */
 #define DES3_SPEED_VECTORS	1
 
-static struct cipher_speed_template des3_speed_template[] = {
+static const struct cipher_speed_template des3_speed_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\x55\x55\x55\x55\x55\x55\x55\x55"
@@ -50,27 +50,27 @@ static struct cipher_speed_template des3_speed_template[] = {
 /*
  * Cipher speed tests
  */
-static u8 speed_template_8[] = {8, 0};
-static u8 speed_template_24[] = {24, 0};
-static u8 speed_template_8_16[] = {8, 16, 0};
-static u8 speed_template_8_32[] = {8, 32, 0};
-static u8 speed_template_16_32[] = {16, 32, 0};
-static u8 speed_template_16_24_32[] = {16, 24, 32, 0};
-static u8 speed_template_20_28_36[] = {20, 28, 36, 0};
-static u8 speed_template_32_40_48[] = {32, 40, 48, 0};
-static u8 speed_template_32_48[] = {32, 48, 0};
-static u8 speed_template_32_48_64[] = {32, 48, 64, 0};
-static u8 speed_template_32_64[] = {32, 64, 0};
+static const u8 speed_template_8[] = {8, 0};
+static const u8 speed_template_24[] = {24, 0};
+static const u8 speed_template_8_16[] = {8, 16, 0};
+static const u8 speed_template_8_32[] = {8, 32, 0};
+static const u8 speed_template_16_32[] = {16, 32, 0};
+static const u8 speed_template_16_24_32[] = {16, 24, 32, 0};
+static const u8 speed_template_20_28_36[] = {20, 28, 36, 0};
+static const u8 speed_template_32_40_48[] = {32, 40, 48, 0};
+static const u8 speed_template_32_48[] = {32, 48, 0};
+static const u8 speed_template_32_48_64[] = {32, 48, 64, 0};
+static const u8 speed_template_32_64[] = {32, 64, 0};
 
 /*
  * AEAD speed tests
  */
-static u8 aead_speed_template_20[] = {20, 0};
+static const u8 aead_speed_template_20[] = {20, 0};
 
 /*
  * Digest speed tests
  */
-static struct hash_speed generic_hash_speed_template[] = {
+static const struct hash_speed generic_hash_speed_template[] = {
 	{ .blen = 16,	.plen = 16, },
 	{ .blen = 64,	.plen = 16, },
 	{ .blen = 64,	.plen = 64, },
@@ -98,7 +98,7 @@ static struct hash_speed generic_hash_speed_template[] = {
 	{  .blen = 0,	.plen = 0, }
 };
 
-static struct hash_speed hash_speed_template_16[] = {
+static const struct hash_speed hash_speed_template_16[] = {
 	{ .blen = 16,	.plen = 16,	.klen = 16, },
 	{ .blen = 64,	.plen = 16,	.klen = 16, },
 	{ .blen = 64,	.plen = 64,	.klen = 16, },
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 29a0cbdd..9f4746eb 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -73,44 +73,44 @@ struct tcrypt_result {
 
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
 
 struct pcomp_test_suite {
 	struct {
-		struct pcomp_testvec *vecs;
+		const struct pcomp_testvec *vecs;
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
 
@@ -131,9 +131,10 @@ struct alg_test_desc {
 	} suite;
 };
 
-static unsigned int IDX[8] = { IDX1, IDX2, IDX3, IDX4, IDX5, IDX6, IDX7, IDX8 };
+static const unsigned int IDX[8] =
+			{ IDX1, IDX2, IDX3, IDX4, IDX5, IDX6, IDX7, IDX8 };
 
-static void hexdump(unsigned char *buf, unsigned int len)
+static void hexdump(const u8 *buf, unsigned int len)
 {
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
 			16, 1,
@@ -189,7 +190,8 @@ static int wait_async_op(struct tcrypt_result *tr, int ret)
 	return ret;
 }
 
-static int __test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
+static int __test_hash(struct crypto_ahash *tfm,
+		       const struct hash_testvec *template,
 		       unsigned int tcount, bool use_digest,
 		       const int align_offset)
 {
@@ -389,7 +391,8 @@ out_nobuf:
 	return ret;
 }
 
-static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
+static int test_hash(struct crypto_ahash *tfm,
+		     const struct hash_testvec *template,
 		     unsigned int tcount, bool use_digest)
 {
 	unsigned int alignmask;
@@ -417,7 +420,7 @@ static int test_hash(struct crypto_ahash *tfm, struct hash_testvec *template,
 }
 
 static int __test_aead(struct crypto_aead *tfm, int enc,
-		       struct aead_testvec *template, unsigned int tcount,
+		       const struct aead_testvec *template, unsigned int tcount,
 		       const bool diff_dst, const int align_offset)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_aead_tfm(tfm));
@@ -799,7 +802,7 @@ out_noxbuf:
 }
 
 static int test_aead(struct crypto_aead *tfm, int enc,
-		     struct aead_testvec *template, unsigned int tcount)
+		     const struct aead_testvec *template, unsigned int tcount)
 {
 	unsigned int alignmask;
 	int ret;
@@ -832,11 +835,12 @@ static int test_aead(struct crypto_aead *tfm, int enc,
 }
 
 static int test_cipher(struct crypto_cipher *tfm, int enc,
-		       struct cipher_testvec *template, unsigned int tcount)
+		       const struct cipher_testvec *template,
+		       unsigned int tcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_cipher_tfm(tfm));
 	unsigned int i, j, k;
-	char *q;
+	const char *q;
 	const char *e;
 	void *data;
 	char *xbuf[XBUFSIZE];
@@ -907,7 +911,8 @@ out_nobuf:
 }
 
 static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
-			   struct cipher_testvec *template, unsigned int tcount,
+			   const struct cipher_testvec *template,
+			   unsigned int tcount,
 			   const bool diff_dst, const int align_offset)
 {
 	const char *algo =
@@ -1154,7 +1159,8 @@ out_nobuf:
 }
 
 static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
-			 struct cipher_testvec *template, unsigned int tcount)
+			 const struct cipher_testvec *template,
+			 unsigned int tcount)
 {
 	unsigned int alignmask;
 	int ret;
@@ -1186,8 +1192,10 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
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
@@ -1267,8 +1275,8 @@ out:
 }
 
 static int test_pcomp(struct crypto_pcomp *tfm,
-		      struct pcomp_testvec *ctemplate,
-		      struct pcomp_testvec *dtemplate, int ctcount,
+		      const struct pcomp_testvec *ctemplate,
+		      const struct pcomp_testvec *dtemplate, int ctcount,
 		      int dtcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_pcomp_tfm(tfm));
@@ -1443,8 +1451,8 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 }
 
 
-static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
-		      unsigned int tcount)
+static int test_cprng(struct crypto_rng *tfm,
+		      const struct cprng_testvec *template, unsigned int tcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
 	int err = 0, i, j, seedsize;
@@ -1726,7 +1734,7 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 }
 
 
-static int drbg_cavs_test(struct drbg_testvec *test, int pr,
+static int drbg_cavs_test(const struct drbg_testvec *test, int pr,
 			  const char *driver, u32 type, u32 mask)
 {
 	int ret = -EAGAIN;
@@ -1800,7 +1808,7 @@ static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
 	int err = 0;
 	int pr = 0;
 	int i = 0;
-	struct drbg_testvec *template = desc->suite.drbg.vecs;
+	const struct drbg_testvec *template = desc->suite.drbg.vecs;
 	unsigned int tcount = desc->suite.drbg.count;
 
 	if (0 == memcmp(driver, "drbg_pr_", 8))
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 62e2485b..306a33b2 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -37,9 +37,9 @@
 
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
@@ -47,10 +47,10 @@ struct hash_testvec {
 };
 
 struct cipher_testvec {
-	char *key;
-	char *iv;
-	char *input;
-	char *result;
+	const char *key;
+	const char *iv;
+	const char *input;
+	const char *result;
 	unsigned short tap[MAX_TAP];
 	int np;
 	unsigned char also_non_np;
@@ -62,11 +62,11 @@ struct cipher_testvec {
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
@@ -81,10 +81,10 @@ struct aead_testvec {
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
@@ -93,28 +93,28 @@ struct cprng_testvec {
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
 
-static char zeroed_string[48];
+static const char zeroed_string[48];
 
 /*
  * MD4 test vectors from RFC1320
  */
 #define MD4_TEST_VECTORS	7
 
-static struct hash_testvec md4_tv_template [] = {
+static const struct hash_testvec md4_tv_template [] = {
 	{
 		.plaintext = "",
 		.digest	= "\x31\xd6\xcf\xe0\xd1\x6a\xe9\x31"
@@ -160,7 +160,7 @@ static struct hash_testvec md4_tv_template [] = {
  */
 #define MD5_TEST_VECTORS	7
 
-static struct hash_testvec md5_tv_template[] = {
+static const struct hash_testvec md5_tv_template[] = {
 	{
 		.digest	= "\xd4\x1d\x8c\xd9\x8f\x00\xb2\x04"
 			  "\xe9\x80\x09\x98\xec\xf8\x42\x7e",
@@ -206,7 +206,7 @@ static struct hash_testvec md5_tv_template[] = {
  */
 #define RMD128_TEST_VECTORS     10
 
-static struct hash_testvec rmd128_tv_template[] = {
+static const struct hash_testvec rmd128_tv_template[] = {
 	{
 		.digest	= "\xcd\xf2\x62\x13\xa1\x50\xdc\x3e"
 			  "\xcb\x61\x0f\x18\xf6\xb3\x8b\x46",
@@ -270,7 +270,7 @@ static struct hash_testvec rmd128_tv_template[] = {
  */
 #define RMD160_TEST_VECTORS     10
 
-static struct hash_testvec rmd160_tv_template[] = {
+static const struct hash_testvec rmd160_tv_template[] = {
 	{
 		.digest	= "\x9c\x11\x85\xa5\xc5\xe9\xfc\x54\x61\x28"
 			  "\x08\x97\x7e\xe8\xf5\x48\xb2\x25\x8d\x31",
@@ -334,7 +334,7 @@ static struct hash_testvec rmd160_tv_template[] = {
  */
 #define RMD256_TEST_VECTORS     8
 
-static struct hash_testvec rmd256_tv_template[] = {
+static const struct hash_testvec rmd256_tv_template[] = {
 	{
 		.digest	= "\x02\xba\x4c\x4e\x5f\x8e\xcd\x18"
 			  "\x77\xfc\x52\xd6\x4d\x30\xe3\x7a"
@@ -402,7 +402,7 @@ static struct hash_testvec rmd256_tv_template[] = {
  */
 #define RMD320_TEST_VECTORS     8
 
-static struct hash_testvec rmd320_tv_template[] = {
+static const struct hash_testvec rmd320_tv_template[] = {
 	{
 		.digest	= "\x22\xd6\x5d\x56\x61\x53\x6c\xdc\x75\xc1"
 			  "\xfd\xf5\xc6\xde\x7b\x41\xb9\xf2\x73\x25"
@@ -466,7 +466,7 @@ static struct hash_testvec rmd320_tv_template[] = {
 };
 
 #define CRCT10DIF_TEST_VECTORS	3
-static struct hash_testvec crct10dif_tv_template[] = {
+static const struct hash_testvec crct10dif_tv_template[] = {
 	{
 		.plaintext = "abc",
 		.psize  = 3,
@@ -504,7 +504,7 @@ static struct hash_testvec crct10dif_tv_template[] = {
  */
 #define SHA1_TEST_VECTORS	6
 
-static struct hash_testvec sha1_tv_template[] = {
+static const struct hash_testvec sha1_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -696,7 +696,7 @@ static struct hash_testvec sha1_tv_template[] = {
  */
 #define SHA224_TEST_VECTORS     5
 
-static struct hash_testvec sha224_tv_template[] = {
+static const struct hash_testvec sha224_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -870,7 +870,7 @@ static struct hash_testvec sha224_tv_template[] = {
  */
 #define SHA256_TEST_VECTORS	5
 
-static struct hash_testvec sha256_tv_template[] = {
+static const struct hash_testvec sha256_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1043,7 +1043,7 @@ static struct hash_testvec sha256_tv_template[] = {
  */
 #define SHA384_TEST_VECTORS	6
 
-static struct hash_testvec sha384_tv_template[] = {
+static const struct hash_testvec sha384_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1237,7 +1237,7 @@ static struct hash_testvec sha384_tv_template[] = {
  */
 #define SHA512_TEST_VECTORS	6
 
-static struct hash_testvec sha512_tv_template[] = {
+static const struct hash_testvec sha512_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1446,7 +1446,7 @@ static struct hash_testvec sha512_tv_template[] = {
  */
 #define WP512_TEST_VECTORS	8
 
-static struct hash_testvec wp512_tv_template[] = {
+static const struct hash_testvec wp512_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1544,7 +1544,7 @@ static struct hash_testvec wp512_tv_template[] = {
 
 #define WP384_TEST_VECTORS	8
 
-static struct hash_testvec wp384_tv_template[] = {
+static const struct hash_testvec wp384_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1626,7 +1626,7 @@ static struct hash_testvec wp384_tv_template[] = {
 
 #define WP256_TEST_VECTORS	8
 
-static struct hash_testvec wp256_tv_template[] = {
+static const struct hash_testvec wp256_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1695,7 +1695,7 @@ static struct hash_testvec wp256_tv_template[] = {
  */
 #define TGR192_TEST_VECTORS	6
 
-static struct hash_testvec tgr192_tv_template[] = {
+static const struct hash_testvec tgr192_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1740,7 +1740,7 @@ static struct hash_testvec tgr192_tv_template[] = {
 
 #define TGR160_TEST_VECTORS	6
 
-static struct hash_testvec tgr160_tv_template[] = {
+static const struct hash_testvec tgr160_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1785,7 +1785,7 @@ static struct hash_testvec tgr160_tv_template[] = {
 
 #define TGR128_TEST_VECTORS	6
 
-static struct hash_testvec tgr128_tv_template[] = {
+static const struct hash_testvec tgr128_tv_template[] = {
 	{
 		.plaintext = "",
 		.psize	= 0,
@@ -1824,7 +1824,7 @@ static struct hash_testvec tgr128_tv_template[] = {
 
 #define GHASH_TEST_VECTORS 5
 
-static struct hash_testvec ghash_tv_template[] =
+static const struct hash_testvec ghash_tv_template[] =
 {
 	{
 		.key	= "\xdf\xa6\xbf\x4d\xed\x81\xdb\x03"
@@ -1884,7 +1884,7 @@ static struct hash_testvec ghash_tv_template[] =
  */
 #define HMAC_MD5_TEST_VECTORS	7
 
-static struct hash_testvec hmac_md5_tv_template[] =
+static const struct hash_testvec hmac_md5_tv_template[] =
 {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
@@ -1966,7 +1966,7 @@ static struct hash_testvec hmac_md5_tv_template[] =
  */
 #define HMAC_RMD128_TEST_VECTORS	7
 
-static struct hash_testvec hmac_rmd128_tv_template[] = {
+static const struct hash_testvec hmac_rmd128_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
 		.ksize	= 16,
@@ -2047,7 +2047,7 @@ static struct hash_testvec hmac_rmd128_tv_template[] = {
  */
 #define HMAC_RMD160_TEST_VECTORS	7
 
-static struct hash_testvec hmac_rmd160_tv_template[] = {
+static const struct hash_testvec hmac_rmd160_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
 		.ksize	= 20,
@@ -2128,7 +2128,7 @@ static struct hash_testvec hmac_rmd160_tv_template[] = {
  */
 #define HMAC_SHA1_TEST_VECTORS	7
 
-static struct hash_testvec hmac_sha1_tv_template[] = {
+static const struct hash_testvec hmac_sha1_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
 		.ksize	= 20,
@@ -2211,7 +2211,7 @@ static struct hash_testvec hmac_sha1_tv_template[] = {
  */
 #define HMAC_SHA224_TEST_VECTORS    4
 
-static struct hash_testvec hmac_sha224_tv_template[] = {
+static const struct hash_testvec hmac_sha224_tv_template[] = {
 	{
 		.key    = "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			"\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -2326,7 +2326,7 @@ static struct hash_testvec hmac_sha224_tv_template[] = {
  */
 #define HMAC_SHA256_TEST_VECTORS	10
 
-static struct hash_testvec hmac_sha256_tv_template[] = {
+static const struct hash_testvec hmac_sha256_tv_template[] = {
 	{
 		.key	= "\x01\x02\x03\x04\x05\x06\x07\x08"
 			  "\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10"
@@ -2463,7 +2463,7 @@ static struct hash_testvec hmac_sha256_tv_template[] = {
 
 #define CMAC_AES_TEST_VECTORS 6
 
-static struct hash_testvec aes_cmac128_tv_template[] = {
+static const struct hash_testvec aes_cmac128_tv_template[] = {
 	{ /* From NIST Special Publication 800-38B, AES-128 */
 		.key		= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
 				  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
@@ -2540,7 +2540,7 @@ static struct hash_testvec aes_cmac128_tv_template[] = {
 
 #define CMAC_DES3_EDE_TEST_VECTORS 4
 
-static struct hash_testvec des3_ede_cmac64_tv_template[] = {
+static const struct hash_testvec des3_ede_cmac64_tv_template[] = {
 /*
  * From NIST Special Publication 800-38B, Three Key TDEA
  * Corrected test vectors from:
@@ -2588,7 +2588,7 @@ static struct hash_testvec des3_ede_cmac64_tv_template[] = {
 
 #define XCBC_AES_TEST_VECTORS 6
 
-static struct hash_testvec aes_xcbc128_tv_template[] = {
+static const struct hash_testvec aes_xcbc128_tv_template[] = {
 	{
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -2683,7 +2683,7 @@ static char vmac_string6[129] = {'p', 't', '*', '7', 'l',
 				 'i', '!', '#', 'w', '0',
 				 'z', '/', '4', 'A', 'n'};
 
-static struct hash_testvec aes_vmac128_tv_template[] = {
+static const struct hash_testvec aes_vmac128_tv_template[] = {
 	{
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -2763,7 +2763,7 @@ static struct hash_testvec aes_vmac128_tv_template[] = {
 
 #define HMAC_SHA384_TEST_VECTORS	4
 
-static struct hash_testvec hmac_sha384_tv_template[] = {
+static const struct hash_testvec hmac_sha384_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -2863,7 +2863,7 @@ static struct hash_testvec hmac_sha384_tv_template[] = {
 
 #define HMAC_SHA512_TEST_VECTORS	4
 
-static struct hash_testvec hmac_sha512_tv_template[] = {
+static const struct hash_testvec hmac_sha512_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
 			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -2984,7 +2984,7 @@ static struct hash_testvec hmac_sha512_tv_template[] = {
 #define DES3_EDE_CTR_ENC_TEST_VECTORS	2
 #define DES3_EDE_CTR_DEC_TEST_VECTORS	2
 
-static struct cipher_testvec des_enc_tv_template[] = {
+static const struct cipher_testvec des_enc_tv_template[] = {
 	{ /* From Applied Cryptography */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -3158,7 +3158,7 @@ static struct cipher_testvec des_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des_dec_tv_template[] = {
+static const struct cipher_testvec des_dec_tv_template[] = {
 	{ /* From Applied Cryptography */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -3268,7 +3268,7 @@ static struct cipher_testvec des_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des_cbc_enc_tv_template[] = {
+static const struct cipher_testvec des_cbc_enc_tv_template[] = {
 	{ /* From OpenSSL */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -3394,7 +3394,7 @@ static struct cipher_testvec des_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des_cbc_dec_tv_template[] = {
+static const struct cipher_testvec des_cbc_dec_tv_template[] = {
 	{ /* FIPS Pub 81 */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -3503,7 +3503,7 @@ static struct cipher_testvec des_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des_ctr_enc_tv_template[] = {
+static const struct cipher_testvec des_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
@@ -3649,7 +3649,7 @@ static struct cipher_testvec des_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des_ctr_dec_tv_template[] = {
+static const struct cipher_testvec des_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
@@ -3795,7 +3795,7 @@ static struct cipher_testvec des_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_enc_tv_template[] = {
+static const struct cipher_testvec des3_ede_enc_tv_template[] = {
 	{ /* These are from openssl */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\x55\x55\x55\x55\x55\x55\x55\x55"
@@ -3960,7 +3960,7 @@ static struct cipher_testvec des3_ede_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_dec_tv_template[] = {
+static const struct cipher_testvec des3_ede_dec_tv_template[] = {
 	{ /* These are from openssl */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\x55\x55\x55\x55\x55\x55\x55\x55"
@@ -4125,7 +4125,7 @@ static struct cipher_testvec des3_ede_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_cbc_enc_tv_template[] = {
+static const struct cipher_testvec des3_ede_cbc_enc_tv_template[] = {
 	{ /* Generated from openssl */
 		.key	= "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24"
 			  "\x44\x4D\x99\x5A\x12\xD6\x40\xC0"
@@ -4305,7 +4305,7 @@ static struct cipher_testvec des3_ede_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_cbc_dec_tv_template[] = {
+static const struct cipher_testvec des3_ede_cbc_dec_tv_template[] = {
 	{ /* Generated from openssl */
 		.key	= "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24"
 			  "\x44\x4D\x99\x5A\x12\xD6\x40\xC0"
@@ -4485,7 +4485,7 @@ static struct cipher_testvec des3_ede_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_ctr_enc_tv_template[] = {
+static const struct cipher_testvec des3_ede_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x9C\xD6\xF3\x9C\xB9\x5A\x67\x00"
 			  "\x5A\x67\x00\x2D\xCE\xEB\x2D\xCE"
@@ -4763,7 +4763,7 @@ static struct cipher_testvec des3_ede_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec des3_ede_ctr_dec_tv_template[] = {
+static const struct cipher_testvec des3_ede_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x9C\xD6\xF3\x9C\xB9\x5A\x67\x00"
 			  "\x5A\x67\x00\x2D\xCE\xEB\x2D\xCE"
@@ -5051,7 +5051,7 @@ static struct cipher_testvec des3_ede_ctr_dec_tv_template[] = {
 #define BF_CTR_ENC_TEST_VECTORS	2
 #define BF_CTR_DEC_TEST_VECTORS	2
 
-static struct cipher_testvec bf_enc_tv_template[] = {
+static const struct cipher_testvec bf_enc_tv_template[] = {
 	{ /* DES test vectors from OpenSSL */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.klen	= 8,
@@ -5243,7 +5243,7 @@ static struct cipher_testvec bf_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec bf_dec_tv_template[] = {
+static const struct cipher_testvec bf_dec_tv_template[] = {
 	{ /* DES test vectors from OpenSSL */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.klen	= 8,
@@ -5435,7 +5435,7 @@ static struct cipher_testvec bf_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec bf_cbc_enc_tv_template[] = {
+static const struct cipher_testvec bf_cbc_enc_tv_template[] = {
 	{ /* From OpenSSL */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\xf0\xe1\xd2\xc3\xb4\xa5\x96\x87",
@@ -5592,7 +5592,7 @@ static struct cipher_testvec bf_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec bf_cbc_dec_tv_template[] = {
+static const struct cipher_testvec bf_cbc_dec_tv_template[] = {
 	{ /* From OpenSSL */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\xf0\xe1\xd2\xc3\xb4\xa5\x96\x87",
@@ -5749,7 +5749,7 @@ static struct cipher_testvec bf_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec bf_ctr_enc_tv_template[] = {
+static const struct cipher_testvec bf_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -6161,7 +6161,7 @@ static struct cipher_testvec bf_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec bf_ctr_dec_tv_template[] = {
+static const struct cipher_testvec bf_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -6587,7 +6587,7 @@ static struct cipher_testvec bf_ctr_dec_tv_template[] = {
 #define TF_XTS_ENC_TEST_VECTORS		5
 #define TF_XTS_DEC_TEST_VECTORS		5
 
-static struct cipher_testvec tf_enc_tv_template[] = {
+static const struct cipher_testvec tf_enc_tv_template[] = {
 	{
 		.key	= zeroed_string,
 		.klen	= 16,
@@ -6755,7 +6755,7 @@ static struct cipher_testvec tf_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_dec_tv_template[] = {
+static const struct cipher_testvec tf_dec_tv_template[] = {
 	{
 		.key	= zeroed_string,
 		.klen	= 16,
@@ -6923,7 +6923,7 @@ static struct cipher_testvec tf_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_cbc_enc_tv_template[] = {
+static const struct cipher_testvec tf_cbc_enc_tv_template[] = {
 	{ /* Generated with Nettle */
 		.key	= zeroed_string,
 		.klen	= 16,
@@ -7106,7 +7106,7 @@ static struct cipher_testvec tf_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_cbc_dec_tv_template[] = {
+static const struct cipher_testvec tf_cbc_dec_tv_template[] = {
 	{ /* Reverse of the first four above */
 		.key	= zeroed_string,
 		.klen	= 16,
@@ -7289,7 +7289,7 @@ static struct cipher_testvec tf_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_ctr_enc_tv_template[] = {
+static const struct cipher_testvec tf_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -7700,7 +7700,7 @@ static struct cipher_testvec tf_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_ctr_dec_tv_template[] = {
+static const struct cipher_testvec tf_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -8111,7 +8111,7 @@ static struct cipher_testvec tf_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_lrw_enc_tv_template[] = {
+static const struct cipher_testvec tf_lrw_enc_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	{
 		.key	= "\x45\x62\xac\x25\xf8\x28\x17\x6d"
@@ -8363,7 +8363,7 @@ static struct cipher_testvec tf_lrw_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_lrw_dec_tv_template[] = {
+static const struct cipher_testvec tf_lrw_dec_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -8616,7 +8616,7 @@ static struct cipher_testvec tf_lrw_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_xts_enc_tv_template[] = {
+static const struct cipher_testvec tf_xts_enc_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 {
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -8958,7 +8958,7 @@ static struct cipher_testvec tf_xts_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tf_xts_dec_tv_template[] = {
+static const struct cipher_testvec tf_xts_dec_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -9323,7 +9323,7 @@ static struct cipher_testvec tf_xts_dec_tv_template[] = {
 #define SERPENT_XTS_ENC_TEST_VECTORS	5
 #define SERPENT_XTS_DEC_TEST_VECTORS	5
 
-static struct cipher_testvec serpent_enc_tv_template[] = {
+static const struct cipher_testvec serpent_enc_tv_template[] = {
 	{
 		.input	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -9499,7 +9499,7 @@ static struct cipher_testvec serpent_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tnepres_enc_tv_template[] = {
+static const struct cipher_testvec tnepres_enc_tv_template[] = {
 	{ /* KeySize=128, PT=0, I=1 */
 		.input	= "\x00\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00",
@@ -9549,7 +9549,7 @@ static struct cipher_testvec tnepres_enc_tv_template[] = {
 };
 
 
-static struct cipher_testvec serpent_dec_tv_template[] = {
+static const struct cipher_testvec serpent_dec_tv_template[] = {
 	{
 		.input	= "\x12\x07\xfc\xce\x9b\xd0\xd6\x47"
 			  "\x6a\xe9\x8f\xbe\xd1\x43\xa0\xe2",
@@ -9725,7 +9725,7 @@ static struct cipher_testvec serpent_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec tnepres_dec_tv_template[] = {
+static const struct cipher_testvec tnepres_dec_tv_template[] = {
 	{
 		.input	= "\x41\xcc\x6b\x31\x59\x31\x45\x97"
 			  "\x6d\x6f\xbb\x38\x4b\x37\x21\x28",
@@ -9766,7 +9766,7 @@ static struct cipher_testvec tnepres_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_cbc_enc_tv_template[] = {
+static const struct cipher_testvec serpent_cbc_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -9907,7 +9907,7 @@ static struct cipher_testvec serpent_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_cbc_dec_tv_template[] = {
+static const struct cipher_testvec serpent_cbc_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -10048,7 +10048,7 @@ static struct cipher_testvec serpent_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_ctr_enc_tv_template[] = {
+static const struct cipher_testvec serpent_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -10459,7 +10459,7 @@ static struct cipher_testvec serpent_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_ctr_dec_tv_template[] = {
+static const struct cipher_testvec serpent_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -10870,7 +10870,7 @@ static struct cipher_testvec serpent_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_lrw_enc_tv_template[] = {
+static const struct cipher_testvec serpent_lrw_enc_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	{
 		.key	= "\x45\x62\xac\x25\xf8\x28\x17\x6d"
@@ -11122,7 +11122,7 @@ static struct cipher_testvec serpent_lrw_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_lrw_dec_tv_template[] = {
+static const struct cipher_testvec serpent_lrw_dec_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -11375,7 +11375,7 @@ static struct cipher_testvec serpent_lrw_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_xts_enc_tv_template[] = {
+static const struct cipher_testvec serpent_xts_enc_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 	{
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -11717,7 +11717,7 @@ static struct cipher_testvec serpent_xts_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec serpent_xts_dec_tv_template[] = {
+static const struct cipher_testvec serpent_xts_dec_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -12072,7 +12072,7 @@ static struct cipher_testvec serpent_xts_dec_tv_template[] = {
 #define CAST6_XTS_ENC_TEST_VECTORS	1
 #define CAST6_XTS_DEC_TEST_VECTORS	1
 
-static struct cipher_testvec cast6_enc_tv_template[] = {
+static const struct cipher_testvec cast6_enc_tv_template[] = {
 	{
 		.key	= "\x23\x42\xbb\x9e\xfa\x38\x54\x2c"
 			  "\x0a\xf7\x56\x47\xf2\x9f\x61\x5d",
@@ -12243,7 +12243,7 @@ static struct cipher_testvec cast6_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_dec_tv_template[] = {
+static const struct cipher_testvec cast6_dec_tv_template[] = {
 	{
 		.key	= "\x23\x42\xbb\x9e\xfa\x38\x54\x2c"
 			  "\x0a\xf7\x56\x47\xf2\x9f\x61\x5d",
@@ -12414,7 +12414,7 @@ static struct cipher_testvec cast6_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_cbc_enc_tv_template[] = {
+static const struct cipher_testvec cast6_cbc_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -12555,7 +12555,7 @@ static struct cipher_testvec cast6_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_cbc_dec_tv_template[] = {
+static const struct cipher_testvec cast6_cbc_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -12696,7 +12696,7 @@ static struct cipher_testvec cast6_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_ctr_enc_tv_template[] = {
+static const struct cipher_testvec cast6_ctr_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -12853,7 +12853,7 @@ static struct cipher_testvec cast6_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_ctr_dec_tv_template[] = {
+static const struct cipher_testvec cast6_ctr_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -13010,7 +13010,7 @@ static struct cipher_testvec cast6_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_lrw_enc_tv_template[] = {
+static const struct cipher_testvec cast6_lrw_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\xf8\xd4\x76\xff\xd6\x46\xee\x6c"
 			  "\x23\x84\xcb\x1c\x77\xd6\x19\x5d"
@@ -13157,7 +13157,7 @@ static struct cipher_testvec cast6_lrw_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_lrw_dec_tv_template[] = {
+static const struct cipher_testvec cast6_lrw_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\xf8\xd4\x76\xff\xd6\x46\xee\x6c"
 			  "\x23\x84\xcb\x1c\x77\xd6\x19\x5d"
@@ -13304,7 +13304,7 @@ static struct cipher_testvec cast6_lrw_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_xts_enc_tv_template[] = {
+static const struct cipher_testvec cast6_xts_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x27\x18\x28\x18\x28\x45\x90\x45"
 			  "\x23\x53\x60\x28\x74\x71\x35\x26"
@@ -13453,7 +13453,7 @@ static struct cipher_testvec cast6_xts_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast6_xts_dec_tv_template[] = {
+static const struct cipher_testvec cast6_xts_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x27\x18\x28\x18\x28\x45\x90\x45"
 			  "\x23\x53\x60\x28\x74\x71\x35\x26"
@@ -13638,7 +13638,7 @@ static struct cipher_testvec cast6_xts_dec_tv_template[] = {
 #define AES_CCM_4309_ENC_TEST_VECTORS 7
 #define AES_CCM_4309_DEC_TEST_VECTORS 10
 
-static struct cipher_testvec aes_enc_tv_template[] = {
+static const struct cipher_testvec aes_enc_tv_template[] = {
 	{ /* From FIPS-197 */
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -13810,7 +13810,7 @@ static struct cipher_testvec aes_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_dec_tv_template[] = {
+static const struct cipher_testvec aes_dec_tv_template[] = {
 	{ /* From FIPS-197 */
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
 			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
@@ -13982,7 +13982,7 @@ static struct cipher_testvec aes_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_cbc_enc_tv_template[] = {
+static const struct cipher_testvec aes_cbc_enc_tv_template[] = {
 	{ /* From RFC 3602 */
 		.key    = "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
 			  "\x51\x2e\x03\xd5\x34\x12\x00\x06",
@@ -14201,7 +14201,7 @@ static struct cipher_testvec aes_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_cbc_dec_tv_template[] = {
+static const struct cipher_testvec aes_cbc_dec_tv_template[] = {
 	{ /* From RFC 3602 */
 		.key    = "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
 			  "\x51\x2e\x03\xd5\x34\x12\x00\x06",
@@ -14420,7 +14420,7 @@ static struct cipher_testvec aes_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct aead_testvec hmac_md5_ecb_cipher_null_enc_tv_template[] = {
+static const struct aead_testvec hmac_md5_ecb_cipher_null_enc_tv_template[] = {
 	{ /* Input data from RFC 2410 Case 1 */
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -14462,7 +14462,7 @@ static struct aead_testvec hmac_md5_ecb_cipher_null_enc_tv_template[] = {
 	},
 };
 
-static struct aead_testvec hmac_md5_ecb_cipher_null_dec_tv_template[] = {
+static const struct aead_testvec hmac_md5_ecb_cipher_null_dec_tv_template[] = {
 	{
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -14504,7 +14504,7 @@ static struct aead_testvec hmac_md5_ecb_cipher_null_dec_tv_template[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 	{ /* RFC 3602 Case 1 */
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -14753,7 +14753,7 @@ static struct aead_testvec hmac_sha1_aes_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha1_ecb_cipher_null_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha1_ecb_cipher_null_enc_tv_temp[] = {
 	{ /* Input data from RFC 2410 Case 1 */
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -14799,7 +14799,7 @@ static struct aead_testvec hmac_sha1_ecb_cipher_null_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha1_ecb_cipher_null_dec_tv_temp[] = {
+static const struct aead_testvec hmac_sha1_ecb_cipher_null_dec_tv_temp[] = {
 	{
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -14845,7 +14845,7 @@ static struct aead_testvec hmac_sha1_ecb_cipher_null_dec_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 	{ /* RFC 3602 Case 1 */
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15108,7 +15108,7 @@ static struct aead_testvec hmac_sha256_aes_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 	{ /* RFC 3602 Case 1 */
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15429,7 +15429,7 @@ static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 
 #define HMAC_SHA1_DES_CBC_ENC_TEST_VEC	1
 
-static struct aead_testvec hmac_sha1_des_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha1_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15489,7 +15489,7 @@ static struct aead_testvec hmac_sha1_des_cbc_enc_tv_temp[] = {
 
 #define HMAC_SHA224_DES_CBC_ENC_TEST_VEC	1
 
-static struct aead_testvec hmac_sha224_des_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha224_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15549,7 +15549,7 @@ static struct aead_testvec hmac_sha224_des_cbc_enc_tv_temp[] = {
 
 #define HMAC_SHA256_DES_CBC_ENC_TEST_VEC	1
 
-static struct aead_testvec hmac_sha256_des_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha256_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15611,7 +15611,7 @@ static struct aead_testvec hmac_sha256_des_cbc_enc_tv_temp[] = {
 
 #define HMAC_SHA384_DES_CBC_ENC_TEST_VEC	1
 
-static struct aead_testvec hmac_sha384_des_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha384_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15677,7 +15677,7 @@ static struct aead_testvec hmac_sha384_des_cbc_enc_tv_temp[] = {
 
 #define HMAC_SHA512_DES_CBC_ENC_TEST_VEC	1
 
-static struct aead_testvec hmac_sha512_des_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha512_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15747,7 +15747,7 @@ static struct aead_testvec hmac_sha512_des_cbc_enc_tv_temp[] = {
 
 #define HMAC_SHA1_DES3_EDE_CBC_ENC_TEST_VEC	1
 
-static struct aead_testvec hmac_sha1_des3_ede_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha1_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15809,7 +15809,7 @@ static struct aead_testvec hmac_sha1_des3_ede_cbc_enc_tv_temp[] = {
 
 #define HMAC_SHA224_DES3_EDE_CBC_ENC_TEST_VEC	1
 
-static struct aead_testvec hmac_sha224_des3_ede_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha224_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15871,7 +15871,7 @@ static struct aead_testvec hmac_sha224_des3_ede_cbc_enc_tv_temp[] = {
 
 #define HMAC_SHA256_DES3_EDE_CBC_ENC_TEST_VEC	1
 
-static struct aead_testvec hmac_sha256_des3_ede_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha256_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -15935,7 +15935,7 @@ static struct aead_testvec hmac_sha256_des3_ede_cbc_enc_tv_temp[] = {
 
 #define HMAC_SHA384_DES3_EDE_CBC_ENC_TEST_VEC	1
 
-static struct aead_testvec hmac_sha384_des3_ede_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha384_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -16003,7 +16003,7 @@ static struct aead_testvec hmac_sha384_des3_ede_cbc_enc_tv_temp[] = {
 
 #define HMAC_SHA512_DES3_EDE_CBC_ENC_TEST_VEC	1
 
-static struct aead_testvec hmac_sha512_des3_ede_cbc_enc_tv_temp[] = {
+static const struct aead_testvec hmac_sha512_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
 		.key    = "\x08\x00"		/* rta length */
@@ -16073,7 +16073,7 @@ static struct aead_testvec hmac_sha512_des3_ede_cbc_enc_tv_temp[] = {
 	},
 };
 
-static struct cipher_testvec aes_lrw_enc_tv_template[] = {
+static const struct cipher_testvec aes_lrw_enc_tv_template[] = {
 	/* from http://grouper.ieee.org/groups/1619/email/pdf00017.pdf */
 	{ /* LRW-32-AES 1 */
 		.key    = "\x45\x62\xac\x25\xf8\x28\x17\x6d"
@@ -16326,7 +16326,7 @@ static struct cipher_testvec aes_lrw_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec aes_lrw_dec_tv_template[] = {
+static const struct cipher_testvec aes_lrw_dec_tv_template[] = {
 	/* from http://grouper.ieee.org/groups/1619/email/pdf00017.pdf */
 	/* same as enc vectors with input and result reversed */
 	{ /* LRW-32-AES 1 */
@@ -16580,7 +16580,7 @@ static struct cipher_testvec aes_lrw_dec_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec aes_xts_enc_tv_template[] = {
+static const struct cipher_testvec aes_xts_enc_tv_template[] = {
 	/* http://grouper.ieee.org/groups/1619/email/pdf00086.pdf */
 	{ /* XTS-AES 1 */
 		.key    = "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -16922,7 +16922,7 @@ static struct cipher_testvec aes_xts_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec aes_xts_dec_tv_template[] = {
+static const struct cipher_testvec aes_xts_dec_tv_template[] = {
 	/* http://grouper.ieee.org/groups/1619/email/pdf00086.pdf */
 	{ /* XTS-AES 1 */
 		.key    = "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -17265,7 +17265,7 @@ static struct cipher_testvec aes_xts_dec_tv_template[] = {
 };
 
 
-static struct cipher_testvec aes_ctr_enc_tv_template[] = {
+static const struct cipher_testvec aes_ctr_enc_tv_template[] = {
 	{ /* From NIST Special Publication 800-38A, Appendix F.5 */
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
 			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
@@ -17620,7 +17620,7 @@ static struct cipher_testvec aes_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_ctr_dec_tv_template[] = {
+static const struct cipher_testvec aes_ctr_dec_tv_template[] = {
 	{ /* From NIST Special Publication 800-38A, Appendix F.5 */
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
 			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
@@ -17975,7 +17975,7 @@ static struct cipher_testvec aes_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_ctr_rfc3686_enc_tv_template[] = {
+static const struct cipher_testvec aes_ctr_rfc3686_enc_tv_template[] = {
 	{ /* From RFC 3686 */
 		.key	= "\xae\x68\x52\xf8\x12\x10\x67\xcc"
 			  "\x4b\xf7\xa5\x76\x55\x77\xf3\x9e"
@@ -19107,7 +19107,7 @@ static struct cipher_testvec aes_ctr_rfc3686_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_ctr_rfc3686_dec_tv_template[] = {
+static const struct cipher_testvec aes_ctr_rfc3686_dec_tv_template[] = {
 	{ /* From RFC 3686 */
 		.key	= "\xae\x68\x52\xf8\x12\x10\x67\xcc"
 			  "\x4b\xf7\xa5\x76\x55\x77\xf3\x9e"
@@ -19198,7 +19198,7 @@ static struct cipher_testvec aes_ctr_rfc3686_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec aes_ofb_enc_tv_template[] = {
+static const struct cipher_testvec aes_ofb_enc_tv_template[] = {
 	 /* From NIST Special Publication 800-38A, Appendix F.5 */
 	{
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
@@ -19227,7 +19227,7 @@ static struct cipher_testvec aes_ofb_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec aes_ofb_dec_tv_template[] = {
+static const struct cipher_testvec aes_ofb_dec_tv_template[] = {
 	 /* From NIST Special Publication 800-38A, Appendix F.5 */
 	{
 		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
@@ -19256,7 +19256,7 @@ static struct cipher_testvec aes_ofb_dec_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_enc_tv_template[] = {
+static const struct aead_testvec aes_gcm_enc_tv_template[] = {
 	{ /* From McGrew & Viega - http://citeseer.ist.psu.edu/656989.html */
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -19416,7 +19416,7 @@ static struct aead_testvec aes_gcm_enc_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_dec_tv_template[] = {
+static const struct aead_testvec aes_gcm_dec_tv_template[] = {
 	{ /* From McGrew & Viega - http://citeseer.ist.psu.edu/656989.html */
 		.key    = zeroed_string,
 		.klen	= 32,
@@ -19618,7 +19618,7 @@ static struct aead_testvec aes_gcm_dec_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_rfc4106_enc_tv_template[] = {
+static const struct aead_testvec aes_gcm_rfc4106_enc_tv_template[] = {
         { /* Generated using Crypto++ */
 		.key    = zeroed_string,
 		.klen	= 20,
@@ -19792,7 +19792,7 @@ static struct aead_testvec aes_gcm_rfc4106_enc_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_rfc4106_dec_tv_template[] = {
+static const struct aead_testvec aes_gcm_rfc4106_dec_tv_template[] = {
         { /* Generated using Crypto++ */
 		.key    = zeroed_string,
 		.klen	= 20,
@@ -19968,7 +19968,7 @@ static struct aead_testvec aes_gcm_rfc4106_dec_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_rfc4543_enc_tv_template[] = {
+static const struct aead_testvec aes_gcm_rfc4543_enc_tv_template[] = {
 	{ /* From draft-mcgrew-gcm-test-01 */
 		.key	= "\x4c\x80\xcd\xef\xbb\x5d\x10\xda"
 			  "\x90\x6a\xc7\x3c\x36\x13\xa6\x34"
@@ -19998,7 +19998,7 @@ static struct aead_testvec aes_gcm_rfc4543_enc_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_gcm_rfc4543_dec_tv_template[] = {
+static const struct aead_testvec aes_gcm_rfc4543_dec_tv_template[] = {
 	{ /* From draft-mcgrew-gcm-test-01 */
 		.key	= "\x4c\x80\xcd\xef\xbb\x5d\x10\xda"
 			  "\x90\x6a\xc7\x3c\x36\x13\xa6\x34"
@@ -20055,7 +20055,7 @@ static struct aead_testvec aes_gcm_rfc4543_dec_tv_template[] = {
 	},
 };
 
-static struct aead_testvec aes_ccm_enc_tv_template[] = {
+static const struct aead_testvec aes_ccm_enc_tv_template[] = {
 	{ /* From RFC 3610 */
 		.key	= "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
 			  "\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf",
@@ -20206,7 +20206,7 @@ static struct aead_testvec aes_ccm_enc_tv_template[] = {
 	}
 };
 
-static struct aead_testvec aes_ccm_dec_tv_template[] = {
+static const struct aead_testvec aes_ccm_dec_tv_template[] = {
 	{ /* From RFC 3610 */
 		.key	= "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
 			  "\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf",
@@ -20345,7 +20345,7 @@ static struct aead_testvec aes_ccm_dec_tv_template[] = {
  * nb: actual key lengths are (klen - 3), the last 3 bytes are actually
  * part of the nonce which combine w/the iv, but need to be input this way.
  */
-static struct aead_testvec aes_ccm_rfc4309_enc_tv_template[] = {
+static const struct aead_testvec aes_ccm_rfc4309_enc_tv_template[] = {
 	{
 		.key	= "\x83\xac\x54\x66\xc2\xeb\xe5\x05"
 			  "\x2e\x01\xd1\xfc\x5d\x82\x66\x2e"
@@ -20505,7 +20505,7 @@ static struct aead_testvec aes_ccm_rfc4309_enc_tv_template[] = {
 	},
 };
 
-static struct aead_testvec aes_ccm_rfc4309_dec_tv_template[] = {
+static const struct aead_testvec aes_ccm_rfc4309_dec_tv_template[] = {
 	{
 		.key	= "\xab\x2f\x8a\x74\xb7\x1c\xd2\xb1"
 			  "\xff\x80\x2e\x48\x7d\x82\xf8\xb9"
@@ -20711,7 +20711,7 @@ static struct aead_testvec aes_ccm_rfc4309_dec_tv_template[] = {
  */
 #define ANSI_CPRNG_AES_TEST_VECTORS	6
 
-static struct cprng_testvec ansi_cprng_aes_tv_template[] = {
+static const struct cprng_testvec ansi_cprng_aes_tv_template[] = {
 	{
 		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
 			  "\xed\x06\x1c\xab\xb8\xd4\x62\x02",
@@ -20807,7 +20807,7 @@ static struct cprng_testvec ansi_cprng_aes_tv_template[] = {
  * (Hash, HMAC, CTR) are tested with all permutations of use cases (w/ and
  * w/o personalization string, w/ and w/o additional input string).
  */
-static struct drbg_testvec drbg_pr_sha256_tv_template[] = {
+static const struct drbg_testvec drbg_pr_sha256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\x72\x88\x4c\xcd\x6c\x85\x57\x70\xf7\x0b\x8b\x86"
@@ -20965,7 +20965,7 @@ static struct drbg_testvec drbg_pr_sha256_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_pr_hmac_sha256_tv_template[] = {
+static const struct drbg_testvec drbg_pr_hmac_sha256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\x99\x69\xe5\x4b\x47\x03\xff\x31\x78\x5b\x87\x9a"
@@ -21123,7 +21123,7 @@ static struct drbg_testvec drbg_pr_hmac_sha256_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_pr_ctr_aes128_tv_template[] = {
+static const struct drbg_testvec drbg_pr_ctr_aes128_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\xd1\x44\xc6\x61\x81\x6d\xca\x9d\x15\x28\x8a\x42"
@@ -21247,7 +21247,7 @@ static struct drbg_testvec drbg_pr_ctr_aes128_tv_template[] = {
  * (Hash, HMAC, CTR) are tested with all permutations of use cases (w/ and
  * w/o personalization string, w/ and w/o additional input string).
  */
-static struct drbg_testvec drbg_nopr_sha256_tv_template[] = {
+static const struct drbg_testvec drbg_nopr_sha256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\xa6\x5a\xd0\xf3\x45\xdb\x4e\x0e\xff\xe8\x75\xc3"
@@ -21369,7 +21369,7 @@ static struct drbg_testvec drbg_nopr_sha256_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
+static const struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\xca\x85\x19\x11\x34\x93\x84\xbf\xfe\x89\xde\x1c"
@@ -21491,7 +21491,7 @@ static struct drbg_testvec drbg_nopr_hmac_sha256_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_nopr_ctr_aes192_tv_template[] = {
+static const struct drbg_testvec drbg_nopr_ctr_aes192_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\xc3\x5c\x2f\xa2\xa8\x9d\x52\xa1\x1f\xa3\x2a\xa9"
@@ -21515,7 +21515,7 @@ static struct drbg_testvec drbg_nopr_ctr_aes192_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_nopr_ctr_aes256_tv_template[] = {
+static const struct drbg_testvec drbg_nopr_ctr_aes256_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\x36\x40\x19\x40\xfa\x8b\x1f\xba\x91\xa1\x66\x1f"
@@ -21539,7 +21539,7 @@ static struct drbg_testvec drbg_nopr_ctr_aes256_tv_template[] = {
 	},
 };
 
-static struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
+static const struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
 	{
 		.entropy = (unsigned char *)
 			"\x87\xe1\xc5\x32\x99\x7f\x57\xa3\x5c\x28\x6d\xe8"
@@ -21635,7 +21635,7 @@ static struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
 #define CAST5_CTR_ENC_TEST_VECTORS	2
 #define CAST5_CTR_DEC_TEST_VECTORS	2
 
-static struct cipher_testvec cast5_enc_tv_template[] = {
+static const struct cipher_testvec cast5_enc_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x12\x34\x56\x78"
 			  "\x23\x45\x67\x89\x34\x56\x78\x9a",
@@ -21796,7 +21796,7 @@ static struct cipher_testvec cast5_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast5_dec_tv_template[] = {
+static const struct cipher_testvec cast5_dec_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x12\x34\x56\x78"
 			  "\x23\x45\x67\x89\x34\x56\x78\x9a",
@@ -21957,7 +21957,7 @@ static struct cipher_testvec cast5_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast5_cbc_enc_tv_template[] = {
+static const struct cipher_testvec cast5_cbc_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
@@ -22095,7 +22095,7 @@ static struct cipher_testvec cast5_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast5_cbc_dec_tv_template[] = {
+static const struct cipher_testvec cast5_cbc_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
@@ -22233,7 +22233,7 @@ static struct cipher_testvec cast5_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast5_ctr_enc_tv_template[] = {
+static const struct cipher_testvec cast5_ctr_enc_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
@@ -22384,7 +22384,7 @@ static struct cipher_testvec cast5_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec cast5_ctr_dec_tv_template[] = {
+static const struct cipher_testvec cast5_ctr_dec_tv_template[] = {
 	{ /* Generated from TF test vectors */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A",
@@ -22541,7 +22541,7 @@ static struct cipher_testvec cast5_ctr_dec_tv_template[] = {
 #define ARC4_ENC_TEST_VECTORS	7
 #define ARC4_DEC_TEST_VECTORS	7
 
-static struct cipher_testvec arc4_enc_tv_template[] = {
+static const struct cipher_testvec arc4_enc_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -22607,7 +22607,7 @@ static struct cipher_testvec arc4_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec arc4_dec_tv_template[] = {
+static const struct cipher_testvec arc4_dec_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
 		.klen	= 8,
@@ -22679,7 +22679,7 @@ static struct cipher_testvec arc4_dec_tv_template[] = {
 #define TEA_ENC_TEST_VECTORS	4
 #define TEA_DEC_TEST_VECTORS	4
 
-static struct cipher_testvec tea_enc_tv_template[] = {
+static const struct cipher_testvec tea_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -22722,7 +22722,7 @@ static struct cipher_testvec tea_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec tea_dec_tv_template[] = {
+static const struct cipher_testvec tea_dec_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -22771,7 +22771,7 @@ static struct cipher_testvec tea_dec_tv_template[] = {
 #define XTEA_ENC_TEST_VECTORS	4
 #define XTEA_DEC_TEST_VECTORS	4
 
-static struct cipher_testvec xtea_enc_tv_template[] = {
+static const struct cipher_testvec xtea_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -22814,7 +22814,7 @@ static struct cipher_testvec xtea_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec xtea_dec_tv_template[] = {
+static const struct cipher_testvec xtea_dec_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -22863,7 +22863,7 @@ static struct cipher_testvec xtea_dec_tv_template[] = {
 #define KHAZAD_ENC_TEST_VECTORS 5
 #define KHAZAD_DEC_TEST_VECTORS 5
 
-static struct cipher_testvec khazad_enc_tv_template[] = {
+static const struct cipher_testvec khazad_enc_tv_template[] = {
 	{
 		.key	= "\x80\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00",
@@ -22909,7 +22909,7 @@ static struct cipher_testvec khazad_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec khazad_dec_tv_template[] = {
+static const struct cipher_testvec khazad_dec_tv_template[] = {
 	{
 		.key	= "\x80\x00\x00\x00\x00\x00\x00\x00"
 			  "\x00\x00\x00\x00\x00\x00\x00\x00",
@@ -22964,7 +22964,7 @@ static struct cipher_testvec khazad_dec_tv_template[] = {
 #define ANUBIS_CBC_ENC_TEST_VECTORS		2
 #define ANUBIS_CBC_DEC_TEST_VECTORS		2
 
-static struct cipher_testvec anubis_enc_tv_template[] = {
+static const struct cipher_testvec anubis_enc_tv_template[] = {
 	{
 		.key	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe",
@@ -23027,7 +23027,7 @@ static struct cipher_testvec anubis_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec anubis_dec_tv_template[] = {
+static const struct cipher_testvec anubis_dec_tv_template[] = {
 	{
 		.key	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe",
@@ -23090,7 +23090,7 @@ static struct cipher_testvec anubis_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec anubis_cbc_enc_tv_template[] = {
+static const struct cipher_testvec anubis_cbc_enc_tv_template[] = {
 	{
 		.key	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe",
@@ -23125,7 +23125,7 @@ static struct cipher_testvec anubis_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec anubis_cbc_dec_tv_template[] = {
+static const struct cipher_testvec anubis_cbc_dec_tv_template[] = {
 	{
 		.key	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
 			  "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe",
@@ -23166,7 +23166,7 @@ static struct cipher_testvec anubis_cbc_dec_tv_template[] = {
 #define XETA_ENC_TEST_VECTORS	4
 #define XETA_DEC_TEST_VECTORS	4
 
-static struct cipher_testvec xeta_enc_tv_template[] = {
+static const struct cipher_testvec xeta_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -23209,7 +23209,7 @@ static struct cipher_testvec xeta_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec xeta_dec_tv_template[] = {
+static const struct cipher_testvec xeta_dec_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -23258,7 +23258,7 @@ static struct cipher_testvec xeta_dec_tv_template[] = {
 #define FCRYPT_ENC_TEST_VECTORS	ARRAY_SIZE(fcrypt_pcbc_enc_tv_template)
 #define FCRYPT_DEC_TEST_VECTORS	ARRAY_SIZE(fcrypt_pcbc_dec_tv_template)
 
-static struct cipher_testvec fcrypt_pcbc_enc_tv_template[] = {
+static const struct cipher_testvec fcrypt_pcbc_enc_tv_template[] = {
 	{ /* http://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.klen	= 8,
@@ -23319,7 +23319,7 @@ static struct cipher_testvec fcrypt_pcbc_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec fcrypt_pcbc_dec_tv_template[] = {
+static const struct cipher_testvec fcrypt_pcbc_dec_tv_template[] = {
 	{ /* http://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.klen	= 8,
@@ -23394,7 +23394,7 @@ static struct cipher_testvec fcrypt_pcbc_dec_tv_template[] = {
 #define CAMELLIA_XTS_ENC_TEST_VECTORS 5
 #define CAMELLIA_XTS_DEC_TEST_VECTORS 5
 
-static struct cipher_testvec camellia_enc_tv_template[] = {
+static const struct cipher_testvec camellia_enc_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
@@ -23694,7 +23694,7 @@ static struct cipher_testvec camellia_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_dec_tv_template[] = {
+static const struct cipher_testvec camellia_dec_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
 			  "\xfe\xdc\xba\x98\x76\x54\x32\x10",
@@ -23994,7 +23994,7 @@ static struct cipher_testvec camellia_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_cbc_enc_tv_template[] = {
+static const struct cipher_testvec camellia_cbc_enc_tv_template[] = {
 	{
 		.key    = "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
 			  "\x51\x2e\x03\xd5\x34\x12\x00\x06",
@@ -24290,7 +24290,7 @@ static struct cipher_testvec camellia_cbc_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_cbc_dec_tv_template[] = {
+static const struct cipher_testvec camellia_cbc_dec_tv_template[] = {
 	{
 		.key    = "\x06\xa9\x21\x40\x36\xb8\xa1\x5b"
 			  "\x51\x2e\x03\xd5\x34\x12\x00\x06",
@@ -24586,7 +24586,7 @@ static struct cipher_testvec camellia_cbc_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_ctr_enc_tv_template[] = {
+static const struct cipher_testvec camellia_ctr_enc_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -25253,7 +25253,7 @@ static struct cipher_testvec camellia_ctr_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_ctr_dec_tv_template[] = {
+static const struct cipher_testvec camellia_ctr_dec_tv_template[] = {
 	{ /* Generated with Crypto++ */
 		.key	= "\x85\x62\x3F\x1C\xF9\xD6\x1C\xF9"
 			  "\xD6\xB3\x90\x6D\x4A\x90\x6D\x4A"
@@ -25920,7 +25920,7 @@ static struct cipher_testvec camellia_ctr_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_lrw_enc_tv_template[] = {
+static const struct cipher_testvec camellia_lrw_enc_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	{
 		.key	= "\x45\x62\xac\x25\xf8\x28\x17\x6d"
@@ -26172,7 +26172,7 @@ static struct cipher_testvec camellia_lrw_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_lrw_dec_tv_template[] = {
+static const struct cipher_testvec camellia_lrw_dec_tv_template[] = {
 	/* Generated from AES-LRW test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -26425,7 +26425,7 @@ static struct cipher_testvec camellia_lrw_dec_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_xts_enc_tv_template[] = {
+static const struct cipher_testvec camellia_xts_enc_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 	{
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -26767,7 +26767,7 @@ static struct cipher_testvec camellia_xts_enc_tv_template[] = {
 	},
 };
 
-static struct cipher_testvec camellia_xts_dec_tv_template[] = {
+static const struct cipher_testvec camellia_xts_dec_tv_template[] = {
 	/* Generated from AES-XTS test vectors */
 	/* same as enc vectors with input and result reversed */
 	{
@@ -27116,7 +27116,7 @@ static struct cipher_testvec camellia_xts_dec_tv_template[] = {
 #define SEED_ENC_TEST_VECTORS	4
 #define SEED_DEC_TEST_VECTORS	4
 
-static struct cipher_testvec seed_enc_tv_template[] = {
+static const struct cipher_testvec seed_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -27158,7 +27158,7 @@ static struct cipher_testvec seed_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec seed_dec_tv_template[] = {
+static const struct cipher_testvec seed_dec_tv_template[] = {
 	{
 		.key    = zeroed_string,
 		.klen	= 16,
@@ -27201,7 +27201,7 @@ static struct cipher_testvec seed_dec_tv_template[] = {
 };
 
 #define SALSA20_STREAM_ENC_TEST_VECTORS 5
-static struct cipher_testvec salsa20_stream_enc_tv_template[] = {
+static const struct cipher_testvec salsa20_stream_enc_tv_template[] = {
 	/*
 	* Testvectors from verified.test-vectors submitted to ECRYPT.
 	* They are truncated to size 39, 64, 111, 129 to test a variety
@@ -28375,7 +28375,7 @@ static struct cipher_testvec salsa20_stream_enc_tv_template[] = {
  */
 #define CTS_MODE_ENC_TEST_VECTORS 6
 #define CTS_MODE_DEC_TEST_VECTORS 6
-static struct cipher_testvec cts_mode_enc_tv_template[] = {
+static const struct cipher_testvec cts_mode_enc_tv_template[] = {
 	{ /* from rfc3962 */
 		.klen	= 16,
 		.key    = "\x63\x68\x69\x63\x6b\x65\x6e\x20"
@@ -28477,7 +28477,7 @@ static struct cipher_testvec cts_mode_enc_tv_template[] = {
 	}
 };
 
-static struct cipher_testvec cts_mode_dec_tv_template[] = {
+static const struct cipher_testvec cts_mode_dec_tv_template[] = {
 	{ /* from rfc3962 */
 		.klen	= 16,
 		.key    = "\x63\x68\x69\x63\x6b\x65\x6e\x20"
@@ -28606,7 +28606,7 @@ struct pcomp_testvec {
 #define DEFLATE_COMP_TEST_VECTORS 2
 #define DEFLATE_DECOMP_TEST_VECTORS 2
 
-static struct comp_testvec deflate_comp_tv_template[] = {
+static const struct comp_testvec deflate_comp_tv_template[] = {
 	{
 		.inlen	= 70,
 		.outlen	= 38,
@@ -28642,7 +28642,7 @@ static struct comp_testvec deflate_comp_tv_template[] = {
 	},
 };
 
-static struct comp_testvec deflate_decomp_tv_template[] = {
+static const struct comp_testvec deflate_decomp_tv_template[] = {
 	{
 		.inlen	= 122,
 		.outlen	= 191,
@@ -28731,7 +28731,7 @@ static const struct {
 	}
 };
 
-static struct pcomp_testvec zlib_comp_tv_template[] = {
+static const struct pcomp_testvec zlib_comp_tv_template[] = {
 	{
 		.params = &deflate_comp_params,
 		.paramsize = sizeof(deflate_comp_params),
@@ -28771,7 +28771,7 @@ static struct pcomp_testvec zlib_comp_tv_template[] = {
 	},
 };
 
-static struct pcomp_testvec zlib_decomp_tv_template[] = {
+static const struct pcomp_testvec zlib_decomp_tv_template[] = {
 	{
 		.params = &deflate_decomp_params,
 		.paramsize = sizeof(deflate_decomp_params),
@@ -28817,7 +28817,7 @@ static struct pcomp_testvec zlib_decomp_tv_template[] = {
 #define LZO_COMP_TEST_VECTORS 2
 #define LZO_DECOMP_TEST_VECTORS 2
 
-static struct comp_testvec lzo_comp_tv_template[] = {
+static const struct comp_testvec lzo_comp_tv_template[] = {
 	{
 		.inlen	= 70,
 		.outlen	= 57,
@@ -28857,7 +28857,7 @@ static struct comp_testvec lzo_comp_tv_template[] = {
 	},
 };
 
-static struct comp_testvec lzo_decomp_tv_template[] = {
+static const struct comp_testvec lzo_decomp_tv_template[] = {
 	{
 		.inlen	= 133,
 		.outlen	= 159,
@@ -28900,7 +28900,7 @@ static struct comp_testvec lzo_decomp_tv_template[] = {
  */
 #define MICHAEL_MIC_TEST_VECTORS 6
 
-static struct hash_testvec michael_mic_tv_template[] = {
+static const struct hash_testvec michael_mic_tv_template[] = {
 	{
 		.key = "\x00\x00\x00\x00\x00\x00\x00\x00",
 		.ksize = 8,
@@ -28950,7 +28950,7 @@ static struct hash_testvec michael_mic_tv_template[] = {
  */
 #define CRC32C_TEST_VECTORS 15
 
-static struct hash_testvec crc32c_tv_template[] = {
+static const struct hash_testvec crc32c_tv_template[] = {
 	{
 		.psize = 0,
 		.digest = "\x00\x00\x00\x00",
@@ -29388,7 +29388,7 @@ static struct hash_testvec crc32c_tv_template[] = {
  */
 #define BFIN_CRC_TEST_VECTORS 6
 
-static struct hash_testvec bfin_crc_tv_template[] = {
+static const struct hash_testvec bfin_crc_tv_template[] = {
 	{
 		.psize = 0,
 		.digest = "\x00\x00\x00\x00",
@@ -29476,7 +29476,7 @@ static struct hash_testvec bfin_crc_tv_template[] = {
 #define LZ4_COMP_TEST_VECTORS 1
 #define LZ4_DECOMP_TEST_VECTORS 1
 
-static struct comp_testvec lz4_comp_tv_template[] = {
+static const struct comp_testvec lz4_comp_tv_template[] = {
 	{
 		.inlen	= 70,
 		.outlen	= 45,
@@ -29491,7 +29491,7 @@ static struct comp_testvec lz4_comp_tv_template[] = {
 	},
 };
 
-static struct comp_testvec lz4_decomp_tv_template[] = {
+static const struct comp_testvec lz4_decomp_tv_template[] = {
 	{
 		.inlen	= 45,
 		.outlen	= 70,
@@ -29509,7 +29509,7 @@ static struct comp_testvec lz4_decomp_tv_template[] = {
 #define LZ4HC_COMP_TEST_VECTORS 1
 #define LZ4HC_DECOMP_TEST_VECTORS 1
 
-static struct comp_testvec lz4hc_comp_tv_template[] = {
+static const struct comp_testvec lz4hc_comp_tv_template[] = {
 	{
 		.inlen	= 70,
 		.outlen	= 45,
@@ -29524,7 +29524,7 @@ static struct comp_testvec lz4hc_comp_tv_template[] = {
 	},
 };
 
-static struct comp_testvec lz4hc_decomp_tv_template[] = {
+static const struct comp_testvec lz4hc_decomp_tv_template[] = {
 	{
 		.inlen	= 45,
 		.outlen	= 70,
-- 
2.1.3
