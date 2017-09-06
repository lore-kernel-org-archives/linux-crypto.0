From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: axis - hide an unused variable
Date: Wed,  6 Sep 2017 15:10:15 +0200
Message-ID: <20170906131033.2690066-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Niklas Cassel <niklas.cassel@axis.com>,
        linux-arm-kernel@axis.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Without CONFIG_DEBUG_FS, we get a harmless warning:

drivers/crypto/axis/artpec6_crypto.c:352:23: error: 'dbgfs_root' defined but not used [-Werror=unused-variable]

This moves it into the #ifdef that hides the only user.

Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
Acked-by: Lars Persson <larper@axis.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Originally sent on August 25, but hasn't made it into linux-next
yet. Resending it in case it got lost, sorry for any duplicates
if this was still pending.
---
 drivers/crypto/axis/artpec6_crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index d9fbbf01062b..0f9754e07719 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -349,8 +349,6 @@ struct artpec6_crypto_aead_req_ctx {
 /* The crypto framework makes it hard to avoid this global. */
 static struct device *artpec6_crypto_dev;
 
-static struct dentry *dbgfs_root;
-
 #ifdef CONFIG_FAULT_INJECTION
 static DECLARE_FAULT_ATTR(artpec6_crypto_fail_status_read);
 static DECLARE_FAULT_ATTR(artpec6_crypto_fail_dma_array_full);
@@ -2984,6 +2982,8 @@ struct dbgfs_u32 {
 	char *desc;
 };
 
+static struct dentry *dbgfs_root;
+
 static void artpec6_crypto_init_debugfs(void)
 {
 	dbgfs_root = debugfs_create_dir("artpec6_crypto", NULL);
-- 
2.9.0
