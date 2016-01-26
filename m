From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 1/2] crypto: sunxi - don't print confusing data
Date: Tue, 26 Jan 2016 14:44:50 +0100
Message-ID: <1453815902-3070323-1-git-send-email-arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:53296 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965130AbcAZNp7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 08:45:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

gcc correctly warns that the printk output contains a variable that
it thinks is not initialized in some cases:

drivers/crypto/sunxi-ss/sun4i-ss-cipher.c: In function 'sun4i_ss_cipher_poll':
drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:254:76: warning: 'todo' may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:144:15: note: 'todo' was declared here

A closer look at the function reveals that the variable is always
initialized at this point (ileft is guaranteed to be positive at the
start), but its contents are not well-defined:
Depending on some other variables, it might be either a count in
words or bytes, and it could refer to either input or output.

The easiest solution apparently is to remove the confusing output
and let the reader figure out the state from the other variables.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index a19ee127edca..7be3fbcd8d78 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -251,11 +251,10 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 		spaces = readl(ss->base + SS_FCSR);
 		rx_cnt = SS_RXFIFO_SPACES(spaces);
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
-		dev_dbg(ss->dev, "%x %u/%u %u/%u cnt=%u %u/%u %u/%u cnt=%u %u %u\n",
+		dev_dbg(ss->dev, "%x %u/%u %u/%u cnt=%u %u/%u %u/%u cnt=%u %u\n",
 			mode,
 			oi, mi.length, ileft, areq->nbytes, rx_cnt,
-			oo, mo.length, oleft, areq->nbytes, tx_cnt,
-			todo, ob);
+			oo, mo.length, oleft, areq->nbytes, tx_cnt, ob);
 
 		if (tx_cnt == 0)
 			continue;
-- 
2.7.0
