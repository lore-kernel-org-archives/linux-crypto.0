Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1265226ED45
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 20:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775246473; cv=none; b=VqxfWIvU3av+ZE5fiOlesut8purmt7y1tpZo0sdEop+RHY7nXXTDKgRWWhJLBL2mCc5JP4ba7KPJeP2gxyRoOOalzHzBVW6r/p1ODny101/pcAPA6mFHsAy75jB/qHXdOFvarcLk5d0lk7KTl91L0TlJpC2HGfqAmnN405ErvYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775246473; c=relaxed/simple;
	bh=/Hog9vPmqfzb/GY6jN9Z+oDejJCGNcblxWSQxxJFasc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZuop2oW26KCZJlnRoixyoIppHXpnfcWZhGyFWcBwU9EORFDChYv5KRpNsxPUVGCo08r9h2/0J7k5rVGkht+6owFTL6JxC+5UBVwFstA5xuSDIR4gk+BRqc6SWPWdRuBsq2Q4iFZ5jvHrS+sJthfPKawvPWz33arpaoQK5zJzIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edZgOFa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edZgOFa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED41C4CEF7;
	Fri,  3 Apr 2026 20:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775246472;
	bh=/Hog9vPmqfzb/GY6jN9Z+oDejJCGNcblxWSQxxJFasc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=edZgOFa+m6Z050EMv3mxaVUk0YISBKg2JBK6vbhoknN0eJr3nHfl5BUYDi9pzAK2y
	 w7ZJK2An7cb/s5lyaMZy4827EjdUXAhdnW8554Qo7taO6guAnx+VGDYJ0jR9rDggck
	 hADR/CParFIaOweZKtRH69wpJd9ufF90tUAgu8puluP4zo+47llnbG9Qn3WM9Kg6g+
	 6FbhhMuCih/EuAKhSXzlu7ZBNJnf0tDtUSzgIgKAiEm0WebVOfgL1OsbLGhfafO2Sr
	 Izf8LvQ4JWhoh2mDOqihYfR2myKnFJA6WwIdzSyMUGgVOtYhifK2AXFhddU2fbujNb
	 22VJxQgLNIT7A==
Date: Fri, 3 Apr 2026 12:59:58 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Demian Shulhan <demyansh@gmail.com>
Subject: Re: [PATCH 0/5] crc64: Tweak intrinsics code and enable it for ARM
Message-ID: <20260403195958.GA2882@sol>
References: <20260330144630.33026-7-ardb@kernel.org>
 <20260401195943.GA2466@quark>
 <dc424b4a-11b5-475f-a53a-987b5813bac5@app.fastmail.com>
 <20260402234028.GA2256@sol>
 <9b5affa6-0e04-4256-b740-6ffdad1747b9@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b5affa6-0e04-4256-b740-6ffdad1747b9@app.fastmail.com>

On Fri, Apr 03, 2026 at 08:49:04AM +0200, Ard Biesheuvel wrote:
> 
> 
> On Fri, 3 Apr 2026, at 01:40, Eric Biggers wrote:
> > On Thu, Apr 02, 2026 at 10:52:17AM +0200, Ard Biesheuvel wrote:
> >> 
> >> On Wed, 1 Apr 2026, at 21:59, Eric Biggers wrote:
> >> > On Mon, Mar 30, 2026 at 04:46:31PM +0200, Ard Biesheuvel wrote:
> >> >> Apply some tweaks to the new arm64 crc64 NEON intrinsics code, and wire
> >> >> it up for the 32-bit ARM build. Note that true 32-bit ARM CPUs usually
> >> >> don't implement the prerequisite 64x64 PMULL instructions, but 32-bit
> >> >> kernels are commonly used on 64-bit capable hardware too, which do
> >> >> implement the 32-bit versions of the crypto instructions if they are
> >> >> implemented for the 64-bit ISA (as per the architecture).
> >> >> 
> >> >> Cc: Demian Shulhan <demyansh@gmail.com>
> >> >> Cc: Eric Biggers <ebiggers@kernel.org>
> >> >> 
> >> >> Ard Biesheuvel (5):
> >> >>   lib/crc: arm64: Drop unnecessary chunking logic from crc64
> >> >>   lib/crc: arm64: Use existing macros for kernel-mode FPU cflags
> >> >>   ARM: Add a neon-intrinsics.h header like on arm64
> >> >>   lib/crc: arm64: Simplify intrinsics implementation
> >> >>   lib/crc: arm: Enable arm64's NEON intrinsics implementation of crc64
> >> >
> >> > I think patches 3 and 4 should be swapped, so it's cleanups first (which
> >> > make sense regardless of the 32-bit ARM support) and then the 32-bit ARM
> >> > support.
> >> >
> >> 
> >> Ok.
> >
> > I can also apply patches 1-2 and 4 now if you want.  Let me know if I
> > should do that or if a new version is coming.
> >
> 
> Yes, good idea. I'll take care of the ARM stuff next cycle.

I've applied patches 1-2 and 4 to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
