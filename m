From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/4] crypto: qat: Fix random config build warnings
Date: Tue, 24 Jun 2014 15:19:24 -0700
Message-ID: <20140624221924.3872.42454.stgit@tstruk-mobl1.intel.com>
References: <20140624221833.3872.65930.stgit@tstruk-mobl1.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, bruce.w.allan@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50593 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaFXWWs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Jun 2014 18:22:48 -0400
In-Reply-To: <20140624221833.3872.65930.stgit@tstruk-mobl1.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46ix random config build warnings:

Implicit-function-declaration =E2=80=98__raw_writel=E2=80=99
Cast to pointer from integer of different size [-Wint-to-pointer-cast]

Reviewed-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |    1 +
 drivers/crypto/qat/qat_common/qat_algs.c          |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/driver=
s/crypto/qat/qat_common/adf_accel_devices.h
index f3206d9..9282381 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -50,6 +50,7 @@
 #include <linux/atomic.h>
 #include <linux/list.h>
 #include <linux/proc_fs.h>
+#include <linux/io.h>
 #include "adf_cfg_common.h"
=20
 #define PCI_VENDOR_ID_INTEL 0x8086
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/=
qat/qat_common/qat_algs.c
index 193b753..c4e8010 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -745,7 +745,7 @@ void qat_alg_callback(void *resp)
 {
 	struct icp_qat_fw_la_resp *qat_resp =3D resp;
 	struct qat_crypto_request *qat_req =3D
-			(void *)(dma_addr_t)qat_resp->opaque_data;
+				(void *)(__force long)qat_resp->opaque_data;
 	struct qat_alg_session_ctx *ctx =3D qat_req->ctx;
 	struct qat_crypto_instance *inst =3D ctx->inst;
 	struct aead_request *areq =3D qat_req->areq;
@@ -779,7 +779,7 @@ static int qat_alg_dec(struct aead_request *areq)
 	*msg =3D ctx->dec_fw_req_tmpl;
 	qat_req->ctx =3D ctx;
 	qat_req->areq =3D areq;
-	qat_req->req.comn_mid.opaque_data =3D (uint64_t)(dma_addr_t)qat_req;
+	qat_req->req.comn_mid.opaque_data =3D (uint64_t)(__force long)qat_req=
;
 	qat_req->req.comn_mid.src_data_addr =3D qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr =3D qat_req->buf.bloutp;
 	cipher_param =3D (void *)&qat_req->req.serv_specif_rqpars;
@@ -822,7 +822,7 @@ static int qat_alg_enc_internal(struct aead_request=
 *areq, uint8_t *iv,
 	*msg =3D ctx->enc_fw_req_tmpl;
 	qat_req->ctx =3D ctx;
 	qat_req->areq =3D areq;
-	qat_req->req.comn_mid.opaque_data =3D (uint64_t)(dma_addr_t)qat_req;
+	qat_req->req.comn_mid.opaque_data =3D (uint64_t)(__force long)qat_req=
;
 	qat_req->req.comn_mid.src_data_addr =3D qat_req->buf.blp;
 	qat_req->req.comn_mid.dest_data_addr =3D qat_req->buf.bloutp;
 	cipher_param =3D (void *)&qat_req->req.serv_specif_rqpars;
