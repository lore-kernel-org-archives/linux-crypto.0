Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522445;
	b=I3rV7scoUy4At6aRGK8EoUEpwwP+/rRHKfs3rbv0rMSvvQWnQED6ZS9U+nVb9pmt2MPg
	 vqQBN//0jGKNUx4n8+uD3G2v3iwBU/iuGcNNO7IV9SFLeu+PEoBYMp0IPeD2zp2//V+Oo
	 LEa7LwhKEyGWUjyv7G9/kt0PH6SeV/sPhrfmV4DI+HjlzzVEsywus1gQlaYJZF+CAveHF
	 reHo6j6yZc3hseOyNr6ekPU/Awrnuqmt6TlcXrfbz+ou57o4GkNWIN3AwSRM/9c8otHIn
	 xK6cghXoemxfl/KAxgrH6KWEAU8kaJv4hlD/E8QZezfzRnAFRCEgB5GDk8F1E5ZHATA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522445;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=f+SeFdYy4JRTK3hXnhRNUWYVD40LxxdzEaf6yp824CU=;
	b=U/XtjFrtsEnRZk7WNmsVwNgqWD3FEh4wfzFurzsFO5Z4nPzQymmTO4EQiEfOVUjZxUqb
	 uw+lc2fWnLSNcMCV+h7y0ge3k+IGBfw1Xyq5qRdbA32kU/pQmavOzXcDd8pyyRw2bM781
	 PnLqZ4t8a17X/mn99hSHFlRP3eITc0CTsPPvuFaMvahRNYbDrUKryeQh8e9Gca5G2mSIj
	 +h7vxcxyTT+DN1uk0Xjb2qqmwgJAK3BvqEDu66dI4KGph/DLZNSf41Oy38NwZhBVIKVts
	 QPE+/Aj/TGP0hTYwVuM02jCI0OgcCR0vp8WQU9SO8nF+92gytwS7kb41hIuyrnfNcXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bz9YT9qj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554DC606A31C;
	Thu, 12 Nov 2026 22:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bz9YT9qj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4333F1F000C4;
	Thu, 12 Nov 2026 22:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794522444;
	bh=f+SeFdYy4JRTK3hXnhRNUWYVD40LxxdzEaf6yp824CU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bz9YT9qjT32lKIG/FhtkoW2ysJ6CnFY75269Dhl4kEYr0/btpFp0Q/zAmM/v/JxxW
	 iTkhm73wCMIzShDuy7NuVOSYEpMOUDOAR7xyBY4cWAy5MFR55rta2H+Yp3ZvpnYK9l
	 CpqaFH0dpolkGQeim7lih4F+A2Yy9iAlaHFxBRxy1LznfM2eYnVvXZxhT5Rnjrb3hW
	 cbOUHosRtenS4QYtihoM0wmHSSTGH1zqcSGL6/utccs7OroRBhjgb8G2hkqzgJGtUe
	 9wN9tSar9pFjDespIyKd8zSnEmT0bEPRcYCG1RHpVXnN7Bm2aRbRzgZSL9qeoUc1GG
	 r0JdF7tybRsLQ==
Date: Thu, 12 Nov 2026 15:27:20 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 0/4] Get rid of all NEON intrinsics stdint.h type hacks
Message-ID: <20261112222720.GA188816@ax162>
References: <20261029135020.272082-6-ardb+git@google.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029135020.272082-6-ardb+git@google.com>

Hi Ard,

On Thu, Oct 29, 2026 at 02:50:20PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Recent Clang has become more finicky when it comes to overriding the
> type macros that the freestanding stdint.h consumes when defining the
> uintXX_t types, and so it is time to finally get rid of this entirely.
> 
> So instead of making stdint.h (which comes from the compiler when
> -ffreestanding is set on the command line) agree with the kernel's
> linux/types.h header, avoid the latter entirely in the compilation units
> that actually use the NEON intrinsics (which are always leaf functions
> that are not tightly coupled to kernel APIs).
> 
> Note that the disagreements are about long vs. long long on arm64, and
> long vs. int on 32-bit ARM, so never about types that actually have
> conflicting representations.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> 
> Ard Biesheuvel (4):
>   lib/crc: Don't include <linux/types.h> in NEON intrinsics code
>   xor: arm/arm64: Move NEON xor_gen() dispatch into the glue code
>   arm64: Drop stdint.h type overrides from asm/neon-intrinsics.h
>   ARM: Drop stdint.h type overrides from asm/neon-intrinsics.h

Who do you think should take this series? It would be nice if it could
start making its way to mainline sooner rather than later since tip of
tree clang builds have been broken for over a month at this point.

-- 
Cheers,
Nathan
