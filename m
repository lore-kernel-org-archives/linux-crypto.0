From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3 02/20] crypto: testmgr to use CRYPTO_ALG_INTERNAL
Date: Mon, 30 Mar 2015 21:56:31 +0200
Message-ID: <35695803.75HNLbDkdq@tachyon.chronox.de>
References: <3417827.fluZli1WvQ@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3417827.fluZli1WvQ@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Allocate the ciphers irrespectively if they are marked as internal
or not. As all ciphers, including the internal ciphers will be
processed by the testmgr, it needs to be able to allocate those
ciphers.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 1f879ad..f9bce3d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1505,7 +1505,7 @@ static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
 	struct crypto_aead *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_aead(driver, type, mask);
+	tfm = crypto_alloc_aead(driver, type | CRYPTO_ALG_INTERNAL, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: aead: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
@@ -1534,7 +1534,7 @@ static int alg_test_cipher(const struct alg_test_desc *desc,
 	struct crypto_cipher *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_cipher(driver, type, mask);
+	tfm = crypto_alloc_cipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: cipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
@@ -1563,7 +1563,7 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 	struct crypto_ablkcipher *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_ablkcipher(driver, type, mask);
+	tfm = crypto_alloc_ablkcipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: skcipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
@@ -1636,7 +1636,7 @@ static int alg_test_hash(const struct alg_test_desc *desc, const char *driver,
 	struct crypto_ahash *tfm;
 	int err;
 
-	tfm = crypto_alloc_ahash(driver, type, mask);
+	tfm = crypto_alloc_ahash(driver, type | CRYPTO_ALG_INTERNAL, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: hash: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
@@ -1664,7 +1664,7 @@ static int alg_test_crc32c(const struct alg_test_desc *desc,
 	if (err)
 		goto out;
 
-	tfm = crypto_alloc_shash(driver, type, mask);
+	tfm = crypto_alloc_shash(driver, type | CRYPTO_ALG_INTERNAL, mask);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: crc32c: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(tfm));
@@ -1706,7 +1706,7 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
 	struct crypto_rng *rng;
 	int err;
 
-	rng = crypto_alloc_rng(driver, type, mask);
+	rng = crypto_alloc_rng(driver, type | CRYPTO_ALG_INTERNAL, mask);
 	if (IS_ERR(rng)) {
 		printk(KERN_ERR "alg: cprng: Failed to load transform for %s: "
 		       "%ld\n", driver, PTR_ERR(rng));
@@ -1733,7 +1733,7 @@ static int drbg_cavs_test(struct drbg_testvec *test, int pr,
 	if (!buf)
 		return -ENOMEM;
 
-	drng = crypto_alloc_rng(driver, type, mask);
+	drng = crypto_alloc_rng(driver, type | CRYPTO_ALG_INTERNAL, mask);
 	if (IS_ERR(drng)) {
 		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
 		       "%s\n", driver);
-- 
2.1.0
