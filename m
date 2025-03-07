Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D27202C42;
	Fri,  7 Mar 2025 09:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.11.138.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741339779; cv=none; b=JLx/DFgIHg0zowm4OPf421TLYsKU107op30MjFKHqixTt8aAOYSC7z9VDrKgVtGQwXaXn1+MtQObb0UhI/mIjVET0DminxmOmXZ14BB4fDKgVuDQC/kM1fJiiAJRihQj/14h1UVGvxWri7R8OCrx+dlwEnrMczVFTkJ80w9+/Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741339779; c=relaxed/simple;
	bh=G1lCccy/OszgdLNgqruHVs1sxATd6Zr72E+2mhbDyfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4qkzqzKQ2EOdfkaHE97HgsTTs/GpbvCAW0Uj2akN7n7wVb2Vgwjak1LSrrcJ2pr8YQ3uFfp8FWKMutozo+mNdzq+fJLitb9FRNL5L2qNmnfeE89jdK5QVMt9nSmMkTQQv6fIWLGPuTvW1ABTJl/PERxyU9uSqdXcwjFgum0zF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de; spf=pass smtp.mailfrom=sntech.de; dkim=pass (2048-bit key) header.d=sntech.de header.i=@sntech.de header.b=MfBYfJcD; arc=none smtp.client-ip=185.11.138.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sntech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sntech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sntech.de header.i=@sntech.de header.b="MfBYfJcD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sntech.de;
	s=gloria202408; h=Content-Type:Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=D2F6Zdb1CkSBitSIoiyY8ywRdELphgvUiwPTl0y2m+g=; b=MfBYfJcDOUJ7bmp4dok8wEmuaJ
	s+yyx3IlEJGd4KThHeWy3pAxTHVErNEA+3t9rrrGyHhIC1iQ+ZefIqjYk7FknH3oKX1GjF2gY3WLT
	+lUHpZPwe7d2cLz5xeEN6MiYDqzmLU124SaDix8I1yDz9h/nJOWkU25hJB96NDIOe/KL7D9WeUZyy
	pKWGJnS728oPVRpb60e1WJAaDeNsSG8y0bj9ocXbmZSCYH+bmYT9X9qsbYhB7GeJxVRUT8u1XNv1+
	RFFGO32ilew0RNMPDCaMkVYG9KjTO/rZTL7gkmRUNjHbh66yygeEemgVc3gb0CuLZRwoc0wz+6PkS
	NKUMyvLw==;
Received: from i53875a38.versanet.de ([83.135.90.56] helo=diego.localnet)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1tqU0n-0002G6-II; Fri, 07 Mar 2025 10:28:57 +0100
From: Heiko =?UTF-8?B?U3TDvGJuZXI=?= <heiko@sntech.de>
To: Daniel Golle <daniel@makrotopia.org>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
 Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject:
 Re: [PATCH] dt-bindings: rng: rockchip,rk3588-rng.: Drop unnecessary status
 from example
Date: Fri, 07 Mar 2025 10:28:55 +0100
Message-ID: <5865714.DvuYhMxLoT@diego>
In-Reply-To: <20250307081406.35242-1-krzysztof.kozlowski@linaro.org>
References: <20250307081406.35242-1-krzysztof.kozlowski@linaro.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 7. M=C3=A4rz 2025, 09:14:06 MEZ schrieb Krzysztof Kozlowski:
> Device nodes are enabled by default, so no need for 'status =3D "okay"' in
> the DTS example.
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Heiko Stuebner <heiko@sntech.de>

> ---
>  Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.ya=
ml b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> index 757967212f55..ca71b400bcae 100644
> --- a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> +++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
> @@ -53,7 +53,6 @@ examples:
>          interrupts =3D <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH 0>;
>          clocks =3D <&scmi_clk SCMI_HCLK_SECURE_NS>;
>          resets =3D <&scmi_reset SCMI_SRST_H_TRNG_NS>;
> -        status =3D "okay";
>        };
>      };
> =20
>=20




