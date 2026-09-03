Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B3C2ECD1D
	for <linux-crypto@vger.kernel.org>; Thu,  3 Sep 2026 03:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788407410; cv=none; b=d7IZ9M1KocQrqgP5/aHSV1YEea2aVNiEDlL8H7jWznzc/+0BYea2MFwaYRN7XPOoZkGnXPzhXgJ/ftIegpJsDQySR2oLhtVpf57he6MBrF/UvGQa6rWjGS5gLNLlwumfMnC5RgdVOmE1oysD8T+tglasGiMwqXOvcUfi1Dal/sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788407410; c=relaxed/simple;
	bh=ZnPpUTwfOWwtewqDG344Fu6YOi+dU2JEh3k5mSEod7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oB//ms2YWfgPscRz2ixGadvRKDmgm3XBrKTHP51ZxwKGXW4dzk3K8ryua5I5fBLlKUt+1BV++jIH1sC4VXjkRNXDmcFzig9S4xoRHyV/n0zAPBCxVFx9/ptnJ1TjP2HI8PCtTlDqet6NEqjnUncq9ncd2cUEFca5XdP45Wn/hbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YkdcU49n; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YkdcU49n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=gqY7bX6kSU9EXYmErgdF/Zaw2gf3giTdYU0E0C4vmkY=; 
	b=YkdcU49nSBOTKwaSw7oEPT8ylsx/HJN5geTPZtxAtkdreE4eXS35dnPLbIa9+kSDK98gS9t0Itx
	EWi50L1V8wFCLYWBF9Uc2YhUSS4NoskXw5UXsoMwS9w/bBYhEUE/VN7YfMddB7py1s8HrQ1TP1nAn
	6kdZsuupp+gk+vVXWDCLIPAHG2qttK8S0kr8B4qAfC5UTfZznotWeaCzGzY7gV33uY2+RSmsDVPy1
	JLO2XO5ZkL968+NiFmEQcEMOopFmxMdUCeLQz6ULQ97+rWeMzO9xksF4h0OP8AnzyHcjahCnGLpzR
	RQP9njypEtpm52P0bH/OGiE3PSQ9SwlHF3mw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x1ySe-0000000AKf5-0tyB;
	Thu, 03 Sep 2026 11:50:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Sep 2026 13:50:00 +1000
Date: Thu, 3 Sep 2026 13:50:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jian Pan <jian.pan@se.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: ECDSA key parsing in crypto drivers
Message-ID: <apjuaALPrsIq8rZ-@gondor.apana.org.au>
References: <34094aaa-da49-4203-b176-ed3faa4b8692@bootlin.com>
 <41bb0b65-3a30-4922-9aef-10f73c654852@bootlin.com>
 <apff2HnJS3IjlT4p@gondor.apana.org.au>
 <c413ff04-61bd-4352-98fe-c2c01f075042@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c413ff04-61bd-4352-98fe-c2c01f075042@bootlin.com>

On Wed, Sep 02, 2026 at 01:58:33PM +0200, Paul Louvel wrote:
>
> By "generic C implementation", do you mean the implementation in ecdsa.c ? For
> verify operation, this is clear. But signing is not implemented, so there is no
> callback for setting the private key.

Right, in order for an algorithm/function to be added to the API,
there has to be an in-kernel use-case.  Right now there is no in-kernel
user of signing so that's why this is not implemented in the
generic code.

Until it's implemented in the generic code, drivers should not
expose this function (at least not via the Crypto API) either.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
