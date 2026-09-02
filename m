Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06E9258EE9
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 08:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338151; cv=none; b=Sas466rWPL7d8n7OSPTtiTbLEDRAJc0zuqWk3+8IfW1HRbCLwZ7QuCkis+k4uEEtbBHLhEiVp0Ed3FzuAqVjnRGU+tCkELcqcmH0JWMocoGcAmfAkVjX4Ocyb74c6K9DT5glCFJu2yvS3q+czvhjS/Sz9WjuH/wDgG4+OQxUPhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338151; c=relaxed/simple;
	bh=KMjFniGd8DfIAvAF9m2mf7317J9NJKEinnLyUiSav6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YE4hvB674uM8GkZD+VIn4JAzZJPRXJmYn1pvvC9SCwniZ+0yq9txvih/q5MnJkFxBKhCxRiGoLMbBHCEq8z9j7bACWCz7o43Cx7ciYSk5AlR08l+xor3hPovOEKZcerBcAfLTpESwRjCSMl+mr+rgHPim7y9WAuYfDJhLLhvrvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=OMaZZcCJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="OMaZZcCJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fG4JxjbQT80jOfpa0dn2FgVaRABMpHtW2ljvkmKq6AM=; 
	b=OMaZZcCJWONaGF2sVKR4xzLVjOaWuQEeNvg3vKgw297Xc59xKbVyQ6MmYstFOx/k4F5UYq+srVZ
	nBzx58WSFXciDPkIWK2tPi3ko6kmn9hbgoLOpbh+nJvjTR/l74mi0imlYnJkiizIruVHKZhNBJLXu
	lCjLlNHO/UqujN4fAqjqHgxpYvXAx67KNLPsEw6hQwcPQTAx2HcG4iny6tM1ockQ8ptbymm8wNbgU
	mKQaym0VVZYlU1b8T1b+FdowvPEEopH3tDa9bhChGEhoc6qVPRfPpVFiu6b8pBLjky2dk+E+XhibS
	461MeHlPnX1W6U5i4cSq8pUv/UyAvBvZCsOw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x1gRU-0000000A136-0stO;
	Wed, 02 Sep 2026 16:35:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Sep 2026 18:35:36 +1000
Date: Wed, 2 Sep 2026 18:35:36 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jian Pan <jian.pan@se.com>
Subject: Re: ECDSA key parsing in crypto drivers
Message-ID: <apff2HnJS3IjlT4p@gondor.apana.org.au>
References: <34094aaa-da49-4203-b176-ed3faa4b8692@bootlin.com>
 <41bb0b65-3a30-4922-9aef-10f73c654852@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41bb0b65-3a30-4922-9aef-10f73c654852@bootlin.com>

On Mon, Aug 31, 2026 at 02:08:02PM +0200, Paul Louvel wrote:
>
> > My question is: which ASN.1 schema should be used? Should a client of the
> > crypto API know in advance which format the driver expects? Also, for RSA,
> > there are helpers for parsing private and public keys: rsa_parse_priv_key() and
> > rsa_parse_pub_key(). These helpers use the kernel's ASN.1 decoder. Would it
> > make sense to have such helpers for ECDSA?

The driver needs to match the generic C implementation of the
same algorithm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
