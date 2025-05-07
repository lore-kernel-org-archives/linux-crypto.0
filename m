Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEFA4B1E4E;
	Wed,  7 May 2025 03:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746588929; cv=none; b=JTWQneBDcubn30EU6PBYMUZvuSZJFjRrz5KI7qeWK4qETOOQzAPtnuli6RjX0WXVEYsS2faRmsahhupQ6t1IXPsPKQPjilU8zRHgNfL1LVyteV+rOJKmXZs7EXmnUb4QLtu6s4LuND3KzYuBaut0JjX/Nbb3RV3ivstjIL6xTMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746588929; c=relaxed/simple;
	bh=U/blkr60HFN9MM8NLIstblc4d05WLZz9eQUN0N/gDLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gVI1SQP5Rb+6jEssh82CzZ62KJaGd/AlhHq7l0xKI9S26wNY30E+Z+jrjRQQtaUZnHRfiDJWhjTDAjPjbBE5ubt6hqoXWbWd5ohqTpf7Jze5Dmdy4/GCuktZCJ7PZNTMHYEUtVnexLgxTf9Uw1Q8HTEph2gQUvU2Bf6sJqhNtvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Eoq8BbC9; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Eoq8BbC9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uovP2EE7NN/SZCaWCWEAOEGAWEzjsBMhrjvtMe0UUb0=; b=Eoq8BbC92bdSdaAoDe0DPYcGP7
	yx6W05z9+zHD5tv1hjs35MH/VZ4W7bhGa73Wev1iNxaLeEkQyjoIJw4NUaGUruzYZqU8Eh32O4wna
	tg+zRmiVYiVbn3X4pPafbc3TpJ/zLK7z0YQQTow3jBnzPGGWDm/tr/IjRnd6HfmPLCmJlDUz/hymM
	tP0d2CBVSfothyIOCEEp0mfmK6Q1cKmQiyqXzK+j8POKLCpoROJ4pTZ9lUknNPs7eFUcMFiphnPZq
	pOcNpj+q1hBBxpgPbeHWm+x6+ZAJYf5BoMPyYqvOOSC12JPvLhROqEcuBcnS/U0S/KrN+hPIWRDFs
	E/JA2NrQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uCVZ3-0047cI-1X;
	Wed, 07 May 2025 11:35:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 07 May 2025 11:35:21 +0800
Date: Wed, 7 May 2025 11:35:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 2/3] s390/crypto: Rework protected key AES for true
 asynch support
Message-ID: <aBrU-VgCQJhqz3SH@gondor.apana.org.au>
References: <20250401145048.52564-1-freude@linux.ibm.com>
 <20250401145048.52564-3-freude@linux.ibm.com>
 <Z-y3W4o5nz9qfijs@gondor.apana.org.au>
 <26acddbb918cda48c948e7f07172ce3b@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26acddbb918cda48c948e7f07172ce3b@linux.ibm.com>

On Tue, May 06, 2025 at 04:02:41PM +0200, Harald Freudenberger wrote:
>
> > > +			rc = paes_convert_key(ctx);
> > 
> > At first I thought this was racy, but then I realised that it is not
> > because only the crypto_engine thread gets called with maysleep ==
> > true.  Since there is only one crypto_engine thread this is safe.
> > 
> > I think this is not really obvious though and worthy of a comment to
> > explain the reliance on the single crypto engine thread.
> > 
> 
> This is racy but the code can handle that. The cpacf instruction
> refuses to do any operations if the converted key material (the "protected"
> key)
> is invalid. So it is in fact thinkable and possible to replace an fresh
> protected key with an older (in the meantime invalid) protected key. As the
> cpacf instruction detects this, refuses to operate with an invalid key and
> the calling code triggers a (re-)conversion this does no harm. So it
> is racy but may only lead to additional conversions but never to invalid
> data on en- or decrypted.

Perhaps add this as a comment in the code?

> I am struggling with that. The thing is how to keep this information.
> I extended the request context with a bool field telling me that there
> is/was a request pushed to the engine and thus all following crypto
> operations on this request need to go via engine.
> BUT ... the request context is not initial zeroized and there is no
> init() for a request and thus one does not know on invocation of the
> skcipher encrypt or decrypt function if the value of the bool field
> is taken for serious or needs initialization. Same would happen if
> there is a counter instead - how to initially set the counter value
> to 0? Any hints on this are welcome.

I think the easiest would be to copy how simd + cryptd does it.
In simd we have the same problem of a fallback path through async
cryptd, and we need to keep using that fallback once we start until
it fully drains.

So right after entering encrypt/decrypt, you check whether the
fallback is in use, and if it is, just do that and that's it.
Otherwise continue as usual:

static int simd_skcipher_encrypt(struct skcipher_request *req)
{
	...

	if (!crypto_simd_usable() ||
	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
		Take fallback path
	else
		Continue on normal path

So for paes this would look like:

static int paes_skcipher_encrypt(struct skcipher_request *req)
{
	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);

	if (paes_skcipher_queued(tfm))
		return paes_skcipher_fallback(req);

	Continue on normal path

Where paes_skcipher_queued(tfm) is just a simple ref count of the
number of entries queued by that tfm onto the fallback path.  IOW
every time you enqueue something you increase the refcount and
every time you dequeue something you decrease it too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
