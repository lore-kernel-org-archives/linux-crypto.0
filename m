Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794633813;
	b=fmffRdkgoJDJT12xfVBRDSi34uhzraRtV34QNzR2ld17eMOu35VQViY+txW4UdJX+YEn
	 EolvoslZhecysY03pYUMg86j+hFe5amty14DN7E+hAPXeyyBOinhkSV7xrOxwnvgHC8zi
	 sAkZ1wlOSRRestlMLkeUY8ejFw6a/k5gcqsDHeSX4ED3RbjqEvMh1jIR0/CVAI7v68CEw
	 ZgcZiNndtKFei+Gf2q/kSRsby0uxZJDVEf0pvdy/Ughv9KJ/uH5OOxazOY7UkB/IZi40k
	 m9ZpdNz7NdpKcpR6CvfwITxt5hDLGyEWOuHQk7SSbAP2p5gA5jh0Cd07te9bUuLVBCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794633813;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OQsXfwK9K4wPpftxoJG8RFnHuRqV7vHiTj0LZPVGXCk=;
	b=EZ3yKUiesuqIm+OETEly4KfSu0br34Nh/o7hVRo8+LrODq8jmlg5NDi0w8o5R1BGO1uE
	 lmZDg3s0Urcu/qAxXms06gUSMI1SWGx9IwNiDJSyBbnXOA8KXxbUw4UJ2Ornr/WWHA3vh
	 B4dqUCljBAE8246C9PeVs8NZsFmCP0VnyVuUPZs1tQ+8E+kX7e7lcO7Zd8hST/6bnlUWL
	 BNBp3yq0dqnWpYqIdq20dCTplzPsvoylA29dmTD26nr03ksbdY8vZvzYwQJI8f0praF2n
	 4KaYlB8/mjcA3At3Y/HV+xTnwYHcYPVyn6ywkg81oyRwSZZgVd6KZY/oR2X2aUyQmtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FX2+3U05;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBCD606A329
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 05:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FX2+3U05
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ECE1F000C4;
	Sat, 14 Nov 2026 05:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794633813;
	bh=OQsXfwK9K4wPpftxoJG8RFnHuRqV7vHiTj0LZPVGXCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FX2+3U05fwOasrYnfOVIItTRPhJTuZy2uHfhDRHQDtj+pcvQ+eyPKxCfW7vfjlk0L
	 BmJrkB9sU7ILzAMVfhW/PxCsHb58kyltCT/lHe8RUGY1EjhAPQtpQbP/HhK7aNISvq
	 5brKPzL+u5PTB7mq+giel3HX7UxykNBBXrYDYsWISfzkovf3HDA2WNny9q3XolBRSw
	 pzgd+o2TrCq5muDmM0j28yM5dpYZ0md++vxhF4RBTIlpkprS8SMyOnf33Peo0/8GtD
	 ZSjxI4F+/uC1yeRcUN+XeftRG/vt9pp5vACZ51Vm7vpSbPbrzgxKX3MEGPlZ3/dZKs
	 H6uDxFnGmX0Rw==
Date: Fri, 13 Nov 2026 21:23:31 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: parker@cronstable.dev
Cc: linux-crypto@vger.kernel.org, ardb@kernel.org
Subject: Re: lib/crc: x86/crc32c: question about the "Future work" note
 (crc32q + VPCLMULQDQ on Zen)
Message-ID: <20261114052331.GA1893@sol>
References: <84998C7E-A862-4483-BB1B-D2C63AB45C7D@cronstable.dev>
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
In-Reply-To: <84998C7E-A862-4483-BB1B-D2C63AB45C7D@cronstable.dev>

Hi Parker,

On Fri, Nov 13, 2026 at 10:27:09PM -0500, parker@cronstable.dev wrote:
> Hi Eric,
> 
> There's a comment in crc32c_arch() in lib/crc/x86/crc32.h that says that
> the optimal strategy on Zen 3--5 is to use crc32q and VPCLMULQDQ in
> parallel, but that different numbers of streams and vector lengths are
> optimal on each microarchitecture.  I've been experimenting with this on
> Zen 5, and am curious about what you're looking for here.
> 
> I've tuned an impl for Zen 5 only: two zmm registers folding with
> VPCLMULQDQ while four crc32q streams run alongside, merged at the end
> using multipliers from a 1 KiB table.  Compared with
> crc32_lsb_vpclmul_avx512() at len=4096:
> 
>     AMD Ryzen 7 9800X3D (Zen 5)            +53%   (crc_kunit)
>     AMD EPYC 9V45 (Zen 5)                  +57%   (userspace)
>     AMD EPYC 9V74 (Zen 4)                  +15%, but slower at len=1024
>     Intel Xeon 6975P-C (Granite Rapids)    -43%
> 
> 
> 1. What would you want a solution to look like?  A variant per
>    microarchitecture, a single variant for whichever one is worth it, or
>    nothing until there's an approach that covers several of them?
> 
> 2. Would a Zen 5-only variant be acceptable for now?

I don't think a separate CRC-32C implementation for each
microarchitecture is worth it currently.  CRC-32C is already incredibly
fast.  In particular, crc32_lsb_vpclmul_avx512() (which we have anyway,
to support the IEEE CRC-32) already reaches up to 80 GB/s on CPUs with
good AVX-512 support, so we already have something better than the
traditional 3-way scalar CRC on them.

And "a separate variant for each microarchitecture" is indeed what each
of Zen 3, Zen 4, and Zen 5 would need, which is annoying.

Also, virtually every kernel has CONFIG_CRC32=y enabled, so it would be
nice not to bloat it too much.

If we could generate them all from a template, that could make it more
worthwhile.  But it's hard to handle different numbers of streams in
that way, and Zen 3 is extra special since it doesn't support AVX-512.

Generally, when we add CRC or crypto assembly files, each one is useful
on multiple CPU microarchitectures from both Intel and AMD.

I'm kind of waiting for Zen 6 and Nova Lake at this point and hoping
that a single CRC-32C implementation (maybe 2 ZMM + 4 crc32q, as you
implemented) will be close to optimum on all of those and be
meaningfully better than crc32_lsb_vpclmul_avx512() on each.  In that
case, it would be more worthwhile to add.

So yes, I think your implementation may be what we want eventually.  I'd
just like to be a bit more sure it won't be a one-off for Zen 5.

(And FWIW, Zen 6 having the same 3 scalar CRC units as Zen 5 is likely,
but also not guaranteed.  Tech news is reporting that one of the
multiplication units is going away since it was deemed not worthwhile.)

- Eric
