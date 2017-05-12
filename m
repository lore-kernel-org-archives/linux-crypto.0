From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH] Documentation: crypto: Fixed bugs,
 added example usage of calc_hash().
Date: Fri, 12 May 2017 17:38:02 +0200
Message-ID: <98b6249c-cd31-10cb-1527-9d95ac26f10e@partner.samsung.com>
References: <CGME20170512153803eucas1p1d3029703e8edee069e4aa3c578885d00@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

- Fixed bugs in example for shash and rng (added missing "*" and " *").
- Corrected pr_info() in calc_hash().
- Added example usage of calc_hash().
- No need for negate PTR_ERR to get error code, as crypto_alloc_rng
  already returns negative values like ERR_PTR(-ENOMEM). Fixed.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 Documentation/crypto/api-samples.rst | 38 ++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
index d021fd96a76d..2531948db89f 100644
--- a/Documentation/crypto/api-samples.rst
+++ b/Documentation/crypto/api-samples.rst
@@ -155,9 +155,9 @@ Code Example For Use of Operational State Memory With SHASH
         char ctx[];
     };
 
-    static struct sdesc init_sdesc(struct crypto_shash *alg)
+    static struct sdesc *init_sdesc(struct crypto_shash *alg)
     {
-        struct sdesc sdesc;
+        struct sdesc *sdesc;
         int size;
 
         size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
@@ -169,15 +169,16 @@ Code Example For Use of Operational State Memory With SHASH
         return sdesc;
     }
 
-    static int calc_hash(struct crypto_shashalg,
-                 const unsigned chardata, unsigned int datalen,
-                 unsigned chardigest) {
-        struct sdesc sdesc;
+    static int calc_hash(struct crypto_shash *alg,
+                 const unsigned char *data, unsigned int datalen,
+                 unsigned char *digest)
+    {
+        struct sdesc *sdesc;
         int ret;
 
         sdesc = init_sdesc(alg);
         if (IS_ERR(sdesc)) {
-            pr_info("trusted_key: can't alloc %s\n", hash_alg);
+            pr_info("can't alloc sdesc\n");
             return PTR_ERR(sdesc);
         }
 
@@ -186,6 +187,23 @@ Code Example For Use of Operational State Memory With SHASH
         return ret;
     }
 
+    static int test_hash(const unsigned char *data, unsigned int datalen,
+                 unsigned char *digest)
+    {
+        struct crypto_shash *alg;
+        char *hash_alg_name = "sha1-padlock-nano";
+        int ret;
+
+        alg = crypto_alloc_shash(hash_alg_name, CRYPTO_ALG_TYPE_SHASH, 0);
+        if (IS_ERR(alg)) {
+                pr_info("can't alloc alg %s\n", hash_alg_name);
+                return PTR_ERR(alg);
+        }
+        ret = calc_hash(alg, data, datalen, digest);
+        crypto_free_shash(alg);
+        return ret;
+    }
+
 
 Code Example For Random Number Generator Usage
 ----------------------------------------------
@@ -195,8 +213,8 @@ Code Example For Random Number Generator Usage
 
     static int get_random_numbers(u8 *buf, unsigned int len)
     {
-        struct crypto_rngrng = NULL;
-        chardrbg = "drbg_nopr_sha256"; /* Hash DRBG with SHA-256, no PR */
+        struct crypto_rng *rng = NULL;
+        char *drbg = "drbg_nopr_sha256"; /* Hash DRBG with SHA-256, no PR */
         int ret;
 
         if (!buf || !len) {
@@ -207,7 +225,7 @@ Code Example For Random Number Generator Usage
         rng = crypto_alloc_rng(drbg, 0, 0);
         if (IS_ERR(rng)) {
             pr_debug("could not allocate RNG handle for %s\n", drbg);
-            return -PTR_ERR(rng);
+            return PTR_ERR(rng);
         }
 
         ret = crypto_rng_get_bytes(rng, buf, len);
-- 
2.7.4

