From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 04/24] crypto: atmel-aes: fix unregistration order of crypto algorithms
Date: Thu, 17 Dec 2015 17:48:35 +0100
Message-ID: <afc8327fae3aef588513b3432611df144418091c.1450366831.git.cyrille.pitchen@atmel.com>
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

This dummy patch fixes atmel_aes_unregister_algs() so crypto algorithms
are unregistered in the reverse order they were registered by
atmel_aes_register_algs().

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-aes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index e545636a7ddc..e948bf2b8a8e 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1219,10 +1219,11 @@ static void atmel_aes_unregister_algs(struct atmel_aes_dev *dd)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(aes_algs); i++)
-		crypto_unregister_alg(&aes_algs[i]);
 	if (dd->caps.has_cfb64)
 		crypto_unregister_alg(&aes_cfb64_alg);
+
+	for (i = 0; i < ARRAY_SIZE(aes_algs); i++)
+		crypto_unregister_alg(&aes_algs[i]);
 }
 
 static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
-- 
1.8.2.2
