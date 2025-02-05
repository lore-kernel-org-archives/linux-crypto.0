Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB7C18A6B2
	for <linux-crypto@vger.kernel.org>; Wed,  5 Feb 2025 15:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768632; cv=none; b=pOMqcs3WU4mGY67fBSXRTyoM+iEg2aVqs6TH18QZT8qfhG40LiQttnNdjtmW7YM0xMsgw/m8V+PJBKls5gkyzb/Aix0U2o7Hc61CfnYrV/i08+J3139oZV5E0ls/0y+WjhlMjdqaff9LRgMdUbZlaZ7h+6hSf5oTYl/HIT1c9Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768632; c=relaxed/simple;
	bh=9bQWjyfhOKP94dxGty6MaGQ0+wHvs6zeGJ3FOjx7a4k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ODYM34lAcugUs1/sxd1dxuybyUigdUM67aioBFRC4I+iuEWZ6y//dG9pm7rLd7PpOueP7IS/SLdUmszr8oZOLJvK2vRd6PsMMbLNZELzCsWuYoXbDOD/vill08gxogoS/kx0QnHPfYNDNfd9mEtuQQIEAv7rTJixs4r09WwveDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FxT/aBid; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FxT/aBid"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21f02a2410aso47700655ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 05 Feb 2025 07:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738768630; x=1739373430; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t0aN/8guITRu30BL0HaWPnLZfgsAxjHGJklJU83lkGw=;
        b=FxT/aBidAdGTctIB0iwWVFS7TcDTnBXgFLr4U6nkRvKhGQUpvn9jVrxj0Qoz2ATbh0
         gjFHoOoXndZlcA+JRrcCSN57JPFYIyNqPbjOw+giduZm5uzKCgwI7FXQXIBUmabJsJti
         4KW4gMr8ZUzLQUb/QAyK3/daobtQ/BY1sqU8pJGxWcy3DgE2mWq+9vdOng27qk5peKJy
         ZlIW5n1UhyaL6m7CM9672V/TBEJyDKPO8yUH6PBbVCREmpnkwbVdw+GErhy72g+0a/bd
         LDtb7p3Kh663WdRrAAQzasDfveQntReB5BP/m4V/5YwQcfkssCr7ysRtcg1duZiVrXga
         uY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738768630; x=1739373430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t0aN/8guITRu30BL0HaWPnLZfgsAxjHGJklJU83lkGw=;
        b=QVIX+rhPEKjCqaNxCvsaZQSFWWDkUxLRZrPPc27CLIHF2l1ydUWt1Wp06iIJibvlo5
         pG5SNvdAf2QLt8NCwF6ZMFo1k5JH8wJjd/mgQ66/AxgURc6OaNqbxcprA/7VtotD1m2y
         kQfz6dhzXvRV+sjpPvI9WDnTd9QKtshO5MDnxEWV9jhZ9AQ38x/G+qZPFjmIUYSXXkIL
         4kQRdLj7TuVQ04LyPPURlvcwz+mQWvEMSnHxJrMVV/ORS81nmYrB8Far6cl0FRTMCijz
         nPgzhxFBT3lHmOmDNgQjdfc/XOU6wp7K9xBUGTFZ93CZubXyhummeSh8pzr6QoMTAXh0
         s5CA==
X-Forwarded-Encrypted: i=1; AJvYcCWkJosj3s0sH3qeqVJTgG+qkWeeC3XfyJmtUJbq3qa4gSGgC7oxcHodzO7ygw13/JVkBoXhHgtEd/Aot/s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9OL9kPH2YTZDnxP/Vq9n2sBGMPxvLRSI0KmO9IAjDdfiiZnes
	YluOyPCzsk/bbZQ0FfAEKZ33FWaPf+/QjJb2ibj4y1Y4g6hhOVk37UoatzES2W3tplNfXCRTgRL
	dDQ==
X-Google-Smtp-Source: AGHT+IHjO2ZnCRxSz9ckB9UKOIbx0lfEs9B109yICVMG4UQB0RF4tpKtRhegltvZ6NeMdGY988NLUYMrptA=
X-Received: from plas19.prod.google.com ([2002:a17:903:2013:b0:21f:467:f8ae])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:228a:b0:21d:cd0c:a1ac
 with SMTP id d9443c01a7336-21f17df7196mr51828645ad.17.1738768629827; Wed, 05
 Feb 2025 07:17:09 -0800 (PST)
Date: Wed, 5 Feb 2025 07:17:08 -0800
In-Reply-To: <62b643dd-36d9-4b8d-bed6-189d84eeab59@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738618801.git.ashish.kalra@amd.com> <e9f542b9f96a3de5bb7983245fa94f293ef96c9f.1738618801.git.ashish.kalra@amd.com>
 <62b643dd-36d9-4b8d-bed6-189d84eeab59@amd.com>
Message-ID: <Z6OA9OhxBgsTY2ni@google.com>
Subject: Re: [PATCH v3 3/3] x86/sev: Fix broken SNP support with KVM module built-in
From: Sean Christopherson <seanjc@google.com>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com, will@kernel.org, robin.murphy@arm.com, 
	michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-coco@lists.linux.dev, iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 05, 2025, Vasant Hegde wrote:
> Hi Ashish,
> 
> [Sorry. I didn't see this series and responded to v2].

Heh, and then I saw your other email first and did the same.  Copying my response
here, too (and fixing a few typos in the process).

> > diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> > index c5cd92edada0..4bcb474e2252 100644
> > --- a/drivers/iommu/amd/init.c
> > +++ b/drivers/iommu/amd/init.c
> > @@ -3194,7 +3194,7 @@ static bool __init detect_ivrs(void)
> >  	return true;
> >  }
> >  
> > -static void iommu_snp_enable(void)
> > +static __init void iommu_snp_enable(void)
> >  {
> >  #ifdef CONFIG_KVM_AMD_SEV
> >  	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> > @@ -3219,6 +3219,14 @@ static void iommu_snp_enable(void)
> >  		goto disable_snp;
> >  	}
> >  
> > +	/*
> > +	 * Enable host SNP support once SNP support is checked on IOMMU.
> > +	 */
> > +	if (snp_rmptable_init()) {
> > +		pr_warn("SNP: RMP initialization failed, SNP cannot be supported.\n");
> > +		goto disable_snp;
> > +	}
> > +
> >  	pr_info("IOMMU SNP support enabled.\n");
> >  	return;
> >  
> > @@ -3318,6 +3326,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
> >  		ret = state_next();
> >  	}
> >  
> > +	if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> 
> 
> I think we should clear when `amd_iommu_snp_en` is true.

That doesn't address the case where amd_iommu_prepare() fails, because amd_iommu_snp_en
will be %false (its init value) and the RMP will be uninitialized, i.e.
CC_ATTR_HOST_SEV_SNP will be incorrectly left set.

And conversely, IMO clearing CC_ATTR_HOST_SEV_SNP after initializing the IOMMU
and RMP is wrong as well.  Such a host is probably hosed regardless, but from
the CPU's perspective, SNP is supported and enabled.

> May be below check is enough?
> 
> 	if (ret && amd_iommu_snp_en)
> 
> 
> -Vasant
> 
> 
