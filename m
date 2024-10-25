Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9082170854;
	Fri, 25 Oct 2024 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729874686; cv=none; b=qbTP6NhlxO3gnDwJt1aGFIDrQdCSGdh8zZeAYuwU9fYLSODptOpaRGqqeKSrU2HCOYbGsbKyMwJKQmHJaq+T28Cnv+8DySbVHKQR2NXtpuiITc8k8sVGhGvV3lNK6Dsc0VFYvnT28c37fDEI/5617So5SCRQmNTvfiAncYjp+cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729874686; c=relaxed/simple;
	bh=dm33zfR58Grs1+44I7WoAOjuTC5WjP5JD5nKra0ImTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g28SEwQeiZuT5lDEPbSWQ2GM6W7yMcUHduuCX/bPPbEvtq0DanEjOd+Sg3wfc55c1eRRNekzjMNF/mYtgtotKphBAheOctwN5Kwemhf60em9UM9R8emKY/tLe4dB2f7XuDfmP6IIYIoY7zj+jfq+dcLb/I0xLhxTMD0s58CMdk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hswP2hz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hswP2hz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE18C4CEC3;
	Fri, 25 Oct 2024 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729874685;
	bh=dm33zfR58Grs1+44I7WoAOjuTC5WjP5JD5nKra0ImTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hswP2hz3gcvFBqPW2ufUXWTcuBYuRsf0Rufswq+PTDT5102qv6Lf5pV/fGycTf2kV
	 7+CE6GtPcMzlKKvg5aln5gtp4IFryAaxDf4Y9T9/zfa9Iz8Wf86WmtPHkhj+PrkXWo
	 yRhLEjU1ahlRgd4D8cBDk6mXHnVbrv6lvuD9wCQ0p6bs3S7oMXrCSCVNVeCEc99ZMZ
	 9mYIQ+FaNRwkQEfFEu6YIUq5M/1umKginTtqd46n9XLpJIjg5WeLK7//HBhUh08Sdt
	 hX2ne6DcsZfhpd9OmA5f4xDXI/P9egVNlFbs8yxlEPLJvBGHjMQK25hkASimts2i+F
	 4GQ2+LFjUAEHw==
Date: Fri, 25 Oct 2024 17:44:39 +0100
From: Conor Dooley <conor@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com
Subject: Re: [PATCH v4 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel
 EIP-93 crypto engine
Message-ID: <20241025-marmalade-constant-1c733ef5f3e8@spud>
References: <20241025094734.1614-1-ansuelsmth@gmail.com>
 <20241025094734.1614-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="QPZZZgLU1JrXIOAQ"
Content-Disposition: inline
In-Reply-To: <20241025094734.1614-2-ansuelsmth@gmail.com>


--QPZZZgLU1JrXIOAQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 25, 2024 at 11:47:23AM +0200, Christian Marangi wrote:
> Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
>=20
> The IP is present on Airoha SoC and on various Mediatek devices and
> other SoC under different names like mtk-eip93 or PKTE.
>=20
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> Changes v4:
> - Out of RFC

I left comments on v3, that I do not see addressed here.

> Changes v3:
> - Add SoC compatible with generic one
> Changes v2:
> - Change to better compatible
> - Add description for EIP93 models
>=20
>  .../crypto/inside-secure,safexcel-eip93.yaml  | 63 +++++++++++++++++++
>  1 file changed, 63 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secur=
e,safexcel-eip93.yaml
>=20
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safex=
cel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,saf=
excel-eip93.yaml
> new file mode 100644
> index 000000000000..13341710ee31
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip=
93.yaml
> @@ -0,0 +1,63 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel-eip93.y=
aml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Inside Secure SafeXcel EIP-93 cryptographic engine
> +
> +maintainers:
> +  - Christian Marangi <ansuelsmth@gmail.com>
> +
> +description: |
> +  The Inside Secure SafeXcel EIP-93 is a cryptographic engine IP block
> +  integrated in varios devices with very different and generic name from
> +  PKTE to simply vendor+EIP93. The real IP under the hood is actually
> +  developed by Inside Secure and given to license to vendors.
> +
> +  The IP block is sold with different model based on what feature are
> +  needed and are identified with the final letter. Each letter correspond
> +  to a specific set of feature and multiple letter reflect the sum of the
> +  feature set.
> +
> +  EIP-93 models:
> +    - EIP-93i: (basic) DES/Triple DES, AES, PRNG, IPsec ESP, SRTP, SHA1
> +    - EIP-93ie: i + SHA224/256, AES-192/256
> +    - EIP-93is: i + SSL/DTLS/DTLS, MD5, ARC4
> +    - EIP-93ies: i + e + s
> +    - EIP-93iw: i + AES-XCB-MAC, AES-CCM
> +
> +properties:
> +  compatible:
> +    items:
> +      - const: airoha,crypto-eip93
> +      - enum:
> +          - inside-secure,safexcel-eip93i
> +          - inside-secure,safexcel-eip93ie
> +          - inside-secure,safexcel-eip93is
> +          - inside-secure,safexcel-eip93ies
> +          - inside-secure,safexcel-eip93iw
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    crypto@1e004000 {
> +      compatible =3D "airoha,crypto-eip93", "inside-secure,safexcel-eip9=
3ies";
> +      reg =3D <0x1fb70000 0x1000>;
> +
> +      interrupts =3D <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
> +    };
> --=20
> 2.45.2
>=20

--QPZZZgLU1JrXIOAQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZxvK9wAKCRB4tDGHoIJi
0mEJAQCgD/LVRzqypI/lSQC01t+ffVDixoJVQ2D32YNL/OTG7gD+NbRCXvRr+A28
6r21JafKUgARYLDPKd0eohYPLM10Qg4=
=TYuD
-----END PGP SIGNATURE-----

--QPZZZgLU1JrXIOAQ--
