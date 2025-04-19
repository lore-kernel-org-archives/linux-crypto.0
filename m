Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6278B2905
	for <linux-crypto@vger.kernel.org>; Sat, 19 Apr 2025 03:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745033892; cv=none; b=jfv1tC6tAPEDn91TAPjwA3td7tvmFd3KlJyHtLZ8Lq6iKTSWLs4WpPhEJTvES9GqaYyu4exTEMSVrTrtQU5o7tENk5P+kqujkDn1oGyHL27pSjB8hiZxb01v/Hvh2+pAzosTnxs/DLv0sp2QRd09VbtIxa7UZHvqjpXDiIrZ/rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745033892; c=relaxed/simple;
	bh=3S1RK32xkS+ORDVxLh7gUxbLEILFFC7qwlPKRDsATWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rD4SUeMiWlDy8VwSg4CQgvM+GV67d1AKwLXZ4Aw/cRJs0xAIp1NqMzoPwSqQcPiSpahv2ByXLlFg6VWXcWcQty6pCbiVaFpQzAJ93t5/z0GOJCpEySYaV1dmGHZwRitnMvED0zgtIOwTmfZD+4ma8ShjEgb2DjPlbsA5KKxPQ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Z/3Vj3Og; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Z/3Vj3Og"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SaWoaVJXe2CTgNUgE6eP4/k67mneKU0zLxJBMuAFw/I=; b=Z/3Vj3OgaKlDNEVrE4ImF8wUN2
	z5nh841PAOZekAe5L6Bk6v32/7xWf5/QopTDWFc9RbMxOw6meyQkFIBIR1Qy+JyJb4wNtVGR0OT+i
	9P+goR31el3W5KnXN6eMDXLs0rZ+CTfhGhthLjw/AiyUxeloi7Rlq5agsX7Aw+qasuiuTrr7oBZ9b
	Gd58wrhKyIwbEnNV8F05nn1upy9cLg+ONCdTF78NlfGs9Ri3IJKAT1krS776MnjcbtJ/l4R1bOAwQ
	oR9MJ93jV6aENtSkmjkcjju2rBhXawTKKmvRpqgRgHrveqe6/xJzqK48rRvLsoHK59yl0Hwx/rKOF
	RMMBu/vQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5z1j-00Gueq-0g;
	Sat, 19 Apr 2025 11:38:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Apr 2025 11:37:59 +0800
Date: Sat, 19 Apr 2025 11:37:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: acomp: fix memory leaks caused by chained
 requests
Message-ID: <aAMal2cgiLz62TFP@gondor.apana.org.au>
References: <20250418100229.9868-1-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418100229.9868-1-dmantipov@yandex.ru>

On Fri, Apr 18, 2025 at 01:02:29PM +0300, Dmitry Antipov wrote:
> Running 6.15.0-rc2 with kmemleak enabled, I've noticed 45
> memory leaks looks like the following:
> 
> unreferenced object 0xffff888114032a00 (size 256):
>   comm "cryptomgr_test", pid 246, jiffies 4294668840
>   hex dump (first 32 bytes):
>     00 20 03 14 81 88 ff ff 00 da 02 14 81 88 ff ff  . ..............
>     90 ca 54 9b ff ff ff ff c8 fb a6 00 00 c9 ff ff  ..T.............
>   backtrace (crc cd58738d):
>     __kmalloc_noprof+0x272/0x520
>     alg_test_comp+0x74e/0x1b60
>     alg_test+0x3f0/0xc40
>     cryptomgr_test+0x47/0x80
>     kthread+0x4e1/0x620
>     ret_from_fork+0x37/0x70
>     ret_from_fork_asm+0x1a/0x30
> 
> These leaks comes from 'test_acomp()' where an extra requests chained to
> the head one (e.g. 'reqs[0]') are never freed. Fix this by unchaining
> and freeing such an extra requests in 'acomp_request_free()'.
> 
> (I'm new to this subsystem and not sure about Fixes: tag BTW).
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
> ---
>  include/crypto/acompress.h | 28 ++++++++++++++++++++++------
>  include/linux/crypto.h     |  5 +++++
>  2 files changed, 27 insertions(+), 6 deletions(-)

Thanks for the patch! I'll fix this by reverting the multibuffer
acomp tests:

https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git/commit/?id=aece1cf146741761a1243746db5b72f5ece68290
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
