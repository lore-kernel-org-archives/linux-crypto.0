Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C79E13C9C7;
	Wed,  5 Jun 2024 19:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717614852; cv=none; b=CoZclH4MK5o1FMnoLTbu8uW2//+wV1JscN8k8EMLkEnVxe5gBdPlEHQk8QsQOUb/brs9h8M2puScqSI0aKxuJMTc8HIpm4z8wFc4GUkxRO1sfuWEuIvf4VrAms12sfZLGeSe1h0jW4Urk4QRJTPltPrOCj+/2WpIxKl0Bq8Dct0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717614852; c=relaxed/simple;
	bh=anJCOkwW/JCOoSR2rAINEuJ0OMo6WwM1LrBeDLnzJ+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ioIg54q+ff7pCCNNmxXT8xBLUE7DPoWCcRI3/JRAwXXK33RgKNkDgfWfax9Kr/O4EtNb8/szDykRb3p3FwiPZZJKlF5fOH7ByCXl1ckCRavHAd6jElBEFdg5VMehQ0ZfGS7f5023tiHQwInzF2mbKauql+pFJYM/xLTvWzeF0BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PmNAZJkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PmNAZJkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE59C2BD11;
	Wed,  5 Jun 2024 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717614852;
	bh=anJCOkwW/JCOoSR2rAINEuJ0OMo6WwM1LrBeDLnzJ+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PmNAZJkqpGyH6vjNz47hE1ihjyXMSZTKTyoxMHhsiKfjXaljY0BTR417ondXgtokP
	 0jKANCFz07Dmgf+Vky5fYkDRhoxj8uCoebggx0Z8Q1djaJknCIvsfjINlfF9dy85CE
	 6WW38NV01bsMeRVwzeqQo3cDuSZyjB927EtHkUXwIndbI+rh5+RO6JDC16fwnR5SKg
	 hglKztyr1w/MqT5KmbdkXB4ozoW6HFvVCGSt0a0whfigTl20B3QGWYiasLzizdsBtI
	 zkX5Nznmb2/svFBIuTCUL4023Hl8en/suEUqcR2P8Cp0Sk0Z20RAO32FQkjeTnByMz
	 zsTjoIXuPhmFw==
Date: Wed, 5 Jun 2024 12:14:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <20240605191410.GB1222@sol.localdomain>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-7-ebiggers@kernel.org>
 <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
 <20240604184220.GC1566@sol.localdomain>
 <ZmAthcxC8V3V3sm3@gondor.apana.org.au>
 <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
 <ZmAz8-glRX2wl13D@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmAz8-glRX2wl13D@gondor.apana.org.au>

On Wed, Jun 05, 2024 at 05:46:27PM +0800, Herbert Xu wrote:
> On Wed, Jun 05, 2024 at 05:22:21PM +0800, Herbert Xu wrote:
> >
> > However, I really dislike the idea of shoehorning this into shash.
> > I know you really like shash, but I think there are some clear
> > benefits to be had by coupling this with ahash.
> 
> If we do this properly, we should be able to immediately use the
> mb code with IPsec.  In the network stack, we already aggregate
> the data prior to IPsec with GSO.  So at the boundary between
> IPsec and the Crypto API, it's dividing chunks of data up to 64K
> into 1500-byte packets and feeding them to crypto one at a time.
> 
> It really should be sending the whole chain of packets to us as
> a unit.
> 
> Once we have a proper mb interface, we can fix that and immediately
> get the benefit of mb hashing.
> 

This would at most apply to AH, not to ESP.  Is AH commonly used these days?
Also even for AH, the IPsec code would need to be significantly restructured to
make use of multibuffer hashing.  See how the segmentation happens in
xfrm_output_gso(), but the ahash calls happen much lower in the stack.

I'm guessing that you've had the AH use case in mind since your earlier
comments.  Given you were originally pushing for this to be supported using the
existing async support in the ahash API (which would have required fewer code
changes on the AH side), but we now agree that is not feasible, maybe it is time
to reconsider whether it would still be worthwhile to make all the changes to
the AH code needed to support this?

Also, even if it would be worthwhile and would use ahash, ahash is almost always
just a wrapper for shash.  So the shash support would be needed anyway.

- Eric
