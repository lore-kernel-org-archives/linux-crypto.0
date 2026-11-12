Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794477392;
	b=xWkkn6EVXljktnYkTCfdEERYy6bMXyUasA1N056O88KPZFtri79Qendz+Uju9BShtRhJ
	 I3DSvb/42dOTGinJoZ+ZyTtLjP35q+8ZUl0dOgv2wqLxgWTK25pyxEm2ZzW4epYre7LU3
	 2liaERJhdgX3RMM+AladpLj/Qw7dE/te1E43i/dbCgRbaySs+mPWXU99hE9mWaONfTT2v
	 ZTGZu1ui6w5HPW6a/28juc1lwmgiad3/hL1KZ2oV/0vzNw4SdzNsUweKg3uFYmpVPlM6D
	 qm1+Y7VhI8c0uDy0E5+M3xcABLISKd6Uy1m/zhpavAolxBisQACrteEo1HvllwhaoOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794477392;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=IpqQrUdn2qhnA27eiGBsYUdjhzGI02RMEz6Jntjyjrc=;
	b=lJ4z+gwNkzgURNS3wv+33FYR/tYfXCx+q7tVyLyRHgwkGdElAJJ0S9H0QTv14o4VYvyd
	 4xqBnI5XXbnY30Ohgw7U2bLRQWViBVP7hMM6fJg4FpLCE2oek/EC2213uCgQ7kCIwxT/V
	 yyOCjfg3dURcLonotXi351f5kDLqkSWaVkcpkOl27C6SSZFi2dBhvGYmloT82fUlSbQHV
	 hWPRD8NXbiO6+sdP5H6T2COZiWGHFJrLdPAz9X3yJpZDnJateBp9uoOpYaxCVi4BOaxQk
	 OS7zQ0DcqUt0TvDP0npt6Nq8ars1Mx4xxTk1h468JMl+1iRTfy8fjsJcf4zj2YMdMEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=YQe4qWxq;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DF1606A321;
	Thu, 12 Nov 2026 09:56:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8DF1606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=YQe4qWxq
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IpqQrUdn2qhnA27eiGBsYUdjhzGI02RMEz6Jntjyjrc=; 
	b=YQe4qWxqafQyT5s2mrhI9FkGvC9ALxbW9K/peJznX1m4IeldruA4zURGUyjmyq+5UAYpHlvAGKY
	P0/RZ2dFC7osNv35ilTV62HI4IUqO+EwY4nM2z8Ao257hcVj/aTwnfMGzHdfl1TVtVikpIfruT3lh
	qaE1bJvRwM3LxFMj4EHkxq+HS6DQlfSNi6PwQnwRqZIOk+Y/zPicHylz2X1I+g53hkJMEEQ953+L2
	d9HuykWev4RXZv5ugzjU/mQwe5y+yBzOTWR6Y3jAu+O3I85lLydBFqDnjDuT94Y6UrZ2xHUbeDk6G
	kntRNh2FxvGMdeSz+Vn6onTULk3OiCLoQGxA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRXd-0000000EDgD-27ii;
	Thu, 12 Nov 2026 17:56:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 17:56:25 +0800
Date: Thu, 12 Nov 2026 17:56:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ryan Brue <ryanbrue.dev@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>, Olivia Mackall <olivia@selenic.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] hwrng: mtk - wait long enough for the next word
Message-ID: <avWNSXABarLk0roZ@gondor.apana.org.au>
References: <20261026-rbrue-sheldon-upstreaming-mtk-rng-timeout-v1-1-551b4b6b4f86@gmail.com>
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
In-Reply-To: <20261026-rbrue-sheldon-upstreaming-mtk-rng-timeout-v1-1-551b4b6b4f86@gmail.com>

On Mon, Oct 26, 2026 at 01:47:05PM -0500, Ryan Brue wrote:
> mtk_rng_wait_ready() gives the generator 60 us to produce the next
> 32-bit word. On MT8695 it takes longer: timed over 1421 waits, the
> median was 82 us, the 99th percentile 92 us and the longest 225 us. So
> most waits time out. A read that fails on its first word returns -EIO,
> which a read from /dev/hwrng after a short idle period does more often
> than not, and longer reads come back short.
> 
> Raise the timeout to 1 ms. Generators that are faster still return as
> soon as the word is ready. On MT8695, 20 reads after idle periods all
> succeeded, and a 256 KiB read returned in full at the same 63 KB/s.
> 
> Signed-off-by: Ryan Brue <ryanbrue.dev@gmail.com>
> ---
> Found while bringing up mainline on the Amazon Fire TV Stick (3rd
> generation, MT8695), whose RNG uses the mediatek,mt7623-rng compatible.
> The board's devicetree is not upstream yet. The timings were taken with
> a temporary print in mtk_rng_wait_ready().
> ---
>  drivers/char/hw_random/mtk-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
