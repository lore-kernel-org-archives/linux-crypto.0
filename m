From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 10/11] crypto: ahash: Remove VLA usage for
	AHASH_REQUEST_ON_STACK
Date: Mon, 25 Jun 2018 14:10:25 -0700
Message-ID: <20180625211026.15819-11-keescook@chromium.org>
References: <20180625211026.15819-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
	Eric Biggers <ebiggers@google.com>, Mike Snitzer <snitzer@redhat.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	qat-linux@intel.com, linux-kernel@vger.kernel.org,
	dm-devel@redhat.com, linux-crypto@vger.kernel.org,
	Lars Persson <larper@axis.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Rabin Vincent <rabinv@axis.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180625211026.15819-1-keescook@chromium.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this caps
the ahash request size similar to the other limits and adds a sanity
check at registration. Unfortunately, these reqsizes can be huge. Looking
at all callers of crypto_ahash_set_reqsize(), the largest appears to be
664 bytes, based on a combination of manual inspection and pahole output:

4       dcp_sha_req_ctx
40      crypto4xx_ctx
52      hash_req_ctx
80      ahash_request
88      rk_ahash_rctx
104     sun4i_req_ctx
200     mcryptd_hash_request_ctx
216     safexcel_ahash_req
228     sha1_hash_ctx
228     sha256_hash_ctx
248     img_hash_request_ctx
252     mtk_sha_reqctx
276     sahara_sha_reqctx
304     mv_cesa_ahash_req
316     iproc_reqctx_s
320     caam_hash_state
320     qce_sha_reqctx
356     sha512_hash_ctx
384     ahash_req_ctx
400     chcr_ahash_req_ctx
416     stm32_hash_request_ctx
432     talitos_ahash_req_ctx
462     atmel_sha_reqctx
496     ccp_aes_cmac_req_ctx
616     ccp_sha_req_ctx
664     artpec6_hash_request_context

So, this chooses 720 as a larger "round" number for the max.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Rabin Vincent <rabinv@axis.com>
Cc: Lars Persson <larper@axis.com>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/crypto/hash.h          | 3 ++-
 include/crypto/internal/hash.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 5d79e2f0936e..b550077c4767 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -66,10 +66,11 @@ struct ahash_request {
 
 #define AHASH_MAX_DIGESTSIZE	512
 #define AHASH_MAX_STATESIZE	512
+#define AHASH_MAX_REQSIZE	720
 
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
