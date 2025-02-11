Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD48C268FEE
	for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 21:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739309522; cv=none; b=k6U01KnJAXjJ1rM5v5BOF2cwYVnVc9G46UONlrY4OEVZ0Ee3DJLDlMou6KlOH/9IFZSNQSWt+OErlcS8tmvfOINM0kjnIRfqcvBwt5MgiYLD56hIhQtwouun31CXH5ps3rv9npz+cBcGU10KbU/GfiiieHNib9MqqxRv6LFSHK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739309522; c=relaxed/simple;
	bh=+LUKvtaq5+tVeSV8nn8P/esQQflfMiqhA8o10k5cyOo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=peVPCYV/uUxEn1fLMbrT+IZL9rhX7l/qG3Dug2yRsQsBPygLdElVyMtYRnmlO1LXwV5t9q/S2XDZDENvB3D6/2dz/6nqwAFNgGP5yI1f0B/qCB10MW4l/7fPlZ9ABmc6Q2E5JIa2nnOW0IHeTBF+7iTS4Cfr8czDIbf26HwOmpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yt2jK6fM; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yt2jK6fM"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220bc75098fso4172075ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 13:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739309516; x=1739914316; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VkaRbODbKGzYYO3d8B5U658Dnrd7njXNzj1iv9zbjaI=;
        b=Yt2jK6fMaUwYFu0R9BfXwO83HnbAB3nmoxfLcm+fATbbAFSn9X7ilBa+qr+46Ak5wv
         iBBTLZEDyCzyyvBIAQuRe4nFLpU4yySP/Byy2S1Z5yPhuPYoBbjLcFWX4YFBMcHFWhcP
         5Yst1KkcHP+8EKveA5hY8hkId7TjWtpZok0ywaEQVAdRz4aado8DP+BptaqpMn7P6kFI
         gPK1GUc0CdwBK25lpYhSAFb7aC1gR4Cv6u4MKpJJQz3Q/E7J0zACyDAj1wd01JZRspu0
         KX2yG4lTy7WjQjNhjO6+A/aKApo3DiTLZxx+0v8eO6FqzvqBsGIuSsbbEdbtEatj3BtJ
         Kt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739309516; x=1739914316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VkaRbODbKGzYYO3d8B5U658Dnrd7njXNzj1iv9zbjaI=;
        b=t4SpgmfXrWhtyPN8akQuvbc1Sm4fyrx7gI2OC6XZ8DgpG8rRADqRc9p6LNjqNuf0Pf
         5flCwod4Vc5YniiJdyUF0n3tim+p9iP/dC+omCTEsRNeIlQg2IFLefCt1Eaw32AcTYb0
         IFJ/v0+uzN7RzNNs95Cz6l97fDgKpfdBlBbrjzopy/uXzIqY6byzosOfa3R1HlPR2ool
         EJCs6t7Rilx8qwL2x0cS1qrvGj2q1WzS/pfYagy/33uzeyRN+zA+0S5KpEc8Als6Op4t
         TOpXMgJs4iw/cKyTwXqoxmZEKCqBoAblp/qzFzWtWdu1LrF0z8U79WaYtLHKEcWHr7/y
         D66w==
X-Forwarded-Encrypted: i=1; AJvYcCWNW/31rhREmlszxxtKiLc338+Rjh+w8RlVrLrUpSKlj5p1hKMQ3/BHWpO10KJiUPt7h6OVS9LonT7u3fE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxZ2OE+D0ZT00xRUMp/88BB+GX58o/ljqnaRWNPfeaDO65rDP1
	DmDOs+FQyTXFTzQLUgiqallavBRcfGjE70jTjyWXfetDDkrBp6tiQ1312XJYBHs9hLfAPcF4Aw0
	a2w==
X-Google-Smtp-Source: AGHT+IF0fRIVtQzGjHRyYmnEnH/8CimtcIxuPGCWLPNdmuUYuFVbVgvZHz2rDvO254ixr09jUnGGcU4Rzps=
X-Received: from pfblb14.prod.google.com ([2002:a05:6a00:4f0e:b0:730:8a7b:24e0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d06:b0:1e4:8fdd:8c77
 with SMTP id adf61e73a8af0-1ee5c733c61mr1455053637.8.1739309515854; Tue, 11
 Feb 2025 13:31:55 -0800 (PST)
Date: Tue, 11 Feb 2025 13:31:54 -0800
In-Reply-To: <cover.1739226950.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1739226950.git.ashish.kalra@amd.com>
Message-ID: <Z6vByjY9t8X901hQ@google.com>
Subject: Re: [PATCH v4 0/3] Fix broken SNP support with KVM module built-in
From: Sean Christopherson <seanjc@google.com>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, joro@8bytes.org, suravee.suthikulpanit@amd.com, 
	will@kernel.org, robin.murphy@arm.com, michael.roth@amd.com, 
	dionnaglaze@google.com, nikunj@amd.com, ardb@kernel.org, 
	kevinloughlin@google.com, Neeraj.Upadhyay@amd.com, vasant.hegde@amd.com, 
	Stable@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 10, 2025, Ashish Kalra wrote:
> Ashish Kalra (1):
>   x86/sev: Fix broken SNP support with KVM module built-in
> 
> Sean Christopherson (2):
>   crypto: ccp: Add external API interface for PSP module initialization
>   KVM: SVM: Ensure PSP module is initialized if KVM module is built-in

Unless I've overlooked a dependency, patch 3 (IOMMU vs. RMP) is entirely
independent of patches 1 and 2 (PSP vs. KVM).  If no one objects, I'll take the
first two patches through the kvm-x86 tree, and let the tip/iommu maintainers
sort out the last patch.

>  arch/x86/include/asm/sev.h  |  2 ++
>  arch/x86/kvm/svm/sev.c      | 10 ++++++++++
>  arch/x86/virt/svm/sev.c     | 23 +++++++----------------
>  drivers/crypto/ccp/sp-dev.c | 14 ++++++++++++++
>  drivers/iommu/amd/init.c    | 34 ++++++++++++++++++++++++++++++----
>  include/linux/psp-sev.h     |  9 +++++++++
>  6 files changed, 72 insertions(+), 20 deletions(-)
> 
> -- 
> 2.34.1
> 
