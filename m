Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2C1183CA8
	for <linux-crypto@vger.kernel.org>; Tue, 24 Sep 2024 22:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727218661; cv=none; b=tomcnWUvfB6rJwCT9z+3AXx5CsdjXznlmusEtK18KEMBPSBZG+nxsaJb01Ent84tBAD2GME7cn2U+gDbLCYiO+oalkis7/CqRU/LWLZ5w6x7Obmgvjhlsf9JVEbDHDal6TeOXcK6OOZQ7rO+GhkSTRDWFyQ/a9usVGwi7S9bs40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727218661; c=relaxed/simple;
	bh=85b7hF/vcV9tStQSx/9ERnTAqMlok4iOcIY8T5l0AB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GwM5WFlAh79p0NA1GACNVLKvyB3kssGe077Aruyd9skcS3/pN30Dh8eYCfgUCJWPjj4JTP/ga7B0G+XzDjItGFIGgD81SvdTE2d17/BgkoBLNEkdFJz7hEhXFwzFn9b4PEWKklv5Hz260iOleK9WEn2yFnEYyyRu3BhzAB6vzKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwwrCpri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwwrCpri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A02EC4CEC4;
	Tue, 24 Sep 2024 22:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727218661;
	bh=85b7hF/vcV9tStQSx/9ERnTAqMlok4iOcIY8T5l0AB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GwwrCpriDoiKIZJ+nc/Tj83rWAyN00Z2qSkD59FXIgV9VSVnbJ3ucrzoyDKIyZWCd
	 Z7dSGJhxTi0dTz0Ixo2e3VgXeBwzfuYWtMtbIZ7zShl8flEd2WXnyY5olTiJsmwh0U
	 SYr1iEvLXlHWqFmS1ykxEd00ccQ9ZW9JynDCbec80qTTSNDOCOl66LEfv3PBCw+I1a
	 T8jUxrUmOaGhBZVw/51FPwKndLT6z//Z7hy/12iBbv3MvH+/w+HySdinY/ejgJ1rsq
	 khbWjk8o7YhT4Ok6PqIMk0/3VYnUKMe2H9nezxrE51+pkqntb74JdvrzhOSgRK+Ssu
	 ypibFZQMbPS7Q==
Date: Tue, 24 Sep 2024 15:57:39 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Harsh Jain <harshjain.prof@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>, h.jain@amd.com,
	harsha.harsha@amd.com, sarat.chand.savitala@amd.com
Subject: Re: HASH_MAX_DESCSIZE warn_on on init tfm with HMAC template
Message-ID: <20240924225739.GE1585@sol.localdomain>
References: <CAFXBA=kKHa5gGqOKGnJ5vN=XF9i3GB=OTUZZxbfpU5cks=fW3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFXBA=kKHa5gGqOKGnJ5vN=XF9i3GB=OTUZZxbfpU5cks=fW3A@mail.gmail.com>

On Mon, Sep 23, 2024 at 12:39:11PM +0530, Harsh Jain wrote:
> Hi All,
> 
> We have observed self test failure with hmac(versal-sha3-384) in
> init_tfm callback.
> 
> [   14.672021] WARNING: CPU: 1 PID: 578 at crypto/shash.c:495
> crypto_shash_init_tfm+0xac/0xd0
> 
> In init_tfm ("versal-sha3-384") we increase the descsize with
> crypto_shash_descsize("sha3-384-generic") . When HMAC template is
> enabled, it add 8 more bytes in descsize and reports warn_on because
> descsize is 376 which is greater than 368 (HASH_MAX_DESCSIZE).
> 
> HMAC            versal-sha3-384         sha3-384-generic
>     8         +              8                 +            360           = 376
> 
> What should be the preferred fix for this.
> 1. Increase the size of HASH_MAX_DESCSIZE macro by 8.
> 2. Register "versal-sha3-384" as ahash algo.

There's no versal driver in the upstream kernel, so it's not entirely clear what
you're talking about.  But if you're just adding a new SHA-3 implementation it
should use 'struct sha3_state' as the descriptor context, like the other ones.
For HMAC that gives 8 + 360 = 368, i.e. HASH_MAX_DESCSIZE.  The extra 8 bytes
that you're somehow adding to get 8 + 8 + 360 should not be necessary.

- Eric
