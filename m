From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 23/23] crypto: skcipher - Remove SKCIPHER_REQUEST_ON_STACK()
Date: Tue, 18 Sep 2018 19:11:00 -0700
Message-ID: <20180919021100.3380-24-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919021100.3380-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that all the users of the VLA-generating SKCIPHER_REQUEST_ON_STACK()
macro have been moved to SYNC_SKCIPHER_REQUEST_ON_STACK(), we can remove
the former.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/crypto/skcipher.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index d00ce90dc7da..45ae894fda32 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -156,11 +156,6 @@ struct skcipher_alg {
 			    ] CRYPTO_MINALIGN_ATTR; \
 	struct skcipher_request *name = (void *)__##name##_desc
 
-#define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
-	char __##name##_desc[sizeof(struct skcipher_request) + \
-		crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
-	struct skcipher_request *name = (void *)__##name##_desc
-
 /**
  * DOC: Symmetric Key Cipher API
  *
-- 
2.17.1
