Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06AF5322C78;
	Sat, 14 Mar 2026 05:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773464838; cv=none; b=ZjGuPvWUflFmKWcNliWBx4+vujESy58Im4tHFOXncItnwO94oOSRz4V0mBHu1C6lolReCkthH3oLwB1Trid+ZqQ3uoW4MnsRxxZTONhRvicP5YGzwZE+A2mQtKg1flJJPN8U9Egsa4kvaN0xfk7SXrDJ5wESN9s2kQEeizUsB6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773464838; c=relaxed/simple;
	bh=8ugnbo23foEUCR/+yALd2xdodJqCGBiYJojIv7YqAMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCaoXJytaehkjgYgBnePZzqudhW9aa7PlOkCm5YamzMzFGNoGdJLdceF5XLuwzyYJcy9V4OiLUnAo0IziEiGzBpUi5kgc7lxzriux8+uTfCE6rXb/Gi1YpTgwxYttrKxccAD3RR4yEeT+joZ/RqV7jkCEzPP71O4KighB8k53Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MpGyM0n6; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MpGyM0n6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HN4c/md7ubCwGFV8iB4QQzxgqPerbYJNq+32KO8z7Z8=; 
	b=MpGyM0n68D6QdNiLKQ1JFuuyEnUZ7u9mToS5Y4vXL6GAmMzXQgTJ+dh+7WD1L6fyiDIWx06tem9
	+B3PiDe6OfX4FAf7GkdaEFM9Z1OBhbuKSF+3Yzot7SCxsa5LBAO3TnEH6X0jr0McEYcLTyrpkFbTA
	j/gbE54UZOWYr+GgWJYZFqEkM83fY7PETke6zr8LmEJcuxvwOiA1v6PC4rNfWFZvxtxzYRFXCqMQ3
	9z9aNGDl0kZJ0ybv2adSuhYEDn6MOy0nzQZZdnTLnNP4TbZ8KbUkxCuuETJNoFNLFEliztUkvES7z
	pWcIPX2FfsD/EN/6Kk6auxPb5qWCL8TnycNQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HDB-00EL1R-1V;
	Sat, 14 Mar 2026 13:06:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:06:53 +0900
Date: Sat, 14 Mar 2026 14:06:53 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Robert Marko <robert.marko@sartura.hr>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, olivia@selenic.com,
	radu_nicolae.pirea@upb.ro, richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org, jirislaby@kernel.org,
	horatiu.vultur@microchip.com, Ryan.Wanner@microchip.com,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
	daniel.machon@microchip.com, luka.perkov@sartura.hr,
	Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v6 2/6] dt-bindings: rng: atmel,at91-trng: add
 microchip,lan9691-trng
Message-ID: <abTs7exXXVPcvULD@gondor.apana.org.au>
References: <20260302112153.464422-1-robert.marko@sartura.hr>
 <20260302112153.464422-3-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302112153.464422-3-robert.marko@sartura.hr>

On Mon, Mar 02, 2026 at 12:20:10PM +0100, Robert Marko wrote:
> Document Microchip LAN969X TRNG compatible.
> 
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
> ---
> Changes in v5:
> * Pick Reviewed-by from Claudiu
> 
> Changes in v3:
> * Pick Acked-by from Conor
> 
>  Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
