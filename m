From: "zhaoxiu.zeng" <zhaoxiu.zeng@gmail.com>
Subject: [PATCH 23/31] crypto: qat: use parity functions in qat_hal.c
Date: Sun, 27 Mar 2016 15:30:47 +0800
Message-ID: <56F78C27.6010307@gmail.com>
References: <1458788612-4367-1-git-send-email-zhaoxiu.zeng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, qat-linux@intel.com,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Pingchao Yang <pingchao.yang@intel.com>,
	Bruce Allan <bruce.w.allan@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35750 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbcC0HbY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 Mar 2016 03:31:24 -0400
In-Reply-To: <1458788612-4367-1-git-send-email-zhaoxiu.zeng@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>

Signed-off-by: Zeng Zhaoxiu <zhaoxiu.zeng@gmail.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 1e480f1..318558f 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -546,17 +546,6 @@ static void qat_hal_disable_ctx(struct icp_qat_fw_loader_handle *handle,
 	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, ctx);
 }
 
-static uint64_t qat_hal_parity_64bit(uint64_t word)
-{
-	word ^= word >> 1;
-	word ^= word >> 2;
-	word ^= word >> 4;
-	word ^= word >> 8;
-	word ^= word >> 16;
-	word ^= word >> 32;
-	return word & 1;
-}
-
 static uint64_t qat_hal_set_uword_ecc(uint64_t uword)
 {
 	uint64_t bit0_mask = 0xff800007fffULL, bit1_mask = 0x1f801ff801fULL,
@@ -566,13 +555,13 @@ static uint64_t qat_hal_set_uword_ecc(uint64_t uword)
 
 	/* clear the ecc bits */
 	uword &= ~(0x7fULL << 0x2C);
-	uword |= qat_hal_parity_64bit(bit0_mask & uword) << 0x2C;
-	uword |= qat_hal_parity_64bit(bit1_mask & uword) << 0x2D;
-	uword |= qat_hal_parity_64bit(bit2_mask & uword) << 0x2E;
-	uword |= qat_hal_parity_64bit(bit3_mask & uword) << 0x2F;
-	uword |= qat_hal_parity_64bit(bit4_mask & uword) << 0x30;
-	uword |= qat_hal_parity_64bit(bit5_mask & uword) << 0x31;
-	uword |= qat_hal_parity_64bit(bit6_mask & uword) << 0x32;
+	uword |= (uint64_t)parity64(bit0_mask & uword) << 0x2C;
+	uword |= (uint64_t)parity64(bit1_mask & uword) << 0x2D;
+	uword |= (uint64_t)parity64(bit2_mask & uword) << 0x2E;
+	uword |= (uint64_t)parity64(bit3_mask & uword) << 0x2F;
+	uword |= (uint64_t)parity64(bit4_mask & uword) << 0x30;
+	uword |= (uint64_t)parity64(bit5_mask & uword) << 0x31;
+	uword |= (uint64_t)parity64(bit6_mask & uword) << 0x32;
 	return uword;
 }
 
@@ -853,15 +842,14 @@ void qat_hal_wr_umem(struct icp_qat_fw_loader_handle *handle,
 	uaddr |= UA_ECS;
 	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, uaddr);
 	for (i = 0; i < words_num; i++) {
-		unsigned int uwrd_lo, uwrd_hi, tmp;
+		unsigned int uwrd_lo, uwrd_hi;
 
 		uwrd_lo = ((data[i] & 0xfff0000) << 4) | (0x3 << 18) |
 			  ((data[i] & 0xff00) << 2) |
 			  (0x3 << 8) | (data[i] & 0xff);
 		uwrd_hi = (0xf << 4) | ((data[i] & 0xf0000000) >> 28);
-		uwrd_hi |= (hweight32(data[i] & 0xffff) & 0x1) << 8;
-		tmp = ((data[i] >> 0x10) & 0xffff);
-		uwrd_hi |= (hweight32(tmp) & 0x1) << 9;
+		uwrd_hi |= parity16(data[i]) << 8;
+		uwrd_hi |= parity16(data[i] >> 16) << 9;
 		qat_hal_wr_ae_csr(handle, ae, USTORE_DATA_LOWER, uwrd_lo);
 		qat_hal_wr_ae_csr(handle, ae, USTORE_DATA_UPPER, uwrd_hi);
 	}
-- 
2.5.5
