From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] crypto: nx: constify vio_device_id
Date: Thu, 17 Aug 2017 18:44:10 +0530
Message-ID: <35e1702104da09dee65dd407bde06b8cb31f6483.1502974810.git.arvind.yadav.cs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        benh@kernel.crashing.org, leosilva@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

vio_device_id are not supposed to change at runtime. All functions
working with vio_device_id provided by <asm/vio.h> work with
const vio_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/nx/nx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 036057a..3a5e31b 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -833,7 +833,7 @@ static void __exit nx_fini(void)
 	vio_unregister_driver(&nx_driver.viodriver);
 }
 
-static struct vio_device_id nx_crypto_driver_ids[] = {
+static const struct vio_device_id nx_crypto_driver_ids[] = {
 	{ "ibm,sym-encryption-v1", "ibm,sym-encryption" },
 	{ "", "" }
 };
-- 
2.7.4
