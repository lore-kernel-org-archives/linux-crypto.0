From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 4/7] soc/qman: add macros needed by caam/qi driver
Date: Fri, 17 Mar 2017 12:05:59 +0200
Message-ID: <20170317100602.2837-5-horia.geanta@nxp.com>
References: <20170317100602.2837-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Wood <oss@buserror.net>, Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0041.outbound.protection.outlook.com ([104.47.33.41]:62275
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751101AbdCQKGm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 06:06:42 -0400
In-Reply-To: <20170317100602.2837-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A few other things need to be added in soc/qman, such that
caam/qi won't open-code them.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 include/soc/fsl/qman.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/soc/fsl/qman.h b/include/soc/fsl/qman.h
index 0252c32f7421..d4dfefdee6c1 100644
--- a/include/soc/fsl/qman.h
+++ b/include/soc/fsl/qman.h
@@ -168,6 +168,7 @@ static inline void qm_fd_set_param(struct qm_fd *fd, enum qm_fd_format fmt,
 #define qm_fd_set_contig_big(fd, len) \
 	qm_fd_set_param(fd, qm_fd_contig_big, 0, len)
 #define qm_fd_set_sg_big(fd, len) qm_fd_set_param(fd, qm_fd_sg_big, 0, len)
+#define qm_fd_set_compound(fd, len) qm_fd_set_param(fd, qm_fd_compound, 0, len)
 
 static inline void qm_fd_clear_fd(struct qm_fd *fd)
 {
@@ -642,6 +643,7 @@ struct qm_mcc_initcgr {
 #define QM_CGR_WE_MODE			0x0001
 
 #define QMAN_CGR_FLAG_USE_INIT	     0x00000001
+#define QMAN_CGR_MODE_FRAME          0x00000001
 
 	/* Portal and Frame Queues */
 /* Represents a managed portal */
-- 
2.12.0.264.gd6db3f216544
