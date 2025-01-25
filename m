Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F73F1E50B
	for <linux-crypto@vger.kernel.org>; Sat, 25 Jan 2025 00:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737765581; cv=none; b=JLiAX0mPr7o5RC4poc/XWgI/y/jTkxLYW48TwFxSS1zAbxf/lrWedR3g8vejLhh8wpGOiKoStrpQnC8457i+msMtGpMGYDw1eNsAqGmAtXiyEwcDFn/CQimOauWkA4xf9PzxJDKl6YQyB1bHWi8VzF+pIpu/Qwr9A5NLqETXrk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737765581; c=relaxed/simple;
	bh=9w7I2x80ypxrKh1VEAFS2n6vYGIv+SvFiL4q0LdcGB8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eTGiZW4o6781avejAnQRZXyAcG/WK3l5A/wZtKmLNlWB8lP0zRcNU+tkAf5ZMsN4RjG22WVlWdrYqcyrhqpcK99GT9BJxrU1Sa0qqAI4IxC9eAcqrZ/s8GbNfj/gfnGME00dPvhnOHnMof/BC5kslEl+PIdCvBgoKpTCM8YmqBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X1kiO5+c; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X1kiO5+c"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-216405eea1fso53183515ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 24 Jan 2025 16:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737765578; x=1738370378; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+X65piYQS/WCBt65hh+j7JofkNo9XQN9knqyTTubMeE=;
        b=X1kiO5+ciRbpydlcc6Un5CQ0AqkiCpZ727tFsSsOShoUCHPXz+DXN1yvntDRJsid1h
         JwWgj9R2bo2RgpuHn2ulaY08XRwz2j8L+b+PvjaLz5O5CHT8+4G5jkaHUcngHr+ph0qo
         cBDkIsgblrkTLTPVIQMMJG7HqSL4gyG/RhmSbf9ao7ZhPOnC8//DeiF9+Xv6c4YPddoY
         M2ol8S83giwQ25DlMB4RAcy/OnIJEW8SnzBZoTFZeKuQ+2UdGtQZJjDM6Yf0uMW6OOvE
         BNS0ez7QzRkgBqzYE0dV05+HJqmsUKRzgeFQwbusf4sN69Mdb5NeXlNtUcUrW/0l9Wj9
         CKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737765578; x=1738370378;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+X65piYQS/WCBt65hh+j7JofkNo9XQN9knqyTTubMeE=;
        b=o8p7UEfVAPwxGS5xCTIg/ivesWeus16uD9UtYa9HswvBWHbltiywLVnunayj9+GkSE
         usCd5KZWmDK9E2PrSyD5qiBuVIg7ZcVFJ+RsK1O/HZvmL/veb8k0MMotxiMgwhXQotCy
         ovzHMal1iTTEZ9Wt/+OxGm6Qmc94iGJ9ECCstgp+izyKOQfm2S+jo6PEl9pRvgt0pBMM
         7TPqb8nYRxqkMiE2ThFcjiNOs2bU8mhFfjgrmT3dM1tzf/rP8X7sl9udaM2mChR3/oZi
         Cr1HCofBg+vw+ZGr0nGiMJxqJAkxdPxInxYmzs9Nutkaovhfx143rRnNZACV7+ZHfiGv
         Vweg==
X-Forwarded-Encrypted: i=1; AJvYcCWzFUOkYnnLmgvioaBpi/8rkELcVTfvaZCvNTS90oJXO8Jo8zQIQmejKTrB3Qt/fVfhGfEEoiixh33XfRY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1orcSdCh6yCY3B1ywHlzQJ4pl1pnWCl0BF8ku/XqfU8iDGkGc
	ybMRDBm9Yet0vnJQBV91kAXzukAQ6YrhnIoC38uy9KYP/Chhsa1ujV6b4B6uFIjJJBphLBl5ttO
	wVw==
