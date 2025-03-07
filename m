Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C8518DF65;
	Fri,  7 Mar 2025 14:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741356396; cv=pass; b=pBgaS9tSPdH5zs3qjs72FkBI1qUTINcjK6a3w+DZSI1ZxNdLRNQsn00zKep1JBNzUneyGf2h0nXgWPsHd1t+tJqeXp6Vcuer8uhHFmfeoHzsU/UQ1O22qyMT2jKzuEVGpZu3qwJqqWgBI3i7JHhNxhAz1kHtCcYl8MfrDz60CFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741356396; c=relaxed/simple;
	bh=ykdhXmylYh6z/rNdao/fGKzQPI3z2XmS1ESDJTS7TYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QGQiIX2zO3ezoyJiUS/o1x6WiTTwwug645zoFo+5NrKnCaJMCPE5xBMQBjEeiNTa2/JO7/JWo9vVpDMjHMe+FFlcYeJeEgqW/AvP1PT5zI3IGIWGMoKp5rvv5qerUXiperkO40i6p4BboCeBcK1FwfjWezQQDXXRCUHC0AiR2OU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=k4LLpH1x; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="k4LLpH1x"
ARC-Seal: i=1; a=rsa-sha256; t=1741356358; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=RUSqeTjX0/f+vSCIJFG7Ivi/H9ExZZOTIGsH8b/7NgnDNY+UPVZ7ECjWzwOuDI3RzpTfQqmbZSAsfna/nJrzgxqNHi9CItEF9nS40fA67K5OyjyabwmfpK9um35EBQjHtXoOmHIdnjUaDBCCDMC8yAzHg++9XIkIh6wtiClIxik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1741356358; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FP+ifasHniIC8neSq6VwSq5ZsIenCwU36aCvQ3EbV9k=; 
	b=M4EErEyApvaCAnFL5c92n1M0wMYZ4/LNdYQL/JjFfVIWr1+oWZ7LWHG91M7LH/wdakw0O6B/Z6DdW1CFhUYSU8YrcdcDdi/S/B33oM+ZFqVbEURJgvl8Ve4JwYi+DVhf5OMbdwCpJiS1Sj2d8rpDnz9ZN6y3eCQFi/Cx2aen930=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1741356358;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type:Message-Id:Reply-To;
	bh=FP+ifasHniIC8neSq6VwSq5ZsIenCwU36aCvQ3EbV9k=;
	b=k4LLpH1xLhH5D3H7h2upAramGsfkMWDuPKZ9FZ0XGVS9QKMQsdQP0bKN4azcuUGk
	pMfBCbFEZtyQaxyMl/XEFyBtH0id4McTIUQZz/KeSYcNbJQotbnjO7wP5JrTi+oGXgB
	95fO8bj46v0ezvai2ZHpniitwdl6VAtoA17B70u4=
Received: by mx.zohomail.com with SMTPS id 1741356356876241.9419093370691;
	Fri, 7 Mar 2025 06:05:56 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
To: Daniel Golle <daniel@makrotopia.org>,
 Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Heiko Stuebner <heiko@sntech.de>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject:
 Re: [PATCH v2] dt-bindings: rng: rockchip,rk3588-rng: Drop unnecessary status
 from example
Date: Fri, 07 Mar 2025 15:05:50 +0100
Message-ID: <5417098.31r3eYUQgx@workhorse>
In-Reply-To: <20250307093309.44950-1-krzysztof.kozlowski@linaro.org>
References: <20250307093309.44950-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Friday, 7 March 2025 10:33:09 Central European Standard Time Krzysztof 
Kozlowski wrote:
> Device nodes are enabled by default, so no need for 'status = "okay"' in
> the DTS example.
> 
> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Changes in v2:
> 1. Drop unnecessary full stop in subject prefix after ':'.
> 2. Add Rb tag.
> ---
>  Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml index
> 757967212f55..ca71b400bcae 100644
> --- a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> +++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> @@ -53,7 +53,6 @@ examples:
>          interrupts = <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH 0>;
>          clocks = <&scmi_clk SCMI_HCLK_SECURE_NS>;
>          resets = <&scmi_reset SCMI_SRST_H_TRNG_NS>;
> -        status = "okay";
>        };
>      };

Hi,

is there the possibility we could make dtschema as invoked by `make 
dt_binding_check W=1` (or W=2) add a warning for examples that have disabled 
or explicitly listed status properties when not needed? Or is this something 
better handled in, say, checkpatch.pl?

The question arises because dumb mistakes by me like this should ideally be 
caught before they waste precious maintainer time.

If it's best handled in dtschema, I can look into working on that so you guys 
don't have to do even more work due to me.

Cheers,
Nicolas Frattaroli


