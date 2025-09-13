Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115FB1F419B;
	Sat, 13 Sep 2025 04:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737611; cv=none; b=go5wuQ02QiocEmPTyeHetlYlihXiZqLp+q/Q9Qrirfm/oeV6qKH0H5RUfDyu/pi/Tg66V9Wk3oum0HzVxrtkvwNIgbYsnXDbbJDmiMgY/XCEJsvFBY5kgwQ2DfFWRuvhmcZW0F2ShhdUx7ndcGU6wWf1MUmLK/VMV5hTbXfqhTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737611; c=relaxed/simple;
	bh=XQTJIS0vIX9aLmO5Z/tUbn+KwMviQjZH0cJykSjiGqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=McuOCsi0jaD3BXd1fNwOgxAETZXVu8+gt5hhMjrBnjwe+RX/y8Mc4AudGdq47KlF6MazCobAz/ge5XBSynF6YVKX8yNiRFvfH/UzjCN4TTGb2PsB5pTnYw7o75Tn6hPK6kKb3bZERtOuG6HLzux3z85DLGCTnLZ5ybEMoxpATYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LGB7ip08; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LGB7ip08"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pMobyi7CHCAtrZXUZ+2PHke7JPIPiUB151O5SnfBnDY=; b=LGB7ip08oATk4jJqJ6nd/Rangi
	PARRVwJTKrt9yL0xGwqYkE/mv351unpn+EQAoS2jJ5skaKm+WvXkmfAfqnleHyBylI16cQdc1okCz
	Mnbr+9wJCoyKBA8dLh7iSZd6IFn06RGfvFH7AJCsy94lTnJ9kwdu3SODGn0SXSp5lwg55/P5mQz92
	JVCmg3L1JlrLKmZtGYIrJlJHnGeZIWKz7eI01xG4VwYaw+5Pvn0SKbPGhrcpD5p8TG5MIj7ITIXFq
	9RujF66I+8MUoynFdvSmy9pCaX4KGgIYhje5BVz3+JpORmhaW66sTyu3omRferKDBezm5NdOTRu4v
	1pOq7BRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHat-0053nS-2d;
	Sat, 13 Sep 2025 12:26:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:26:32 +0800
Date: Sat, 13 Sep 2025 12:26:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
	"David S. Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>, John Keeping <john@keeping.me.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: rockchip - Fix dma_unmap_sg() nents value
Message-ID: <aMTyeGTWPgsFglQ-@gondor.apana.org.au>
References: <20250903080648.614539-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903080648.614539-2-fourier.thomas@gmail.com>

On Wed, Sep 03, 2025 at 10:06:46AM +0200, Thomas Fourier wrote:
> The dma_unmap_sg() functions should be called with the same nents as the
> dma_map_sg(), not the value the map function returned.
> 
> Fixes: 57d67c6e8219 ("crypto: rockchip - rework by using crypto_engine")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/crypto/rockchip/rk3288_crypto_ahash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
