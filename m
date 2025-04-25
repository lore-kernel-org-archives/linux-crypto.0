Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816292701B7
	for <linux-crypto@vger.kernel.org>; Fri, 25 Apr 2025 11:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745581789; cv=none; b=kFVRjBm5NbdPIwHhxXg2F/f+11K+cbJzLRlFrs+Ja9KP0B0M7RS8BsfjovMtmbeZbABxY3qJx9BxkgdOKlJIbqQuHZ63iO7uUDwGaWyAfWugZjjqOXdtWhudO8yQRUv5TLjs99NOnk+FLS+TziricxCVwz1Gvfi9QBX4QO6QpYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745581789; c=relaxed/simple;
	bh=641yZfywJKAArK32uSxokrmz5CnbGw4G7fVlsAaklcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N+bLFaiXnNVL+2ekDXwCqJwvB/vHimbalMR6O+fTtfaHA7bSNZlPCSyszbLi4lqHPBtDV7XWjjvH2pqxfqxXX2ybIjukOF5fddx/aZp/80uTAv+4qSxQqrxJV4JUbK1iSeLe1eX3q97Qzb9Mn36AB0GrHspx84o3BipQKgy64G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZKmi++ff; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZKmi++ff"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uB5wV4QoUDWquUNWMzuzATBKh35wq5xw2d7DvaXO9uo=; b=ZKmi++ffri2csXAkHt8vqVp1Nu
	BhxgPUyAcDqdJM7N9qDXeZiwnMSJSGiVK4pfeVEikYqkoecosDq7WgTmvwnxee7RRjfcyxH8Qao4j
	L7akMP7OX8oa+dZ9aa7LCUMEDmhsmJSD6kVBCpk/jkFZQRkCJ03usXIcBAr7A2bELxC8T9+1+1DJZ
	EeTirowd5x5GeBV5lUcc6KPD5uzb3IEg4P9a6vCUaW7XdeYO3HL3Yz6yJheUFUBPHv0M+7IhxCkaG
	pxSHwj87oxNVpqnbceh7NN8tO0bWXUmGMJGmNBNpfFSilw1tagqT97NTmjlUh10W9WjHZ+rVwLZmt
	lQBGj9/Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8HYs-000ycO-1o;
	Fri, 25 Apr 2025 19:49:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Apr 2025 19:49:42 +0800
Date: Fri, 25 Apr 2025 19:49:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 02/15] crypto: lib/poly1305 - Add block-only interface
Message-ID: <aAt21pphcto2Cjxa@gondor.apana.org.au>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <7c55da6f6310d4830360b088a5cc947e1da9b38f.1745490652.git.herbert@gondor.apana.org.au>
 <20250424161431.GE2427@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250424161431.GE2427@sol.localdomain>

On Thu, Apr 24, 2025 at 09:14:31AM -0700, Eric Biggers wrote:
> 
> Use 'raw_key' instead of 'key' when referring to the 16-byte polynomial hash key
> which is the first half of the full 32-byte Poly1305 one-time key.

OK I'll change that.

> > +	desc->buflen = BLOCK_HASH_UPDATE(&poly1305_block, &desc->state,
> > +					 src, nbytes, POLY1305_BLOCK_SIZE,
> > +					 desc->buf, desc->buflen);
> >  }
> >  EXPORT_SYMBOL_GPL(poly1305_update_generic);
> 
> Again, should just write this out without the weird macro, which is also being
> used incorrectly here.

If you have a better way of abstracting out the partial block
handling, please let me know.

As to using it incorrectly, could you please be more specific?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
