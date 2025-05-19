Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9501C6FE5;
	Mon, 19 May 2025 06:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747634407; cv=none; b=K0GzzJHp9F+uBRGPz8tfhEW6QqRwm5bVJhyo8FTnVChp4nGwRURva7Cz1HWMI9X4r/fFX/7B/+XsXWyzvBFWr8iSG+q1bIBB1YSOaI3UC5uFcXVwGKVh+uxqtbHIhp2H9k7wcgg/DpPUVWqi6aRJrCYk+oruvyBlRk/Sh3WeQIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747634407; c=relaxed/simple;
	bh=NOnvo7eUOCbEOc94PyTpCqq9+2Qf8DHBhSAm9nzXf/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jS5NVyLEKGY7ZVlNqKV412xKxAf5FrrDjV5JWtd6RtQzFpgT7uinMvQogrMv4Oj1+6fgeGhGxJ8H6L99DlzLn9soD9Q2uBOfv2LQajMgTITzFkAcVcue1UAfWqSsSw62EFPc/CyV5U4JJrmZ/4rXeShNBSgLFhzkclqbvFEiT/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FU9tFkAA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FU9tFkAA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VEc0G+EWqK9ZUZ2NEMHITtg9zm26pHzmElk8+0AuHDg=; b=FU9tFkAAhaqoHBH4c5nROqTjXb
	9Qmne3DqBuJRROA28qh/AB10KQ9vtA8Kj0/qPlxuXm4HMEugime2nHlEmoizrFFx7bQuPKX7M8MTv
	PlLMPilsNBJWgdqxfCWERKxkfNe/vX+MBrnnOUoxW48HqFesNQjACdjJF8eGzWWBmmQljWrpJTFNZ
	1nqRCm2MwH4N9Q5WLo61fTYc99IOFOh/JS7AdBzOE8kGqr2w6ljhbdY2b/ePRKAMfu/uyXPbIijVg
	E4xM/Prlt3J5IXl/MdP8biFh41X/53jXVPJhNQBBEJUT9vhZ6kb0603I9u1afkiQ+1GfJUqzNs4ax
	eY5bOotg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uGtXa-00784g-1j;
	Mon, 19 May 2025 13:59:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 19 May 2025 13:59:58 +0800
Date: Mon, 19 May 2025 13:59:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Lars Persson <lars.persson@axis.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: Convert axis,artpec6-crypto to DT
 schema
Message-ID: <aCrI3u2DrTKeRfVZ@gondor.apana.org.au>
References: <20250513184057.3051854-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513184057.3051854-1-robh@kernel.org>

On Tue, May 13, 2025 at 01:40:56PM -0500, Rob Herring (Arm) wrote:
> Convert the Axis Crypto engine binding to DT schema format. It's a
> straight forward conversion.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  .../bindings/crypto/artpec6-crypto.txt        | 16 --------
>  .../bindings/crypto/axis,artpec6-crypto.yaml  | 39 +++++++++++++++++++
>  2 files changed, 39 insertions(+), 16 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/artpec6-crypto.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/axis,artpec6-crypto.yaml

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
