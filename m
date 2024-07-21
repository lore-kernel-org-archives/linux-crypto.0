Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1210B804;
	Sun, 21 Jul 2024 00:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721521609; cv=none; b=XwNA0RYOCniCqDRIrAYi+VjGF8FNkVJdT4jb3Bp5CLnZ9QXJwN7kD3U6RqB9QY4t/iYK3mjx5qFk7x6QxJMCwq4mMsXrKr40HYjHvhzDgTYRE5gd4el1mAMidbCQ9o928AZMOIAH0Y0bEkW6xvzvAq3+l11d7vmqpgGX8Q2oZtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721521609; c=relaxed/simple;
	bh=JMGaMaPZ3ZO2BcfKDOjO1lFotjB4r9bLN2jZkshxsj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMcS8YOKWjIePhssaXNsp1DetmXSssjH6mUNh6v8EMZ70cUlenh2uMCsMVRdPn+DMwj1+VGZhcgeGB38iIgwo73bzifjUTTeVygn6JQNy0Si7ufI31Qpuw3HdE2I17Nh0yo4tNIR2UdRf8+XGlAksh3J2FixknSjGxfJ26xT6Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=Ofoz6UP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ofoz6UP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D312C2BD10;
	Sun, 21 Jul 2024 00:26:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Ofoz6UP3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1721521604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=94FH1yeLhYBAH1oy+kJ20vtAV9HFB221cCBm9BA0Y7A=;
	b=Ofoz6UP3L2rYYQH6xpyv5+l3QzmBz2DqzvtyQRdg0I5jCeLGXesg2U3vIwij0bYuMW6qCI
	ZNiNA2P7D9i/D9QhhHqK/3V0pVmuRhMTdrpi71gIrXXXCdKnm0K38ac5w05FbuGtgiS481
	HiX89vVGR/i+0MON2fj7Dx418V6Dwgo=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6afbfb1c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 21 Jul 2024 00:26:44 +0000 (UTC)
Date: Sun, 21 Jul 2024 02:26:40 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Chen-Yu Tsai <wens@kernel.org>, Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Kaiser <martin@kaiser.cx>, Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/3] hwrng: add hwrng driver for Rockchip RK3568 SoC
Message-ID: <ZpxVwFdIZxLw3R_l@zx2c4.com>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <f606403145588d28dda14a55ba3afef85720a4dc.1720969799.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f606403145588d28dda14a55ba3afef85720a4dc.1720969799.git.daniel@makrotopia.org>

On Sun, Jul 14, 2024 at 04:16:17PM +0100, Daniel Golle wrote:
> +	rk_rng->rng.quality = 900;

This is out of 1024, not 1000.

https://elixir.bootlin.com/linux/v6.10/source/include/linux/hw_random.h#L35
