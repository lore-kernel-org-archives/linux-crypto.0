Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECD538D3F2;
	Fri, 17 Jul 2026 07:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784274740; cv=none; b=PBdoNqIv9U2y7BZ+7YLyvLyXtZlSmsg3OvSLT5lvpWa9H8JKK2lqGizf3ygkchQmugFuyUxEfr1dhuv3FnOd7ieqfm5TWhyZeuy3buP76mBJjuVCmyzacLCTKXaBS+Q7FOxYonH58yuuAuS8h7kl79+F1yvdI3p3/17t6TXnQUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784274740; c=relaxed/simple;
	bh=MAiMSBSwUisF6BFlXbffP1Yu3wHgZSv/LTUj/qukT0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=maozZalNAe/B7TNY/2XIJK0DtZ3ucR0ngrEYFyt55nuK8tnFs4uQaQ7JcFDbibFQtIiFkfyZVhy+2JNwJKnH8HQS0diOG8VAVOYm+pf7jETCCWdFNf7t02IdeKXWiynsbTJR2vlJhsQEBJkbisUoW3OM3NzCfw2JA3UszbNSK6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=lhZCOLLO; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="lhZCOLLO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=5U7c8tWt6k422BbmITKu4Ii4R9579krAxUNVe8Ab9To=; 
	b=lhZCOLLOWnQy81cB7sTTPRI5qVgEImq3bYEOll8zO0ey9a2sEO8FmJiu7xGSLxSGljH1wism/QN
	WiBnxYlpNtz7YhBKq5vmh1pwiSFJLjXOLc4msDcg9FwQ3E3JieTdEbcIPLXNqXRkVMJVP6VQWixWr
	VvH5BnXDbdpZNKMYMgguHzisexLonSvhFqxsvoPVLFdHSzZ+MVsUSCvkswu96YVE6WpuumiCMDXM7
	WrS46aRofVtZr2kaYbD64ngzKcje8cLeQibiquC6IGFxqvx+k+t8BKREBEUA2rGt2hoFbfldTD06S
	P8ks328SyUORXME3uHDhYiRnDXugSVULauxw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdMh-0000000ENXr-2JaP;
	Fri, 17 Jul 2026 15:52:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 17:52:11 +1000
Date: Fri, 17 Jul 2026 17:52:11 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jihong Min <hurryman2212@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: Re: [PATCH v2 1/5] crypto: eip93: guard DMA cleanup on uninitialized
 mappings
Message-ID: <alnfK4PRK4rkDfoZ@gondor.apana.org.au>
References: <20260707171537.467608-1-hurryman2212@gmail.com>
 <20260707171537.467608-2-hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707171537.467608-2-hurryman2212@gmail.com>

On Wed, Jul 08, 2026 at 02:15:33AM +0900, Jihong Min wrote:
>
> @@ -534,8 +536,10 @@ int eip93_send_req(struct crypto_async_request *async,
>  	memcpy(iv, reqiv, rctx->ivsize);
>  
>  	rctx->sa_state = kzalloc(sizeof(*rctx->sa_state), GFP_KERNEL);
> -	if (!rctx->sa_state)
> -		return -ENOMEM;
> +	if (!rctx->sa_state) {
> +		err = -ENOMEM;
> +		goto free_sa_state;
> +	}

What kind of non-sense is this?

Please stop wasting my time.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
