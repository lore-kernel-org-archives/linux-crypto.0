Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15621EB9EF;
	Sun,  2 Mar 2025 22:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740953075; cv=none; b=KZRoegaVsB4mySoiWSgnqe3JHX2DmarkQCVYEEZj9Sns7UM4BCJ5WSwvh25W9h7cWxelWI99xNMoumyu1sKAsdldz4qSs5//ezSer0k+CgEYBNfh3zbQ2qD9vpjVFyZw+AZD3SgmJoPwvpnxH7i4s3tNkH6ieeLunni7y2Rq7tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740953075; c=relaxed/simple;
	bh=sNHgqXDivFwdiZ8TXbNDsXGkLUf6pi1RZL5XR7U6cCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RwGrsPjwZAEn9qBMtN/0pdL6oDZuI81tRfehaFiVZnlwI1oQnoQJsMCVajjF0PCYzjH627uqTdUuhN/vS0Om0wYDfglj6/GA0t9lajz4+NmLAHJpJJv0suChlgQyVHviyfJ0iXZSxw4xLxPf94cZT+dhj6YuazB0a4KquF9Gr8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tN3Mxiiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tN3Mxiiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5901C4CED6;
	Sun,  2 Mar 2025 22:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740953075;
	bh=sNHgqXDivFwdiZ8TXbNDsXGkLUf6pi1RZL5XR7U6cCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tN3Mxiiw13zsYQWWDIEtsEf/0L6ocsJEAmNj1Ny1VIFIzCRYoy4eEuXfZ4sukVgnS
	 cHg0RxwS06qLApzE6y6ebLvaQsa2tZeX84fsq3o5RY+x4QS2q8+R7QRvI6hh4cNnGs
	 L3JJLL2loPpv/3k8ZE6X10TWEB5joAyshocfFPU89lWa/Vv2Qk3FNbvpkMLZ2hoqMg
	 vvF2NyhWKPpD2PS16k1b9U4qdicuBDveuthuDYSCwnSMTmhMYeUBS16OlE/YxI1OPr
	 rCU+0x1sjLrc0Pq+KpH1odkZ1or1f7CQ2W+QOBwoj7oRJzdmwevG1d3bnc+M1V4G6z
	 HIpn0NU+UD5xA==
Date: Sun, 2 Mar 2025 14:04:26 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Zhihang Shao <zhihang.shao.iscas@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>, Xiao Wang <xiao.w.wang@intel.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH 0/4] RISC-V CRC optimizations
Message-ID: <20250302220426.GC2079@quark.localdomain>
References: <20250216225530.306980-1-ebiggers@kernel.org>
 <20250224180614.GA11336@google.com>
 <87ikorl0r5.fsf@all.your.base.are.belong.to.us>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ikorl0r5.fsf@all.your.base.are.belong.to.us>

