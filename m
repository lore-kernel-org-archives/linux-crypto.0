Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422876;
	b=K0hIi3Ha2u0zZhwdlDFJCm9QEA9NpflzbpN9ERe/5GDkiWrn2GkCg4wB4uNVAhAUlb0I
	 M1aN1LO/EnFGUGspOcJccxKEUaT+k0zAIaD0hYUd5Hz1YohG8RGfXC4OHd5Z364XCjjJZ
	 tTTqZwdXGSmSEJAYtNOy3sayHagjHynmyFjZr0PXElQta51e5GofpHYjvlEKsTX9wUbvK
	 iJ9mPEz7zpuSKAmmRCKkYBiYwmxPiPw26a8YhQKwkXhbQPb/vUH++ieP7C2nrrzUt/7ek
	 mjp5OrMrQgys2R3vm3xgjkerSuLFA/uKW0zSvsycThzrFd1wF/oZbmrwEaKmRDstG2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422876;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=K3c6U7vZET0ArCQqZ6t3FK0dhz2IPxufvWBSMOwbpIM=;
	b=ieowm5M+YH2wcDs7SaM40Of9qHHIMi+wPdZ7vaJLpeMq1lznjbQoTczaovRC7f5Wr2+O
	 /IsZxK4eypw0n/9Trl60WySv5i/Mg+B4yiHnLvBOzW4eQiuzXrteIY6dQrYqcMMStViMM
	 ALm2kp0cgw1YvAxNZYXPhLplsKVAMlcdHTEdeM2l2xmdH0NdKVBbYK53F5wqCLvBsogCF
	 w39av6zkVVT4jqtEozfxcxYZNBjrln0HHw11HUFgdXl+Xg649XEa4VYPpnyyJ7IVFXq+W
	 8uajpQeMrC86K6foYK7hqTk6uGy+T3HstfgnSeF8izq6msnsdD/wRcqmkxUEZuUKYFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZP6SlRId;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE09609CEC6;
	Mon, 19 Oct 2026 15:14:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCE09609CEC6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZP6SlRId
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422876; x=1823958876;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fBdQxqP0ia731zZUJ9lS/7B/cmQuMcRcrOzsQArbmhA=;
  b=ZP6SlRIdTDQW3snjBGztPQfuBENAezR788WbEraZxv7L+hfnY0MNSCDS
   gyeg85r+cB6Pn/5E7CJsiC0YnHEo7aAasZo7nOyf6o5gJ1SUQkHd7W7oH
   ceUzYFOACZ0DRk6Cf2CSOmA5kcOwTWXJap3+GdvNWSsJ0plKGL4l7DEWR
   JrIWbw/a08QjEQ/4Pt56VitZSrBmyD9kCunGnhJ9g4GU+2Qxfdm9Gv6G6
   2acJRSgh8Ti7ebBWRp7uV3bEvapZMCtFi1PQXPtVdkCAPuVWgXN5XgED+
   ILP1PYa5mifhjI6E3pFBi97pLqSjYjL1JZiCyjn5qefAx7wdx/XXG7DEH
   w==;
X-CSE-ConnectionGUID: jV2VEcjAQmmo77QQ2R3Jhw==
X-CSE-MsgGUID: ZJ8++HgITdC523Aj/GVeeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986906"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986906"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:34 -0700
X-CSE-ConnectionGUID: IW4Pg3uWRke1ETqnKEma+A==
X-CSE-MsgGUID: wvzt0xZURDC/fcWi/g05Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536958"
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
Subject: [PATCH 05/17] dmaengine: idxd: unbind the device driver before its work queues go away
Date: Mon, 19 Oct 2026 08:06:18 -0700
Message-ID: <20261019150630.4026341-6-daniel1.byrne@intel.com>
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

idxd_remove() unregisters the work queue conf_devs first, and each
queue is freed by its conf_dev release. Only then does it unregister
the device's own conf_dev, whose driver remove, idxd_device_drv_remove(),
walks idxd->wqs and reads wq->state to disable the queues still
active. On a PCI unbind of an enabled device that is a read of freed
memory for every queue, which KASAN reports as a slab-use-after-free.
The usual administrative flow disables the device first and never hits
it.

Release the device driver before the queues are unregistered, so its
remove sees them while they exist. The conf_dev is unregistered where it
was, now without a driver bound, and the reference taken there only
keeps the memory alive for the remaining cleanup.

That remove also releases the driver of every bound queue, not only of
the queues that read enabled. A halt's clear_state leaves a bound queue
disabled, and skipping it would unregister the dma_device while that
queue's channel is still registered, so the queue's own unbind later
freed the channel and the device a second time.

The devices on the dsa bus stay open to a sysfs bind until they are
unregistered, and the bus does not take the parent's lock, so the PCI
device lock that the remove holds does not exclude a bind. The early
unbind leaves the device reading enabled while its queues' drivers are
released, and disabled before it is unregistered, which a queue probe
and the device probe accept respectively. The remove therefore marks
the device as going away before it unbinds the driver, and the device
probe and the queue enable, which every queue driver's probe calls,
refuse a device so marked, as the driver core did once the devices
were unregistered.

