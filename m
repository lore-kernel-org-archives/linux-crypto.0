Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F235B1C84D0;
	Thu, 27 Aug 2026 02:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787798510; cv=none; b=TXhtVkFfPWBQe26bUf1jFYN4ELGwOcvZBiuWFMDJagk6Iwj9q4F4M4Hf7vkXavT420vHyRwwjnspOdJ7fWiD9tTmIV/Ty49UlSWdjlpdUAZNJ4Hn6P8Q416IKGxUDAXs87VBJMgceub40hf3hLTdKpf/Gsdu7cBMmp8IFbCzhrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787798510; c=relaxed/simple;
	bh=Pe6ebjgOySQG8KNJ1VVfaNeyeiwUQZQXsALIp8Pr0Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CufRTT61ulQ9tnNh6N8iq/KHS5b0Ae6hblDGrLloobjIVIydjkfHZJ+we1xka3ZEwtXrrqb4JNZLB9rgGdhsRsk9dJOIsL492HauwDbtwyFSKg6hyTdpdtoqeSDbmP4HO0Ofk9c838LrDWaQbhx6zOGKFso2tvmT3ldJvkDE7SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BP/YiBWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BP/YiBWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD1C1F000E9;
	Thu, 27 Aug 2026 02:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787798508;
	bh=0jL/52kKMOIHpqQcbC2UZp4pVJ+MTKjkZLk5/qlb7SM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BP/YiBWD+3TcmZitorucd8VNk9N7uCYMgLIssSwWIctzVn4uwyV0delXCj7+vpN2X
	 dyqAJycPGAY+KfZM57H+XNBNuLf/HonYBg4xc+mFcz8zKQeXRZmBcTDQj00Cn7d62I
	 sTc1HAr0GRCugKUC7SGCgKhcQ7GVf7WpakaOWw4IAbOb9nXAPt2bpxDj7LBrX5ufkp
	 jz1D/lozHm+SJueYetT/I/NfclDASej5KtZcoCSgeA+Zn6Eh3WB+o6jsJp1nmqKx9A
	 8d+PyLkteaHUQ0NUzujhiyYgrS+n7cD2pgkYORaUzXTQlkyFMzcZUfBgFNGl4Fw7G7
	 GlCNCnUdbQoaw==
Date: Wed, 26 Aug 2026 19:39:43 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: dsterba@suse.com, linux-kernel@vger.kernel.org, terrelln@fb.com,
	linux-crypto@vger.kernel.org, yosry@kernel.org, hannes@cmpxchg.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, shakeel.butt@linux.dev,
	kernel-team@meta.com
Subject: Re: [PATCH 0/3] zstd: probe the CPU for BMI2 support once, not per
 context
Message-ID: <20260827023943.GA2327@sol>
References: <20260826122558.2662013-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826122558.2662013-1-usama.arif@linux.dev>

On Wed, Aug 26, 2026 at 05:25:35AM -0700, Usama Arif wrote:
> zstd picks between BMI2 and generic code paths at runtime, and issues
> CPUID to decide every time a compression or decompression context is set
> up. The answer cannot change while the kernel is running.
> 
> It is not a cold path: squashfs calls zstd_init_dstream() for every block
> it decompresses, and erofs, btrfs, f2fs and crypto/zstd all initialise a
> context per operation. Each probe is two serializing CPUID instructions
> on x86.
> 
> Patch 1 routes ZSTD_initStaticCCtx() through ZSTD_cpuSupportsBmi2()
> instead of open-coding the probe, which also fixes it testing for BMI2
> without BMI1 - the bodies it selects are tagged
> TARGET_ATTRIBUTE("lzcnt,bmi,bmi2"), so both are needed. No CPU in the
> field implements BMI2 without BMI1, so this is latent. Patch 2 skips the
> probe when DYNAMIC_BMI2 is 0, where every consumer ignores the flag
> anyway. Patch 3 caches the result.
> 
> A 4 KiB crypto_acomp benchmark [1] in a one-vCPU KVM guest, twelve boots
> of nine 30,000-operation rounds, median per-round mean over 108 rounds:
> 
>                     compress     decompress
>   unpatched         16,756 ns     3,455 ns
>   patched           13,646 ns     1,002 ns
>                     -3,110 ns    -2,452 ns
>                      (18.6%)      (71.0%)
> 
> The main reason is because CPUID is an unconditional VM exit.
> 
> [1] https://gist.github.com/uarif1/5cf02f0e22c23f0d1b3d84348f12914c
>  
> Usama Arif (3):
>   zstd: use ZSTD_cpuSupportsBmi2() in ZSTD_initStaticCCtx()
>   zstd: skip the BMI2 probe when dynamic BMI2 dispatch is disabled
>   zstd: probe the CPU for BMI2 support only once
> 
>  lib/zstd/common/zstd_internal.h   | 22 ++++++++++++++++++++--
>  lib/zstd/compress/zstd_compress.c |  2 +-
>  2 files changed, 21 insertions(+), 3 deletions(-)

Why not just use cpu_feature_enabled(X86_FEATURE_BMI2), which compiles
down to a static branch?  All these issues are caused by lib/zstd/ using
its own custom CPU feature detection code, instead of the normal CPU
feature detection code that the rest of the kernel uses.

- Eric
