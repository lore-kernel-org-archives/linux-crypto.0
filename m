From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 09/10] crypto: qat: Cleanup - Use hweight for bit counting
Date: Fri, 25 Jul 2014 15:55:57 -0700
Message-ID: <20140725225557.24909.556.stgit@gitlad.jf.intel.com>
References: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <tadeusz.struk@intel.com>, <davem@davemloft.net>,
	<bruce.w.allan@intel.com>, <bo.cui@intel.com>,
	<pingchao.yang@intel.com>, <qat-linux@intel.com>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaGYWz7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jul 2014 18:55:59 -0400
In-Reply-To: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use predefined hweight32 function instead of writing a new one.

Signed-off-by: Pingchao Yang <pingchao.yang@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 drivers/crypto/qat/qat_common/qat_hal.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 8d686a2..9b8a315 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -795,17 +795,6 @@ static void qat_hal_get_uwords(struct icp_qat_fw_loader_handle *handle,
 	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, ustore_addr);
 }
 
-static int qat_hal_count_bits(unsigned int word)
-{
-	int n = 0;
-
-	while (word) {
-		n++;
-		word &= word - 1;
-	}
-	return n;
-}
-
 void qat_hal_wr_umem(struct icp_qat_fw_loader_handle *handle,
 		     unsigned char ae, unsigned int uaddr,
 		     unsigned int words_num, unsigned int *data)
@@ -822,9 +811,9 @@ void qat_hal_wr_umem(struct icp_qat_fw_loader_handle *handle,
 			  ((data[i] & 0xff00) << 2) |
 			  (0x3 << 8) | (data[i] & 0xff);
 		uwrd_hi = (0xf << 4) | ((data[i] & 0xf0000000) >> 28);
-		uwrd_hi |= (qat_hal_count_bits(data[i] & 0xffff) & 0x1) << 8;
+		uwrd_hi |= (hweight32(data[i] & 0xffff) & 0x1) << 8;
 		tmp = ((data[i] >> 0x10) & 0xffff);
-		uwrd_hi |= (qat_hal_count_bits(tmp) & 0x1) << 9;
+		uwrd_hi |= (hweight32(tmp) & 0x1) << 9;
 		qat_hal_wr_ae_csr(handle, ae, USTORE_DATA_LOWER, uwrd_lo);
 		qat_hal_wr_ae_csr(handle, ae, USTORE_DATA_UPPER, uwrd_hi);
 	}
