Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAB61CAA7B
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 07:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752477225; cv=none; b=q8lzFmtNcJ+RR2zA0FCMK2Hzpk8kh2VIDxmq0ICuc5rlF7eLYHjo0vh1Hm12jPpNeEjlr6ydDXtiIwBXWek7I3vIZhnQJKAKAfbY/6rhVTLq3m+SYa7UgA+MN5dBTnQZWzdgKhI/iqccWpamccbAtc9OBI0gf6EPri84gH00uLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752477225; c=relaxed/simple;
	bh=b2iavg5BjoHFDxmik5usK732jYbi3lIc5rc0vpuk0eE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lrHRICHgkeJA53B2PaUWlC0AmnPXgP3WuZYg+c2W8vJxJxC5FIlp6ZBBmdCKCgQ9jH2i+gfFuoBQ7V4wjwNeiYo5CDsbmhFI2UHoMOvZiZrHpUPazsL3t9QLQ0ikt2jolzORExlCedsdZkdeRlk9jh3ehZTbOKNh0dVr+FnUrR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dwyYrCjT; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dwyYrCjT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752477224; x=1784013224;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b2iavg5BjoHFDxmik5usK732jYbi3lIc5rc0vpuk0eE=;
  b=dwyYrCjTxftbGn5s+kD88nbtnx204g0ojQ0pGKebsWyHdAicsnpKSfEx
   jHn8SavlB42Gh27chTnROrYtfeJ87svAp7OtQQ6jD8/aZ/QQra3Te/1lx
   iyv9N7yXO9NUK+ekcow2BuZ8uS+jpWmRMgU2KiImX8TsWIyfw48qlGRPq
   v5YxIuHQZN1TiyTyTSeDzyM7Oqifm0yH9FHI98xeppfc5EAbBAKDproYC
   OtoM9r9ZN+p+0V3zYD3DibQQvsbj1SU872zkBGUu3JLoR3MrthKrkU/BB
   kqcAtFGZrHQUTKIBLvV6/MxFAqZt+jrmo74Tu7XONR+URizoap8MLm7bc
   w==;
X-CSE-ConnectionGUID: zdbywFUERXGqB50uR1tw3w==
X-CSE-MsgGUID: WSj6fLMYQEOelnzUaPYODQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54519525"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="54519525"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 00:13:43 -0700
X-CSE-ConnectionGUID: K65nuLlVS2KIvukjagjEXA==
X-CSE-MsgGUID: ByQuH0sKRjSQdYGtFukWbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="156283931"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by orviesa006.jf.intel.com with ESMTP; 14 Jul 2025 00:13:42 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Shwethax Shetty <shwethax.shetty@intel.com>,
	Srikanth Thokala <srikanth.thokala@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - add missing INIT_LIST_HEAD in probe()
Date: Mon, 14 Jul 2025 08:13:13 +0100
Message-ID: <20250714071333.6417-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Shwethax Shetty <shwethax.shetty@intel.com>

If a list is not properly initialized before use, traversing it can lead
to undefined behavior, including NULL pointer dereferences. In this
case, the `adf_ctl_stop_devices()` function attempts to iterate over a
list to retrieve `accel_dev`, but if the list hasn't been initialized,
it may result in a kernel panic.

This issue was observed during testing, with the following stack trace:

    BUG: kernel NULL pointer dereference, address: 0000000000000214
    RIP: 0010:adf_ctl_stop_devices+0x65/0x240 [intel_qat]
    4xxx 0000:86:00.0: pci_iomap_range() calls ioremap_driver_hardened()
    ? __die+0x24/0x70
    ? page_fault_oops+0x82/0x160
    ? do_user_addr_fault+0x65/0x690
    ? exc_page_fault+0x78/0x170
    4xxx 0000:86:00.0: pci_iomap_range() calls ioremap_driver_hardened()
    ? asm_exc_page_fault+0x26/0x30
    ? adf_ctl_stop_devices+0x65/0x240 [intel_qat]
    4xxx 0000:86:00.0: pci_iomap_range() calls ioremap_driver_hardened()
    ? adf_ctl_stop_devices+0x65/0x240 [intel_qat]
    adf_ctl_ioctl+0x6a9/0x790 [intel_qat]

