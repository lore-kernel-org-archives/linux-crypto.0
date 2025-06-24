Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5A6248869;
	Tue, 24 Jun 2025 06:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750748072; cv=none; b=gCG40byzmhTyfBev4RZvoTzs0lxNPX9XEmRd0JMrVaEFM7sf/vOcfesFGNrHtcuFU+1BbtO9iKaDXKlbPc8AIeIFKYyu5/KmZhkE+W0vSe5BCGW/lYVDf9Cp+5HViCXvorlsDUrF71AZVKDBQcLnqOcRyi8ZqQO5iRfRlL6Z3ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750748072; c=relaxed/simple;
	bh=MqPVVn60QZsD3GUpLYhu+hDEi72E8HlooHIEzEBl2es=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qOm6iWJoT2iUsOwjmGVm1XTX740t07srrlkZWrcuoElOo6uI5N922T9mkoIzgRiV46xg18xZ/+/y49eEQc/yl6TogFUgRwBSHJAOQVVQINgBe1mivV6D/ihah1aytM5A0mTo1Ava1XR9Hobtw3N99cdOuPhkex1XKdF3SEO9JzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F9XCxgFX; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F9XCxgFX"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-22c33677183so700865ad.2;
        Mon, 23 Jun 2025 23:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750748070; x=1751352870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rq36PiS01h5y6219zqAsB82yoW0N7OYfIxqCT84G0SE=;
        b=F9XCxgFX1HvZIiDOEslRFHN1Vm+2zqBY1Anlt2G/q/eI7cVz7fXLJ84nZxhA7ErGDF
         6cflE+ihlnPbKYt3yu51CJxM6Eq8fbkOo6KhLA/M+EHepCX/ihjWQiaelxvSjBM3dz7B
         53P+k7F8chnHxcbodY9BMTBbI7Lw5CNkmwpvzKE7UwXb1brYpAGZEpxPtNfLPiFsmMTf
         vFbnJKaMgYItKlICJVqvM04X+f9NRBgRfQO4/O16H2XdOciQaWvxa4e1jcldPa8ocQAQ
         VqMHCpI6/ZuO6uClQWpsmUYimZfu2rcPQl7fRFiBSMYvJlju80FCUeElZpGPlQacwwRq
         G8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750748070; x=1751352870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rq36PiS01h5y6219zqAsB82yoW0N7OYfIxqCT84G0SE=;
        b=cNg/2WU+Cn0tTwHRsZPcUJdkKs/1vI0Nw6kkvpuf4zDooDQLofHfWY+PoYUe2xuXmE
         TcVehlNCGi7p3642eNAZA0beXoWVU4CDdGekOMifEez1T0nnxW4z3T1EeVWoxD47vs4D
         f7C2YvO21vk68koPE8f5tkYw/fvC6uDs004tjYJ0JQTGMGgvWC3sdK+d/0MiQQjG1Xsp
         bRi+sruIEMnb+XzrtfKZsMa7w7kEy6T5Xx+MXb1ed4BusOBucLr1I8BaSIN/y5eVIPye
         VYTJusyByCfh1wTtlku0lG9XEsiEJviJaxGLgZAkWG4f5LYmO4hVhg1wd5x8PSdn9oUV
         Aqzw==
X-Forwarded-Encrypted: i=1; AJvYcCVcBL01TfuebM1go3bmq4k0qfFIXr8hgh/KprjN5eNCimUly2f8Zf8SmEpcyS0GIWnt9R/aXbo3lN1bsKU=@vger.kernel.org, AJvYcCXuSvPfE3JfjcShi2obzRoioS+FVVc3q8VEbzQ8HWxf4FptazczClqJLcdaAmVnhSfvN4/by1RgkjlLSu2x@vger.kernel.org
X-Gm-Message-State: AOJu0YwlGnIshVhQG7DEYis3e3b+yIhjc7d04yULPa0sxt2PIPJrM7oD
	CFbpPc2Nn+qpHkc4vNJ5QkT4ziJcYtqG6alqBDXAPo5QROkYserBaDP1
X-Gm-Gg: ASbGnctrcqyTSkR1p5LygckgaEQJT3fV2Rpjoh7qPeaT00dbzWCrbxQaJ1R+8B6aVpA
	guH9dq5nNpKKhLFhRZvVIB68rybs4pfitc0M+NuU2e9tc8ftTdc5GM0EwB9SACmY/zaY06jxiSe
	ZSKSVOgEvUrGV3sFD/sRWuwp47Kht5GQlnKoI8s3Q8rptahelbf5tza6wr/88jiGHTIKi141y9r
	tUOAdjuQGtmswV0AfWn4PEJ2Nrh6RI5eyqQsLMm7AGYyRVUKykfMEK8u8GGFulmVhj8kZ1Rk2FH
	wvcFyqbqxnqznsPiA/LMbSGN8l+C/+kNinFolTggXa9IZ5lulmI60PXiXjdR6msBMIb3+NIP73e
	J8EbP9eUU
