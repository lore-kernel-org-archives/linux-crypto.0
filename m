Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91403EA76;
	Mon, 10 Mar 2025 12:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741610999; cv=none; b=D2am44IPbtHAOFIDJC6gLJCVmqSymqSYcB/RlmvonAix1a1xNRA+eXPaUyeesmfNKKe9XYzRq5kRPo2ZIrcsKSnDf3PmfXUi4j8GE67RVAv48n0XBtUo+otRnLH9j3WptZ/Ol5Fk/4hrgY/ircFVTR4Z7aHSR1KvZ2FhEf9VCwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741610999; c=relaxed/simple;
	bh=DOEHd6cnQseKz/MeHFswCo+xv14h0VbP6CgZAcOI3JE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oul16weC87prodnMAxpJrbtCi0/dEL/48wbmHrWJ9bBKCgIcwwSvnnIAkY916g9qy8l+oSyZoJY8bq9tXuE2BNSW3+GH2IGWRqPBXx9M/1JrCWoNMAhPbUct3CcG1oyDYHidIG4LQNXvsM14WtkeIxzvl5hpNq2OocSZkAVu5ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0HcoMdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0HcoMdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2358FC4CEEA;
	Mon, 10 Mar 2025 12:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741610998;
	bh=DOEHd6cnQseKz/MeHFswCo+xv14h0VbP6CgZAcOI3JE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t0HcoMdXQYndg5RPlZ/Dwc7eluZqRPTg52J1enTxQ+Gaf8XTr2u1yWhmevb/1HfCb
	 NM0JP2gBaWhFobT/aTQwj3PUh7+2yZr0+oj4mKeTM61OmPeeKRjprbHtuGn3yJCZsA
	 Ny94+jR2DkKRL9pvcPEhM9Ap0KAmO0HGH5oI4RMoOgMi+k7SKGqvMRw+r1QS3o3p/o
	 WXS+KHf4HmXv1tupmZQ4PfFjkVlDYf+uXOvGBxQzfJhumJLtJeCluwcu378AdQYihg
	 Hqsehhwtuc63VG27IvqJxAANYVaweTZJO9WQ5tDsUCYxI92p+fUhsxIFaB2y/bmb67
	 o1YH5kOR/RY6w==
Date: Mon, 10 Mar 2025 07:49:56 -0500
From: Rob Herring <robh@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v2] dt-bindings: rng: rockchip,rk3588-rng: Drop
 unnecessary status from example
Message-ID: <20250310124956.GA3875809-robh@kernel.org>
References: <20250307093309.44950-1-krzysztof.kozlowski@linaro.org>
 <5417098.31r3eYUQgx@workhorse>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5417098.31r3eYUQgx@workhorse>

On Fri, Mar 07, 2025 at 03:05:50PM +0100, Nicolas Frattaroli wrote:
> On Friday, 7 March 2025 10:33:09 Central European Standard Time Krzysztof 
> Kozlowski wrote:
> > Device nodes are enabled by default, so no need for 'status = "okay"' in
> > the DTS example.
> > 
> > Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> > Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> > 
> > ---
> > 
> > Changes in v2:
> > 1. Drop unnecessary full stop in subject prefix after ':'.
> > 2. Add Rb tag.
> > ---
> >  Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> > b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml index
> > 757967212f55..ca71b400bcae 100644
> > --- a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> > +++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> > @@ -53,7 +53,6 @@ examples:
> >          interrupts = <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH 0>;
> >          clocks = <&scmi_clk SCMI_HCLK_SECURE_NS>;
> >          resets = <&scmi_reset SCMI_SRST_H_TRNG_NS>;
> > -        status = "okay";
> >        };
> >      };
> 
> Hi,
> 
> is there the possibility we could make dtschema as invoked by `make 
> dt_binding_check W=1` (or W=2) add a warning for examples that have disabled 
> or explicitly listed status properties when not needed? Or is this something 
> better handled in, say, checkpatch.pl?
> 
> The question arises because dumb mistakes by me like this should ideally be 
> caught before they waste precious maintainer time.
> 
> If it's best handled in dtschema, I can look into working on that so you guys 
> don't have to do even more work due to me.

Trust me, I'm always looking for things to check automatically. :)

I have something like that which adds a schema for examples only. I 
think there were some corner cases. I'll take a fresh look at it.

Rob
