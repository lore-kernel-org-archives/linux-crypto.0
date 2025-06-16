Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3D628D8C0;
	Mon, 16 Jun 2025 02:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750042677; cv=none; b=jqTly/dgYYhbU0gtUqJervhABDGar3HQJCQlkY2ka2TgrFWHPhth1zzVqk6wDSxhp33VnxKyGzpCpQY072ifHRpmvpdhPaSrYzNazo+0WSWc4uAG241Kr4Cz7ul15JYsIQM1EBbRe5fBZVBS80Y3+yCdodW64uB0zOyXAY8T0QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750042677; c=relaxed/simple;
	bh=JHtyBMhZMq7rLRDVHqLS9ppKc+pVnVIs1DsdASXRp98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lbw5gWJFz27dKMcJ0OBLjCapyW7b4BmsC7dBUeHgi6DQeNp2DQgILEL6wTOq+GIcReSUrdeJX8ov0yWhJ2wdo+2LAS7EkpXvwEHnsoR9/AwG/ueIIDPbu9PreIAojY1OB20URs1UMQUUqk3liXmGSuXNhtgtTszFTf3v6Fhw1HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lESr2ySu; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lESr2ySu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7By6MJ1Fsc8uXWLkUPRl/M51yuYgmOKip7AFJpU06TY=; b=lESr2ySuFhGN2Bp4nrQcAtFJdr
	JGF6VpgVU1gldJ0wxHBZFMoFvjKpuc4kK/Gat6MLM5L2di6E/D2zJ6SbIcb0fOGa9KRS2AFzbdT1V
	pH1kYQ+07eTazom1WFHGih9ixT6uz2uhF0JnX17mfdFLfWb4H/zBfA5Vb7jVeaHg4vV1dZccs8WA3
	r29gaU0WYkOe/p1ZcazoEzyRqqAGd/YTrX+4zypuadJ+l/oRhYZqE9fC0sQyoLw1ZblKZOH63P7cF
	xfB8BxdtyW2DoEU6wXRC6TNSMUQZMjEk0DMRr6R4HvmUb1l1NIB6P7OeJF29wbkARXzMn/R9EVdA5
	p1kIHjQg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQznY-000Id0-0N;
	Mon, 16 Jun 2025 10:57:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 16 Jun 2025 10:57:51 +0800
Date: Mon, 16 Jun 2025 10:57:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	"David S. Miller" <davem@davemloft.net>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>
Subject: Re: [PATCH 0/2] crypto: replace cpumask_next with better API
Message-ID: <aE-IL6Nyrb6OO-9D@gondor.apana.org.au>
References: <20250604204742.21183-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604204742.21183-1-yury.norov@gmail.com>

On Wed, Jun 04, 2025 at 04:47:39PM -0400, Yury Norov wrote:
> From: Yury Norov [NVIDIA]  <yury.norov@gmail.com>
> 
> Recently added cpumask_next_wrap() and cpumask_nth() work better than
> cpumask_next(). Use them where appropriate.
> 
> Yury Norov [NVIDIA] (2):
>   crypto: pcrypt: Optimize pcrypt_aead_init_tfm()
>   crypto: caam - Fix opencoded cpumask_next_wrap() in
>     caam_drv_ctx_init()
> 
>  crypto/pcrypt.c          | 7 ++-----
>  drivers/crypto/caam/qi.c | 5 +----
>  2 files changed, 3 insertions(+), 9 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