X-Google-Smtp-Source: AGHT+IH5pyZm7P7J2EfWIsHZRYckdeS+Nzz4NZU6SqKekD1+3E8CxcQmOTtSAh1E7juugZ+IquzevA==
X-Received: by 2002:a17:903:1b50:b0:235:ef79:2997 with SMTP id d9443c01a7336-237d9ab5f95mr200445445ad.47.1750748070208;
        Mon, 23 Jun 2025 23:54:30 -0700 (PDT)
Received: from SH-PF2ZPNXA.Hygon.cn ([112.64.138.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8393893sm100144205ad.25.2025.06.23.23.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 23:54:29 -0700 (PDT)
From: Mengbiao Xiong <xisme1998@gmail.com>
To: thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: john.allen@amd.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mengbiao Xiong <xisme1998@gmail.com>
Subject: [PATCH v2] crypto: ccp - Fix crash when rebind ccp device for ccp.ko
Date: Tue, 24 Jun 2025 14:54:18 +0800
Message-Id: <20250624065418.1743-1-xisme1998@gmail.com>
X-Mailer: git-send-email 2.34.0.windows.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When CONFIG_CRYPTO_DEV_CCP_DEBUGFS is enabled, rebinding
the ccp device causes the following crash:

$ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/unbind
$ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/bind

[  204.976930] BUG: kernel NULL pointer dereference, address: 0000000000000098
[  204.978026] #PF: supervisor write access in kernel mode
[  204.979126] #PF: error_code(0x0002) - not-present page
[  204.980226] PGD 0 P4D 0
[  204.981317] Oops: Oops: 0002 [#1] SMP NOPTI
...
[  204.997852] Call Trace:
[  204.999074]  <TASK>
[  205.000297]  start_creating+0x9f/0x1c0
[  205.001533]  debugfs_create_dir+0x1f/0x170
[  205.002769]  ? srso_return_thunk+0x5/0x5f
[  205.004000]  ccp5_debugfs_setup+0x87/0x170 [ccp]
[  205.005241]  ccp5_init+0x8b2/0x960 [ccp]
[  205.006469]  ccp_dev_init+0xd4/0x150 [ccp]
[  205.007709]  sp_init+0x5f/0x80 [ccp]
[  205.008942]  sp_pci_probe+0x283/0x2e0 [ccp]
[  205.010165]  ? srso_return_thunk+0x5/0x5f
[  205.011376]  local_pci_probe+0x4f/0xb0
[  205.012584]  pci_device_probe+0xdb/0x230
[  205.013810]  really_probe+0xed/0x380
[  205.015024]  __driver_probe_device+0x7e/0x160
[  205.016240]  device_driver_attach+0x2f/0x60
[  205.017457]  bind_store+0x7c/0xb0
[  205.018663]  drv_attr_store+0x28/0x40
[  205.019868]  sysfs_kf_write+0x5f/0x70
[  205.021065]  kernfs_fop_write_iter+0x145/0x1d0
[  205.022267]  vfs_write+0x308/0x440
[  205.023453]  ksys_write+0x6d/0xe0
[  205.024616]  __x64_sys_write+0x1e/0x30
[  205.025778]  x64_sys_call+0x16ba/0x2150
[  205.026942]  do_syscall_64+0x56/0x1e0
[  205.028108]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  205.029276] RIP: 0033:0x7fbc36f10104
[  205.030420] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 8d 05 e1 08 2e 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3 66 90 41 54 55 49 89 d4 53 48 89 f5

This patch sets ccp_debugfs_dir to NULL after destroying it in
ccp5_debugfs_destroy, allowing the directory dentry to be
recreated when rebinding the ccp device.

Tested on AMD Ryzen 7 1700X.

Fixes: 3cdbe346ed3f ("crypto: ccp - Add debugfs entries for CCP information")
Signed-off-by: Mengbiao Xiong <xisme1998@gmail.com>
---
 drivers/crypto/ccp/ccp-debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
index a1055554b..dc26bc22c 100644
--- a/drivers/crypto/ccp/ccp-debugfs.c
+++ b/drivers/crypto/ccp/ccp-debugfs.c
@@ -319,5 +319,8 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 
 void ccp5_debugfs_destroy(void)
 {
+	mutex_lock(&ccp_debugfs_lock);
 	debugfs_remove_recursive(ccp_debugfs_dir);
+	ccp_debugfs_dir = NULL;
+	mutex_unlock(&ccp_debugfs_lock);
 }
-- 
2.17.1

