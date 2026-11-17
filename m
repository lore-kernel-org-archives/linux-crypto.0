Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794873681;
	b=w9/MqCzCoRdYdS6+qyGmB0RozicbJLRH3hsgZYutc1mSdK763LdRMewIJ42qCoQVw+yL
	 oPnhqTOKFuUI2m8IRxrsBrtdyNJegCCS6IFZv3wIjwC+q/1LKtuTlMOPl383aYZ1bsoUB
	 Y3ttFKFqpGL0X/R4S040czOEloxGyA5zSeXIXsD8VFQdxEcZff2t9mwtOe8g05EZIcn+2
	 qWVIKRwsPg1aS3fBnVWPPilY1QqmcvSEfiLCtHJFCiuA4f1OCght7obbM0E0nkpGI0Tso
	 dCzHPxtFA8YNiyBbpngfPU9iNUq7Gylb0XlS1m4Kr3SjJ9omSywPlwRoz23RolWUZUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794873681;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=K1ZF2KDYPZjWmgXYpRnfPLQMZhHrewkjaJJVimnVSxs=;
	b=eJMIxNCeuWNtdlilKt0bMTKUai6mDiKKcLICBPRiPZ7vlRou9EgPI7+XjhBd/bLq4jFF
	 ajRMNfcJWBI6JzFiMEVqE82C5qBmN1WhYh+JvqWPbWN9Oqd0YaPOJozzENjzd3sVcByhx
	 rHJNw9bf7LdO3tflUDs+Lckgimd4GYzXp+22DYHCxUrji9iAui72yoaZmp7euLRSngrcW
	 pUSh3FX+WXpNSge8P2EbC9YK+p89+dQwtHVov+VCNdNPuf5HsGIVMgX1Mz2oBbEB0C5+y
	 p+zJHPs8pLBBxQQX5tt/E/jX9ptMW8TUZ9xujCtALRVTqWe5JFAe1sPDdIbu0fID7DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GoX9fW28;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FC8606A31C;
	Tue, 17 Nov 2026 00:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GoX9fW28
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9E01F000C4;
	Tue, 17 Nov 2026 00:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794873680;
	bh=K1ZF2KDYPZjWmgXYpRnfPLQMZhHrewkjaJJVimnVSxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GoX9fW28HH2359NOfFg0P9xkJRArgLVZxtLeEIe9cDXJYM7G54evwdy6sqCCoek2V
	 4V6ImVs2iOBcbYlICJyz43hSA9SOuyglGyAuPZZkirz3rM5xO56nO5LlPZDpG1vTwO
	 ShDKtvun2Ue+dm6JBE0HAR4fbANoK17SoSZv9WkawiWgTd9k2ni5Hu8/gmCTp/ROX1
	 eEvi0BvZLYVhkVvagByRuvvXCZu/XmrOcSnNYvo1OiyGytCw3oZFw1oKI2YucF2+Kw
	 Jsx60bhG+Q29wsdlVtnhLuOR964cKuxoAYnI0gL9eidDrgV+NpCCg8yDNrs9RrP3YZ
	 KkQFmlQ+vAS/A==
Date: Tue, 17 Nov 2026 00:01:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Shreesh Adiga <16567adigashreesh@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Demian Shulhan <demyansh@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lib/crc: arm64: Add NEON PMULL+EOR3 crc64_nvme
 implementation
Message-ID: <20261117000119.GH229817@google.com>
References: <20261114172955.1598929-1-16567adigashreesh@gmail.com>
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
In-Reply-To: <20261114172955.1598929-1-16567adigashreesh@gmail.com>

On Sat, Nov 14, 2026 at 10:59:51PM +0530, Shreesh Adiga wrote:
> Add a 4x-folding implementation for CPUs with FEAT_SHA3 which benefits
> newer ARMv9 CPUs like Cortex-X925.
> Usage of EOR3 from SHA3 extension improves performance by 20% compared
> to the regular PMULL without EOR3 on Cortex-X925 measure in userspace
> application via libbenchmark for 512 byte input size.
> Measured about 3x speedup for 512 byte input compared with the existing
> NEON single fold implementation on Cortex-X925 in userspace.

Was crc_kunit run?  It already has a benchmark in it.

The commit message should also clarify that this benefits ARMv8.2 and
later processors with the sha3 extension, not just ARMv9.  (E.g., Apple
M1 is an example of an ARMv8.4 processor that benefits.)

> +#ifdef CONFIG_ARM64
> +#define SHA3_TARGET __attribute__((target("arch=armv8.2-a+crypto+sha3")))

Doesn't this break the build with gcc 8.1?  The kernel supports gcc 8.1
and later, but support for the sha3 target and intrinsics were added in
gcc 9.1.  Either this code will need to check the gcc version, or inline
assembly will need to be used for eor3 like lib/raid/xor/ does.

> +	v0 = fold_single_round(v0, v2, fold_consts_2x);
> +	v1 = fold_single_round(v1, v3, fold_consts_2x);
> +	v0 = fold_single_round(v0, v1, fold_consts);
> +
> +	while (len >= 16) {
> +		uint64x2_t t0 = vreinterpretq_u64_u8(vld1q_u8(p));
> +
> +		v0 = fold_single_round(v0, t0, fold_consts);
> +		p += 16;
> +		len -= 16;
> +	}
> +
> +	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */
> +	v0 = vextq_u64(v0, zero, 1) ^ pmull64_hi_lo(fold_consts, v0);
> +
> +	/* Final Barrett reduction */
> +	uint64x2_t bconsts = vld1q_u64(bconsts_val);
> +	uint64x2_t final = pmull64(bconsts, v0);
> +
> +	v0 = veor3q_u64(v0, vextq_u64(zero, final, 1),
> +			pmull64_hi_lo(bconsts, final));
> +
> +	return vgetq_lane_u64(v0, 1);

Note that this is missing several optimizations compared to the x86
version (lib/crc/x86/crc-pclmul-template.S), including using
fold_consts_2x for a tail of 'len & 32', efficiently handling lengths
that aren't a multiple of 16 bytes, and reducing to the final CRC in two
carryless multiplication instructions rather than three.

This is also just one of several CRC variants.  This would have to be
done all over again for each variant if they are not going to be
generated by a template like x86 and riscv do.

So we can do this for now, but it isn't a very scalable solution.

- Eric
