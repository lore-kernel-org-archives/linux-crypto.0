From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: axis - hide an unused variable
Date: Fri, 25 Aug 2017 00:19:54 +0200
Message-ID: <20170824222016.731342-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@axis.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>,
        Niklas Cassel <niklas.cassel@axis.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:63287 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753566AbdHXWUi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Aug 2017 18:20:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Without CONFIG_DEBUG_FS, we get a harmless warning:

drivers/crypto/axis/artpec6_crypto.c:352:23: error: 'dbgfs_root' defined but not used [-Werror=unused-variable]

This moves it into the #ifdef that hides the only user.

Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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
