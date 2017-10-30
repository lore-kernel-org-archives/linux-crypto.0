From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta-3arQi8VN3Tc@public.gmane.org>
Subject: [PATCH RESEND 3/4] crypto: caam: add functionality used by the caam_dma driver
Date: Mon, 30 Oct 2017 15:46:53 +0200
Message-ID: <20171030134654.13729-4-horia.geanta@nxp.com>
References: <20171030134654.13729-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Dan Douglass <dan.douglass-3arQi8VN3Tc@public.gmane.org>,
        Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Radu Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171030134654.13729-1-horia.geanta-3arQi8VN3Tc@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Radu Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org>

The caam_dma is a memcpy DMA driver based on the DMA functionality of
the CAAM hardware block. It creates a DMA channel for each JR of the
CAAM. This patch adds functionality that is used by the caam_dma that is
not yet part of the JR driver.

Signed-off-by: Radu Alexe <radu.alexe-3arQi8VN3Tc@public.gmane.org>
---
 drivers/crypto/caam/desc.h |  3 +++
 drivers/crypto/caam/jr.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/jr.h   |  2 ++
 3 files changed, 47 insertions(+)

diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 2e6766a1573f..f03221d2468a 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -354,6 +354,7 @@
 #define FIFOLD_TYPE_PK_N	(0x08 << FIFOLD_TYPE_SHIFT)
 #define FIFOLD_TYPE_PK_A	(0x0c << FIFOLD_TYPE_SHIFT)
 #define FIFOLD_TYPE_PK_B	(0x0d << FIFOLD_TYPE_SHIFT)
+#define FIFOLD_TYPE_IFIFO	(0x0f << FIFOLD_TYPE_SHIFT)
 
 /* Other types. Need to OR in last/flush bits as desired */
 #define FIFOLD_TYPE_MSG_MASK	(0x38 << FIFOLD_TYPE_SHIFT)
@@ -407,6 +408,7 @@
 #define FIFOST_TYPE_MESSAGE_DATA (0x30 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_RNGSTORE	 (0x34 << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_RNGFIFO	 (0x35 << FIFOST_TYPE_SHIFT)
+#define FIFOST_TYPE_METADATA	 (0x3e << FIFOST_TYPE_SHIFT)
 #define FIFOST_TYPE_SKIP	 (0x3f << FIFOST_TYPE_SHIFT)
 
 /*
@@ -1443,6 +1445,7 @@
 #define MATH_SRC1_INFIFO	(0x0a << MATH_SRC1_SHIFT)
 #define MATH_SRC1_OUTFIFO	(0x0b << MATH_SRC1_SHIFT)
 #define MATH_SRC1_ONE		(0x0c << MATH_SRC1_SHIFT)
+#define MATH_SRC1_ZERO		(0x0f << MATH_SRC1_SHIFT)
 
 /* Destination selectors */
 #define MATH_DEST_SHIFT		8
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index d258953ff488..00e87094588d 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -23,6 +23,14 @@ struct jr_driver_data {
 
 static struct jr_driver_data driver_data;
 
+static int jr_driver_probed;
+
+int caam_jr_driver_probed(void)
+{
+	return jr_driver_probed;
+}
+EXPORT_SYMBOL(caam_jr_driver_probed);
+
 static int caam_reset_hw_jr(struct device *dev)
 {
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(dev);
@@ -119,6 +127,8 @@ static int caam_jr_remove(struct platform_device *pdev)
 		dev_err(jrdev, "Failed to shut down job ring\n");
 	irq_dispose_mapping(jrpriv->irq);
 
+	jr_driver_probed--;
+
 	return ret;
 }
 
@@ -280,6 +290,36 @@ struct device *caam_jr_alloc(void)
 }
 EXPORT_SYMBOL(caam_jr_alloc);
 
+/**
+ * caam_jridx_alloc() - Alloc a specific job ring based on its index.
+ *
+ * returns :  pointer to the newly allocated physical
+ *	      JobR dev can be written to if successful.
+ **/
+struct device *caam_jridx_alloc(int idx)
+{
+	struct caam_drv_private_jr *jrpriv;
+	struct device *dev = ERR_PTR(-ENODEV);
+
+	spin_lock(&driver_data.jr_alloc_lock);
+
+	if (list_empty(&driver_data.jr_list))
+		goto end;
+
+	list_for_each_entry(jrpriv, &driver_data.jr_list, list_node) {
+		if (jrpriv->ridx == idx) {
+			atomic_inc(&jrpriv->tfm_count);
+			dev = jrpriv->dev;
+			break;
+		}
+	}
+
+end:
+	spin_unlock(&driver_data.jr_alloc_lock);
+	return dev;
+}
+EXPORT_SYMBOL(caam_jridx_alloc);
+
 /**
  * caam_jr_free() - Free the Job Ring
  * @rdev     - points to the dev that identifies the Job ring to
@@ -538,6 +578,8 @@ static int caam_jr_probe(struct platform_device *pdev)
 
 	atomic_set(&jrpriv->tfm_count, 0);
 
+	jr_driver_probed++;
+
 	return 0;
 }
 
diff --git a/drivers/crypto/caam/jr.h b/drivers/crypto/caam/jr.h
index 97113a6d6c58..ee4d31c9aeb8 100644
--- a/drivers/crypto/caam/jr.h
+++ b/drivers/crypto/caam/jr.h
@@ -8,7 +8,9 @@
 #define JR_H
 
 /* Prototypes for backend-level services exposed to APIs */
+int caam_jr_driver_probed(void);
 struct device *caam_jr_alloc(void);
+struct device *caam_jridx_alloc(int idx);
 void caam_jr_free(struct device *rdev);
 int caam_jr_enqueue(struct device *dev, u32 *desc,
 		    void (*cbk)(struct device *dev, u32 *desc, u32 status,
-- 
2.14.2.606.g7451fcd

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
