Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422878;
	b=3SXlwloAtyH3p6OD5q1h1Kyve00owqDz0cnpiu1sGpaiwAQiMmp39Nim3n5UoS8KsLoi
	 EGw8Uk0EXffPQvCLcBqBk2H+btmDQHHn83eZhumqf5+JKlsEHz5qreAmcJwXRE2oCM4M4
	 DZQzsiEpjp4clNNj293MtNRrtQrxKUUvjWp+UgXEpPnVwBXZulOhETwxNB9rsn03xCXvE
	 U58F8lCAMr8t3Rmd2bOpuQpLLY2JyUnGxgf8YAcWQ2PwQKHX928zcbFQiC08NVnm1dTQH
	 VUAFNEdjL+RDq/pGpefl3wN2gswX9HrTHuIKaQ7flMkN/c9Kqav4vmi1pXGph6hhm3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422878;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ws3H+lIEcNOXtpveRpahYY4erdxZUvHm7RfHeuN9MhI=;
	b=IaVDKHHfoGSdjejTSRuOpt4ysyXso6OzoBn7PvqfUoPgyeepGRgLSJPWeN6ixuZBg2uN
	 cBBQd8cJ8jIy9dNcES25mkt9z5MSKkRkjMi5WOALeavdfV8iVJW1U8E50xWEsHi90ZdrO
	 G1q6WJBFWNMkIpwiZrd5Cr53Wc7vh8AfywxYFj+kY3umF/kGkjA2oIhs96w7PLk93AuKT
	 eRRSzfVe4C735oSi/WKBarlyBHFNPFbmTuVsNXGI/WDeXGsPY0+jsUpMnzXMu5JRhkW+N
	 k8cYMEc25Cd4NYVz2mbdDZ2X/apgEzPczCEVBq+LOWNT0yU7E/uhi/nJMAzvgkY/iEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=A6xshx09;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5041609CED5;
	Mon, 19 Oct 2026 15:14:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5041609CED5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=A6xshx09
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422878; x=1823958878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mi88PpzB2jgeRU5T7r8TqeC2BDhPk+eVLupIAsqkK3Y=;
  b=A6xshx09EvpKqxhvlUYOAiFD+qszws2KdNE7HBi27iGvhxWxy6KMcZjs
   0PV7o5fzfG9E70IMVDdR5Qb59heFAmVhOhRwpFH59rf24pHgwbbU6c+qC
   m6P/2Ihi71dY9hb+VS2/tea0LpCuoWZ+Ts1LZyavTwq+UVH2G7hK0KkpX
   mdsGanzw3/yx3F0zHyyxGy1GIyXa/CLkAYIhnZRw4aZdhfLGGZEiJ9Uus
   BTOMfPHpftllfprhZ7mT+gCYvICH39pHA8KRJt5LPUBEL3tXarbxVqH59
   ny5YLjuW28zYSaZFb4XDdoK4TGOgM+bUplV53CU4QqaEWGmVXJI/KzrEb
   Q==;
X-CSE-ConnectionGUID: AdNFSCYtQ4mo+i+PM+PhzQ==
X-CSE-MsgGUID: tufFMB7KQ5qHwREgTxboJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986921"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986921"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:34 -0700
X-CSE-ConnectionGUID: RHusxk8UT4OjLkn3wu9nAA==
X-CSE-MsgGUID: vMS66wY1SQSs8cEGadeY/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536978"
Received: from jf5300-15a101203tc.jf.intel.com (HELO meta-crater2c.jf.intel.com) ([10.54.113.49])
  by orviesa003.jf.intel.com with ESMTP; 19 Oct 2026 08:14:34 -0700
From: Daniel Byrne <daniel1.byrne@intel.com>
To: Vinod Koul <vkoul@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Frank Li <Frank.Li@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	dmaengine@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 10/17] dmaengine: idxd: return -ETIMEDOUT from drains and resets and leak what the device may still write
Date: Mon, 19 Oct 2026 08:06:23 -0700
Message-ID: <20261019150630.4026341-11-daniel1.byrne@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019150630.4026341-1-daniel1.byrne@intel.com>
References: <20261019150630.4026341-1-daniel1.byrne@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A device command that timed out, or was refused because an earlier one
did, leaves the device enabled with whatever it holds, and a timeout
must never read as a completed drain: the callers free the memory the
device still writes into, or unbind a PASID the device still issues DMA
with.

