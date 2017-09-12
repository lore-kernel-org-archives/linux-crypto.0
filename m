From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: inside-secure - fix gcc-4.9 warnings
Date: Tue, 12 Sep 2017 12:12:16 +0200
Message-ID: <20170912101232.3688217-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>, Ofer Heifetz <oferh@marvell.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

All older compiler versions up to gcc-4.9 produce these
harmless warnings:

drivers/crypto/inside-secure/safexcel_cipher.c:389:9: warning: missing braces around initializer [-Wmissing-braces]
drivers/crypto/inside-secure/safexcel_cipher.c:389:9: warning: (near initialization for ‘result.completion’) [-Wmissing-braces]
drivers/crypto/inside-secure/safexcel_hash.c:422:9: warning: missing braces around initializer [-Wmissing-braces]
drivers/crypto/inside-secure/safexcel_hash.c:422:9: warning: (near initialization for ‘result.completion’) [-Wmissing-braces]

This changes the syntax to something that works on all versions
without warnings.

Fixes: 1b44c5a60c13 ("crypto: inside-secure - add SafeXcel EIP197 crypto engine driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
 drivers/crypto/inside-secure/safexcel_hash.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index d2207ac5ba19..5438552bc6d7 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -386,7 +386,7 @@ static int safexcel_cipher_exit_inv(struct crypto_tfm *tfm)
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct skcipher_request req;
-	struct safexcel_inv_result result = { 0 };
+	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
 
 	memset(&req, 0, sizeof(struct skcipher_request));
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 3f819399cd95..3980f946874f 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -419,7 +419,7 @@ static int safexcel_ahash_exit_inv(struct crypto_tfm *tfm)
 	struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct ahash_request req;
-	struct safexcel_inv_result result = { 0 };
+	struct safexcel_inv_result result = {};
 	int ring = ctx->base.ring;
 
 	memset(&req, 0, sizeof(struct ahash_request));
-- 
2.9.0
