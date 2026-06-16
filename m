Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF161AA1D2
	for <linux-crypto@vger.kernel.org>; Tue, 16 Jun 2026 08:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781597643; cv=none; b=iGVRqtxYh3dZB2rJtGKbk5qYLTVdNUJjLy0GnMypiCUsEeRVsd8Dc+OktK7kMOk3PeMAua7EbCorrHKoMhjLZpuKrv1zTspKXNwfZ8HfRCLBB6K9iNx26pWGUDgZI+r+F7yKB0tM9DefgG3SiIitRXl1nvmnjNkHOZ2eBdLPMn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781597643; c=relaxed/simple;
	bh=GFVq4UQRxzODJ2V5pzchBL1UfarU6a7+leBY94Hd4V8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OwoUDPJKCjFWGX6ctuTIzIUk4iufSzaAY5oNDS+bzmXu0znndjbTqOb5/scrWl5FCh8PTLsghyzQw9+ESIHL2xIhsMldCjWe0axiPyDFJ19YzVI2qLKeb7rcptgrD1T6kEQ4obc+CFIahVRmLQfHv7y63p+CzlJyg02LlymnVwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hsu2kZud; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hsu2kZud"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490bb83a3f6so33088295e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Jun 2026 01:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781597641; x=1782202441; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TVXyFOU/nCSLvGY/1pF7V6nZATXSTaghxQ1IN52FbJs=;
        b=hsu2kZudskft4p1f5ilvwaQLRcWUs2AaRbGEKHhrRVUSauIkuw9pbMTGRT7TZBYdJL
         CAuk9g8UY7vpPhpMQuw1VMLkPC2PZdQBFtkhL9d1o684tgXiBdfrzXAmF7w2Dl9SlElU
         0B5XF6FIcQFkI9Ew9lwPS9H7s7L9ycelYHtsagWfgcy9idtIEWyUKTD0PoyvNhAG0NQw
         7qofxtlgZGHDjAHIQvLg8vYUlB+Jr+Nf4lltnU32ijwuEtkOYHjbue4bWardAGmKfe7e
         ItpHmpsSzns7YbHVDkcHgVw/4Ky2R80ce5Ka/068Onw9AwliuODcHEB/xGs9rHKYP6j1
         l9FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781597641; x=1782202441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TVXyFOU/nCSLvGY/1pF7V6nZATXSTaghxQ1IN52FbJs=;
        b=VUYa+lew/qW8jUJ3SHJk6IggDwQ6u3miFGZoTe145sl7+El08eokOAU3tz954pSY7j
         q4LXMcmye04wYiBkAr6+I+nDQMoIxVjN6WxquncvpUxNG2Ce3l50c2T1Xk4z2PJrzTSK
         LDC6mIgs7EyrIhQgLE6xBMpyxfN193WH+S9avXc9M22rGekVafNZXuX2wNnHo/FZB129
         uRsPzpw+dh9xuY3n+HaTpKBBJ4Eopp54pA8R3j1MPTSwXNVgd//vnWAszUOMnjLCm4ok
         wKwwqFmz4MT/z6wDMAN0+0ZIqql/4lC2XkdemHROGoGJSOmKFoPGQJJcneTy8RmA5qwQ
         zX2w==
X-Forwarded-Encrypted: i=1; AFNElJ/QnTFfr4fDDMf9WLEScL1k8N8IT4HqLeLM0l763tRCzJbRrBpoL8M0rwWE/rx2kYnT8w7II4F8ezkjolw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp6SPJS/i13jKmZZBwrru/D6zu4fsGY+RHVFLB556y/LrV5g3G
	wxaupJfj65iKrcxPX1HngMv1e+0v0UoiS4kVeTO6OsHzAFxKlfquFZEJ
X-Gm-Gg: Acq92OEcD15MECZv57wEA7bcBVBuabc30z01wxaJzMEn4LoT3g/1g/b4tn3DCL0yvrh
	UM0DFJQXlNVUoCi7cH4+NFxSBWs0N0/uQOxPP4L8EqS5oIqK2umjEg6aBAyEwnEFv1iP8X6PahY
	WEEiFsMEppZcafSoTUcajij3aDnT7HrzRr811tAYmTGN1vD1bPdON+HCFwG61IX7NYAOlCG552G
	maEwK0hdOjsnvHZsaifQlwwHRjiTRnJpcvTz3Uj8ezcf60O8tUZZzom/y6nmJRIJsTcsecEvNw7
	SAnXxOizFQfuZj6A0frBtXxUG2UPbEZZep8qBHk2MG/LJaqPoBG/b3g0jVMoP3VDhRxDFaYFi0w
	ZLYvEYnELJP01UUxvn+WBMk7bmNtSrnT/7BRsfcaf5NSUVVEZKrWcrTNld5454haCbloJPuRyVF
	dxA1/AFnRkUbPkSI2405tv0nnFhxC7rW0zeiTAO9Q2OmMcDN6VQsMG2C+ZKjYs
