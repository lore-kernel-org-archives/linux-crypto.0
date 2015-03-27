From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 02/20] crypto: testmgr to use CRYPTO_ALG_INTERNAL
Date: Fri, 27 Mar 2015 23:50:42 +0100
Message-ID: <1657882.6iCTT84gKK@tachyon.chronox.de>
References: <1746748.uPZFXamDiM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1746748.uPZFXamDiM@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

If a cipher allocation fails with -ENOENT, the testmgr now retries
to allocate the cipher with CRYPTO_ALG_INTERNAL flag.

As all ciphers, including the internal ciphers will be processed by
the testmgr, it needs to be able to allocate those ciphers.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1f879ad..609bafa 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1506,6 +1506,9 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 	int err = 0;
 
 	tfm = crypto_alloc_aead(driver, type, mask);
+	if (PTR_ERR(tfm) == -ENOENT)
+		tfm = crypto_alloc_aead(driver, type | CRYPTO_ALG_INTERNAL,
+					mask | CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: aead: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
@@ -1535,6 +1538,9 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 	int err = 0;
 
 	tfm = crypto_alloc_cipher(driver, type, mask);
+	if (PTR_ERR(tfm) == -ENOENT)
+		tfm = crypto_alloc_cipher(driver, type | CRYPTO_ALG_INTERNAL,
+					  mask | CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: cipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
@@ -1564,6 +1570,10 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 	int err = 0;
 
 	tfm = crypto_alloc_ablkcipher(driver, type, mask);
+	if (PTR_ERR(tfm) == -ENOENT)
+		tfm = crypto_alloc_ablkcipher(driver,
+					      type | CRYPTO_ALG_INTERNAL,
+					      mask | CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: skcipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
@@ -1637,6 +1647,9 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 	int err;
 
 	tfm = crypto_alloc_ahash(driver, type, mask);
+	if (PTR_ERR(tfm) == -ENOENT)
+		tfm = crypto_alloc_ahash(driver, type | CRYPTO_ALG_INTERNAL,
+					 mask | CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: hash: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
@@ -1665,6 +1678,9 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 		goto out;
 
 	tfm = crypto_alloc_shash(driver, type, mask);
+	if (PTR_ERR(tfm) == -ENOENT)
+		tfm = crypto_alloc_shash(driver, type | CRYPTO_ALG_INTERNAL,
+					 mask | CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: crc32c: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
@@ -1707,6 +1723,9 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 	int err;
 
 	rng = crypto_alloc_rng(driver, type, mask);
+	if (PTR_ERR(rng) == -ENOENT)
+		rng = crypto_alloc_rng(driver, type | CRYPTO_ALG_INTERNAL,
+				       mask | CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(rng)) {
 		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(rng));
@@ -1734,6 +1753,9 @@ static int drbg_cavs_test(struct drbg_testvec *test, int pr,
 		return -ENOMEM;
 
 	drng = crypto_alloc_rng(driver, type, mask);
+	if (PTR_ERR(drng) == -ENOENT)
+		drng = crypto_alloc_rng(driver, type | CRYPTO_ALG_INTERNAL,
+					mask | CRYPTO_ALG_INTERNAL);
 	if (IS_ERR(drng)) {
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
-- 
2.1.0
