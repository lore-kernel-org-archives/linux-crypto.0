Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB1E25A359;
	Sun,  5 Jul 2026 08:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240877; cv=none; b=A233MOasvTvvMrLL05IfgF6UP36hCiwqTbK0EQcWJgt8vxFZJ61w8+oocMb0trj5HPzTMNgbcyOmVfgfojmUX1mYjF394kJy7CBrSTe0DxYU8UJu2Ui8bSV2vpOyrONeHO50me0sRv3IqS7h8VwR1CnEXKLMpySv2Qd9st0gvrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240877; c=relaxed/simple;
	bh=1+gOaToo5vvHtHAaX3SLmKQyNbhsfW0+qtWOqCWwOO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfD7symNxrOuMRa9h5QCMNFH/mtgdj+CWe7OeeRDXbC+g64vfAUIJPajXdnYNtecGPWAPCu+ZD5YdFZrxSIUtxZ7FrBYQVPDoW869W7QEfA3zJVTp+GCSfxWp0Umq26qifPNA4NzAKc5nkZj6KBkoYIyHhGBUhcU+kXoBvNmc0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RUoGVOQa; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RUoGVOQa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=uIZ1s9iu+uSsb1wpgwsIU9Gza1O6BxIlc3wFdmBBwk8=; 
	b=RUoGVOQa3JMUVnS5illGoI3AqU2YXkQgvJvij2mmpXcyM+x+s1XV85zZnIPV1rAGsQND14mMHv5
	qaTyDV6lUN0l2geSo6c8Xscob21sdzDSRPcaxbuMxzi6K5o1uhHOXhiiFnJK0GWHf0MwDvfNRBJZc
	SZNzsd/jyPYlNFI/JEQLCzY+agGROmKZSHKkPfXvo2jj2VJIzLL+/tgm8UYWgADhDdCBbOQ5HX34a
	Ov8iOFEMQzmvbAkdIfTVxHRf2irNE6y233OI9HSzWMm+sICatCnlJ8FaWGFfrrMdkVHoyyvwGk/WU
	cDVLhm5Q+3QZSNRmDWPwA3grTv3dvjmbV3nQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIPY-0000000Al8g-3ds2;
	Sun, 05 Jul 2026 16:41:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:41:12 +0800
Date: Sun, 5 Jul 2026 16:41:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Myeonghun Pak <mhun512@gmail.com>
Cc: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ijae Kim <ae878000@gmail.com>
Subject: Re: [PATCH] crypto: keembay: Fix AEAD unregister count in error path
Message-ID: <akoYqJFlFkL7V5om@gondor.apana.org.au>
References: <20260624072230.26742-1-mhun512@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624072230.26742-1-mhun512@gmail.com>

On Wed, Jun 24, 2026 at 04:15:49PM +0900, Myeonghun Pak wrote:
> register_aes_algs() registers the AEAD algorithms before registering the
> skcipher algorithms.  If skcipher registration fails, the function unwinds
> the earlier AEAD registration with crypto_engine_unregister_aeads(), but it
> passes ARRAY_SIZE(algs), which is the skcipher table size.
> 
> Use ARRAY_SIZE(algs_aead) for the AEAD unwind path so the unregister helper
> iterates over the same table that was registered.  Also clarify the nearby
> comment: the crypto registration helpers clean up algorithms registered
> within the same call, while this function must still unwind earlier
> successful registration steps.
> 
> Fixes: 885743324513 ("crypto: keembay - Add support for Keem Bay OCS AES/SM4")
> Co-developed-by: Ijae Kim <ae878000@gmail.com>
> Signed-off-by: Ijae Kim <ae878000@gmail.com>
> Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
> 
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-aes-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
