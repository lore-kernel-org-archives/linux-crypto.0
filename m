From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] geode: PTR_ERR return of wrong pointer in fallback_init_cip()
Date: Mon, 07 Dec 2009 14:28:23 +0100
Message-ID: <4B1D02F7.2020505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935053AbZLGN1R@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/crypto/geode-aes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 4801162..12cf864 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 
 	if (IS_ERR(op->fallback.cip)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(op->fallback.blk);
+		return PTR_ERR(op->fallback.cip);
 	}
 
 	return 0;
