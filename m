Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8253435DA47;
	Thu, 15 Oct 2026 03:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792035519; cv=none; b=LWOXf38Sr3/OuU8uG6vd3DXDcxoCVgbyJ2+C+0noBLNZxD/5YuTpv71NKwmWcJjSvruSBxqm0hnbexANKMlCDaM/QDz9L0x6B1wG/VZ7+70tGVcEi1/zV4B2xX0KK8/PwBW8NBzV9VnyN1nWKPDHfv/DfR/0VvyLH02pxxpaCGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792035519; c=relaxed/simple;
	bh=CZHcVdNt1V2Iji5ZTXAfFJOAJHzY0Dy37ZEvo2hDgiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+Ryha4f87SRC5y4xnt50SUwa2GaBFgBsUz9fBdDtF6eVewrV6CbDDFdrCt5opILqPCYhvS+yevkN1kdfUfRmHlIuiZ05qKiF5B9VbvGehJmKHvvP/tHCoVWF5RJW2E+UoPjFQdenWooIT5y9OLR+vf9H/RM7Il2LGxcBFWbo+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=BjDEgRgG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="BjDEgRgG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Sc6VKg5gYpkq60oiW8V8hAYQDoClurKYFAZ6GPkKRow=; 
	b=BjDEgRgGK9Qn1QEyKxQdglZTIodjl0jWDZoRL1zI9IQMeQMDzJ/sMcR9HjA01kIpTy2Ym7+5CIR
	vJSovDlVtD+vYoLxmWXkNkwiDU75n5DhcYzY6+ePY2vk+T7FWz+LQcoA6NLGGdSPMzlLU38zXiv1E
	5vIZXHoewXMhkbQYPGmM4ynyOfGAHtkcZPlT5KztfhCUgVvsq372BSuYpADttqWHiKbqeNlblPBh+
	hMAcJkhIGiMEzopouswW+RIHC7PFUn48PP/56JIm4hjfq1SnqNotEY2dhVRsWitmPpV10YRARl1nh
	3RsSK2dytZixj1KCiBo8FkGgyuTDYt3po+LA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHCIR-000000041tf-3R93;
	Thu, 15 Oct 2026 11:38:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 14:38:23 +1100
Date: Thu, 15 Oct 2026 14:38:23 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: essiv: fix use-after-free in AEAD path
Message-ID: <atBKr1-gTDAJ1IRe@gondor.apana.org.au>
References: <20261014222351.2930674-1-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261014222351.2930674-1-Jeremy.Jean@oss.cyber.gouv.fr>

On Wed, Oct 14, 2026 at 10:23:51PM +0000, Jérémy Jean wrote:
>
> @@ -247,11 +248,12 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
>  				  essiv_aead_done, req);
>  	aead_request_set_crypt(subreq, src, req->dst, req->cryptlen, req->iv);
>  
> +	assoc = rctx->assoc;
>  	err = enc ? crypto_aead_encrypt(subreq) :
>  		    crypto_aead_decrypt(subreq);
>  
> -	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
> -		kfree(rctx->assoc);
> +	if (assoc && err != -EINPROGRESS && err != -EBUSY)
> +		kfree(assoc);

Last time this came up Ard asked for the rctx->assoc != NULL test
to be dropped completely.  Could you please do that and resend?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
