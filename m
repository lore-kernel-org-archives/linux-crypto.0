Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6F819B5B4
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 17:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741282482; cv=none; b=qkLdeTJHPgHEizYITC46MPegwt0doKes5DGFhG6RhsXdjM+pykkraUpZGkNNJ3YHKRtt+bGMzpzJQ01weQoWkoMcOuu71dPoRqdLDtZT1d2i3GGj5VGYvUN9ZhI/CV7rHK40MeSTz9vqNdHftrZFXAxMWgtyQHrR0+wspWKjWgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741282482; c=relaxed/simple;
	bh=Z9//5D1Yfbmh6gllOwzcOtbRix0xgb5zL+xdH8cxXkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gejrMh3XvPmLc02jYVQljVZb0Fk8Fpy049MpNltjTRPGq7BQd+rtDd0seLn8buQf71H/dQBBMBNmLn9JOBoqCFCiOpuFtJRQyMUOHmHsz+JRztG6U+QysxqVKzGSDKotdwX/febnCaKFLO6e4eaiIF0RpdlZITfvHjn80UmdRMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3HEcFyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3HEcFyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580D3C4CEE0;
	Thu,  6 Mar 2025 17:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741282480;
	bh=Z9//5D1Yfbmh6gllOwzcOtbRix0xgb5zL+xdH8cxXkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y3HEcFyzF1Cf89eeY1urJjYXG7Eex4hNXnosdUxwObQEOkPKefkm4p/AX5ad8N01A
	 ZARoStmrEfzhlQWltnsJKLSWyg4jxF+GFqi6c/UH+4BmmmMjwaCyO4iXQ7YaCGw7Kk
	 wpJUpGESgo6wrW9OfTX4xKIvjcDd4cO76UyN36NtbPYGEAbW2V1/M9PgmloOu68Kn7
	 uMjxYwIYsH04xFOWa8m5uPNM7zQQm+wO58y3rfinen3zv0u0CLdqNTNKSajOD/VqKx
	 HjYd6P93C2+w0MWEU/Jt8C2JpcbOOPxStipEFe1+VNfC7OgBVIlfewZVOPL8/sdyI3
	 fbdo91hyYVDAQ==
Date: Thu, 6 Mar 2025 09:34:38 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: scatterwalk - Change scatterwalk_next calling
 convention
Message-ID: <20250306173438.GG1796@sol.localdomain>
References: <Z8kOABHrceBW7EiK@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8kOABHrceBW7EiK@gondor.apana.org.au>

On Thu, Mar 06, 2025 at 10:52:48AM +0800, Herbert Xu wrote:
> +static inline unsigned int scatterwalk_next(struct scatter_walk *walk,
> +					    unsigned int total)
>  {
> -	*nbytes_ret = scatterwalk_clamp(walk, total);
> -	return scatterwalk_map(walk);
> +	total = scatterwalk_clamp(walk, total);
> +	walk->addr = scatterwalk_map(walk);
> +	return total;
>  }

Maybe do:

    unsigned int nbytes = scatterwalk_clamp(walk, total);

    walk->addr = scatterwalk_map(walk);
    return nbytes;

Otherwise 'total' is being reused for something that is not the total length,
which might be confusing.

> @@ -149,32 +150,30 @@ static inline void scatterwalk_advance(struct scatter_walk *walk,
>  /**
>   * scatterwalk_done_src() - Finish one step of a walk of source scatterlist
>   * @walk: the scatter_walk
> - * @vaddr: the address returned by scatterwalk_next()
>   * @nbytes: the number of bytes processed this step, less than or equal to the
>   *	    number of bytes that scatterwalk_next() returned.
>   *
>   * Use this if the @vaddr was not written to, i.e. it is source data.
>   */

The comment above still mentions @vaddr.

>  /**
>   * scatterwalk_done_dst() - Finish one step of a walk of destination scatterlist
>   * @walk: the scatter_walk
> - * @vaddr: the address returned by scatterwalk_next()
>   * @nbytes: the number of bytes processed this step, less than or equal to the
>   *	    number of bytes that scatterwalk_next() returned.
>   *
>   * Use this if the @vaddr may have been written to, i.e. it is destination data.
>   */

The comment above still mentions @vaddr.

- Eric
