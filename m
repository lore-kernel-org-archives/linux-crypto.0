From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - don't use userspace pointer
Date: Wed, 21 Oct 2015 12:30:45 -0700
Message-ID: <20151021193044.30343.6431.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39120 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbbJUTdN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 Oct 2015 15:33:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Bugfix - don't dereference userspace pointer.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index ebc1c63..fcb790e 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -198,7 +198,7 @@ static int adf_copy_key_value_data(struct adf_accel_dev *accel_dev,
 			goto out_err;
 		}
 
-		params_head = section_head->params;
+		params_head = section.params;
 
 		while (params_head) {
 			if (copy_from_user(&key_val, (void __user *)params_head,
