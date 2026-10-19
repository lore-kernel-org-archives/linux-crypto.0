Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422879;
	b=r99UfxHO65M67gDXr6ToEFv8dCvRhLHl0rgovTQFc89SjBUsuLOnOdZ5js5e+X1VBDaF
	 v9/4WqHzEljKv0yOvKcANv0E2CoybP5fQvIoPUdS01CaAK6aWNY82iAH+IzkqkIryXjnM
	 +bnkBhYwXUucRTp2rhYLNF6EipdNdlacfOLV4Z5Z6KqtjJXmGZjP6smZ0Fn/gdcqIzUNN
	 3YsaTze7yMrjcoa3cSh+bRNuJWU5U0TCfij9uoA6BOdGoolFYpwg553fLFuNQl97dP5Ef
	 yJct6ffY/oNYZdL3MODstJLsoVLV55Wd3I4YCPXQgwkPgrnLzSHzKmCUckKl31XnR9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422879;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TKt0wIyw61Jqk2IhfD66W7oNe5O8PkSQRaKgq/MX62o=;
	b=Hjrq+Gju3fWvrTeun7DF5/Xq9000LRJfDXawarlK4dICwTVeW2KqiFynxUBzlOLj+pPL
	 Q6AarLU9kpw0hFTW2FSuOAR87pXFfZhCpN8CbESehgVvmgKtomfVZvK1Cnjdytjcmds9n
	 XoGYQb9ngpt0ncKqhmzeD/z59jGb01l0814d4NNho5Gk3edy2IexqmqngA7FYQbeXJZsi
	 HoreGu/5c5RwmWmjWMc7JoBVVDAPjVOfsH4l8u7quR93QweP8xwadbp5asgiJsPE2G7RA
	 hbWuBFwwwlvH+ME+o6iZDUL3Dps69Ro8SFkXiwsYHdb0Yf51DL2revGu5rLKVCCNe6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cobzsBOM;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE60609CED7;
	Mon, 19 Oct 2026 15:14:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CE60609CED7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cobzsBOM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422879; x=1823958879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O4amii2pzLm3C5mzdVc3gIpQy4aiCuKSjiPtyMfocTM=;
  b=cobzsBOMskme4ib2X3gEZ8J0RPbmv9/bPQyBMC0FamTjjc3Ti4RoKzvI
   SYhKtB5Cu2s62toOHTKm3jPO1x5okpmTpHgIN3dGVqbpJ/Z8DRFugETIO
   tySRIyKRemMupdfRTox8p3NT7zki08Cey4LB6SF5OeFgx8Fbf+Ef3LOB7
   dT7lLxk5V8UsHfwXRaOKh7TUS6YUbFpBpf7S/DL7EmytE/Jz7lD4hJg9Q
   RmuflCs7pmeFHX2UR4RmviCf7eF2IB9hHGLTGRnKwKbCrTrxnk8VypL4Q
   NEKN7dBPd7L+L+gdRgcbsQKQViWCoFTz7sdlOVl43ctFjQ/8SQ0quiuue
   g==;
X-CSE-ConnectionGUID: 8NpEQ7ttRlCiIdyrf+aruA==
X-CSE-MsgGUID: DitMwP8FTxyJdO27n8YpXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986927"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986927"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:34 -0700
X-CSE-ConnectionGUID: DYtkNTj1Tg+aijwvHYD7ag==
X-CSE-MsgGUID: CPIvL5oDRxCg92KKLiAeIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536986"
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
Subject: [PATCH 12/17] dmaengine: idxd: hold device commands off while the reset re-creates its interrupts
Date: Mon, 19 Oct 2026 08:06:25 -0700
Message-ID: <20261019150630.4026341-13-daniel1.byrne@intel.com>
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

The re-probe after a reset frees the misc interrupt and the MSI-X
vectors and requests them again. A device command whose completion
interrupt arrives in between is never completed, so its owner times
out and fences the device that was just reset, and the rebind in
idxd_reset_done() then fails.

