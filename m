Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79122D060C;
	Sun, 29 Mar 2026 20:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774816711; cv=none; b=KPDptlIU/Bv36TzeAGhuiLTVbAZi475nlBSjg9WRZhj9r8+Zj+tUP06yvY8SemXCd5P7bjsBMHrg/5y0rMcxygfj8ENW900qurty5aL17Ej2hWi8fQsql5qfmRpkO6E+gffldBH3qvc3E3fCbsR5xzDzGVtYH/HmMTeEI0+134s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774816711; c=relaxed/simple;
	bh=yYaQyjAQ+oTlcnhhYfdkv5KRzeJYgZ4/wQYablCPVRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9eI/zIoAmU1Uv2rXBsT68kGMDTo6q5nTUwVxo3fK3RpWWY/VyfaV/eaQRRbb1einDRIsKqa1/4TN05N1Cc6PVrwHg9e62dhthwDV+LMl2mkgL6aL/bDmfLgHXk9VgzKmCwED0Oe+cUMtnu63sV/FLNkXzK1m27TqDhAlToGKvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XGq9cyzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XGq9cyzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E00C116C6;
	Sun, 29 Mar 2026 20:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774816711;
	bh=yYaQyjAQ+oTlcnhhYfdkv5KRzeJYgZ4/wQYablCPVRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XGq9cyzkihOvqpYwGMfsey8DxUJr4Z433YDhfv2hD0kW3+dYM8hW+dz8+3CIOEDPc
	 24sR2qhfx1p4ACjwTPWlwAFbPt/upIUvegheuBd4DBwyOnRzRXkisBunjttTpeq+m6
	 RBMWb6RA8znTgKcYcxxiwxW78V53CpBr8wiZqEJ7SX+f39G4GM81Jk/7T+shNaDTyE
	 JtfcVppFIfPKe054mpLMrqtQtbKvu3/JnJnd1nFpqN11h20ffXLF3leNtRQAIrcbI9
	 VWxIWeKZryV3B60yuk7mvEk+0Y1cXyOh/wTjyE2Bwb9I1GrNg/cwtLTT3//KpzKXJy
	 35YJ7vhf2ZUdQ==
Date: Sun, 29 Mar 2026 13:38:29 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Demian Shulhan <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org
Subject: Re: [PATCH v3] lib/crc: arm64: add NEON accelerated CRC64-NVMe
 implementation
Message-ID: <20260329203829.GA2746@quark>
References: <20260317065425.2684093-1-demyansh@gmail.com>
 <20260329074338.1053550-1-demyansh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329074338.1053550-1-demyansh@gmail.com>

On Sun, Mar 29, 2026 at 07:43:38AM +0000, Demian Shulhan wrote:
> Implement an optimized CRC64 (NVMe) algorithm for ARM64 using NEON
> Polynomial Multiply Long (PMULL) instructions. The generic shift-and-XOR
> software implementation is slow, which creates a bottleneck in NVMe and
> other storage subsystems.
> 
> The acceleration is implemented using C intrinsics (<arm_neon.h>) rather
> than raw assembly for better readability and maintainability.
> 
> Key highlights of this implementation:
> - Uses 4KB chunking inside scoped_ksimd() to avoid preemption latency
>   spikes on large buffers.
> - Pre-calculates and loads fold constants via vld1q_u64() to minimize
>   register spilling.
> - Benchmarks show the break-even point against the generic implementation
>   is around 128 bytes. The PMULL path is enabled only for len >= 128.
> 
> Performance results (kunit crc_benchmark on Cortex-A72):
> - Generic (len=4096): ~268 MB/s
> - PMULL (len=4096): ~1556 MB/s (nearly 6x improvement)
> 
> Signed-off-by: Demian Shulhan <demyansh@gmail.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

Thanks!

- Eric