idxd_wq_drain(), idxd_wq_reset() and idxd_device_drain_pasid() return
-ETIMEDOUT for such a command, and their callers leak what the device
may still reach. The work queue disable keeps the descriptor and
completion memory, and the cdev release keeps the context and its
PASID binding. idxd_wq_disable() reports a failed drain instead of
resetting the queue, so the dedicated user queue's release keeps its
context as the shared queue's does. idxd_wq_reset() leaves the software
state of a queue whose reset timed out enabled, as idxd_wq_disable()
does after a failed reset: the device still runs the queue on its
configuration, and clearing that state let sysfs accept a new one and a
later bind enable the queue on it. idxd_device_reset() reports a refused
reset instead of clearing the software state of an enabled device, and
the device-level remove that could neither disable nor reset the device
keeps the event log.

A command a halted device never ran is not a timeout. A halted device
runs nothing until it is reset, so a drain or reset refused that way
counts as complete, and the cdev release unbinds its PASID normally.

device_synchronize() cannot keep its promise after a drain that failed.
The channel release path runs it under dma_list_mutex, and a device
that refused the drain offers nothing to wait for, so the driver keeps
its own memory safe instead: the quarantined slots stay out of use and
the queue takes no new descriptor until a later drain completes or a
halt kills what the device holds, so a late completion record lands in
a slot nobody reuses.

Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/cdev.c   |  35 ++++++++--
 drivers/dma/idxd/device.c | 138 +++++++++++++++++++++++++++++++-------
 drivers/dma/idxd/dma.c    |  31 +++++++--
 drivers/dma/idxd/idxd.h   |  14 ++--
 drivers/dma/idxd/irq.c    |   4 +-
 drivers/dma/idxd/submit.c |   7 ++
 6 files changed, 190 insertions(+), 39 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 168888adccac..4cfa77c72719 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -120,30 +120,53 @@ static void idxd_file_dev_release(struct device *dev)
 	struct idxd_user_context *ctx = dev_to_uctx(dev);
 	struct idxd_wq *wq = ctx->wq;
 	struct idxd_device *idxd = wq->idxd;
-	int rc;
+	int rc, drained = 0;
 
 	ida_free(&file_ida, ctx->id);
 
 	/* Wait for in-flight operations to complete. */
 	if (wq_shared(wq)) {
-		idxd_device_drain_pasid(idxd, ctx->pasid);
+		drained = idxd_device_drain_pasid(idxd, ctx->pasid);
 	} else {
 		if (device_user_pasid_enabled(idxd)) {
-			/* The wq disable in the disable pasid function will drain the wq */
+			/*
+			 * The wq disable in the disable pasid function drains
+			 * the wq. A drain that never completed leaves the
+			 * PASID in the queue's configuration with the
+			 * descriptors still in it. A failure after the drain,
+			 * re-enabling the queue for instance, does not.
+			 */
 			rc = idxd_wq_disable_pasid(wq);
-			if (rc < 0)
-				dev_err(dev, "wq disable pasid failed.\n");
+			if (rc < 0) {
+				dev_err(dev, "wq disable pasid failed: %d\n", rc);
+				if (rc == -ETIMEDOUT)
+					drained = rc;
+			}
 		} else {
-			idxd_wq_drain(wq);
+			drained = idxd_wq_drain(wq);
 		}
 	}
 
+	/*
+	 * A drain that never completed leaves this context's descriptors
+	 * in the device, tagged with its PASID. Unbinding the PASID would
+	 * let it be reused by another process while the device can still
+	 * issue DMA with it, so the binding, the PASID lookup entry and the
+	 * context are leaked instead.
+	 */
+	if (drained) {
+		dev_err(dev, "pasid %u: drain timed out, leaking the context and its PASID binding\n",
+			ctx->pasid);
+		goto put_wq;
+	}
+
 	if (ctx->sva) {
 		idxd_cdev_evl_drain_pasid(wq, ctx->pasid);
 		iommu_sva_unbind_device(ctx->sva);
 		idxd_xa_pasid_remove(ctx);
 	}
 	kfree(ctx);