Wait for the running command before the vectors are freed, since its
interrupt still arrives, and then hold IDXD_FLAG_CMD_RUNNING without an
owner until the interrupts are back, so that commands issued meanwhile
wait as they wait for any running command. A halt's recovery may forget
the hold, so it is released only if no newer command owns the state.

Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/device.c | 44 +++++++++++++++++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h   |  2 ++
 drivers/dma/idxd/init.c   | 10 +++++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index d3b95593a686..222c201669bd 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -724,6 +724,50 @@ void idxd_cmd_reset_state(struct idxd_device *idxd)
 	spin_unlock_irqrestore(&idxd->cmd_lock, flags);
 }
 
+/*
+ * Hold device commands off while the re-probe after a reset frees the
+ * interrupts and requests them again. A command whose completion
+ * interrupt comes while the misc vector is gone is never completed, and
+ * its owner would time out and fence the device that was just reset.
+ * The running command, if any, is waited for first: its owner gives up
+ * within its timeout, and the misc vector still takes its interrupt.
+ * RUNNING is then held without an owner, and new commands wait for it
+ * as for any running command. Returns false, holding nothing, when a
+ * command timed out, since commands then fail fast anyway.
+ */
+bool idxd_cmd_hold(struct idxd_device *idxd, u32 *seq)
+{
+	bool held = false;
+
+	spin_lock_irq(&idxd->cmd_lock);
+	wait_event_lock_irq(idxd->cmd_waitq,
+			    !test_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags) ||
+			    test_bit(IDXD_FLAG_CMD_TIMEDOUT, &idxd->flags),
+			    idxd->cmd_lock);
+	if (!test_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags)) {
+		__set_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags);
+		*seq = ++idxd->cmd_seq;
+		held = true;
+	}
+	spin_unlock_irq(&idxd->cmd_lock);
+	return held;
+}
+
+/*
+ * End a hold taken by idxd_cmd_hold(). A halt's recovery may have
+ * forgotten the hold meanwhile and let another command run, which then
+ * has an owner or a newer sequence number, and its state is left alone.
+ */
+void idxd_cmd_unhold(struct idxd_device *idxd, u32 seq)
+{
+	spin_lock_irq(&idxd->cmd_lock);
+	if (idxd->cmd_seq == seq && !idxd->cmd_done) {
+		__clear_bit(IDXD_FLAG_CMD_RUNNING, &idxd->flags);
+		wake_up(&idxd->cmd_waitq);
+	}
+	spin_unlock_irq(&idxd->cmd_lock);
+}
+
 int idxd_device_enable(struct idxd_device *idxd)
 {
 	struct device *dev = &idxd->pdev->dev;
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index c04a2855aa3f..9d88b0d82fee 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -794,6 +794,8 @@ int idxd_device_disable(struct idxd_device *idxd);
 int idxd_device_reset(struct idxd_device *idxd);
 void idxd_device_clear_state(struct idxd_device *idxd);
 void idxd_cmd_reset_state(struct idxd_device *idxd);
+bool idxd_cmd_hold(struct idxd_device *idxd, u32 *seq);
+void idxd_cmd_unhold(struct idxd_device *idxd, u32 seq);
 int idxd_device_config(struct idxd_device *idxd);
 int idxd_device_drain_pasid(struct idxd_device *idxd, int pasid);
 int idxd_device_load_config(struct idxd_device *idxd);
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index a037a6e76362..312b4670b3e8 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -1212,6 +1212,14 @@ int idxd_pci_probe_alloc(struct idxd_device *idxd, struct pci_dev *pdev,
 	}
 
 	if (!alloc_idxd) {
+		bool held;
+		u32 seq;
+
+		/*
+		 * Commands complete through the misc interrupt, which is
+		 * gone until it is requested again.
+		 */
+		held = idxd_cmd_hold(idxd, &seq);
 		/* Release interrupts in the IDXD device. */
 		idxd_cleanup_interrupts(idxd);
 
@@ -1219,6 +1227,8 @@ int idxd_pci_probe_alloc(struct idxd_device *idxd, struct pci_dev *pdev,
 		rc = idxd_setup_interrupts(idxd);
 		if (rc)
 			dev_warn(dev, "IDXD interrupts failed to setup\n");
+		if (held)
+			idxd_cmd_unhold(idxd, seq);
 	}
 
 	dev_info(&pdev->dev, "Intel(R) Accelerator Device (v%x)\n",
-- 
2.43.0

