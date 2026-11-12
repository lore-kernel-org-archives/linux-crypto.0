Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794477831;
	b=FX31BNzpIox6hm9DLI1JnSB06dHaCe6kA6jDZMB4wTFCxNCPZAnsZoitORYvJaoWOH3P
	 X5OSrSU/ZZtCzl+bnwnYSt+aeAyZVoWZdYfR1hUHlLN9hmiFe2NNY6DqQIihDQT/qIv9A
	 kM7RWiGxnbDOrUdLm/eOGZjNOr6ENf0IFsVqOLM6VQUbf688nYEXtSaY4a+EeHpfUlPMq
	 yvQQd15Xu0LUgIQ0f9963StFo30xTRAVupXVE2LVDOcFZ19gij3mFsmkRdwz7zbDijHaX
	 RBh9r5S4BL0/+zUNCpOnjL+MIidLcBh2EHX04er8wGx4OmRp62S82EiAjcWzSmNVu/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794477831;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=IpqQrUdn2qhnA27eiGBsYUdjhzGI02RMEz6Jntjyjrc=;
	b=RKY3Y/zzxQUow496G61U1N0hDGkTtIlq3yxmT4+/VJ9yFs42klWJsUApjLjlvpn2eSIH
	 BZy2OAlKXX8/GRIi8nk3Nrcpi5cVG92RLxiJYtcY8nYxUVqZbeDdMhc2sr3e/69V3qtNU
	 pbcqRRKKlhcmujti3ju/UBOVe6h/FqYiDCzsAF7Is11bdfreqDgjezcerQgSyagiWsh3z
	 R4PSrn2qUnU91N3KYKLcDRqU0YaHRHA+tJScJ5KnFzZoidpQNOPih2DEytCZuNVcUUbdn
	 A5/bk7aq5FbXgJWDCXaDBg4Sh4dwOff81QMDA94U0Pa0dJ1vK70jD8oeVprsHSoiU4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="bxe1Yv/T";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E295606A321;
	Thu, 12 Nov 2026 10:03:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E295606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=bxe1Yv/T
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IpqQrUdn2qhnA27eiGBsYUdjhzGI02RMEz6Jntjyjrc=; 
	b=bxe1Yv/TQfKAtfczi5Sj5QeQUzYLYU2jmvZ03C5/Ud2YCPSnaq2VbsGmXu+riBnY7aCefzE6OA1
	gtm/KCSrlkNAT4OUsx8A8xdkVhm1ZqiiVMzpKgt9962Cj4Nzh9Qq+Q1Xf+HGsNUPaJpkef0EWMehC
	7eR7Kymzkoye2lxY61VYCBi94fcWqfHPkAdknAvLEBcI0+vddruVjiLmW6HwV3SobSkVU+IhHYs01
	+G9udSXGKwCKAHSDF5dCwFLTnLoiej1rrgBXn5w4yxLZHx5oA4NyVGxF3+5kiZeOgA64fknfsiaGR
	IYheOpEaFZRq28wGMuVkiGW9EaKgO/kQfPDA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRRej-0000000EDvP-3qVY;
	Thu, 12 Nov 2026 18:03:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Nov 2026 18:03:45 +0800
Date: Thu, 12 Nov 2026 18:03:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ryan Brue <ryanbrue.dev@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>, Olivia Mackall <olivia@selenic.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] hwrng: mtk - wait long enough for the next word
Message-ID: <avWPAXUIyv3KP0hb@gondor.apana.org.au>
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
