From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v3 05/12] crypto: atmel-sha: add atmel_sha_wait_for_data_ready()
Date: Thu, 26 Jan 2017 17:07:50 +0100
Message-ID: <6dfd52ed532de56f5bcc3857b8bd96029360089e.1485443478.git.cyrille.pitchen@atmel.com>
References: <cover.1485443478.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <smueller@chronox.de>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:35469 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752702AbdAZQNF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 11:13:05 -0500
In-Reply-To: <cover.1485443478.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch simply defines a helper function to test the 'Data Ready' flag
of the Status Register. It also gives a chance for the crypto request to
be processed synchronously if this 'Data Ready' flag is already set when
polling the Status Register. Indeed, running synchronously avoid the
latency of the 'Data Ready' interrupt.

When the 'Data Ready' flag has not been set yet, we enable the associated
interrupt and resume processing the crypto request asynchronously from the
'done' task just as before.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index b29a4e5bc404..be0d72cf4352 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -434,6 +434,19 @@ static void atmel_sha_write_ctrl(struct atmel_sha_dev *dd, int dma)
 	atmel_sha_write(dd, SHA_MR, valmr);
 }
 
+static inline int atmel_sha_wait_for_data_ready(struct atmel_sha_dev *dd,
+						atmel_sha_fn_t resume)
+{
+	u32 isr = atmel_sha_read(dd, SHA_ISR);
+
+	if (unlikely(isr & SHA_INT_DATARDY))
+		return resume(dd);
+
+	dd->resume = resume;
+	atmel_sha_write(dd, SHA_IER, SHA_INT_DATARDY);
+	return -EINPROGRESS;
+}
+
 static int atmel_sha_xmit_cpu(struct atmel_sha_dev *dd, const u8 *buf,
 			      size_t length, int final)
 {
-- 
2.7.4
