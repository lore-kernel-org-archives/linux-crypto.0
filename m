Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6DF1FDE09;
	Sun, 18 May 2025 06:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747550071; cv=none; b=TKG8CfkLr18sImoNxuWGZ7HcZHSNu0SYOs0Yu5crvHRyyKWHp5VKVOXwG8X5ZLzhmeKT70jh3ZLhwSfPsFL9N6FwXdga2LVrDHrjk4a3n2fClkPqryjb83VCEiMtA5+FDonJO61fSHpDHdMEuaZMLrWhPwGbvy1Cmu/lgx5I1Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747550071; c=relaxed/simple;
	bh=gjgnFhEXwxcmSN96JYN0zITyDmCiesVn/YDJQi9HefY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qQl+oB77OGwwoppZvAQgZRivhRNwmXk57cha7EYaW8EZDMPggxwBg5/uVrO8lyHDb5B1gJssqyGarLeYVgqwONjDXp/RFiIMChGblaEb5UCch6M9DGWv0vvRwXiQLdF4c/Hy113rKytipotkcY9YoVVrPr6nHO1uX9PHy25PI0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8iwBYcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8iwBYcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DE2C4CEE7;
	Sun, 18 May 2025 06:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747550070;
	bh=gjgnFhEXwxcmSN96JYN0zITyDmCiesVn/YDJQi9HefY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K8iwBYcw/Q+oCg5m0H916mmQduMgA0wWUJtVZiwpNumI/9G4Ubbu//Uk+/bWu6cWD
	 HMjN4DSWozqvedrH+sK6gpk7SUFOewObSBPs3exSgt9ktQ4Cyeu7hM1S7i52OKNwmA
	 srWvWbW4ZYWm6K/sLE/h1IMa4BAVGQVskD1jetPC6Az0Mw85o3aa04mlmnoRk9McdZ
	 6XckkvDroEuwWwnSFsFbVD28oxWxbtYWr0qoCL0AoLwkgs55IdO113iVbKrwbr+Hyp
	 OKys1Jku57rJv1FqUVDdz37uTk2BhR/+Ngf/J/JrD9/0BvUjy/9BcPNNE3gydd0vef
	 9kxp+FvlHzsRA==
Date: Sun, 18 May 2025 08:34:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ayush Jain <Ayush.Jain3@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 3/3] x86/fpu: Don't support kernel-mode FPU when
 irqs_disabled()
Message-ID: <aCl_cSO2XqtSQEZT@gmail.com>
References: <20250516231858.27899-1-ebiggers@kernel.org>
 <20250516231858.27899-4-ebiggers@kernel.org>
 <aCg2DSYp0nakwX3l@gmail.com>
 <20250517183919.GC1239@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250517183919.GC1239@sol>


* Eric Biggers <ebiggers@kernel.org> wrote:

> > Alternatively we could set in_kernel_fpu during CPU bootstrap, and 
> > clear it once we know the FPU is usable? This is only a relatively 
> > short early boot period, with no scheduling, right?
> 
> Yes, if there isn't agreement on this approach we can do that 
> instead.  Say:
> 
> - Replace in_kernel_fpu with kernel_fpu_supported, with the opposite 
>   meaning (so that the initial value of false means "unsupported")

I'm not against simplifying the x86 FPU model to exclude IRQs-off
context (especially if it also micro-optimizes some of the key runtime
kernel-FPU primitives), but it has to be a full solution and we'll have
to see how complicated the EFI changes get.

Ie. without seeing the full cost-benefit balance it's hard to call this
in advance. Mind sending a full series that addresses the EFI case too?

Thanks,

	Ingo
