Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51334233947
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 09:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230606; cv=none; b=Fxo1Q8O/wqa/so+r+E0/ROPx2S3C8Mut5Yo8ExCFU7gqv/I31qFMeCvrMb7v1l7dvgU3EPCk5554a2XIpeq59sJMr86ph8Ku/WC/GYLLxJOvyP98SSvv/I4V00xg+XxACh7uufbTy0ZrgLHNb8OEqVv3xGP781/cSSbhLYqiILI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230606; c=relaxed/simple;
	bh=7cTvreYa1kqPURd9PoHuzU3jw+QC7MFAqHtzrvBZd+M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m9CfPxg4XNq1a3hzobClVMU436SNYZ8nLr48XzICkkSjn14Sz3uVrQ4Yc7AkYEGFgyCvT1FJwB7uV+8Rf+6ZgKNcA2HWJR9tzZRCcE190gs/sHynoMygYtHMeaefb2w0M/UyKW03EZhzI7yvZu9zlCITQ+mxkcuQZEkpzvB+dOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dfqE4gT4; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfqE4gT4"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4956242332dso31711395e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 02:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785230603; x=1785835403; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+5wzvt8StBpeLA5peqV/1tOOI9hQR8xx+Ocy8vLCtJg=;
        b=dfqE4gT4W+NGRui4rt0MTOvM3rL/h5GIkaFEaf7M7aL7KyK1xcAkvpaFJWQ1cnyV76
         AOP7C97htCwLBDdqiq4O3Bn0qHc/iAzVbYu8LF62H7ymfZB7kJrsouXtouuyy8AqueOe
         07jP22+DszImofCGaQ8joniZKBMvMixelpkwCqqAMptvhd+uSAI5ze3ta1XAUQZo24Bi
         qS6N2sT59S/3N16dJRNRWvZ0iMRcwX/A2Li7zkPxm29vEtxqOMPXWPJZ6gnrZW5S11gg
         oui9BgCimjqXypPs5oe5bSWZW8SV+2JUInx6bQw0tfco/9dL3NpzL1gQmC4CjdjDH0TB
         A85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785230603; x=1785835403;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+5wzvt8StBpeLA5peqV/1tOOI9hQR8xx+Ocy8vLCtJg=;
        b=Lb2UWzgLCp8dW793C2SQtK4DfQFiDJL/Jb81nI2LTgB0MhCD+zhZhxm27ZR8Ie64wb
         C3pGae+qhZx05+y0BU0+pnX9e9C6DlQd8O/moF3uj3rjBBp7GiCk95ZQ4QeePaJvi20U
         WLzbecw0q3hYlggjFBD2/uaAeHZDazvwZOqeS6Ca7YZqrH2SeyPPPEh9ndrKI9ykcR16
         sXgTwUJyaPeL3f4NTA1AB8S500wB7OjxiYX/tnyaNXsU88wbp7eSb+rEVD1fp2rNww4E
         3UPrKbJvjHeQx5WHzIjmWbql7GLBWYXvm6LFNFCmede9GIjX+U/+AzyPEo2mFjxfb1DP
         +jqw==
X-Forwarded-Encrypted: i=1; AHgh+RpbIdbsjTA2D3roCmh9oOrYGgISwhMaviw8sa1oUjutVeWLjhAL5qft4POha0ALlEX8wAMfoPRBIfPL6Rs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvLZ/KITg8O7dMWbhT+d3Nqh7xkUqQJEaCpehPXrBm4neuvrK4
	yjAIktbnYOyz+s53XyXGggJMLsi3ITWUKbCOEueYiWK9p5hEvRNxd6B8
X-Gm-Gg: AR+sD110KDh9jROaC+kx9F38p0PdjioVwH2cwM98lIsVDZeUr8t7z9k5kGlAGJRYox7
	+bVCqnrvfMLO8BTa9ByB1bnhDNAJe3en+bu1+YsnSy0twPRhWV+31UydljFf/wYqWH6qfYAZJvn
	5wc3NheiPI8Po132XfUF2OetiW4Me46pTdPG0BplsSiGVakmQ/fhurWdQElL1JvM9mAlSHu+ARQ
	SVu7SWRNKGdEJurVHflgYrc1k6qlyC5TJnQZRSvS6DxNtPQrHULDIy2pTylXE3raxJGN/zzR8Ue
	2Yz+T12k2mIx6YyGm0miv7Yy2+SJ39tttHvWgv9k3YrujZFxqB4q0YkfG4Jh4W4B2DBTmmtyyoy
	sjkWZd9Qxveyp0eLiSSPd5IseAELtB3/uo9jMkOAZWiT1Pewzdn4UDjeVJFYjJeXGQOKQHTIEqf
	jpNLTXmrqqm6lF0uePCSusd6hW+W4vMcmYQw3Zn/nBcPlLVtwB8w==
