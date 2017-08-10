From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [RFC PATCH 02/10] staging: fsl-mc: dpio: add congestion notification support
Date: Thu, 10 Aug 2017 20:42:45 +0300
Message-ID: <20170810174253.20951-3-horia.geanta@nxp.com>
References: <20170810174253.20951-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S . Miller" <davem@davemloft.net>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devel@driverdev.osuosl.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0046.outbound.protection.outlook.com ([104.47.32.46]:23979
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753126AbdHJRng (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 13:43:36 -0400
In-Reply-To: <20170810174253.20951-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for Congestion State Change Notifications (CSCN), which
allow DPIO users to be notified when a congestion group changes its
state (due to hitting the entrance / exit threshold).

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Radu Alexe <radu.alexe@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/staging/fsl-mc/include/dpaa2-io.h | 43 +++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/staging/fsl-mc/include/dpaa2-io.h b/drivers/staging/fsl-mc/include/dpaa2-io.h
index 002829cecd75..e7af7d647ab1 100644
--- a/drivers/staging/fsl-mc/include/dpaa2-io.h
+++ b/drivers/staging/fsl-mc/include/dpaa2-io.h
@@ -136,4 +136,47 @@ struct dpaa2_io_store *dpaa2_io_store_create(unsigned int max_frames,
 void dpaa2_io_store_destroy(struct dpaa2_io_store *s);
 struct dpaa2_dq *dpaa2_io_store_next(struct dpaa2_io_store *s, int *is_last);
 
+/***************/
+/* CSCN        */
+/***************/
+
+/**
+ * struct dpaa2_cscn - The CSCN message format
+ * @verb: identifies the type of message (should be 0x27).
+ * @stat: status bits related to dequeuing response (not used)
+ * @state: bit 0 = 0/1 if CG is no/is congested
+ * @reserved: reserved byte
+ * @cgid: congest grp ID - the first 16 bits
+ * @ctx: context data
+ *
+ * Congestion management can be implemented in software through
+ * the use of Congestion State Change Notifications (CSCN). These
+ * are messages written by DPAA2 hardware to memory whenever the
+ * instantaneous count (I_CNT field in the CG) exceeds the
+ * Congestion State (CS) entrance threshold, signifying congestion
+ * entrance, or when the instantaneous count returns below exit
+ * threshold, signifying congestion exit. The format of the message
+ * is given by the dpaa2_cscn structure. Bit 0 of the state field
+ * represents congestion state written by the hardware.
+ */
+struct dpaa2_cscn {
+	u8 verb;
+	u8 stat;
+	u8 state;
+	u8 reserved;
+	__le32 cgid;
+	__le64 ctx;
+};
+
+#define DPAA2_CSCN_SIZE                        64
+#define DPAA2_CSCN_ALIGN               16
+
+#define DPAA2_CSCN_STATE_MASK          0x1
+#define DPAA2_CSCN_CONGESTED           1
+
+static inline bool dpaa2_cscn_state_congested(struct dpaa2_cscn *cscn)
+{
+	return ((cscn->state & DPAA2_CSCN_STATE_MASK) == DPAA2_CSCN_CONGESTED);
+}
+
 #endif /* __FSL_DPAA2_IO_H */
-- 
2.12.0.264.gd6db3f216544
