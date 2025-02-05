Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB4A1FECD1
	for <linux-crypto@vger.kernel.org>; Wed,  5 Feb 2025 19:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738783919; cv=none; b=cOIO7cqmYYkSpz/LIUb9kBWgxRLSHpkcL85/mh5tG8iWPgp8lhp2ClWorQ7NA2Ei6NwjgOVoA4//T5ctCzXYRuVk4h/gubFR8WXHRQjdK694n807ievuFVWp356IrcBVMTRXvdAq5ksA6w/1NRPfS9SpOE4w0iTtAjQTTOM1ZnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738783919; c=relaxed/simple;
	bh=2rxoVBPGkYRdke7t02zWdPgQ6HfJzuAcVvL+PkSrGoc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=USb0mwepXtOKW3dqiEH42QxxmBKNQbmetsYkvoNJ7EAR91XyDKIuu2FEZGQUIXr/s/qg/5jXoK5c4WeEAAae+SB+vOIBlhuQNt4lIoNjqYFUS26CHF4qOdOxH5h74D13+c17FbE6OoL8RcFLWP1PU84xSqEVXvWpxaBwjlCgBxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bnl3bEL0; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bnl3bEL0"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f9f2bf2aaeso126219a91.1
        for <linux-crypto@vger.kernel.org>; Wed, 05 Feb 2025 11:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738783917; x=1739388717; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ityHFYbQHjCJ1n0TCLpdhG0BGuuO1UwpdTT8iBBDxQE=;
        b=Bnl3bEL0/CYG6FgGetK3sqtOL/Fp32lYz2doPwIARyb0A+IZMy6B2kL2EcpUsop67C
         wcLTkTPGKWRK9s/LZ1ixGJKS+mOr5DyoY0RUFy+VVvjFtagADdiiv1TXnIOioD5iZNt1
         stTrcV485A3nZ42zvrqdSp3nNh73rvOuR/cuGeyd5jaLnxBtjzgTDGgU+iZcy34bYFSS
         nGYGS/vN+Zvp0EpoRT+aYKXjCSwzbPZsTPnl8GgIsZVEWItWAjtOVYupCMNnMAoC7lBc
         /u8zGCVU2cuGRhDZlC3JOZTa37aXBDDYSuDLIYlHHcDUd/seyAkq1NVRE1RLM6/HI9Hu
         V7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738783917; x=1739388717;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ityHFYbQHjCJ1n0TCLpdhG0BGuuO1UwpdTT8iBBDxQE=;
        b=BxjMLW0UEySYtjg3CbvnWPG9ujFG/t3HZm3/bSpfR9+a+WSwMo7KHGTkLlET4KLCGL
         HAHtygeeVjIxGGEj077LcIgkmyPlJ3SsPYMRjRdsSivKzZnM7iQhgJFxU/VIufmDyTHn
         wT5p5O9KAvn2UkIfTXDS993E1PNQzJyp8ZPJLYFvQdjZ0fmbmyVGI8B3vjGc8MKkw6M6
         f724RKaMDbtqh6xtXnu8anvLbm1u+BpYS0lPTyo2BKojkE88mNYMt+YFRrRtx1dFssO3
         n2GNQVKO1LScHaSHwrl+6lBlfTNf3MQbcmHZVf3FjpKrNx+srCrqsHWvH2xCApROdBPl
         BPsg==
X-Forwarded-Encrypted: i=1; AJvYcCWO0Rp2dz8UueZPmuVbFFGhFoanMF+cIRDKRKCI59ceWkqebW6dtjQyBROk3tqyzO/qYwmpe3AW0uXyBDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmzyQmbXBDhF7VqL32kG/WWsX3MNRiz43C+LLg2N31OZa1+NyW
	wj230LXFTrw8/hHpLX0Okg3q0AdZ/jp88Lq1gzI/JGuPSSPa85SbOj8qjNVpakXBJPOX28QDUeG
	o/w==
X-Google-Smtp-Source: AGHT+IGYpR9H2o7CsrEfJdhduqV6CItDd+RRnz38obHEp/U4zWkL8bbKIHK5OX1zzdtql3FDGJLnjb3ZcYY=
X-Received: from pfwy2.prod.google.com ([2002:a05:6a00:1c82:b0:72f:f548:3e09])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:28cc:b0:725:f1b1:cbc5
 with SMTP id d2e1a72fcca58-730350f96demr7928023b3a.3.1738783917255; Wed, 05
 Feb 2025 11:31:57 -0800 (PST)
Date: Wed, 5 Feb 2025 11:31:51 -0800
In-Reply-To: <8f7822df-466d-497c-9c41-77524b2870b6@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738618801.git.ashish.kalra@amd.com> <e9f542b9f96a3de5bb7983245fa94f293ef96c9f.1738618801.git.ashish.kalra@amd.com>
 <62b643dd-36d9-4b8d-bed6-189d84eeab59@amd.com> <Z6OA9OhxBgsTY2ni@google.com> <8f7822df-466d-497c-9c41-77524b2870b6@amd.com>
Message-ID: <Z6O8p96ExhWFEn_9@google.com>
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
> On 2/5/2025 8:47 PM, Sean Christopherson wrote:
> > On Wed, Feb 05, 2025, Vasant Hegde wrote:
> >>> @@ -3318,6 +3326,9 @@ static int __init iommu_go_to_state(enum iommu_init_state state)
> >>>  		ret = state_next();
> >>>  	}
> >>>  
> >>> +	if (ret && !amd_iommu_snp_en && cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> >>
> >>
> >> I think we should clear when `amd_iommu_snp_en` is true.
> > 
> > That doesn't address the case where amd_iommu_prepare() fails, because amd_iommu_snp_en
> > will be %false (its init value) and the RMP will be uninitialized, i.e.
> > CC_ATTR_HOST_SEV_SNP will be incorrectly left set.
> 
> You are right. I missed early failure scenarios :-(
> 
> > 
> > And conversely, IMO clearing CC_ATTR_HOST_SEV_SNP after initializing the IOMMU
> > and RMP is wrong as well.  Such a host is probably hosed regardless, but from
> > the CPU's perspective, SNP is supported and enabled.
> 
> So we don't want to clear  CC_ATTR_HOST_SEV_SNP after RMP initialization -OR-
> clear for all failures?

I honestly don't know, because the answer largely depends on what happens with
hardware.  I asked in an earlier version of this series if IOMMU initialization
failure after the RMP is configured is even survivable.

For this series, I think it makes sense to match the existing behavior, unless
someone from AMD can definitively state that we should do something different.
And the existing behavior is that amd_iommu_snp_en and CC_ATTR_HOST_SEV_SNP will
be left set if the IOMMU completes iommu_snp_enable(), and the kernel completes
RMP setup.
