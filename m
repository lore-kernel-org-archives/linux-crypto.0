Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756284;
	b=jP//wHS7fuh08j+5o3vkobVSjI9ipEP+yo/Hu2z9Xglmh37NCSgMq1dB8da/VJ8TXjj0
	 TBiGeKZ17Qx0mAjNOR6Iv1mNmjHsWXLQmVUPBjMw6c+3HssWqX5v5UwMhx71DRPfPx3y3
	 77Tx+Tib91XnrqqxV3P7MVBYYapmM1n/QIhG7eqqDJODSuMfGaCsWS/WUQWzMzFIRwtZT
	 CbkoElIKy3sBBNs+guaNLEq2KicGSFnej/F20hFHJInN5tzuryJD5zAuK12/yMP8R6Y5v
	 ys460cn4PIxuUS836ngojsZVGAoq5oFtKEoRbYOyaFO1EuF0g0NKuyVYgahCi1VCuBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756284;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Newsgroups;
	bh=CD98uwzn1z5bmXKFQMAS+XVWTHzZRqrm72A3gkcUC/c=;
	b=bAADI0PtvSWyuuA7XjKBqFtRFnElVem1fDVelXZ+hvIMqxUGciE6OKxxCIjC/sPPH5eQ
	 /mAJzzQ5Erw5mfXAj1VJ+xxykTGrULW3tjHSCU1l1bTkTg+T6bLZD+jriWkBLsppHaYMR
	 oVYhEf5nkLJB91SjY3a8toUj1G51DBcfAdd8CJlqS2Tnl7gHEH8GG+LaaYk29BAItsARI
	 VEHvNSpsMqb+k7Zcms/dPW5D/Al4B9lIQbvUP1SJlbmVPr//JIAhgVpJWmuZtQsQfcwOY
	 2VOtAYkcOfCCabd9IWI67VqTRXzXDzEEo6HRQ8QjKKIKzsonTw8/BBYG98rd2/Df2dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=j6D6mOcG;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C1B606A31C;
	Fri, 27 Nov 2026 05:11:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87C1B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=j6D6mOcG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=CD98uwzn1z5bmXKFQMAS+XVWTHzZRqrm72A3gkcUC/c=; b=j6D6mOcGBcWywulh6qiz/EQtzi
	0abysrqGMeMpxS0k3/ualj3KXu9k5kirL2ajHmqZIr1LchIKxUF2PW08ozSfS16pvAzfhY9Hg6+dx
	/h1RZdAdThK7fFXmxOwnZkIOF8xqqdYhd1Dn+oJZzJNe8h2qiYCpM1d8NgPfJb7GrFQfC21L/w1Jg
	HYJkIc1q/usSQV0oRVg0lJTJgsRTphvLzqCLYfks+6PD9mr02urhp08K6GlRPI+nkut6mRk+bm3+1
	1SE4qqTvUW8muSxXs96+zAeYnAMZLjFDwp9KhORCHQxHBF+siXviPGthkHCjDCeJFYvzvXRszRI62
	vd8WDy8g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoEx-00000002VTj-3CQq;
	Fri, 27 Nov 2026 13:11:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:11:19 +0800
Date: Fri, 27 Nov 2026 13:11:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
Cc: ayush.sawal@chelsio.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: chelsio - Fix potential NULL dereference after
 detach
Message-ID: <awkQ9-PZryz8Ss5s@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-c29ba55625-crypto-chelsio@mail.sdu.edu.cn>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Guangshuo Li <liguangshuo@mail.sdu.edu.cn> wrote:
> Detached contexts remain on the inactive list until module exit, but
> their PCI driver data has already been cleared. Looking up the adapter
> to reset its counters then dereferences NULL.
> 
> Skip the adapter lookup for detached contexts and free the contexts
> without accessing the removed adapter.
> 
> This issue was found by our static analysis tool under development.
> 
> Fixes: c0271a053612 ("crypto: chelsio - Resetting crypto counters during the driver unregister")
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> ---
> drivers/crypto/chelsio/chcr_core.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
