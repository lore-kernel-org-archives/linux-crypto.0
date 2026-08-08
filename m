Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92644369D5B
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 06:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786172017; cv=none; b=lT35WICVEqxTm2Macjqz6UwavEvhIM9bxJyFKPGshvh/8UlJwMf28FMqs+kAH9gVbbuMBjyfiUwDI8eMc+Og5n8sJ3kSuhHzPDSbuewtngVV8uF0OrkeWIi7TugHlzuqhy0Lbl1wVn4tRQo35JKSAQTIexEPtU47A+3NfuA/gg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786172017; c=relaxed/simple;
	bh=Yg5CbE960A1w7vxea9z+UV1mUCRNaxpr/Wq63BHbYNI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WNnqX+K9eQH+rTx5VUml1qivNqY5D5WwQhNCFaoL/cNZVS51MvrX09sRCMB08y+i8MR634ed+zkUeCBGeiYCV27hvsvajpR1F8oU/kMQJJKvpEcDEChrSNuBYOlEprg/n7XV8lYkpdHj81Jbq0PZH8mGeoQ52WN6+UirzzOLQ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJsf9DCe; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJsf9DCe"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2caea3f742bso5197525ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 07 Aug 2026 23:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786172016; x=1786776816; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q8+qdfUNsFYx07WswywD1ui9gvhu1XyZ5pnsDk2yr+k=;
        b=nJsf9DCeHKoimLQJ5p5bFdDH5Lq4oxyD6fvJDAT0z0usPuFgF5YGJpTa3HjxV0XF6q
         RFIHQzHsIFmfcShd1zbJInDxWhh4ir2vnkD0S+ZV95iRP4QuFbBVQ6tFkR0Trwf4BqTo
         5Tw8OFpDfL+k+onai+pniP14AOdJyA3R8bE5lBl0/2OGJ8ueLT/c1SxQjaVnXe+vaErN
         vJxTO0IkjZw1eoduZvuycohPigeBBjDHm3jKI+dnWBl9pjInK9Pkny2wZtGrb4c9VI40
         e2LGPff8KO4OhTqrZF1k9lxNX3Wmj+CXTTkxXB7J8UouZaNFF0bjH0jcDOHMx+ZAUkkN
         +ZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786172016; x=1786776816;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q8+qdfUNsFYx07WswywD1ui9gvhu1XyZ5pnsDk2yr+k=;
        b=Mt7h+CN6PSyGggetSx0xHjnarEpLt0KmezYvSDHeAeFn0uaLRTbYuHQphbAFKxtJzO
         gYR4/hBoS79EHvWSKJGm9dJYOCwn7Al34QGE0O6j3sCccVwNxAxs5FMqaiBX/0Q6hAFZ
         izEBZfIL3i+H7o3C+QqNB8nPnqQ/CSWfuoQ7UxY86d/q9gRGshRhwz0WPFZYXdlEz5g9
         Y7ZY0gtvAnIfCuxif4u5HF8j8VPZC+54Hu2zH/BExOJPAkdSeRKb+LfQlF4mDcAuTv3J
         qLwg+jXDtq40f9aLEmSbW1vepH7z2oZCVykZ6jCds2pU05i7LbTgH5a2NeaOSby61QFM
         R25w==
X-Forwarded-Encrypted: i=1; AHgh+Rp+ZpiBzqMvb8rD/V7SQMzY7hZMRz58Ip1JOm17o5AZnIwTQRhDa79opg7CBi4248Yj4myhvof2K6E/13I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSEW2c6+rVqYqZbmglo4rWatckzeYkZFM8KJR4UjlSKSS63Uq2
	WMorK51U3aue8+I/tbnWIvKD4XZ2zAXhm6B+cZuOfP/ha2qt1wwTi5e5
X-Gm-Gg: AR+sD137os7ydY5NHL6W+YxoP60POJLFndnGXyxi0TixUbclaoRZpmrwUpqercNZRf2
	14TPcK1cWzkL315f3ynFFf6sbALhnDdTbVOj0dH+xlwGqny3UMyzzrF9GSuyW0A3oR29qW6VMKa
	9SOMeGKTywypkF4cQnxVaCw8uKs+Hjv/KQfYuej1Yh13cWAr1uux7f213rfuNf0XHpZsXyXPyTl
	HoPanlnfpf1FVdha8Z5Th4UHTKjvTUimMwt57mIfdxsrQymKKTFf4N253GoF23IT2bWC4oMbxCG
	W3PbhAa3gRLr7QgWUj4Qk5lZQpMJpIivnp7kjd3ETf+h53SAb+VASEQmOBANFtt7EbdCTrY8SGm
	2kvJoHt+ncJKNQo7zjGWw2l2v2Rvw8dTFgjHuB1XwuzBXmc0tFYGP3QD3ricVcbwY1sAozmVCn2
	to1A7j7FWIq0yvj6YsRBf45F7BbJb2fJpPc2OtW1SwGYy6Ic6NJ1hu5g==
X-Received: by 2002:a17:90b:4b84:b0:38e:8021:2ea9 with SMTP id 98e67ed59e1d1-3903c5f6482mr25708102a91.19.1786172015866;
        Fri, 07 Aug 2026 23:53:35 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3925ff6658bsm5116933a91.14.2026.08.07.23.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 23:53:35 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Hadar Gat <hadar.gat@arm.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] hwrng: cctrng: fix usage_count leak when autosuspend_delay is negative
Date: Sat,  8 Aug 2026 14:41:45 +0800
Message-ID: <20260808064145.2615010-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cc_trng_pm_init() calls pm_runtime_use_autosuspend(), but
cc_trng_pm_fini() does not call the matching
pm_runtime_dont_use_autosuspend() before disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() call before disabling
runtime PM.

This issue was found by manual code inspection.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/char/hw_random/cctrng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index a5be9258037f..bed4b9876d09 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -126,6 +126,7 @@ static void cc_trng_pm_fini(struct cctrng_drvdata *drvdata)
 {
 	struct device *dev = &(drvdata->pdev->dev);
 
+	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_disable(dev);
 }
 
-- 
2.43.0

