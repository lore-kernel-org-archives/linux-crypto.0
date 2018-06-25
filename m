From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 03/11] crypto: shash: Remove VLA usage
Date: Mon, 25 Jun 2018 14:10:18 -0700
Message-ID: <20180625211026.15819-4-keescook@chromium.org>
References: <20180625211026.15819-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Eric Biggers <ebiggers@google.com>, qat-linux@intel.com,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org, Lars Persson <larper@axis.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
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

In the quest to remove all stack VLA usage from the kernel[1], this
removes the VLAs in SHASH_DESC_ON_STACK (via crypto_shash_descsize())
by using the maximum allowable size (which is now more clearly captured
in a macro). Similar limits are turned into macros as well.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/shash.c        | 6 +++---
 include/crypto/hash.h | 6 +++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 5d732c6bb4b2..ab6902c6dae7 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -458,9 +458,9 @@ static int shash_prepare_alg(struct shash_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
-	if (alg->digestsize > PAGE_SIZE / 8 ||
-	    alg->descsize > PAGE_SIZE / 8 ||
-	    alg->statesize > PAGE_SIZE / 8)
+	if (alg->digestsize > SHASH_MAX_DIGESTSIZE ||
+	    alg->descsize > SHASH_MAX_DESCSIZE ||
+	    alg->statesize > SHASH_MAX_STATESIZE)
 		return -EINVAL;
 
 	base->cra_type = &crypto_shash_type;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 76e432cab75d..804e87a9510e 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -151,9 +151,13 @@ struct shash_desc {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
+#define SHASH_MAX_DIGESTSIZE    512
+#define SHASH_MAX_DESCSIZE      512
+#define SHASH_MAX_STATESIZE     512
+
 #define SHASH_DESC_ON_STACK(shash, ctx)				  \
 	char __##shash##_desc[sizeof(struct shash_desc) +	  \
-		crypto_shash_descsize(ctx)] CRYPTO_MINALIGN_ATTR; \
+		SHASH_MAX_DESCSIZE] CRYPTO_MINALIGN_ATTR; \
 	struct shash_desc *shash = (struct shash_desc *)__##shash##_desc
 
 /**
-- 
2.17.1
