Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05C43BE141
	for <linux-crypto@vger.kernel.org>; Mon, 17 Aug 2026 08:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786954516; cv=none; b=Q3RyO81Js8QbXBiMctiww7CpJL2OJIYf2wLXnohOeGc1N5y0EZazftJMlJ5rpzXD8s0OLRWAn6h2fnl9s/5UzwLS0oBn48yxYJsLn4/NVzqC3mwjrcxCaxiqVTQUulhtp4Ccqu1fDipCkd5CT2Q7QtcTf5r/tY80aR2fSQV0srM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786954516; c=relaxed/simple;
	bh=C0O0F0T5Khr4i9evrKR9qQ1b3ukNc51FfJbV+j3oy3Q=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=sgfCr+PpF50enoXxuDmkKpILp1TfOXvhddmfMXYl9qeacyfoejV7tMsLtPROu4X5w/qk7vFKdVeB9EqvxBTu8/2l2Y3sztD81YLeqjvk4Jlx5NNPWDtfNQ61eoWGhS1cgYpGi0XCb/xxOgrcNxct1lu9pzMBJnYzHYBzz9Nv0rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com; spf=pass smtp.mailfrom=cknow-tech.com; dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b=hhVhQJO6; arc=none smtp.client-ip=91.218.175.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow-tech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow-tech.com header.i=@cknow-tech.com header.b="hhVhQJO6"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=C0O0F0T5Khr4i9evrKR9qQ1b3ukNc51FfJbV+j3oy3Q=;
 c=simple/simple; d=cknow-tech.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786954510; v=1; x=1787559310;
 b=hhVhQJO6LkgnZbGnPrn8ZOEQmZ7vWhS+ZVrfUmUxrqh+qv0Lrw3p1WOmQTwfA3WY2wTf5SBI
 0tDB9rb2tHUdFs9DxdaIjJJiMseOo/TUH43zMy4zDmw1i8uKCuhHLYknSM1JWHe94JQi4ZJRJOl
 y7DSQa1EYuOWLuLa5i3Yz4UuPqb4mxRmshbPhrWy2sBSremdXLazCLaAGqrt1wul74Ls8UgjAtQ
 FJ4oOXzu1Jy8RBfSiUyvZ2ZovLXnBlMoKdC6erXOqhkS5UNWGDOJMEIg1TMH8bEd6GJ/N3O0lsO
 95LPnVzzotiEKHIhkkGTkzVOYwfef25S4fEIDjh5vtdNg==
X-Envelope-To: linux-crypto@vger.kernel.org
Received: from localhost (92.254.112.55)
	by smtp.migadu.com with ESMTPS id 54f7be6b0ec37d4f;
	Mon, 17 Aug 2026 08:15:00 +0000
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 17 Aug 2026 10:14:58 +0200
Message-Id: <DKR2I3X521F8.J6H7KW07GDD0@cknow-tech.com>
Subject: Re: [PATCH v3 1/4] dt-bindings: crypto: rockchip: Add RK356x/RK3588
 crypto engine binding
From: "Diederik de Haas" <diederik@cknow-tech.com>
To: "Dawid Olesinski" <dawidro@gmail.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>,
 "Rob Herring" <robh@kernel.org>, "Krzysztof Kozlowski"
 <krzk+dt@kernel.org>, "Heiko Stuebner" <heiko@sntech.de>
Cc: "Diederik de Haas" <diederik@cknow-tech.com>, "Eric Biggers"
 <ebiggers@kernel.org>, "Sebastian Reichel"
 <sebastian.reichel@collabora.com>, "Philipp Zabel"
 <p.zabel@pengutronix.de>, "Conor Dooley" <conor+dt@kernel.org>, "Corentin
 Labbe" <clabbe@baylibre.com>, <linux-crypto@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-rockchip@lists.infradead.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <20260816194112.552100-1-dawidro@gmail.com>
 <20260816194112.552100-2-dawidro@gmail.com>
In-Reply-To: <20260816194112.552100-2-dawidro@gmail.com>

Hi Dawid,

