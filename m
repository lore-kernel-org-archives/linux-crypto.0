Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647F07F6;
	Sat,  5 Oct 2024 05:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728105079; cv=none; b=pqIcHk1ajUJgpWa5vqf/DCHDsL8dyGAHRH2EPSWikez/Gx8ggmpy/po5zkqlb96YlEbDGQ1gfTElvC2RYJomJyJHJ/MqCsE/pmA9+Y28HuOujtX9cAkK19ZNUHL3Sm7uYApna4G+MXJg644MjPNlUV7wfRYjlQfxuYG3uwf7lBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728105079; c=relaxed/simple;
	bh=+qFCL9at33w8BJyTXugTpsbcmLlhuQJjf0p9CVnuCeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXlozEEBH31GlnRRImgZCz3kPf/8TbQC56EPhFbO1Mr4g3s+jvynfQJ89gRstti8tXm+hu/iyK44R3sKAwU36SpHtmlYRQsdu2r4v2OCvRHa9OUOI74QxtHVzEgNTwY5mz68B24oTEHmdArWPojDj6s9MeeCBO8qaH1UXnCxm+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dc3HXopP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dc3HXopP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5JbN65GwW2HuvSV8ZD+1AnZ/MGceIGbVU/2Z4qiMRs0=; b=dc3HXopPt1XFjCr8RX96VjtUle
	N1wOGmKI35cImJheu2pFpwybqeHKrk3lAFnTuBwu86pF1BoS22UPCDSVjeWo9Tu1T6rwGl1lxZ5uh
	hW1wWnJMCtalOlBb7BOcKG78u9HYFEeI+9IF1/sSNc23I2f+Qzz6caA1fXxrQb82s6f5+hHVmytC0
	BEZ/h/JQK2N+zBrg2c4S/caJbABNwEe0iraC0Dnvv/UxX09OBChVxDuY5zK7GhaBJurTvN1v/n+4w
	b4nFq8G5e2VeYz2/Jnj9o//G4KFOdYGMWuWLKqQqAu9jFZMrLG6LHF7eBB037WyEXg6t+i6PRJdR/
	YlFrWskQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swwhe-0071Hw-2I;
	Sat, 05 Oct 2024 12:57:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 12:57:52 +0800
Date: Sat, 5 Oct 2024 12:57:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hmac - Improve local variable types
Message-ID: <ZwDHUGIG_BvqJboW@gondor.apana.org.au>
References: <20240924112727.240950-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240924112727.240950-2-thorsten.blum@linux.dev>

On Tue, Sep 24, 2024 at 01:27:27PM +0200, Thorsten Blum wrote:
> Since crypto_shash_blocksize(), crypto_shash_digestsize(), and
> crypto_shash_statesize() return an unsigned int, also use unsigned int
> for the local variables.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/hmac.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/crypto/hmac.c b/crypto/hmac.c
> index 7cec25ff9889..6ab7ce4cb930 100644
> --- a/crypto/hmac.c
> +++ b/crypto/hmac.c
> @@ -31,9 +31,9 @@ struct hmac_ctx {
>  static int hmac_setkey(struct crypto_shash *parent,
>  		       const u8 *inkey, unsigned int keylen)
>  {
> -	int bs = crypto_shash_blocksize(parent);
> -	int ds = crypto_shash_digestsize(parent);
> -	int ss = crypto_shash_statesize(parent);
> +	unsigned int bs = crypto_shash_blocksize(parent);
> +	unsigned int ds = crypto_shash_digestsize(parent);
> +	unsigned int ss = crypto_shash_statesize(parent);

These values are all capped by the API.  So I don't think this
churn is worth it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
