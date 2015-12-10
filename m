From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch -next] crypto: qat - uint8_t is not large enough for accel_id
Date: Fri, 11 Dec 2015 01:00:44 +0300
Message-ID: <20151210220044.GA21797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Pingchao Yang <pingchao.yang@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23738 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbbLJWBC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Dec 2015 17:01:02 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

->accel_id has to be large enough to hold ADF_MAX_DEVICES + 1 (which is
1025) so uint8_t is too small.

Fixes: 890c55f4dc0e ('crypto: qat - add support for c3xxx accel type')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 4d78ec0..1e1cdef 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -251,6 +251,6 @@ struct adf_accel_dev {
 		} vf;
 	};
 	bool is_vf;
-	uint8_t accel_id;
+	unsigned int accel_id;
 } __packed;
 #endif
