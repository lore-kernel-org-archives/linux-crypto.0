From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH 2/3] crypto: caam - Add API's to allocate/free Job Rings
Date: Fri, 25 Oct 2013 12:01:02 +0530
Message-ID: <1382682663-18651-2-git-send-email-ruchika.gupta@freescale.com>
References: <1382682663-18651-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:44342
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab3JYGgO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Oct 2013 02:36:14 -0400
In-Reply-To: <1382682663-18651-1-git-send-email-ruchika.gupta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With each of the Job Ring available as a platform device, the
Job Ring driver needs to take care of allocation/deallocation
of the Job Rings to the above interface layers. Added APIs
in Job Ring Driver to allocate/free Job rings

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
Reviewed-by: Garg Vakul-B16394 <vakul@freescale.com>
---
 drivers/crypto/caam/intern.h |  3 +++
 drivers/crypto/caam/jr.c     | 60 +++++++++++++++++++++++++++++++++++++++++---
 drivers/crypto/caam/jr.h     |  2 ++
 3 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index bff4acd..b781445 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -44,6 +44,9 @@ struct caam_drv_private_jr {
 	struct tasklet_struct irqtask;
 	int irq;			/* One per queue */
 
+	/* Number of scatterlist crypt transforms active on the JobR */
+	atomic_t tfm_count ____cacheline_aligned;
+
 	/* Job ring info */
 	int ringsize;	/* Size of rings (assume input = output) */
 	struct caam_jrentry_info *entinfo;	/* Alloc'ed 1 per ring entry */
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index cdeaf25..636bb53 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -97,10 +97,9 @@ static int caam_jr_remove(struct platform_device *pdev)
 	jrpriv = dev_get_drvdata(jrdev);
 
 	/*
-	 * Make sure ring is empty before release
+	 * Return EBUSY if job ring already allocated.
 	 */
-	if (rd_reg32(&jrpriv->rregs->outring_used) ||
-	    (rd_reg32(&jrpriv->rregs->inpring_avail) != JOBR_DEPTH)) {
+	if (atomic_read(&jrpriv->tfm_count)) {
 		dev_err(jrdev, "Device is busy\n");
 		return -EBUSY;
 	}
@@ -234,6 +233,59 @@ static void caam_jr_dequeue(unsigned long devarg)
 }
 
 /**
+ * caam_jr_alloc() - Alloc a job ring for someone to use as needed.
+ *
+ * returns :  pointer to the newly allocated physical
+ *	      JobR dev can be written to if successful.
+ **/
+struct device *caam_jr_alloc(void)
+{
+	struct caam_drv_private_jr *jrpriv, *min_jrpriv = NULL;
+	struct device *dev = NULL;
+	int min_tfm_cnt	= INT_MAX;
+	int tfm_cnt;
+
+	spin_lock(&driver_data.jr_alloc_lock);
+
+	if (list_empty(&driver_data.jr_list)) {
+		spin_unlock(&driver_data.jr_alloc_lock);
+		return ERR_PTR(-ENODEV);
+	}
+
+	list_for_each_entry(jrpriv, &driver_data.jr_list, list_node) {
+		tfm_cnt = atomic_read(&jrpriv->tfm_count);
+		if (tfm_cnt < min_tfm_cnt) {
+			min_tfm_cnt = tfm_cnt;
+			min_jrpriv = jrpriv;
+		}
+		if (!min_tfm_cnt)
+			break;
+	}
+
+	if (min_jrpriv) {
+		atomic_inc(&min_jrpriv->tfm_count);
+		dev = min_jrpriv->dev;
+	}
+	spin_unlock(&driver_data.jr_alloc_lock);
+
+	return dev;
+}
+EXPORT_SYMBOL(caam_jr_alloc);
+
+/**
+ * caam_jr_free() - Free the Job Ring
+ * @rdev     - points to the dev that identifies the Job ring to
+ *             be released.
+ **/
+void caam_jr_free(struct device *rdev)
+{
+	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(rdev);
+
+	atomic_dec(&jrpriv->tfm_count);
+}
+EXPORT_SYMBOL(caam_jr_free);
+
+/**
  * caam_jr_enqueue() - Enqueue a job descriptor head. Returns 0 if OK,
  * -EBUSY if the queue is full, -EIO if it cannot map the caller's
  * descriptor.
@@ -442,6 +494,8 @@ static int caam_jr_probe(struct platform_device *pdev)
 	list_add_tail(&jrpriv->list_node, &driver_data.jr_list);
 	spin_unlock(&driver_data.jr_alloc_lock);
 
+	atomic_set(&jrpriv->tfm_count, 0);
+
 	return 0;
 }
 
diff --git a/drivers/crypto/caam/jr.h b/drivers/crypto/caam/jr.h
index 02f69bb..97113a6 100644
--- a/drivers/crypto/caam/jr.h
+++ b/drivers/crypto/caam/jr.h
@@ -8,6 +8,8 @@
 #define JR_H
 
 /* Prototypes for backend-level services exposed to APIs */
+struct device *caam_jr_alloc(void);
+void caam_jr_free(struct device *rdev);
 int caam_jr_enqueue(struct device *dev, u32 *desc,
 		    void (*cbk)(struct device *dev, u32 *desc, u32 status,
 				void *areq),
-- 
1.8.1.4
