Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72948351C17;
	Fri, 18 Sep 2026 09:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723822; cv=none; b=qqid/eMFEEhAE3OxhdoI1QaTR26ZAOKxEB0TRaSk96HbaJzkkm5w7NeMizq6ESTbUq4nHXsSjEIcgY53m+aciy2tndv4I1/pmzWh4r8cMvaY0OR+M+W7RNzLlw/w0b6fh5VhudYnkso+EWuSka1JvrJVVoq4nVkPjHXRgbf59OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723822; c=relaxed/simple;
	bh=ukoItSd2dC2ievn05JkDuqVXifwHWgWGJCQz9B0uBss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XZvTDtfsL8qXB/HupfWh6Ev8/uvZpE+7okLbqjvygdOYUg/i3rAeKxD8kmzEdGneqLazSc2OQG2UTpY6PPt+02MDskilj+xZgSJY/cSUqFVp1SVk57w95QgHpqM32jQiQi6jqdpaQjGYQ98ZseZNpiGVmKKYWVatZX9YdUxOLpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=G2vg1l5q; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="G2vg1l5q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lMR92ThYf5j5ZXMSPAOePMJHPvQhXXyNH7YKDce1HqQ=; 
	b=G2vg1l5qXwKs8XsWp+DTE6cpLvVetf/w9VxN4WsyRU8eAOOGeyznd8veGeNolqyyRQq5WI88evq
	FbgUJBGCb4KApaFKnmGoz5v08x77ApS/r53u/sbAJi9yyrFIj12UHVZjnl39h+DJ2VmVsVY4oBFHi
	GKxm/PbJ6NjKXHeZ/+uZ+R/eG5+xlCmnZ1URt01m4a2QYgTesWI4D+w9gANO6ZkT70mD4VzV1geD+
	JmILl/r9M0mRz4GSd78TDP5wRpfCvd9fisO0C3vTJG5In2fNgTA72Vx44v627ty50ejoroOnVgry4
	xWLLDJMl6ciUsSxXCePtvdAzawBj9wAAraRw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7UvA-0000000FLSA-0JBM;
	Fri, 18 Sep 2026 17:30:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:30:16 +1000
Date: Fri, 18 Sep 2026 19:30:16 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/19] crypto: talitos/hash - Use
 CRYPTO_AHASH_BLOCK_ONLY API
Message-ID: <aq0EqCdvLsjCn_EY@gondor.apana.org.au>
References: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
 <20260907-7-1-rc1_talitos_cleanup-v5-1-860f43cd7317@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907-7-1-rc1_talitos_cleanup-v5-1-860f43cd7317@bootlin.com>

On Mon, Sep 07, 2026 at 03:22:35PM +0200, Paul Louvel wrote:
> The hash implementation maintained a software buffer to accumulate
> partial blocks across update() calls, copying data to/from scatterlists
> with sg_copy_to_buffer()/sg_pcopy_to_buffer() and chaining in a virtual
> scatterlist entry.  This is unnecessary now with
> CRYPTO_AHASH_ALG_BLOCK_ONLY flag.
> 
> Remove unnecessary fields in the request and export structure. On
> completion, pass any remaining tail bytes back via
> ahash_request_complete() so that the core re-submits them with the next
> request.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
>  drivers/crypto/talitos.c | 178 +++++++++++++++++++----------------------------
>  1 file changed, 70 insertions(+), 108 deletions(-)

Please review the Sashiko comments and they seem to identify real
issues:

https://sashiko.dev/#/patchset/20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a%40bootlin.com

> @@ -2111,6 +2052,8 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
>  	ret = talitos_submit(dev, ctx->ch, &edesc->desc, ahash_done, areq);
>  	if (ret != -EINPROGRESS)
>  		free_edesc_list_from(areq, edesc);
> +	else
> +		req_ctx->message_size += nbytes_to_hash;

Once you submit an async request the request should be considered
to be gone because it may have been freed before the return.

So this update should go to the place where the request is
actually processed and before the completion function has been
invoked, e.g., ahash_done might be a better place for this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
