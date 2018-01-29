From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 1/3] crypto: caam/qi - return -EBADMSG for ICV check failure
Date: Mon, 29 Jan 2018 10:38:35 +0200
Message-ID: <20180129083837.21174-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0066.outbound.protection.outlook.com ([104.47.38.66]:29632
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751298AbeA2Ii7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jan 2018 03:38:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Crypto drivers are expected to return -EBADMSG in case of
ICV check (authentication) failure.

In this case it also makes sense to suppress the error message
in the QI dequeue callback.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 12 +++++++++++-
 drivers/crypto/caam/qi.c         | 11 +++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 4aecc9435f69..f4db39495d22 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -562,8 +562,18 @@ static void aead_done(struct caam_drv_req *drv_req, u32 status)
 	qidev = caam_ctx->qidev;
 
 	if (unlikely(status)) {
+		u32 ssrc = status & JRSTA_SSRC_MASK;
+		u8 err_id = status & JRSTA_CCBERR_ERRID_MASK;
+
 		caam_jr_strstatus(qidev, status);
-		ecode = -EIO;
+		/*
+		 * verify hw auth check passed else return -EBADMSG
+		 */
+		if (ssrc == JRSTA_SSRC_CCB_ERROR &&
+		    err_id == JRSTA_CCBERR_ERRID_ICVCHK)
+			ecode = -EBADMSG;
+		else
+			ecode = -EIO;
 	}
 
 	edesc = container_of(drv_req, typeof(*edesc), drv_req);
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index f9a44f485aac..b9480828da38 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -579,8 +579,15 @@ static enum qman_cb_dqrr_result caam_rsp_fq_dqrr_cb(struct qman_portal *p,
 
 	fd = &dqrr->fd;
 	status = be32_to_cpu(fd->status);
-	if (unlikely(status))
-		dev_err(qidev, "Error: %#x in CAAM response FD\n", status);
+	if (unlikely(status)) {
+		u32 ssrc = status & JRSTA_SSRC_MASK;
+		u8 err_id = status & JRSTA_CCBERR_ERRID_MASK;
+
+		if (ssrc != JRSTA_SSRC_CCB_ERROR ||
+		    err_id != JRSTA_CCBERR_ERRID_ICVCHK)
+			dev_err(qidev, "Error: %#x in CAAM response FD\n",
+				status);
+	}
 
 	if (unlikely(qm_fd_get_format(fd) != qm_fd_compound)) {
 		dev_err(qidev, "Non-compound FD from CAAM\n");
-- 
2.12.0.264.gd6db3f216544
