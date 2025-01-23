Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DEC14EC55;
	Thu, 23 Jan 2025 18:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737656301; cv=none; b=UIgNMHsj1F0P5mXmr6GxX/hLxOHv6hUTMi+uYfFNjvcMXMW1inD7F1umCJEybD9avRqJBVdaCPIgAciSHQ++OAbdbnAsK3qYniP86m9RaVVcE5rEfnwBTsVJV9+4vska39oAHoCPIHKrTOOW3zNs0HAjy5aw9Ni0gTt181F6e8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737656301; c=relaxed/simple;
	bh=H3RmKXA3Gu71IoJFsaYTzThULswBy/Y7nRWMJ/Xry1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsjhghjtVphywybYl2skbvytcW4T1a3PxZ1g2LsXHyT1vZAeJ5H7D53FUTQHo7uV6Q6/KmeEZ4Kl1hxdQRWBmMl4PnqnRoj4nqmCqA0m/tYRDSTC9jefftLIFvPqj5DfMHQjflcUPgRzf6Wl82vnsAgx1vnhOdVublq5Zxrc6XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjmZA+aF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjmZA+aF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210EAC4CED3;
	Thu, 23 Jan 2025 18:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737656300;
	bh=H3RmKXA3Gu71IoJFsaYTzThULswBy/Y7nRWMJ/Xry1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjmZA+aFzLG0ZgIXN9FLz+JFb648ZyTup8Jv6GxAi0CxNBSDK/2WBdha5vSMt6h90
	 9asVtzfyKQBEH72PE4o1BN3inupnK/pEaLd+ASkkH4KP4gj2oLIiX/KHAPDT074XGN
	 XNckuv/xnLeq4Mn4g0iQOIQOb7MOd6HcPX4WvR35y7yrU9CnLje7hyB6TnqB5rs62e
	 UEMBD5VFOpQnIx1LvMM+uxHHJJof8aXF2txvWFcw+2VzvdCC/HcAeyzyMMmRq8aYmM
	 NEZ2C67c8ZMp2NWwG1ZQYz5xX1BhiXT+29Tsnv/VmmuecVCGgqgpO9zXL9sZXu8t3h
	 cdqbmSlG8FAVA==
Date: Thu, 23 Jan 2025 18:18:18 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Vinicius Peixoto <vpeixoto@lkcamp.dev>,
	WangYuli <wangyuli@grjsls0nwwnnilyahiblcmlmlcaoki5s.yundunwaf1.com>
Subject: Re: [GIT PULL] CRC updates for 6.14
Message-ID: <20250123181818.GA2117666@google.com>
References: <20250119225118.GA15398@sol.localdomain>
 <CAHk-=wgqAZf7Sdyrka5RQQ2MVC1V_C1Gp68KrN=mHjPiRw70Jg@mail.gmail.com>
 <20250123051633.GA183612@sol.localdomain>
 <20250123074618.GB183612@sol.localdomain>
 <20250123140744.GB3875121@mit.edu>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250123140744.GB3875121@mit.edu>

On Thu, Jan 23, 2025 at 09:07:44AM -0500, Theodore Ts'o wrote:
> On Wed, Jan 22, 2025 at 11:46:18PM -0800, Eric Biggers wrote:
> > 
> > Actually, I'm tempted to just provide slice-by-1 (a.k.a. byte-by-byte) as the
> > only generic CRC32 implementation.  The generic code has become increasingly
> > irrelevant due to the arch-optimized code existing.  The arch-optimized code
> > tends to be 10 to 100 times faster on long messages.
> 
> Yeah, that's my intuition as well; I would think the CPU's that
> don't have a CRC32 optimization instruction(s) would probably be the
> most sensitive to dcache thrashing.
> 
> But given that Geert ran into this on m68k (I assume), maybe we could
> have him benchmark the various crc32 generic implementation to see if
> we is the best for him?  That is, assuming that he cares (which he
> might not. :-).

FWIW, benchmarking the CRC library functions is easy now; just enable
CONFIG_CRC_KUNIT_TEST=y and CONFIG_CRC_BENCHMARK=y.

But, it's just a traditional benchmark that calls the functions in a loop, and
doesn't account for dcache thrashing.  It's exactly the sort of benchmark I
mentioned doesn't tell the whole story about the drawbacks of using a huge
table.  So focusing only on microbenchmarks of slice-by-n generally leads to a
value n > 1 seeming optimal --- potentially as high as n=16 depending on the
CPU, but really old CPUs like m68k should need much less.  So the rationale of
choosing "slice-by-1" in the kernel would be to consider the reduced dcache use
and code size, and the fact that arch-optimized code is usually used instead
these days anyway, to be more important than microbenchmark results.  (And also
the other CRC variants in the kernel like CRC64, CRC-T10DIF, CRC16, etc. already
just have slice-by-1, so this would make CRC32 consistent with that.)

- Eric
