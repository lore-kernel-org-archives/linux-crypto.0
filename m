Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5DB2C178D;
	Sat, 28 Feb 2026 03:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772250047; cv=none; b=AhW1dbR1UUGe5idB+vuURO1C2H/biB0UsnskckmwVRsXKwpMHE75Djmn9AuQVNp6JAmeYUrHbwMoanQdSyPveQa9Q8M62dsmD2X+s3fLXG381auXSEQPhWOfsMNXMNrd8+vPY8DBTzEsCsWMvLKt6/K1yaEyKVfOdqJM5vjFgUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772250047; c=relaxed/simple;
	bh=ORR41oNRqpSaz/9EeKWjE2HUD+iWGppUOWIiwAgBG/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=badJU3PwaUeH5mYs/Hz0OzMgiteENGEdK0HedAGpK7d6g5r1/5KaNz2hSOQTSnj/kew3rZvSo1cvz5j4kJC7XcgQpPcFev2v4RC3QRg67dPkPXyX3q9e4hn+ZbmAJibYLr4kycPaKfW0hiGO7eUe1O6BXMQxWNRoYKC64Vaf0RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SgDVLnIY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SgDVLnIY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=OA1Gm4aH6afdX6co966EXqk3g4zzx7bu9CBDahUFiqw=; 
	b=SgDVLnIYxB587fBdmNpj+LNenN8vA/4qr3ftG1WLV8KQ1QkIFbHP4uAHFS4dJ77MUUaUD+0wai2
	v9DcddO/7E/BTjyjXaOS3hqzfngjGb6K4/oXDeBjbXY8GQH/NsWXI6ZwgbXJf9k+f3Uj8gSrlTL8H
	7R6sI9seuTJdprE9wJ/6HHxHCr+hq5yM/wHBHCl4Ez0c1/MnzhxOrxtYtDKBAqH3kEyWBIuTHF+uw
	g/ITuOv1WeI20SNqrFujGYSSjcaJAdrD+lqD4UXwo5wCmh2mS1w1+53YeKR52pB9Vphcv1CbPTs4Y
	kJ74A1UYYxwLpFSxkFCI3APtqwD0EN/pQNzA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwBBy-00ABZG-2g;
	Sat, 28 Feb 2026 11:40:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 12:40:34 +0900
Date: Sat, 28 Feb 2026 12:40:34 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ethan Tidmore <ethantidmore06@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
	Tero Kristo <t-kristo@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sa2ul: add missing IS_ERR checks
Message-ID: <aaJjsnV8rGLpxha_@gondor.apana.org.au>
References: <20260216231609.38021-1-ethantidmore06@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216231609.38021-1-ethantidmore06@gmail.com>

On Mon, Feb 16, 2026 at 05:16:09PM -0600, Ethan Tidmore wrote:
> The function dmaengine_desc_get_metadata_ptr() can return an error
> pointer and is not checked for it. Add error pointer checks.
> 
> Fixes: 7694b6ca649fe ("crypto: sa2ul - Add crypto driver")
> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> ---
>  drivers/crypto/sa2ul.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index fdc0b2486069..58d41c269d62 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c
> @@ -1051,6 +1051,9 @@ static void sa_aes_dma_in_callback(void *data)
>  	if (req->iv) {
>  		mdptr = (__be32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl,
>  							       &ml);
> +		if (IS_ERR(mdptr))
> +			return;

Thanks for adding the error checks.  However, if we get an error
here shouldn't we still free the resources and pass the error up
to the caller?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
