Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756401;
	b=St8GzKqOtquceRh7gGdFhkJY2VlwnZV5p83oWRjGYw9VS0irH6jNu6qsuAGOUgiuv/QW
	 yea7NZtLZeIN7fneD3n6rciKMbGRPIYLB2dc+/aC+EFK+hbH7W4KG3NX+Tthi9iIy04Or
	 mvQCbMLx1AZTgTuW0bqEAICv0iAeA7fJzHWUrOHjprvEzUDRD1LiUgWc1IZgKLUdfzUIQ
	 U20toSc2mPweAYqBmA1t7sDkZXxzWMaRUNYId6dvBcm3ZTEvjOCQTO9sfMVoxfJKuiu8I
	 LBfGoyqnsfXGzMoisQ+8g2Qj/5TO3xJOEs8DlVxVTnSpm01WghTHlwxQ3FMoLsG8iqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756401;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=FKXTvjxtdne1GDyeDT5Y46eZbfmMTtdejd1xb6K/bPE=;
	b=hML5yOd8i3Nw3gg/ZfaBmS4rX6nSe74ZbYIOEAno0p/G7i3JEKsYGAVp89DDx4ZMmUkZ
	 FM4c7IBQaMaPuz1SEBMVcQvd/0NmwiQAmDwLLOo4Gc8aeZEwrfHAG5GUUs1zm5EEp2mwS
	 0Fp13+kSUFPH0at3GjJpov0HFcIgAUka4qkr2y23fpwblY15+eYLApjy0tfuYIi/XZe1q
	 OSWx3ob+lpAq4NNd55f+2BaMVvXo2V7p+R+IMUP3bDD4cWv3CJBO5r05lrL5SUpYDHYPy
	 PfHy9Vz324T+WPtDLdHi7jTNQk/qJXVJVEIiZqK+Qaabw7A4c+m8w0rqxVMr8nXdOLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=PA2GCZib;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40096606A31C;
	Fri, 27 Nov 2026 05:13:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40096606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=PA2GCZib
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=FKXTvjxtdne1GDyeDT5Y46eZbfmMTtdejd1xb6K/bPE=; 
	b=PA2GCZibCNOfazFzNuoa/mhXnkwO5Ua9Ch+KYNd76zjVPA4yGs31PHzAnw3WGvxQKekDr0iOha2
	b1Lz/p53KVGna6vh5mkL/8iVWtvwWqpj3J1kh75+HWNXNxFtV8y9VBTMvqUgYTSCdvwC3UH+aXMNU
	VxoEFdqnCvAJ0Op1U2Qz13qvD4K6evHYnJK13idc5RC9d8zcbQwlP8vk27yEnqcdti2jx+ki+yGK6
	96HEiK9jrUFoDI7Z2Le0ivIxS/qRzetArsVA0ipk3axZsDApVLgvpZJpe2NGuxcXMJ19x4jinXEtd
	TOWFD0u8m7nWgxWRk8F/dEyrYheBWeO6wRrg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoGq-00000002VV6-2h7x;
	Fri, 27 Nov 2026 13:13:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:13:16 +0800
Date: Fri, 27 Nov 2026 13:13:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Haoxiang Li <haoxiang_li2024@163.com>
Cc: schalla@marvell.com, bbhushan2@marvell.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: marvell/cesa - Fix hash DMA buffer cleanup
Message-ID: <awkRbH_mH0NCGFzd@gondor.apana.org.au>
References: <20261118075636.2152451-1-haoxiang_li2024@163.com>
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
In-Reply-To: <20261118075636.2152451-1-haoxiang_li2024@163.com>

On Wed, Nov 18, 2026 at 03:56:33PM +0800, Haoxiang Li wrote:
> This series fixes DMA cache and padding buffer leaks in the CESA hash
> request error paths.
> 
> The DMA cache is not released when request preparation fails. Padding
> cleanup can also be skipped because request type detection depends on a
> TDMA chain that has already been cleared. In addition, final requests
> rejected by the queue leave their padding allocated.
> 
> The patches address these cleanup paths and clear the DMA cache pointer
> after freeing it to prevent stale-pointer reuse.
> 
> Testing:
> - ARM compile testing of hash.o for each intermediate revision, using
>   Clang with W=1 and KCFLAGS=-Werror.
> - Userspace mock tests of extracted driver functions covering allocation
>   failures, queue rejection, backlog acceptance, completion cleanup,
>   retries and non-DMA requests.
> 
> The mock tests, which is assisted by codex, validate resource lifetimes
> with DMA pools and hardware interfaces mocked. No hardware testing was performed.
> 
> Haoxiang Li (3):
>   crypto: marvell/cesa - Fix DMA cache leaks on hash setup errors
>   crypto: marvell/cesa - Fix padding cleanup on hash setup errors
>   crypto: marvell/cesa - Free hash padding when queueing fails
> 
>  drivers/crypto/marvell/cesa/hash.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> 
> base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
