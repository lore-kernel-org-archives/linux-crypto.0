Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E503C352A3
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 12:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 713C62082F
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 12:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBJMKA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 07:10:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:56040 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgBJMKA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 07:10:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 04D39AB87;
        Mon, 10 Feb 2020 12:09:56 +0000 (UTC)
Message-ID: <2bd9936d106948210b7a34c8060600572318600c.camel@suse.de>
Subject: Re: [PATCH] dt-bindings: rng: Convert BCM2835 to DT schema
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     =?ISO-8859-1?Q?N=EDcolas?= "F. R. A. Prado" 
        <nfraprado@protonmail.com>, devicetree@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        linux-arm-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org
Date:   Mon, 10 Feb 2020 13:09:54 +0100
In-Reply-To: <20200207231347.2908737-1-nfraprado@protonmail.com>
References: <20200207231347.2908737-1-nfraprado@protonmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-zCBFPwRk+DMEN1eeas6c"
User-Agent: Evolution 3.34.3 
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--=-zCBFPwRk+DMEN1eeas6c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-02-07 at 23:14 +0000, N=C3=ADcolas F. R. A. Prado wrote:
> Convert BCM2835/6368 Random number generator bindings to DT schema.
>=20
> Signed-off-by: N=C3=ADcolas F. R. A. Prado <nfraprado@protonmail.com>
> ---

Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

Thanks!

> Hi,
> wasn't really clear to me who to add as maintainer for this dt-binding.
> The three names added here as maintainers were based on the get_maintaine=
r
> script and on previous commits on this file.
> Please tell me whether these are the right maintainers for this file or n=
ot.

Looks OK to me. When in doubt I just trust get_maintainer, never failed me =
so
far.

> This patch was tested with:
> make ARCH=3Darm
> DT_SCHEMA_FILES=3DDocumentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> dt_binding_check
> make ARCH=3Darm
> DT_SCHEMA_FILES=3DDocumentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> dtbs_check
>=20
> Thanks,
> N=C3=ADcolas
>=20
>  .../devicetree/bindings/rng/brcm,bcm2835.txt  | 40 ------------
>  .../devicetree/bindings/rng/brcm,bcm2835.yaml | 61 +++++++++++++++++++
>  2 files changed, 61 insertions(+), 40 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm2835.tx=
t
>  create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm2835.ya=
ml
>=20
> diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
> b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
> deleted file mode 100644
> index aaac7975f61c..000000000000
> --- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
> +++ /dev/null
> @@ -1,40 +0,0 @@
> -BCM2835/6368 Random number generator
> -
> -Required properties:
> -
> -- compatible : should be one of
> -	"brcm,bcm2835-rng"
> -	"brcm,bcm-nsp-rng"
> -	"brcm,bcm5301x-rng" or
> -	"brcm,bcm6368-rng"
> -- reg : Specifies base physical address and size of the registers.
> -
> -Optional properties:
> -
> -- clocks : phandle to clock-controller plus clock-specifier pair
> -- clock-names : "ipsec" as a clock name
> -
> -Optional properties:
> -
> -- interrupts: specify the interrupt for the RNG block
> -
> -Example:
> -
> -rng {
> -	compatible =3D "brcm,bcm2835-rng";
> -	reg =3D <0x7e104000 0x10>;
> -	interrupts =3D <2 29>;
> -};
> -
> -rng@18033000 {
> -	compatible =3D "brcm,bcm-nsp-rng";
> -	reg =3D <0x18033000 0x14>;
> -};
> -
> -random: rng@10004180 {
> -	compatible =3D "brcm,bcm6368-rng";
> -	reg =3D <0x10004180 0x14>;
> -
> -	clocks =3D <&periph_clk 18>;
> -	clock-names =3D "ipsec";
> -};
> diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> new file mode 100644
> index 000000000000..b1621031721e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/rng/brcm,bcm2835.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: BCM2835/6368 Random number generator
> +
> +maintainers:
> +  - Stefan Wahren <stefan.wahren@i2se.com>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Herbert Xu <herbert@gondor.apana.org.au>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - brcm,bcm2835-rng
> +      - brcm,bcm-nsp-rng
> +      - brcm,bcm5301x-rng
> +      - brcm,bcm6368-rng
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    description: phandle to clock-controller plus clock-specifier pair
> +    maxItems: 1
> +
> +  clock-names:
> +    const: ipsec
> +
> +  interrupts:
> +    description: specify the interrupt for the RNG block
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +examples:
> +  - |
> +    rng {
> +        compatible =3D "brcm,bcm2835-rng";
> +        reg =3D <0x7e104000 0x10>;
> +        interrupts =3D <2 29>;
> +    };
> +
> +  - |
> +    rng@18033000 {
> +        compatible =3D "brcm,bcm-nsp-rng";
> +        reg =3D <0x18033000 0x14>;
> +    };
> +
> +  - |
> +    random: rng@10004180 {
> +        compatible =3D "brcm,bcm6368-rng";
> +        reg =3D <0x10004180 0x14>;
> +
> +        clocks =3D <&periph_clk 18>;
> +        clock-names =3D "ipsec";
> +    };


--=-zCBFPwRk+DMEN1eeas6c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl5BSBIACgkQlfZmHno8
x/538Af9E4Fj5GNcVUndgLxJI32oW02ih5MIyieex2uP1j3je0U/0mUmRyfYHTzE
VoXDjFd07nq4I+qcNBMCCm/EoZVmhTcYzOwgwkYGpnffvb1y+2xNx0FN0yYJFMAF
aZKfwp/s5DFeNxJyowh/ejeHQyRZh5lbUrlg4Dhu5f2wJ9pnUzbkQn4qMGmJ5tcJ
l+HYDtp5LRNdLwgjaI8kPeTHU403RO20ASLGW8XBL12/Rc2MvOj18OcURS+SlB0J
/eyvAoeVkeB9RBAzpg0LpsC8kF506li/telVa1zKbyFKycY0JoQZP0VvfNUVSjVX
0bfhLaOaOSn8PWfr8Jwfkko+ZmhI4Q==
=+aAd
-----END PGP SIGNATURE-----

--=-zCBFPwRk+DMEN1eeas6c--

