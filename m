From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: qat - remove an unneeded cast
Date: Tue, 8 Jul 2014 13:59:07 +0300
Message-ID: <20140708105907.GE19737@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Pingchaox Yang <pingchaox.yang@intel.com>,
	Bo Cui <bo.cui@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The cast to (unsigned int *) doesn't hurt anything but it is pointless.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 903ca88..28da876 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -850,7 +850,7 @@ static int qat_hal_exec_micro_inst(struct icp_qat_fw_loader_handle *handle,
 
 	if ((inst_num > handle->hal_handle->max_ustore) || !micro_inst) {
 		pr_err("QAT: invalid instructs inst_num=%d, micro_inst=0x%p\n ",
-		       inst_num, (unsigned int *)micro_inst);
+		       inst_num, micro_inst);
 		return -EINVAL;
 	}
 	/* save current context */
