Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3A74D9F9A;
	Fri,  9 Oct 2026 13:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550998; cv=none; b=t1foM0WAyzPQxj/WEJshu41nr2s/zl5IcGmOH2KQ29nbpsetLtTtOHxiAU/8R4QcxUGE6/SEny1idITgXihQi1b4d0OyfJMLGD1TJ3UzRiu3ob31M4TRhD4k5c/lKB2yttCLrnnPoWIH421mfA1dPaiqTfZWTSn1NtB4Cp9NBWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550998; c=relaxed/simple;
	bh=ttzYFwpQ/doOQHsKirP20/czRy7MLn8ag0WCEHGoXPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLIFTjlZp0MhMfpxTxMpP8a355W+gbN91W1OOzPdXGQBDn2xoKoME/EqEEucJp9sMGxCe5t90DslLTf/bb+RUhEj3IL7De/nvhjlXZLMeDvKI4yigAOEIh5KuI8fCvIIWknMfI8aPaYuJb1pYj+fmDk1NvBqaX8AuTCjHITZ8gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=njAQgK31; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="njAQgK31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB301F000FF;
	Fri,  9 Oct 2026 13:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791550997;
	bh=znsJb0UxnxeG1udpcuKbA32t65RY/Kt2O7rCbLckbh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=njAQgK31bhxbWVovsQi0aKPd/BRnXOzbIuw5mdlSfhJ0PwzIEDQEj5LA4fbhUV012
	 vFUwi1masqLsG+ia92wN7kHg3yncwWd0ViEqGAN1SeDDhI/TtglhbcMZt+CRWcNvwS
	 2oTnJjBJ74txK5yNOgyZAUORwpIsRuOVMpYK4DmMLlOBOQi04/sX9YLzuF7yoGg5y1
	 tLXbEgh40WgCc3ZdviZWg5i8ePVGlrYhPXtpkLZYwxNFPqnxsgjVJ75HYK5RyJcGON
	 7J8GgDjyT7U3kejotKvOS2ByuHF0mJO2Omzo5MGnm/chMdHMpT8/iWqmdLumurdlcb
	 HBhUOnGqj1xJg==
Date: Fri, 9 Oct 2026 15:03:10 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] lib/crypto: arm64: Fix lost Poly1305 carry when
 resuming NEON state
Message-ID: <20261009130310.GA309826@quark>
References: <20261008201949.561207-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261008201949.561207-4-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261008201949.561207-4-Jeremy.Jean@oss.cyber.gouv.fr>

On Thu, Oct 08, 2026 at 08:19:50PM +0000, Jérémy Jean wrote:
> These limbs in base 2^26 represent the value
>       4 
>     + (2^26    ) * 2^26
>     + (2^26 - 1) * 2^52
>     + (2^26 - 1) * 2^78
>     + (2^24 - 1) * 2^104
>   = 2^128 + 4,
> so converting back to base 2^64 must produce
>   h0 = 4, h1 = 0, h2 = 1,
> so that h0 + h1 * 2^64 + h2 * 2^128 = 2^128 + 4.
> 
> The third limb starts at bit 52, so its low 12 bits belong in h0 and
> its upper 14 bits belong in h1. The low-word ADDS starts from
>   4 + 2^26 * 2^26 = 2^52 + 4
> and adds the low 64 bits of
>   (2^26 - 1) << 52 = 2^78 - 2^52,
> namely 2^64 - 2^52. The sum is 2^64 + 4, so it leaves h0 = 4 and
> carry = 1.
> 
> The middle word contains the upper 14 bits of the third limb, all of
> the fourth limb, and the low 24 bits of the fifth limb. The next ADC
> adds the carry from h0 to
>   ((2^26 - 1) >> 12) + ((2^26 - 1) << 14),
> giving
>   (2^14 - 1) + (2^40 - 2^14) + 1 = 2^40.
> The following ADDS adds the low 64 bits of
>   (2^24 - 1) << 40 = 2^64 - 2^40,
> so the sum is 2^64, h1 wraps to 0, and carry = 1.
> 
> The top word starts from the remaining bits of the fifth limb,
>   (2^24 - 1) >> 24 = 0.
> The final ADC must add the carry from h1 and set h2 = 1. Writing the
> carry into d2 instead leaves h2 = 0, so the reconstructed value is 4
> instead of 2^128 + 4.

Thanks, but this LLM-generated "explanation" is way too verbose and
doesn't really say anything useful.  The new test in patch 2 is also
unnecessarily specialized to this exact issue and implementation, isn't
properly explained, and it's apparently LLM-generated too.  I'd normally
give a bit more time for submitters to fix things up, but since it will
likely just go back into the LLM, I don't think there's much point here.
So I went ahead and sent out a v3 that addresses these issues.

Thanks,

- Eric
