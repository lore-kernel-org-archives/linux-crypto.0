Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E389827602C;
	Sun, 28 Sep 2025 03:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759031994; cv=none; b=QgZqiMl6c1tUVBq6huHT3umIXfz1Mv5jG5RSwFskrKzirVW3jPHVSWwo1DWF9jgsI5R1jDfzjgu45+ReHabVF2qtaJngK6BXgMbig+AAw7rMJmn1pW4GG3He4tsDTqti0cilWCCjbtmQLoQQORkE44A4XfPRqd3A4qy2fIA0gts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759031994; c=relaxed/simple;
	bh=vzjOspmjJPzC7R9MBh3FkcIH6t03smFNIGFp5E4/2hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iaq/lmb53YF4j8SZYrnDaxyHzCa2U4iP3SUB0M35MFKWHckOvSKipbxiElWAEsgynTkVpCX+Q3yNvP3liNSc3sRkNvRY+jc089m36DRbm5L3uwFT1uJTurMq31LCsYA+x1yLhCBTEsMWx68046QrJxTJOOEpmRN0iIXVSEuRAgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Apq5YTNL; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Apq5YTNL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=KURZhtPJ4MMnUbopcJ6PisqOLs8wVV3eFlGgFKFAdRE=; b=Apq5YTNLGSsCXBD/IqPm8A5h2P
	eXDorf5tuYyVb+qKFi+1sxmEJDeHvytCNf1s+b+1k7xB8i0Q/TyJmq0jMq1ryT3xlOemhrllOeiNZ
	n1w7RXxtv1VSLAB6INPQKrfzFCS1fA4r3kvSbgt515tMz2aT9zajnRMfkLGIC1vASgQG8qABQQcgl
	ryrSeE6ldD68p3W7La8Gm1gqLzM7krV7b3XQlslxXszNx6l+kcYkp9sxm6UICRJgWZLnRkH8te3tr
	yMb9e1NCnlKUNhU3XHaiR2G18TkghG+uWqYU05NPam3RRKJ7I5WJbm8BqVuHul7ndk59TKThURkD2
	NkRhHtGA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v2iZX-008qWb-1Z;
	Sun, 28 Sep 2025 11:59:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 28 Sep 2025 11:59:39 +0800
Date: Sun, 28 Sep 2025 11:59:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kael D'Alcamo <dev@kael-k.io>
Cc: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: rng: hisi-rng: convert to DT schema
Message-ID: <aNiyq8AmsRG2xcWe@gondor.apana.org.au>
References: <20250921161139.99047-1-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250921161139.99047-1-dev@kael-k.io>

On Sun, Sep 21, 2025 at 06:11:34PM +0200, Kael D'Alcamo wrote:
> Convert the Devicetree binding documentation for hisilicon,hip04-rng
> and hisilicon,hip05-rng from plain text to YAML.
> 
> Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
> ---
>  .../devicetree/bindings/rng/hisi-rng.txt      | 12 -------
>  .../devicetree/bindings/rng/hisi-rng.yaml     | 32 +++++++++++++++++++
>  2 files changed, 32 insertions(+), 12 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.txt
>  create mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.yaml

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
