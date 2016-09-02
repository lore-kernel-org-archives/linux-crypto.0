From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH 2/2] crypto: qat - fix resource release omissions
Date: Fri,  2 Sep 2016 16:37:59 +0200
Message-ID: <20160902143759.31125-3-lambert.quentin@gmail.com>
References: <20160902143759.31125-1-lambert.quentin@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Quentin Lambert <lambert.quentin@gmail.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34935 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754123AbcIBOif (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2016 10:38:35 -0400
In-Reply-To: <20160902143759.31125-1-lambert.quentin@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This issue was found with Hector.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -981,7 +981,8 @@ static int qat_uclo_parse_uof_obj(struct
 			(PID_MINOR_REV & handle->hal_handle->revision_id);
 	if (qat_uclo_check_uof_compat(obj_handle)) {
 		pr_err("QAT: UOF incompatible\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_err;
 	}
 	obj_handle->ustore_phy_size = ICP_QAT_UCLO_MAX_USTORE;
 	if (!obj_handle->obj_hdr->file_buff ||
