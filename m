Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793770035;
	b=YA58ynUbHK+1wj5avzV2cA1o6lkQiFinucOmUGxhYxegtr1T30mM6yNDXbpgO+Af7III
	 0To02nLCt1pApnKzyWyQ65KTUVlK6xDFvgvRv2vOO8sOi1ZtD1w09CB248ev8Q43nJSBP
	 UXQB2dnsjqldSzmM1+1x8WFSRObTU6p8x1IZJbH8teRRaUT/2Ld0hkpLMHjW8rlfVrRx5
	 jhohsMZLUBfVRZZLCs1mN6Nu/N4Uxt1RBxUdv3SWtAdBevMQ8bbMU3MnPZvU116CHChmj
	 ZXtQrizLtzAY5RP0SuUD6SdjbumrV1GrWB/xC/Hs859dZhMRuYAdHtnm8jx70w5l/6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793770035;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=m0lCmt30EUiatLfsbnSZVC7crDyhMJWqluU/myeillI=;
	b=p2uGPcxlV1XaVllTFKkCEjcd8S+j861irkYpMmbDHB9XzqBMn6KN0skM98eI8+4ST16+
	 q+1fY9u+7yZ+VuQr/vmkyfMsGh1tmakxBs2p0MXazEeU8iMGvlJ95U1BMhsKMOtjXqQL0
	 0XEVyHKj3OYkjvbBqXTGur5vhGW0kdUwhRt0p5B1S5RiJQL0XoOsOadAviYfFHf16Z0yn
	 xAf/DHjNCl0WtmfLFolNN/6eCu5t+IgFwGnCv6kEkncBv8TS9zHK5eYqYlK0EXmU8I/Wa
	 MlJw6bNmY4e67Rv7SCRBM/hV4mVkfsmtVbmWmT4hYpBgQwkw8PqIXNT1x+5VHAaWzYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=QK0n3R8T;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1808E606A31B;
	Wed,  4 Nov 2026 05:27:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1808E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=QK0n3R8T
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=m0lCmt30EUiatLfsbnSZVC7crDyhMJWqluU/myeillI=; 
	b=QK0n3R8TKCA3wbnmyk3Dfxurzbf8yHdlTX+2PI62NNo+nne+umG/Fjw9XcSeafMgOHqU6nzLpa8
	f4G6+VDk6xERljfPHijnAzPCzOebtrFS9kqR7sl1hWFlyqm1u7xAoiNS6ja3donyQfWbQzmOEMSG2
	Ew+6nJGCE3+zJ2A9qXepeTLV8mF+/EYl5ezefzv3fvBLhLMDXnSw14KRqsjdC90jezJntIOyaURfO
	CxI3QjWmZAUYjKC3Kc/bYe/ZmoV/g5WdyDDbmKytotJp8YSJ2kEQchRC45gh4Q609NHWAQcrM6NWA
	4UdGGA7QMn1+5ivCebizL+fe6foVjlPqXuSQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOTWZ-0000000Ajjv-3GDG;
	Wed, 04 Nov 2026 13:27:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 13:27:03 +0800
Date: Wed, 4 Nov 2026 13:27:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: sashiko-reviews@lists.linux.dev
Cc: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>,
	hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/1] mm: zswap: Move the crypto_acomp to be per pool,
 instead of per-CPU.
Message-ID: <aurCJ8wl6EYiXS2J@gondor.apana.org.au>
References: <20261103000313.13677-1-kanchanapsridhar2026@gmail.com>
 <sashiko-outbox-194595@kernel.org>
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
In-Reply-To: <sashiko-outbox-194595@kernel.org>

On Tue, Nov 03, 2026 at 05:42:27AM +0000, sashiko-bot@kernel.org wrote:
>
> For example, in drivers/crypto/hisilicon/zip/zip_crypto.c,
> hisi_zip_acomp_init() allocates one compression queue pair, one
> decompression queue pair, and a per-transform request queue and spinlock on
> tfm->base.node:

That's just a bug in hisilicon.  The tfm is meant to be a globally
shared data structure.  All per-CPU/node optimisations should be
implemented in the reqeust object.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
