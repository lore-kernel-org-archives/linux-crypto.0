From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 02/24] crypto: atmel-aes: constify value argument of atmel_aes_write_n()
Date: Thu, 17 Dec 2015 17:48:33 +0100
Message-ID: <f5c31bdb23fc62c1230bf0ca131a86f10a05c679.1450366831.git.cyrille.pitchen@atmel.com>
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

atmel_aes_write_n() should not modify its value argument.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 854e2813b2bb..1d3997a45610 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -231,7 +231,7 @@ static void atmel_aes_read_n(struct atmel_aes_dev *dd, u32 offset,
 }
 
 static void atmel_aes_write_n(struct atmel_aes_dev *dd, u32 offset,
-					u32 *value, int count)
+			      const u32 *value, int count)
 {
 	for (; count--; value++, offset += 4)
 		atmel_aes_write(dd, offset, *value);
-- 
1.8.2.2
