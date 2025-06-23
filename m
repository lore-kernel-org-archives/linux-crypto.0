Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D43320F;
	Mon, 23 Jun 2025 06:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750659960; cv=none; b=IteB5ia8Hh60gIZu60B4x26+V/PwhazUiQmKZOPuS/cxpu/U2XnPGznrK1B35MHZPm+rqvtOYmODOBr54IadLKK711tj5cVrwjlDwDqDHnjWhR5sm9S/NDrYSuJsIOCALaZIObIkhY9HkdBjlNlUX37WsvoZiD0lNcilc07jqo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750659960; c=relaxed/simple;
	bh=wnQh+LvS0D5AuTJKnrX6mkVbFgz5xswffy0gLl05/aI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KMIqAbMLvVC9xjoDLDhe9xTT02hj+f3a75teroUyV/a6TpUsAAtQG7wETDXFf0Vl5u5eZ68B6vMLf6LmA2c6Nrt3fSBSFUzrEA0FbLWE/PijNTk35mv+EfMdvHBZKW0uBqq5kjHrg7nvQw2gYT2QdOSSKnQXuG80jJlxDteDb0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cS/doHih; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cS/doHih"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-31329098ae8so3160211a91.1;
        Sun, 22 Jun 2025 23:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750659958; x=1751264758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EHqOPOVW85zbXW/CJtlwKUat7gKYYJU/x1bAcm4jWqM=;
        b=cS/doHihQH7IJdR4fM1l2KLy27GUQwEYHXJmR8ui05JVpT54MqvDwYOTpZJT5u2zPd
         WtBzsxw7jPjmUbCGezm3vITgIkFH3NLBPU4OkPMmjBhFnarJ2cN3+0vcsdG7rijDvdK9
         mAVNhhaCqKTFEPgip+y1B4dGGmmyrNZXtIMOHHfnMQYqgSvLSJFEq6aV23mmNzvXVOQw
         BWzly6D4VyjReq7/oi7x/dAXolsZWdP+0AVZWCWSj/AQKqSfYp56jpxS5Drb0SNyH5eC
         miYDcUQqFd8QzelFaepqqTweYu3iatodtxNNIkxOVjH9/yczyhSVbAIv+Q9YQ+mJ3Xme
         P4LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750659958; x=1751264758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EHqOPOVW85zbXW/CJtlwKUat7gKYYJU/x1bAcm4jWqM=;
        b=Bswp8GHzW0KWGkFOYanwydDb4z0a0mhfIH+/Jl6+Hnf3i7OVDaF0/GA8dYXO5d/lQc
         rO7+gKmL/cnjB3QnnB9fjxInnLe25PRq5H6ABnsnR7KH/oopDYOmDeMAEmMRELuYEeGX
         4w59dcJuMfGSA/83kOcABZFASsFgWff+ZjzSGoxr5KPRMujeHMy9yL+hzaTJ/wp3iWIw
         dvZrnXpYzm5HMXztDgHo9/w0/pRM6g8Sd0W4h0MIHAWKBJ5w15xxO/rMGRCey3NQb2y3
         xKf+Webbs9oB+GYocICLrIEWhg5w7efIVJ2K4FMD1ZC+UTa/LNq224gwccZR9isR4pWr
         SoBg==
X-Forwarded-Encrypted: i=1; AJvYcCUcnltRMQc53pj6t2A5PCHwYtHneiY1qDJCV7LEIzEZT8jo7fr4yhgkAwPJL/yDLsHq28UcE4eJvcZaY/gM@vger.kernel.org, AJvYcCWGhhmupIpeEvBL+g0agCEKp1ZiWImyTdO9pv3LrsNUUlAwKzhBRjgTTUH22DEnWrfsvN37O8KC2bZGkq0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvFenUI5Crge1VcQ0YdNTtaL+Erpe1N8MOWZV8YpV9sneb1dSc
	odhB6euZTAyMGX0/z7Cis/HmmiYoieok/Fe7Xv3x9e2cI0Voq0IkuqEp
X-Gm-Gg: ASbGnctXGduOWOdpJ7IZ2Jd/XaFakqedTCTfkgRcnvqYDapNMTD+xrAttRtv1Ohn7Y5
	fxeKLwJ8e37UrMj4POkzzCyJCy8Hem7HqfSl+4V1uysp2tBLDO44h0MqMDn21ZVhCm9bURkkXkt
	TXoDJMpsOX6UReA+lftd02GUkej7JMOBGAay4NfsHcZUovcnbkHdPolFR9V6SItd1vgzUr6QWTT
	FtdJ4n+rpopJTPG0Kw6JJtBu2CHoQPWOYSw0abhLvD7KEVV+CiWvdm2bakfbQOMBS9ein6QbJR4
	+91bLfcohxZ7AH7viiNAqcjMai9KNyYxMYITCG6OKFfnRY0+w7MocBT6MvuCvHnFWFl/G6enOdk
	haeM5y0HE
X-Google-Smtp-Source: AGHT+IHSgKXTq0iSHlLOQrnIyMowewm3aLTzVp7gwuHuapk1aBOGUTrh4Uw6zwO4rMa50WVqGokxtQ==
X-Received: by 2002:a17:90b:3942:b0:30a:3e8e:ea30 with SMTP id 98e67ed59e1d1-3159f5014d3mr16752382a91.11.1750659957776;
        Sun, 22 Jun 2025 23:25:57 -0700 (PDT)
Received: from SH-PF2ZPNXA.Hygon.cn ([112.64.138.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3159de7c703sm8056035a91.0.2025.06.22.23.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jun 2025 23:25:57 -0700 (PDT)
From: Mengbiao Xiong <xisme1998@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: thomas.lendacky@amd.com,
	john.allen@amd.com,
	gary.hook@amd.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mengbiao Xiong <xisme1998@gmail.com>
Subject: [PATCH] crypto: ccp - Fix crash when rebind ccp device for ccp.ko
Date: Mon, 23 Jun 2025 14:25:47 +0800
Message-Id: <20250623062547.1256-1-xisme1998@gmail.com>
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
 drivers/crypto/ccp/ccp-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
index a1055554b..0d432f3c4 100644
--- a/drivers/crypto/ccp/ccp-debugfs.c
+++ b/drivers/crypto/ccp/ccp-debugfs.c
@@ -320,4 +320,5 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 void ccp5_debugfs_destroy(void)
 {
 	debugfs_remove_recursive(ccp_debugfs_dir);
+	ccp_debugfs_dir = NULL;
 }
-- 
2.17.1

