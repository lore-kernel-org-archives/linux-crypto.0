Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DE9379C38;
	Fri, 11 Sep 2026 05:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104498; cv=none; b=cd0ytZND8iILUU5rl0+thAbccbvEiHF8tVvCnsn43gzyPRi8ghPmdf3eJdR3sI/A3s0L5nKTbBpidcBHOi/4NzKZHw4UEP3d0tCm3lOloo4nY2N3TjN7BKIXc2WEnDKlRngJO9HCuOptmXduWKIuvVx9t1n86y+Xw4+hVlr3H14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104498; c=relaxed/simple;
	bh=WVt1PqELCaucaDhp0F/4DXqtyChTTiTvMiZpRR5pK1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mqnzW4snSUq/u6pmdvyvIvxVS1ZHMJgpmgzKD69/d9G0KJzNm+0UOhK0JQqUapvPgfRPh2eEVjUEJweH8ERAEzEAv9986gohbgHkUti6oP59OEOkarwOOrRUkBHsBSVwtZOmLB4t5KmFHkrRGa+hqpCv+l+7fDbJrC/xTWKe+J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iutcW8Cz; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iutcW8Cz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=sXaW7nLhdxLR/EafmtojL5rr+PSsllONQeXcJl7e4w8=; 
	b=iutcW8CzcMtFZP0Lw34a+pq4coz5T8bipcXOGXJHnG4yXImdRHwe2Hp/1Zb+VVii5OS+fM1Jklx
	YO3L/HlUYHOBwr9Ppgb2Mb8ouiqiCkTgA3XxCIQgR+Fal6ofvWveTiyGWOankS0tsuV20lEmMBN1q
	jWeEwFGfetFAre9E1WvA4LAxCb7KfmIsYQON/B4NhWvNdc6OOf9FOQ03SezFZQvSS1U17GttWutHC
	raXjZWyZsvda54bGtTJD/AsdOg8wd8Af+W0pOi/6ylDx1ryLysj8YxjLdOfIOrfdgsq5KZNpi44co
	3Gcj0bTdlC7kgtF4k+yrz5izfM4/8yOUGLHg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tny-0000000Cu6y-4BUS;
	Fri, 11 Sep 2026 13:28:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:28:06 +1000
Date: Fri, 11 Sep 2026 15:28:06 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: rsassa-pkcs1: fix undersized key handling
Message-ID: <aqORZi129t_AHaku@gondor.apana.org.au>
References: <20260826103744.1554131-1-Jeremy.Jean@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260826103744.1554131-1-Jeremy.Jean@oss.cyber.gouv.fr>

On Wed, Aug 26, 2026 at 10:37:42AM +0000, Jérémy Jean wrote:
> PKCS#1 v1.5 requires an encoded message of at least 11 bytes. The
> signing and verification functions do not reject smaller RSA modulus
> sizes reported by the child implementation.
> 
> This series include two patches due to integer underflows:
> * one in the signing function that can write OOB,
> * one in the verification function that can read 1 byte OOB.
> 
> Jérémy Jean (2):
>   crypto: rsassa-pkcs1: reject undersized keys when signing
>   crypto: rsassa-pkcs1: reject undersized keys when verifying
> 
>  crypto/rsassa-pkcs1.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> -- 
> 2.47.3

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