+put_wq:
 	mutex_lock(&wq->wq_lock);
 	idxd_wq_put(wq);
 	mutex_unlock(&wq->wq_lock);
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 09475f5ea026..d3b95593a686 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -19,6 +19,7 @@ static void idxd_cmd_exec(struct idxd_device *idxd, int cmd_code, u32 operand,
 			  u32 *status);
 static void idxd_device_wqs_clear_state(struct idxd_device *idxd);
 static void idxd_wq_disable_cleanup(struct idxd_wq *wq);
+static inline bool idxd_device_is_halted(struct idxd_device *idxd);
 static int idxd_wq_config_write(struct idxd_wq *wq);
 
 /* Interrupt control bits */
@@ -119,6 +120,7 @@ int idxd_wq_alloc_resources(struct idxd_wq *wq)
 		return 0;
 
 	/* A fresh pool: nothing outstanding can land in it. */
+	wq->stuck = false;
 	INIT_LIST_HEAD(&wq->quarantine);
 	num_descs = wq_dedicated(wq) ? wq->size : wq->threshold;
 	wq->num_descs = num_descs;
@@ -222,6 +224,7 @@ int idxd_wq_disable(struct idxd_wq *wq, bool reset_config)
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
 	u32 status, operand;
+	int rc;
 
 	dev_dbg(dev, "Disabling WQ %d\n", wq->id);
 
@@ -239,8 +242,14 @@ int idxd_wq_disable(struct idxd_wq *wq, bool reset_config)
 	 * To make sure pending translations are drained before WQ
 	 * attributes are changed, we use a WQ Drain followed by WQ Reset and
 	 * then restore the WQ configuration.
+	 *
+	 * A drain that timed out leaves descriptors in the queue. Report
+	 * it instead of resetting, so that the caller keeps whatever those
+	 * descriptors can still reach, a PASID for instance.
 	 */
-	idxd_wq_drain(wq);
+	rc = idxd_wq_drain(wq);
+	if (rc)
+		return rc;
 
 	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
 	idxd_cmd_exec(idxd, IDXD_CMD_RESET_WQ, operand, &status);
@@ -260,36 +269,72 @@ int idxd_wq_disable(struct idxd_wq *wq, bool reset_config)
 	return 0;
 }
 
-void idxd_wq_drain(struct idxd_wq *wq)
+/*
+ * The result of a drain or a reset. IDXD_CMDSTS_HW_ERR stands for a
+ * command that timed out, or was refused after one did, and then the
+ * device may still run what it holds. It is also the device's own code
+ * for a hardware error, after which the specification has software read
+ * GENSTS. Both leave the device enabled unless it halted, and a halted
+ * device runs nothing until it is reset, so what it holds is then as
+ * gone as after a drain and that is not a timeout.
+ */
+static int idxd_cmd_drain_result(struct idxd_device *idxd, u32 status)
+{
+	if (status != IDXD_CMDSTS_HW_ERR || idxd_device_is_halted(idxd))
+		return 0;
+	return -ETIMEDOUT;
+}
+
+/*
+ * Returns -ETIMEDOUT when the command never completed, or was refused
+ * because an earlier one never did, in which case descriptors may still
+ * be in the device and the caller must not free anything it can write
+ * into.
+ */
+int idxd_wq_drain(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
-	u32 operand;
+	u32 operand, status;
 
 	if (wq->state != IDXD_WQ_ENABLED) {
 		dev_dbg(dev, "WQ %d in wrong state: %d\n", wq->id, wq->state);
-		return;
+		return 0;
 	}
 
 	dev_dbg(dev, "Draining WQ %d\n", wq->id);
 	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
-	idxd_cmd_exec(idxd, IDXD_CMD_DRAIN_WQ, operand, NULL);
+	idxd_cmd_exec(idxd, IDXD_CMD_DRAIN_WQ, operand, &status);
+	return idxd_cmd_drain_result(idxd, status);
 }
 
-void idxd_wq_reset(struct idxd_wq *wq)
+int idxd_wq_reset(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
-	u32 operand;
+	u32 operand, status;
+	int rc;
 
 	if (wq->state != IDXD_WQ_ENABLED) {
 		dev_dbg(dev, "WQ %d in wrong state: %d\n", wq->id, wq->state);
-		return;
+		return 0;
 	}
 
 	operand = BIT(wq->id % 16) | ((wq->id / 16) << 16);
-	idxd_cmd_exec(idxd, IDXD_CMD_RESET_WQ, operand, NULL);
+	idxd_cmd_exec(idxd, IDXD_CMD_RESET_WQ, operand, &status);
+	/*
+	 * A reset that timed out, or was refused after a command did,
+	 * leaves the queue enabled in the device on its configuration.
+	 * Its software state stays enabled too, as after a failed
+	 * idxd_wq_disable(), so that the queue is neither reconfigured nor
+	 * enabled again on a configuration the device does not run until
+	 * a device disable or reset has stopped it.
+	 */
+	rc = idxd_cmd_drain_result(idxd, status);
+	if (rc)
+		return rc;
 	idxd_wq_disable_cleanup(wq);
+	return 0;
 }
 
 int idxd_wq_map_portal(struct idxd_wq *wq)
