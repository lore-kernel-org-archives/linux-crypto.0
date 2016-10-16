From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 1/7] crypto: doc - convert crypto API documentation to Sphinx
Date: Sun, 16 Oct 2016 05:16:22 +0200
Message-ID: <3476236.oX1ylRMUoQ@positron.chronox.de>
References: <2721226.4nLlHD9uQ6@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53528 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751393AbcJPD3B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Oct 2016 23:29:01 -0400
In-Reply-To: <2721226.4nLlHD9uQ6@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With the conversion of the kernel crypto API DocBook to Sphinx, the
monolithic document is broken up into individual documents. The
documentation is unchanged with the exception of a slight reordering to
keep the individual document parts self-contained.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/crypto/api-aead.rst     |  68 ++++++
 Documentation/crypto/api-akcipher.rst |  56 +++++
 Documentation/crypto/api-digest.rst   | 122 ++++++++++
 Documentation/crypto/api-rng.rst      |  32 +++
 Documentation/crypto/api-samples.rst  | 224 +++++++++++++++++
 Documentation/crypto/api-skcipher.rst | 203 ++++++++++++++++
 Documentation/crypto/api.rst          |  24 ++
 Documentation/crypto/architecture.rst | 435 ++++++++++++++++++++++++++++++++++
 Documentation/crypto/devel-algos.rst  | 247 +++++++++++++++++++
 Documentation/crypto/index.rst        |  24 ++
 Documentation/crypto/intro.rst        |  74 ++++++
 Documentation/crypto/userspace-if.rst | 387 ++++++++++++++++++++++++++++++
 Documentation/index.rst               |   1 +
 13 files changed, 1897 insertions(+)
 create mode 100644 Documentation/crypto/api-aead.rst
 create mode 100644 Documentation/crypto/api-akcipher.rst
 create mode 100644 Documentation/crypto/api-digest.rst
 create mode 100644 Documentation/crypto/api-rng.rst
 create mode 100644 Documentation/crypto/api-samples.rst
 create mode 100644 Documentation/crypto/api-skcipher.rst
 create mode 100644 Documentation/crypto/api.rst
 create mode 100644 Documentation/crypto/architecture.rst
 create mode 100644 Documentation/crypto/devel-algos.rst
 create mode 100644 Documentation/crypto/index.rst
 create mode 100644 Documentation/crypto/intro.rst
 create mode 100644 Documentation/crypto/userspace-if.rst