Fixes: 745e92a6d816 ("dmaengine: idxd: idxd: move remove() bits for idxd 'struct device' to device.c")
Assisted-by: Claude:claude-fable-5-1
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/device.c | 26 +++++++++++++++++++++++---
 drivers/dma/idxd/idxd.h   |  1 +
 drivers/dma/idxd/init.c   | 28 +++++++++++++++++++++++-----
 3 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 131138483b87..a83b5da88f8c 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -1415,6 +1415,16 @@ int idxd_drv_enable_wq(struct idxd_wq *wq)
 
 	lockdep_assert_held(&wq->wq_lock);
 
+	/*
+	 * The device remove releases the queues' drivers before it disables
+	 * the device, so the device still reads enabled meanwhile.
+	 */
+	if (test_bit(IDXD_FLAG_REMOVING, &idxd->flags)) {
+		idxd->cmd_status = IDXD_SCMD_DEV_NOT_ENABLED;
+		rc = -ENODEV;
+		goto err;
+	}
+
 	if (idxd->state != IDXD_DEV_ENABLED) {
 		idxd->cmd_status = IDXD_SCMD_DEV_NOT_ENABLED;
 		goto err;
@@ -1563,6 +1573,9 @@ int idxd_device_drv_probe(struct idxd_dev *idxd_dev)
 	struct idxd_device *idxd = idxd_dev_to_idxd(idxd_dev);
 	int rc = 0;
 
+	if (test_bit(IDXD_FLAG_REMOVING, &idxd->flags))
+		return -ENODEV;
+
 	/*
 	 * Device should be in disabled state for the idxd_drv to load. If it's in
 	 * enabled state, then the device was altered outside of driver's control.
@@ -1623,9 +1636,16 @@ void idxd_device_drv_remove(struct idxd_dev *idxd_dev)
 		struct idxd_wq *wq = idxd->wqs[i];
 		struct device *wq_dev = wq_confdev(wq);
 
-		if (wq->state == IDXD_WQ_DISABLED)
-			continue;
-		dev_warn(dev, "Active wq %d on disable %s.\n", i, dev_name(wq_dev));
+		/*
+		 * A halt's clear_state leaves a bound queue DISABLED while
+		 * its driver still holds the queue's channel and resources.
+		 * Release every bound driver, not only the enabled queues',
+		 * before the dma_device below frees their channels. For a
+		 * queue without a driver the release is a no-op.
+		 */
+		if (wq->state != IDXD_WQ_DISABLED)
+			dev_warn(dev, "Active wq %d on disable %s.\n", i,
+				 dev_name(wq_dev));
 		device_release_driver(wq_dev);
 	}
 
diff --git a/drivers/dma/idxd/idxd.h b/drivers/dma/idxd/idxd.h
index ce78b9a7c641..2343f0367d62 100644
--- a/drivers/dma/idxd/idxd.h
+++ b/drivers/dma/idxd/idxd.h
@@ -269,6 +269,7 @@ enum idxd_device_flag {
 	IDXD_FLAG_CMD_RUNNING,
 	IDXD_FLAG_PASID_ENABLED,
 	IDXD_FLAG_USER_PASID_ENABLED,
+	IDXD_FLAG_REMOVING,	/* PCI remove under way, refuse binds */
 };
 
 struct idxd_dma_dev {
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 4b827a329756..4443d23fde5a 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -1267,13 +1267,31 @@ static void idxd_remove(struct pci_dev *pdev)
 {
 	struct idxd_device *idxd = pci_get_drvdata(pdev);
 
+	/*
+	 * The devices on the dsa bus stay registered, and so open to a
+	 * sysfs bind, until the unregisters below. A bind during the
+	 * removal would re-probe the device or enable one of its queues
+	 * while they are torn down, and the PCI device lock held here does
+	 * not exclude it, so the probes test this first. The command path
+	 * changes IDXD_FLAG_CMD_RUNNING in the same word with non-atomic
+	 * bit operations under cmd_lock, which would lose a bit set
+	 * concurrently, so the flag is set under that lock too.
+	 */
+	spin_lock_irq(&idxd->cmd_lock);
+	set_bit(IDXD_FLAG_REMOVING, &idxd->flags);
+	spin_unlock_irq(&idxd->cmd_lock);
+	/*
+	 * The idxd sub-driver's remove walks idxd->wqs to disable the
+	 * active queues, and each wq is freed with its conf_dev. Unbind
+	 * that driver while the queues still exist.
+	 */
+	device_release_driver(idxd_confdev(idxd));
 	idxd_unregister_devices(idxd);
 	/*
-	 * When ->release() is called for the idxd->conf_dev, it frees all the memory related
-	 * to the idxd context. The driver still needs those bits in order to do the rest of
-	 * the cleanup. However, we do need to unbound the idxd sub-driver. So take a ref
-	 * on the device here to hold off the freeing while allowing the idxd sub-driver
-	 * to unbind.
+	 * When ->release() is called for the idxd->conf_dev, it frees all
+	 * the memory related to the idxd context. The driver still needs
+	 * those bits in order to do the rest of the cleanup, so take a ref
+	 * on the device here to hold off the freeing until that is done.
 	 */
 	get_device(idxd_confdev(idxd));
 	device_unregister(idxd_confdev(idxd));
-- 
2.43.0

