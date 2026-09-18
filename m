Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4163B6C18;
	Fri, 18 Sep 2026 09:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789724711; cv=none; b=Zqy8rqFm2Z3bEq3yM2wbRG17LFp1KaByusrXXdBNTF8Z/WoyqBIkO/q490M8H6QmpmqKJgZizYLO5gnFGKp9bK1JP9CgaQlDyEW/iKKGQ5618OjWr04fnAIL91MXY1k55NOfK1ehQ3DaVvwP5ohcCEtXi81FnmgeJ3JXPHllmTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789724711; c=relaxed/simple;
	bh=6TLYglIIwwxsfigPK5nWuJReyXADwLqn8qkd0xAjO+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bodAKi12N9MK/zfqhTK8UAbHj/dovG+Yd3nZKDWRAD22Fkzn1vyP/d06O+zNjMePGwsq4jocQYSxxmdszQXjDkI2RUPUFapFj3eNaThchkzNvVr+As9dkywnGHNXjRsyroj6BiPrz9/NexkQ0LVM93gBqwes8w670YY3I0SkzG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Yp9qO/vO; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Yp9qO/vO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qAOOBoHhyrohJBgPrS8sxicttEG9Cbl+gLJb3pcYjq8=; 
	b=Yp9qO/vOulz2Ge8C6NtxVrB6ALquU9jI79c7EUPdKD8yQWMa99kqjMcchYxRqjuXWmjg76HnTLa
	DAAkRh4+v1nYnD/pCHIMR/YjP8L3M9BQij1g2DCQjSOrQJlACpHUA5To9y8V3sJ3TaSukFWh5OEqs
	w2VoiIpkICDryt/INZHX3Uf9HPZK1Tyveb+gJ2O/4lXvFc19mvmmqqhD7TEY+vGsGR0YR7jrshMiH
	pWAP2Ibq/tBwG9JWcnJBb8Ecup1vmwSeu2ihkGtu+a9uwkfqVQw+/bChkWYMY6OZxvarp3CVJHMH6
	91JJ785wjlRq7AsDz15rWqgudieSV/neDGHg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7V9T-0000000FLqd-3Oum;
	Fri, 18 Sep 2026 17:45:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:45:03 +1000
Date: Fri, 18 Sep 2026 19:45:03 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: markdamirkan@gmail.com
Cc: "David S. Miller" <davem@davemloft.net>,
	David Howells <dhowells@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: af_alg/hash: Report errors that discard hash
 state
Message-ID: <aq0IH8mFkBUaJkzR@gondor.apana.org.au>
References: <20260912-afalg-b4-send-20260912-v1-1-c6cf966d3f1a@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912-afalg-b4-send-20260912-v1-1-c6cf966d3f1a@gmail.com>

On Sat, Sep 12, 2026 at 01:11:14AM -0700, Mark Amirkan via B4 Relay wrote:
> From: Mark Amirkan <markdamirkan@gmail.com>
> 
> hash_sendmsg() processes large requests in several batches.  If a later
> batch fails, the common error path calls hash_free_result() and clears
> ctx->more.  The next operation therefore starts a new hash request.
> 
> The function nevertheless returns the number of bytes processed by earlier
> batches.  With failslab, a 262144-byte SHA-1 send without MSG_MORE returns
> 262128 when the result allocation fails.  A digest read then returns the
> digest of an empty input.  Retrying the last 16 bytes instead returns the
> digest of only those 16 bytes.
> 
> Return the error whenever the request state is discarded.  This also
> restores the error-first behavior used before the request batching code was
> reworked.
> 
> Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")
> Cc: stable@vger.kernel.org
> Assisted-by: Symbolic
> Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
> ---
>  crypto/algif_hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
> index 6e8b5fb82a7f1..7c1910c370ad6 100644
> --- a/crypto/algif_hash.c
> +++ b/crypto/algif_hash.c
> @@ -184,7 +184,7 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
>  	err = 0;
>  unlock:
>  	release_sock(sk);
> -	return copied ?: err;
> +	return err ?: copied;

This could be simplified to:

		err = copied;
	unlock:
		release_sock(sk);
		return err;

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
