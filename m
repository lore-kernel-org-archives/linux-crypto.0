Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793785677;
	b=i83K5A6JPa1GGCr8vXZeptv6L86q3cBUd4t3uVlLm6VtIrcqcNUupiH5Hu6y2KSMzJ+w
	 KJ+6crZsi1cvW24nSAnE2NgYfTVG4Hosib+p/4VPg17gAddTt7C18TnsDGkbYM+Qefe26
	 G5CZ0L8sO0O2Jd+Hd9EAGTgA2186ZSxWQUgLBRHBfO2jl6GiarR93a0z1UW9S5tyJqyKC
	 JZeNnEAjjLZ5XBoCmIf2qJMflzRvfYiDk7kWcT3XyVlVpS66de0ia6mEkv8IOnK1O3Kuw
	 Cgwj1iIvAur7lEPZguDEWrzPo8CwfiHW+el2aLrJJ9Z7MeUzCefuPqjWipgVsjT3kxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793785677;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=n+attB9PvL2n6dsbSQ6Vs1/AeKnQk1sOTd77loYwPLM=;
	b=YOOUxCvmIrBBxcnmF20nnD88oqNflyycpjX/ov/jA8AMRQjEHqi3/9L2Mk2d0POFf/P8
	 1OLPHvaSQ0+4O9GuT3UFVlb0mvllIP9ILH/w3G1f0NUyX8Qhbqpz52z0llQfOgpuEUr3g
	 YQbRCGKDXV3cmZCet6bnMcUcoS1V+/pdeGFlXYwmSefHv1obXO82sh+yPCxMXBRLxjk0T
	 uWlYSp7+1uyrXrE7mC1YmftuEeaBW7o2o5Mv8rz6oGUvozXAjVlZji0vjOoma/KENvK29
	 fJ9tcbLeGQ4T8Z2c0yjDiPlkZq5G+1SFSg1teLxDAnHHvVawezQ9RtUfHZflZDxrB6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=Cm7wEFo4;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF057606A31B;
	Wed,  4 Nov 2026 09:47:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF057606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=Cm7wEFo4
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=n+attB9PvL2n6dsbSQ6Vs1/AeKnQk1sOTd77loYwPLM=; 
	b=Cm7wEFo4Pm4FVw8bVsqV2KFGXONAXn6Pmnx4MSA9MrouvnFLO4rMTc1JraBdzLb9Bg6/iiJoyXx
	zh+NuJSooJuoesImo5j1R6UDhSebvzodBtz5iurbl64AjowLXbqNIALrzPAt8P3sucbiTxTsr5Xnl
	WqpLIAnocz5CJFUFw+3TlX6v6TqKf3qfqPsd6LXajQgP81vaIiDsX6YMuO3OpDnncmLSmyRxGywrM
	f096M2hlh/uIfaYwGU8xCbcnRlst5USAx6Cz2KMBimgSZ6lx6amC1anM3UMyVG01ExWUYWdf+ihl2
	20SN9YL3LfeLWs7fq95MO26ay61JZNaSbaog==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOXax-0000000AoNg-1YbC;
	Wed, 04 Nov 2026 17:47:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 17:47:51 +0800
Date: Wed, 4 Nov 2026 17:47:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] crypto: essiv: fix use-after-free in AEAD path
Message-ID: <aur_R6HA1ylklPB_@gondor.apana.org.au>
References: <20261016075030.3463123-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261016075030.3463123-2-Jeremy.Jean@oss.cyber.gouv.fr>

On Fri, Oct 16, 2026 at 07:50:31AM +0000, Jérémy Jean wrote:
> The request that ESSIV submits to its wrapped AEAD transform may
> finish before crypto_aead_encrypt() or crypto_aead_decrypt() returns.
> In case this happens, essiv_aead_done() calls aead_request_complete()
> on the original ESSIV request, which can end up freeing the request
> before essiv_aead_crypt() resumes, creating a UAF:
> 
>   BUG: KASAN: slab-use-after-free in essiv_aead_crypt+0x8e6/0x950
>   Read of size 8 at addr ffff888102af1360 by task init/66
> 
> Check the return status before dereferencing rctx after submitting that
> request. If the operation did not return -EINPROGRESS or -EBUSY, then
> the request cannot have been freed yet.
> 
> Fixes: be1eb7f78aa8 ("crypto: essiv - create wrapper template for ESSIV generation")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> ---
> 
> Changes in v3:
>  - Code simplification.
> 
> Changes in v2:
>  - Drop the local assoc variable and check the return status before
>    dereferencing rctx, as requested by Herbert Xu.
> 
> v1: https://lore.kernel.org/linux-crypto/20261014222351.2930674-1-Jeremy.Jean@oss.cyber.gouv.fr/
> v2: https://lore.kernel.org/linux-crypto/20261015121743.3151400-2-Jeremy.Jean@oss.cyber.gouv.fr/
> 
>  crypto/essiv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
