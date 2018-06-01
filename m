From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: cavium: make structure algs static
Date: Fri,  1 Jun 2018 14:12:27 +0100
Message-ID: <20180601131227.1340-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: George Cherian <george.cherian@cavium.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The structure algs is local to the source and does not need to be in
global scope, so make it static.

Cleans up sparse warning:
drivers/crypto/cavium/cpt/cptvf_algs.c:354:19: warning: symbol 'algs'
was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/cavium/cpt/cptvf_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index df21d996db7e..600336d169a9 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -351,7 +351,7 @@ static int cvm_enc_dec_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-struct crypto_alg algs[] = { {
+static struct crypto_alg algs[] = { {
 	.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC,
 	.cra_blocksize = AES_BLOCK_SIZE,
 	.cra_ctxsize = sizeof(struct cvm_enc_ctx),
-- 
2.17.0
