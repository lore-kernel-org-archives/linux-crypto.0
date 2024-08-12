Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E91C16F0DD;
	Mon, 12 Aug 2024 10:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458813; cv=none; b=VF+e3oD48dp9mznS5YvLsvduSzlLnSfMeqn6kR0WtWRTs3mpKsU6mlavgg5d3psBftgvjJhd7TgCjLf+zpYnsEFdTeyy022B0UAnT6e+K6Np9fcbHfddjqhiOw81As9OyerKPbcrzuu5wIgOiejxDmmgzMXvLqIgUI8Xwa+4OFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458813; c=relaxed/simple;
	bh=B8Qbfd2UQVuWQpbmzy8EOiYoqBi8gM63YNxBCXhCd30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFirUI5Din4Q2hvQlR7WaRPurjf+py55Zu6czx+flUCHr0lW7JEDPguGfhvxH0sEC6zA23QsR0My+Ov4zGPHTb+wdWG2UN1xAHEc7ylU1/jrsxqA0t1K4BWcqeERhsg4IEl52wqiAynrGZKtxEVK/YnxPVbm+83czVWcuDvgpSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sdSE0-0044x5-2v;
	Mon, 12 Aug 2024 18:33:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 Aug 2024 18:33:13 +0800
Date: Mon, 12 Aug 2024 18:33:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>, lkp@intel.com,
	oe-kbuild-all@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/3] crypto: api - Do not wait for tests during
 registration
Message-ID: <Zrnk6Y8IDxmN99kG@gondor.apana.org.au>
References: <ZrbTfOViUr3S4V7X@gondor.apana.org.au>
 <34069b9d-3731-4d0c-b317-bcbc61df7e9d@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34069b9d-3731-4d0c-b317-bcbc61df7e9d@stanley.mountain>

On Sun, Aug 11, 2024 at 04:30:10PM +0300, Dan Carpenter wrote:
>
> c72358571aaadf Karim Eshapa   2017-05-13  368  	pr_err("alg: Unexpected test result for %s: %d\n", name, err);
> 73d3864a4823ab Herbert Xu     2008-08-03  369  	goto unlock;
> 
> This calling crypto_alg_put() on the last item in the list seems wrong either
> way.

Indeed.  This should just return.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
