From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 01/24] crypto: atmel-aes: add new version
Date: Thu, 17 Dec 2015 17:48:32 +0100
Message-ID: <539384e229f7aa1b0ccd6064d0480f40024d1443.1450366831.git.cyrille.pitchen@atmel.com>
References: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Leilei Zhao <leilei.zhao@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450366831.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Leilei Zhao <leilei.zhao@atmel.com>

Add new version of atmel-aes available with SAMA5D2 devices.

Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
---
 drivers/crypto/atmel-aes.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index bfb1f799bf56..854e2813b2bb 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1258,6 +1258,11 @@ static void atmel_aes_get_cap(struct atmel_aes_dev *dd)
 
 	/* keep only major version number */
 	switch (dd->hw_version & 0xff0) {
+	case 0x500:
+		dd->caps.has_dualbuff = 1;
+		dd->caps.has_cfb64 = 1;
+		dd->caps.max_burst_size = 4;
+		break;
 	case 0x200:
 		dd->caps.has_dualbuff = 1;
 		dd->caps.has_cfb64 = 1;
-- 
1.8.2.2
