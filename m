Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CDC2857C7
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 21:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763068555; cv=none; b=hmNh+tH7HPXVAphLwx1OgW+pA88alXk5XlDI7dfFAxtgqorlrbDSbrN4A3e8JXQu8fP9cGnVQSGs1xNGcU+B2GJhU9ZnGwk86JgBvickf035EZtqmy2vzJA5HpxJrJhiJfAV5QE8Z6aPz02e57zFfR4TCGOKUNGZz6LO+dsKSCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763068555; c=relaxed/simple;
	bh=JlbnF1+Miz9+WltFJiWNGqBdZlSaszjURQds1GG4q94=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TE0muLUJzoZw9KmXi1uExkFlO5IinskVbckKNG+ptKZMZFwlYQckfCEwYjM06BZg2tFI/iNpuWUnB3/JjtaANqOFTJb6VdDUWnvlOwa4OGLqHeWIwlYm/MkoaIdeBgO+Ez1fDrVWMgKeURCwZf+TnHCDpsQYnK5FB6/U/przXDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NpdzPWLm; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NpdzPWLm"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340c0604e3dso1619002a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 13:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763068553; x=1763673353; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ff3EWcIQuw+YV2qhyOlP9oPJacgoGW33b/BuZqsgvi4=;
        b=NpdzPWLmzrVUn+FZQIRWpkORkJdoW4pMD8NehAr8VzXqzLpqa1SdqzrUgAz5naZNfb
         w2vAS2mijWauDK4ntZAd1I9hFFpvaJ+qiDhqB5BcTTPcXvhUkZQ7pi8sS9g4mXOGh1Ji
         zFFlGRLVaJHtaE66Jm+2J4tfRotbtyx4C5wMdHqNIsNWWmxHgUGmNx+HD7KL3AsK1/Wu
         ebr5sJRq62miqbgS2hnTcU3+vq3Hkh1W6gc6o5HoYjevouWMWOK2Sz9kl2bajY+wd3qA
         vnFLwVxRlGzH3dKh+3JKn0eV0seTVafgebfUBj3GzluwjkYAkCCJ8suJzAtRwrbXATce
         bzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763068553; x=1763673353;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ff3EWcIQuw+YV2qhyOlP9oPJacgoGW33b/BuZqsgvi4=;
        b=gSygPG1WGdTcVl8rUloNt0vnwYjZ6Dh/B4zEsLkQuu2KtCK8ogd8Vs/jMutcTzFatC
         DjcG1EDnfEYQm5qv7hCaBD6r07VUpWmfczNjKPSYS96mevQbuSy5ZjsY6+bjWvfjzwHp
         oPf7gFraaee6x2K976pOaBGg6l+5OBbHNE3jdS9BTkslZD4XU2VDuR9cRvcLVQrGLgIB
         h0h6JMuG6gRQdJWEbM5cHqHt+dtPtk8/ttocj0h+A9xmh60jOywsTGlcFlQFvbw/7Xvj
         jivDOQoLcdNgd+H0A9fRBPnBB96ZMd/AZZA/+Qv8VaCUO33ecQCQT/32lDI1z55GAVIt
         X+nw==
X-Forwarded-Encrypted: i=1; AJvYcCVX5vuaGOzPsSMLeXeyn9e2McdJtEFaNtj9doQwaTTrH5T7Rz+TJNkhp3scqL3rBNzOAwbOwEQSzuGFdrc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCCc12CidUQNMVTrzvdlBsBgJKruiGV0hCXkkmJ/Z8mnC1ow9i
	2kif01VTfatosUHeXxJ/mibQ0gKHvfdXXNVXjR42ABO9WuFjVpVwhqAMDcKJ7OOp0wmxyKRyWln
	KSamF8Q==
X-Google-Smtp-Source: AGHT+IHTvDg0Fvfho2plPN2GuX7qIZOwANyRsPh/XlR4u6dO0fQ8jS/rLmriSL1JSLeZyf3zKAVGdzai8vQ=
X-Received: from pjbcm4.prod.google.com ([2002:a17:90a:fa04:b0:341:8490:5949])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b0c:b0:32e:1b1c:f8b8
 with SMTP id 98e67ed59e1d1-343fa63dc90mr700635a91.26.1763068553344; Thu, 13
 Nov 2025 13:15:53 -0800 (PST)
Date: Thu, 13 Nov 2025 13:15:51 -0800
In-Reply-To: <6e9d3d9d-6541-41ed-994c-04415962a7da@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1761593631.git.thomas.lendacky@amd.com> <e3f711366ddc22e3dd215c987fd2e28dc1c07f54.1761593632.git.thomas.lendacky@amd.com>
 <aRYo05KMsaNdj59U@google.com> <6e9d3d9d-6541-41ed-994c-04415962a7da@amd.com>
Message-ID: <aRZKh66hJWCtqgz1@google.com>
Subject: Re: [PATCH v4 2/4] crypto: ccp - Add an API to return the supported
 SEV-SNP policy bits
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-crypto@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 13, 2025, Tom Lendacky wrote:
> On 11/13/25 12:52, Sean Christopherson wrote:
> > On Mon, Oct 27, 2025, Tom Lendacky wrote:
> >> @@ -1014,6 +1031,7 @@ void *snp_alloc_firmware_page(gfp_t mask);
> >>  void snp_free_firmware_page(void *addr);
> >>  void sev_platform_shutdown(void);
> >>  bool sev_is_snp_ciphertext_hiding_supported(void);
> >> +u64 sev_get_snp_policy_bits(void);
> >>  
> >>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
> >>  
> >> @@ -1052,6 +1070,8 @@ static inline void sev_platform_shutdown(void) { }
> >>  
> >>  static inline bool sev_is_snp_ciphertext_hiding_supported(void) { return false; }
> >>  
> >> +static inline u64 sev_get_snp_policy_bits(void) { return 0; }
> > 
> > As called out in the RFC[*], this stub is unnecesary.
> > 
> > [*] https://lore.kernel.org/all/aMHP5EO-ucJGdHXz@google.com
> 
> Ah, sorry, missed that one. Do you want a fix up or do you want to handle it?

No fixup necessary, assuming this goes through kvm-x86.
