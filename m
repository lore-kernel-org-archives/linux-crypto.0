Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712851D6DB4;
	Wed,  5 Mar 2025 18:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198406; cv=none; b=JrY+lydZwFdY1YDlrl79gm1txu8tR5/qPnjCDtsgZdjJZ2QXBGau7hGXEMoOqbPpQedHOQlLmgcn5qbtPBWBYR4zDiyULORExfgVEXdOyAno8JeG9p2cF8fjrlGXdLoza09zxsSt5FMt5DUyNxWioveYVvmwWdFOohmAwo0i9Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198406; c=relaxed/simple;
	bh=TCsk+sBiPB8l6Kt6oCdcWaTfve6D/4S6zhOFktjB3ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nsm4uTYI8yDQZNbcQUtwFQ87D24Qv8Y/mBuKDlE33wvndndmN7Pwz5BNdGJtmz0+zFbSwwU3OcsQtnJfbDiJXWFeA0A/G4SHu4CsNxVUFCbPhetR4iiEWEdu46ZfMNP7oKmxwR0iOCwaoBeaZIIyk80i7FWOBjxHZuue6IMZ9EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LfHD2vta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LfHD2vta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF09BC4CEE2;
	Wed,  5 Mar 2025 18:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741198406;
	bh=TCsk+sBiPB8l6Kt6oCdcWaTfve6D/4S6zhOFktjB3ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LfHD2vta12yJo6VPpZ94vmo6B23JGndyWHz3gVEBGHoW60ZE50AE8joWkr9xT39YO
	 GAj3/+fvbsX6kuGKljAGy8mg2sHBntML16sy5gh8t8x9kRNwwQ9joQQTqyV/4TDhoi
	 cM+pfM0AmoLqmK9lLiIm55fBPP4eB9oAhoChVAH2qyF14qAhK3KbfHhzvpkAq6vgtE
	 KcREGNGt5IIiYFtdtcV+gEyt3OkhVd7qUROjrBXv3V5kcFhHaneeSkPBZGVHAloBnF
	 tSqSglYZOyGqZ2F6oVDfizGj8bLoX0ExecASlDDwgrz6xGriGpxKGdroXe+5mZACMV
	 s51xMQ8GKQbnw==
Date: Wed, 5 Mar 2025 19:13:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Eric Biggers <ebiggers@kernel.org>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Xiao Liang <shaw.leon@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	"Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: [RFC PATCH v2] x86/fpu: make kernel-mode FPU reliably usable in
 softirqs
Message-ID: <Z8iUMRGyUpgisuc_@gmail.com>
References: <20250304204954.3901-1-ebiggers@kernel.org>
 <Z8gUYamgBr4M5ZaB@gmail.com>
 <b6a80f6d-8469-429d-b03a-8fa71a33046b@intel.com>
 <Z8iL1dY3o9OxQgBy@gmail.com>
 <65c29e20-8d63-4323-b2e5-09e2e7bf3c1c@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65c29e20-8d63-4323-b2e5-09e2e7bf3c1c@intel.com>


* Dave Hansen <dave.hansen@intel.com> wrote:

> On 3/5/25 09:37, Ingo Molnar wrote:
> > 
> > * Dave Hansen <dave.hansen@intel.com> wrote:
> > 
> >> On 3/5/25 01:07, Ingo Molnar wrote:>> Alternatives considered:
> >>>> - Make kernel-mode FPU sections fully preemptible.  This would require
> >>>>   growing task_struct by another struct fpstate which is more than 2K.
> >>>
> >>> So that's something that will probably happen once the kernel is built 
> >>> using APX anyway?
> >>
> >> I was expecting that building the kernel with APX would be very 
> >> different than a kernel_fpu_begin(). We don't just need *one* more 
> >> save area for APX registers: we need a stack, just like normal GPRs.
> > 
> > Yes - but my point is: with any APX build we'd probably be saving 
> > FPU(-ish) registers at entry points, into a separate context area. If 
> > that includes FPU registers then we'd not have to do 
> > kernel_fpu_begin()/end().
> 
> That's true. But wouldn't it be a bit silly to include _all_ FPU
> registers? If the kernel isn't using AVX512, why bother saving and
> restoring AVX512?

Fair enough - although I bet the execution time difference between a 
partial and a full FPU context save isn't as large as the buffer size 
would suggest... There's a lot of setup cost in XSAVE* instructions 
last I checked.

Thanks,

	Ingo
