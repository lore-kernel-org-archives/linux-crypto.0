From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 12/24] crypto: atmel-aes: remove unused 'err' member of struct atmel_aes_dev
Date: Thu, 17 Dec 2015 17:48:43 +0100
Message-ID: <75eec0cd71650aa6526aebbe619eb36ce3372a03.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This 'err' member was initialized to 0 but its value never changed.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index ac551ee2d624..25dc7bd73532 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -127,7 +127,6 @@ struct atmel_aes_dev {
 	int	irq;
 
 	unsigned long		flags;
-	int	err;
 
 	spinlock_t		lock;
 	struct crypto_queue	queue;
@@ -288,7 +287,6 @@ static int atmel_aes_hw_init(struct atmel_aes_dev *dd)
 		atmel_aes_write(dd, AES_CR, AES_CR_SWRST);
 		atmel_aes_write(dd, AES_MR, 0xE << AES_MR_CKEY_OFFSET);
 		dd->flags |= AES_FLAGS_INIT;
-		dd->err = 0;
 	}
 
 	return 0;
@@ -1171,9 +1169,6 @@ static int atmel_aes_dma_complete(struct atmel_aes_dev *dd)
 	int err;
 
 	err = atmel_aes_crypt_dma_stop(dd);
-
-	err = dd->err ? : err;
-
 	if (dd->total && !err) {
 		if (dd->flags & AES_FLAGS_FAST) {
 			dd->in_sg = sg_next(dd->in_sg);
-- 
1.8.2.2
