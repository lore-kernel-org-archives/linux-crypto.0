From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v5 05/11] crypto: ahash: Remove VLA usage
Date: Mon, 16 Jul 2018 21:21:44 -0700
Message-ID: <20180717042150.37761-6-keescook@chromium.org>
References: <20180717042150.37761-1-keescook@chromium.org>
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
	Tim Chen <tim.c.chen@linux.intel.com>, Alasdair Kergon <agk@redhat.com>,
	Rabin Vincent <rabinv@axis.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180717042150.37761-1-keescook@chromium.org>
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
introduces max size macros for ahash, as already done for shash, and
adjust the crypto user to max state size.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/ahash.c        | 4 ++--
 crypto/algif_hash.c   | 2 +-
 include/crypto/hash.h | 3 +++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index a64c143165b1..6435bdbe42fd 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -550,8 +550,8 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 {
 	struct crypto_alg *base = &alg->halg.base;
 
-	if (alg->halg.digestsize > PAGE_SIZE / 8 ||
-	    alg->halg.statesize > PAGE_SIZE / 8 ||
+	if (alg->halg.digestsize > AHASH_MAX_DIGESTSIZE ||
+	    alg->halg.statesize > AHASH_MAX_STATESIZE ||
 	    alg->halg.statesize == 0)
 		return -EINVAL;
 
diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index bfcf595fd8f9..8974ee8ebead 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -239,7 +239,7 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags,
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
 	struct ahash_request *req = &ctx->req;
-	char state[crypto_ahash_statesize(crypto_ahash_reqtfm(req)) ? : 1];
+	char state[AHASH_MAX_STATESIZE];
 	struct sock *sk2;
 	struct alg_sock *ask2;
 	struct hash_ctx *ctx2;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index ae14cc0e0cdb..4fcd0e2368cd 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -64,6 +64,9 @@ struct ahash_request {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
+#define AHASH_MAX_DIGESTSIZE	512
+#define AHASH_MAX_STATESIZE	512
+
 #define AHASH_REQUEST_ON_STACK(name, ahash) \
 	char __##name##_desc[sizeof(struct ahash_request) + \
 		crypto_ahash_reqsize(ahash)] CRYPTO_MINALIGN_ATTR; \
-- 
2.17.1
