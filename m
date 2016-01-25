From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/4] crypto: sunxi - don't print uninitialized data
Date: Mon, 25 Jan 2016 17:53:48 +0100
Message-ID: <1453740845-1980433-1-git-send-email-arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

gcc correctly warns that the printk output contains a variable that
is not initialized in some cases:

drivers/crypto/sunxi-ss/sun4i-ss-cipher.c: In function 'sun4i_ss_cipher_poll':
drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:254:76: warning: 'todo' may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:144:15: note: 'todo' was declared here

This adds an explicit initialization to zero in the exact case where it
was missing, to avoid leaking stack data to the console and to shut up
that warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index a19ee127edca..db52ae16c147 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -246,6 +246,8 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 				sg_miter_next(&mi);
 				oi = 0;
 			}
+		} else {
+			todo = 0;
 		}
 
 		spaces = readl(ss->base + SS_FCSR);
-- 
2.7.0
