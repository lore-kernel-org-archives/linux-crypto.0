Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48029149C6F;
	Thu,  2 Oct 2025 11:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759404462; cv=none; b=nugT9BmGw90JlyIN3aufkhMXIB2d3YdnL2Kf/YKjDZt+owHXnEDDfvkc8eP1KwK2nw211x0fW057g8HeMA8g5dIMN0nF29E77MYwBMHFn1DX0nEr8Zai75EeVBIFIel+NLBlWYEBlg9f9/aScFwSrAlLoANAMHZNzj5BAyxrMe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759404462; c=relaxed/simple;
	bh=Egm0T8cSzPyrQsOMXP9uiDZImB/BFusEsrwgMevPWwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bes8zn0hwApUBD7LlAwiZWf6x6glbjUz7FFtRg2sdUecDk8Hp2DeyQwUhW7FEUAlbY6uaGk3KqrFM7r4zPOxSxDd5kzmGFWHg43MiE7OGQs/yiWSs8nkfNWBoea1EHA9GjDwXRX59imlk08IxWX1ne4HbBslv69C/tteJVkuBDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Oy1O6G9J; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Oy1O6G9J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	reply-to; bh=NKN2jJAcUQAltvUw4+OVLkUL2lRdIIFnP1PmgDZHiEA=; b=Oy1O6G9Jjea8PF9g
	DzEESfzU4hlh5I2toehR4D1F4aqJQNjGC6kDTak9Cl2GOvB0Va7LTDUKHY3FTG2PTwKQxwEVEMNvK
	YC9C4vYN7bQ8uG5eY2CSZoa8vI+5/I9+qZDKcy/byXJw4yH0CmO8GB3o6a/a6mIEMyDDXzHLc7GRj
	iFtelG5yarOpEG9o9yz0zxM2nt76cZtF3B2KELYig5ehUuJdpKrqKnhxjsyeHeKLellGhGwvYI7m7
	qCAn++lIGHuVlyrQV1QemhxVZPvkG55b1AIn8sXMoiv7j3yYUNHy4V48WtQAdfNv/xwzdb2z7f8HF
	buGP6wd3E0GSNM9+6w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v4HT9-00A0Pp-1F;
	Thu, 02 Oct 2025 19:27:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Oct 2025 19:27:31 +0800
Date: Thu, 2 Oct 2025 19:27:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>, netdev@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
Message-ID: <aN5ho_VTClL5ai8l@gondor.apana.org.au>
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
 <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
 <aN5GO1YLO_yXbMNH@gondor.apana.org.au>
 <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
 <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>

On Thu, Oct 02, 2025 at 12:57:11PM +0200, Jiri Slaby wrote:
>
> Anyway, cherry-picking this -next commit onto 6.17 works as well (the code
> uses now crypto_lib's sha1, not crypto's):
> commit 095928e7d80186c524013a5b5d54889fa2ec1eaa
> Author: Eric Biggers <ebiggers@kernel.org>
> Date:   Sat Aug 23 21:36:43 2025 -0400
> 
>     ipv6: sr: Use HMAC-SHA1 and HMAC-SHA256 library functions
> 
> 
> I don't know what to do next -- should it be put into 6.17 stable later and
> we are done?

Yes that works too.  But it's basically the same as reverting
the patch from Vegard since it makes the code use SHA1 again
even though we told it not too.

Perhaps we should just revert Vegard's change? Since it's kind
of pointless now that people are just using the underlying SHA1
algorithm directly through lib/crypto.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
