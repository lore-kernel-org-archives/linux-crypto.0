Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1775B27EFEE
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774345915; cv=none; b=UwDzzY3MWGwquPGAGA8mBK9gcZmsqLTrIADQl1tvRKiQM4gr9ea0TE5TKfXKSxDh2+0+FWyox24Bv2+xoU+0aP4qtswPSudh1SimZZSc7X3NveP9VCotyXhyjAVuxxm3r5eaUMoxCiuSFXjzQ29+4JfeCRRMATxJmupviSvzJmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774345915; c=relaxed/simple;
	bh=DN5nBzZi7SMTH8VUEEE3sDCT3Tpeh++Aw0R8hjEJb70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4iVTNtJMo/FJeYnkL5ZE8nEB7mjbmIR1JJSTeScykHiayCRYxO9WnOEAJvvPQllg3d0JCiNFu92WmKYXT2hw2nJNDc7j8/i4oYrkWHqCQ4Mmrv3HhTiMl9u7hSJOKPtuiQjovg7z9CLz39mZCPCWklmRNCjmRRmP2OlhPmgobw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=VLrem8Q4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="VLrem8Q4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=KmLEBsSkXnq/gYdqmgK15k/M6aXu1Jp/BL2Eh+G9zHI=; 
	b=VLrem8Q4rw+1Ku9eh954MsxbvTAYQyT+nswMna2Z2y/7llti4U3FRxPqR9SOyDKfky6LQ6QyAtx
	f2F3MAr0a58mLRwdB6QHaWPfoDq0onS/geOK93vy66nDyujFUoWUOQNO4ZOpnFF8EHqNlGbwwj+o4
	fZp6Ixr9kwYMRnU3nfCiYJQZgXlo3q/+7kDw24y2kbbZpyv8W7YePV8KN3noRSZeSYWLvF9ipwLEr
	/DutWLMloJbqJ9WYt1wwMhZJGZ7+QvGR42CtT1ooZEVy/2foTjBmsm6F+z2voX35vOhwisaMXW6K8
	gZvFbM3hLrD7P11LAYB8qLW9zQP9EeFBE5wg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w4y0o-000cOL-0t;
	Tue, 24 Mar 2026 17:51:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 24 Mar 2026 18:51:41 +0900
Date: Tue, 24 Mar 2026 18:51:41 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, Paul Bunyan <pbunyan@redhat.com>
Subject: Re: [PATCH] crypto: caam - Fix DMA corruption on long hmac keys
Message-ID: <acJerX5liyO2tQ-B@gondor.apana.org.au>
References: <aa6PaoYiz_BY1eZI@gondor.apana.org.au>
 <d1bd8cf9-db43-4e36-869f-ecb953dd82e6@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1bd8cf9-db43-4e36-869f-ecb953dd82e6@nxp.com>

On Tue, Mar 10, 2026 at 05:12:10PM +0200, Horia Geantă wrote:
> 
> When aligned_len is bigger than keylen, kmemdup would go beyond the end of
> "key" buffer.
> 
> Looks like kzalloc + memcpy should be used instead of kmemdup.
> 
> Double checking the faulty commit, I've found the same pattern in
> ahash_setkey from drivers/crypto/caam/caamalg_qi2.c. Let me know if you'd
> send a fix for this or I should do it.

Hi Horia:

While we should still fix this, it turns out that the original
problem went beyond the memory allocation.

The root cause of the self-test failure is actually caused by
the parallel self-test mechanism which became the default in
2024.

It appears the caam is unable to deal with this because the
ahash_setkey function will fail if caam_jr_enqueue returns
ENOSPC, which is bound to happen sooner or later in a parallel
environment.

So it'll either need to deal with ENOSPC, or switch to a
software fallback.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
