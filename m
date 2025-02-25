Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7012135A0;
	Tue, 25 Feb 2025 22:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740522099; cv=none; b=L0a4P4naY35S7N8tdiWgaWKCXhtM+ThoYKUDbewF54jNUE2TGkpWoDmDkVEFK8hhOmGaaSZnBGCiqgD9SoZH3FUWjmr5jijHAigJwf503Pa/u8uw+cyFo+zsii02WdevgLEGlS2aKasRWMRFKriUqoN2D+orE71Mw603dMid33s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740522099; c=relaxed/simple;
	bh=4dV3qMEaY+/b58WRuHTItVUPpAgVVn9pTDo0iht+B4w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fMcE8nLrxvZLg2zMtR3XNDGpWV6uDT7k+sXxd/0kldXdG2gIj1Iyj4xm5+xCGOtzS1GaTjYK1lPf0YxLf8j/5uqDcynPoLhYdUKvE/wticlnmSWVulefXnEdNiV/9tkMcfZuquhPvteIzCUpdwFN4SHKKtCJqGUISlYv+kyp2X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNgRVUNu; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNgRVUNu"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43989226283so42252565e9.1;
        Tue, 25 Feb 2025 14:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740522096; x=1741126896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VHOvPuR/Wi9UO5iZQxG9fC7V2bgAgdFZoJjL8l7B2iU=;
        b=kNgRVUNuNdwo5DBBGGunBP1m3r2f/78DATIwdGdSn664wub+RM4XGB91Op7S3I2V5N
         oePRRq2c0mFTlcgBTBEHarXr3pTYp3N2/hg/e1mjm0lgd0C8vrtUoCkeXWYxEsh8BBjo
         OQi/Hw6cyU1qW9EQngQo34+l+WDElcca3jgd3BCqLBBEf7x3s3b8bVfzpYyxaxuaXL8W
         wznnOpimxpGJTWcQ2Q6w3HS2Pc9UTewbvgC2Z3pXo1UJAF6T491GeLkv08zLcOK+fMQD
         Rrw+3IER7tSfLzcOb8X6c5pKb59zml0omTZBn6xtTB55u6BspMZ5jWFQcBmG3tEqBrUk
         7aEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740522096; x=1741126896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VHOvPuR/Wi9UO5iZQxG9fC7V2bgAgdFZoJjL8l7B2iU=;
        b=ZkG1MBKPU988OLWvTnFhKmb9fvYDGBFOXblvyxoG4tYl+61QfLjNzBsQaIkSOQVq55
         DSRHfHDau1PdIGq5LANaBTEIlfbeaNmEEf1vc8f/yMtSeaYCvc7ITP0Y03XiJK0v1jl5
         35Dw/NXGsl2efdlcRsKDUhJ89wfc0HUHfAjOEvziobHGdByY9jwkf5qqxY4Lcdcy22GZ
         imIosCx3WoyGCuw9+eDj+aq/051Dcxk0q8yBVuIKdbAauoV8p51QaBjuxRr6nEWGY0Wk
         IGLvJ2zyG+A0+vEABDBfcDLltDAhI9pXlp7erWaO69oNpTCiZ/gMMnndKTqPERKs3E15
         ImdA==
X-Forwarded-Encrypted: i=1; AJvYcCVArfQ5+AMyItRglMHD1yLp8CwLlxV9qB84NgaewgDfx84dZylNDtZ9KuCckmauKzSg4eAwSA5gBPmcJtE=@vger.kernel.org, AJvYcCVxm8ZOqdoaPnQzbULYPdrYfLqSVICAKHaEmzuQyCfW8MlvlKwkSDHFY1xQc/YvVYTgCmaCaAyWtSRQ08MC@vger.kernel.org
X-Gm-Message-State: AOJu0YyEwjWnmF509rOr4jmh5Z24n0Yt3/XIv69x/sVEZM7efv4UwDz3
	Syy0wOZ3AuM0SC1TLXjcP5FggI0LwJnBhhWmsFNH0V6aiFj5feMm
X-Gm-Gg: ASbGncs+tpcEntc/G8woxMoITasF4sqKlfCDNwOIEo/cmkN+MmLy0uA/AxsIO+I9XH9
	r/7UU/jpuLbP4UkUqmSwDzWk3sNFEmudlix5QOvrd8PvN9yfy5fyg9cn0S1b6R8xwi4cJo9j5D+
	uJhO+OSHuU0ZA+DlQqP5pT7o0mHt6MF5fYFDhKT1iYcUkwrbJPFyB0OI9JwxXAZnSrItTKoDY0d
	Vm2T942sjufX9DTlR/uz/Evi2p9OXbl3KeMc1qwAkIgC9mJ0FafGUQzsn26El9VdwY+xI9cu43+
	ENDMmKeh/b9WYOR69ZSx7ygnKeM774uhtaPgNsx2W7Eh/yEisd+j+jymyjwIUS/G
