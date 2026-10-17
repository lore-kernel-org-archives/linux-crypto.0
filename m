Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47C837A846;
	Sat, 17 Oct 2026 05:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792213652; cv=none; b=jQ9lRgfimTwMtIXlLUeVqawwadlE6HAa3g7d+DfuTK2ypaB7jbcNwlcy+0hXG5LqrNXwtSlhVq3y6SoVDjt1sc/LbBb2P4BdzxX07Kt7ttpyP7YB/wleLFlgDOjxZ2c5Ctm4JIuII3e6CTnbiic4khZTREcE27ocB9EGkYOHc5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792213652; c=relaxed/simple;
	bh=ZmTRlvew0CRM2W8eTbSVN8nEkxlmDho0fnArFkIhsoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3M4zHSGVQSw7qWTR8d8hgL2koOTsH8eIpMQtlM9Lmt+HL+TDjTvFEJ0aih6yBhUh93oEefQ2bvfPtSxRJvVeL0MiBLSqUAjj8dKFd0YxOb5H/VO9E1MDjVNP3RkX68HuYVOCKPowsK4DfB5Sm1SVDxGc+IWS/IGJ/5aAVRHCnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KorvX6et; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KorvX6et"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GS+AsPIGu7yHRqy2jnr1W3dVbHJLUv2AWFzFOh/wFDY=; 
	b=KorvX6etA1H1LwYIHbjwREizKszwt/mxjdfcD2DUylxpmdQYv2zpOgDwRmP3YPR0RmUpdWJzQGo
	oPQjy4KW8cqA89aYUI5lEIpnepflISPJVyh43PIXf01uhiXJsHVmc8KG6lvkfNzWa3o+4ccLxYzDF
	xcExs5PGftzWLR1dcge0eepyH/FsiBSyR+QnUgSPGvbev7iTd2NPPiL94Uj0KrmY9TM4/3LsBMP1S
	YfbqM04tYbW/ZSI7dmX3kDOqVLbPxO4WHZbxEIFxkv1zLB7XrSEXc/JnWqU1FsoAgs8olJHf2MHJq
	pp/6MNEQiBIGs3aTInov8ui1iePsiz84tT+A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHwdS-00000004n42-0Bu1;
	Sat, 17 Oct 2026 13:07:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Oct 2026 13:07:10 +0800
Date: Sat, 17 Oct 2026 13:07:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atMCfhB63koot230@gondor.apana.org.au>
References: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au>
 <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au>
 <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>

On Fri, Oct 16, 2026 at 10:02:13PM -0700, Kanchana P. Sridhar wrote:
>
> > What if you just do the conditional and short-circuit in
> > crypto_acomp_compress?
> 
> Yes, this is the first option I tried (20,946 KB/s).
> 
> [1]:
> 
> int crypto_acomp_compress(struct acomp_req *req)
> {
> struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> 
> if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
> return -EAGAIN;
> 
> if (likely(req->unit_size && acomp_request_issg(req))) {
> if (likely(!crypto_acomp_req_seg(tfm))) {
> int err = tfm->compress(req);
> 
> req->dst->length = unlikely(err) ? err : req->dlen;
> return err;
> }
> 
> return tfm->compress(req);
> }
> 
> if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
> return tfm->compress(req);
> 
> return acomp_do_req_chain(req, true);
> }

That isn't quite right though.  We need to ensure that it really
is a singleton before taking the short-cut.  So you need at
least one conditional:

	if (likely(req->unit_size == req->slen))
		take short-cut

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
