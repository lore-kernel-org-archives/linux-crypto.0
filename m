Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8638B318ED6;
	Thu, 19 Mar 2026 04:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773894055; cv=none; b=iPb2P73hjEUlgYcYkCETGPMyz+qKt9+lkkKPbNzl832RJtk2f4z5b6ZBkIHVyKCb2lZu7lp6tR0oZuOwAA96NPOg1jxXQbBH+j/45ttoD/HLzjywSb8EVJCy2/lemfOnhNNioBZo+ujvTfLEg/6hVDlOfCPkhnPvIG3tMXQ6nB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773894055; c=relaxed/simple;
	bh=2te8/ukVk5tkn/UMG9/I/B0cAeCWAo4JFhY+rfv94Xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KdW8Nloi6HqHTMdbitM5TzYzI3H9u9keC8+VNrCfKdQVS4RMCwOH4wFCcvPgKivZSmuAdxvnP8cop6olriWUm6RLBO5UUiDSezT+E4icv87dA+L5WAIhqMuQ2yFWWgiJsoEGb80mQku/6+nvYnnZPSdrEpHXpL9+GilA5fXfjiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Wp+qcqCi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Wp+qcqCi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=LWQLY8nIw/SpSvEj+/isvem6465b7xcUOlaktpaOEtg=; 
	b=Wp+qcqCi4AjjeHihETJUI1GJZs+tQxNt3JkMgEhxtbSJHhsltss4aSjhis2bXufVR+50oUvc72q
	hofkCM7Khcsv8tIy8U0hlSV4OSZxNTwYV8VGhjyNS4BLDeWIbFH4HzGlmfu+hDwMZe0TQAalhbsSR
	4N7XXIEdvKn0I4+urXSTJkZKhe40/fgxygybFfIrG5P0q/vWbyQmyFGcbUXDUBigDHt4p/SH/RFbk
	1fBSbAftrm0AcJpnWOU6v1RapopTrdvFBZVu1J3lGrLY/cSjjBN++VIiRc8/QYDG6JNxC9aS/UejE
	vFqGl18tVO12J15lNzJqYwQ7uAZ2CcGJcg/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w34s7-00FdgR-0e;
	Thu, 19 Mar 2026 12:20:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 19 Mar 2026 13:20:35 +0900
Date: Thu, 19 Mar 2026 13:20:35 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>,
	Yuan Kang <Yuan.Kang@freescale.com>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: caam - guard HMAC key hex dumps in
 hash_digest_key
Message-ID: <abt5k85OBr8LGaFe@gondor.apana.org.au>
References: <20260318194649.137257-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318194649.137257-3-thorsten.blum@linux.dev>

On Wed, Mar 18, 2026 at 08:46:50PM +0100, Thorsten Blum wrote:
>
> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
> index 167372936ca7..3392070942ab 100644
> --- a/drivers/crypto/caam/caamalg_qi2.c
> +++ b/drivers/crypto/caam/caamalg_qi2.c
> @@ -3269,8 +3269,10 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, u32 *keylen, u8 *key,
>  	dpaa2_fl_set_addr(out_fle, key_dma);
>  	dpaa2_fl_set_len(out_fle, digestsize);
>  
> -	print_hex_dump_debug("key_in@" __stringify(__LINE__)": ",
> -			     DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
> +#ifdef DEBUG
> +	print_hex_dump(KERN_DEBUG, "key_in@" __stringify(__LINE__)": ",
> +		       DUMP_PREFIX_ADDRESS, 16, 4, key, *keylen, 1);
> +#endif

I'd prefer to keep the compiler coverage when DEBUG is off.

Please add a new helper, either print_hex_dump_devel or
print_hex_dump_sensitive that only gets enabled when DEBUG is
defined.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
