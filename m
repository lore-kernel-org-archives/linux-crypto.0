Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422875;
	b=hLjxsz3+97YvHFhHbmylR4mL88BNUsNTfrIA1k9IuVEujWZCHBYmyUhq8PQIHoMdJMFz
	 TijfeQgUXdbqHhuKdszCBaqnWpP/KeEZTn2bVUr/N4c6WHKLbkYvPzwpjT0gOj62o0CWP
	 7CUHp/8tg2x8obBhZLW+b4wjvTES/ElxDweJpkh30FJ+pYk+qpooO2J0NUArJ8RcClTh1
	 s5HmBnZr2DAwSCx6Bk8N1OTrnsax8+KoBRKJz7hXjRMG/ZbO3qV2csZ8RVCGn4mDxbQ8y
	 g2IZ77WxohB3xO2+W0MLVAVw6zA8+PranStJz6GHsPT376PticOk/KQPYG8DqzCEMbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422875;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=w8FFU920O6hthP2kOcBJoQFeT5EYhCngVGH34Szcxe0=;
	b=Q9VdRPSpeCmnInw8Vi8fvL78apQS9pYgvPfFrBwchxEKbem5OiEACOadOsI0I1sdwZHq
	 x8IJYazO9zR6rG0iXf6T7Me67xJ2MtCv7C1b0deM8YEnhnF1JsIc1XAr7bWkIAdnNsBnb
	 OF+8A0K3uLF8IKBgpKtAVx/FrVndjM3/cOR+mVOegkUDrpiqWdOwDc5ZcZ3tt9/wcpSFD
	 Uc/U+eoaZw0jnz6V0gvmUdjwsWHDNyFBegDuKYYj/Nj+CJw4ezhRPIYkZs7/xYHuoMYub
	 d3L0Um6E9hg1rSP41CdU4pAO5xrJXt36tVOQFnQIknTvMDjor2519QVa4o3e2nUlfBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RQE6mDPh;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B5D609CEC3;
	Mon, 19 Oct 2026 15:14:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53B5D609CEC3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RQE6mDPh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422875; x=1823958875;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wfn18wwXaGIRCG2m5ZCkpOBwKPLntBQ1wWxL20h4kI8=;
  b=RQE6mDPhOETcKs6ODno8uY2L1aIKh6aMe9WCQe9R6EG55IJN1rL/LoAM
   NdPxA1WezOKT+4hHUY/vz0oBTd94f5W8QXdjPRhtKkDgNHx1gK66bUFAL
   3sBYBPb3wgpDLW0XxPf+9P3AtBPvny5Ar4u0Asv8NYkRuKGzqwCQ24HdX
   jDi8+3EMX14CqAgo5oBPSi+OABMN/fKn7blYpQtseWD5a1q46p5v9CVtM
   3hHVBH5LeKgRRl9KiKuLWJ81lDxJtmTLaC1qOEgAJceXN8JCWe6PghjVi
   IRlwUOfTKZjIFACqCObrGqamHjNrll5+SdjjerLQs1aNdXiwkEej370XJ
   w==;
X-CSE-ConnectionGUID: m+KyKl4gTbulyKE0N3Z+bA==
X-CSE-MsgGUID: 0KjVkdCGTNC7I5UuzAqeRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986897"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986897"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:33 -0700
X-CSE-ConnectionGUID: 286F4wdWTGCbbBdc9uFnuw==
X-CSE-MsgGUID: GU6ljnV8TsCe6lQzE0utjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536946"
Received: from jf5300-15a101203tc.jf.intel.com (HELO meta-crater2c.jf.intel.com) ([10.54.113.49])
  by orviesa003.jf.intel.com with ESMTP; 19 Oct 2026 08:14:33 -0700
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
Subject: [PATCH 02/17] dmaengine: idxd: detach the user fault workqueue under the event log lock
Date: Mon, 19 Oct 2026 08:06:15 -0700
Message-ID: <20261019150630.4026341-3-daniel1.byrne@intel.com>
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

The event log walk tests wq->wq and queues fault work on it, and the
drain of a closing context's PASID tests it and drains it, both under
evl->lock. The user driver's remove destroyed the workqueue without
that lock, so a walk could queue on a workqueue being destroyed, and
the probe's error path destroyed it without clearing the pointer, so a
later walk or drain found a dangling one.

Detach and destroy the workqueue under evl->lock, in one helper that
the remove and the probe error path share, and clear the pointer in
both. A walk or a drain that finds it gone knows that the fault work
it would have waited for has run.

Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/cdev.c | 27 ++++++++++++++++++++++-----
 drivers/dma/idxd/irq.c  |  5 ++++-
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 82b07cf942ef..168888adccac 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -592,6 +592,26 @@ void idxd_wq_del_cdev(struct idxd_wq *wq)
 	put_device(cdev_dev(idxd_cdev));
 }
 
+/*
+ * The event log walk tests the fault workqueue and queues on it, and the
+ * drain of a closing context's PASID tests it and drains it, both under
+ * the log's lock, which neither the probe nor the remove otherwise takes.
+ * The workqueue is therefore detached and destroyed under that lock. A
+ * walk or a drain that finds it gone knows that its work has run.
+ */
+static void idxd_user_wq_destroy_fault_wq(struct idxd_wq *wq)
+{
+	struct idxd_evl *evl = wq->idxd->evl;
+
+	if (evl)
+		mutex_lock(&evl->lock);
+	wq->type = IDXD_WQT_NONE;
+	destroy_workqueue(wq->wq);
+	wq->wq = NULL;
+	if (evl)
+		mutex_unlock(&evl->lock);
+}
+
 static int idxd_user_drv_probe(struct idxd_dev *idxd_dev)
 {
 	struct device *dev = &idxd_dev->conf_dev;
@@ -653,8 +673,7 @@ static int idxd_user_drv_probe(struct idxd_dev *idxd_dev)
 err_cdev:
 	idxd_drv_disable_wq(wq);
 err:
-	destroy_workqueue(wq->wq);
-	wq->type = IDXD_WQT_NONE;
+	idxd_user_wq_destroy_fault_wq(wq);
 wq_err:
 	mutex_unlock(&wq->wq_lock);
 	return rc;
@@ -667,9 +686,7 @@ static void idxd_user_drv_remove(struct idxd_dev *idxd_dev)
 	mutex_lock(&wq->wq_lock);
 	idxd_wq_del_cdev(wq);
 	idxd_drv_disable_wq(wq);
-	wq->type = IDXD_WQT_NONE;
-	destroy_workqueue(wq->wq);
-	wq->wq = NULL;
+	idxd_user_wq_destroy_fault_wq(wq);
 	mutex_unlock(&wq->wq_lock);
 }
 
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index 820b1ff69fb6..647969920a06 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -339,7 +339,10 @@ static void process_evl_entry(struct idxd_device *idxd,
 			 * PASID xarray, which is populated by cdev opens
 			 * alone. A kernel WQ has no cdev workqueue and no
 			 * user contexts, so queueing could only warn and
-			 * drop the record. Note it and move on.
+			 * drop the record. Note it and move on. The user
+			 * driver detaches the workqueue under evl->lock,
+			 * which this walk holds, so the one tested here is
+			 * the one queued on.
 			 */
 			if (!is_idxd_wq_user(wq) || !wq->wq) {
 				dev_warn_ratelimited(dev,
-- 
2.43.0

