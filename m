Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A0421E3C2;
	Wed, 16 Oct 2024 03:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729047831; cv=none; b=JlY5bXb57/rydBXlgpidem3q8NdDeYZxr8yHs26+7qJ+x+PPIvd2SYeckUwMw3vROvYzgYmrgtzoY5wUG9yzdrHTAWNSCqhp69hiCDmzRIIKYLz9+J/lqIn2s31edSY25EsLpeJlpD7f7DrbHf59gxqJbsh93W8nMBT+rtq87fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729047831; c=relaxed/simple;
	bh=OvU5BIe7svfN/KO28xtzTgtEROgI/qBKkppVbJJdG08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UqiclsNpJmDBlVHa5tg+Kw0xSA4eXtZO3VMer3kpOSQushM6wjFBXz5Az3uC+8C6M3bLqV2SLWd+JbOotfe9+XYS0QpwFUd2Ywrd+pouDPW+iNay5f4V7ykeG5axt6o3Ia+ZRJFIu2qNrcpSGx/nJ/wDhIEREQd7upVoRDE7FYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AsWCavh8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AsWCavh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B278FC4CEC6;
	Wed, 16 Oct 2024 03:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729047831;
	bh=OvU5BIe7svfN/KO28xtzTgtEROgI/qBKkppVbJJdG08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AsWCavh8uNXg9fSfKlVr7UDasLKQBfMRTZ7vDju4zT9eEaUen0JsOhG2N0852aVgm
	 7n/BH/2sOIbMgTKAbiXRQIU1olOzAUmV/eFcIWInD0DpP1nnibLw94Gr+lRsiKd8ay
	 /ruug9hAuCackPKcpRpcHcD0jLmizFv/jNNc5czHLvWUP2AmXJYy2WG/G2X19MMH3p
	 GLvsxfrADlyrlN3OHX3uAHY4Bbry2wj0plTsCW5yrz8/CSmv1Jz543GrlBgKzm77Oj
	 J6aVTig9Bu/XGoQoWQSharHF4P611auAErSn2FwSXpMzLIOLZ1ADMFzVUxDw5ohqJ1
	 4vB+R2cfnViCg==
Date: Tue, 15 Oct 2024 20:03:49 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	will@kernel.org, catalin.marinas@arm.com,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH 2/2] arm64/crc32: Implement 4-way interleave using PMULL
Message-ID: <20241016030349.GD1138@sol.localdomain>
References: <20241015104138.2875879-4-ardb+git@google.com>
 <20241015104138.2875879-6-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015104138.2875879-6-ardb+git@google.com>

On Tue, Oct 15, 2024 at 12:41:40PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Now that kernel mode NEON no longer disables preemption, using FP/SIMD
> in library code which is not obviously part of the crypto subsystem is
> no longer problematic, as it will no longer incur unexpected latencies.
> 
> So accelerate the CRC-32 library code on arm64 to use a 4-way
> interleave, using PMULL instructions to implement the folding.
> 
> On Apple M2, this results in a speedup of 2 - 2.8x when using input
> sizes of 1k - 8k. For smaller sizes, the overhead of preserving and
> restoring the FP/SIMD register file may not be worth it, so 1k is used
> as a threshold for choosing this code path.
> 
> The coefficient tables were generated using code provided by Eric. [0]
> 
> [0] https://github.com/ebiggers/libdeflate/blob/master/scripts/gen_crc32_multipliers.c
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/lib/Makefile      |   2 +-
>  arch/arm64/lib/crc32-glue.c  |  36 +++
>  arch/arm64/lib/crc32-pmull.S | 240 ++++++++++++++++++++
>  3 files changed, 277 insertions(+), 1 deletion(-)

Thanks for doing this!  The new code looks good to me.  4-way does seem like the
right choice for arm64.

I'd recommend calling the file crc32-4way.S and the functions
crc32*_arm64_4way(), rather than crc32-pmull.S and crc32*_pmull().  This would
avoid confusion with a CRC implementation that is actually based entirely on
pmull (which is possible).  The proposed implementation uses the crc32
instructions to do most of the work and only uses pmull for combining the CRCs.
Yes, crc32c-pcl-intel-asm_64.S made this same mistake, but it is a mistake, IMO.

- Eric