@@ -732,24 +777,41 @@ int idxd_device_disable(struct idxd_device *idxd)
 	return 0;
 }
 
-void idxd_device_reset(struct idxd_device *idxd)
+/*
+ * Returns -ENXIO when the device refused or never ran the reset. The
+ * software state is cleared only after a reset that ran, since clearing
+ * it for an enabled device lets a later teardown free memory the device
+ * still writes.
+ */
+int idxd_device_reset(struct idxd_device *idxd)
 {
-	idxd_cmd_exec(idxd, IDXD_CMD_RESET_DEVICE, 0, NULL);
+	u32 status;
+
+	idxd_cmd_exec(idxd, IDXD_CMD_RESET_DEVICE, 0, &status);
+	if (status != IDXD_CMDSTS_SUCCESS) {
+		dev_dbg(&idxd->pdev->dev, "%s: err_code: %#x\n", __func__, status);
+		return -ENXIO;
+	}
 	idxd_device_clear_state(idxd);
 	spin_lock(&idxd->dev_lock);
 	idxd_unmask_error_interrupts(idxd);
 	spin_unlock(&idxd->dev_lock);
+	return 0;
 }
 
-void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid)
+/* Returns -ETIMEDOUT when the drain was never run or never completed. */
+int idxd_device_drain_pasid(struct idxd_device *idxd, int pasid)
 {
 	struct device *dev = &idxd->pdev->dev;
-	u32 operand;
+	u32 operand, status;
 
 	operand = pasid;
 	dev_dbg(dev, "cmd: %u operand: %#x\n", IDXD_CMD_DRAIN_PASID, operand);
-	idxd_cmd_exec(idxd, IDXD_CMD_DRAIN_PASID, operand, NULL);
+	idxd_cmd_exec(idxd, IDXD_CMD_DRAIN_PASID, operand, &status);
+	if (idxd_cmd_drain_result(idxd, status))
+		return -ETIMEDOUT;
 	dev_dbg(dev, "pasid %d drained\n", pasid);
+	return 0;
 }
 
 int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
@@ -1480,6 +1542,14 @@ void idxd_wq_quarantine_take(struct idxd_wq *wq, struct list_head *list)
 	spin_unlock(&wq->ie.list_lock);
 }
 
+/* The drain did not complete: the device may still run them. */
+void idxd_wq_quarantine_put_back(struct idxd_wq *wq, struct list_head *list)
+{
+	spin_lock(&wq->ie.list_lock);
+	list_splice(list, &wq->quarantine);
+	spin_unlock(&wq->ie.list_lock);
+}
+
 /*
  * Nothing the device holds can write their completion records, or reach
  * the memory their unmap data maps, any more. The unmap data goes before
@@ -1498,8 +1568,8 @@ void idxd_wq_quarantine_free(struct idxd_wq *wq, struct list_head *list)
 
 /*
  * A halt killed every descriptor the device held: the quarantined slots
- * are free. Under wq_lock, since an unbind racing the halt may free the
- * pool.
+ * are free, and the fence a failed drain raised can be lifted. Under
+ * wq_lock, since an unbind racing the halt may free the pool.
  */
 void idxd_wq_halt_release(struct idxd_wq *wq)
 {
@@ -1512,6 +1582,7 @@ void idxd_wq_halt_release(struct idxd_wq *wq)
 
 	idxd_wq_quarantine_take(wq, &dead_descs);
 	idxd_wq_quarantine_free(wq, &dead_descs);
+	WRITE_ONCE(wq->stuck, false);
 }
 
 static void idxd_device_set_perm_entry(struct idxd_device *idxd,
@@ -1783,6 +1854,7 @@ void idxd_drv_disable_wq(struct idxd_wq *wq)
 {
 	struct idxd_device *idxd = wq->idxd;
 	struct device *dev = &idxd->pdev->dev;
+	int rc;
 
 	lockdep_assert_held(&wq->wq_lock);
 
@@ -1791,10 +1863,19 @@ void idxd_drv_disable_wq(struct idxd_wq *wq)
 			 wq->id, idxd_wq_refcount(wq));
 
 	idxd_wq_unmap_portal(wq);
-	idxd_wq_drain(wq);
+	rc = idxd_wq_drain(wq);
 	idxd_wq_free_irq(wq);
-	idxd_wq_reset(wq);
-	idxd_wq_free_resources(wq);
+	rc |= idxd_wq_reset(wq);
+	/*
+	 * A drain or reset that never completed leaves descriptors in the
+	 * device, and their completion records live in the memory freed
+	 * here. Leak it; the device writing into freed memory is worse.
+	 */
+	if (rc)
+		dev_err(dev, "wq %d: drain or reset timed out, leaking its descriptor memory\n",
+			wq->id);
+	else
+		idxd_wq_free_resources(wq);
 	percpu_ref_exit(&wq->wq_active);
 	wq->client_count = 0;
 }