To prevent this, add the missing `INIT_LIST_HEAD()` in `adf_probe()` to
ensure the list is correctly initialized before use.

Fixes: 7afa232e76ce ("crypto: qat - Intel(R) QAT DH895xcc accelerator")
Fixes: dd0f368398ea ("crypto: qat - Add qat dh895xcc VF driver")
Fixes: a6dabee6c8ba ("crypto: qat - add support for c62x accel type")
Fixes: 3771df3cff75 ("crypto: qat - add support for c62xvf accel type")
Fixes: 890c55f4dc0e ("crypto: qat - add support for c3xxx accel type")
Fixes: 8b206f2d666f ("crypto: qat - add support for c3xxxvf accel type")
Fixes: 8c8268166e83 ("crypto: qat - add qat_4xxx driver")
Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
Signed-off-by: Shwethax Shetty <shwethax.shetty@intel.com>
Reviewed-by: Srikanth Thokala <srikanth.thokala@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c      | 1 +
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c       | 1 +
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c      | 1 +
 drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c    | 1 +
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c       | 1 +
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c     | 1 +
 drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c   | 1 +
 drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c | 1 +
 8 files changed, 8 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
index cfa00daeb4fb..5b88828931f9 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
@@ -55,6 +55,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
+	INIT_LIST_HEAD(&accel_dev->list);
 	accel_pci_dev = &accel_dev->accel_pci_dev;
 	accel_pci_dev->pci_dev = pdev;
 
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index c9be5dcddb27..80326a4f932a 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -57,6 +57,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
+	INIT_LIST_HEAD(&accel_dev->list);
 	accel_pci_dev = &accel_dev->accel_pci_dev;
 	accel_pci_dev->pci_dev = pdev;
 
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
index bceb5dd8b148..597a6a2b9b46 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
@@ -84,6 +84,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
+	INIT_LIST_HEAD(&accel_dev->list);
 	accel_pci_dev = &accel_dev->accel_pci_dev;
 	accel_pci_dev->pci_dev = pdev;
 
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
index c622793e94a8..acb73fb94687 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
@@ -98,6 +98,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pf = adf_devmgr_pci_to_accel_dev(pdev->physfn);
 	accel_pci_dev = &accel_dev->accel_pci_dev;
 	accel_pci_dev->pci_dev = pdev;
+	INIT_LIST_HEAD(&accel_dev->list);
 
 	/* Add accel device to accel table */
 	if (adf_devmgr_add_dev(accel_dev, pf)) {
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
index 23ccb72b6ea2..6fe5854b46f9 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -86,6 +86,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
 	accel_pci_dev = &accel_dev->accel_pci_dev;
 	accel_pci_dev->pci_dev = pdev;
+	INIT_LIST_HEAD(&accel_dev->list);
 
 	/* Add accel device to accel table.
 	 * This should be called before adf_cleanup_accel is called */
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
index 4840d44bbd5b..905bc7e0aa67 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
@@ -98,6 +98,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pf = adf_devmgr_pci_to_accel_dev(pdev->physfn);
 	accel_pci_dev = &accel_dev->accel_pci_dev;
 	accel_pci_dev->pci_dev = pdev;
+	INIT_LIST_HEAD(&accel_dev->list);
 
 	/* Add accel device to accel table */
 	if (adf_devmgr_add_dev(accel_dev, pf)) {
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
index b59e0cc49e52..2c4385c42dc9 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
@@ -86,6 +86,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
 	accel_pci_dev = &accel_dev->accel_pci_dev;
 	accel_pci_dev->pci_dev = pdev;
+	INIT_LIST_HEAD(&accel_dev->list);
 
 	/* Add accel device to accel table.
 	 * This should be called before adf_cleanup_accel is called */
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
index 7cd528ee31e7..4cfdc0088ba5 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
@@ -98,6 +98,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pf = adf_devmgr_pci_to_accel_dev(pdev->physfn);
 	accel_pci_dev = &accel_dev->accel_pci_dev;
 	accel_pci_dev->pci_dev = pdev;
+	INIT_LIST_HEAD(&accel_dev->list);
 
 	/* Add accel device to accel table */
 	if (adf_devmgr_add_dev(accel_dev, pf)) {

base-commit: 60a2ff0c7e1bc0615558a4f4c65f031bcd00200d
-- 
2.50.0