X-Google-Smtp-Source: AGHT+IGhuQdlW93oN+iObz2oloQDQjhab7e/6iloMoMzZrb9scHCZGmdXSbo/tQq2HlfvypbqG9OAg==
X-Received: by 2002:a05:600c:1c13:b0:439:98b0:f911 with SMTP id 5b1f17b1804b1-439ae1e9aa8mr179552915e9.10.1740522095603;
        Tue, 25 Feb 2025 14:21:35 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43aba52b591sm1452315e9.6.2025.02.25.14.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 14:21:35 -0800 (PST)
Date: Tue, 25 Feb 2025 22:21:33 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Xiao Liang <shaw.leon@gmail.com>, x86@kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ard Biesheuvel
 <ardb@kernel.org>, Ben Greear <greearb@candelatech.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>
Subject: Re: [RFC PATCH 1/2] x86/fpu: make kernel-mode FPU reliably usable
 in softirqs
Message-ID: <20250225222133.395f7194@pumpkin>
In-Reply-To: <20250221193124.GA3790599@google.com>
References: <20250220051325.340691-1-ebiggers@kernel.org>
	<20250220051325.340691-2-ebiggers@kernel.org>
	<CABAhCOQjnSsos3gm4GWrxFUdV8dw-=r_mMn0+xdjnZjJ0PQ9MA@mail.gmail.com>
	<20250221193124.GA3790599@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Feb 2025 19:31:24 +0000
Eric Biggers <ebiggers@kernel.org> wrote:

> Hi Xiao,
> 
> On Fri, Feb 21, 2025 at 03:38:27PM +0800, Xiao Liang wrote:
> > > Therefore, this patch updates x86 accordingly to reliably support
> > > kernel-mode FPU in softirqs (except when hardirqs are disabled).
> > >
> > > This is done by just disabling softirq processing in kernel-mode FPU
> > > sections, as that prevents the nesting that was problematic.
> > >
> > > This will delay some softirqs slightly, but only ones that would have
> > > otherwise been nested inside a task context kernel-mode FPU section.
> > > Any such softirqs would have taken the slow fallback path before if they
> > > tried to do any en/decryption.  Now these softirqs will just run at the
> > > end of the task context kernel-mode FPU section (since local_bh_enable()
> > > runs pending softirqs) and will no longer take the slow fallback path.  
> > 
> > I think this will delay all softirqs, including those that don't use
> > FPU. Will there be a performance impact?
> > (I guess you've noticed the patch I submitted last year. And this is
> > the main reason why it was implemented in the way you mentioned as
> > the second alternative.)  
> 
> Thanks for taking a look at this patch!  It's true that this patch makes all
> softirqs on the same CPU be delayed until the end of the current kernel-mode FPU
> section.  But, I'm a bit skeptical that it actually matters enough on x86 to go
> with a more complex solution that would allow nested kernel-mode FPU.
> Kernel-mode FPU sections are generally short; the usual cases are en/decrypting
> disk sectors or network packets that are 4 KiB or less.
> 
....
> I think it's also important to note that when local_bh_enable() re-enables
> softirq processing (when called from kernel_fpu_end()), it also immediatelly
> runs any pending softirqs.  Thus there would be no additional delay; the CPU
> will *immediately* run any pending softirqs.

I'd also have thought that anything time-critical shouldn't rely on softirq.
The network stack will run a lot of code in softirq context, a bit of time
with softirq disabled isn't going to make any difference to real-world latency.

I do wonder though whether the network napi code should be running in softint
context at all.
With the amount of data it is trivial to get through a single 'consumer' ethernet
interface it can easily cause the scheduler to mis-behave.
I'd guess that google (etc) use threaded napi, multiple rx queues and RFS to get
the network processing spread out and non contending with process code.

> 
> As for supporting nested kernel-mode FPU if we wanted to go that way: yes, your
> patch from last year
> https://lore.kernel.org/lkml/20240403140138.393825-1-shaw.leon@gmail.com/
> ostensibly did that.  However, I found some bugs in it; e.g., it didn't take
> into account that struct fpu is variable-length.  So it didn't turn out as
> simple as that patch made it seem.  Just extending fpregs_{lock,unlock}() to
> kernel-mode FPU is a simpler solution with fewer edge cases, and it avoids
> increasing the memory usage of the kernel.  So I thought I'd propose that first.

Since many kernel users don't want the traditional fpu, they just need to use
an instruction that requires an AVX register or two, is it possible for code
to specify a small save area for just two or four registers and then use just
those registers? (so treating then all as caller-saved).
I know that won't work with anything that affects the fpu status register,
but if you want a single wide register for a PCIe read (to generate a big TLP)
it is more than enough.

I'm sure there are horrid pitfalls, especially if IPI are still used to for
deferred save of fpu state.

	David