@@ -1862,6 +1943,7 @@ void idxd_device_drv_remove(struct idxd_dev *idxd_dev)
 {
 	struct device *dev = &idxd_dev->conf_dev;
 	struct idxd_device *idxd = idxd_dev_to_idxd(idxd_dev);
+	bool stopped;
 	int i;
 
 	for (i = 0; i < idxd->max_wqs; i++) {
@@ -1882,10 +1964,20 @@ void idxd_device_drv_remove(struct idxd_dev *idxd_dev)
 	}
 
 	idxd_unregister_dma_device(idxd);
-	idxd_device_disable(idxd);
-	if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
-		idxd_device_reset(idxd);
-	idxd_device_evl_free(idxd);
+	/*
+	 * A disable or a reset that ran, or found the device disabled or
+	 * halted, leaves nothing in flight. Both are refused after a device
+	 * command timed out, and the device then stays enabled with whatever
+	 * it holds, so what it may still write is kept.
+	 */
+	stopped = !idxd_device_disable(idxd);
+	if (test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags) &&
+	    !idxd_device_reset(idxd))
+		stopped = true;
+	if (stopped)
+		idxd_device_evl_free(idxd);
+	else
+		dev_err(dev, "device still enabled after a command timeout, leaking the event log\n");
 }
 
 static enum idxd_dev_type dev_types[] = {
diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index 196045cb9ef2..1d08856f5c4e 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -212,13 +212,34 @@ static void idxd_dma_synchronize(struct dma_chan *c)
 
 	/*
 	 * dmaengine_synchronize() promises the client that its memory may
-	 * be freed afterwards. The drain keeps that promise, and nothing
-	 * the device held before it is left to write a completion record,
-	 * so the slots terminate_all quarantined are free again.
+	 * be freed afterwards. A drain that completed keeps that promise,
+	 * and nothing the device held before it is left to write a
+	 * completion record, so the slots terminate_all quarantined are
+	 * free again. A drain that never completed, or that was refused
+	 * because an earlier command never did, leaves the client's
+	 * descriptors in a device that may still run them. The channel
+	 * release path runs this under dma_list_mutex, and a device that
+	 * refused the drain offers nothing to wait for, so waiting longer
+	 * here would hold up every dmaengine user for nothing. The driver
+	 * cannot keep the promise for the client's memory then and says so.
+	 * It keeps its own memory safe: the quarantined slots stay out of
+	 * use and the queue takes no new descriptor until a later drain
+	 * completes or a halt kills what the device holds, so a late
+	 * completion record lands in a slot nobody reuses, and
+	 * idxd_drv_disable_wq() leaks what the device may still write.
+	 * Only a device reset ends the exposure of the client's memory.
 	 */
 	idxd_wq_quarantine_take(wq, &quarantined);
-	idxd_wq_drain(wq);
-	idxd_wq_quarantine_free(wq, &quarantined);
+	if (!idxd_wq_drain(wq)) {
+		idxd_wq_quarantine_free(wq, &quarantined);
+		WRITE_ONCE(wq->stuck, false);
+		return;
+	}
+	idxd_wq_quarantine_put_back(wq, &quarantined);
+	WRITE_ONCE(wq->stuck, true);
+	dev_err_ratelimited(&wq->idxd->pdev->dev,
+			    "wq %d: drain failed. Its descriptors may still complete and it takes no new work until a drain completes or the device is reset\n",
+			    wq->id);
 }
 
 int idxd_register_dma_device(struct idxd_device *idxd)
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index 31bc4a506225..c04a2855aa3f 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -224,6 +224,11 @@ struct idxd_wq {
 	struct idxd_desc **descs;
 	struct sbitmap_queue sbq;
 	struct idxd_dma_chan *idxd_chan;
+	bool stuck;		/* a drain failed with the device enabled: the
+				 * outstanding descriptors may complete at any
+				 * time, so no slot is reused until a later
+				 * drain completes or a halt kills them
+				 */
 	struct list_head quarantine;	/* descriptors a terminate_all took
 					 * off the lists while the device
 					 * still held them. Their slots, with
@@ -786,11 +791,11 @@ void idxd_drv_disable_wq(struct idxd_wq *wq);
 int idxd_device_init_reset(struct idxd_device *idxd);
 int idxd_device_enable(struct idxd_device *idxd);
 int idxd_device_disable(struct idxd_device *idxd);
-void idxd_device_reset(struct idxd_device *idxd);
+int idxd_device_reset(struct idxd_device *idxd);
 void idxd_device_clear_state(struct idxd_device *idxd);
 void idxd_cmd_reset_state(struct idxd_device *idxd);
 int idxd_device_config(struct idxd_device *idxd);
-void idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
+int idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
 int idxd_device_load_config(struct idxd_device *idxd);
 int idxd_device_request_int_handle(struct idxd_device *idxd, int idx, int *handle,
 				   enum idxd_interrupt_type irq_type);
@@ -803,8 +808,8 @@ int idxd_wq_alloc_resources(struct idxd_wq *wq);
 void idxd_wq_free_resources(struct idxd_wq *wq);
 int idxd_wq_enable(struct idxd_wq *wq);
 int idxd_wq_disable(struct idxd_wq *wq, bool reset_config);
-void idxd_wq_drain(struct idxd_wq *wq);
-void idxd_wq_reset(struct idxd_wq *wq);
+int idxd_wq_drain(struct idxd_wq *wq);
+int idxd_wq_reset(struct idxd_wq *wq);
 int idxd_wq_map_portal(struct idxd_wq *wq);
 void idxd_wq_unmap_portal(struct idxd_wq *wq);
 int idxd_wq_set_pasid(struct idxd_wq *wq, int pasid);
@@ -816,6 +821,7 @@ void idxd_wq_free_irq(struct idxd_wq *wq);
 int idxd_wq_request_irq(struct idxd_wq *wq);
 void idxd_wq_flush_descs(struct idxd_wq *wq, bool quarantine);
 void idxd_wq_quarantine_take(struct idxd_wq *wq, struct list_head *list);
+void idxd_wq_quarantine_put_back(struct idxd_wq *wq, struct list_head *list);
 void idxd_wq_quarantine_free(struct idxd_wq *wq, struct list_head *list);
 void idxd_wq_halt_release(struct idxd_wq *wq);
 
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 6f58d33b7297..e48f7c307ceb 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -40,7 +40,9 @@ static void idxd_device_reinit(struct work_struct *work)
 	 * timed out before the halt would otherwise refuse the reset.
 	 */
 	idxd_cmd_reset_state(idxd);
-	idxd_device_reset(idxd);
+	rc = idxd_device_reset(idxd);
+	if (rc < 0)
+		goto out;
 	rc = idxd_device_config(idxd);
 	if (rc < 0)
 		goto out;
diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index 03217041b8b3..26dce0179d30 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -34,6 +34,13 @@ struct idxd_desc *idxd_alloc_desc(struct idxd_wq *wq, enum idxd_op_type optype)
 
 	if (idxd->state != IDXD_DEV_ENABLED)
 		return ERR_PTR(-EIO);
+	/*
+	 * A failed drain left descriptors the device may still complete.
+	 * No slot is reused until a later drain completes or a halt kills
+	 * them.
+	 */
+	if (READ_ONCE(wq->stuck))
+		return ERR_PTR(-ENXIO);
 
 	sbq = &wq->sbq;
 	idx = sbitmap_queue_get(sbq, &cpu);
-- 
2.43.0

