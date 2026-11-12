Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794478608;
	b=pXdUA9NPvvf1reins4+ElNxv45AtbJ56nonqqYbkLjKLMzHkotX+RssJ0KKrjLIfr/y6
	 eJy3DZj7P4ER2GjbmwUb+z/XTBYxf7GIAwqzyBIxsm8hTNcA8pMTaMtfg+RQ2f0LBdkoP
	 kKSHxw3bOJEDhMK+/I47lc+gLLgEcJYHnXS2eTPoBDp/lG1rjM7jqxGC5XE0mlQLOxO6x
	 GE7VQs9EDPTN1QQm73Q5UJTNJxLvib67rvc0XVwvQ95SYnv/YdSYHcJkz987w0y6YMcCG
	 Sccf3zs7+OLrkGQKiybd3h5R1HFYc6w2E27RYWJU8rw14+KzvklHi3fl67FGi0d0V0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794478608;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=VVah+vg4xAv2siGrSxOxbppjzuj5m9VQvKrWpcQv+ZM=;
	b=MLK4rnZdvHDz/KcrTfK410x6XCkVCA2IdvWdDqJGct1Opndif14dBlVH/8dLdZPYwKIH
	 4Fy2Wm2CNTk2YP8P1eN+TxdXtV/kPV5Zbge0M+fqW0npx1d/6o6bkIuLtCx7rn0Wb9Vke
	 +2dmEtsqtfE/MIiPCor/zlEaV6cBJdh88mPgAzyEDXibgvnmDUv8dore87W54sr6m8syX
	 HhqvyzfrEXt3zPF3MwQTYm8roLxa25OcfxSuFbqjeaMoU3CoI1MgV/IO0SdSkuajCM1WE
	 jrshotGwIRGw6vgJ8gqbvTSvW1csmSWNRmbPcjEH2ItCvjuKOfU03MwDcvDPuuEaqtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=GdRTSP+o;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6E1606A327;
	Thu, 12 Nov 2026 10:16:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D6E1606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=GdRTSP+o
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=VVah+vg4xAv2siGrSxOxbppjzuj5m9VQvKrWpcQv+ZM=; 
	b=GdRTSP+okoqEQepIU2Pb50RnZbuiFSBoe3nkgnmeRvGkx85kP7dekjlojfI45g5tFX6kzTw7SYx
	ntrvCZmQv/DTIgPZYbC8H1UBtvM2KlbC59/jkgxLTZmADEpMDnNhCXu3eA3g8UUNQ9yk9jPVJjaSD
	OGb2tAJD4v1/LZQRe1VfQEjuYZ3ZjouGsBT8gg+bDIq0at2KYl8zSgupJx6qTdOgah199HtgbsTVX
	YPyqvR3Ql33d1S+4PQBM8h45DVG3OQ99xbedmMQ8HRlcCtONZssescWtzS6qPvpxnmeHBSAZHUD7n
	fBiTYT7HsJtN4/EpgqWLtyK3frQMsMoAmPVw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRrC-0000000EEFU-0OPk;
	Thu, 12 Nov 2026 18:16:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 18:16:38 +0800
Date: Thu, 12 Nov 2026 18:16:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Martin Kaiser <martin@kaiser.cx>
Cc: Hadar Gat <hadar.gat@arm.com>, Olivia Mackall <olivia@selenic.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwrng: cctrng - fix usage counter in error path
Message-ID: <avWSBrBQLBA0MwBJ@gondor.apana.org.au>
References: <20261031144729.2327464-1-martin@kaiser.cx>
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
In-Reply-To: <20261031144729.2327464-1-martin@kaiser.cx>

On Sat, Oct 31, 2026 at 03:46:20PM +0100, Martin Kaiser wrote:
> If probe fails after the runtime pm usage counter was incremented,
> we have to decrement it before we exit.
> 
> Remove the cc_trng_pm_fini call in the error path. It calls
> pm_runtime_disable before runtime pm is enabled.
> 
> Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
> based on sashiko review
> https://lore.kernel.org/linux-crypto/67844d9d-d4d4-4026-9549-73589afcc1ff@wanadoo.fr/T/#m1a770f5f9eeed95b48cad7545580aed4fa74e6fa
> 
> compile-tested only
> 
> v2:
>  - don't duplicate the error code in dev_err_probe
> 
>  drivers/char/hw_random/cctrng.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
