Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2ED1DE3DB
	for <linux-crypto@vger.kernel.org>; Wed,  7 May 2025 17:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746638209; cv=none; b=gw3F9eScVsQtF5FJocuC8KPe0KTjLSyrrfZUulroD1Ripl4j1x21d+fND0cwHeD8ziqTlHN7nKuSJpKToMaHffK3olN0N4JSxIHFqh4hEy2Tdq+0MoY0xtoEcMUsrFcgZHWkeofbogW/4YoDAMOeQPinWOqHs9gGw7XEneX8KrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746638209; c=relaxed/simple;
	bh=RdVOkr3onQv8r+hrY3a4B7h0AH1uaDelHc0766sSH7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JA1JlzuELKuKxdPi5U02V/46OzFTxNJYqN0WNYQHz2T5nRJMAENsyM7DPDVAuf4OzjPuq3lzpUjXkUHz0nyr2O08QknjQIl9j9BjsJK8Yd/x/0FRHwJ1T6FGRTndHommJWoL27jdWDvKHKIbw4QAjIFLfF46ouFgtG7uEisTwOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klszOqwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klszOqwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3218DC4CEE2;
	Wed,  7 May 2025 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746638209;
	bh=RdVOkr3onQv8r+hrY3a4B7h0AH1uaDelHc0766sSH7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=klszOqwP5xY1QGGVR0rIUlpJsoP36UqlNSUUoAlaj3qy4ZQdDL5g6/F/MjUhDAT5X
	 lsZ7c0be0IXwmmDT7dlCO1dE7X4opim4tilSK9YrngkZAVWjwSpfkWEUkCAudsdc/z
	 BjAgLA9wN/wTtbCDk+7RIt/mBLZ6/hKH5nindKW6nYmm8uFEa+p8FbyTXX4x814uve
	 ZNFtdMzrPx/fXBqbAAegl62b3OeWLBefnNSrjUq98voJiLVcxsrHIWhRWkygTKJ4rU
	 bbxr9XpZVXyuJnQSC8QzSZzqZ/0Kw5XSFHVu0n2TKuwkcHU2yd6epnJt0fCRCsOR1l
	 EveJcjOyzK+XA==
Date: Wed, 7 May 2025 10:16:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 2/3] crypto: acomp - Add setparam interface
Message-ID: <20250507171644.GB181648@sol>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <74c13ddb46cb0a779f93542f96b7cdb1a20db3d4.1716202860.git.herbert@gondor.apana.org.au>
 <aBoyV37Biar4zHkW@gcabiddu-mobl.ger.corp.intel.com>
 <aBrDihaynGkKIFj8@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBrDihaynGkKIFj8@gondor.apana.org.au>

On Wed, May 07, 2025 at 10:20:58AM +0800, Herbert Xu wrote:
> On Tue, May 06, 2025 at 05:01:27PM +0100, Cabiddu, Giovanni wrote:
> >
> > > diff --git a/crypto/acompress.c b/crypto/acompress.c
> > > index 6fdf0ff9f3c0..cf37243a2a3c 100644
> > > --- a/crypto/acompress.c
> > > +++ b/crypto/acompress.c
> > ...
> > > +int crypto_acomp_setparam(struct crypto_acomp *tfm, const u8 *param,
> > > +			  unsigned int len)
> > Is the intent here to use strings to identify parameters? In such case,
> > `len` should be called `value`.
> > Or, is `param` a pointer to a structure?
> 
> param is just an arbitrary buffer with a length.  It's up to each
> algorithm to put an interpretation on param.
> 
> But I would recommend going with the existing Crypto API norm of
> using rtnl serialisation.
> 
> For example the existing struct zcomp_params (for zstd) would then
> look like this under rtnl (copied from authenc):
> 
> 	struct rtattr *rta = (struct rtattr *)param;
> 	struct crypto_zstd_param {
> 		__le32 dictlen;
> 		__le32 level;
> 	};
> 
> 	struct crypto_zstd_param *zstd_param;
> 
> 	if (!RTA_OK(rta, keylen))
> 		return -EINVAL;
> 	if (rta->rta_type != CRYPTO_AUTHENC_ZSTD_PARAM)
> 		return -EINVAL;
> 
> 	if (RTA_PAYLOAD(rta) != sizeof(*param))
> 		return -EINVAL;
> 
> 	zstd_param = RTA_DATA(rta);
> 	dictlen = le32_to_cpu(zstd_param->dictlen);
> 	level = le32_to_cpu(zstd_param->level);
> 
> 	param += rta->rta_len;
> 	len -= rta->rta_len;
> 
> 	if (len < dictlen)
> 		return -EINVAL;
> 
> 	dict = param;

That sounds crazy.  There's no need to serialize and deserialize byte streams
just for different parts of the kernel to talk to each other.

I'm still skeptical about the whole idea of trying to force people to go through
the Crypto API for compression.  It just results in the adoption of all the bad
ideas from the Crypto API.

- Eric
