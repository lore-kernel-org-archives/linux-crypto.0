Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2B426C3B5;
	Fri, 16 May 2025 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747422406; cv=none; b=BFk8heoueGQYg3gcln+7OeNWGb5a9G1OWTUsbcPZT8s9EXIYwLlNfFDjezRx6g3pp5fczoHGCZYKhNEE9aHpal1Z4wTczrdL5GAk6ZzudsjzIMOPthCmdvGjyyWsV7oyn9KJ/SP0avOYhBB4o9KAOeeTv4fHBIZHPDRTNtHGBB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747422406; c=relaxed/simple;
	bh=JDru76EihXPIsk0ZdHga0s1MNz6DJOcO3W/lzu46W3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8qhHL85DlP90D8u4ggaRgAj+dLuYyNnn01nC+R5V+k6lrlJ+FblAdsscJanuQP8fk+1rMnTSdh71tkeFThxJeRmYUrdXuIemcjWUgZCsiVzvqtHBAm9wgZn41DOWXNxwFP1oOXh34muFcBvwqugsc8NLIzIjQXCYjtIlRqbTGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUNMKbcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUNMKbcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F89C4CEE4;
	Fri, 16 May 2025 19:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747422405;
	bh=JDru76EihXPIsk0ZdHga0s1MNz6DJOcO3W/lzu46W3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GUNMKbcE5OzOkskHmbyAw0oaTy7DQvHUO9XDG01tmVvzUPhB0hvtTm61JWYERAnH1
	 GLL3MB9d+3EM38Vhukjr01bFfpdTxg9Dzf0y64K7/zsbFvp6bsx3hIOYqggRYZb96x
	 ZgmNgZu5UwTbVZF8WNnBjJ2Kibx4SXKq1TX8cbX5eLIrr37ybtOq0Z0AJM0knHdXo6
	 QP7/f4OetYCgNt5u0Q36Rh5y/EkOglYknyL+Og/4mJVL7Xwp6tu8buN1wLnwV9ITEE
	 fULEscEjCy1FAOwZG2UsxMnTeXS+xxRMmomiaZDN2fGlHDmhh2PajnLtyX5PCY7GgE
	 zIcKT0byDs1GA==
Date: Fri, 16 May 2025 12:06:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Jain@formenos.rohan.me.apana.org.au, Ayush <Ayush.Jain3@amd.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, x86-ml <x86@kernel.org>,
	lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/sha256 - Disable SIMD
Message-ID: <20250516190637.GA32835@sol>
References: <20250516112217.GBaCcf6Yoc6LkIIryP@fat_crate.local>
 <aCcirrsFFrrRqf5A@gondor.apana.org.au>
 <aCcmJGuCnuyHmHbx@gondor.apana.org.au>
 <20250516170316.GD1241@sol>
 <20250516181322.GGaCeAQjnIVQx_tX_R@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250516181322.GGaCeAQjnIVQx_tX_R@fat_crate.local>

On Fri, May 16, 2025 at 08:13:22PM +0200, Borislav Petkov wrote:
> On Fri, May 16, 2025 at 10:03:16AM -0700, Eric Biggers wrote:
> > That's silly.  We should just fix x86's irq_fpu_usable() to return false
> > before the CPU is properly initialized. It already checks a per-cpu bool, so
> > it shouldn't be too hard to fit that in.
> 
> Probably.
> 
> There's a fpu__init_cpu() call almost right after load_ucode_ap() which causes
> this thing.
> 
> I'm not sure how much initialized stuff you need for SHA256 SIMD... perhaps
> swap fpu__init_cpu() and load_ucode_ap() calls after proper code audit whether
> that's ok.
> 
> Or add a "is the FPU initialized" check, as you propose, which is probably
> easier.
> 
> As always, the x86 CPU init path is nasty and needs careful auditing.

There are a few different ways in which __apply_microcode_amd() can get called:

    __apply_microcode_amd
        load_ucode_amd_bsp
            load_ucode_bsp
                x86_64_start_kernel
        apply_microcode_amd
            load_ucode_amd_ap
                load_ucode_ap
                    start_secondary
            microcode_ops::apply_microcode
                load_secondary
                __load_primary
        reload_ucode_amd
            reload_early_microcode
                microcode_bsp_resume
                    mc_syscore_ops::resume
                        syscore_resume
                    __restore_processor_state
                        restore_processor_state

What would you say about going back to my earlier plan to make irq_fpu_usable()
return false when irqs_disabled(), like what arm64 does?  (As I had in
https://lore.kernel.org/lkml/20250220051325.340691-2-ebiggers@kernel.org/).
I think that would handle all these cases, as well as others.  We'd need to fix
__save_processor_state() to save the FPU state directly without pretending that
it's using kernel-mode FPU, but I don't know of any issues besides that.  Then
we could also delete the irqs_disabled() checks that I added to
kernel_fpu_begin() and kernel_fpu_end().

- Eric