X-Received: by 2002:a05:600c:630d:b0:495:4572:21af with SMTP id 5b1f17b1804b1-496c65458e1mr19199285e9.9.1785230603192;
        Tue, 28 Jul 2026 02:23:23 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a60asm60761545f8f.3.2026.07.28.02.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 02:23:22 -0700 (PDT)
Date: Tue, 28 Jul 2026 10:23:21 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org,
 linux-um@lists.infradead.org, linux-raid@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph
 Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512
 xstate bits
Message-ID: <20260728102321.78f4c947@pumpkin>
In-Reply-To: <20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>
References: <20260728021603.79870-1-ebiggers@kernel.org>
	<20260728021603.79870-2-ebiggers@kernel.org>
	<20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Jul 2026 22:27:27 -0700
Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Jul 27, 2026 at 07:15:56PM -0700, Eric Biggers wrote:
> > If the CPU declares AVX or AVX-512 support, verify that the
> > corresponding xstate bits are also set.  If not, warn and clear them.
> > 
> > This eliminates the perceived need for AVX and AVX-512 optimized code in  
> 
> s/This eliminates/Eliminate/
> 
> > the kernel to call cpu_has_xfeatures().  That has never been universally
> > done, which strongly suggests that it has never really been needed in
> > practice, but this should remove any remaining doubt.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  arch/x86/kernel/fpu/xstate.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > index a7b6524a9dea2..904ff933c0d88 100644
> > --- a/arch/x86/kernel/fpu/xstate.c
> > +++ b/arch/x86/kernel/fpu/xstate.c
> > @@ -799,6 +799,23 @@ static u64 __init guest_default_mask(void)
> >  	return ~(u64)XFEATURE_MASK_USER_DYNAMIC;
> >  }
> >  
> > +/* Clear any X86_FEATURE_* used by the kernel whose xfeatures are missing. */
> > +static void __init clear_cpu_caps_with_missing_xfeatures(u64 xfeatures)  
> 
> That function name is a bit too long. How about:
> 
> clear_cpu_caps_xft()

That is too terse.
Since none of the uses are overlong lines it really doesn't matter.

> 
> or so.
> 
> > +{
> > +	u64 mask;
> > +
> > +	mask = XFEATURE_MASK_FPSSE | XFEATURE_MASK_YMM;
> > +	if (boot_cpu_has(X86_FEATURE_AVX) && (xfeatures & mask) != mask) {
> > +		pr_err("x86/fpu: Disabling AVX support due to missing xstate features\n");
> > +		setup_clear_cpu_cap(X86_FEATURE_AVX);
> > +	}
> > +	mask = XFEATURE_MASK_FPSSE | XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512;
> > +	if (boot_cpu_has(X86_FEATURE_AVX512F) && (xfeatures & mask) != mask) {
> > +		pr_err("x86/fpu: Disabling AVX-512 support due to missing xstate features\n");
> > +		setup_clear_cpu_cap(X86_FEATURE_AVX512F);
> > +	}
> > +}
> > +
> >  /*
> >   * Enable and initialize the xsave feature.
> >   * Called once per system bootup.
> > @@ -812,12 +829,14 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
> >  
> >  	if (!boot_cpu_has(X86_FEATURE_FPU)) {
> >  		pr_info("x86/fpu: No FPU detected\n");
> > +		clear_cpu_caps_with_missing_xfeatures(0);
> >  		return;
> >  	}
> >  
> >  	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
> >  		pr_info("x86/fpu: x87 FPU will use %s\n",
> >  			boot_cpu_has(X86_FEATURE_FXSR) ? "FXSAVE" : "FSAVE");
> > +		clear_cpu_caps_with_missing_xfeatures(0);  
> 
> Also, I'm not really clear on the usage here: if the CPU doesn't have FPU or
> XSAVE, we pass in xfeature 0 which is XFEATURE_FP in both cases. And then we
> clear AVX and AVX-512.
> 
> The 0 is basically forcing the checks in the function to match, i.e., it looks
> to me like we're defining a new interface but then we're misusing it so that
> those basic CPU flags are cleared.
> 
> What are we even protecting against here?
> 
> AVX and AVX-512 code needs to check whether it has FPU and XSAVE support?
> 
> I.e., we're protecting against some weird guests?

More likely userspace running an old kernel on a new cpu.
While unlikely to be a problem with AVX and AVX-512, it did happen when they
were first added and might happen when the next feature is added.

> 
> I wanna say, we should not protect but let them crash'n'burn in big big flames
> which can be seen from a mile away.

I don't want to see the bug reports.
The flames aren't big, what happens is that the registers don't get preserved
across a process switch - so code tends to work a lot of the time.

For userspace the XCR bits are the important ones.

	David

> 
> Or do you have a sensible use case in mind which we really wanna protect
> against and this all actually makes sense?
> 
> Thx.
> 

