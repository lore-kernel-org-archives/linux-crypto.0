Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303EE288BD;
	Mon, 29 Jul 2024 23:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722295150; cv=none; b=QXZCxD/2qW7ATs+qcmPXpZxs9qWXxVvgwSZYCojanGCq81MeRDHUagWK+TnwXGm2UGoptXwUMJJLX6Lg8MX97DU3LOvWHQ7iq/AtFy/rQ+oiKZddtKlQQdtecW0LjH8AD5ScAFMRm9wdhK3X73wPMG/8flYh4CglYe62hF2YAXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722295150; c=relaxed/simple;
	bh=C9Q/uxyrf74fdHhdxm1fLdf6cHFhS/lUKhNgg1ajdhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CRAGkjqcQFSGOOpjZYLhDbK8UZLI/lSmAE1Z/NNghFpaVSxWLQzj2+WaAaXyyE3FMKyvB10aBz8DTZpJ1hf7lGkXa4QfBUQlKqQLmupmgd2iLM4PnqSi6BGJY+DFs0/eEzbGXNKUatzPHVQFfMYc7lN/EqVwX9PXBtjh4Mz0yeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.98)
	(envelope-from <daniel@makrotopia.org>)
	id 1sYZdZ-000000006Q5-0COe;
	Mon, 29 Jul 2024 23:18:41 +0000
Date: Tue, 30 Jul 2024 00:18:37 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Dragan Simic <dsimic@manjaro.org>
Cc: Diederik de Haas <didi.debian@cknow.org>,
	Chen-Yu Tsai <wens@kernel.org>, linux-rockchip@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Kaiser <martin@kaiser.cx>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Olivia Mackall <olivia@selenic.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v7 0/3] hwrng: add hwrng support for Rockchip RK3568
Message-ID: <ZqgjTQMgWZO2FjaC@makrotopia.org>
References: <cover.1720969799.git.daniel@makrotopia.org>
 <3190961.CRkYR5qTbq@bagend>
 <CAGb2v64Dx7XaJOu0HHzFxYYY2ddUZao5Tar8-s1R_miVZqWcXA@mail.gmail.com>
 <4406786.zLnsZ2vfAB@bagend>
 <faa0baebabd3c31adf1afa7efbbdf608@manjaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faa0baebabd3c31adf1afa7efbbdf608@manjaro.org>

On Wed, Jul 24, 2024 at 08:07:51AM +0200, Dragan Simic wrote:
> Thanks a lot for the testing.  Though, such wildly different test results
> can, regrettably, lead to only one conclusion:  the HWRNG found in RK3566
> is unusable. :/

The results on RK3568 look much better and the series right now also
only enabled the RNG on RK3568 systems. However, we have only seen few
boards with RK3568 up to now, and I only got a couple of NanoPi R5C
here to test, all with good hwrng results.

Do you think it would be agreeable to only enable the HWRNG for RK3568
as suggested in this series? Or are we expecting quality to also vary
as much as it (sadly) does for RK3566?
