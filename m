Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569A239022A;
	Fri, 11 Sep 2026 05:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104802; cv=none; b=MNEy04z+heQkAXpa2gPIwa7hqcjSiX/W9ggYwvDovfRVsaRcqfbqzqleYjo4RA1jI4Lx/rxW1T0N+xZUuA/QfVZggCY/vz/7LJjpSNDZ1uFVTggoDa8Mpk43bvmgXTVsuFPj7HFKQqzBk5ZY/xlcfQ1+1A58e1vx0LldoDOJJyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104802; c=relaxed/simple;
	bh=zGZ3uu0S3y/uYm1Kg1dxuSxHdKPYJr/SNR1QnCOeyQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6bwgf0qX9vFtniz6DQnSSwRI+Q9/mvn2oC3/Fn/YkiCzHBE3Y2qq4BDYzZ2sFEpP/EbfU+wkgH68iTX13OMjKCbIAfVFcanfY675HDCFzMzvmhRl4m5FhT2LqDLeKXH7tS9mVeR4kA3flV24wEwSglIFiF1555yQGxOzRBsZo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TIMa3c6G; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TIMa3c6G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PdKT3mgg1Pb/Jdrfl1nwELxR2cBte3Dqhgwz6ZyzOwI=; 
	b=TIMa3c6GeA4fZd4f2E6nP97mtVPGZ6Brs0UF+lS5YEA2cywF320gAH8RDdDBChvD0RddqlPLGhx
	WXuqzHhDm7t+Tnm/GAwrHmIPWaWJYaB3qnhyhJX9tQYv+NSi0i6fA7FMT4jiDiibym1Z/YaSlFztO
	q7hR/B3xMXUs++aaDluo+STuZciNdkyZ1ufV1DOwBsHTmOAU73PMqgfI2Nr74K+Zu0MrcI7PRUuuq
	JEFjXcSp/CSDwOVHvAT8fmCF7rzl/e8WKLWFeFtY0a40Y+1SXFc8qNHDYZ4t8afbW8+UCeAVsHuKw
	IPkVSKsec5vXBCXbyEZztjYGKnN5+0fEruBg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tsi-0000000CuDA-1MAD;
	Fri, 11 Sep 2026 13:33:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:33:00 +1000
Date: Fri, 11 Sep 2026 15:33:00 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Wensheng Wang <wenswang@yeah.net>, Frank Li <Frank.Li@nxp.com>,
	Cosmo Chou <chou.cosmo@gmail.com>, Colin Huang <u8813345@gmail.com>,
	Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Eddie James <eajames@linux.ibm.com>,
	Dixit Parmar <dixitparmar19@gmail.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH 1/2] dt-bindings: trivial-devices: add atmel,atecc608a
Message-ID: <aqOSjDb1FeLv9Po4@gondor.apana.org.au>
References: <20260830220151.21469-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830220151.21469-3-blum@kernel.org>

On Mon, Aug 31, 2026 at 12:01:51AM +0200, Thorsten Blum wrote:
> Add an entry for ATECC608A.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  Documentation/devicetree/bindings/trivial-devices.yaml | 2 ++
>  1 file changed, 2 insertions(+)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
