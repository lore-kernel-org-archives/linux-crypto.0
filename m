Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0786233BBBD;
	Sat, 14 Mar 2026 05:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773465464; cv=none; b=OD4HyHiiR9Wgpd18sH+vtBchhenekn1joJ65xbdwcyZh/k70dw5gnywWSrkZIMPMPxk6YxZBj5dPkihDVkcPc5aEqzCz1ABCxPBk3I0PhJ+DrYNCBjMA/7o2MwPxsx51Hku51uJvx7BGCABqJw05DNYUeh/CtOFi3XiCPoPCmJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773465464; c=relaxed/simple;
	bh=AclA9w3gbDKRByiVzYlbZhA1vcrU3u1HyyVSrczOL84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWTKBgdeaOtqsl8fd7MLJAZ/mswMgvWsyBIbT6TnuKMOpmFZoLP5P2g8zJwW2359S9lrJEkfGj+CU/wG2puZpL6z2ahHfu9Yba6zqP5LCZlxMyBz6bEo6vJSY9VT8FUMGip97p0cctvlcZM8A31FNCR82BSg8DlsTtBBaROPBDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Ky4nppD0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Ky4nppD0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BzWAAXoImhghi3lyi5SgqjAfETq31DEyl9LJED0rBmk=; 
	b=Ky4nppD0Ucx/NvtT/fNjHvIPfPC3qlNBhR6NQIkqO15QqvU1JxpO4Sgy6OYbiCOO1pgOZWdrO/Y
	AQGR4GmsXG64UZ+rpH6KZBcxpOIPcMZQINhfAaRoVyK0D770sIroF7IelU7d4cEBnXlwv3VosC56J
	bYEZ/5Tq3nV11Jb9JhhUxUuiW8EFSUQUBU/RTO6/GNn3tPYEQ0NBKzkZTlLfw9EMCMLg6vKtrTgT2
	UHt9kNYVf80Q06kCniczUdeLgQH5HstzLqLIFA+iYYVr42mXeerqXo+H7ikPQ3oqVg9WDKRQUETp3
	17zvM0mU+3Co3bDx6j8k4fNlTUqQ1kuJIMLQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HNP-00ELC5-1W;
	Sat, 14 Mar 2026 13:17:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:17:27 +0900
Date: Sat, 14 Mar 2026 14:17:27 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, atenart@kernel.org, davem@davemloft.net,
	vschagen@icloud.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - register hash before
 authenc algorithms
Message-ID: <abTvZ2qLCgk7vO9c@gondor.apana.org.au>
References: <20260306221742.1801119-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306221742.1801119-1-olek2@wp.pl>

On Fri, Mar 06, 2026 at 11:17:40PM +0100, Aleksander Jan Bajkowski wrote:
> Register hash before hmac and authenc algorithms. This will ensure
> selftests pass at startup. Previously, selftests failed on the
> crypto_alloc_ahash() function since the associated algorithm was
> not yet registered.
> 
> Fixes following error:
> ...
> [   18.375811] alg: self-tests for authenc(hmac(sha1),cbc(aes)) using authenc(hmac(sha1-eip93),cbc(aes-eip93)) failed (rc=-2)
> [   18.382140] alg: self-tests for authenc(hmac(sha224),rfc3686(ctr(aes))) using authenc(hmac(sha224-eip93),rfc3686(ctr(aes-eip93))) failed (rc=-2)
> [   18.395029] alg: aead: authenc(hmac(sha256-eip93),cbc(des-eip93)) setkey failed on test vector 0; expected_error=0, actual_error=-2, flags=0x1
> [   18.409734] alg: aead: authenc(hmac(md5-eip93),cbc(des3_ede-eip93)) setkey failed on test vector 0; expected_error=0, actual_error=-2, flags=0x1
> ...
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/crypto/inside-secure/eip93/eip93-main.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
