Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A27731F9BF
	for <linux-crypto@vger.kernel.org>; Thu,  2 Apr 2026 23:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775173301; cv=none; b=jNPX2ZzP/Ywmsud5HQCQLsuA23Hvw8hWXeqspSKXw0yGC4JGoHhozQBzM+O1P+P1+hpEN72axGcrqO18kLzmbz+0HjpdPiqEeP7TQb0mtM4jJzJu5xh8Fzs8swnSUgOGoSRsWgjVSDDfARu0lWF1gKMqdNg1el2+3OPzWdWgCUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775173301; c=relaxed/simple;
	bh=7NOW3ITftkmp8qKTfa0k6SbUHcFY4cawziN3p3aCPzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NF4gHXaHhKEU7UDK8Ndfj6imsRC2UVyxTf4Eq1ICw2IS/1vIMJm94cLrXVMIymVaLhI0ioSqJdDplp1E4QGWrWvJyPSPbMzmUlwWpRRPfUF91RQm2z5S9B0UKeBHq8V/Ze2BsswI8sRR/irCm+OT1mqtO3X6Y05fKz5MME3bV2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TkcfvpWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TkcfvpWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D87C116C6;
	Thu,  2 Apr 2026 23:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775173300;
	bh=7NOW3ITftkmp8qKTfa0k6SbUHcFY4cawziN3p3aCPzc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TkcfvpWzktc1Bo9FBwdcwgXFMwCasG7oEuS/DudNm2kQdM6DspmrlBOXkcS2TTpO1
	 /sCjIvh2jS/HGl6wd6DiC20xNR8HQzjTn2uBQQE25kBJPvJ5z+vlcphLwTYnBD4s0r
	 qe0VlHnsAM9UgFcuwS26OjOSybAvoD+DOje4T0nT/FpfX86oAsSLXaCnFfgL7X+rJ5
	 Io3w/oxIdbFcio56DOq08Ki9kLz0INji3b5XtRNHFhkzDDvhHcujVSge0jtIycx9fV
	 Ux6Tfme1dbAkLgJuC0+TwuoGX7c/BEyW9X0M/TnmpIgWmy54L340rSPlKoxX4vLwZr
	 fW/zFo3XXBQ8A==
Date: Thu, 2 Apr 2026 16:40:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Demian Shulhan <demyansh@gmail.com>
Subject: Re: [PATCH 0/5] crc64: Tweak intrinsics code and enable it for ARM
Message-ID: <20260402234028.GA2256@sol>
References: <20260330144630.33026-7-ardb@kernel.org>
 <20260401195943.GA2466@quark>
 <dc424b4a-11b5-475f-a53a-987b5813bac5@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc424b4a-11b5-475f-a53a-987b5813bac5@app.fastmail.com>

On Thu, Apr 02, 2026 at 10:52:17AM +0200, Ard Biesheuvel wrote:
> 
> On Wed, 1 Apr 2026, at 21:59, Eric Biggers wrote:
> > On Mon, Mar 30, 2026 at 04:46:31PM +0200, Ard Biesheuvel wrote:
> >> Apply some tweaks to the new arm64 crc64 NEON intrinsics code, and wire
> >> it up for the 32-bit ARM build. Note that true 32-bit ARM CPUs usually
> >> don't implement the prerequisite 64x64 PMULL instructions, but 32-bit
> >> kernels are commonly used on 64-bit capable hardware too, which do
> >> implement the 32-bit versions of the crypto instructions if they are
> >> implemented for the 64-bit ISA (as per the architecture).
> >> 
> >> Cc: Demian Shulhan <demyansh@gmail.com>
> >> Cc: Eric Biggers <ebiggers@kernel.org>
> >> 
> >> Ard Biesheuvel (5):
> >>   lib/crc: arm64: Drop unnecessary chunking logic from crc64
> >>   lib/crc: arm64: Use existing macros for kernel-mode FPU cflags
> >>   ARM: Add a neon-intrinsics.h header like on arm64
> >>   lib/crc: arm64: Simplify intrinsics implementation
> >>   lib/crc: arm: Enable arm64's NEON intrinsics implementation of crc64
> >
> > I think patches 3 and 4 should be swapped, so it's cleanups first (which
> > make sense regardless of the 32-bit ARM support) and then the 32-bit ARM
> > support.
> >
> 
> Ok.

I can also apply patches 1-2 and 4 now if you want.  Let me know if I
should do that or if a new version is coming.

- Eric
