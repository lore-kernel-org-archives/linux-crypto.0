Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D5E51DDE4;
	Thu, 15 Oct 2026 12:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792066805; cv=none; b=ArC17B84kF5ouz121x1HnTLCe0Tbi32KmztaSgOjdrCBm05SXU86upScdV+vheEzJbhi85HxNK7b8bH2hgz+8oxFD38IGamFjAHPuITOIbAfetoy04MAtq6F7woEGf9Uu2RLd/qbX/BkYfLiRu1MRp8oDNir87lX979JpOnJYZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792066805; c=relaxed/simple;
	bh=VUDM9gtow3o4LRWb+E3zC51mYjtRZmtrBgYtfTqbMJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ImMwqrON6IKuXzSpwlms0IJgfdDmKNIhnmLgO5iJTD1l/V+hMJ55VBLeyTit9wc6IrKYBXcrFk2pOnNa3a7Ncv0e2KdouF7EShv1pUcUC4somf7+bUijkFLqBJzwCYjw3UccTru/CBbhfJlsBblT1Z7HTGB+9egZ7p0uyyI4al4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Y/2AGAzG; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Y/2AGAzG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Jd3nfwLVD1yY89LAQ7zdBuWux1fPDOKfqkLmrKOVgvs=; 
	b=Y/2AGAzGGUWx9SX3XQo3/HpKTdPXoE7X16tgY9cMiJyGSL9wPKB5kH16xOw545LMvF2NONJm50I
	nDbZtaiw9zEOP0LjWEETm9ql8qoYgX2IUfke8pvsPKrgOBHatk3OZEy9fNtn+8zZ12TV5voQk3HyM
	WciN8M5ljQA/KxL1b/JblKx8qrz1NQXO7/nCtRkltiLbt22Zp+vGEp1zpqw0cOw2q4BQRuGd5dYP3
	z/T1jqE1Zja4pCMfTax1YpYKMJKfDu3EbJ7H5Fi+LO6BQUpHMQhDOhUDJk3iHVRWIoY5bKsk564kP
	8R0WI98CshKJ98Bd1pzT24uISu+OsUhBmIyg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHKRB-00000004ArB-0W9x;
	Thu, 15 Oct 2026 20:19:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 23:19:57 +1100
Date: Thu, 15 Oct 2026 23:19:57 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: essiv: fix use-after-free in AEAD path
Message-ID: <atDE7dqBGm63pkde@gondor.apana.org.au>
References: <20261015121743.3151400-2-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261015121743.3151400-2-Jeremy.Jean@oss.cyber.gouv.fr>

On Thu, Oct 15, 2026 at 12:17:43PM +0000, Jérémy Jean wrote:
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
> +	if (err != -EINPROGRESS && err != -EBUSY)
> +		kfree(assoc);

There is no need for assoc at all once the rctx->assoc test is
dropped.  If the condition is true then rctx cannot have been
freed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
