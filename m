From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 05/24] crypto: atmel-aes: remove unused header includes
Date: Thu, 17 Dec 2015 17:48:36 +0100
Message-ID: <c33f39fa103fa81c834d87c2eed899b88268726d.1450366831.git.cyrille.pitchen@atmel.com>
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

Hash headers have nothing to do with AES block ciphers.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index e948bf2b8a8e..7d1b055811c4 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -33,12 +33,9 @@
 #include <linux/of_device.h>
 #include <linux/delay.h>
 #include <linux/crypto.h>
-#include <linux/cryptohash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
-#include <crypto/hash.h>
-#include <crypto/internal/hash.h>
 #include <linux/platform_data/crypto-atmel.h>
 #include <dt-bindings/dma/at91.h>
 #include "atmel-aes-regs.h"
-- 
1.8.2.2
