Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C143119C569;
	Wed,  5 Mar 2025 17:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741196252; cv=none; b=EWmxzk3IHY8Rcfm9w+gly7ID7EjS2bQaIzre+OB1p7LeIJacUm+VnKx+batrbS6yhd+My27alZKeT/z8SB3xT/CgiPPY/vpBYslQknPJsEsWIHAtV6TYd8653m13lqXIAAATy2Ob37NX4hRH1AMyTG5mloVGhP0J81k/qkcekno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741196252; c=relaxed/simple;
	bh=nKyUdYFJ7Cfv/I2R2NfHVbnwb9rPPNSVBNlTXVcu1GE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNf5LwZslPb/OHzHkW7fRqTvhGQYSm/CsH3WCO2vvv99C6ekfabF179IAvTFfAwMpqReo99mmdhkWhcLkIvu+suAvpDMg8iaf+RjRGzdChgmSI/5kSCfz9DnhAOvc4Syzy6kmbGYjWz5XgZJr+Zz4LtZufC3QISeJ31gGwxUWu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hX5kWA7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hX5kWA7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF974C4CED1;
	Wed,  5 Mar 2025 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741196251;
	bh=nKyUdYFJ7Cfv/I2R2NfHVbnwb9rPPNSVBNlTXVcu1GE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hX5kWA7d4RNwD69CzyIpBnf9ZRw5YfmiJj9H60j/H+HU+JN+PkEkHIioX8/TnBj1o
	 NcdSTSeHDUghVgasZkKAYpcCgfKux3GNkijjbxZMF9iY8geKtudMdLwozMWmK2BPwy
	 2tsGKjqIh2go4Sk1Ez2iO+DaSfMLrFa2X9PsfUFC0uTyajnKJk/7qgeC0ARjwtdFbL
	 0o0KRKWTS2dZxuYIw0DdWUnvVrzwfXFbDsuE6zqNjkq+YjJdTB7yln+EF8POygI1Ra
	 BOTAOeNEl2YokMsKREMDduyYEYqCcQPm0FIW2yOxAfWT7a2LsEq7QKhV4rJbci+XKX
	 VdRZkYSiEvdiA==
Date: Wed, 5 Mar 2025 18:37:25 +0100
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
Message-ID: <Z8iL1dY3o9OxQgBy@gmail.com>
References: <20250304204954.3901-1-ebiggers@kernel.org>
 <Z8gUYamgBr4M5ZaB@gmail.com>
 <b6a80f6d-8469-429d-b03a-8fa71a33046b@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a80f6d-8469-429d-b03a-8fa71a33046b@intel.com>


* Dave Hansen <dave.hansen@intel.com> wrote:

> On 3/5/25 01:07, Ingo Molnar wrote:>> Alternatives considered:
> >> - Make kernel-mode FPU sections fully preemptible.  This would require
> >>   growing task_struct by another struct fpstate which is more than 2K.
> > 
> > So that's something that will probably happen once the kernel is built 
> > using APX anyway?
> 
> I was expecting that building the kernel with APX would be very 
> different than a kernel_fpu_begin(). We don't just need *one* more 
> save area for APX registers: we need a stack, just like normal GPRs.

Yes - but my point is: with any APX build we'd probably be saving 
FPU(-ish) registers at entry points, into a separate context area. If 
that includes FPU registers then we'd not have to do 
kernel_fpu_begin()/end().

In other words, we'd be doing something close to 'growing task_struct 
by another struct fpstate', or so - regardless of whether it's in 
task_struct or some sort of extended pt_regs. The kernel would also be 
close to 'FPU-safe', i.e. there likely wouldn't be a need for 
kernel_fpu_begin()/end().

Thanks,

	Ingo
