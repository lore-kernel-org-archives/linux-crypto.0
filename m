Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5187463B9;
	Sat, 21 Mar 2026 08:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774082864; cv=none; b=fQ6fL2UJSqVouXlTl4Hm66Qav+CawTgqLVp7zyzTlesBmavX21PPIkDjuHW7Zp+/djg40tayYwPCxdXhG0UR7vBRlltIVP2+OiKKlyM+4YJWASVwfIfIZFtB++ykZvuexTES8I9ucmPzqiiRcnJ2u+d4IVXgxdZoqEnNRn3jVMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774082864; c=relaxed/simple;
	bh=zMxNpJEX1tje3qAn3gofcFe7zsudK0mfHnAIxiq6Lbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lJmcRkT24yD/qayEmiUS5B8tm/bHtvcDnHDu5nZ51qsdFrmcvrEW52OPl5VRoZ/5OyeDmr/UyV5/DJ0MlGYsRjApGCN2dD5kGeEuW/9vphQdTKKjWij3wMnzoXZ2PHmyV0txqcqVjfATA7O0sQxQfCOvWq/vsKRAAikFgnMwQiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hGZtU65a; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hGZtU65a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GAYI36BuyLNtFwWJ/mVzmo5kO6+XzauuqvOp/jdB/BM=; 
	b=hGZtU65aSlNzhszzUX62kqapg82S8od4wk2niylkubjcIWYINWO6v7Im/SD6cOWxnS4OUD3/oLV
	PxmzOXyOq1iH6gAaaQuky4RtTEO6AvJDK/JK7igpJjz6iRiCGPnoj8fzp+0rJuswEJ2t1MGOC/v0h
	K+XnS8WsFi6VVOYIY+7gek2ZM49hTW9/TvU2kLYa8J0qWWoaNIHau62a5DQm0ebfooGTO3vsdi/pC
	HtmQ8YPH5poAWvKBK8+FGtQix/IcN5eAncL1fotSvXL5VhSRrYpT69wpZB2IKYJCousVCE9ZU1Wp7
	3bDQhC2y2QQOXwzvceDhIbCL5xEc9xVQ7y4Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3rzJ-00GJ8e-0s;
	Sat, 21 Mar 2026 16:47:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:47:17 +0900
Date: Sat, 21 Mar 2026 17:47:17 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-aes - Fix 3-page memory leak in
 atmel_aes_buff_cleanup
Message-ID: <ab5bFYWKvBakbESr@gondor.apana.org.au>
References: <20260311020733.250288-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311020733.250288-3-thorsten.blum@linux.dev>

On Wed, Mar 11, 2026 at 03:07:35AM +0100, Thorsten Blum wrote:
> atmel_aes_buff_init() allocates 4 pages using __get_free_pages() with
> ATMEL_AES_BUFFER_ORDER, but atmel_aes_buff_cleanup() frees only the
> first page using free_page(), leaking the remaining 3 pages. Use
> free_pages() with ATMEL_AES_BUFFER_ORDER to fix the memory leak.
> 
> Fixes: bbe628ed897d ("crypto: atmel-aes - improve performances of data transfer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-aes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
