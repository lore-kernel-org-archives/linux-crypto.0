From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 05/10] crypto: qat: Cleanup - use min_t macro
Date: Fri, 25 Jul 2014 15:55:32 -0700
Message-ID: <20140725225532.24909.81716.stgit@gitlad.jf.intel.com>
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
Received: from mga11.intel.com ([192.55.52.93]:51393 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaGYWzh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Jul 2014 18:55:37 -0400
In-Reply-To: <20140725225410.24909.56360.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

prefer min_t() macro over two open-coded logical tests

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 drivers/crypto/qat/qat_common/qat_uclo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 17a9954f..b1a16eb 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -901,8 +901,8 @@ static int qat_uclo_set_ae_mode(struct icp_qat_fw_loader_handle *handle)
 			      (unsigned long *)&handle->hal_handle->ae_mask))
 			continue;
 		ae_data = &obj_handle->ae_data[ae];
-		for (s = 0; s < ae_data->slice_num && s < ICP_QAT_UCLO_MAX_CTX;
-		     s++) {
+		for (s = 0; s < min_t(unsigned int, ae_data->slice_num,
+				      ICP_QAT_UCLO_MAX_CTX); s++) {
 			if (!obj_handle->ae_data[ae].ae_slices[s].encap_image)
 				continue;
 			uof_image = ae_data->ae_slices[s].encap_image->img_ptr;
