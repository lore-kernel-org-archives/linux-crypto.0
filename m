From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 2/5] crypto: sunxi-ss: fix min3() call to match types
Date: Tue, 22 Dec 2015 12:27:44 +0000
Message-ID: <1450787267-26836-3-git-send-email-andre.przywara@arm.com>
References: <1450787267-26836-1-git-send-email-andre.przywara@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
	linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, arnd@arndb.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450787267-26836-1-git-send-email-andre.przywara@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The min3() macro expects all arguments to be of the same type (or
size at least). While two arguments are ints or u32s, one is size_t,
which does not match on 64-bit architectures.
Cast the size_t to u32 to make min3() happy. In this context here the
length should never exceed 32 bits anyway.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 drivers/crypto/sunxi-ss/sun4i-ss-cipher.c | 12 ++++++------
 drivers/crypto/sunxi-ss/sun4i-ss-hash.c   |  8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index a19ee12..b3bc7bd 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -79,7 +79,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 	oi = 0;
 	oo = 0;
 	do {
-		todo = min3(rx_cnt, ileft, (mi.length - oi) / 4);
+		todo = min3(rx_cnt, ileft, (u32)(mi.length - oi) / 4);
 		if (todo > 0) {
 			ileft -= todo;
 			writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
@@ -94,7 +94,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
 		rx_cnt = SS_RXFIFO_SPACES(spaces);
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
 
-		todo = min3(tx_cnt, oleft, (mo.length - oo) / 4);
+		todo = min3(tx_cnt, oleft, (u32)(mo.length - oo) / 4);
 		if (todo > 0) {
 			oleft -= todo;
 			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
@@ -216,7 +216,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 			 * todo is the number of consecutive 4byte word that we
 			 * can read from current SG
 			 */
-			todo = min3(rx_cnt, ileft / 4, (mi.length - oi) / 4);
+			todo = min3(rx_cnt, ileft / 4, (u32)(mi.length - oi) / 4);
 			if (todo > 0 && ob == 0) {
 				writesl(ss->base + SS_RXFIFO, mi.addr + oi,
 					todo);
@@ -231,7 +231,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 				 * pass, so it is why we min() with rx_cnt
 				 */
 				todo = min3(rx_cnt * 4 - ob, ileft,
-					    mi.length - oi);
+					    (u32)mi.length - oi);
 				memcpy(buf + ob, mi.addr + oi, todo);
 				ileft -= todo;
 				oi += todo;
@@ -260,7 +260,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 		if (tx_cnt == 0)
 			continue;
 		/* todo in 4bytes word */
-		todo = min3(tx_cnt, oleft / 4, (mo.length - oo) / 4);
+		todo = min3(tx_cnt, oleft / 4, (u32)(mo.length - oo) / 4);
 		if (todo > 0) {
 			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
 			oleft -= todo * 4;
@@ -284,7 +284,7 @@ static int sun4i_ss_cipher_poll(struct ablkcipher_request *areq)
 				 * no more than remaining buffer
 				 * no need to test against oleft
 				 */
-				todo = min(mo.length - oo, obl - obo);
+				todo = min((u32)mo.length - oo, obl - obo);
 				memcpy(mo.addr + oo, bufo + obo, todo);
 				oleft -= todo;
 				obo += todo;
diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
index ff80314..cd29009 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-hash.c
@@ -245,7 +245,7 @@ int sun4i_hash_update(struct ahash_request *areq)
 			 */
 			while (op->len < 64 && i < end) {
 				/* how many bytes we can read from current SG */
-				in_r = min3(mi.length - in_i, end - i,
+				in_r = min3((u32)mi.length - in_i, end - i,
 					    64 - op->len);
 				memcpy(op->buf + op->len, mi.addr + in_i, in_r);
 				op->len += in_r;
@@ -266,8 +266,8 @@ int sun4i_hash_update(struct ahash_request *areq)
 		}
 		if (mi.length - in_i > 3 && i < end) {
 			/* how many bytes we can read from current SG */
-			in_r = min3(mi.length - in_i, areq->nbytes - i,
-				    ((mi.length - in_i) / 4) * 4);
+			in_r = min3((u32)mi.length - in_i, areq->nbytes - i,
+				    ((u32)(mi.length - in_i) / 4) * 4);
 			/* how many bytes we can write in the device*/
 			todo = min3((u32)(end - i) / 4, rx_cnt, (u32)in_r / 4);
 			writesl(ss->base + SS_RXFIFO, mi.addr + in_i, todo);
@@ -289,7 +289,7 @@ int sun4i_hash_update(struct ahash_request *areq)
 	if ((areq->nbytes - i) < 64) {
 		while (i < areq->nbytes && in_i < mi.length && op->len < 64) {
 			/* how many bytes we can read from current SG */
-			in_r = min3(mi.length - in_i, areq->nbytes - i,
+			in_r = min3((u32)mi.length - in_i, areq->nbytes - i,
 				    64 - op->len);
 			memcpy(op->buf + op->len, mi.addr + in_i, in_r);
 			op->len += in_r;
-- 
2.5.1