X-Google-Smtp-Source: AGHT+IH8zqVnP4Psc/uYL4UhGgHMW+W6e9Nz3rYjPKiv7YzdXD9pSuwl/RQiWph/kP5Qf47fPPDng4ucmM4=
X-Received: from pfwo3.prod.google.com ([2002:a05:6a00:1bc3:b0:725:df7a:f4e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d8a:b0:1ea:f941:8da0
 with SMTP id adf61e73a8af0-1eb214e52damr45529351637.24.1737765578583; Fri, 24
 Jan 2025 16:39:38 -0800 (PST)
Date: Fri, 24 Jan 2025 16:39:37 -0800
In-Reply-To: <5af2cc74-c56d-4bcf-870e-afa98d6456b3@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1737505394.git.ashish.kalra@amd.com> <0b74c3fce90ea464621c0be1dbf681bf46f1aadd.1737505394.git.ashish.kalra@amd.com>
 <c310e42d-d8a8-4ca0-f308-e5bb4e978002@amd.com> <5df43bd9-e154-4227-9202-bd72b794fdfb@amd.com>
 <5af2cc74-c56d-4bcf-870e-afa98d6456b3@amd.com>
Message-ID: <Z5QyybbSk4NeroyZ@google.com>
Subject: Re: [PATCH 1/4] iommu/amd: Check SNP support before enabling IOMMU
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	joro@8bytes.org, suravee.suthikulpanit@amd.com, will@kernel.org, 
	robin.murphy@arm.com, michael.roth@amd.com, dionnaglaze@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 24, 2025, Ashish Kalra wrote:
> With discussions with the AMD IOMMU team, here is the AMD IOMMU
> initialization flow:

..

> IOMMU SNP check
>   Core IOMMU subsystem init is done during iommu_subsys_init() via
>   subsys_initcall.  This function does change the DMA mode depending on
>   kernel config.  Hence, SNP check should be done after subsys_initcall.
>   That's why its done currently during IOMMU PCI init (IOMMU_PCI_INIT stage).
>   And for that reason snp_rmptable_init() is currently invoked via
>   device_initcall().
>  
> The summary is that we cannot move snp_rmptable_init() to subsys_initcall as
> core IOMMU subsystem gets initialized via subsys_initcall.

Just explicitly invoke RMP initialization during IOMMU SNP setup.  Pretending
there's no connection when snp_rmptable_init() checks amd_iommu_snp_en and has
a comment saying it needs to come after IOMMU SNP setup is ridiculous.

Compile tested only.

---
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 24 Jan 2025 16:25:58 -0800
Subject: [PATCH] x86/sev: iommu/amd: Explicitly init SNP's RMP table during
 IOMMU SNP setup

Explicitly initialize the RMP table during IOMMU SNP setup, as there is a
hard dependency on the IOMMU being configured first, and dancing around
the dependency with initcall shenanigans and a comment is all kinds of
stupid.

The RMP is blatantly not a device; initializing it via a device_initcall()
is confusing and "works" only because of dumb luck: due to kernel build
order, when the the PSP driver is built-in, its effective device_initcall()
just so happens to be invoked after snp_rmptable_init().

That all falls apart if the order is changed in any way.  E.g. if KVM
is built-in and attempts to access the RMP during its device_initcall(),
chaos ensues.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/sev.h |  1 +
 arch/x86/virt/svm/sev.c    | 25 ++++++++-----------------
 drivers/iommu/amd/init.c   |  7 ++++++-
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 91f08af31078..30da0fc15923 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -503,6 +503,7 @@ static inline void snp_kexec_begin(void) { }
 
 #ifdef CONFIG_KVM_AMD_SEV
 bool snp_probe_rmptable_info(void);
+int __init snp_rmptable_init(void);
 int snp_lookup_rmpentry(u64 pfn, bool *assigned, int *level);
 void snp_dump_hva_rmpentry(unsigned long address);
 int psmash(u64 pfn);
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 9a6a943d8e41..d932aa21340b 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -189,19 +189,19 @@ void __init snp_fixup_e820_tables(void)
  * described in the SNP_INIT_EX firmware command description in the SNP
  * firmware ABI spec.
  */
-static int __init snp_rmptable_init(void)
+int __init snp_rmptable_init(void)
 {
 	u64 max_rmp_pfn, calc_rmp_sz, rmptable_size, rmp_end, val;
 	void *rmptable_start;
 
-	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
-		return 0;
+	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
+		return -ENOSYS;
 
-	if (!amd_iommu_snp_en)
-		goto nosnp;
+	if (WARN_ON_ONCE(!amd_iommu_snp_en))
+		return -ENOSYS;
 
 	if (!probed_rmp_size)
-		goto nosnp;
+		return -ENOSYS;
 
 	rmp_end = probed_rmp_base + probed_rmp_size - 1;
 
@@ -218,13 +218,13 @@ static int __init snp_rmptable_init(void)
 	if (calc_rmp_sz > probed_rmp_size) {
 		pr_err("Memory reserved for the RMP table does not cover full system RAM (expected 0x%llx got 0x%llx)\n",
 		       calc_rmp_sz, probed_rmp_size);
-		goto nosnp;
+		return -ENOSYS;
 	}
 
 	rmptable_start = memremap(probed_rmp_base, probed_rmp_size, MEMREMAP_WB);
 	if (!rmptable_start) {
 		pr_err("Failed to map RMP table\n");
-		goto nosnp;
+		return -ENOMEM;
 	}
 
 	/*
@@ -261,17 +261,8 @@ static int __init snp_rmptable_init(void)
 	crash_kexec_post_notifiers = true;
 
 	return 0;
-
-nosnp:
-	cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
-	return -ENOSYS;
 }
 
-/*
- * This must be called after the IOMMU has been initialized.
- */
-device_initcall(snp_rmptable_init);
-
 static struct rmpentry *get_rmpentry(u64 pfn)
 {
 	if (WARN_ON_ONCE(pfn > rmptable_max_pfn))
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 0e0a531042ac..d00530156a72 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3171,7 +3171,7 @@ static bool __init detect_ivrs(void)
 	return true;
 }
 
-static void iommu_snp_enable(void)
+static __init void iommu_snp_enable(void)
 {
 #ifdef CONFIG_KVM_AMD_SEV
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
@@ -3196,6 +3196,11 @@ static void iommu_snp_enable(void)
 		goto disable_snp;
 	}
 
+	if (snp_rmptable_init()) {
+		pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
+		goto disable_snp;
+	}
+
 	pr_info("IOMMU SNP support enabled.\n");
 	return;
 

base-commit: ac80076177131f6e3291737c851a6fe32cc03fd3
-- 