On Sun Aug 16, 2026 at 9:39 PM CEST, Dawid Olesinski wrote:
> Add a YAML device tree binding for the Rockchip second-generation (V2)
> cryptographic hardware accelerator present on the RK3568 and RK3588 SoCs.
>
> The IP block exposes AES-ECB, AES-CBC, AES-XTS block ciphers, SHA-1,
> SHA-224, SHA-256, SHA-384, SHA-512, MD5, and SM3 hash algorithms, each
> with a hardware DMA engine controlled via linked-list descriptors.
>
> The binding covers two compatible strings:
>
>   - rockchip,rk3568-crypto: clocks and resets are driven directly by the
>     non-secure CRU (accessible to Linux at EL1).
>   - rockchip,rk3588-crypto: clocks and resets live in SECURECRU, a
>     register bank sandboxed to TrustZone. Linux must request them through
>     the ARM SCMI firmware interface (scmi_clk / scmi_reset), as direct
>     MMIO access to SECURECRU from EL1 triggers a bus fault.
>
> Co-developed-by: Corentin Labbe <clabbe@baylibre.com>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> Signed-off-by: Dawid Olesinski <dawidro@gmail.com>
> Tested-by: Diederik de Haas <diederik@cknow-tech.com>  # Quartz64-B,
> NanoPi R5S, NanoPC-T6 LTS

AFAIK these lines should not have a line break, ie must be on one line.

Cheers,
  Diederik

> ---
>  .../crypto/rockchip,rk3588-crypto.yaml        | 83 +++++++++++++++++++
>  MAINTAINERS                                   |  2 +
>  2 files changed, 85 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3=
588-crypto.yaml
>
> diff --git a/Documentation/devicetree/bindings/crypto/rockchip,rk3588-cry=
pto.yaml b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.=
yaml
> new file mode 100644
> index 000000000000..32d241c19453
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yam=
l
> @@ -0,0 +1,83 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/rockchip,rk3588-crypto.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Rockchip cryptographic offloader
> +
> +maintainers:
> +  - Heiko Stuebner <heiko@sntech.de>
> +  - Corentin Labbe <clabbe@baylibre.com>
> +  - Dawid Olesinski <dawidro@gmail.com>
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: rockchip,rk3568-crypto
> +      - items:
> +          - enum:
> +              - rockchip,rk3588-crypto
> +          - const: rockchip,rk3568-crypto
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  clocks:
> +    items:
> +      - description: Core clock for the crypto IP internal logic
> +      - description: AXI interconnect clock interface
> +      - description: AHB interface clock
> +
> +  clock-names:
> +    items:
> +      - const: core
> +      - const: aclk
> +      - const: hclk
> +
> +  resets:
> +    minItems: 1
> +    maxItems: 3
> +
> +  reset-names:
> +    minItems: 1
> +    items:
> +      - const: core
> +      - const: aclk
> +      - const: hclk
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +  - resets
> +  - reset-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/clock/rockchip,rk3588-cru.h>
> +    #include <dt-bindings/reset/rockchip,rk3588-cru.h>
> +
> +    bus {
> +      #address-cells =3D <2>;
> +      #size-cells =3D <2>;
> +
> +      crypto@fe370000 {
> +        compatible =3D "rockchip,rk3588-crypto", "rockchip,rk3568-crypto=
";
> +        reg =3D <0x0 0xfe370000 0x0 0x2000>;
> +        interrupts =3D <GIC_SPI 209 IRQ_TYPE_LEVEL_HIGH 0>;
> +        clocks =3D <&scmi_clk SCMI_CRYPTO_CORE>, <&scmi_clk SCMI_ACLK_SE=
CURE_NS>,
> +                 <&scmi_clk SCMI_HCLK_SECURE_NS>;
> +        clock-names =3D "core", "aclk", "hclk";
> +        resets =3D <&scmi_reset SCMI_SRST_CRYPTO_CORE>;
> +        reset-names =3D "core";
> +      };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c8d4b913f26c..50b77a750db3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23131,9 +23131,11 @@ F:	drivers/media/platform/rockchip/rkcif/
> =20
>  ROCKCHIP CRYPTO DRIVERS
>  M:	Corentin Labbe <clabbe@baylibre.com>
> +M:	Dawid Olesinski <dawidro@gmail.com>
>  L:	linux-crypto@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/crypto/rockchip,rk3288-crypto.yaml
> +F:	Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
>  F:	drivers/crypto/rockchip/
> =20
>  ROCKCHIP I2S TDM DRIVER


