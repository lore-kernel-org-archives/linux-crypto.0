Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F7C2459F6
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 21:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741383831; cv=none; b=uQxhYqt3FiDjodFtE5pRbxNITkU0mxcrfOB+V0ftcJLKN45s0SIyC1AKtMRY69q/xm2kFLH15kfT35Jxo01KIf+PUF+gF4O0mw7obdv9aVDO1nYUajZhGY9vJZAt5RMV2Yvm97Lx8GnzvNm+JQdDhpxODfR3XpNTdDD70YV4O44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741383831; c=relaxed/simple;
	bh=oGlUp5Lq3gubBiAY8YwK/w//K4pFb20QNqgAZIXME2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W+YqEY1KgDCifZMEoZ4xFli+4oPA59sDZ1tVE0tgboXyFxw0Yxai3MYpLGATtIn+fSslqP1CYWN2Q+gdsWN/qnHm0ShPtndoDxch9xGL4qc5etF2BGhLkV3bvvTKTUlzm+czX2bhstO7ANP651IvMnqn8CTCNbK6q7fyagGiVQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luCBpwXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luCBpwXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51BFC4CEE5;
	Fri,  7 Mar 2025 21:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741383830;
	bh=oGlUp5Lq3gubBiAY8YwK/w//K4pFb20QNqgAZIXME2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=luCBpwXIq/4MWmLTi0NuMnTJIdLUuRixkH4VAgoWb3S0bjgUr1zth8Hja7kx/VNyM
	 Lq0yJmdwBzesb/7oaDWwbSV+Srb8SeoNomrAnbBzdwkJMC+SY8kgwsZhnkPuT/Uqg4
	 Mbme+X28kJXTMJBnzsI0FosTw/Enuwf28d526Wh65oqFhzbypsjK1UqMhSsxjpWIxx
	 RV5RHSu5QZQoPR2Ds351BPzoRciVWtHCtW+ssd9KLZMmrB5D5btuTvebUaa0xcvOiz
	 oCCNSoKZqkuX/J6cBp1OZfjCaqr29rraTEZzfaSI5oBHvL3fHn/2J4wGVgzHjTidwL
	 RcEXNM+93RJKw==
Date: Fri, 7 Mar 2025 13:43:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 1/3] crypto: scatterwalk - Change scatterwalk_next
 calling convention
Message-ID: <20250307214349.GB27856@quark.localdomain>
References: <cover.1741318360.git.herbert@gondor.apana.org.au>
 <2b608ececa9eee4141391ee33dcb7d59590b9280.1741318360.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b608ececa9eee4141391ee33dcb7d59590b9280.1741318360.git.herbert@gondor.apana.org.au>

On Fri, Mar 07, 2025 at 11:36:16AM +0800, Herbert Xu wrote:
> diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
> index 11065978d360..8f1dfb758ced 100644
> --- a/include/crypto/algapi.h
> +++ b/include/crypto/algapi.h
> @@ -54,6 +54,7 @@ struct rtattr;
>  struct scatterlist;
>  struct seq_file;
>  struct sk_buff;
> +union crypto_no_such_thing;
>  
>  struct crypto_type {
>  	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
> @@ -122,6 +123,12 @@ struct crypto_queue {
>  struct scatter_walk {
>  	struct scatterlist *sg;
>  	unsigned int offset;
> +	union {
> +		void *const addr;
> +
> +		/* Private API field, do not touch. */
> +		union crypto_no_such_thing *maddr;
> +	};
>  };

This is okay (it makes it a bit easier to accidentally use addr after it was
unmapped, but it's probably worth the simplification in code), but I think using
'void *__addr' would be more consistent with other places in the kernel that use
a similar trick to have something both const and non-const.  For example
struct inode in include/linux/fs.h has i_nlink and __i_nlink.

- Eric
