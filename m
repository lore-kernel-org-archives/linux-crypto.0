Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE92364D6;
	Mon, 25 Nov 2024 06:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732514983; cv=none; b=tJSUyw9yow2g3hyOp51lDWTKydtCwDKeO43YE4pqNY4i/6XZi4+2Jub6F+Ow+t+GpPf6Y5OjiYVG/7QFKZ9JntoE2CSvhZUSqqqlgWZ4vn5INRRrdiZ4heq0nwkNzz8Mn8QcC2vlpu2JUdfKVoq5E82IPNVs6UZMHUPLlTjOuUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732514983; c=relaxed/simple;
	bh=MRQeRVTaqmoNfnsHa+uLbRfTdnGwyDlPAHWuiTkbs54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X2JymjsKK6wxZfA9RKqH2erkOPu+S/ky/upz68FUlAQPFGXHZ5fSLQb1fNUt0msiMStDKQVfGweKXpCGYewZMYZEfHgc9f9iVqx/CNU7mxRMU2i0aJwuxgHhaDU/kFTgC2DHxsSnBrIASiWd7bjNqIUzd+I1zgC9Ptn9mJuaXJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=I393jQfM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="I393jQfM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=B7r4LINbl9oYYjpznVoVNyIXz5UKh/UFGV/wN7Hu1ck=; b=I393jQfMoxwoj8oWWYqCLPTmh6
	EhHGtdAI6ngONbbMHcan8KcJA+UyzvzW9ow8F1Hivx+Z38DBD5Z0v8iNF93v+BcqSxIK4zFvbY2oI
	evc8MoIa4sPc/F8+Yxa+nliqBZnvzT81nQvfRxc4dym9XY2yV/8kPXZkB/RM6SGKpXJhtyQHlHyKu
	Cx6eUv/QK7i0GJKF/DRQBpNbc3HAMV6ORv71nitk8AuALWOuJ9WC0mXjTatWjp0FUBwSiAAfnY2Dr
	f4hwlmXwIG+gBhrDhhaYqmBfPGwb/r6sfXxTg36BugjlhnCfwxFzP6/J+Ly/urJQDl8tHjLbwawwf
	7KkU9j0w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tFSHn-001TMd-36;
	Mon, 25 Nov 2024 14:09:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 25 Nov 2024 14:09:27 +0800
Date: Mon, 25 Nov 2024 14:09:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Cc: davem@davemloft.net, dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 3/3] s390/crypto: New s390 specific protected key hash
 phmac
Message-ID: <Z0QUl_eSUwEANb4s@gondor.apana.org.au>
References: <20241122143427.135682-1-freude@linux.ibm.com>
 <20241122143427.135682-4-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241122143427.135682-4-freude@linux.ibm.com>

On Fri, Nov 22, 2024 at 03:34:27PM +0100, Harald Freudenberger wrote:
>
> +static inline int phmac_keyblob2pkey(const u8 *key, unsigned int keylen,
> +				     struct phmac_protkey *pk)
> +{
> +	int i, rc = -EIO;
> +
> +	/* try three times in case of busy card */
> +	for (i = 0; rc && i < 3; i++) {
> +		if (rc == -EBUSY && msleep_interruptible(1000))
> +			return -EINTR;

You can't sleep in crypto calls in general.

Now there are specific circumstances where sleeping is allowed,
e.g., when the MAY_SLEEP flag is set, but I don't think this will
be acceptable for your purpose.

I see the same problem exists in paes_s390, which was not reviewed
on linux-crypto.

So what exactly causes the EBUSY? The 3 retries followed by failure
seem rather dangerous too given that this could be used by the block
layer for critical data that cannot fail.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
