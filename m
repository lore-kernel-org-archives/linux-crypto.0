Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3733E5A2B;
	Wed,  5 Aug 2026 20:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962257; cv=none; b=sBG2zLUsyiTqS/gdbaWWGd7UB+ouWlhWutkFyak7aczDVvPnYCVj6pqeg3v1Wl7h1pnCW6TLWgVWt6IP6rqWkPYtcb/qvpFtExJ0rhj8gKr6iQGetKEo7txQORADzr3BktcC0KFNaaqH4y5MN/qU4nx3kbrkcKImspvy5rA/jbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962257; c=relaxed/simple;
	bh=pUlAXpmiS0ebZxuRgi7k58UccycbFv2zWRu6hDFfrMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/L+aEvcHFSvjbIn6M3bugITrF4AkfsOVXgaz9K8+GcPgUrpeZ8sf2AkOp+/bOT3C6Z5F9Re8ETwaFXJjMJ4yXzkHGAsplJuSEMSxgO9B6Xn+KlAP2KqgBs17zozm0mVZdwhTVCGIrekw8V+SR6NRINSt5b+thZaz4yNylvxfZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B55OTeJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B55OTeJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4771F000E9;
	Wed,  5 Aug 2026 20:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785962255;
	bh=B2Wi7wFOq/cqhSSoNG2UfdKLMCbz5UclJJvWFppwhHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B55OTeJvlTf14GiubOZz07CucslUl6BZId92Lnd+tcU4f9DFc4hSc7eQM0D+isNQ1
	 jnOnuY13YYoTP1h6cfhIs11/Ofierf3mOWgQ3eX66fF/0hMGoQJVnR7pAe0wzDaeWj
	 ccYlF4jy64zipUmbARylyS9fSrrcS73fazA6piTI8PwfwgGdX4Hl7zWrN7Rl4ScoxD
	 a9PJ3G3AVMSd2PgtZefT+ZsACXlE6ZGTFxOCn/9DMzt2KP4ZEk+VgnTVqQPcCpckPL
	 puO8T7Jfwe0wqMz/CuzDAVa8isDFje5CJ98JIRD4KWJd1KMY5GnP0x0ZikVO3fD/h6
	 3fYdRm00+Z2Zw==
Date: Wed, 5 Aug 2026 13:37:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] crypto: Provide wrapper functions for zeroizing
 aes_cmac_key and aes_cmac_ctx
Message-ID: <20260805203734.GF3438@quark>
References: <20260805143611.818559-1-thuth@redhat.com>
 <20260805143611.818559-2-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805143611.818559-2-thuth@redhat.com>

On Wed, Aug 05, 2026 at 04:36:04PM +0200, Thomas Huth wrote:
> crypto: Provide wrapper functions for zeroizing aes_cmac_key and aes_cmac_ctx

    lib/crypto: aes-cmac: Add zeroization functions

> +/**
> + * aes_cmac_zeroize_key - Clear a aes_cmac_key structure

aes_cmac_zeroize_key() - Zeroize an aes_cmac_key structure

> + * @ctx: The location of the key structure that should be zeroized
> + *
> + * Explicitly fills the aes_cmac_key with zeroes. This should be done once
> + * the key is not required anymore to avoid that its contents are leaked
> + * on the stack or heap.

The mention of "heap" is kind of misleading, since normally
kfree_sensitive() would be used in that case.  Maybe add: "Only required
if not using kfree_sensitive()."

> + */
> +static inline void aes_cmac_zeroize_key(struct aes_cmac_key *key)
> +{
> +	memzero_explicit(key, sizeof(*key));
> +}

Also maybe put the function definition right after the definition of
struct aes_cmac_key itself, and likewise for struct aes_cmac_ctx.  Then
they would be closely paired with the corresponding structs.

> /**                                                                              
> * aes_cmac_zeroize_ctx - Clear a aes_cmac_ctx structure   

aes_cmac_zeroize_ctx() - Zeroize an aes_cmac_ctx structure

Could we also get notes in the kerneldoc for aes_cmac_preparekey() and
aes_cmac_init()?  For example:

    "On success, the caller should ensure that the prepared key is
    zeroized at the end of its lifetime, e.g. by calling
    aes_cmac_zeroize_key() or kfree_sensitive()."

and

    "The caller should ensure that the context is zeroized at the end of
    its lifetime, e.g. by calling aes_cmac_final() or
    aes_cmac_zeroize_ctx()."

- Eric
