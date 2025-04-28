Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041B91D5159;
	Mon, 28 Apr 2025 11:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745841292; cv=none; b=SLqdH4WZnCPGOU2m0PDJuTPmjRudgDWhry+zik1fxvbK/izKlRYGi7BwzxaOqawiKmrLzAJqHgtcPw5xVLMJrPLMImO2CfutVf9aDsX43CON8sFMFXIKLgKUxR4A/hkw4lDvmmP+u49/UJ+cR/6B/CGtLWUBwJTLUZbSaCUFSxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745841292; c=relaxed/simple;
	bh=23kwinisccu34XpMcGpdPDdAalJwVI2LvbzrznvSi7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEFpgYBbTjV8RgRc1JYW6kR8nXaLPJSPj3pgB18OknMvoxURrIXH4SMWf2ZsV+8bBy3pt8SCi5mO/0yhxtt1b9kkb23Ct/t+VL2pNVGEo5JBpJmb5NPnpEXc7Ya+CECTlV2legHY4+fbYDKOWKfNTu/CDLUKdWrGCO2ADjozpFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Exf5KlG1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Exf5KlG1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=37rLIMLFlk5npwCc/iHhjmm772yYSs2S7drUMssNos0=; b=Exf5KlG1jNwSSx5K2CYsRXlgxz
	EIc044a7f7ZLQYKBCotON1j483aD8yfVhp235sVZHMGGQsa3YzatkM2m4sQpuk4K5HlVPZgyV70Vj
	P8e3LTcb2SQvvKKNp+p/zyMK24HUlIZW8MxtMSgmxkzohXWgdHk+yCREW2jtxHalzlEwttASUxIOh
	6L9+UasiKlZeHBjZH5f8JlMJ+mKJv9SPymYIFlKSciUSG5Yfp+z2WA92N0UISUwjZX2Q6PkqDxv/Y
	jtfeGq70DrmhfuKfQG7MVt8SRGIjKHNntSIp6uzKv6LVbw6/HaogauxOUTi4Xb6xsLTvJpUFX+2Eg
	tJqaPY1w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9N4M-001bL3-30;
	Mon, 28 Apr 2025 19:54:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 19:54:42 +0800
Date: Mon, 28 Apr 2025 19:54:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: jernej.skrabec@gmail.com, samuel@sholland.org, wens@csie.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH RESEND] crypto: sun8i-ss: do not use sg_dma_len before
 calling DMA functions
Message-ID: <aA9sgikONjK2ig5z@gondor.apana.org.au>
References: <20250427111236.25668-1-clabbe.montjoie@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250427111236.25668-1-clabbe.montjoie@gmail.com>

On Sun, Apr 27, 2025 at 01:12:36PM +0200, Corentin Labbe wrote:
> When testing sun8i-ss with multi_v7_defconfig, all CBC algorithm fail crypto
> selftests.
> This is strange since on sunxi_defconfig, everything was ok.
> The problem was in the IV setup loop which never run because sg_dma_len
> was 0.
> 
> Fixes: 359e893e8af4 ("crypto: sun8i-ss - rework handling of IV")
> Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> ---
> 
> If someone know why sunxi_defconfig have sg_dma_len() which always works
> even with any DMA call not done.
> 
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
