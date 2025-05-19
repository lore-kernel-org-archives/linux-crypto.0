Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155BF63B9;
	Mon, 19 May 2025 06:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634449; cv=none; b=atRrmJNKQZ4DcumxEcASMDMDqmwMJkZKezmTGQtBB7UxEfLsBptdw2lcAILQ3xte6YmduXSb0sapx8hDZKcvVFl391P1xmzRWYiRc6R1j+lxZ98Y6J+bT2ogRmD2DlqeqmO2q5jfMe4If1BG7CsOyhded1+rQODBqkqClXECoJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634449; c=relaxed/simple;
	bh=DE8CJUTzyviIFB+RZK3QRIxg3nc0qnaK45zkgEKHiJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o9udWHvonm979D7+Zn4lxT0CqPB9OOYdldM2+VYK0Tva25R0otH2gpBsuF2tUc1A4gmb4Ypq6rbkS8oT4Qly/G6QcVZKsZH0A4T30jn21zElEngJrO+14WvhCU+iluQd6eddhxxPyav7UkQWvQ9LOfJoXTJIeIG5eAxZq32LU3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DIB+GExq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DIB+GExq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U0xnaihkpePfiUyqlUQ5SEjWXf8CRS0vG8FT6nry0ZM=; b=DIB+GExqQtSeD9lKwmPHIgiLJP
	NQTgZfu53NrJfIuXWN7EnMMKqccMUbVem/ZRIMayiA/n2EFXujyFKDAhuwZt5o9cANtbmJnKDqXUa
	FJYENOAPXO1812/UWjTTZZHkr5smEdj12I9qMFogBMCVfYo3QMyuASfbkGtTZAvPdxe0zfe/tRaY7
	E+Za8LRxOHsUb5v+cTtHX24gw1eWbFLBRv4HhQ9wrf+3SN58QL6sNX3zA1iK24LqCYVV/PiC6HDuT
	rE678hDDd368/GGT7nA6vIeWKRuEaEp7lZBcKfzQW52aXo0vQCWve0PIGrRbFfYA8rNg3LtvHCQ2W
	G6FIXtBA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtYD-00785x-2C;
	Mon, 19 May 2025 14:00:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 14:00:37 +0800
Date: Mon, 19 May 2025 14:00:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Boris Brezillon <bbrezillon@kernel.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: Convert Marvell CESA to DT schema
Message-ID: <aCrJBaAlN8cZAv-A@gondor.apana.org.au>
References: <20250513184125.3052705-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513184125.3052705-1-robh@kernel.org>

On Tue, May 13, 2025 at 01:41:23PM -0500, Rob Herring (Arm) wrote:
> Convert the Marvell CESA binding to DT schema format. The
> marvell-cesa.txt and mv_cesa.txt are duplicate bindings.
> 
> The clock properties are quite varied for each platform hence the
> if/then schemas. The old binding was fairly accurate with reality.
> 
> The original binding didn't mention there is 1 interrupt per CESA
> engine. Based on users, there's a maximum of 2 engines.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../bindings/crypto/marvell,orion-crypto.yaml | 133 ++++++++++++++++++
>  .../bindings/crypto/marvell-cesa.txt          |  44 ------
>  .../devicetree/bindings/crypto/mv_cesa.txt    |  32 -----
>  3 files changed, 133 insertions(+), 76 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/crypto/marvell,orion-crypto.yaml
>  delete mode 100644 Documentation/devicetree/bindings/crypto/marvell-cesa.txt
>  delete mode 100644 Documentation/devicetree/bindings/crypto/mv_cesa.txt

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
