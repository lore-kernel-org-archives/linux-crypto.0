Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D1E3EC687;
	Thu,  8 Oct 2026 08:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448534; cv=none; b=LGr3qrZg8aIl6gy0ht4MsWZB+asssKWPX/P4ZTcbhSYgMmF6sL3EWcDjyVg9RsZGMMoeYxj9qQl/Quf+le4o/B2Ea68/nR5DiFVkg0DhWfEgCNI/1SoXPn46lYg2KwcUBBR7ltEHGSddhhVjIx1zAapXvMDSkHD2Yc8MRi9uRng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448534; c=relaxed/simple;
	bh=ZesY1Y5yCPzTMzqwSHn1I1JQn5haocBLKRMhSM8rRP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTjtPoUweLST69DOYcB1DoqV+stR9UwRiQuG6H8I90aLEOaDBn1Zcz8dRiFGpACurQiGsE7tkbexqbI+S5csvh52ZYeDzjnzeC3PbmNpgf5C7DzWUtQglenzwLNqBJmd/WW5p6WI8sz2vxW08+LbzC4yJM4eKAoylg4eKxJhvsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=EJN7pIsI; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="EJN7pIsI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=s2Ray92q6Vmgf55HUr1VGCUVBdkkO0DjyIM5lhthz7I=; 
	b=EJN7pIsIGeo72dNY8XzKRQTcAWf5B+9ncRDI9R8bdlKZfx7YMgi4PDZPhZLbsLQ6x+ptNNyYXjU
	CW2IQf3doIlkXneU9b483E5eZSkxbgxEfgy8glz7H78FGx8dZL184T5GJGiGPbueP0MPGAnUBVYuk
	bLkzm+4dleewvrj+tYMBZISKr7aRdeWSWWJdcsL2BPUwK/5kF8tBFyanWxuBpSbWl3aGZa3qUyj4L
	Npytki0Q3iodeQjwVXI8d2JExSeUmwPvHSXrPPvzYGE4Em2R8iCs8cEGKqIjkLY+4VH8sU8nGXW1I
	Pb5F2msazMk3lP1jMgw6WhcLa7Kk2L9Ovo6Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjaz-00000001o7M-3enA;
	Thu, 08 Oct 2026 16:35:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:35:21 +1100
Date: Thu, 8 Oct 2026 19:35:21 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v9 00/14] crypto: qce - Fix crypto self-test failures
Message-ID: <asdVyUKWndnZ1Mxv@gondor.apana.org.au>
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
 <ar9qNirrzOTDLipN@gondor.apana.org.au>
 <CAMRc=MdRBu5gg7Q3pz8Wn9Da4RpmmiKLP2-LwiszKCd3o8jQdQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MdRBu5gg7Q3pz8Wn9Da4RpmmiKLP2-LwiszKCd3o8jQdQ@mail.gmail.com>

On Fri, Oct 02, 2026 at 10:31:41PM +0300, Bartosz Golaszewski wrote:
>
> > Please check the Sashiko comments:
> >
> > https://sashiko.dev/#/patchset/20260922-qce-fix-self-tests-v9-0-b1aa742e79af%40oss.qualcomm.com
> >
> 
> I've gone through them. None of the issues were introduced by this series, all
> are pre-existing. I've added them to my list and will fix them. Can we not
> delay this series any longer and instead work in smaller steps since the crypto
> algos will be disabled by default anyway?

The very first comment appears to be pointing to new code:

> > +/*
> > + * BAM DMA cannot handle zero-length transfers, so the driver always holds
> > + * back at least one byte to submit to the engine. A zero rctx->buflen at
> > + * finalization time does not necessarily mean the message is empty: the
> > + * caller may have imported a state that already reflects some hashed data
> > + * with nothing currently buffered. Handle both cases through the software
> > + * fallback: reconstruct the running state when there is one instead of
> > + * assuming the message is empty.
> > + */
> > +static int qce_ahash_finalize_zero(struct ahash_request *req)
> > +{
> > +	struct qce_sha_reqctx *rctx = ahash_request_ctx_dma(req);
> > +	HASH_FBREQ_ON_STACK(fbreq, req);
> > +	struct __sha256_ctx core;
> > +	struct scatterlist sg;
> > +	int ret;
> > +
> > +	sg_init_one(&sg, NULL, 0);
> Can this trigger a kernel panic during zero-length finalization?
> qce_ahash_finalize_zero() creates a dummy scatterlist by calling
> sg_init_one(&sg, NULL, 0).
> sg_init_one() unconditionally calls sg_set_buf(), which attempts to resolve
> the page via virt_to_page(NULL).
> If CONFIG_DEBUG_SG is enabled, this triggers a BUG_ON(!virt_addr_valid(buf))
> kernel panic, because 0 is not a valid linear map address.
> If disabled, it results in a bogus PFN being stored in the scatterlist,
> leading to potential invalid memory access during software fallback operations.
> This path appears reachable by untrusted userspace via AF_ALG performing a
> zero-length HMAC finalization.

How is this a pre-existing issue?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
