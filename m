Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAC9225403;
	Wed, 19 Nov 2025 04:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763527552; cv=none; b=lJ3yGI+gvA1KH2Rip+IQg/xnV5J6/2h4bmXxyrFR+/Y1saWaaO3W0P0SlzfUuLHAAcbtVkegapS7OJi2Rd2R602tOH2UipyGdqj9ifNnpmpuCyT5lB0IiIu6kZ0Kh+5XEPFhwVLrnvB0IvdrxV0UStZ6u43AYECXKgZ0//47lno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763527552; c=relaxed/simple;
	bh=xonWsW4Mn1ADS389J5gbxnd46hIOAisJFhRzn07OXZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4WctlpqbL79rUmX5N6DCvtNi9iNvI4Owfx41vHwSXR6HgrzdkX2z0V6jatorT1ZTwYrU2WL1azHXey4dt5kclZ74Bblt4kCZssbHBD6Yqt9jxCxnjDMQIz72nwfg8KCiaPvHm0TavreP2xNA3A55zrXbgxQX9C5piqGsVPIFHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Iu0eZ4Op; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Iu0eZ4Op"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6BEIqZG6bo5PQjoxroG9YI7kWvevX/mqtoG1am08OZU=; 
	b=Iu0eZ4OptbLzd4hBHH3FN3998y37bkRDMDZScjS4j1KN6Bob9a7k7v4U6lomVhVxlEHpoAr4Suq
	PDbpI0P6rqx/250DTm533BpMQt9gSwe60UC5lk3aEFxMR0s1O5r2ul3s7Amt461IRPVp63Rp0VZ40
	Nri9ExN/q25yB2/lbwTH4L8rxSTOG1s/slvfC0q341iEKH0Ws9HAx0grEtIwgejY5hD3U+qBeVskI
	P6fQwwneEIsiaImHItTVmfIdbslhhsorJMPzV+pcRkpn00lhERMhiFmd6SSlf85e0E912zLJPpG/8
	09ndI1OA4yjQkb//kQqYjq/zqM16QrGicCog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vLa4W-004E2z-24;
	Wed, 19 Nov 2025 12:45:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Nov 2025 12:45:36 +0800
Date: Wed, 19 Nov 2025 12:45:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Neil Horman <nhorman@tuxdriver.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: rng - Combine two seq_printf() calls into one in
 crypto_rng_show()
Message-ID: <aR1LcMOO0B6qUdOX@gondor.apana.org.au>
References: <d9574f40-8d0f-4f14-bc9f-b29c56069b8b@web.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9574f40-8d0f-4f14-bc9f-b29c56069b8b@web.de>

On Mon, Nov 10, 2025 at 04:56:10PM +0100, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 10 Nov 2025 16:45:13 +0100
> 
> A bit of data was put into a sequence by two separate function calls.
> Print the same data by a single function call instead.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  crypto/rng.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/crypto/rng.c b/crypto/rng.c
> index ee1768c5a400..479c4ac6fb6c 100644
> --- a/crypto/rng.c
> +++ b/crypto/rng.c
> @@ -81,8 +81,7 @@ static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
>  	__maybe_unused;
>  static void crypto_rng_show(struct seq_file *m, struct crypto_alg *alg)
>  {
> -	seq_printf(m, "type         : rng\n");
> -	seq_printf(m, "seedsize     : %u\n", seedsize(alg));
> +	seq_printf(m, "type         : rng\nseedsize     : %u\n", seedsize(alg));

This makes the code look worse and appears to be an optimisation
that isn't really needed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
