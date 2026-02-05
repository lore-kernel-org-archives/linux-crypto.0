Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [144.217.248.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE192C859;
	Thu,  5 Feb 2026 10:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.217.248.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770287488; cv=none; b=A7hU5oGz7ePXrWeuz00Lcr+xosNL7fDo+wxNOEY1SfdLF3y7rJ6BjY87S//1Kb5siqLM9VgmX4D2nDAaWB4OYwSqHuSaa7loILxWB9QZz9AU31DCBPQwwK5AyGHjfDsYHaSbJqrEAlhY0TFhrUUVmvjn1+1VMkV/HoCzdU4nVSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770287488; c=relaxed/simple;
	bh=Y51/vkwZf26q2e+XhHxvTOLyHFwURHRyVgaZFIOUt/w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TU24XdCZYqLtBLiyqGZGi8ZOVj/9ws3sLedofY9erBzSCP5zz+8KBph7RcTTXuP5qu7Oz04FGMfo4Udw0piJ+7KGvSGUOmRursCLVLeyKCFEdiiNT9gpCNJ25ZkbLiiz5MlNmS+fIew982KPCyCDEoro6bTSVyf52y7/cHWPuWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=MZjB8W2p; arc=none smtp.client-ip=144.217.248.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="MZjB8W2p"
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay1.mymailcheap.com (Postfix) with ESMTPS id 17EC23E86D;
	Thu,  5 Feb 2026 10:31:27 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 6017640129;
	Thu,  5 Feb 2026 10:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1770287485; bh=Y51/vkwZf26q2e+XhHxvTOLyHFwURHRyVgaZFIOUt/w=;
	h=From:To:Cc:Subject:Date:From;
	b=MZjB8W2p5LreHuhMwqSr1HmIqtLKG/Vm9L9gJBHcTsmjVJZSRZ1Sypy3uchjp1Z+6
	 pITTVXTvz7/56ihyL3JpWIzhhqhdx3YDy8qvc2N+YHP8H7RwA/FaPOGRKLdaRHi+1W
	 gpaF2f0p7jPwGnlsaNs/Ckq8cVgzl4kd4A27YdVQ=
Received: from avenger-XINGYAO-Series (unknown [114.244.128.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 69C8E42B54;
	Thu,  5 Feb 2026 10:31:12 +0000 (UTC)
From: WangYuli <wangyuli@aosc.io>
To: mario.limonciello@amd.com,
	thomas.lendacky@amd.com,
	john.allen@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	mika.westerberg@linux.intel.com,
	andriy.shevchenko@linux.intel.com,
	jsd@semihalf.com,
	andi.shyti@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	bp@alien8.de,
	ashish.kalra@amd.com,
	wangyuli@aosc.io,
	markhas@chromium.org,
	jarkko.nikula@linux.intel.com,
	wsa@kernel.org,
	WangYuli <wangyl5933@chinaunicom.cn>,
	stable@vger.kernel.org
Subject: [PATCH] i2c: designware: Enable PSP semaphore for AMDI0010 and fix probe deferral
Date: Thu,  5 Feb 2026 18:30:47 +0800
Message-ID: <20260205103047.19127-1-wangyuli@aosc.io>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6017640129
X-Spamd-Result: default: False [1.40 / 10.00];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	ARC_NA(0.00)[];
	RCVD_COUNT_ONE(0.00)[1];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	SURBL_MULTI_FAIL(0.00)[chinaunicom.cn:server fail];
	LOCAL_OUTBOUND(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	URIBL_BLOCKED(0.00)[chinaunicom.cn:email,aosc.io:mid,aosc.io:from_smtp,aosc.io:from_mime,mail20.mymailcheap.com:rdns,mail20.mymailcheap.com:helo];
	RCVD_TLS_ALL(0.00)[]
X-Rspamd-Action: no action
X-Rspamd-Server: nf2.mymailcheap.com

From: WangYuli <wangyl5933@chinaunicom.cn>

AMD Strix Point platforms use the AMDI0010 ACPI HID for their I2C
controllers, but this entry was missing the ARBITRATION_SEMAPHORE flag
that enables PSP-based bus arbitration.

Without proper arbitration, when both the x86 host and AMD PSP
(Platform Security Processor) attempt to access the shared I2C bus
simultaneously, the DesignWare controller loses arbitration and reports:

  i2c_designware AMDI0010:01: i2c_dw_handle_tx_abort: lost arbitration

This causes communication failures with I2C devices such as touchpads
(e.g., BLTP7853 HID-over-I2C).

Add the ARBITRATION_SEMAPHORE flag to the AMDI0010 entry to enable PSP
mailbox-based I2C bus arbitration, consistent with how AMDI0019 was
handled for AMD Cezanne platforms.

However, simply enabling this flag exposes a latent bug introduced by
commit 440da737cf8d ("i2c: designware: Use PCI PSP driver for
communication"): the driver unconditionally returns -EPROBE_DEFER when
psp_check_platform_access_status() fails, causing an infinite probe
deferral loop on platforms that lack PSP platform access support.

The problem is that psp_check_platform_access_status() returned -ENODEV
for all failure cases, but there are two distinct scenarios:

  1. PSP is still initializing (psp pointer exists but platform_access_data
     is not yet ready, while vdata->platform_access indicates support) -
     this is a transient condition that warrants probe deferral.

  2. The platform genuinely lacks PSP platform access support (either no
     psp pointer, or vdata->platform_access is not set) - this is a
     permanent condition where probe deferral would loop indefinitely.

Fix this by updating psp_check_platform_access_status() to return:

  - -EPROBE_DEFER: when PSP exists with platform_access capability but
    platform_access_data is not yet initialized (transient)
  - -ENODEV: when the platform lacks PSP platform access support (permanent)

Then update the I2C driver to pass through the actual return code from
psp_check_platform_access_status() instead of forcing -EPROBE_DEFER,
allowing the driver to fail gracefully on unsupported platforms.

Tested on MECHREVO XINGYAO 14 with AMD Ryzen AI 9 H 365.

Fixes: 440da737cf8d ("i2c: designware: Use PCI PSP driver for communication")
Cc: stable@vger.kernel.org
Signed-off-by: WangYuli <wangyl5933@chinaunicom.cn>
---
 drivers/crypto/ccp/platform-access.c        |  7 ++++++-
 drivers/i2c/busses/i2c-designware-amdpsp.c  | 11 +++++++++--
 drivers/i2c/busses/i2c-designware-platdrv.c |  2 +-
 include/linux/psp-platform-access.h         |  5 +++--
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/platform-access.c b/drivers/crypto/ccp/platform-access.c
index 1b8ed3389733..3f20cf194cb6 100644
--- a/drivers/crypto/ccp/platform-access.c
+++ b/drivers/crypto/ccp/platform-access.c
@@ -46,7 +46,12 @@ int psp_check_platform_access_status(void)
 {
 	struct psp_device *psp = psp_get_master_device();
 
-	if (!psp || !psp->platform_access_data)
+	/* PSP driver not loaded yet, caller should defer */
+	if ((!psp) || (!psp->platform_access_data && psp->vdata->platform_access))
+		return -EPROBE_DEFER;
+
+	/* PSP loaded but platform_access not supported by hardware */
+	if (!psp->platform_access_data && !psp->vdata->platform_access)
 		return -ENODEV;
 
 	return 0;
diff --git a/drivers/i2c/busses/i2c-designware-amdpsp.c b/drivers/i2c/busses/i2c-designware-amdpsp.c
index 404571ad61a8..341232767177 100644
--- a/drivers/i2c/busses/i2c-designware-amdpsp.c
+++ b/drivers/i2c/busses/i2c-designware-amdpsp.c
@@ -269,6 +269,7 @@ static const struct i2c_lock_operations i2c_dw_psp_lock_ops = {
 int i2c_dw_amdpsp_probe_lock_support(struct dw_i2c_dev *dev)
 {
 	struct pci_dev *rdev;
+	int ret;
 
 	if (!IS_REACHABLE(CONFIG_CRYPTO_DEV_CCP_DD))
 		return -ENODEV;
@@ -291,8 +292,14 @@ int i2c_dw_amdpsp_probe_lock_support(struct dw_i2c_dev *dev)
 		_psp_send_i2c_req = psp_send_i2c_req_doorbell;
 	pci_dev_put(rdev);
 
-	if (psp_check_platform_access_status())
-		return -EPROBE_DEFER;
+	/*
+	 * Check if PSP platform access is available.
+	 * Returns 0 on success, -EPROBE_DEFER if PSP driver not loaded,
+	 * -ENODEV if platform_access is not supported by hardware.
+	 */
+	ret = psp_check_platform_access_status();
+	if (ret)
+		return ret;
 
 	psp_i2c_dev = dev->dev;
 
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 7be99656a67d..63b1c06ee111 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -345,7 +345,7 @@ static const struct acpi_device_id dw_i2c_acpi_match[] = {
 	{ "80860F41", ACCESS_NO_IRQ_SUSPEND },
 	{ "808622C1", ACCESS_NO_IRQ_SUSPEND },
 	{ "AMD0010", ACCESS_INTR_MASK },
-	{ "AMDI0010", ACCESS_INTR_MASK },
+	{ "AMDI0010", ACCESS_INTR_MASK | ARBITRATION_SEMAPHORE },
 	{ "AMDI0019", ACCESS_INTR_MASK | ARBITRATION_SEMAPHORE },
 	{ "AMDI0510", 0 },
 	{ "APMC0D0F", 0 },
diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
index 540abf7de048..84dbdbeb61d6 100644
--- a/include/linux/psp-platform-access.h
+++ b/include/linux/psp-platform-access.h
@@ -64,8 +64,9 @@ int psp_ring_platform_doorbell(int msg, u32 *result);
  * if platform features has initialized.
  *
  * Returns:
- * 0          platform features is ready
- * -%ENODEV   platform features is not ready or present
+ *  0:            platform features is ready
+ *  -%ENODEV:     platform_access is not supported by hardware
+ *  -%EPROBE_DEFER: PSP driver not ready or platform features not yet initialized
  */
 int psp_check_platform_access_status(void);
 
-- 
2.51.0

