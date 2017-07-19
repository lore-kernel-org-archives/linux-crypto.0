From: Colin King <colin.king@canonical.com>
Subject: [PATCH] Crypto: atmel-ecc: Make a couple of local functions static
Date: Wed, 19 Jul 2017 10:24:15 +0100
Message-ID: <20170719092415.9553-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Functions atmel_ecc_i2c_client_alloc and atmel_ecc_i2c_client_free are
local to the source and no not need to be in the global scope. Make
them static.

Cleans up sparse warnings:
symbol 'atmel_ecc_i2c_client_alloc' was not declared. Should it be static?
symbol 'atmel_ecc_i2c_client_free' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/atmel-ecc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 66ab1021eba5..c6e8de2b28dd 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -492,7 +492,7 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 	return ret;
 }
 
-struct i2c_client *atmel_ecc_i2c_client_alloc(void)
+static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 {
 	struct atmel_ecc_i2c_client_priv *i2c_priv, *min_i2c_priv = NULL;
 	struct i2c_client *client = ERR_PTR(-ENODEV);
@@ -527,7 +527,7 @@ struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 	return client;
 }
 
-void atmel_ecc_i2c_client_free(struct i2c_client *client)
+static void atmel_ecc_i2c_client_free(struct i2c_client *client)
 {
 	struct atmel_ecc_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-- 
2.11.0
