From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 3/4] drivers/crypto/ixp4xx_crypto.c: convert GFP_KERNEL to GFP_ATOMIC
Date: Mon,  9 Jan 2012 10:40:49 +0100
Message-ID: <1326102050-30265-3-git-send-email-Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Julia Lawall <julia.lawall@lip6.fr>

The function is called with locks held and thus should not use GFP_KERNEL.

The semantic patch that makes this report is available
in scripts/coccinelle/locks/call_kern.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>

---
 drivers/crypto/ixp4xx_crypto.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 4c20c5b..bc349cc 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -265,7 +265,7 @@ static int setup_crypt_desc(void)
 	BUILD_BUG_ON(sizeof(struct crypt_ctl) != 64);
 	crypt_virt = dma_alloc_coherent(dev,
 			NPE_QLEN * sizeof(struct crypt_ctl),
-			&crypt_phys, GFP_KERNEL);
+			&crypt_phys, GFP_ATOMIC);
 	if (!crypt_virt)
 		return -ENOMEM;
 	memset(crypt_virt, 0, NPE_QLEN * sizeof(struct crypt_ctl));
