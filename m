Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EEE2AF00;
	Fri, 29 May 2026 06:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780034422; cv=none; b=kpfetXn1eqYv3NuLmmMKJwr3l9SAEGAXMxuIUFYxdNDwMfIB5gQH/TQBUBBr16o/OTjA9kL6Y/hPHS24m8kSo1IwoGOxmI5aFbDeTDcxiJCFLtgpfZ0uZ9k3LwK9Cfc8PaB/bwwIx8g/X1XHioNnmDu5nUuDUT+DCi2eCxGEj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780034422; c=relaxed/simple;
	bh=jaaAo6XjEI1s/BqSAA5vLV0ueaJP12DD1nZEnD6eRes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qu5iCBb5TZugWc/xu5Y6I11sYvjVor4FE02OCM7Vt0zD9l3eyqqXGyTYJfqjoevSvfQC4phszVqWrASFArt1qRsqOkHm6PlLki3QLzTE1UFI6OknMMPQm3VEoPe4MQw7Ctbnh1y7Tkt4aA1Wh49l+U6O3lLxSfOcsGjW4yMPUJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mKkeKlmS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mKkeKlmS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=MDu8S1s5aFiIEX9NQS39TExk/Ti+UAQOPHihIqPaxF8=; 
	b=mKkeKlmSntqEMEhXAOR+XLC8QytMnpPrg1cl7jJxvvesBTABMdjmP19yWflFfDQAOMdnceZsBoK
	nVGkswSJcVZ0BLRxQrL+dMEWnQ/sU5+AE4jaf7J5RB12KKa2iTYN/mwa44bCO77qPqq7BOaxyUVET
	IpN6V8Dbprb62c0igHLmAANZyQIB7yxwDbYYNIZZaYnoz4iaQDKxJKA5VuszRu0lBHUuu9OyrCTb7
	xls6S1Fbx3E2qW+jcEdrpJmIQKVSFg6dxQm40U4oBbMZJKb6svJjQ/4ZcrF7WI+iIZ1cV9O6lVDOP
	Q1yDwJ0rki/oXxYgIui5xFPvcCp8bShGi9nQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqGQ-000d8l-14;
	Fri, 29 May 2026 14:00:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:00:10 +0800
Date: Fri, 29 May 2026 14:00:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, atenart@kernel.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - Drop superfluous blank line
Message-ID: <ahkrauzXbzjgzkCn@gondor.apana.org.au>
References: <20260518212304.290520-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518212304.290520-1-olek2@wp.pl>

On Mon, May 18, 2026 at 11:22:56PM +0200, Aleksander Jan Bajkowski wrote:
> No need for a blank line.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/crypto/inside-secure/eip93/eip93-main.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
