From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 2/5] crypto: caampkc - avoid kzalloc(0) in caam_read_raw_data
Date: Tue, 25 Apr 2017 16:26:36 +0300
Message-ID: <20170425132639.20178-3-horia.geanta@nxp.com>
References: <20170425132639.20178-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0071.outbound.protection.outlook.com ([104.47.32.71]:12723
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1430995AbdDYN1Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 09:27:16 -0400
In-Reply-To: <20170425132639.20178-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

The function returns NULL if buf is composed only of zeros.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caampkc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 49cbdcba7883..999ba18495b0 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -374,6 +374,8 @@ static inline u8 *caam_read_raw_data(const u8 *buf, size_t *nbytes)
 		buf++;
 		(*nbytes)--;
 	}
+	if (!*nbytes)
+		return NULL;
 
 	val = kzalloc(*nbytes, GFP_DMA | GFP_KERNEL);
 	if (!val)
-- 
2.12.0.264.gd6db3f216544
