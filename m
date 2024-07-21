Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DCA4414;
	Sun, 21 Jul 2024 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721569788; cv=none; b=RpfKKgO2B2Bq4yRPNYmab9+XC8VZbrzd3Q3gSwmAQ8lcYRu71VXJZi3opYl777ZOkUYtidy0LjhD8E5pkWYK4vvTwtfa9A63Tc//cqxA7YNU9U8pfMHH/6TmWzZkx6AqlI2POxuQQ2J+WB5QcFweg0N7AZD3bRa/nk3Sk+FxqK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721569788; c=relaxed/simple;
	bh=mLvS1bT0Th5eLLuLv0fvplVbwtnqYlF5KvlT0I8gAFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fl+dJdBjbCd01gKqsI+n8ODs+UMm/u0NaWVFojeW4USmkmbxMpeVerlxlYgt+Eczn7AoF1/AUDva6JOlOSYTsPIr0WNo96pKz4ZzK4fRubW1uu1mh7ATq0/jB/dzXaku6b9wOgx0xlNrLofyMrPyvIbnqDOjEFmjl63ePXuJxVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.98)
	(envelope-from <daniel@makrotopia.org>)
	id 1sVWwH-000000001Qr-1EaD;
	Sun, 21 Jul 2024 13:49:25 +0000
Date: Sun, 21 Jul 2024 14:49:17 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@debian.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Martin Kaiser <martin@kaiser.cx>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/3] arm64: dts: rockchip: add DT entry for RNG to
 RK356x
Message-ID: <Zp0R3YtzDoi02P1K@makrotopia.org>
References: <cover.1721522430.git.daniel@makrotopia.org>
 <c28cb9ad04062b6da66d9cac8adefa0edc0046ea.1721522430.git.daniel@makrotopia.org>
 <Zpz5-2q-C0oQBqoa@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zpz5-2q-C0oQBqoa@zx2c4.com>

On Sun, Jul 21, 2024 at 02:07:23PM +0200, Jason A. Donenfeld wrote:
> On Sun, Jul 21, 2024 at 01:48:38AM +0100, Daniel Golle wrote:
> > From: Aurelien Jarno <aurelien@aurel32.net>
> > 
> > Enable the just added Rockchip RNG driver for RK356x SoCs.
> > 
> > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> >  arch/arm64/boot/dts/rockchip/rk3568.dtsi |  7 +++++++
> >  arch/arm64/boot/dts/rockchip/rk356x.dtsi | 10 ++++++++++
> >  2 files changed, 17 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> > index f1be76a54ceb..b9c6b2dc87fa 100644
> > --- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> > +++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
> > @@ -257,6 +257,13 @@ power-domain@RK3568_PD_PIPE {
> >  	};
> >  };
> >  
> > +&rng {
> > +	rockchip,sample-count = <1000>;
> > +	quality = <900>;
> 
> As I already wrote you for v7, quality is out of 1024, not 1000, so this
> won't hit 90% as you intend.

It's not actually 90%. Around 125 out of 1000 test runs are failing on
the R5C boards I got here, so that makes it 87.5% which is pretty close
to the 87.9% of the 900/1024 figure there, hence I kept it 900 despite
your comment.

> 
> But also, I think putting this in the DT is a mistake. Other drivers
> don't generally do this, and if the hardware is actually the same piece
> to piece (it is...), then there's not per-manufactured unit tweaking
> needed. So keep this in the actual driver C like other drivers.

So quality should be assigned using the DT compatible, right?
And if needed we should have several of them, one for each SoC (if
testing now turns out to show that the results are specific for the SoC
rather than for the board).
