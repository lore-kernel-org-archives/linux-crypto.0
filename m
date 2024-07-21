Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F11726AFF;
	Sun, 21 Jul 2024 12:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721563652; cv=none; b=j680sO4kUIjaYNXOm+dhrYISyHahgosqwsfRTHCsRyqByJad4gLX/g+LMo3hUO4yV2L2kFIBbj3ykRgFkr/OY5BrJGnpbiSfwx8Sgm/9J550WWJXFjNWDax0tZdYCjXBjoaSCsrJvGhVDFB2FBrI33nHADEM0CSJ3UwFttW7I90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721563652; c=relaxed/simple;
	bh=qlb6WjlAnEKcXc092oqfM8G67zC7IPvZt+7Tiv3Ck9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IfCU9DdlV5h73bkv3wMcTVZUCpx2gZObxUKMNdUfMZ/XoeD1qWT+pPIwhJEgb+yFb9LJJDZxxo1x4L+V/7NC3ehU2e2g/a4IlUzLK/CF7a2yXquTS7k3xwzcQh53PP1zUvijzkJh2H5OeL417EgCTJwr+9/6xH34Xxdou14W+kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=N0g7IAhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="N0g7IAhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C7C116B1;
	Sun, 21 Jul 2024 12:07:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="N0g7IAhM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1721563647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9wfLvY3ya2nrHr45pIZikIDrp87iOyHgJfRiGxlFpQg=;
	b=N0g7IAhMr2y4iqU3m3NWTxzJME/+JeNsyoW0Nmoh9tOd+WcJsf/u13VVA3QbVVg1CHYPBT
	tthBNmpSyuXXxLJHbYiVlr7CdBXSlL7WgKvoyWKkHG6NnC3ef5ooE3BKlA0wkaVYIUZ3hv
	NxgAd7PsXLYbYGCILizvOq/YIT4IWKs=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 663834c5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 21 Jul 2024 12:07:27 +0000 (UTC)
Date: Sun, 21 Jul 2024 14:07:23 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Martin Kaiser <martin@kaiser.cx>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/3] arm64: dts: rockchip: add DT entry for RNG to
 RK356x
Message-ID: <Zpz5-2q-C0oQBqoa@zx2c4.com>
References: <cover.1721522430.git.daniel@makrotopia.org>
 <c28cb9ad04062b6da66d9cac8adefa0edc0046ea.1721522430.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c28cb9ad04062b6da66d9cac8adefa0edc0046ea.1721522430.git.daniel@makrotopia.org>

On Sun, Jul 21, 2024 at 01:48:38AM +0100, Daniel Golle wrote:
> From: Aurelien Jarno <aurelien@aurel32.net>
> 
> Enable the just added Rockchip RNG driver for RK356x SoCs.
> 
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  arch/arm64/boot/dts/rockchip/rk3568.dtsi |  7 +++++++
>  arch/arm64/boot/dts/rockchip/rk356x.dtsi | 10 ++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> index f1be76a54ceb..b9c6b2dc87fa 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> @@ -257,6 +257,13 @@ power-domain@RK3568_PD_PIPE {
>  	};
>  };
>  
> +&rng {
> +	rockchip,sample-count = <1000>;
> +	quality = <900>;

As I already wrote you for v7, quality is out of 1024, not 1000, so this
won't hit 90% as you intend.

But also, I think putting this in the DT is a mistake. Other drivers
don't generally do this, and if the hardware is actually the same piece
to piece (it is...), then there's not per-manufactured unit tweaking
needed. So keep this in the actual driver C like other drivers.

Jason
