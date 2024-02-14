Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FA42556E
	for <linux-crypto@vger.kernel.org>; Wed, 14 Feb 2024 23:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707954255; cv=none; b=DPKMP8VHsbL/BE+go9aaHtGOZreqIoMsGIz4DaKlEr66Bx0xrgMNHNPZa7Rf4YRMAfrxPTT5Tl6bjnW9Flr2ZtPjO4SnUAmkGrrFGFVJsjMJx4D3D2ZPMEMgcSgpuMsJDY7bn4pVm53BPmTdgm0w3zJFVMgKJQqj+DcYejaZAAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707954255; c=relaxed/simple;
	bh=SovgcSCUQcz6Oewmmah/YSpBnM0TLMcB4SgxM+mB79c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1aRSnY3QvmIOq/d2OOJdxbopQpN80gyRWdXhLVlOE1CTWgvz7waIrx9Ww6Zy9V9p/HKr8E6Y40WH7535l4sRmWsw6NQA1+gYo0Eu6AcbMKfxqtLAcDlksnoVQmC+MUgi4UpOW85CScskfncBS1qZLSlVrPD2xE44E1+Hr5mnMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtQkQNda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtQkQNda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE2AC433F1;
	Wed, 14 Feb 2024 23:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707954255;
	bh=SovgcSCUQcz6Oewmmah/YSpBnM0TLMcB4SgxM+mB79c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FtQkQNdaTar/RKQFNeQHWMDvV/qJ3eLqkTZmgC7kb4w7mkNyrOi8OV5F8i9EIYmc5
	 SFHFygAWM9eve+tTgnS7OgniFnuIgiSZcvURh1B1SPcIhuk4WBOlr14kEQAj9K0m0n
	 vOmph2VxJbEv3t6I4sgEzl91tDiI5TFA6zf6t+wF3Ivqpu+gslOQsBoAj19fZWGEwJ
	 Yn3tcmdKeV2lDW7h30QU372EiXaJzUJfq5RT+asBTikbra2w9v5mE9GQbqpvyMm4/Y
	 kuPr016LIe625qCq0Nnb5UnSbrz1OS7a/DsYgFAvdX/rPi1pjSX4czM/uK8Stynftl
	 1xdjh/JqtWyFg==
Date: Wed, 14 Feb 2024 15:44:13 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 01/15] crypto: skcipher - Add tailsize attribute
Message-ID: <20240214234413.GF1638@sol.localdomain>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <39cd9244cd3e4aba23653464c95f94da5b2dc3ec.1707815065.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39cd9244cd3e4aba23653464c95f94da5b2dc3ec.1707815065.git.herbert@gondor.apana.org.au>

On Sat, Dec 02, 2023 at 12:55:02PM +0800, Herbert Xu wrote:
> This patch adds a new tailsize attribute to skcipher and lskcipher
> algorithms.  This will be used by algorithms such as CTS which may
> need to withhold a number of blocks until the end has been reached.
> 
> When issuing a NOTFINAL request, the user must ensure that at least
> tailsize bytes will be supplied later on a final request.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/lskcipher.c                 |  1 +
>  crypto/skcipher.c                  | 16 ++++++++++++++-
>  include/crypto/internal/skcipher.h |  1 +
>  include/crypto/skcipher.h          | 33 ++++++++++++++++++++++++++++++
>  4 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
> index 0b6dd8aa21f2..2a602911f4fc 100644
> --- a/crypto/lskcipher.c
> +++ b/crypto/lskcipher.c
> @@ -300,6 +300,7 @@ static void __maybe_unused crypto_lskcipher_show(
>  	seq_printf(m, "ivsize       : %u\n", skcipher->co.ivsize);
>  	seq_printf(m, "chunksize    : %u\n", skcipher->co.chunksize);
>  	seq_printf(m, "statesize    : %u\n", skcipher->co.statesize);
> +	seq_printf(m, "tailsize     : %u\n", skcipher->co.tailsize);

Do we really want to add new attributes like this to /proc/crypto?

I worry about userspace starting to depend on these algorithm attributes in a
weird way.

What is the use case for exposing them to userspace?

- Eric
