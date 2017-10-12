From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] crypto: qat: qat_common: qat_uclo - mark expected switch
 fall-throughs
Date: Thu, 12 Oct 2017 17:55:29 -0500
Message-ID: <20171012225529.GA25176@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index e2454d9..61ae091 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -791,6 +791,7 @@ static int qat_uclo_init_reg(struct icp_qat_fw_loader_handle *handle,
 	case ICP_GPA_ABS:
 	case ICP_GPB_ABS:
 		ctx_mask = 0;
+		/* fall through */
 	case ICP_GPA_REL:
 	case ICP_GPB_REL:
 		return qat_hal_init_gpr(handle, ae, ctx_mask, reg_type,
@@ -800,6 +801,7 @@ static int qat_uclo_init_reg(struct icp_qat_fw_loader_handle *handle,
 	case ICP_SR_RD_ABS:
 	case ICP_DR_RD_ABS:
 		ctx_mask = 0;
+		/* fall through */
 	case ICP_SR_REL:
 	case ICP_DR_REL:
 	case ICP_SR_RD_REL:
@@ -809,6 +811,7 @@ static int qat_uclo_init_reg(struct icp_qat_fw_loader_handle *handle,
 	case ICP_SR_WR_ABS:
 	case ICP_DR_WR_ABS:
 		ctx_mask = 0;
+		/* fall through */
 	case ICP_SR_WR_REL:
 	case ICP_DR_WR_REL:
 		return qat_hal_init_wr_xfer(handle, ae, ctx_mask, reg_type,
-- 
2.7.4