diff --git a/Documentation/crypto/api-aead.rst b/Documentation/crypto/api-aead.rst
new file mode 100644
index 0000000..78a7ce4
--- /dev/null
+++ b/Documentation/crypto/api-aead.rst
@@ -0,0 +1,68 @@
+Authenticated Encryption With Associated Data (AEAD) Algorithm Definitions
+--------------------------------------------------------------------------
+
+.. kernel-doc:: include/crypto/aead.h
+   :doc: Authenticated Encryption With Associated Data (AEAD) Cipher API
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: aead_request
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: aead_alg
+
+Authenticated Encryption With Associated Data (AEAD) Cipher API
+---------------------------------------------------------------
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: crypto_alloc_aead
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: crypto_free_aead
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: crypto_aead_ivsize
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: crypto_aead_authsize
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: crypto_aead_blocksize
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: crypto_aead_setkey
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: crypto_aead_setauthsize
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: crypto_aead_encrypt
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: crypto_aead_decrypt
+
+Asynchronous AEAD Request Handle
+--------------------------------
+
+.. kernel-doc:: include/crypto/aead.h
+   :doc: Asynchronous AEAD Request Handle
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: crypto_aead_reqsize
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: aead_request_set_tfm
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: aead_request_alloc
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: aead_request_free
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: aead_request_set_callback
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: aead_request_set_crypt
+
+.. kernel-doc:: include/crypto/aead.h
+   :functions: aead_request_set_ad
diff --git a/Documentation/crypto/api-akcipher.rst b/Documentation/crypto/api-akcipher.rst
new file mode 100644
index 0000000..305e616
--- /dev/null
+++ b/Documentation/crypto/api-akcipher.rst
@@ -0,0 +1,56 @@
+Asymmetric Cipher Algorithm Definitions
+---------------------------------------
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: akcipher_alg
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: akcipher_request
+
+Asymmetric Cipher API
+---------------------
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :doc: Generic Public Key API
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: crypto_alloc_akcipher
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: crypto_free_akcipher
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: crypto_akcipher_set_pub_key
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: crypto_akcipher_set_priv_key
+
+Asymmetric Cipher Request Handle
+--------------------------------
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: akcipher_request_alloc
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: akcipher_request_free
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: akcipher_request_set_callback
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: akcipher_request_set_crypt
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: crypto_akcipher_maxsize
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: crypto_akcipher_encrypt
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: crypto_akcipher_decrypt
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: crypto_akcipher_sign
+
+.. kernel-doc:: include/crypto/akcipher.h
+   :functions: crypto_akcipher_verify
diff --git a/Documentation/crypto/api-digest.rst b/Documentation/crypto/api-digest.rst
new file mode 100644
index 0000000..b5eaf0f
--- /dev/null
+++ b/Documentation/crypto/api-digest.rst
@@ -0,0 +1,122 @@
+Message Digest Algorithm Definitions
+------------------------------------
+
+.. kernel-doc:: include/crypto/hash.h
+   :doc: Message Digest Algorithm Definitions
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: hash_alg_common
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: ahash_alg
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: shash_alg
+
+Asynchronous Message Digest API
+-------------------------------
+
+.. kernel-doc:: include/crypto/hash.h
+   :doc: Asynchronous Message Digest API
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_alloc_ahash
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_free_ahash
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_ahash_init
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_ahash_digestsize
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_ahash_reqtfm
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_ahash_reqsize
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_ahash_setkey
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_ahash_finup
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_ahash_final
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_ahash_digest
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_ahash_export
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_ahash_import
+
+Asynchronous Hash Request Handle
+--------------------------------
+
+.. kernel-doc:: include/crypto/hash.h
+   :doc: Asynchronous Hash Request Handle
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: ahash_request_set_tfm
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: ahash_request_alloc
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: ahash_request_free
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: ahash_request_set_callback
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: ahash_request_set_crypt
+
+Synchronous Message Digest API
+------------------------------
+
+.. kernel-doc:: include/crypto/hash.h
+   :doc: Synchronous Message Digest API
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_alloc_shash
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_free_shash
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_blocksize
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_digestsize
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_descsize
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_setkey
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_digest
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_export
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_import
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_init
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_update
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_final
+
+.. kernel-doc:: include/crypto/hash.h
+   :functions: crypto_shash_finup
diff --git a/Documentation/crypto/api-rng.rst b/Documentation/crypto/api-rng.rst
new file mode 100644
index 0000000..0d7ee78
--- /dev/null
+++ b/Documentation/crypto/api-rng.rst
@@ -0,0 +1,32 @@
+Random Number Algorithm Definitions
+-----------------------------------
+
+.. kernel-doc:: include/crypto/rng.h
+   :functions: rng_alg
+
+Crypto API Random Number API
+----------------------------
+
+.. kernel-doc:: include/crypto/rng.h
+   :doc: Random number generator API
+
+.. kernel-doc:: include/crypto/rng.h
+   :functions: crypto_alloc_rng
+
+.. kernel-doc:: include/crypto/rng.h
+   :functions: crypto_rng_alg
+
+.. kernel-doc:: include/crypto/rng.h
+   :functions: crypto_free_rng
+
+.. kernel-doc:: include/crypto/rng.h
+   :functions: crypto_rng_generate
+
+.. kernel-doc:: include/crypto/rng.h
+   :functions: crypto_rng_get_bytes
+
+.. kernel-doc:: include/crypto/rng.h
+   :functions: crypto_rng_reset
+
+.. kernel-doc:: include/crypto/rng.h
+   :functions: crypto_rng_seedsize
diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
new file mode 100644
index 0000000..0a10819
--- /dev/null
+++ b/Documentation/crypto/api-samples.rst
@@ -0,0 +1,224 @@
+Code Examples
+=============
+
+Code Example For Symmetric Key Cipher Operation
+-----------------------------------------------
+
+::
+
+
+    struct tcrypt_result {
+        struct completion completion;
+        int err;
+    };
+
+    /* tie all data structures together */
+    struct skcipher_def {
+        struct scatterlist sg;
+        struct crypto_skcipher *tfm;
+        struct skcipher_request *req;
+        struct tcrypt_result result;
+    };
+
+    /* Callback function */
+    static void test_skcipher_cb(struct crypto_async_request *req, int error)
+    {
+        struct tcrypt_result *result = req->data;
+
+        if (error == -EINPROGRESS)
+            return;
+        result->err = error;
+        complete(&result->completion);
+        pr_info("Encryption finished successfully\n");
+    }
+
+    /* Perform cipher operation */
+    static unsigned int test_skcipher_encdec(struct skcipher_def *sk,
+                         int enc)
+    {
+        int rc = 0;
+
+        if (enc)
+            rc = crypto_skcipher_encrypt(sk->req);
+        else
+            rc = crypto_skcipher_decrypt(sk->req);
+
+        switch (rc) {
+        case 0:
+            break;
+        case -EINPROGRESS:
+        case -EBUSY:
+            rc = wait_for_completion_interruptible(
+                &sk->result.completion);
+            if (!rc && !sk->result.err) {
+                reinit_completion(&sk->result.completion);
+                break;
+            }
+        default:
+            pr_info("skcipher encrypt returned with %d result %d\n",
+                rc, sk->result.err);
+            break;
+        }
+        init_completion(&sk->result.completion);
+
+        return rc;
+    }
+
+    /* Initialize and trigger cipher operation */
+    static int test_skcipher(void)
+    {
+        struct skcipher_def sk;
+        struct crypto_skcipher *skcipher = NULL;
+        struct skcipher_request *req = NULL;
+        char *scratchpad = NULL;
+        char *ivdata = NULL;
+        unsigned char key[32];
+        int ret = -EFAULT;
+
+        skcipher = crypto_alloc_skcipher("cbc-aes-aesni", 0, 0);
+        if (IS_ERR(skcipher)) {
+            pr_info("could not allocate skcipher handle\n");
+            return PTR_ERR(skcipher);
+        }
+
+        req = skcipher_request_alloc(skcipher, GFP_KERNEL);
+        if (!req) {
+            pr_info("could not allocate skcipher request\n");
+            ret = -ENOMEM;
+            goto out;
+        }
+
+        skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+                          test_skcipher_cb,
+                          &sk.result);
+
+        /* AES 256 with random key */
+        get_random_bytes(&key, 32);
+        if (crypto_skcipher_setkey(skcipher, key, 32)) {
+            pr_info("key could not be set\n");
+            ret = -EAGAIN;
+            goto out;
+        }
+
+        /* IV will be random */
+        ivdata = kmalloc(16, GFP_KERNEL);
+        if (!ivdata) {
+            pr_info("could not allocate ivdata\n");
+            goto out;
+        }
+        get_random_bytes(ivdata, 16);
+
+        /* Input data will be random */
+        scratchpad = kmalloc(16, GFP_KERNEL);
+        if (!scratchpad) {
+            pr_info("could not allocate scratchpad\n");
+            goto out;
+        }
+        get_random_bytes(scratchpad, 16);
+
+        sk.tfm = skcipher;
+        sk.req = req;
+
+        /* We encrypt one block */
+        sg_init_one(&sk.sg, scratchpad, 16);
+        skcipher_request_set_crypt(req, &sk.sg, &sk.sg, 16, ivdata);
+        init_completion(&sk.result.completion);
+
+        /* encrypt data */
+        ret = test_skcipher_encdec(&sk, 1);
+        if (ret)
+            goto out;
+
+        pr_info("Encryption triggered successfully\n");
+
+    out:
+        if (skcipher)
+            crypto_free_skcipher(skcipher);
+        if (req)
+            skcipher_request_free(req);
+        if (ivdata)
+            kfree(ivdata);
+        if (scratchpad)
+            kfree(scratchpad);
+        return ret;
+    }
+
+
+Code Example For Use of Operational State Memory With SHASH
+-----------------------------------------------------------
+
+::
+
+
+    struct sdesc {
+        struct shash_desc shash;
+        char ctx[];
+    };
+
+    static struct sdescinit_sdesc(struct crypto_shash *alg)
+    {
+        struct sdescsdesc;
+        int size;
+
+        size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
+        sdesc = kmalloc(size, GFP_KERNEL);
+        if (!sdesc)
+            return ERR_PTR(-ENOMEM);
+        sdesc->shash.tfm = alg;
+        sdesc->shash.flags = 0x0;
+        return sdesc;
+    }
+
+    static int calc_hash(struct crypto_shashalg,
+                 const unsigned chardata, unsigned int datalen,
+                 unsigned chardigest) {
+        struct sdescsdesc;
+        int ret;
+
+        sdesc = init_sdesc(alg);
+        if (IS_ERR(sdesc)) {
+            pr_info("trusted_key: can't alloc %s\n", hash_alg);
+            return PTR_ERR(sdesc);
+        }
+
+        ret = crypto_shash_digest(&sdesc->shash, data, datalen, digest);
+        kfree(sdesc);
+        return ret;
+    }
+
+
+Code Example For Random Number Generator Usage
+----------------------------------------------
+
+::
+
+
+    static int get_random_numbers(u8 *buf, unsigned int len)
+    {
+        struct crypto_rngrng = NULL;
+        chardrbg = "drbg_nopr_sha256"; /* Hash DRBG with SHA-256, no PR */
+        int ret;
+
+        if (!buf || !len) {
+            pr_debug("No output buffer provided\n");
+            return -EINVAL;
+        }
+
+        rng = crypto_alloc_rng(drbg, 0, 0);
+        if (IS_ERR(rng)) {
+            pr_debug("could not allocate RNG handle for %s\n", drbg);
+            return -PTR_ERR(rng);
+        }
+
+        ret = crypto_rng_get_bytes(rng, buf, len);
+        if (ret < 0)
+            pr_debug("generation of random numbers failed\n");
+        else if (ret == 0)
+            pr_debug("RNG returned no data");
+        else
+            pr_debug("RNG returned %d bytes of data\n", ret);
+
+    out:
+        crypto_free_rng(rng);
+        return ret;
+    }
diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
new file mode 100644
index 0000000..eabd369
--- /dev/null
+++ b/Documentation/crypto/api-skcipher.rst
@@ -0,0 +1,203 @@
+Block Cipher Algorithm Definitions
+----------------------------------
+
+.. kernel-doc:: include/linux/crypto.h
+   :doc: Block Cipher Algorithm Definitions
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_alg
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: ablkcipher_alg
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: blkcipher_alg
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: cipher_alg
+
+Symmetric Key Cipher API
+------------------------
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :doc: Symmetric Key Cipher API
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: crypto_alloc_skcipher
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: crypto_free_skcipher
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: crypto_has_skcipher
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: crypto_skcipher_ivsize
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: crypto_skcipher_blocksize
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: crypto_skcipher_setkey
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: crypto_skcipher_reqtfm
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: crypto_skcipher_encrypt
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: crypto_skcipher_decrypt
+
+Symmetric Key Cipher Request Handle
+-----------------------------------
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :doc: Symmetric Key Cipher Request Handle
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: crypto_skcipher_reqsize
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: skcipher_request_set_tfm
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: skcipher_request_alloc
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: skcipher_request_free
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: skcipher_request_set_callback
+
+.. kernel-doc:: include/crypto/skcipher.h
+   :functions: skcipher_request_set_crypt
+
+Single Block Cipher API
+-----------------------
+
+.. kernel-doc:: include/linux/crypto.h
+   :doc: Single Block Cipher API
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_alloc_cipher
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_free_cipher
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_has_cipher
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_cipher_blocksize
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_cipher_setkey
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_cipher_encrypt_one
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_cipher_decrypt_one
+
+Asynchronous Block Cipher API - Deprecated
+------------------------------------------
+
+.. kernel-doc:: include/linux/crypto.h
+   :doc: Asynchronous Block Cipher API
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_alloc_ablkcipher
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_free_ablkcipher
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_has_ablkcipher
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_ablkcipher_ivsize
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_ablkcipher_blocksize
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_ablkcipher_setkey
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_ablkcipher_reqtfm
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_ablkcipher_encrypt
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_ablkcipher_decrypt
+
+Asynchronous Cipher Request Handle - Deprecated
+-----------------------------------------------
+
+.. kernel-doc:: include/linux/crypto.h
+   :doc: Asynchronous Cipher Request Handle
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_ablkcipher_reqsize
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: ablkcipher_request_set_tfm
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: ablkcipher_request_alloc
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: ablkcipher_request_free
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: ablkcipher_request_set_callback
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: ablkcipher_request_set_crypt
+
+Synchronous Block Cipher API - Deprecated
+-----------------------------------------
+
+.. kernel-doc:: include/linux/crypto.h
+   :doc: Synchronous Block Cipher API
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_alloc_blkcipher
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_free_blkcipher
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_has_blkcipher
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_blkcipher_name
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_blkcipher_ivsize
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_blkcipher_blocksize
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_blkcipher_setkey
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_blkcipher_encrypt
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_blkcipher_encrypt_iv
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_blkcipher_decrypt
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_blkcipher_decrypt_iv
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_blkcipher_set_iv
+
+.. kernel-doc:: include/linux/crypto.h
+   :functions: crypto_blkcipher_get_iv
diff --git a/Documentation/crypto/api.rst b/Documentation/crypto/api.rst
new file mode 100644
index 0000000..f2bbeb0
--- /dev/null
+++ b/Documentation/crypto/api.rst
@@ -0,0 +1,24 @@
+Programming Interface
+=====================
+
+Please note that the kernel crypto API contains the AEAD givcrypt API
+(crypto_aead_giv\* and aead_givcrypt\* function calls in
+include/crypto/aead.h). This API is obsolete and will be removed in the
+future. To obtain the functionality of an AEAD cipher with internal IV
+generation, use the IV generator as a regular cipher. For example,
+rfc4106(gcm(aes)) is the AEAD cipher with external IV generation and
+seqniv(rfc4106(gcm(aes))) implies that the kernel crypto API generates
+the IV. Different IV generators are available.
+
+.. class:: toc-title
+
+	   Table of contents
+
+.. toctree::
+   :maxdepth: 2
+
+   api-skcipher
+   api-aead
+   api-digest
+   api-rng
+   api-akcipher
diff --git a/Documentation/crypto/architecture.rst b/Documentation/crypto/architecture.rst
new file mode 100644
index 0000000..34e396b
--- /dev/null
+++ b/Documentation/crypto/architecture.rst
@@ -0,0 +1,435 @@
+Kernel Crypto API Architecture
+==============================
+
+Cipher algorithm types
+----------------------
+
+The kernel crypto API provides different API calls for the following
+cipher types:
+
+-  Symmetric ciphers
+
+-  AEAD ciphers
+
+-  Message digest, including keyed message digest
+
+-  Random number generation
+
+-  User space interface
+
+Ciphers And Templates
+---------------------
+
+The kernel crypto API provides implementations of single block ciphers
+and message digests. In addition, the kernel crypto API provides
+numerous "templates" that can be used in conjunction with the single
+block ciphers and message digests. Templates include all types of block
+chaining mode, the HMAC mechanism, etc.
+
+Single block ciphers and message digests can either be directly used by
+a caller or invoked together with a template to form multi-block ciphers
+or keyed message digests.
+
+A single block cipher may even be called with multiple templates.
+However, templates cannot be used without a single cipher.
+
+See /proc/crypto and search for "name". For example:
+
+-  aes
+
+-  ecb(aes)
+
+-  cmac(aes)
+
+-  ccm(aes)
+
+-  rfc4106(gcm(aes))
+
+-  sha1
+
+-  hmac(sha1)
+
+-  authenc(hmac(sha1),cbc(aes))
+
+In these examples, "aes" and "sha1" are the ciphers and all others are
+the templates.
+
+Synchronous And Asynchronous Operation
+--------------------------------------
+
+The kernel crypto API provides synchronous and asynchronous API
+operations.
+
+When using the synchronous API operation, the caller invokes a cipher
+operation which is performed synchronously by the kernel crypto API.
+That means, the caller waits until the cipher operation completes.
+Therefore, the kernel crypto API calls work like regular function calls.
+For synchronous operation, the set of API calls is small and
+conceptually similar to any other crypto library.
+
+Asynchronous operation is provided by the kernel crypto API which
+implies that the invocation of a cipher operation will complete almost
+instantly. That invocation triggers the cipher operation but it does not
+signal its completion. Before invoking a cipher operation, the caller
+must provide a callback function the kernel crypto API can invoke to
+signal the completion of the cipher operation. Furthermore, the caller
+must ensure it can handle such asynchronous events by applying
+appropriate locking around its data. The kernel crypto API does not
+perform any special serialization operation to protect the caller's data
+integrity.
+
+Crypto API Cipher References And Priority
+-----------------------------------------
+
+A cipher is referenced by the caller with a string. That string has the
+following semantics:
+
+::
+
+        template(single block cipher)
+
+
+where "template" and "single block cipher" is the aforementioned
+template and single block cipher, respectively. If applicable,
+additional templates may enclose other templates, such as
+
+::
+
+        template1(template2(single block cipher)))
+
+
+The kernel crypto API may provide multiple implementations of a template
+or a single block cipher. For example, AES on newer Intel hardware has
+the following implementations: AES-NI, assembler implementation, or
+straight C. Now, when using the string "aes" with the kernel crypto API,
+which cipher implementation is used? The answer to that question is the
+priority number assigned to each cipher implementation by the kernel
+crypto API. When a caller uses the string to refer to a cipher during
+initialization of a cipher handle, the kernel crypto API looks up all
+implementations providing an implementation with that name and selects
+the implementation with the highest priority.
+
+Now, a caller may have the need to refer to a specific cipher
+implementation and thus does not want to rely on the priority-based
+selection. To accommodate this scenario, the kernel crypto API allows
+the cipher implementation to register a unique name in addition to
+common names. When using that unique name, a caller is therefore always
+sure to refer to the intended cipher implementation.
+
+The list of available ciphers is given in /proc/crypto. However, that
+list does not specify all possible permutations of templates and
+ciphers. Each block listed in /proc/crypto may contain the following
+information -- if one of the components listed as follows are not
+applicable to a cipher, it is not displayed:
+
+-  name: the generic name of the cipher that is subject to the
+   priority-based selection -- this name can be used by the cipher
+   allocation API calls (all names listed above are examples for such
+   generic names)
+
+-  driver: the unique name of the cipher -- this name can be used by the
+   cipher allocation API calls
+
+-  module: the kernel module providing the cipher implementation (or
+   "kernel" for statically linked ciphers)
+
+-  priority: the priority value of the cipher implementation
+
+-  refcnt: the reference count of the respective cipher (i.e. the number
+   of current consumers of this cipher)
+
+-  selftest: specification whether the self test for the cipher passed
+
+-  type:
+
+   -  skcipher for symmetric key ciphers
+
+   -  cipher for single block ciphers that may be used with an
+      additional template
+
+   -  shash for synchronous message digest
+
+   -  ahash for asynchronous message digest
+
+   -  aead for AEAD cipher type
+
+   -  compression for compression type transformations
+
+   -  rng for random number generator
+
+   -  givcipher for cipher with associated IV generator (see the geniv
+      entry below for the specification of the IV generator type used by
+      the cipher implementation)
+
+-  blocksize: blocksize of cipher in bytes
+
+-  keysize: key size in bytes
+
+-  ivsize: IV size in bytes
+
+-  seedsize: required size of seed data for random number generator
+
+-  digestsize: output size of the message digest
+
+-  geniv: IV generation type:
+
+   -  eseqiv for encrypted sequence number based IV generation
+
+   -  seqiv for sequence number based IV generation
+
+   -  chainiv for chain iv generation
+
+   -  <builtin> is a marker that the cipher implements IV generation and
+      handling as it is specific to the given cipher
+
+Key Sizes
+---------
+
+When allocating a cipher handle, the caller only specifies the cipher
+type. Symmetric ciphers, however, typically support multiple key sizes
+(e.g. AES-128 vs. AES-192 vs. AES-256). These key sizes are determined
+with the length of the provided key. Thus, the kernel crypto API does
+not provide a separate way to select the particular symmetric cipher key
+size.
+
+Cipher Allocation Type And Masks
+--------------------------------
+
+The different cipher handle allocation functions allow the specification
+of a type and mask flag. Both parameters have the following meaning (and
+are therefore not covered in the subsequent sections).
+
+The type flag specifies the type of the cipher algorithm. The caller
+usually provides a 0 when the caller wants the default handling.
+Otherwise, the caller may provide the following selections which match
+the aforementioned cipher types:
+
+-  CRYPTO_ALG_TYPE_CIPHER Single block cipher
+
+-  CRYPTO_ALG_TYPE_COMPRESS Compression
+
+-  CRYPTO_ALG_TYPE_AEAD Authenticated Encryption with Associated Data
+   (MAC)
+
+-  CRYPTO_ALG_TYPE_BLKCIPHER Synchronous multi-block cipher
+
+-  CRYPTO_ALG_TYPE_ABLKCIPHER Asynchronous multi-block cipher
+
+-  CRYPTO_ALG_TYPE_GIVCIPHER Asynchronous multi-block cipher packed
+   together with an IV generator (see geniv field in the /proc/crypto
+   listing for the known IV generators)
+
+-  CRYPTO_ALG_TYPE_DIGEST Raw message digest
+
+-  CRYPTO_ALG_TYPE_HASH Alias for CRYPTO_ALG_TYPE_DIGEST
+
+-  CRYPTO_ALG_TYPE_SHASH Synchronous multi-block hash
+
+-  CRYPTO_ALG_TYPE_AHASH Asynchronous multi-block hash
+
+-  CRYPTO_ALG_TYPE_RNG Random Number Generation
+
+-  CRYPTO_ALG_TYPE_AKCIPHER Asymmetric cipher
+
+-  CRYPTO_ALG_TYPE_PCOMPRESS Enhanced version of
+   CRYPTO_ALG_TYPE_COMPRESS allowing for segmented compression /
+   decompression instead of performing the operation on one segment
+   only. CRYPTO_ALG_TYPE_PCOMPRESS is intended to replace
+   CRYPTO_ALG_TYPE_COMPRESS once existing consumers are converted.
+
+The mask flag restricts the type of cipher. The only allowed flag is
+CRYPTO_ALG_ASYNC to restrict the cipher lookup function to
+asynchronous ciphers. Usually, a caller provides a 0 for the mask flag.
+
+When the caller provides a mask and type specification, the caller
+limits the search the kernel crypto API can perform for a suitable
+cipher implementation for the given cipher name. That means, even when a
+caller uses a cipher name that exists during its initialization call,
+the kernel crypto API may not select it due to the used type and mask
+field.
+
+Internal Structure of Kernel Crypto API
+---------------------------------------
+
+The kernel crypto API has an internal structure where a cipher
+implementation may use many layers and indirections. This section shall
+help to clarify how the kernel crypto API uses various components to
+implement the complete cipher.
+
+The following subsections explain the internal structure based on
+existing cipher implementations. The first section addresses the most
+complex scenario where all other scenarios form a logical subset.
+
+Generic AEAD Cipher Structure
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The following ASCII art decomposes the kernel crypto API layers when
+using the AEAD cipher with the automated IV generation. The shown
+example is used by the IPSEC layer.
+
+For other use cases of AEAD ciphers, the ASCII art applies as well, but
+the caller may not use the AEAD cipher with a separate IV generator. In
+this case, the caller must generate the IV.
+
+The depicted example decomposes the AEAD cipher of GCM(AES) based on the
+generic C implementations (gcm.c, aes-generic.c, ctr.c, ghash-generic.c,
+seqiv.c). The generic implementation serves as an example showing the
+complete logic of the kernel crypto API.
+
+It is possible that some streamlined cipher implementations (like
+AES-NI) provide implementations merging aspects which in the view of the
+kernel crypto API cannot be decomposed into layers any more. In case of
+the AES-NI implementation, the CTR mode, the GHASH implementation and
+the AES cipher are all merged into one cipher implementation registered
+with the kernel crypto API. In this case, the concept described by the
+following ASCII art applies too. However, the decomposition of GCM into
+the individual sub-components by the kernel crypto API is not done any
+more.
+
+Each block in the following ASCII art is an independent cipher instance
+obtained from the kernel crypto API. Each block is accessed by the
+caller or by other blocks using the API functions defined by the kernel
+crypto API for the cipher implementation type.
+
+The blocks below indicate the cipher type as well as the specific logic
+implemented in the cipher.
+
+The ASCII art picture also indicates the call structure, i.e. who calls
+which component. The arrows point to the invoked block where the caller
+uses the API applicable to the cipher type specified for the block.
+
+::
+
+
+    kernel crypto API                                |   IPSEC Layer
+                                                     |
+    +-----------+                                    |
+    |           |            (1)
+    |   aead    | <-----------------------------------  esp_output
+    |  (seqiv)  | ---+
+    +-----------+    |
+                     | (2)
+    +-----------+    |
+    |           | <--+                (2)
+    |   aead    | <-----------------------------------  esp_input
+    |   (gcm)   | ------------+
+    +-----------+             |
+          | (3)               | (5)
+          v                   v
+    +-----------+       +-----------+
+    |           |       |           |
+    |  skcipher |       |   ahash   |
+    |   (ctr)   | ---+  |  (ghash)  |
+    +-----------+    |  +-----------+
+                     |
+    +-----------+    | (4)
+    |           | <--+
+    |   cipher  |
+    |   (aes)   |
+    +-----------+
+
+
+
+The following call sequence is applicable when the IPSEC layer triggers
+an encryption operation with the esp_output function. During
+configuration, the administrator set up the use of rfc4106(gcm(aes)) as
+the cipher for ESP. The following call sequence is now depicted in the
+ASCII art above:
+
+1. esp_output() invokes crypto_aead_encrypt() to trigger an
+   encryption operation of the AEAD cipher with IV generator.
+
+   In case of GCM, the SEQIV implementation is registered as GIVCIPHER
+   in crypto_rfc4106_alloc().
+
+   The SEQIV performs its operation to generate an IV where the core
+   function is seqiv_geniv().
+
+2. Now, SEQIV uses the AEAD API function calls to invoke the associated
+   AEAD cipher. In our case, during the instantiation of SEQIV, the
+   cipher handle for GCM is provided to SEQIV. This means that SEQIV
+   invokes AEAD cipher operations with the GCM cipher handle.
+
+   During instantiation of the GCM handle, the CTR(AES) and GHASH
+   ciphers are instantiated. The cipher handles for CTR(AES) and GHASH
+   are retained for later use.
+
+   The GCM implementation is responsible to invoke the CTR mode AES and
+   the GHASH cipher in the right manner to implement the GCM
+   specification.
+
+3. The GCM AEAD cipher type implementation now invokes the SKCIPHER API
+   with the instantiated CTR(AES) cipher handle.
+
+   During instantiation of the CTR(AES) cipher, the CIPHER type
+   implementation of AES is instantiated. The cipher handle for AES is
+   retained.
+
+   That means that the SKCIPHER implementation of CTR(AES) only
+   implements the CTR block chaining mode. After performing the block
+   chaining operation, the CIPHER implementation of AES is invoked.
+
+4. The SKCIPHER of CTR(AES) now invokes the CIPHER API with the AES
+   cipher handle to encrypt one block.
+
+5. The GCM AEAD implementation also invokes the GHASH cipher
+   implementation via the AHASH API.
+
+When the IPSEC layer triggers the esp_input() function, the same call
+sequence is followed with the only difference that the operation starts
+with step (2).
+
+Generic Block Cipher Structure
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Generic block ciphers follow the same concept as depicted with the ASCII
+art picture above.
+
+For example, CBC(AES) is implemented with cbc.c, and aes-generic.c. The
+ASCII art picture above applies as well with the difference that only
+step (4) is used and the SKCIPHER block chaining mode is CBC.
+
+Generic Keyed Message Digest Structure
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Keyed message digest implementations again follow the same concept as
+depicted in the ASCII art picture above.
+
+For example, HMAC(SHA256) is implemented with hmac.c and
+sha256_generic.c. The following ASCII art illustrates the
+implementation:
+
+::
+
+
+    kernel crypto API            |       Caller
+                                 |
+    +-----------+         (1)    |
+    |           | <------------------  some_function
+    |   ahash   |
+    |   (hmac)  | ---+
+    +-----------+    |
+                     | (2)
+    +-----------+    |
+    |           | <--+
+    |   shash   |
+    |  (sha256) |
+    +-----------+
+
+
+
+The following call sequence is applicable when a caller triggers an HMAC
+operation:
+
+1. The AHASH API functions are invoked by the caller. The HMAC
+   implementation performs its operation as needed.
+
+   During initialization of the HMAC cipher, the SHASH cipher type of
+   SHA256 is instantiated. The cipher handle for the SHA256 instance is
+   retained.
+
+   At one time, the HMAC implementation requires a SHA256 operation
+   where the SHA256 cipher handle is used.
+
+2. The HMAC instance now invokes the SHASH API with the SHA256 cipher
+   handle to calculate the message digest.
diff --git a/Documentation/crypto/devel-algos.rst b/Documentation/crypto/devel-algos.rst
new file mode 100644
index 0000000..66f50d3
--- /dev/null
+++ b/Documentation/crypto/devel-algos.rst
@@ -0,0 +1,247 @@
+Developing Cipher Algorithms
+============================
+
+Registering And Unregistering Transformation
+--------------------------------------------
+
+There are three distinct types of registration functions in the Crypto
+API. One is used to register a generic cryptographic transformation,
+while the other two are specific to HASH transformations and
+COMPRESSion. We will discuss the latter two in a separate chapter, here
+we will only look at the generic ones.
+
+Before discussing the register functions, the data structure to be
+filled with each, struct crypto_alg, must be considered -- see below
+for a description of this data structure.
+
+The generic registration functions can be found in
+include/linux/crypto.h and their definition can be seen below. The
+former function registers a single transformation, while the latter
+works on an array of transformation descriptions. The latter is useful
+when registering transformations in bulk, for example when a driver
+implements multiple transformations.
+
+::
+
+       int crypto_register_alg(struct crypto_alg *alg);
+       int crypto_register_algs(struct crypto_alg *algs, int count);
+
+
+The counterparts to those functions are listed below.
+
+::
+
+       int crypto_unregister_alg(struct crypto_alg *alg);
+       int crypto_unregister_algs(struct crypto_alg *algs, int count);
+
+
+Notice that both registration and unregistration functions do return a
+value, so make sure to handle errors. A return code of zero implies
+success. Any return code < 0 implies an error.
+
+The bulk registration/unregistration functions register/unregister each
+transformation in the given array of length count. They handle errors as
+follows:
+
+-  crypto_register_algs() succeeds if and only if it successfully
+   registers all the given transformations. If an error occurs partway
+   through, then it rolls back successful registrations before returning
+   the error code. Note that if a driver needs to handle registration
+   errors for individual transformations, then it will need to use the
+   non-bulk function crypto_register_alg() instead.
+
+-  crypto_unregister_algs() tries to unregister all the given
+   transformations, continuing on error. It logs errors and always
+   returns zero.
+
+Single-Block Symmetric Ciphers [CIPHER]
+---------------------------------------
+
+Example of transformations: aes, arc4, ...
+
+This section describes the simplest of all transformation
+implementations, that being the CIPHER type used for symmetric ciphers.
+The CIPHER type is used for transformations which operate on exactly one
+block at a time and there are no dependencies between blocks at all.
+
+Registration specifics
+~~~~~~~~~~~~~~~~~~~~~~
+
+The registration of [CIPHER] algorithm is specific in that struct
+crypto_alg field .cra_type is empty. The .cra_u.cipher has to be
+filled in with proper callbacks to implement this transformation.
+
+See struct cipher_alg below.
+
+Cipher Definition With struct cipher_alg
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Struct cipher_alg defines a single block cipher.
+
+Here are schematics of how these functions are called when operated from
+other part of the kernel. Note that the .cia_setkey() call might happen
+before or after any of these schematics happen, but must not happen
+during any of these are in-flight.
+
+::
+
+             KEY ---.    PLAINTEXT ---.
+                    v                 v
+              .cia_setkey() -> .cia_encrypt()
+                                      |
+                                      '-----> CIPHERTEXT
+
+
+Please note that a pattern where .cia_setkey() is called multiple times
+is also valid:
+
+::
+
+
+      KEY1 --.    PLAINTEXT1 --.         KEY2 --.    PLAINTEXT2 --.
+             v                 v                v                 v
+       .cia_setkey() -> .cia_encrypt() -> .cia_setkey() -> .cia_encrypt()
+                               |                                  |
+                               '---> CIPHERTEXT1                  '---> CIPHERTEXT2
+
+
+Multi-Block Ciphers
+-------------------
+
+Example of transformations: cbc(aes), ecb(arc4), ...
+
+This section describes the multi-block cipher transformation
+implementations. The multi-block ciphers are used for transformations
+which operate on scatterlists of data supplied to the transformation
+functions. They output the result into a scatterlist of data as well.
+
+Registration Specifics
+~~~~~~~~~~~~~~~~~~~~~~
+
+The registration of multi-block cipher algorithms is one of the most
+standard procedures throughout the crypto API.
+
+Note, if a cipher implementation requires a proper alignment of data,
+the caller should use the functions of crypto_skcipher_alignmask() to
+identify a memory alignment mask. The kernel crypto API is able to
+process requests that are unaligned. This implies, however, additional
+overhead as the kernel crypto API needs to perform the realignment of
+the data which may imply moving of data.
+
+Cipher Definition With struct blkcipher_alg and ablkcipher_alg
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Struct blkcipher_alg defines a synchronous block cipher whereas struct
+ablkcipher_alg defines an asynchronous block cipher.
+
+Please refer to the single block cipher description for schematics of
+the block cipher usage.
+
+Specifics Of Asynchronous Multi-Block Cipher
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+There are a couple of specifics to the asynchronous interface.
+
+First of all, some of the drivers will want to use the Generic
+ScatterWalk in case the hardware needs to be fed separate chunks of the
+scatterlist which contains the plaintext and will contain the
+ciphertext. Please refer to the ScatterWalk interface offered by the
+Linux kernel scatter / gather list implementation.
+
+Hashing [HASH]
+--------------
+
+Example of transformations: crc32, md5, sha1, sha256,...
+
+Registering And Unregistering The Transformation
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+There are multiple ways to register a HASH transformation, depending on
+whether the transformation is synchronous [SHASH] or asynchronous
+[AHASH] and the amount of HASH transformations we are registering. You
+can find the prototypes defined in include/crypto/internal/hash.h:
+
+::
+
+       int crypto_register_ahash(struct ahash_alg *alg);
+
+       int crypto_register_shash(struct shash_alg *alg);
+       int crypto_register_shashes(struct shash_alg *algs, int count);
+
+
+The respective counterparts for unregistering the HASH transformation
+are as follows:
+
+::
+
+       int crypto_unregister_ahash(struct ahash_alg *alg);
+
+       int crypto_unregister_shash(struct shash_alg *alg);
+       int crypto_unregister_shashes(struct shash_alg *algs, int count);
+
+
+Cipher Definition With struct shash_alg and ahash_alg
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Here are schematics of how these functions are called when operated from
+other part of the kernel. Note that the .setkey() call might happen
+before or after any of these schematics happen, but must not happen
+during any of these are in-flight. Please note that calling .init()
+followed immediately by .finish() is also a perfectly valid
+transformation.
+
+::
+
+       I)   DATA -----------.
+                            v
+             .init() -> .update() -> .final()      ! .update() might not be called
+                         ^    |         |            at all in this scenario.
+                         '----'         '---> HASH
+
+       II)  DATA -----------.-----------.
+                            v           v
+             .init() -> .update() -> .finup()      ! .update() may not be called
+                         ^    |         |            at all in this scenario.
+                         '----'         '---> HASH
+
+       III) DATA -----------.
+                            v
+                        .digest()                  ! The entire process is handled
+                            |                        by the .digest() call.
+                            '---------------> HASH
+
+
+Here is a schematic of how the .export()/.import() functions are called
+when used from another part of the kernel.
+
+::
+
+       KEY--.                 DATA--.
+            v                       v                  ! .update() may not be called
+        .setkey() -> .init() -> .update() -> .export()   at all in this scenario.
+                                 ^     |         |
+                                 '-----'         '--> PARTIAL_HASH
+
+       ----------- other transformations happen here -----------
+
+       PARTIAL_HASH--.   DATA1--.
+                     v          v
+                 .import -> .update() -> .final()     ! .update() may not be called
+                             ^    |         |           at all in this scenario.
+                             '----'         '--> HASH1
+
+       PARTIAL_HASH--.   DATA2-.
+                     v         v
+                 .import -> .finup()
+                               |
+                               '---------------> HASH2
+
+
+Specifics Of Asynchronous HASH Transformation
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Some of the drivers will want to use the Generic ScatterWalk in case the
+implementation needs to be fed separate chunks of the scatterlist which
+contains the input data. The buffer containing the resulting hash will
+always be properly aligned to .cra_alignmask so there is no need to
+worry about this.
diff --git a/Documentation/crypto/index.rst b/Documentation/crypto/index.rst
new file mode 100644
index 0000000..94c4786
--- /dev/null
+++ b/Documentation/crypto/index.rst
@@ -0,0 +1,24 @@
+=======================
+Linux Kernel Crypto API
+=======================
+
+:Author: Stephan Mueller
+:Author: Marek Vasut
+
+This documentation outlines the Linux kernel crypto API with its
+concepts, details about developing cipher implementations, employment of the API
+for cryptographic use cases, as well as programming examples.
+
+.. class:: toc-title
+
+	   Table of contents
+
+.. toctree::
+   :maxdepth: 2
+
+   intro
+   architecture
+   devel-algos
+   userspace-if
+   api
+   api-samples
diff --git a/Documentation/crypto/intro.rst b/Documentation/crypto/intro.rst
new file mode 100644
index 0000000..9aa89eb
--- /dev/null
+++ b/Documentation/crypto/intro.rst
@@ -0,0 +1,74 @@
+Kernel Crypto API Interface Specification
+=========================================
+
+Introduction
+------------
+
+The kernel crypto API offers a rich set of cryptographic ciphers as well
+as other data transformation mechanisms and methods to invoke these.
+This document contains a description of the API and provides example
+code.
+
+To understand and properly use the kernel crypto API a brief explanation
+of its structure is given. Based on the architecture, the API can be
+separated into different components. Following the architecture
+specification, hints to developers of ciphers are provided. Pointers to
+the API function call documentation are given at the end.
+
+The kernel crypto API refers to all algorithms as "transformations".
+Therefore, a cipher handle variable usually has the name "tfm". Besides
+cryptographic operations, the kernel crypto API also knows compression
+transformations and handles them the same way as ciphers.
+
+The kernel crypto API serves the following entity types:
+
+-  consumers requesting cryptographic services
+
+-  data transformation implementations (typically ciphers) that can be
+   called by consumers using the kernel crypto API
+
+This specification is intended for consumers of the kernel crypto API as
+well as for developers implementing ciphers. This API specification,
+however, does not discuss all API calls available to data transformation
+implementations (i.e. implementations of ciphers and other
+transformations (such as CRC or even compression algorithms) that can
+register with the kernel crypto API).
+
+Note: The terms "transformation" and cipher algorithm are used
+interchangeably.
+
+Terminology
+-----------
+
+The transformation implementation is an actual code or interface to
+hardware which implements a certain transformation with precisely
+defined behavior.
+
+The transformation object (TFM) is an instance of a transformation
+implementation. There can be multiple transformation objects associated
+with a single transformation implementation. Each of those
+transformation objects is held by a crypto API consumer or another
+transformation. Transformation object is allocated when a crypto API
+consumer requests a transformation implementation. The consumer is then
+provided with a structure, which contains a transformation object (TFM).
+
+The structure that contains transformation objects may also be referred
+to as a "cipher handle". Such a cipher handle is always subject to the
+following phases that are reflected in the API calls applicable to such
+a cipher handle:
+
+1. Initialization of a cipher handle.
+
+2. Execution of all intended cipher operations applicable for the handle
+   where the cipher handle must be furnished to every API call.
+
+3. Destruction of a cipher handle.
+
+When using the initialization API calls, a cipher handle is created and
+returned to the consumer. Therefore, please refer to all initialization
+API calls that refer to the data structure type a consumer is expected
+to receive and subsequently to use. The initialization API calls have
+all the same naming conventions of crypto_alloc\*.
+
+The transformation context is private data associated with the
+transformation object.
diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
new file mode 100644
index 0000000..de5a72e
--- /dev/null
+++ b/Documentation/crypto/userspace-if.rst
@@ -0,0 +1,387 @@
+User Space Interface
+====================
+
+Introduction
+------------
+
+The concepts of the kernel crypto API visible to kernel space is fully
+applicable to the user space interface as well. Therefore, the kernel
+crypto API high level discussion for the in-kernel use cases applies
+here as well.
+
+The major difference, however, is that user space can only act as a
+consumer and never as a provider of a transformation or cipher
+algorithm.
+
+The following covers the user space interface exported by the kernel
+crypto API. A working example of this description is libkcapi that can
+be obtained from [1]. That library can be used by user space
+applications that require cryptographic services from the kernel.
+
+Some details of the in-kernel kernel crypto API aspects do not apply to
+user space, however. This includes the difference between synchronous
+and asynchronous invocations. The user space API call is fully
+synchronous.
+
+[1] http://www.chronox.de/libkcapi.html
+
+User Space API General Remarks
+------------------------------
+
+The kernel crypto API is accessible from user space. Currently, the
+following ciphers are accessible:
+
+-  Message digest including keyed message digest (HMAC, CMAC)
+
+-  Symmetric ciphers
+
+-  AEAD ciphers
+
+-  Random Number Generators
+
+The interface is provided via socket type using the type AF_ALG. In
+addition, the setsockopt option type is SOL_ALG. In case the user space
+header files do not export these flags yet, use the following macros:
+
+::
+
+    #ifndef AF_ALG
+    #define AF_ALG 38
+    #endif
+    #ifndef SOL_ALG
+    #define SOL_ALG 279
+    #endif
+
+
+A cipher is accessed with the same name as done for the in-kernel API
+calls. This includes the generic vs. unique naming schema for ciphers as
+well as the enforcement of priorities for generic names.
+
+To interact with the kernel crypto API, a socket must be created by the
+user space application. User space invokes the cipher operation with the
+send()/write() system call family. The result of the cipher operation is
+obtained with the read()/recv() system call family.
+
+The following API calls assume that the socket descriptor is already
+opened by the user space application and discusses only the kernel
+crypto API specific invocations.
+
+To initialize the socket interface, the following sequence has to be
+performed by the consumer:
+
+1. Create a socket of type AF_ALG with the struct sockaddr_alg
+   parameter specified below for the different cipher types.
+
+2. Invoke bind with the socket descriptor
+
+3. Invoke accept with the socket descriptor. The accept system call
+   returns a new file descriptor that is to be used to interact with the
+   particular cipher instance. When invoking send/write or recv/read
+   system calls to send data to the kernel or obtain data from the
+   kernel, the file descriptor returned by accept must be used.
+
+In-place Cipher operation
+-------------------------
+
+Just like the in-kernel operation of the kernel crypto API, the user
+space interface allows the cipher operation in-place. That means that
+the input buffer used for the send/write system call and the output
+buffer used by the read/recv system call may be one and the same. This
+is of particular interest for symmetric cipher operations where a
+copying of the output data to its final destination can be avoided.
+
+If a consumer on the other hand wants to maintain the plaintext and the
+ciphertext in different memory locations, all a consumer needs to do is
+to provide different memory pointers for the encryption and decryption
+operation.
+
+Message Digest API
+------------------
+
+The message digest type to be used for the cipher operation is selected
+when invoking the bind syscall. bind requires the caller to provide a
+filled struct sockaddr data structure. This data structure must be
+filled as follows:
+
+::
+
+    struct sockaddr_alg sa = {
+        .salg_family = AF_ALG,
+        .salg_type = "hash", /* this selects the hash logic in the kernel */
+        .salg_name = "sha1" /* this is the cipher name */
+    };
+
+
+The salg_type value "hash" applies to message digests and keyed message
+digests. Though, a keyed message digest is referenced by the appropriate
+salg_name. Please see below for the setsockopt interface that explains
+how the key can be set for a keyed message digest.
+
+Using the send() system call, the application provides the data that
+should be processed with the message digest. The send system call allows
+the following flags to be specified:
+
+-  MSG_MORE: If this flag is set, the send system call acts like a
+   message digest update function where the final hash is not yet
+   calculated. If the flag is not set, the send system call calculates
+   the final message digest immediately.
+
+With the recv() system call, the application can read the message digest
+from the kernel crypto API. If the buffer is too small for the message
+digest, the flag MSG_TRUNC is set by the kernel.
+
+In order to set a message digest key, the calling application must use
+the setsockopt() option of ALG_SET_KEY. If the key is not set the HMAC
+operation is performed without the initial HMAC state change caused by
+the key.
+
+Symmetric Cipher API
+--------------------
+
+The operation is very similar to the message digest discussion. During
+initialization, the struct sockaddr data structure must be filled as
+follows:
+
+::
+
+    struct sockaddr_alg sa = {
+        .salg_family = AF_ALG,
+        .salg_type = "skcipher", /* this selects the symmetric cipher */
+        .salg_name = "cbc(aes)" /* this is the cipher name */
+    };
+
+
+Before data can be sent to the kernel using the write/send system call
+family, the consumer must set the key. The key setting is described with
+the setsockopt invocation below.
+
+Using the sendmsg() system call, the application provides the data that
+should be processed for encryption or decryption. In addition, the IV is
+specified with the data structure provided by the sendmsg() system call.
+
+The sendmsg system call parameter of struct msghdr is embedded into the
+struct cmsghdr data structure. See recv(2) and cmsg(3) for more
+information on how the cmsghdr data structure is used together with the
+send/recv system call family. That cmsghdr data structure holds the
+following information specified with a separate header instances:
+
+-  specification of the cipher operation type with one of these flags:
+
+   -  ALG_OP_ENCRYPT - encryption of data
+
+   -  ALG_OP_DECRYPT - decryption of data
+
+-  specification of the IV information marked with the flag ALG_SET_IV
+
+The send system call family allows the following flag to be specified:
+
+-  MSG_MORE: If this flag is set, the send system call acts like a
+   cipher update function where more input data is expected with a
+   subsequent invocation of the send system call.
+
+Note: The kernel reports -EINVAL for any unexpected data. The caller
+must make sure that all data matches the constraints given in
+/proc/crypto for the selected cipher.
+
+With the recv() system call, the application can read the result of the
+cipher operation from the kernel crypto API. The output buffer must be
+at least as large as to hold all blocks of the encrypted or decrypted
+data. If the output data size is smaller, only as many blocks are
+returned that fit into that output buffer size.
+
+AEAD Cipher API
+---------------
+
+The operation is very similar to the symmetric cipher discussion. During
+initialization, the struct sockaddr data structure must be filled as
+follows:
+
+::
+
+    struct sockaddr_alg sa = {
+        .salg_family = AF_ALG,
+        .salg_type = "aead", /* this selects the symmetric cipher */
+        .salg_name = "gcm(aes)" /* this is the cipher name */
+    };
+
+
+Before data can be sent to the kernel using the write/send system call
+family, the consumer must set the key. The key setting is described with
+the setsockopt invocation below.
+
+In addition, before data can be sent to the kernel using the write/send
+system call family, the consumer must set the authentication tag size.
+To set the authentication tag size, the caller must use the setsockopt
+invocation described below.
+
+Using the sendmsg() system call, the application provides the data that
+should be processed for encryption or decryption. In addition, the IV is
+specified with the data structure provided by the sendmsg() system call.
+
+The sendmsg system call parameter of struct msghdr is embedded into the
+struct cmsghdr data structure. See recv(2) and cmsg(3) for more
+information on how the cmsghdr data structure is used together with the
+send/recv system call family. That cmsghdr data structure holds the
+following information specified with a separate header instances:
+
+-  specification of the cipher operation type with one of these flags:
+
+   -  ALG_OP_ENCRYPT - encryption of data
+
+   -  ALG_OP_DECRYPT - decryption of data
+
+-  specification of the IV information marked with the flag ALG_SET_IV
+
+-  specification of the associated authentication data (AAD) with the
+   flag ALG_SET_AEAD_ASSOCLEN. The AAD is sent to the kernel together
+   with the plaintext / ciphertext. See below for the memory structure.
+
+The send system call family allows the following flag to be specified:
+
+-  MSG_MORE: If this flag is set, the send system call acts like a
+   cipher update function where more input data is expected with a
+   subsequent invocation of the send system call.
+
+Note: The kernel reports -EINVAL for any unexpected data. The caller
+must make sure that all data matches the constraints given in
+/proc/crypto for the selected cipher.
+
+With the recv() system call, the application can read the result of the
+cipher operation from the kernel crypto API. The output buffer must be
+at least as large as defined with the memory structure below. If the
+output data size is smaller, the cipher operation is not performed.
+
+The authenticated decryption operation may indicate an integrity error.
+Such breach in integrity is marked with the -EBADMSG error code.
+
+AEAD Memory Structure
+~~~~~~~~~~~~~~~~~~~~~
+
+The AEAD cipher operates with the following information that is
+communicated between user and kernel space as one data stream:
+
+-  plaintext or ciphertext
+
+-  associated authentication data (AAD)
+
+-  authentication tag
+
+The sizes of the AAD and the authentication tag are provided with the
+sendmsg and setsockopt calls (see there). As the kernel knows the size
+of the entire data stream, the kernel is now able to calculate the right
+offsets of the data components in the data stream.
+
+The user space caller must arrange the aforementioned information in the
+following order:
+
+-  AEAD encryption input: AAD \|\| plaintext
+
+-  AEAD decryption input: AAD \|\| ciphertext \|\| authentication tag
+
+The output buffer the user space caller provides must be at least as
+large to hold the following data:
+
+-  AEAD encryption output: ciphertext \|\| authentication tag
+
+-  AEAD decryption output: plaintext
+
+Random Number Generator API
+---------------------------
+
+Again, the operation is very similar to the other APIs. During
+initialization, the struct sockaddr data structure must be filled as
+follows:
+
+::
+
+    struct sockaddr_alg sa = {
+        .salg_family = AF_ALG,
+        .salg_type = "rng", /* this selects the symmetric cipher */
+        .salg_name = "drbg_nopr_sha256" /* this is the cipher name */
+    };
+
+
+Depending on the RNG type, the RNG must be seeded. The seed is provided
+using the setsockopt interface to set the key. For example, the
+ansi_cprng requires a seed. The DRBGs do not require a seed, but may be
+seeded.
+
+Using the read()/recvmsg() system calls, random numbers can be obtained.
+The kernel generates at most 128 bytes in one call. If user space
+requires more data, multiple calls to read()/recvmsg() must be made.
+
+WARNING: The user space caller may invoke the initially mentioned accept
+system call multiple times. In this case, the returned file descriptors
+have the same state.
+
+Zero-Copy Interface
+-------------------
+
+In addition to the send/write/read/recv system call family, the AF_ALG
+interface can be accessed with the zero-copy interface of
+splice/vmsplice. As the name indicates, the kernel tries to avoid a copy
+operation into kernel space.
+
+The zero-copy operation requires data to be aligned at the page
+boundary. Non-aligned data can be used as well, but may require more
+operations of the kernel which would defeat the speed gains obtained
+from the zero-copy interface.
+
+The system-interent limit for the size of one zero-copy operation is 16
+pages. If more data is to be sent to AF_ALG, user space must slice the
+input into segments with a maximum size of 16 pages.
+
+Zero-copy can be used with the following code example (a complete
+working example is provided with libkcapi):
+
+::
+
+    int pipes[2];
+
+    pipe(pipes);
+    /* input data in iov */
+    vmsplice(pipes[1], iov, iovlen, SPLICE_F_GIFT);
+    /* opfd is the file descriptor returned from accept() system call */
+    splice(pipes[0], NULL, opfd, NULL, ret, 0);
+    read(opfd, out, outlen);
+
+
+Setsockopt Interface
+--------------------
+
+In addition to the read/recv and send/write system call handling to send
+and retrieve data subject to the cipher operation, a consumer also needs
+to set the additional information for the cipher operation. This
+additional information is set using the setsockopt system call that must
+be invoked with the file descriptor of the open cipher (i.e. the file
+descriptor returned by the accept system call).
+
+Each setsockopt invocation must use the level SOL_ALG.
+
+The setsockopt interface allows setting the following data using the
+mentioned optname:
+
+-  ALG_SET_KEY -- Setting the key. Key setting is applicable to:
+
+   -  the skcipher cipher type (symmetric ciphers)
+
+   -  the hash cipher type (keyed message digests)
+
+   -  the AEAD cipher type
+
+   -  the RNG cipher type to provide the seed
+
+-  ALG_SET_AEAD_AUTHSIZE -- Setting the authentication tag size for
+   AEAD ciphers. For a encryption operation, the authentication tag of
+   the given size will be generated. For a decryption operation, the
+   provided ciphertext is assumed to contain an authentication tag of
+   the given size (see section about AEAD memory layout below).
+
+User space API example
+----------------------
+
+Please see [1] for libkcapi which provides an easy-to-use wrapper around
+the aforementioned Netlink kernel interface. [1] also contains a test
+application that invokes all libkcapi API calls.
+
+[1] http://www.chronox.de/libkcapi.html
diff --git a/Documentation/index.rst b/Documentation/index.rst
index c53d089..5591eeb 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -18,6 +18,7 @@ Contents:
    media/index
    gpu/index
    80211/index
+   crypto/index
 
 Indices and tables
 ==================
-- 
2.7.4
