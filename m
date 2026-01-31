Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA132D5C8E;
	Sat, 31 Jan 2026 02:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769827750; cv=none; b=TxVb9b2/y9TUw06D8odhixvVOl7K0G4k1k0RytJQynmqOIiDP+xfFGTrSchuKxH7Qj6fsk+XcVODtNHS2v7sCVwcn0P1pwA4CdtrAbF+P+5Z0vjI/83RqwGkdtdxjrd+T0Nhth/Uqta2vE+S5rKUvF2cc3vC7bmzpt/aN5sva3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769827750; c=relaxed/simple;
	bh=BWv+S28hx4s6NAxl5LoWIX33U+Fp/jq4PWwonCHQmYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X7zxktwGSdBFOea19phHdduECUfFQtVUeDmXXylYh7pCcvSuc/ESpaRBP8O5HLj5XZLY6MV7sK/fKbokouQvUsO7h2g8/AH0cscnWTAbXiqltrxqlFl3Fhzdijvr1dreXir708toCNpSMpfIYfwVNTDTvIXkJaUr84zmm82WdHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HeWQvVU7; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HeWQvVU7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=TU1lIGiisOSvQp27PeT3c7yQhstskqKBVN+EfVBMwNo=; 
	b=HeWQvVU7HcdzYD9nWxWD96zWFT06fAD9C4+B1wwVNGDdrm2ChFwAqeepf6r45NSc23CXh1wmxiN
	L4+6x2DpfTZDGlPw5nsgwh+3XvxeTSqzBCRvuy6pdPY16U4Lk9KiDHkLuQSpZ/7HxSlII2uIsVcEs
	ZUCNybdoUTH1ihvmHOEoIx5Ho6ot/U0L1puRWBygVx5V1/dNfRpYP0kfmkt+YxUAGZNT5bTNkvf9a
	VeHJv6/Jj9g2CzPtRjSX0GE9N9ql95IsyjgZemouaoDFilQ/nbTLUA4e7WzIV3XXStnR49pejqrWo
	9KEqZexuwAiTzexlaxC6FJc8qHJdJKBjaLxg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm12W-003Rrr-0o;
	Sat, 31 Jan 2026 10:48:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:48:48 +0800
Date: Sat, 31 Jan 2026 10:48:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, maxim.anisimov.ua@gmail.com, amadeus@jmu.edu.cn,
	atenart@kernel.org, davem@davemloft.net, vschagen@icloud.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - unregister only available
 algorithm
Message-ID: <aX1tkBYemz1w78wm@gondor.apana.org.au>
References: <20260111132531.2232417-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111132531.2232417-1-olek2@wp.pl>

On Sun, Jan 11, 2026 at 02:20:32PM +0100, Aleksander Jan Bajkowski wrote:
> EIP93 has an options register. This register indicates which crypto
> algorithms are implemented in silicon. Supported algorithms are
> registered on this basis. Unregister algorithms on the same basis.
> Currently, all algorithms are unregistered, even those not supported
> by HW. This results in panic on platforms that don't have all options
> implemented in silicon.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
> v2:
> - keep the keysize assignment in eip93_register_algs
> ---
>  .../crypto/inside-secure/eip93/eip93-main.c   | 92 +++++++++++--------
>  1 file changed, 53 insertions(+), 39 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
