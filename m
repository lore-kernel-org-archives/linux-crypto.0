Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86C43101DC;
	Fri, 14 Nov 2025 10:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763115807; cv=none; b=ZU2ZeiJDTtMSCeGan4ZRStSzYL6Phyq+v162RHoU9ndGIF7TyIl3Y23EdLZ3jFOt06uy/9hoiK4o2yi7bqMqKSl1EB7UZKhi1HR0PgAu+LCoJ54W3RE1ohg8KwZ7+e4AuQrWUrocHM1hwS73P8CU9TFZIa2Vll51UFgaW29NNOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763115807; c=relaxed/simple;
	bh=ctZHJWuq+0TpQST/zyyIk88G6B435ZSxcmvS9Z2hcIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iJiWI1qJkM5fuxuoDSHT10S4TjdlZtl74adpV4gRXQQQq86f0Gfd5by/1cejxXdXCGWlwONovWwoH33H98rQq5sntBAPiCD+PeaXDwJj79cizQ03vPEO36X6b30v3uezmbCXBa2DfpgnwBs/5vODVhW0OWl88bafX2k8MY+PTP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZnU1QTQ2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZnU1QTQ2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zn+WZbkFWl9GEXlWzbgdsX9misJw5iBF5BGbREwNIdQ=; 
	b=ZnU1QTQ2Ezz66z5U+K+2XVzN9FSC9x7fI/wpDa0JR/y9hD98yNP5vNBBSB7/i4ZHJDzA3Vg6agJ
	lZr/mJYkNxLWGhRY11EXNWP1m7kkhxAN+huwmjXhks6BcV88MvvVovp+w9+73Sz+Rj4c05YdKmf6V
	YZx5Ap76TF7SxcHstmXugmQXRRsYHjw1dxIAlM/swiq2a9v8W4OA0Csy5dCyPTZS4CQIIYC9lFHVM
	iWOw+pltNGDErFgNtW7dTYl7QYft3IxP8TFQsFAV/CLvUUgU3C+Xl5wTWub0z9STMqcPwdSaYROej
	N4tt/J9N2G1zTGvWU9cYAhGQqCnoWlED3cvg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vJqwu-002yOl-2q;
	Fri, 14 Nov 2025 18:22:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Nov 2025 18:22:36 +0800
Date: Fri, 14 Nov 2025 18:22:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
	Jesper Nilsson <jesper.nilsson@axis.com>,
	Lars Persson <lars.persson@axis.com>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@axis.com
Subject: Re: [PATCH v2 0/6] crypto/hwrng: Simplify with
 of_device_get_match_data()
Message-ID: <aRcC7NzNk7__6hb3@gondor.apana.org.au>
References: <20251107-crypto-of-match-v2-0-a0ea93e24d2a@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107-crypto-of-match-v2-0-a0ea93e24d2a@linaro.org>

On Fri, Nov 07, 2025 at 09:15:47AM +0100, Krzysztof Kozlowski wrote:
> Changes in v2:
> - crypto: artpec6: Add missing (enum artpec6_crypto_variant) cast (to
>   fix 32-bit builds)
> - Add Acks/Rb tags.
> - Link to v1: https://patch.msgid.link/20251106-crypto-of-match-v1-0-36b26cd35cff@linaro.org
> 
> Few simple cleanups, not tested on the hardware.
> 
> Care has to be taken when converting of_match_data() into
> of_device_get_match_data(), because first can check arbitrary
> device_node and the latter checks device's node.  Cases here should be
> safe because of_match_data() uses 'dev.of_node'.
> 
> Best regards,
> Krzysztof
> 
> ---
> Krzysztof Kozlowski (6):
>       hwrng: bcm2835 - Move MODULE_DEVICE_TABLE() to table definition
>       hwrng: bcm2835 - Simplify with of_device_get_match_data()
>       crypto: artpec6 - Simplify with of_device_get_match_data()
>       crypto: ccp - Constify 'dev_vdata' member
>       crypto: ccp - Simplify with of_device_get_match_data()
>       crypto: cesa - Simplify with of_device_get_match_data()
> 
>  drivers/char/hw_random/bcm2835-rng.c | 11 +++--------
>  drivers/crypto/axis/artpec6_crypto.c |  9 +++------
>  drivers/crypto/ccp/sp-dev.h          |  2 +-
>  drivers/crypto/ccp/sp-platform.c     | 17 +++--------------
>  drivers/crypto/marvell/cesa/cesa.c   |  7 ++-----
>  5 files changed, 12 insertions(+), 34 deletions(-)
> ---
> base-commit: cec65c58b74636b6410fc766be1ca89247fbc68e
> change-id: 20251106-crypto-of-match-22726ffd20b4
> 
> Best regards,
> -- 
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
