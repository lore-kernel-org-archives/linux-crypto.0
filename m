From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 02/11] Revert "staging: fsl-mc/dpio: remove couple of unused functions"
Date: Mon, 10 Sep 2018 20:15:41 +0300
Message-ID: <20180910171550.5659-3-horia.geanta@nxp.com>
References: <20180910171550.5659-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: "David S . Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Roy Pledge <roy.pledge@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180910171550.5659-1-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This reverts commit a211c8170b3c348353decb6e175c58a7814f218c.
(+ updated to account for driver being moved out of staging)

dpseci object will make use of these functions, thus it's time to add
them back.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/soc/fsl/dpio/dpio-service.c | 58 +++++++++++++++++++++++++++++++++++++
 include/soc/fsl/dpaa2-io.h          |  4 +++
 2 files changed, 62 insertions(+)

diff --git a/drivers/soc/fsl/dpio/dpio-service.c b/drivers/soc/fsl/dpio/dpio-service.c
index 9b17f72349ed..321a92613a7e 100644
--- a/drivers/soc/fsl/dpio/dpio-service.c
+++ b/drivers/soc/fsl/dpio/dpio-service.c
@@ -309,6 +309,37 @@ int dpaa2_io_service_rearm(struct dpaa2_io *d,
 }
 EXPORT_SYMBOL_GPL(dpaa2_io_service_rearm);
 
+/**
+ * dpaa2_io_service_pull_fq() - pull dequeue functions from a fq.
+ * @d: the given DPIO service.
+ * @fqid: the given frame queue id.
+ * @s: the dpaa2_io_store object for the result.
+ *
+ * Return 0 for success, or error code for failure.
+ */
+int dpaa2_io_service_pull_fq(struct dpaa2_io *d, u32 fqid,
+			     struct dpaa2_io_store *s)
+{
+	struct qbman_pull_desc pd;
+	int err;
+
+	qbman_pull_desc_clear(&pd);
+	qbman_pull_desc_set_storage(&pd, s->vaddr, s->paddr, 1);
+	qbman_pull_desc_set_numframes(&pd, (u8)s->max);
+	qbman_pull_desc_set_fq(&pd, fqid);
+
+	d = service_select(d);
+	if (!d)
+		return -ENODEV;
+	s->swp = d->swp;
+	err = qbman_swp_pull(d->swp, &pd);
+	if (err)
+		s->swp = NULL;
+
+	return err;
+}
+EXPORT_SYMBOL(dpaa2_io_service_pull_fq);
+
 /**
  * dpaa2_io_service_pull_channel() - pull dequeue functions from a channel.
  * @d: the given DPIO service.
@@ -341,6 +372,33 @@ int dpaa2_io_service_pull_channel(struct dpaa2_io *d, u32 channelid,
 }
 EXPORT_SYMBOL_GPL(dpaa2_io_service_pull_channel);
 
+/**
+ * dpaa2_io_service_enqueue_fq() - Enqueue a frame to a frame queue.
+ * @d: the given DPIO service.
+ * @fqid: the given frame queue id.
+ * @fd: the frame descriptor which is enqueued.
+ *
+ * Return 0 for successful enqueue, -EBUSY if the enqueue ring is not ready,
+ * or -ENODEV if there is no dpio service.
+ */
+int dpaa2_io_service_enqueue_fq(struct dpaa2_io *d,
+				u32 fqid,
+				const struct dpaa2_fd *fd)
+{
+	struct qbman_eq_desc ed;
+
+	d = service_select(d);
+	if (!d)
+		return -ENODEV;
+
+	qbman_eq_desc_clear(&ed);
+	qbman_eq_desc_set_no_orp(&ed, 0);
+	qbman_eq_desc_set_fq(&ed, fqid);
+
+	return qbman_swp_enqueue(d->swp, &ed, fd);
+}
+EXPORT_SYMBOL(dpaa2_io_service_enqueue_fq);
+
 /**
  * dpaa2_io_service_enqueue_qd() - Enqueue a frame to a QD.
  * @d: the given DPIO service.
diff --git a/include/soc/fsl/dpaa2-io.h b/include/soc/fsl/dpaa2-io.h
index ab51e40d11db..70997ab2146c 100644
--- a/include/soc/fsl/dpaa2-io.h
+++ b/include/soc/fsl/dpaa2-io.h
@@ -97,9 +97,13 @@ void dpaa2_io_service_deregister(struct dpaa2_io *service,
 int dpaa2_io_service_rearm(struct dpaa2_io *service,
 			   struct dpaa2_io_notification_ctx *ctx);
 
+int dpaa2_io_service_pull_fq(struct dpaa2_io *d, u32 fqid,
+			     struct dpaa2_io_store *s);
 int dpaa2_io_service_pull_channel(struct dpaa2_io *d, u32 channelid,
 				  struct dpaa2_io_store *s);
 
+int dpaa2_io_service_enqueue_fq(struct dpaa2_io *d, u32 fqid,
+				const struct dpaa2_fd *fd);
 int dpaa2_io_service_enqueue_qd(struct dpaa2_io *d, u32 qdid, u8 prio,
 				u16 qdbin, const struct dpaa2_fd *fd);
 int dpaa2_io_service_release(struct dpaa2_io *d, u32 bpid,
-- 
2.16.2