X-Received: by 2002:a05:600c:3151:b0:490:d354:bd00 with SMTP id 5b1f17b1804b1-4922ffb823bmr37903905e9.25.1781597640400;
        Tue, 16 Jun 2026 01:14:00 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c473bsm46295394f8f.28.2026.06.16.01.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 01:14:00 -0700 (PDT)
Date: Tue, 16 Jun 2026 09:13:58 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, Christoph Hellwig <hch@lst.de>,
 linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260616091358.2ea11b9f@pumpkin>
In-Reply-To: <20260615201050.GB1764@quark>
References: <20260615190338.26581-1-ebiggers@kernel.org>
	<20260615201050.GB1764@quark>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jun 2026 13:10:50 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> On Mon, Jun 15, 2026 at 12:03:38PM -0700, Eric Biggers wrote:
> > Note: for now I omitted the cpu_has_xfeatures() check that the AVX-512
> > optimized crypto and CRC code does, since it's not implemented on
> > User-Mode Linux and it's never been present in the RAID6 code either.  
> 
> By the way, Sashiko keeps complaining about this decision.
> 
> Maybe the x86 maintainers have some advice here?
> 
> For context: on x86 processors, executing AVX or AVX512 instructions
> requires not just that the CPU supports the feature, but also that the
> operating system has set certain bits in XCR0.  For example all EVEX
> coded instructions (i.e. AVX-512) require XCR0=111xx111b.  (See Intel
> manual "2.6.11.1 State Dependent #UD".)
> 
> Therefore most of the kernel's AVX and AVX512 optimized code checks not
> just X86_FEATURE_AVX* but also calls cpu_has_xfeatures() to check XCR0.
> 
> But "most" isn't all.  The RAID6 code for example doesn't check
> cpu_has_xfeatures().  So if you e.g. boot a kernel in QEMU using
> "-cpu max,xsave=off", it already crashes when the RAID6 code does its
> boot-time benchmark.
> 
> Part of the reason for that omission probably is that UML doesn't
> provide an implementation of cpu_has_xfeatures().  And the x86 RAID (XOR
> and RAID6) code is enabled on UML.
> 
> It could be implemented for UML by using the xgetbv instruction, like
> what userspace programs do.  (We'd also need to copy the XFEATURE_MASK_*
> constants, as UML can't include arch/x86/include/asm/fpu/types.h)
> 
> But I wanted to ask: do we really care about the case where features are
> "supported" but their XCR0 bits aren't set?  Perhaps the kernel just
> doesn't/shouldn't support weird cases like "-cpu max,xsave=off"?

I think that case definitely matters for userspace.
Isn't it what happens when you run an old OS on a new cpu?
I remember cases where people were compiling programs that used AVX
(possibly from gcc's cpu=native) but the os hadn't been updated to
actually save the relevant registers.
The programs 'sort of worked' until a process switch failed to preserve
the registers.

So the check you need to do is looking at XCR0 rather than anything else.

> 
> If this case indeed needs to be handled, could we make things easier for
> the kernel's AVX and AVX-512 optimized code?  Currently AVX-512 needs:
> 
>         if (boot_cpu_has(X86_FEATURE_AVX512F) &&
>             cpu_has_xfeatures(XFEATURE_MASK_FP | XFEATURE_MASK_SSE |
>                               XFEATURE_MASK_YMM | XFEATURE_MASK_AVX512, NULL))
> 
> How about we make X86_FEATURE_AVX512F depend on XCR0=111xx111, and
> X86_FEATURE_AVX depend on XCR0=xxxxx111?  Then the cpu_has_xfeatures()
> check wouldn't be needed.  Is there any reason not to do that?

If cpu_has_xfeatures() is checking (a copy of) XCR0 isn't it enough
to just check that XFEATURE_MASK_AVX512 is set - it doesn't make any
sense for the other bits to be clear at the same time.
If the XCR0 copy is sane/sanitised you only need to check one bit.
That would let you #define the constant to 0 if the kernel is built without
the feature and the compiler will optimise the code away.

Then the test would just be:
	if (can_use_xfeature(XFEATURE_AVX512))

-- David

> 
> - Eric

