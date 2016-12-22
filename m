From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v2 06/12] crypto: atmel-sha: add SHA_MR_MODE_IDATAR0
Date: Thu, 22 Dec 2016 17:37:55 +0100
Message-ID: <7f3f5092d8e2726ba66a4330b6221ad7072ee8ee.1482424395.git.cyrille.pitchen@atmel.com>
References: <cover.1482424395.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1482424395.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch defines an alias macro to SHA_MR_MODE_PDC, which is not suited
for DMA usage.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha-regs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/atmel-sha-regs.h b/drivers/crypto/atmel-sha-regs.h
index deb0b0b15096..8d62d31eda08 100644
--- a/drivers/crypto/atmel-sha-regs.h
+++ b/drivers/crypto/atmel-sha-regs.h
@@ -16,6 +16,7 @@
 #define SHA_MR_MODE_MANUAL		0x0
 #define SHA_MR_MODE_AUTO		0x1
 #define SHA_MR_MODE_PDC			0x2
+#define SHA_MR_MODE_IDATAR0		0x2
 #define SHA_MR_PROCDLY			(1 << 4)
 #define SHA_MR_UIHV			(1 << 5)
 #define SHA_MR_UIEHV			(1 << 6)
-- 
2.7.4
