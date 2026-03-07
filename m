Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF4A368277
	for <linux-crypto@vger.kernel.org>; Sat,  7 Mar 2026 04:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772859325; cv=none; b=gXbTl+kGTPfAIr+4tTa/bnio+iXhuSxVtMXeOV2/+cLBJ2P9i0/Brj/AG/hYvEK3MCmX/zrqhmpYqUwq1h7ArJfqDW4TFqAET42Tgen+iODllyYzyC2nonOA2WwCLieRSdRIimv2su6FrQmSXsA83rwY9JpvzuMAxJcr1kRRtqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772859325; c=relaxed/simple;
	bh=wJuLBwtfOWkCL/Bdq/IkoPQlvPknEemntdr4oNvsmcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iur3TC+6PRLIEhyRY7etkgQn72dJmOJcyE0mQsDMIO3qr0R4anBv0/DcLb8dmz1T6MC2BboBmztbQc0jcL+J0ymAD4tvDiPRc3S1cX6cdMpBTcT28oqsqAiS2022g6IqlnqOcsmnDecYlWJTXkYajj3qgZVM2Nu/4kq7yI17Fh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=oDxr7nho; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="oDxr7nho"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=a9Ffc54MZsxWrWbemDVNJ3PL5DDdE/sA8SMDKbeD5xo=; 
	b=oDxr7nho9gdil1lXGjKz9wcg388Hexj+Ejkifm3uf9cR8lsdtZFrs6+AdrNzjqAZhQ5daMZhCuK
	RuE5ikTRQ5ivgmHCdUOwWZvO1DkjtoZx1Ln1rWYjVmjWNZlswXz8imkcStiIizW/HUuyDSGARRimk
	M+CGo4+iHUsKmwc3k+2bs/RXRKlbSoN2AAnzaocpFn5DeLtvOS8zBo7X6A2zOUZ7zzCXdKnnI0i9p
	ywdkfrcEMSMXGYbBO3zn6jKacAK7/Ik2z0XdRGTvuk3TaH++0FDxLEbDDAUwm+/5v3nj4L9WcC4Ij
	8u23NWacTHmLDGF3o9ErzyZvJkvs3HsvSD2g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vyjgv-00CJHt-1b;
	Sat, 07 Mar 2026 12:55:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 13:55:05 +0900
Date: Sat, 7 Mar 2026 13:55:05 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sun Chaobo <suncoding913@gmail.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH]  crypto: fix spelling errors in comments
Message-ID: <aauvqWqXqzu_pZYS@gondor.apana.org.au>
References: <20260224033756.78693-1-suncoding913@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224033756.78693-1-suncoding913@gmail.com>

On Tue, Feb 24, 2026 at 11:37:56AM +0800, Sun Chaobo wrote:
> Fix several spelling mistakes in comments across the following files:
> 
> - crypto/tcrypt.c: Correct "intentionaly" to "intentionally"
> - crypto/xts.c: Correct "mutliple" to "multiple"
> 
> No functional change.
> 
> Signed-off-by: Sun Chaobo <suncoding913@gmail.com>
> ---
>  crypto/tcrypt.c | 2 +-
>  crypto/xts.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Please merge this patch with your previous one.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
