Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF464AF169;
	Fri, 18 Sep 2026 08:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721227; cv=none; b=FYf2WKgWgA/YDvSMzV6+OaaqwBeWxw2Vq3oypDdXkWJedVNxnE4UJfFfRPCTpXT0W1gTc4xJ7xfSWwxn7Sy2Hkxo0fuVICrzz6ORJU9PSjBIapN4ENmTZdi5xrQKBpoa/0nhOc7LgK1kE4pkBmacf/D+O3aoTyULqbnoHqXN7S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721227; c=relaxed/simple;
	bh=/nXPBdJYH8nvuy0mJToWvX1IgI6s3f5ppwli6o/jP/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U0OWlDXKcEctArQlJCvd/UJgFyZ/F2AkYM1OolKRf3tzR5YPwVjoWQE3k0nKcHqYe7ezVnBU0w2pz04ONRT3gS6qQ3bVHnXQNo2Ww7ThXCigXd59YT8VcWuJ+UXAz014q1Myt7evQpiLaDc9T7d713XI4GgynhC+nElzY4BTKzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c65NNrxv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c65NNrxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7A41F000FF;
	Fri, 18 Sep 2026 08:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789721220;
	bh=/nXPBdJYH8nvuy0mJToWvX1IgI6s3f5ppwli6o/jP/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c65NNrxvSf8TmwYZKhPXmbbGcdsK/lZ4f7yRJsWG0jRcyIuqUnRV80s4W4R43VquZ
	 VUzCUpsZJMPvS3lXDyMEDFUg46rHt7jFWnEEqJi9I/3h8ef4Yq3+YbT5Sof89Cw/Qe
	 9GpPpIomjDGAvpo0rhoXK7DMes/NKMKzyNGwUjZaVSVdHy0P2EfAm6/hhA6eXhf0qG
	 YORK+0HF2WpCmGhwuxNbHw6hJWCXB/+6Z0MciYDMUhAYM8QU4nCqrN9HnaErfYa/+V
	 icnvq3kLdg6tMhB+alLlKnbYg9Ympj1XDAPalwWBH4i0Dx1aCmb8JJpYMtHtuyjBfP
	 CKTjPzUlLUsWg==
Date: Fri, 18 Sep 2026 10:46:57 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Bhargav Joshi <j.bhargav.u@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, 
	Andreas Kemnade <andreas@kemnade.info>, Kevin Hilman <khilman@baylibre.com>, 
	Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Animesh Agarwal <animeshagarwal28@gmail.com>, linux-omap@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/4] dt-bindings: crypto: ti,omap4-des: Remove
 redundant clock properties
Message-ID: <20260918-jolly-honeybee-of-improvement-601ad0@quoll>
References: <20260916-ti-dra7-omap-sham-fix-v2-0-4eadb60081e5@gmail.com>
 <20260916-ti-dra7-omap-sham-fix-v2-1-4eadb60081e5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260916-ti-dra7-omap-sham-fix-v2-1-4eadb60081e5@gmail.com>

On Wed, Sep 16, 2026 at 02:29:38AM +0530, Bhargav Joshi wrote:
> The omap-des driver doesn't use the clocks and clock-names properties
> because clock management is entirely handled by the parent ti-sysc
> wrapper. files omap5-l4.dtsi, omap4-l4.dtsi, am4372.dtsi doesn't use
> these properties either.

This is not a correct reason alone to make a DT change and it is
explicitly documented in writing bindings doc. If hardware has clocks,
but driver does not use them, they must be documented.

Explain the hardware. You can mention the driver as an argument proving
only lack of ABI impact, but not reason to make a change.

Best regards,
Krzysztof

