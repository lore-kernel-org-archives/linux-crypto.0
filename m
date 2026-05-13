Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D057327BF8;
	Wed, 13 May 2026 17:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778694685; cv=none; b=rZq2/DpLTok5YzCfExD40ZHjjuXa/yf9ubiCF26u7wqhCfn4uD6KbToL60jpX/S7/sjUVY5YXByhVJ3JMcyEAv6tbwpmIo6CCWHWf50+M8m7FVAdZ+EH6sSsRwsVAusCf9yfboEaxoQRCokJIAtoscqUldUENJN4buyFtFu89H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778694685; c=relaxed/simple;
	bh=WhETy1A1wMdxvS7CzsIzIem5tVJ3SfVlf/HYIcaDxro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d7yCiBlgMija1Y4asMlPUufkekhrorctVb0Nnt+Esa4X198N0uyRgkpFJ8wcT87YZSBo2SY69lgY+PotdC5G5Gn+cGd0TOSutNL+9Z9HJOdjN9H1nnZwqs0iewxcKzUxrXiAwKrSx9tOVQpKohhTuXXo51KIHzA9GMU4/UAFCf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nfITAXPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nfITAXPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3C6C19425;
	Wed, 13 May 2026 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778694684;
	bh=WhETy1A1wMdxvS7CzsIzIem5tVJ3SfVlf/HYIcaDxro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nfITAXPSmCaaoisykuojRos//8tVRJ9nXTc5wfW6gTMLhEDl5+mM98wAoK5zMYl8r
	 SUaammZyGoENwfBxAjoKWfc/7c3z0kileCV/TZPOOjHsisyVUsfDflJkWLw8EVtyV9
	 KIeYWYCzcWEpOX/YpVZIw35CSCkXx1uY7m+Vrv4ptL0CYk6sxNBcFif18y8TjXkoqd
	 zL53pVxhXVskaT4xCuxHQk0aKTYwhCxcC4GLlELZlwZLgdZP/nBNKWBcVlrJHxLdZq
	 1WxIgCCgPvECIiLo5pxwGw1qs7mOenJ0hSnmEXF3ywPL1p7rdyLT/vpfUqJ6UAMg6+
	 r3LED4HNgs/yA==
Date: Wed, 13 May 2026 10:51:22 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 5.10.y 1/3] net: ipv4: stop checking
 crypto_ahash_alignmask
Message-ID: <20260513175122.GC2128@quark>
References: <2026051236-writing-prior-b532@gregkh>
 <20260513171555.3876989-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513171555.3876989-1-sashal@kernel.org>

[+Cc linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
     Steffen Klassert <steffen.klassert@secunet.com> ]

On Wed, May 13, 2026 at 01:15:52PM -0400, Sasha Levin wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> [ Upstream commit e77f5dd701381cef35b9ea8b6dea6e62c8a7f9f3 ]
> 
> Now that the alignmask for ahash and shash algorithms is always 0,
> crypto_ahash_alignmask() always returns 0 and will be removed.  In
> preparation for this, stop checking crypto_ahash_alignmask() in ah4.c.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Stable-dep-of: ec54093e6a8f ("xfrm: ah: account for ESN high bits in async callbacks")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

You forgot to send this to the IPsec maintainers, linux-crypto, and
netdev.  See Documentation/process/submitting-patches.rst for some tips
on how to use scripts/get_maintainer.pl to find the right place to send
kernel patches.

This commit was part of the series
https://lore.kernel.org/linux-crypto/20231022081100.123613-1-ebiggers@kernel.org/

What is your rationale for why it's safe to backport this patch 18 of a
30-patch series by itself?  "The alignmask for ahash and shash
algorithms is always 0" is definitely *not* true in older kernels.

I *think* it's probably okay.  I think this would just regress AH
performance in some cases, and "no one" uses AH anyway.

Just keep in mind this is effectively new development, which needs
review like any other kernel patch.  Not even Cc'ing the subsystem
mailing lists isn't a great approach.

- Eric
