Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF8119343E
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2025 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012338; cv=none; b=ppSJOUHwjLx6So5TZT6sc/T3rhhxVosG6P8q5PB1fysNdDv3Cy+mYnhawcFIpiqF+hhKyA9qV+69p2KkUTJv41yM/t0Kotm+C8Rq2uSYdiRi8JPcxCr1JiNLqh7IkBOORgYFQVDmpUxYdIaUSZTrTp0VIfCSF8Kz0joL1u7Qgf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012338; c=relaxed/simple;
	bh=QIUlCdDDgNKC8e57Y3+feDkX5uLyeyfTJ0A0n34JkIU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GaKl5KbVHa2BjyfCA9wWaFzeVTkxEOdIVIFhDoV5KziFzbfALHENpTA6ekE8EHAjrCXdX6m6JKstZLoYCERw+IUNvGuJo+PQyMdbotbIyx/aYcZim+yUdSh+nrsmkh1gsJaXbF9/3b0oNrFjGp8rTdD7euanNDTAtthwgTh70YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pDOqq240; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pDOqq240"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2166e907b5eso87265705ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2025 13:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738012336; x=1738617136; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K6hZefyXL2l96pWmeGJw77FS+9rwDaTak9GYI9pCtzA=;
        b=pDOqq240FmwonOMwNSeDQryDJWs1PZN5mD2ExqzAAtzpE4kTj8NPyComxyDeV+Y24j
         8maE47AQBLv5/gh8a+147Aeqx5MTkeNgCChNtRmq4txrg4Hlda0fE7smZTBgXNJkGQ4O
         ZZ7+Qv0RcYDjMDowTBRa427T9jyxItwVbKxGuMAieTG0gitNvJZBrdnXC1gDMB+j+gsU
         h0yQ/bepPdx9kTrs1B2qP8Adsm3mOX9LDGblsMbvO77UouhQqtdC/E/542pnLZA58hZM
         ymXbRHEtc/KZ7K1rmXeUuWnE0MaoSE5Gx+zzb4c0RoYAYDQNoIbCelnRcIb8GzZmiwUk
         64fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738012336; x=1738617136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K6hZefyXL2l96pWmeGJw77FS+9rwDaTak9GYI9pCtzA=;
        b=pUQBSDlWSKm7qlT2qoUW7fEB62CK7WKqv07bHaRCVQeUslX3tfylsvv1bKx+uElpyQ
         0LSx+O4UMMlLCLOVTsXBHkZQPv3stkN6G3GYNZt7DyPaj+dP+7vcCDbOEvf8m56i1Ffv
         LiZ0mbHkwLeJJgCXnbLd5pD2oZETQL1LOB92sEHJ3ousSX5laJY1FkCM6Viv7k3wAiz9
         CZizc/WmF9Ool6jOq2aXDI6UK+GDFDbEICNcJv5ucEZHu2Lt88LNeHUz1eXJJrCQw6o8
         mEMRva+nxjqsu4r+ncpxeHq44sLzofnL5thNkxA/EVK6McT7Uyt74iMhWZlVNzaHxzlx
         qREg==
X-Forwarded-Encrypted: i=1; AJvYcCVxMQOI97JswrnD6xYgh2h21lQ8ypvnwbmQ9NAiUhc37Hg8Ustppfc9lVH/eIRMW6iuZBbNAYtMeEOXZwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyB8CPijeIe3li+WOAGjJ3TzczxNfF6jnEzDEVpXeSn1EStdkpq
	XG7UXh7gBj2/AzNjatGydsAtWj5ZHoZh7O85PHEKuLwZvUFwZnUG5CvE6BnBPWzb2bOs3USx3UW
	MpQ==
X-Google-Smtp-Source: AGHT+IEwgayOURYSvjY7e6XLYoI71UjcKramt48qbeELOlKyudPYpVmcvakyD5Op74xYsySjMiHHABxL/+s=
X-Received: from pfbcb5.prod.google.com ([2002:a05:6a00:4305:b0:725:936f:c305])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8d1:b0:725:f153:22d5
 with SMTP id d2e1a72fcca58-72dafb9e674mr61995080b3a.18.1738012335920; Mon, 27
 Jan 2025 13:12:15 -0800 (PST)
Date: Mon, 27 Jan 2025 13:12:14 -0800
In-Reply-To: <e23a94f0-c35f-4d50-b348-4cd64b5ebb67@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1737505394.git.ashish.kalra@amd.com> <0b74c3fce90ea464621c0be1dbf681bf46f1aadd.1737505394.git.ashish.kalra@amd.com>
 <c310e42d-d8a8-4ca0-f308-e5bb4e978002@amd.com> <5df43bd9-e154-4227-9202-bd72b794fdfb@amd.com>
 <5af2cc74-c56d-4bcf-870e-afa98d6456b3@amd.com> <Z5QyybbSk4NeroyZ@google.com> <e23a94f0-c35f-4d50-b348-4cd64b5ebb67@amd.com>
Message-ID: <Z5f2rnMyBAjK88dP@google.com>
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

On Mon, Jan 27, 2025, Ashish Kalra wrote:
> Hello Sean,
> 
> On 1/24/2025 6:39 PM, Sean Christopherson wrote:
> > On Fri, Jan 24, 2025, Ashish Kalra wrote:
> >> With discussions with the AMD IOMMU team, here is the AMD IOMMU
> >> initialization flow:
> > 
> > ..
> > 
> >> IOMMU SNP check
> >>   Core IOMMU subsystem init is done during iommu_subsys_init() via
> >>   subsys_initcall.  This function does change the DMA mode depending on
> >>   kernel config.  Hence, SNP check should be done after subsys_initcall.
> >>   That's why its done currently during IOMMU PCI init (IOMMU_PCI_INIT stage).
> >>   And for that reason snp_rmptable_init() is currently invoked via
> >>   device_initcall().
> >>  
> >> The summary is that we cannot move snp_rmptable_init() to subsys_initcall as
> >> core IOMMU subsystem gets initialized via subsys_initcall.
> > 
> > Just explicitly invoke RMP initialization during IOMMU SNP setup.  Pretending
> > there's no connection when snp_rmptable_init() checks amd_iommu_snp_en and has
> > a comment saying it needs to come after IOMMU SNP setup is ridiculous.
> > 
> 
> Thanks for the suggestion and the patch, i have tested it works for all cases
> and scenarios. I will post the next version of the patch-set based on this
> patch.

One thing I didn't account for: if IOMMU initialization fails and iommu_snp_enable()
is never reached, CC_ATTR_HOST_SEV_SNP will be left set.

I don't see any great options.  Something like the below might work?  And maybe
keep a device_initcall() in arch/x86/virt/svm/sev.c that sanity checks that SNP
really is fully enabled?  Dunno, hopefully someone has a better idea.

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 0e0a531042ac..6d62ee8e0055 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3295,6 +3295,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
                ret = state_next();
        }
 
+       if (ret && !amd_iommu_snp_en)
+               cc_platform_clear(CC_ATTR_HOST_SEV_SNP);
+
        return ret;
 }
