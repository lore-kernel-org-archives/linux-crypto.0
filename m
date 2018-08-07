From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v8 7/9] crypto: qat: Remove VLA usage
Date: Tue,  7 Aug 2018 14:18:41 -0700
Message-ID: <20180807211843.47586-8-keescook@chromium.org>
References: <20180807211843.47586-1-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Eric Biggers <ebiggers@google.com>,
	Will Deacon <will.deacon@arm.com>, qat-linux@intel.com,
	Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	dm-devel@redhat.com, Geert Uytterhoeven <geert@linux-m68k.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alasdair Kergon <agk@redhat.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180807211843.47586-1-keescook@chromium.org>
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

In the quest to remove all stack VLA usage from the kernel[1], this uses
the new upper bound for the stack buffer. Also adds a sanity check.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 1138e41d6805..a28edf7b792f 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -153,8 +153,8 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	struct sha512_state sha512;
 	int block_size = crypto_shash_blocksize(ctx->hash_tfm);
 	int digest_size = crypto_shash_digestsize(ctx->hash_tfm);
-	char ipad[block_size];
-	char opad[block_size];
+	char ipad[MAX_ALGAPI_BLOCKSIZE];
+	char opad[MAX_ALGAPI_BLOCKSIZE];
 	__be32 *hash_state_out;
 	__be64 *hash512_state_out;
 	int i, offset;
@@ -164,6 +164,10 @@ static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
 	shash->tfm = ctx->hash_tfm;
 	shash->flags = 0x0;
 
+	if (WARN_ON(block_size > sizeof(ipad) ||
+		    sizeof(ipad) != sizeof(opad)))
+		return -EINVAL;
+
 	if (auth_keylen > block_size) {
 		int ret = crypto_shash_digest(shash, auth_key,
 					      auth_keylen, ipad);
-- 
2.17.1
