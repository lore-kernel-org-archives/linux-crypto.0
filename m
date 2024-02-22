Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68976A3F;
	Thu, 22 Feb 2024 06:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708583675; cv=none; b=gHm8Tlw8EcxSlJFGyYkNdUEOHoeCk5qcyEz47bLp4p9s2SXlYXiaMGw/HxZtwdipPd5uvIl7RrWpqmdj6EGsNIXRqcX9VS1fD4tCblvc6V/1Bo1PiqtyKUrDS5g8V3TiyKEK+c6uthw6Tp0Yje4Wm3kWTLtxArjRB7gjxsWa6sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708583675; c=relaxed/simple;
	bh=utVGYA1jsUbTdSF23TVfYNwr3Dv1enzZmeupdecEtGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7cSOZGpzoahL1PRY2wpAOmi20fR9YcOQDRW2dWFsq+q51vYettn9T8OWPuhC1vJAsFYq8uC07hDoQk8VpE/Ab3uCm7LtJCv/rduHrjh0R+2ZHvjp8qmShtVelQO/p7Gic4R4yY1X1N60clXFvHz1vZaxmJBrlQbHl2OvXGS0cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sZLZenrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sZLZenrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E47C433C7;
	Thu, 22 Feb 2024 06:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708583675;
	bh=utVGYA1jsUbTdSF23TVfYNwr3Dv1enzZmeupdecEtGQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sZLZenrSVbyJviQNkgxmlnf/7S1zEl2jTPaWA4SLmKis08BO3WMzPodwBt0ae30fT
	 S/4teASk2F3zV8283yPvHZJTcz/hwhMRlW45sEnuC9QAqw56KcO5ySFF2z4kWMT0Sn
	 xjnqbcy9c0dKIxGCtdqW8QSbAk0g22pJUT1bLsbJw/exxm/bHQCZx9vpVMPna5gV79
	 TrRRr0k60LFvvO/BcJcHYA5aytnHerMHQlrXL5zabTTo2zvFrgv+KjrIOMzF42dfPA
	 6Xr6jcpkdJWyIo67pD1b4/7C5ydQThpL+OMM2RrnetEPT/fPy3XNbBmN5fLLtzdJwj
	 AkUR/vBYsSdCQ==
Date: Wed, 21 Feb 2024 22:34:33 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
	syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
Subject: Re: [PATCH] crypto: arm64/neonbs - fix out-of-bounds access on short
 input
Message-ID: <20240222063433.GA37580@sol.localdomain>
References: <20240217161151.3987164-2-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240217161151.3987164-2-ardb+git@google.com>

On Sat, Feb 17, 2024 at 05:11:52PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The bit-sliced implementation of AES-CTR operates on blocks of 128
> bytes, and will fall back to the plain NEON version for tail blocks or
> inputs that are shorter than 128 bytes to begin with.
> 
> It will call straight into the plain NEON asm helper, which performs all
> memory accesses in granules of 16 bytes (the size of a NEON register).
> For this reason, the associated plain NEON glue code will copy inputs
> shorter than 16 bytes into a temporary buffer, given that this is a rare
> occurrence and it is not worth the effort to work around this in the asm
> code.
> 
> The fallback from the bit-sliced NEON version fails to take this into
> account, potentially resulting in out-of-bounds accesses. So clone the
> same workaround, and use a temp buffer for short in/outputs.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
> Tested-by: syzbot+f1ceaa1a09ab891e1934@syzkaller.appspotmail.com
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Looks like this could use:

Fixes: fc074e130051 ("crypto: arm64/aes-neonbs-ctr - fallback to plain NEON for final chunk")

> +			if (unlikely(nbytes < AES_BLOCK_SIZE))
> +				src = dst = memcpy(buf + sizeof(buf) - nbytes,
> +						   src, nbytes);
> +
>  			neon_aes_ctr_encrypt(dst, src, ctx->enc, ctx->key.rounds,
>  					     nbytes, walk.iv);
> +
> +			if (unlikely(nbytes < AES_BLOCK_SIZE))
> +				memcpy(d, buf + sizeof(buf) - nbytes, nbytes);

The second one could use 'dst' instead of 'buf + sizeof(buf) - nbytes', right?

Otherwise this looks good.

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
