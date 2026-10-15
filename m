Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE51377EC3
	for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 03:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792035534; cv=none; b=sG3RKh4GKDemWXtr28fgRf5wVM+JXt4O2ePsdGmGSh6XhsVyLqM2bD6ogulXNZaogfFTL4JA7yiIkUNQE/2rtFabmQvVTmS9fretPqMLB1qDKpZrmT47GaYawXV+RRbkGksJyXmNKW34E6QBoPNjNnEsB4GXhCO+3e+NwSXVq4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792035534; c=relaxed/simple;
	bh=I7eufOpZZ2W3J7jKQo6amXrTAoF1j9MR2sWXX0CdAGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mkV1qpqXiUaF4Hd6eWQ0LB3Rat4O7Xa3ALxvSxtjrkktatmG/isuHBSfwVoHPO9Fn8Dj8MoK2PSf14k0yn3lCK0Dxvtyaa2IusO9Jr4TJTqXowQqn9qgiU39xrDFD9pQF7FCjZFu0I7LVJRrtDdeoNvV2A/aZCpClk/5jy65Pec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P8k5v4bp; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P8k5v4bp"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-16ad92569b5so4614755c88.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 20:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792035532; x=1792640332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=STbYkXfQYBHP4vFrbP+VlU1TS6sSthQE0QYCE49OIug=;
        b=P8k5v4bpRQx+LPncerPNj0adfO/TPkNe1z0xYsKqotA1nx3fUDx+aoEzw00505Algt
         g0LPo6Lo5gGiSMQzqg2T7NyxMFKUeU82lqSbOSSMh4bDKLd7FC9EHJp0PLOkvLXwUxw1
         fDNAUH8bc7jXYIwbw71IwMp5MqSTlfAmXi02yDqRbR56y847TOZETMEFu9gKyHj8MUNo
         9tRSczIf9mGB3Id2hTygPj23upSK0HoT7LIGgl+hRWj0XqptzRZ5/fQ1psdYiRaSzSek
         Bh9FGc5SmIto1IsK0mdzCAok/kKurO4VfXapykSvYWb2kd8eFyaF/DtygaOp8l2letou
         TExA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792035532; x=1792640332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=STbYkXfQYBHP4vFrbP+VlU1TS6sSthQE0QYCE49OIug=;
        b=ZpPJsyXvBkPck5WWVvSL/NZwTO5qsASQ9SJgbUXmTPUnEIQNskUXoaBiebzxdXvPpG
         pUGolgqrZR4XWkelpD/cylxowNuFYsfjj7hs5zQj8v36+bECN57FyqPA9ZMRvBVWjFhv
         NuXXrfYsX3IxNHD9Izs3YRPoXhuPgWHf0vVaZFZHD2/tKRL32HelCCCvwfyeEjAZx3yw
         o+hflfhwXf3co15HOFMTAjLYJuLVTMVnm+4W9badWCCql/5lpwiBIygi3LPvaRY67+C7
         zaFFKtLRJ56XOIA6ukKUDT+VCLKAnvcV4gTJqMS/Th+DcTqj1ki5hjQaMGQqKvQGDvHT
         8V9A==
X-Forwarded-Encrypted: i=1; AKwUvBwPjRW/YB7hiUw3p7Od6TWymLL49PzW51qht74+rIqBQXByWkmTNj8twEWaMKqNZn773pfK0+oSH8b01Hw=@vger.kernel.org
X-Gm-Message-State: AFq9FYL7TCNbx/M/nIoXbuA1IWhuQx1i5r2KSaX4wuLcGKOBr62GtDAG
	cF6YAHqTU41RRoonsmbIhqeYcOJW1yUpkxvOg0rLW1voGQeidaiJGQFG
X-Gm-Gg: AYBFou3KKBmp7E/0DP9HAnP8VozEKzgE6ZWDQi7vGkNtNYf2f5NqQCKDPwfICz+ixuv
	zfiJ/0Mu3IuAZOx+dncRlbCBij2hHDjWYvi++xuQvb87LwTgCNtB7LWKOyzX+U0h7nhHK8+uUw3
	yusxRsGSdVU2Mkq2hjiFHrgwe+2e2QfKdoEix/AbXkxeG/18J/Xz6XgjuVUDdSbtwmAa0qevD88
	AVOqSCBPO380PFa1vGFJFGqHiiBwZRiuGyuQAxkCvEJDni7inMDcohL0NbNQVyfEYOTEcGLc6/M
	WgIpVv1ohR+Zs+O6HDUm/NGQx3SyAMcO8AbqitX0Kbe70jbjpn0hgycLsScOXT+pUAb+uipaZOd
	falT8gFnsZYaAGYDV0DXyYQdjQrCFoTjfXGFOpKZn17zi6w9zhZz+iHYk2/dyEWFkU6W0mwwajG
	sODdNnhbDvkAjEgDZ4qO44XvxcfNpr5mKzFyxit9TQ6VHcQKQJMjdVKnhC4QA5Mg85X37hsK/Gz
	BifzE6QFSL9a5o=
X-Received: by 2002:a05:701b:2309:b0:151:f0c5:7a09 with SMTP id a92af1059eb24-16a5f01db04mr27843452c88.43.1792035531877;
        Wed, 14 Oct 2026 20:38:51 -0700 (PDT)
Received: from kernel ([45.251.35.75])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cab27d5sm63854661eec.17.2026.10.14.20.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 20:38:51 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: ebiggers@kernel.org,
	ardb@kernel.org
Cc: Jason@zx2c4.com,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH] lib/crypto: md5: correct header inclusions
Date: Thu, 15 Oct 2026 09:08:43 +0530
Message-ID: <20261015033843.6056-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The file uses 'rol32()' inline function (inside the MD5STEP macro) but
does not explicitly include `<linux/bitops.h>`, currently relying on
indirect includes.

Also, `<linux/unaligned.h>` is included but never used, as the code
relies on direct pointer casts.

Add the missing `<linux/bitops.h>` and remove the unused
`<linux/unaligned.h>`.

Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 lib/crypto/md5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/md5.c b/lib/crypto/md5.c
index 3d2b017a0525..a838bb90103f 100644
--- a/lib/crypto/md5.c
+++ b/lib/crypto/md5.c
@@ -13,10 +13,10 @@
 #include <crypto/hmac.h>
 #include <crypto/md5.h>
 #include <linux/export.h>
+#include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/unaligned.h>
 #include <linux/wordpart.h>
 
 static const struct md5_block_state md5_iv = {
-- 
2.53.0

