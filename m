Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CB423BCF7
	for <linux-crypto@vger.kernel.org>; Sat, 21 Mar 2026 07:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774079489; cv=none; b=J2gF2hKSW8zgyfNVeWheYVzuUa0Uj3Zfea52u65wcgGBKgcAocZS6ITCPYyA6y1itsPJuLDtGJiv9dRq9XlXrZpcmc3VPbqHkWRFoXt2mJ6TlX7p9RH1Jju1k2P/AZFmoI9s+sL+VOaC+/PVJbHwiRcHUEslA8nL4Ju8hq9Fzmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774079489; c=relaxed/simple;
	bh=r3V5N2pu5UtOLib8YjsGS5ZER19EOkbXw+o8LN8NNpM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=XUeJTIiCEahAFk0hqXKiVs/QIpp1RU2kZ6PlVL3ScDXMNVIn18Gm2Po58QQ3h6SRuNWL3BGT1GBNxZW2HMRQJjPwOvdl4aZwn9p5HXpvZRL5ark0igF02hnNlEaM1eeszL79lNCXNEQbl5Qwu/1OpnODH4zWvH1/2SkjLRjp5fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=IDJbV8pl; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="IDJbV8pl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=EsRKAslWsF1TJRCjN2EOIDK0oIc24TGSlhjZVS/UP3Q=; b=IDJbV8plunavJzoCc+aFD+SOQu
	J4twXBQD1uyWjGWvch+KPiZnTZJQHXcShrgxUpZNzn/d57YF575KWlJkUeVD81G4Cy67FxDdzKjzU
	QsasdrTNWqdsN6KniSS65KdsfuormTjdSa2XHtldolsKADNnFvMGzLPWogPr2wFZN47qm0d/xHnGJ
	RFCTUG+LRq1vSe/9gGdmqwY46Z+NT9vrU1zQ3KS3meDie39h4E7Ph7MDvkDeg1zHc2Ls5jxj6UV6w
	sa/1jYcsTnayVSCSLXw8G9bpRzyL5VB1HArihN9peQFoGDuwkNlFmr8nnFJz3wbyJONVX2dTJXrfc
	LJCtignw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3r76-00GIdk-2T;
	Sat, 21 Mar 2026 15:51:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 16:51:16 +0900
Date: Sat, 21 Mar 2026 16:51:16 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - correct ecb(des-eip93) typo
Message-ID: <ab5N9LgbrgD14QJP@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1003432575.1235274.1773572703895@mail.yahoo.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Mieczyslaw Nalewaj <namiltd@yahoo.com> wrote:
> Correct the typo in the name "ecb(des-eip93)".
> 
> Signed-off-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
> ---
> drivers/crypto/inside-secure/eip93/eip93-cipher.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-cipher.c b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
> index 7893c15..4dd7ab7 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-cipher.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-cipher.c
> @@ -320,7 +320,7 @@ struct eip93_alg_template eip93_alg_ecb_des = {
> .ivsize = 0,
> .base = {
> .cra_name = "ecb(des)",
> - .cra_driver_name = "ebc(des-eip93)",
> + .cra_driver_name = "ecb(des-eip93)",
> .cra_priority = EIP93_CRA_PRIORITY,
> .cra_flags = CRYPTO_ALG_ASYNC |
> CRYPTO_ALG_KERN_DRIVER_ONLY,

This appears to be space-damaged.  Please resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
