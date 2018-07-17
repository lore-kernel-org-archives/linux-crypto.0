From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v5 10/11] crypto: ahash: Remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Mon, 16 Jul 2018 21:21:49 -0700
Message-ID: <20180717042150.37761-11-keescook@chromium.org>
References: <20180717042150.37761-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717042150.37761-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this caps
the ahash request size similar to the other limits and adds a sanity
check at initialization. AHASH_REQUEST_ON_STACK is special, though: it
is only ever used for shash-wrapped ahash, so its size is bounded only
by non-async hashes. A manual inspection of this shows the largest to be:
sizeof(struct shash_desc) + SHASH_MAX_DESCSIZE

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/shash.c        |  9 ++++++++-
 include/crypto/hash.h | 10 +++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 8d4746b14dd5..e344560458cb 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -355,6 +355,7 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	struct crypto_ahash *crt = __crypto_ahash_cast(tfm);
 	struct crypto_shash **ctx = crypto_tfm_ctx(tfm);
 	struct crypto_shash *shash;
+	size_t reqsize;
 
 	if (!crypto_mod_get(calg))
 		return -EAGAIN;
@@ -365,6 +366,12 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 		return PTR_ERR(shash);
 	}
 
+	reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
+	if (WARN_ON(reqsize > AHASH_MAX_REQSIZE)) {
+		crypto_mod_put(calg);
+		return -EINVAL;
+	}
+
 	*ctx = shash;
 	tfm->exit = crypto_exit_shash_ops_async;
 
@@ -383,7 +390,7 @@ int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	if (alg->import)
 		crt->import = shash_async_import;
 
-	crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
+	crt->reqsize = reqsize;
 
 	return 0;
 }
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 4fcd0e2368cd..2181fb38eab9 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -67,9 +67,17 @@ struct ahash_request {
 #define AHASH_MAX_DIGESTSIZE	512
 #define AHASH_MAX_STATESIZE	512
 
+/*
+ * HASH_REQUEST_ON_STACK must only be used when wrapping shash (i.e.
+ * allocated with a CRYPTO_ALG_ASYNC mask), and is generally discouraged
+ * (just use shash directly). This is really only ever needed when using
+ * scatter/gather input sources.
+ */
+#define AHASH_MAX_REQSIZE	(sizeof(struct shash_desc) + \
+				 SHASH_MAX_DESCSIZE)
 #define AHASH_REQUEST_ON_STACK(name, ahash) \
 	char __##name##_desc[sizeof(struct ahash_request) + \
-		crypto_ahash_reqsize(ahash)] CRYPTO_MINALIGN_ATTR; \
+		AHASH_MAX_REQSIZE] CRYPTO_MINALIGN_ATTR; \
 	struct ahash_request *name = (void *)__##name##_desc
 
 /**
-- 
2.17.1
