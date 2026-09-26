Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A5C346AFD;
	Sat, 26 Sep 2026 04:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790398148; cv=none; b=LCyohRHEG//Uve3JAW9SBBbzts2+ilA8EQT7Qj0E+hQif/S5jEW4gQ7/VFIyH/XWUaqgf0SnU8fO+UDVRn3oTEk6CQFyz2IQrLtwGc6REKYf6SDLfE1qmE8tH7IF47WcWcmGZv1xUKf0HTJ7yBsvg07pVV4E6FcGU8cSOu3VcGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790398148; c=relaxed/simple;
	bh=qvEz7yOXGuOMJQFGtA4Z5p/8/SC881Fg8DFAb+DBDBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uic13sKdqYMz3N6Zfj1x02/W3PDcjhElidTB2wzuv77HtAhMuYQGm9+TYzNfWsw4O99hMRR6xKHfnGq5PMI+QMQjYdTVCy9RMaXJMWUHHqk4DcE4cb1zeeGr/aaXXb2wXMF229j6rYIKhauImbZlWczt3SY9B+n45XKzqFOXhSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ka0oOJcs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ka0oOJcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1001F000FF;
	Sat, 26 Sep 2026 04:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790398146;
	bh=QodIB1xe4hI6Svc1ZX75HcrMssbUbUh3lshXwbPYkwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ka0oOJcsbvP+DY3pf1WeeMeptQ3pUxr7i+0eXL1Mre6vYkzF9q/ynfxuCU8aKUkyu
	 77i/oN/liqme8ApXMxe3rTFCFmDKMCR1gbLez5ipVQPiaFS5u5ws/2YH8OLzWBMXJq
	 YR93As/z8037H3HTA71yqyKKaKw9JBN6aT7j7ep8nE1sFZg3gEiGfavGMKo+/7GSGI
	 Q1TfOgzifvphkwyqLOF+JSZia0IK8x05sgZirof78ujhjzD0wD03wFo1kKZOOYDJ/p
	 UmzqNdwvzTi6v+dqMwzfTIie4vIKyFzAqhthRa3inDkhzJQmkyZfiMEf45VCr0FTVI
	 ihw3KlguFQYBA==
Date: Fri, 25 Sep 2026 21:49:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	jkoolstra@xs4all.nl, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/aes-gcm - fix always true check for last AAD
 segment
Message-ID: <20260926044905.GA11118@sol>
References: <20260926040614.8683-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926040614.8683-1-raizudeen.kerneldev@gmail.com>

On Sat, Sep 26, 2026 at 09:36:14AM +0530, Mohamad Raizudeen wrote:
> In gcm_process_assoc(), a segment that is not the last one must have its
> length rounded down to a multiple of 16 bytes, as required by the
> assembly. The check intended to detect a non-last segment,
> `if (unlikely(assoclen)) /* Not the last segment yet? */` is always
> true, since the loop only runs while assoclen is nonzero.
> 
> As a result the last segment was rounded down as well, leading to some
> avoidable extra work: an additional memcpy into the temporary buffer and
> an additional call into the assembly after the loop. The GCM
> authentication tag is unaffected either way, so the self-tests pass and
> this went unnoticed, its purely an efficiency issue rather than
> correctness one.
> 
> Fix this by comparing the length of the current step against the amount
> of AAD that remains, so that only a step which cannot consume all of the
> remaining bytes is treated as a non-last segment.
> 
> Fixes: b06affb1cb580 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---

Thanks for finding this!  Please use the correct Fixes commit and add Cc
stable:

    Fixes: e9787deff49e ("crypto: x86/aes-gcm - use the new scatterwalk functions")
    Cc: stable@vger.kernel.org

> -		if (unlikely(assoclen)) /* Not the last segment yet? */
> +		if (unlikely(len < assoclen)) /* Not the last segment yet? */
> 			len = round_down(len, 16);

Well, this is not correct either.  Let's just move
'assoclen -= orig_len_this_step;' to near the beginning of the loop
body, restoring the original logic prior to e9787deff49e.

- Eric
