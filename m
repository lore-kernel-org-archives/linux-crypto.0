Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168351;
	b=iH7Nh5RFa4T6BuxPYXxs/0mIBbiP44DAXJZ3iiDRuWhnob5zbMUNFxtF8hVqVvCCxO41
	 /pJ/Pp2FzCCvHC7DCFJyuNQRK4D66TFxX3a7VWxTZWjeu/02N0Ncb2ogQcZ2/WGDTpXwV
	 beTDIG753377bomvXIHxNcOGMp7pdb1UY6LNOl8SXQ17Sd8ENs7zmxauCepAC2QX62Pxx
	 +KlCpWFag4e0CQ8fw6R9nvfUbilOZfRJyecPArtozRXm617QJPvoKPH8sxalYvVAWErKB
	 sGwBiCPB49SejYhrKMTdFn1rU5iq8VgRy8ZNIDO/kciX+5nJyJ2IbAOlCcaI7IZwahw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168351;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=2XWww8i4ymISC1dR/irtFbeO8Vev90H8R+uxG9/wG2k=;
	b=HSYsKMRUyy5KaY5b768EoLbfRm0PEkyIemhSZhSmDUwq16ahe4gx7s93HD1zn6NxNSuJ
	 yAWKVYUd2aOFXimqcPP3FaY6B3hLC/2JgsJW/wfFIDringX3qhPnhhBk5lJPkXBpKpBak
	 jGsq6HZ0Y233VeLXksLl3cCqi5XYtPILrbcw3JhxJt00r5xu+BgAzaDD/FExwmBB6eQxM
	 zvTkcHLAZWOqSfhy3mpt3/tJRUXwnZeW0X2PGH0CrI5HulQm42SVG0TBX94w0HyX1PAEt
	 +uV5JI0Ogst+KpuymEJwSp8XBAzACDU8xcBy37O7dQewi/9FS+Zs6wcPGTHAopkxTUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=T4TY0WPt;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290B1606A325;
	Fri, 20 Nov 2026 09:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 290B1606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=T4TY0WPt
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2XWww8i4ymISC1dR/irtFbeO8Vev90H8R+uxG9/wG2k=; 
	b=T4TY0WPtyqcudFLfBy/tVZPc+e4NbKHk5MLaW/dULOkJiTaXgI3JZm0a02mKdAcjozAmaXl0Ral
	1MIPyEpGOH4uSUevEgX697iQavmz16D/vPQPwcQ+QOlWdeOBB8CWItFcUQs8cpuu4w096DzLV/con
	Lj94bCViZnGH7agF0ypfvUS/WwyXoiROo8ErUB/3Zmfw6YXmdceSHWZ2A4GzlaucombFTLTFmV7BM
	sFScdpAfXzPf0jnHWCTusSwzzjOXGdO6SWivOr2CGah+2otF/xWUjPfmU5c73ib50iswrOzb00ykR
	Jmm5YCA8/SNwriGzoGFteoHCaGifQByVlWJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULI6-0000000HYdi-0Yk6;
	Fri, 20 Nov 2026 17:52:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:52:22 +0800
Date: Fri, 20 Nov 2026 17:52:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gu Bin <gubin@cmss.chinamobile.com>
Cc: sean.wang@mediatek.com, olivia@selenic.com, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] hwrng: mtk - runtime PM fixes
Message-ID: <awAYVvHMjqZGZCn8@gondor.apana.org.au>
References: <20261111073237.1647-1-gubin@cmss.chinamobile.com>
 <20261111090704.1699-1-gubin@cmss.chinamobile.com>
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
In-Reply-To: <20261111090704.1699-1-gubin@cmss.chinamobile.com>

On Wed, Nov 11, 2026 at 05:06:57PM +0800, Gu Bin wrote:
> The sashiko review of v1 pointed out a pre-existing ordering problem:
> mtk_rng_probe() registers the RNG before enabling runtime PM, so
> mtk_rng_read() can run while runtime PM is disabled - both in the
> probe window (hwrng_register() starts the fillfn kthread right away)
> and on unbind (the devres teardown disables runtime PM before the RNG
> is unregistered). Patch 2 moves the drvdata assignment and the
> runtime PM setup above the registration, which closes both windows.
> Patch 1 is unchanged.
> 
> Gu Bin (2):
>   hwrng: mtk - use pm_runtime_resume_and_get() in mtk_rng_read()
>   hwrng: mtk - enable runtime PM before registering the RNG
> 
>  drivers/char/hw_random/mtk-rng.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> -- 
> 2.55.0.windows.3

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
