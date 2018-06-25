From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 01/11] crypto: xcbc: Remove VLA usage
Date: Mon, 25 Jun 2018 14:10:16 -0700
Message-ID: <20180625211026.15819-2-keescook@chromium.org>
References: <20180625211026.15819-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, qat-linux@intel.com,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180625211026.15819-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this uses
the maximum blocksize and adds a sanity check. For xcbc, the blocksize
must always be 16, so use that, since it's already being enforced during
instantiation.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/xcbc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 25c75af50d3f..7aa03beed795 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -57,6 +57,8 @@ struct xcbc_desc_ctx {
 	u8 ctx[];
 };
 
+#define XCBC_BLOCKSIZE	16
+
 static int crypto_xcbc_digest_setkey(struct crypto_shash *parent,
 				     const u8 *inkey, unsigned int keylen)
 {
@@ -65,7 +67,10 @@ static int crypto_xcbc_digest_setkey(struct crypto_shash *parent,
 	int bs = crypto_shash_blocksize(parent);
 	u8 *consts = PTR_ALIGN(&ctx->ctx[0], alignmask + 1);
 	int err = 0;
-	u8 key1[bs];
+	u8 key1[XCBC_BLOCKSIZE];
+
+	if (WARN_ON(bs > sizeof(key1)))
+		return -EINVAL;
 
 	if ((err = crypto_cipher_setkey(ctx->child, inkey, keylen)))
 		return err;
@@ -212,7 +217,7 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return PTR_ERR(alg);
 
 	switch(alg->cra_blocksize) {
-	case 16:
+	case XCBC_BLOCKSIZE:
 		break;
 	default:
 		goto out_put_alg;
-- 
2.17.1
