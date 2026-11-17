Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794899500;
	b=W8aJ9IGzo92giwd29QsjJIG/bs/kDCU8hp6NRyq8V0PGRPGbXMSScIyEI0wfe5PwV7N5
	 FNC1SzFSgEed90Hg4KJMoWCUQMEEi1p1U8jc8j/mQTFs1E673nNSAIPoOyiAP2J8m/8gr
	 FDyq1qWHsV+m+f1/lIxq/Cr69l5ox1V0DCl9mwQYCFuYwgLNPDELX2Fh4Enod2Z7RBp5Y
	 s5Z9RtDj81UdJkl3Rt5JnwiqpJn3oz9oTvYHfPfm4B2krD7VAp4fubtlLRtUR1LPIpLzg
	 ZfKe+HyOVuhTPTVyX2knbHEyh8WQE3W6UlM9Wg5p8J6I14G2BQoAZ/OBNPXrTFP0ofw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794899500;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=ztaw8/WdqcS29DKSXo4rCT1dQ3je+MJasmM3/vzgZOY=;
	b=faIkPX+SzmCl3dGZNQY5zSPjvgB2t9f7rC6rh6TcROPY4hgwrFBDHZtaj2bjtWWlCMG7
	 O3BTdoNDVTvNUwPuEK4z9wKHfO2zd0DLLhBlkQcp6s+Ao+6je/ypQtXzRMnN0xEPbGqdf
	 xfc7skmwyMZAa9GTeiA2Te2ruq1qe8dh9Kw/2ikbIUk9/DkR33i2YnwdKC+ynMf9bme5g
	 adEgghU3YDZ91OcsNGKBj+ux2njryJXX1JjVTyGU3G1DJIP2RNUs9Hzp9vAfemoo62CCc
	 xm1RoSxKKKsY7s0ryBqcQ8e0Qy6UKhWGTknRESAI9BH2lceWjP+8JNmAY8sV1n2L5qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c4U0aRY9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E18606A334;
	Tue, 17 Nov 2026 07:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c4U0aRY9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372091F000C5;
	Tue, 17 Nov 2026 07:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794899500;
	bh=ztaw8/WdqcS29DKSXo4rCT1dQ3je+MJasmM3/vzgZOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c4U0aRY9HvPb8yvBj9mhBgKDlwrRUrGVqhy1bZTU4hsgxc/Wj3Hu6D5dKMXR7/8UD
	 Xk4n+Arom+VyX7tBUk1srqPF4em4ldWZ+sAR5dVPrqoYa9KQXUlCY0BnWin1xUSnvm
	 GPx4N79lWeGP9r4t6wu+flnReI+MWGRqxp54zHmXN1eAE4wcYqWSLULl47i8IGaU41
	 eSWPhUPpuxsri+hqZGnH/ABf2gEYaqtuK/WMEB2zoe+98S5/gRM/8eMgbA5npmWkiM
	 gWE5kkx1flPSOfmmWDGBE7FahYjx0KV7Qt6Vir87A88e/BXPtDKKDS2Pe/3g0IemOE
	 3ba3nNdVJcjWA==
Date: Mon, 16 Nov 2026 23:11:38 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Shreesh Adiga <16567adigashreesh@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Demian Shulhan <demyansh@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme
 implementation
Message-ID: <20261117071138.GA269875@sol>
References: <20261114172955.1598929-1-16567adigashreesh@gmail.com>
 <20261117000119.GH229817@google.com>
 <CA+-x59b-gUddP2cfHbzDrv9jupmeM1LeHkQnNXhE8_y6B+JC1A@mail.gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+-x59b-gUddP2cfHbzDrv9jupmeM1LeHkQnNXhE8_y6B+JC1A@mail.gmail.com>

On Tue, Nov 17, 2026 at 12:20:08PM +0530, Shreesh Adiga wrote:
> Hi Eric,
> 
> On Tue, Nov 17, 2026 at 5:31 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > Was crc_kunit run?  It already has a benchmark in it.
> No, I have access to only one aarch64 device that is Android Mediatek
> Dimensity 9400 SoC without root access.
> Therefore I can't run crc_kunit on that, instead I have done userspace
> comparisons for the same kernel with libbenchmark.
> This is based on my earlier work for FFmpeg:
> https://code.ffmpeg.org/FFmpeg/FFmpeg/pulls/21651
> I also have Corporate MacOS M5 and did check inside Ubuntu VM but that
> is not accurate due to virtualization.

Well, this is a kernel patch.  Contributors are expected to test their
kernel patches.  It can at least be done with QEMU.

> > The commit message should also clarify that this benefits ARMv8.2 and
> > later processors with the sha3 extension, not just ARMv9.  (E.g., Apple
> > M1 is an example of an ARMv8.4 processor that benefits.)
> Sure I will take care of it, but for now I am thinking of first
> improving the existing PMULL to have 4x unrolling as per Demian's
> suggestion.

That would be fine too.

> > Note that this is missing several optimizations compared to the x86
> > version (lib/crc/x86/crc-pclmul-template.S), including using
> > fold_consts_2x for a tail of 'len & 32', efficiently handling lengths
> > that aren't a multiple of 16 bytes, and reducing to the final CRC in two
> > carryless multiplication instructions rather than three.
> I was looking at the crc-pclmul-template.S code and I have a few queries.
> In this aarch64 version we only dispatch to this SIMD routine only
> when len>=128.
> Since we have 128 bytes available, do we have to add the tail of `len
> & 32` handling?

It's still useful, since the length mod 64 might be >= 32.

> Handling len not a multiple of 16 bytes (partial block) I will add but
> I am assuming that the dispatch will maintain 128 minimum len.

There is overhead in entering a kernel-mode NEON section, so it makes
sense to continue to have a minimum length.

> I was trying to understand your "reducing to the final CRC in two
> carryless multiplications rather than three" statement.
> From going through the code in crc-pclmul-template.S:
> .Lreduce_128bits_to_crc tracing the logic below this label, I see
> three clmul operations:
> _pclmulqdq CONSTS_XMM, LO64_TERMS, %xmm0, HI64_TERMS, %xmm1
> 
> _cond_vex movdqa, OFFSETOF_BARRETT_REDUCTION_CONSTS(CONSTS_PTR), CONSTS_XMM
> _pclmulqdq CONSTS_XMM, HI64_TERMS, %xmm0, HI64_TERMS, %xmm1
> 
> .if LSB_CRC && \n == 64
> _cond_vex punpcklqdq, %xmm1, %xmm2, %xmm2
> _pclmulqdq CONSTS_XMM, LO64_TERMS, %xmm1, HI64_TERMS, %xmm1
> 
> I even checked the Intel Whitepaper and the reduction for 64-bit CRC
> section "Final Reduction of 128-bits" also mentions 3 clmul.
> One for using x^128 followed by xor, and then 2 more for final barrett
> reduction with mu and poly.
> Thus I am confused about accomplishing this with just 2 clmul. Could
> you provide details on this?

Sorry, I misremembered.  It's indeed 3 minimum.  There are just a lot of
implementations out there that unnecessarily do 4, including
lib/crc/arm64/crc-t10dif-core.S for example which still exists.

- Eric
