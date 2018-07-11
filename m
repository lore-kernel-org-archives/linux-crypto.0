From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v4 12/14] crypto: ahash: Remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Wed, 11 Jul 2018 13:36:17 -0700
Message-ID: <20180711203619.1020-13-keescook@chromium.org>
References: <20180711203619.1020-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-crypto@vger.kernel.org, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711203619.1020-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this caps
the ahash request size similar to the other limits and adds a sanity
check at registration. Unfortunately, these reqsizes can be very large.
Looking at instrumented tcrypt output, the largest is for sha512:

	crypt: testing sha512
	crypto_ahash_set_reqsize: 528
	crypto_ahash_set_reqsize: 728
	crypto_ahash_set_reqsize: 808

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/crypto/hash.h          | 3 ++-
 include/crypto/internal/hash.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 4fcd0e2368cd..9290120536cd 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -66,10 +66,11 @@ struct ahash_request {
 
 #define AHASH_MAX_DIGESTSIZE	512
 #define AHASH_MAX_STATESIZE	512
+#define AHASH_MAX_REQSIZE	808
 
 #define AHASH_REQUEST_ON_STACK(name, ahash) \
 	char __##name##_desc[sizeof(struct ahash_request) + \
-		crypto_ahash_reqsize(ahash)] CRYPTO_MINALIGN_ATTR; \
+		AHASH_MAX_REQSIZE] CRYPTO_MINALIGN_ATTR; \
 	struct ahash_request *name = (void *)__##name##_desc
 
 /**
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index a0b0ad9d585e..d96ae5f52125 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -142,6 +142,7 @@ static inline struct ahash_alg *__crypto_ahash_alg(struct crypto_alg *alg)
 static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
 					    unsigned int reqsize)
 {
+	BUG_ON(reqsize > AHASH_MAX_REQSIZE);
 	tfm->reqsize = reqsize;
 }
 
-- 
2.17.1
