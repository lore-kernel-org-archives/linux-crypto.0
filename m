From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 1/7] soc/qman: export volatile dequeue related structs
Date: Fri, 17 Mar 2017 12:05:56 +0200
Message-ID: <20170317100602.2837-2-horia.geanta@nxp.com>
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
Received: from mail-bn3nam01on0043.outbound.protection.outlook.com ([104.47.33.43]:8384
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751017AbdCQKGf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 06:06:35 -0400
In-Reply-To: <20170317100602.2837-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since qman_volatile_dequeue() is already exported, move the related
structures into the public header too.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/soc/fsl/qbman/qman_priv.h | 36 ------------------------------------
 include/soc/fsl/qman.h            | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/soc/fsl/qbman/qman_priv.h b/drivers/soc/fsl/qbman/qman_priv.h
index 53685b59718e..64781eff6974 100644
--- a/drivers/soc/fsl/qbman/qman_priv.h
+++ b/drivers/soc/fsl/qbman/qman_priv.h
@@ -271,42 +271,6 @@ const struct qm_portal_config *qman_destroy_affine_portal(void);
  */
 int qman_query_fq(struct qman_fq *fq, struct qm_fqd *fqd);
 
-/*
- * For qman_volatile_dequeue(); Choose one PRECEDENCE. EXACT is optional. Use
- * NUMFRAMES(n) (6-bit) or NUMFRAMES_TILLEMPTY to fill in the frame-count. Use
- * FQID(n) to fill in the frame queue ID.
- */
-#define QM_VDQCR_PRECEDENCE_VDQCR	0x0
-#define QM_VDQCR_PRECEDENCE_SDQCR	0x80000000
-#define QM_VDQCR_EXACT			0x40000000
-#define QM_VDQCR_NUMFRAMES_MASK		0x3f000000
-#define QM_VDQCR_NUMFRAMES_SET(n)	(((n) & 0x3f) << 24)
-#define QM_VDQCR_NUMFRAMES_GET(n)	(((n) >> 24) & 0x3f)
-#define QM_VDQCR_NUMFRAMES_TILLEMPTY	QM_VDQCR_NUMFRAMES_SET(0)
-
-#define QMAN_VOLATILE_FLAG_WAIT	     0x00000001 /* wait if VDQCR is in use */
-#define QMAN_VOLATILE_FLAG_WAIT_INT  0x00000002 /* if wait, interruptible? */
-#define QMAN_VOLATILE_FLAG_FINISH    0x00000004 /* wait till VDQCR completes */
-
-/*
- * qman_volatile_dequeue - Issue a volatile dequeue command
- * @fq: the frame queue object to dequeue from
- * @flags: a bit-mask of QMAN_VOLATILE_FLAG_*** options
- * @vdqcr: bit mask of QM_VDQCR_*** options, as per qm_dqrr_vdqcr_set()
- *
- * Attempts to lock access to the portal's VDQCR volatile dequeue functionality.
- * The function will block and sleep if QMAN_VOLATILE_FLAG_WAIT is specified and
- * the VDQCR is already in use, otherwise returns non-zero for failure. If
- * QMAN_VOLATILE_FLAG_FINISH is specified, the function will only return once
- * the VDQCR command has finished executing (ie. once the callback for the last
- * DQRR entry resulting from the VDQCR command has been called). If not using
- * the FINISH flag, completion can be determined either by detecting the
- * presence of the QM_DQRR_STAT_UNSCHEDULED and QM_DQRR_STAT_DQCR_EXPIRED bits
- * in the "stat" parameter passed to the FQ's dequeue callback, or by waiting
- * for the QMAN_FQ_STATE_VDQCR bit to disappear.
- */
-int qman_volatile_dequeue(struct qman_fq *fq, u32 flags, u32 vdqcr);
-
 int qman_alloc_fq_table(u32 num_fqids);
 
 /*   QMan s/w corenet portal, low-level i/face	 */
diff --git a/include/soc/fsl/qman.h b/include/soc/fsl/qman.h
index 3d4df74a96de..4de1ffcc8982 100644
--- a/include/soc/fsl/qman.h
+++ b/include/soc/fsl/qman.h
@@ -791,6 +791,23 @@ struct qman_cgr {
 #define QMAN_INITFQ_FLAG_SCHED	     0x00000001 /* schedule rather than park */
 #define QMAN_INITFQ_FLAG_LOCAL	     0x00000004 /* set dest portal */
 
+/*
+ * For qman_volatile_dequeue(); Choose one PRECEDENCE. EXACT is optional. Use
+ * NUMFRAMES(n) (6-bit) or NUMFRAMES_TILLEMPTY to fill in the frame-count. Use
+ * FQID(n) to fill in the frame queue ID.
+ */
+#define QM_VDQCR_PRECEDENCE_VDQCR	0x0
+#define QM_VDQCR_PRECEDENCE_SDQCR	0x80000000
+#define QM_VDQCR_EXACT			0x40000000
+#define QM_VDQCR_NUMFRAMES_MASK		0x3f000000
+#define QM_VDQCR_NUMFRAMES_SET(n)	(((n) & 0x3f) << 24)
+#define QM_VDQCR_NUMFRAMES_GET(n)	(((n) >> 24) & 0x3f)
+#define QM_VDQCR_NUMFRAMES_TILLEMPTY	QM_VDQCR_NUMFRAMES_SET(0)
+
+#define QMAN_VOLATILE_FLAG_WAIT	     0x00000001 /* wait if VDQCR is in use */
+#define QMAN_VOLATILE_FLAG_WAIT_INT  0x00000002 /* if wait, interruptible? */
+#define QMAN_VOLATILE_FLAG_FINISH    0x00000004 /* wait till VDQCR completes */
+
 	/* Portal Management */
 /**
  * qman_p_irqsource_add - add processing sources to be interrupt-driven
@@ -963,6 +980,25 @@ int qman_retire_fq(struct qman_fq *fq, u32 *flags);
  */
 int qman_oos_fq(struct qman_fq *fq);
 
+/*
+ * qman_volatile_dequeue - Issue a volatile dequeue command
+ * @fq: the frame queue object to dequeue from
+ * @flags: a bit-mask of QMAN_VOLATILE_FLAG_*** options
+ * @vdqcr: bit mask of QM_VDQCR_*** options, as per qm_dqrr_vdqcr_set()
+ *
+ * Attempts to lock access to the portal's VDQCR volatile dequeue functionality.
+ * The function will block and sleep if QMAN_VOLATILE_FLAG_WAIT is specified and
+ * the VDQCR is already in use, otherwise returns non-zero for failure. If
+ * QMAN_VOLATILE_FLAG_FINISH is specified, the function will only return once
+ * the VDQCR command has finished executing (ie. once the callback for the last
+ * DQRR entry resulting from the VDQCR command has been called). If not using
+ * the FINISH flag, completion can be determined either by detecting the
+ * presence of the QM_DQRR_STAT_UNSCHEDULED and QM_DQRR_STAT_DQCR_EXPIRED bits
+ * in the "stat" parameter passed to the FQ's dequeue callback, or by waiting
+ * for the QMAN_FQ_STATE_VDQCR bit to disappear.
+ */
+int qman_volatile_dequeue(struct qman_fq *fq, u32 flags, u32 vdqcr);
+
 /**
  * qman_enqueue - Enqueue a frame to a frame queue
  * @fq: the frame queue object to enqueue to
-- 
2.12.0.264.gd6db3f216544