On Sun, Mar 02, 2025 at 07:56:46PM +0100, Björn Töpel wrote:
> Eric!
> 
> Eric Biggers <ebiggers@kernel.org> writes:
> 
> > On Sun, Feb 16, 2025 at 02:55:26PM -0800, Eric Biggers wrote:
> >> This patchset is a replacement for
> >> "[PATCH v4] riscv: Optimize crct10dif with Zbc extension"
> >> (https://lore.kernel.org/r/20250211071101.181652-1-zhihang.shao.iscas@gmail.com/).
> >> It adopts the approach that I'm taking for x86 where code is shared
> >> among CRC variants.  It replaces the existing Zbc optimized CRC32
> >> functions, then adds Zbc optimized CRC-T10DIF and CRC64 functions.
> >> 
> >> This new code should be significantly faster than the current Zbc
> >> optimized CRC32 code and the previously proposed CRC-T10DIF code.  It
> >> uses "folding" instead of just Barrett reduction, and it also implements
> >> Barrett reduction more efficiently.
> >> 
> >> This applies to crc-next at
> >> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next.
> >> It depends on other patches that are queued there for 6.15, so I plan to
> >> take it through there if there are no objections.
> >> 
> >> Tested with crc_kunit in QEMU (set CONFIG_CRC_KUNIT_TEST=y and
> >> CONFIG_CRC_BENCHMARK=y), both 32-bit and 64-bit.  I don't have real Zbc
> >> capable hardware to benchmark this on, but the new code should work very
> >> well; similar optimizations work very well on other architectures.
> >
> > Any feedback on this series from the RISC-V side?
> 
> I have not reviewed your series, but I did a testrun the Milk-V Jupiter
> which sports a Spacemit K1 that has Zbc.
> 
> I based the run on commit 1973160c90d7 ("Merge tag
> 'gpio-fixes-for-v6.14-rc5' of
> git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux"), plus your
> crc-next branch (commit a0bd462f3a13 ("x86/crc: add ANNOTATE_NOENDBR to
> suppress objtool warnings")) merged:
> 
>   | --- base1.txt	2025-03-02 18:31:16.169438876 +0000
>   | +++ eric.txt	2025-03-02 18:35:58.683017223 +0000
>   | @@ -11,7 +11,7 @@
>   |      # crc16_benchmark: len=127: 153 MB/s
>   |      # crc16_benchmark: len=128: 153 MB/s
>   |      # crc16_benchmark: len=200: 153 MB/s
>   | -    # crc16_benchmark: len=256: 153 MB/s
>   | +    # crc16_benchmark: len=256: 154 MB/s
>   |      # crc16_benchmark: len=511: 154 MB/s
>   |      # crc16_benchmark: len=512: 154 MB/s
>   |      # crc16_benchmark: len=1024: 155 MB/s
>   | @@ -20,94 +20,94 @@
>   |      # crc16_benchmark: len=16384: 155 MB/s
>   |      ok 2 crc16_benchmark
>   |      ok 3 crc_t10dif_test
>   | -    # crc_t10dif_benchmark: len=1: 48 MB/s
>   | -    # crc_t10dif_benchmark: len=16: 125 MB/s
>   | -    # crc_t10dif_benchmark: len=64: 136 MB/s
>   | -    # crc_t10dif_benchmark: len=127: 138 MB/s
>   | -    # crc_t10dif_benchmark: len=128: 138 MB/s
>   | -    # crc_t10dif_benchmark: len=200: 138 MB/s
>   | -    # crc_t10dif_benchmark: len=256: 138 MB/s
>   | -    # crc_t10dif_benchmark: len=511: 139 MB/s
>   | -    # crc_t10dif_benchmark: len=512: 139 MB/s
>   | -    # crc_t10dif_benchmark: len=1024: 139 MB/s
>   | -    # crc_t10dif_benchmark: len=3173: 140 MB/s
>   | -    # crc_t10dif_benchmark: len=4096: 140 MB/s
>   | -    # crc_t10dif_benchmark: len=16384: 140 MB/s
>   | +    # crc_t10dif_benchmark: len=1: 28 MB/s
>   | +    # crc_t10dif_benchmark: len=16: 236 MB/s
>   | +    # crc_t10dif_benchmark: len=64: 450 MB/s
>   | +    # crc_t10dif_benchmark: len=127: 480 MB/s
>   | +    # crc_t10dif_benchmark: len=128: 540 MB/s
>   | +    # crc_t10dif_benchmark: len=200: 559 MB/s
>   | +    # crc_t10dif_benchmark: len=256: 600 MB/s
>   | +    # crc_t10dif_benchmark: len=511: 613 MB/s
>   | +    # crc_t10dif_benchmark: len=512: 635 MB/s
>   | +    # crc_t10dif_benchmark: len=1024: 654 MB/s
>   | +    # crc_t10dif_benchmark: len=3173: 665 MB/s
>   | +    # crc_t10dif_benchmark: len=4096: 669 MB/s
>   | +    # crc_t10dif_benchmark: len=16384: 673 MB/s
>   |      ok 4 crc_t10dif_benchmark
>   |      ok 5 crc32_le_test
>   |      # crc32_le_benchmark: len=1: 31 MB/s
>   | -    # crc32_le_benchmark: len=16: 456 MB/s
>   | -    # crc32_le_benchmark: len=64: 682 MB/s
>   | -    # crc32_le_benchmark: len=127: 620 MB/s
>   | -    # crc32_le_benchmark: len=128: 744 MB/s
>   | -    # crc32_le_benchmark: len=200: 768 MB/s
>   | -    # crc32_le_benchmark: len=256: 777 MB/s
>   | -    # crc32_le_benchmark: len=511: 758 MB/s
>   | -    # crc32_le_benchmark: len=512: 798 MB/s
>   | -    # crc32_le_benchmark: len=1024: 807 MB/s
>   | -    # crc32_le_benchmark: len=3173: 807 MB/s
>   | -    # crc32_le_benchmark: len=4096: 814 MB/s
>   | -    # crc32_le_benchmark: len=16384: 816 MB/s
>   | +    # crc32_le_benchmark: len=16: 439 MB/s
>   | +    # crc32_le_benchmark: len=64: 1209 MB/s
>   | +    # crc32_le_benchmark: len=127: 1067 MB/s
>   | +    # crc32_le_benchmark: len=128: 1616 MB/s
>   | +    # crc32_le_benchmark: len=200: 1739 MB/s
>   | +    # crc32_le_benchmark: len=256: 1951 MB/s
>   | +    # crc32_le_benchmark: len=511: 1855 MB/s
>   | +    # crc32_le_benchmark: len=512: 2174 MB/s
>   | +    # crc32_le_benchmark: len=1024: 2301 MB/s
>   | +    # crc32_le_benchmark: len=3173: 2347 MB/s
>   | +    # crc32_le_benchmark: len=4096: 2407 MB/s
>   | +    # crc32_le_benchmark: len=16384: 2440 MB/s
>   |      ok 6 crc32_le_benchmark
>   |      ok 7 crc32_be_test
>   | -    # crc32_be_benchmark: len=1: 27 MB/s
>   | -    # crc32_be_benchmark: len=16: 258 MB/s
>   | -    # crc32_be_benchmark: len=64: 388 MB/s
>   | -    # crc32_be_benchmark: len=127: 402 MB/s
>   | -    # crc32_be_benchmark: len=128: 424 MB/s
>   | -    # crc32_be_benchmark: len=200: 438 MB/s
>   | -    # crc32_be_benchmark: len=256: 444 MB/s
>   | -    # crc32_be_benchmark: len=511: 449 MB/s
>   | -    # crc32_be_benchmark: len=512: 455 MB/s
>   | -    # crc32_be_benchmark: len=1024: 461 MB/s
>   | -    # crc32_be_benchmark: len=3173: 463 MB/s
>   | -    # crc32_be_benchmark: len=4096: 465 MB/s
>   | -    # crc32_be_benchmark: len=16384: 466 MB/s
>   | +    # crc32_be_benchmark: len=1: 25 MB/s
>   | +    # crc32_be_benchmark: len=16: 251 MB/s
>   | +    # crc32_be_benchmark: len=64: 458 MB/s
>   | +    # crc32_be_benchmark: len=127: 496 MB/s
>   | +    # crc32_be_benchmark: len=128: 547 MB/s
>   | +    # crc32_be_benchmark: len=200: 569 MB/s
>   | +    # crc32_be_benchmark: len=256: 605 MB/s
>   | +    # crc32_be_benchmark: len=511: 621 MB/s
>   | +    # crc32_be_benchmark: len=512: 637 MB/s
>   | +    # crc32_be_benchmark: len=1024: 657 MB/s
>   | +    # crc32_be_benchmark: len=3173: 668 MB/s
>   | +    # crc32_be_benchmark: len=4096: 671 MB/s
>   | +    # crc32_be_benchmark: len=16384: 674 MB/s
>   |      ok 8 crc32_be_benchmark
>   |      ok 9 crc32c_test
>   |      # crc32c_benchmark: len=1: 31 MB/s
>   | -    # crc32c_benchmark: len=16: 457 MB/s
>   | -    # crc32c_benchmark: len=64: 682 MB/s
>   | -    # crc32c_benchmark: len=127: 620 MB/s
>   | -    # crc32c_benchmark: len=128: 744 MB/s
>   | -    # crc32c_benchmark: len=200: 769 MB/s
>   | -    # crc32c_benchmark: len=256: 779 MB/s
>   | -    # crc32c_benchmark: len=511: 758 MB/s
>   | -    # crc32c_benchmark: len=512: 797 MB/s
>   | -    # crc32c_benchmark: len=1024: 807 MB/s
>   | -    # crc32c_benchmark: len=3173: 806 MB/s
>   | -    # crc32c_benchmark: len=4096: 813 MB/s
>   | -    # crc32c_benchmark: len=16384: 816 MB/s
>   | +    # crc32c_benchmark: len=16: 446 MB/s
>   | +    # crc32c_benchmark: len=64: 1188 MB/s
>   | +    # crc32c_benchmark: len=127: 1066 MB/s
>   | +    # crc32c_benchmark: len=128: 1600 MB/s
>   | +    # crc32c_benchmark: len=200: 1727 MB/s
>   | +    # crc32c_benchmark: len=256: 1941 MB/s
>   | +    # crc32c_benchmark: len=511: 1854 MB/s
>   | +    # crc32c_benchmark: len=512: 2164 MB/s
>   | +    # crc32c_benchmark: len=1024: 2300 MB/s
>   | +    # crc32c_benchmark: len=3173: 2345 MB/s
>   | +    # crc32c_benchmark: len=4096: 2402 MB/s
>   | +    # crc32c_benchmark: len=16384: 2437 MB/s
>   |      ok 10 crc32c_benchmark
>   |      ok 11 crc64_be_test
>   | -    # crc64_be_benchmark: len=1: 64 MB/s
>   | -    # crc64_be_benchmark: len=16: 144 MB/s
>   | -    # crc64_be_benchmark: len=64: 154 MB/s
>   | -    # crc64_be_benchmark: len=127: 156 MB/s
>   | -    # crc64_be_benchmark: len=128: 156 MB/s
>   | -    # crc64_be_benchmark: len=200: 156 MB/s
>   | -    # crc64_be_benchmark: len=256: 156 MB/s
>   | -    # crc64_be_benchmark: len=511: 157 MB/s
>   | -    # crc64_be_benchmark: len=512: 157 MB/s
>   | -    # crc64_be_benchmark: len=1024: 157 MB/s
>   | -    # crc64_be_benchmark: len=3173: 158 MB/s
>   | -    # crc64_be_benchmark: len=4096: 158 MB/s
>   | -    # crc64_be_benchmark: len=16384: 158 MB/s
>   | +    # crc64_be_benchmark: len=1: 29 MB/s
>   | +    # crc64_be_benchmark: len=16: 264 MB/s
>   | +    # crc64_be_benchmark: len=64: 476 MB/s
>   | +    # crc64_be_benchmark: len=127: 499 MB/s
>   | +    # crc64_be_benchmark: len=128: 558 MB/s
>   | +    # crc64_be_benchmark: len=200: 576 MB/s
>   | +    # crc64_be_benchmark: len=256: 611 MB/s
>   | +    # crc64_be_benchmark: len=511: 621 MB/s
>   | +    # crc64_be_benchmark: len=512: 638 MB/s
>   | +    # crc64_be_benchmark: len=1024: 659 MB/s
>   | +    # crc64_be_benchmark: len=3173: 667 MB/s
>   | +    # crc64_be_benchmark: len=4096: 671 MB/s
>   | +    # crc64_be_benchmark: len=16384: 674 MB/s
>   |      ok 12 crc64_be_benchmark
>   |      ok 13 crc64_nvme_test
>   | -    # crc64_nvme_benchmark: len=1: 64 MB/s
>   | -    # crc64_nvme_benchmark: len=16: 144 MB/s
>   | -    # crc64_nvme_benchmark: len=64: 154 MB/s
>   | -    # crc64_nvme_benchmark: len=127: 156 MB/s
>   | -    # crc64_nvme_benchmark: len=128: 156 MB/s
>   | -    # crc64_nvme_benchmark: len=200: 156 MB/s
>   | -    # crc64_nvme_benchmark: len=256: 156 MB/s
>   | -    # crc64_nvme_benchmark: len=511: 157 MB/s
>   | -    # crc64_nvme_benchmark: len=512: 157 MB/s
>   | -    # crc64_nvme_benchmark: len=1024: 157 MB/s
>   | -    # crc64_nvme_benchmark: len=3173: 158 MB/s
>   | -    # crc64_nvme_benchmark: len=4096: 158 MB/s
>   | -    # crc64_nvme_benchmark: len=16384: 158 MB/s
>   | +    # crc64_nvme_benchmark: len=1: 36 MB/s
>   | +    # crc64_nvme_benchmark: len=16: 479 MB/s
>   | +    # crc64_nvme_benchmark: len=64: 1340 MB/s
>   | +    # crc64_nvme_benchmark: len=127: 1179 MB/s
>   | +    # crc64_nvme_benchmark: len=128: 1766 MB/s
>   | +    # crc64_nvme_benchmark: len=200: 1965 MB/s
>   | +    # crc64_nvme_benchmark: len=256: 2201 MB/s
>   | +    # crc64_nvme_benchmark: len=511: 2087 MB/s
>   | +    # crc64_nvme_benchmark: len=512: 2464 MB/s
>   | +    # crc64_nvme_benchmark: len=1024: 2331 MB/s
>   | +    # crc64_nvme_benchmark: len=3173: 2673 MB/s
>   | +    # crc64_nvme_benchmark: len=4096: 2745 MB/s
>   | +    # crc64_nvme_benchmark: len=16384: 2782 MB/s
>   |      ok 14 crc64_nvme_benchmark
>   |  # crc: pass:14 fail:0 skip:0 total:14
>   |  # Totals: pass:14 fail:0 skip:0 total:14
> 
> That's a significant speed up for this popular SoC, and it would be
> great to get this series in for the next merge window! Thank you!
> 
> Tested-by: Björn Töpel <bjorn@rivosinc.com>

Thanks for testing this patchset!  So to summarize, on long messages the results
were roughly:

    lsb-first CRCs (crc32_le, crc32c, crc64_nvme):
        Generic table-based code:             158 MB/s
        Old Zbc-optimized code (crc32* only): 816 MB/s
        New Zbc-optimized code:               2440 MB/s

    mst-first CRCs (crc_t10dif, crc32_be, crc64_be):
        Generic table-based code:             158 MB/s
        Old Zbc-optimized code (crc32* only): 466 MB/s
        New Zbc-optimized code:               674 MB/s

So, quite positive results.  Though, the fact the msb-first CRCs are (still) so
much slower than lsb-first ones indicates that be64_to_cpu() is super slow on
RISC-V.  That seems to be caused by the rev8 instruction from Zbb not being
used.  I wonder if there are any plans to make the endianness swap macros use
rev8, or if I'm going to have to roll my own endianness swap in the CRC code.
(I assume it would be fine for the CRC code to depend on both Zbb and Zbc.)

Anyway, I've applied this series to the crc tree
(https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next).

Palmer, I'd appreciate your ack though!

- Eric
