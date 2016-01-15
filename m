From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 3/5] crypto: atmel-sha: add support of sama5d2x SoCs
Date: Fri, 15 Jan 2016 15:49:33 +0100
Message-ID: <18134513303134ae7e22b4840e7000a74af8f9f9.1452867917.git.cyrille.pitchen@atmel.com>
References: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds support of hardware version 5.1.x embedded inside sama5d2x
SoCs.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 75a8cbcf3121..7327e11e0ccb 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1279,6 +1279,12 @@ static void atmel_sha_get_cap(struct atmel_sha_dev *dd)
 
 	/* keep only major version number */
 	switch (dd->hw_version & 0xff0) {
+	case 0x510:
+		dd->caps.has_dma = 1;
+		dd->caps.has_dualbuff = 1;
+		dd->caps.has_sha224 = 1;
+		dd->caps.has_sha_384_512 = 1;
+		break;
 	case 0x420:
 		dd->caps.has_dma = 1;
 		dd->caps.has_dualbuff = 1;
-- 
1.8.2.2
