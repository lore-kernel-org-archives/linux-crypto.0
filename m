Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422880;
	b=PnQU7vqQH9PfOx/Cxe8ZPb7d1vAxLW+Lb87YaEWGifmBd6pOy+AHya2nF8s32G6/XtNd
	 cCMB8CANfdvTJl3k4kVMzHWKQ4MLIyJBfjck++ruu+i6C5nbMJbh/2oVudbrSgzr1SnrQ
	 l97Sjc6Q1URrN91Ufwp5e6xPexdKu1+ms6LLYy3lcO7XFrI06bKmTeSE1/z3nT4SBBiIp
	 ExfREQqQBbA0I7DRplFbxH1/8b8z6sSomPCa2D1o/X1OuY+TuVIKZ6Of+v/4BSFhPh2LT
	 13wfdGkS5URV5LPYY2VljDOdUCpfurGsv2OK/4287fsL4SZuaUAmnhH7scdK9pK3ciQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422880;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dIby/7eEgxDKQXQ2aHnI10S7wEmYaOf/FtXew4LHqHg=;
	b=h/j+VLxMgNgJJNLilHirZcyqMPTWYthtiWSR/zEYMi2bfZg9jH0nGxdqOXzkGYBOQ38u
	 1znDWgP40+ioejXtbA5XivgtlIRw88zWsX18skfgjA3miSnsISFfBd3nYo4QbYy7rYGP5
	 +9WgX2nswinUdLEBJ1ZNieMRfxCqhwUdggMYLRWl5GIhYqQTDSnkA/KDCWpmdsgsJVh1u
	 6YHAEzzoO/pt/yUI1HOT2KvpBUUu58ubCfTxFppY+vyEf7dd1S7r7KWGEwxBWYDslittY
	 DLjnbl91vHUU5aU5g2S4TsXuL+DkOI5/UhLWn82tG+ZUeIftXvn+EKCVKn+w3pYzfBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Dw8TrsLf;
	arc=none smtp.remote-ip=198.175.65.12
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3EB609CED6;
	Mon, 19 Oct 2026 15:14:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A3EB609CED6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Dw8TrsLf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792422879; x=1823958879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4YYmbMdv7rYBDlF6wNMCrgGAGvSKvKeBSWDj6XsK8PQ=;
  b=Dw8TrsLf8vG9cG9e5Sq+X24Vp7HLTQMx1WbFUC6CK/nDHrixemkDJn0a
   bfelpUF8n7x239ch2XnCpEmZyeUa7J/WKWGqWkoKJrIa2j6mApxNZ4sOb
   GDFWmoBqpvknar6jI9WZBry0rlx7IE74H1pc9U4M4yjOt2DS6bqHGMsJ+
   I6uL9bgmEFGC7jL+WCThslVrBmVtozzcoL2LOR+/yjRD3jTRwI0bL5eyg
   PkejdLKEaGw55kvd8sVeyUxM7an6NN0CCcgXhmtLztPS/HBwpjVYOo9HK
   EYzoe6jw3edyWOPjIBqL1tG9yxvh7QbVzWAoKgdiIS16jtBqJnzBkpmLH
   Q==;
X-CSE-ConnectionGUID: zX2t05orTamcRp9GLqjE4Q==
X-CSE-MsgGUID: hYFBaDwpQzicDHdTyfTckQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="986924"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="986924"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:14:34 -0700
X-CSE-ConnectionGUID: Twz+9YbeRxGoGQDIFINOnQ==
X-CSE-MsgGUID: j8K7LmVvQROaVMgXqdtCWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2536981"
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
Subject: [PATCH 11/17] dmaengine: idxd: disable the device before its work queues are unregistered
Date: Mon, 19 Oct 2026 08:06:24 -0700
Message-ID: <20261019150630.4026341-12-daniel1.byrne@intel.com>
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

idxd_remove() unregisters the work queues, and with them their
software state, before idxd_shutdown() disables the device. The
sub-driver's remove leaves the device enabled when a device command has
timed out, and a late completion can clear that fail-fast state at any
time, so the disable in idxd_shutdown() may be the one that runs. It
then clears the software state of queues that no longer exist.

Disable the device right after the sub-driver is unbound, while the
queues still exist. Mark the device disabled once bus mastering is off,
so that nothing reached through the device reads it as enabled, and do
so before the reference taken for the cleanup is dropped: that
reference is the last one, and its release frees the device.

Assisted-by: Claude:claude-opus-5-5
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Daniel Byrne <daniel1.byrne@intel.com>
---
 drivers/dma/idxd/init.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index c4319ac27bfb..a037a6e76362 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -1296,6 +1296,13 @@ static void idxd_remove(struct pci_dev *pdev)
 	 * that driver while the queues still exist.
 	 */
 	device_release_driver(idxd_confdev(idxd));
+	/*
+	 * Disable the device while the queues still exist too. The
+	 * sub-driver's remove leaves the device enabled when a command has
+	 * timed out, a late completion can clear that state at any time,
+	 * and the disable below then clears the queues' software state.
+	 */
+	idxd_shutdown(pdev);
 	idxd_unregister_devices(idxd);
 	/*
 	 * When ->release() is called for the idxd->conf_dev, it frees all
@@ -1305,15 +1312,20 @@ static void idxd_remove(struct pci_dev *pdev)
 	 */
 	get_device(idxd_confdev(idxd));
 	device_unregister(idxd_confdev(idxd));
-	idxd_shutdown(pdev);
 	idxd_device_remove_debugfs(idxd);
 	perfmon_pmu_remove(idxd);
 	idxd_cleanup_interrupts(idxd);
 	if (device_pasid_enabled(idxd))
 		idxd_disable_system_pasid(idxd);
 	pci_iounmap(pdev, idxd->reg_base);
-	put_device(idxd_confdev(idxd));
 	pci_disable_device(pdev);
+	/*
+	 * Bus mastering is off, so nothing the device holds can complete.
+	 * The store comes before the reference taken above is dropped:
+	 * that reference is the last one, and its release frees the device.
+	 */
+	idxd->state = IDXD_DEV_DISABLED;
+	put_device(idxd_confdev(idxd));
 }
 
 static struct pci_driver idxd_pci_driver = {
-- 
2.43.0

