Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247931A38F9;
	Sat, 22 Nov 2025 03:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763781556; cv=none; b=tMnIe5qQSlSLjxer7ZxmokfVucoIovMSlhQ5gqglr3Q8thShq+56BMUIS9Bqlx87X+vwZeeRueCfHSCzOlI9ECX3vSYeDn84LqrW0PtGycWuvGTFmG1fr/2ogi8MuM/ru5v25ikkXV0ra2OXN8j/Ma7oGEdfAQ5/sVLWNVo2rbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763781556; c=relaxed/simple;
	bh=+kJWv8EX60hntoHVCzVCHbdtd95JZoWQzGWNmofOs9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m5skjhK42OLw2T08qZEo08o3T2rThjKb1mPx6Q3nZEYdWhwrSyBMNR+Gtxwmzpg9OJ484EnYunNyI6dBbkltFb5khjU11HLvce4+X5pYIw+Xj6KEPlsF8jLfvBkMGPq4fdSotQK68D1lhWCA1aQB7AURXCaIHkuOrywjZvAbqV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=b2OlJ/M5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="b2OlJ/M5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=OWQCQV3fc7yk4rGSSf535qJ6HM6l02Xbh0AgmZsQFYM=; 
	b=b2OlJ/M5kLZDkFIbott0k5JSj1cmTVoUyHrx5A2Hy/qEi2AKw6ncyyZ2rejiXCHrAa+cxwi7NTJ
	OeP0Os9gHgk/h6Y2DIZgbC6J0M37tnz9OEhNZcfWr6nMztoSiED/6GFtJzLKTzU5sWAc8obhUqoq7
	G+ywV7D/Mvl46RSkmiSzl/oKaW7mjcUY+9UmoUCqg530od337EVKPJMraVcN5jvmCd2CcZsjsdT1A
	EpGTdFel0d7uIuv4rhsZnelK1cHugPHHJkFRG5yJXSUg8tEioFE76h/g3G2IxHYoeaBYAlFbA2BUH
	9ytn8xIMVshagwA8G0nTmT0+DzV70+1nJ/pw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMe9V-0056X6-10;
	Sat, 22 Nov 2025 11:19:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 11:19:09 +0800
Date: Sat, 22 Nov 2025 11:19:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH] crypto: iaa - Request to add Kanchana P Sridhar to
 Maintainers.
Message-ID: <aSErrYJjNgfnrWg0@gondor.apana.org.au>
References: <20251114182713.32485-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114182713.32485-1-kanchana.p.sridhar@intel.com>

On Fri, Nov 14, 2025 at 10:27:13AM -0800, Kanchana P Sridhar wrote:
> As suggested by Herbert, I would like to request to be added as a
> Maintainer for the iaa_crypto driver.
> 
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
