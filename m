Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59C51F2B88;
	Sat, 28 Feb 2026 08:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772268246; cv=none; b=skFQcgIQpcOOgjTE77SZYL+sLjpZrhPbXQ/ZHXPFeSEEtc+/azfjHq32z5NhY2ar+RrHcKZfkuMDoMt15hIO3W0jqfiDsQtfY+8a+O+5r7Heq14Jr30BXOsoA2mzId6qEvddtBiejN+GWoNPeTqjiNL0T/A6NjTPGIx5hzJ26zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772268246; c=relaxed/simple;
	bh=yVrdeMe9ZtBfxF7tQWl6TM/5Shzp0gzPb9g4CCFZwpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0GjBhpJsMDeTUZu2SXN3cXasAMresfZjsBikQlv4XSQZu6YDmgh9Acn4P/3VMQEvdEV720WAjvvsgh/o85E97dXMPrr2qIUg3Fqj7JMJv85pSmgWeHRhKTM9Ph05mOZPPtIJRXZOb39rVV4l+7lvO6vpjgZKI6jXXwfGhHm0yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nKFLOnBq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nKFLOnBq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PlHLJdTKWplxNfrfeHra0/ZfY38N5uglzUwEdJTZmpo=; 
	b=nKFLOnBqwoF1hxelaNja9qwGh0CqvfSC/rVHvkLH2i9ofS7nAKLBXjZY84KRAil9jHRdeH9BM6Q
	Mi9vOTmFjdCDwbD1SAlZuF2Q+aZA3eHpZdZ0GWewuENqzp/EYHFKv5eLBMlftH5C8b3d9Pt5PqqsI
	msy9YIzFtI/Hnfh1ZGmIm6JeldrPy2/6IqbKZTASFIqGuMh/tODiTQML63SBG8btIvWCMFcgsveTG
	0vGp+lmcal3RHZYJfMiGIuiGqkgYz1VpOVUwnwLpH5mXkJmRAb0lYtjKJJmjhR1+EqAj1IokSxzKJ
	2+BnLKYW72FevrDpU8WGWuh4wrclMWIuguiA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwFvS-00ADnR-2P;
	Sat, 28 Feb 2026 16:43:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 17:43:50 +0900
Date: Sat, 28 Feb 2026 17:43:50 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, atenart@kernel.org, davem@davemloft.net,
	vschagen@icloud.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - fix register definition
Message-ID: <aaKqxiftG2Al_nq8@gondor.apana.org.au>
References: <20260208103602.8168-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260208103602.8168-1-olek2@wp.pl>

On Sun, Feb 08, 2026 at 11:35:53AM +0100, Aleksander Jan Bajkowski wrote:
> Checked the register definitions with the documentation[1]. Turns out
> that the PKTE_INBUF_CNT register has a bad offset. It's used in Direct
> Host Mode (DHM). The driver uses Autonomous Ring Mode (ARM), so it
> causes no harm.
> 
> 1. ADSP-SC58x/ADSP-2158x SHARC+ Processor Hardware Reference
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
