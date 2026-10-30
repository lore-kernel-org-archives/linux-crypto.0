Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793339492;
	b=uca02yGZEeloEhd2Q7nG68kG4IhTOlhavyis44OquIdPj1H5zqJU2gDmdp20/d07UFmp
	 o3Ve+vganhNo0g27uAVuz1myFbZXBvGtdWxh16IKG5dWRvW6GokPxvdMXelQfGp2FmpgV
	 DNpFhEY/vq6pxgrp/slmkpmBE6g6VoDpqpKtPORLWlAkKt5TQghVp/Axgx+sxR6H27sPn
	 JrkwPKM+VuYqKbp8KE53TAxWv4jf+aYzCDfbBPE5L1rxSRkEy+n5G5zx4TTCVwmgm4ZbV
	 MCwbe9XXvNwjyzTEPcpNfJGxLbBOJEUpzvkYbOxmRqwQhq28wINcl83Sx0TZ9eH0yzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793339492;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=9YfJOSpnYoqiR78tZwDBtF0PrUJ/nLB9HJdYwRb1UHU=;
	b=Gn6rziNEa2lgq/mrROdbwqJ0jT2fU7L1WYJfT37pxMRcHStkByFhyM82gyKSOxnHGWWR
	 nkcteczTHVyNqsW/F5v7EsCIerKlFwY3+KUWW8aiHbAFXdl1x941WATacwYyxO6uqcm8e
	 /I/LF9KB4zfraPh1razfa9xK8ej79338ohc7FMugkC6bDJmHlhpBK0eLsZT029zYbvR8i
	 UAmwN++IgDjaIgiD143COoVDaozT9e4XLDYO3mTMFgl2wHgqa36BKWXs5EDZgBGhMlEBh
	 R9Q/dZ5x6DfYWlIh4le87KI9Vz2mY03bN3+JJ7krPPwtLRpEEnTpOSExzw1n96Y0DzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=QlYl8R23;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DC8606A31A;
	Fri, 30 Oct 2026 05:51:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92DC8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=QlYl8R23
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9YfJOSpnYoqiR78tZwDBtF0PrUJ/nLB9HJdYwRb1UHU=; 
	b=QlYl8R23ah7db17cXjIK67qEfvz8JUtktiO7fjnOtMoLCiyWnmZA3/MnFD4QhgRePS3V2XlyJ5m
	SHueIHs1OxKrVfgPR9Cur5A17QChscsZYTpyZNEj6oLMIKjUO+lMKmVlP725RDtaDAfTGjF40UoSN
	rI8WTGQfxdkbr0pdR66K5Cg8mc+BY3NuJtmjfM+iB9AxhFWNjc349K6LhV6SOfeOWv4ha5YbI3f2w
	0IKrX+w1QeNNbWcwYujuLdcYF/sqkedsBuag4Tka+PjEdcuJGCiuEMg5iTty3YYRVeIw87KRhf3UF
	mOQxSDjHsxPgt0yfy6To3jpBqfE8o9bEOsAg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMfWM-00000008zTr-1ZKw;
	Fri, 30 Oct 2026 13:51:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Oct 2026 13:51:22 +0800
Date: Fri, 30 Oct 2026 13:51:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev,
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, rientjes@google.com,
	willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
Message-ID: <auQwWgMbBuo0YEBI@gondor.apana.org.au>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-188658@kernel.org>
 <auQhULh1VTh6lWoe@gondor.apana.org.au>
 <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
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
In-Reply-To: <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>

On Thu, Oct 29, 2026 at 10:15:15PM -0700, Kanchana P. Sridhar wrote:
> 
> This is how it is in the current mainline, and has been for as long as
> I can remember.. I assumed it was because we need a per-CPU acomp_req
> to be allocated for the tfm. Can this be done with a single
> crypto_acomp for a given algorithm?

The request needs to be per-cpu, but the tfm does not.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
