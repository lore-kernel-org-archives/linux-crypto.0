Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B538D19AD48
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 21:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741384093; cv=none; b=uQcfcoNnBMEPnnjz2gFf8S26yLgKbGVTkGhgjSUIhufl95Z9Oh6O8hY4wni+ndR7DnvlCOH5f+NM2ZOTEVGwEKwNY5DI1+9fyHX2w5Y0XKrNAm2HtW5K7YzYLxsn8aBEJbDHPw4dhFkAl8bRC5oNPG994M9ozMTRNvASbksPtA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741384093; c=relaxed/simple;
	bh=sHp1T5hXxGSl5GnlgrFcufCKagWU3o5pUCX30yMhdwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gbFM+EuC+/AxBBZfY723mXZ4okVF+xYSnrOF87gbcfSEvbuhZgg6PwNyJly8dehcK/WxXGfi6m5h8sU71bUWhZHMFfurmBBPHjE747FgaSf+p5kXBbRYnEWcD92xedZEdj9k6XQELFpTT0BYED/JovSiBrZfGvOjjegJUc9a8bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBjmAtAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBjmAtAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB5BC4CED1;
	Fri,  7 Mar 2025 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741384093;
	bh=sHp1T5hXxGSl5GnlgrFcufCKagWU3o5pUCX30yMhdwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jBjmAtADj4LeoVZOtIbF5YJszah3gkXwJFcEYA9w62owRKhy2zZJNRFTE+/JbcMTY
	 O26XLagE7VrrTixRPJuaUdzNNXAOaZ0ordARbxNPmqWlidnol9jNsDHaHnPsPZbS2+
	 8naHTgim3g891rcLZuGckVAfzB4UDgRaqvQgScHdTRCGjgBLTo2uE6hahYZUxNfcmY
	 5M4WOXkJpnvmBO+0jt3+dR4yCZthiDXAXgQu9ExL7Txf3/LkZ3hpSThps0Ex4eVo9Z
	 es0jx7dVeN63buholAowPmObkolVVj4FQH5vIiA/RXLDDKeX0QDu1eR2BM4sa7oc7k
	 5/bEIewzS3u/Q==
Date: Fri, 7 Mar 2025 13:48:11 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 3/3] crypto: skcipher - Eliminate duplicate virt.addr
 field
Message-ID: <20250307214811.GC27856@quark.localdomain>
References: <cover.1741318360.git.herbert@gondor.apana.org.au>
 <2234a3dc7c2765c6067824288961f9d6841a5b0a.1741318360.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2234a3dc7c2765c6067824288961f9d6841a5b0a.1741318360.git.herbert@gondor.apana.org.au>

On Fri, Mar 07, 2025 at 11:36:21AM +0800, Herbert Xu wrote:
> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
> index 92def074374a..24bb78f45bfb 100644
> --- a/crypto/skcipher.c
> +++ b/crypto/skcipher.c
> @@ -43,14 +43,12 @@ static inline void skcipher_map_src(struct skcipher_walk *walk)
>  {
>  	/* XXX */
>  	walk->in.maddr = scatterwalk_map(&walk->in);
> -	walk->src.virt.addr = walk->in.addr;
>  }

This patch makes all the callers of scatterwalk_map() assign the returned
address to the struct scatter_walk itself.  So that should just be done by
scatterwalk_map() itself.  Then skcipher_map_src() and skcipher_map_dst() should
be removed and the callers updated to use scatterwalk_map(&walk->in) and
scatterwalk_map(&walk->out) directly.

> @@ -214,7 +209,7 @@ static int skcipher_next_fast(struct skcipher_walk *walk)
>  		(u8 *)(sg_page(walk->out.sg) + (walk->out.offset >> PAGE_SHIFT));
>  
>  	skcipher_map_src(walk);
> -	walk->dst.virt.addr = walk->src.virt.addr;
> +	walk->out.maddr = walk->in.maddr;
>  
>  	if (diff) {
>  		walk->flags |= SKCIPHER_WALK_DIFF;

Note that this will have to be rebased on top of
https://lore.kernel.org/r/20250306033305.163767-1-ebiggers@kernel.org
(sorry for missing that earlier).

- Eric
