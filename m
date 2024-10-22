Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1A64438B;
	Tue, 22 Oct 2024 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729616775; cv=none; b=lScmOqwXwmCat0B7lRJKT+WwMNUPF++E3ezHWMN5RYhXmWZb7JionBBKLEVIYZNrcKlJADAKIfulu0IPvBdNLo/AyDhF/S8Xo0zKgZwzDUQPxStqbJUd09iqLtDvJMVFFCgXms6XVBgviIetqvjJHtKZPU+0IW6ZziU41vgo9+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729616775; c=relaxed/simple;
	bh=JSq1PbKICLPD3uEw/HtbkFlY48LXhzmHMpUzmbOu/KA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBsu7AazZu6oRp6aso4UL822t+cloPS62THv+pXxkE9aj2AcLArdGNrt0K73NfCQt7sWwKxvIDAVGlmbb7k/m1a6ZqcjXmDYGVOueBoWjfOf04K1bEJ4pTFZtaMCDpBOi7Booht90ZUOB/w4LGcan+q508K3Fom++hVDoP2HxsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e18z5qEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e18z5qEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C67C4CEC3;
	Tue, 22 Oct 2024 17:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729616774;
	bh=JSq1PbKICLPD3uEw/HtbkFlY48LXhzmHMpUzmbOu/KA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e18z5qEYerXbFSihhum4dQ7H0airCV1cW9LE38K9rLigMXBv12l088+WqureaXLyh
	 aYqXSxqQ2+u1pfol71i/9g6o1XqJVsyhwao5E74YAnohCRoeaPaCaqSGryVvV05YWm
	 BF+1qnJfY3E4qr0lY35uDwzQ9vRJO+Xsn/RBhqwjZXYxdEOvlNSlEe1MS4GbS6O+1K
	 I1+a0ENIx8/BkE6D5h2DjkXfXrFlKUYeml0TOg6SN4eVmJZWlMmeJNkqlWwuGyK6jG
	 T9edol+8M23G48/Qq2a+yP+RisXYzUPoCGIa6Mci5zV3bfhetFFuWmx+7JuKMFGOpH
	 ZX/WRaKpgrWLw==
Date: Tue, 22 Oct 2024 18:06:08 +0100
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
	Justin Stitt <justinstitt@google.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [RFC PATCH v3 2/3] dt-bindings: crypto: Add Inside Secure
 SafeXcel EIP-93 crypto engine
Message-ID: <20241022-most-politely-e85f571c05a3@spud>
References: <20241021145642.16368-1-ansuelsmth@gmail.com>
 <20241021145642.16368-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tBfP0HJf7nOgQAVw"
Content-Disposition: inline
In-Reply-To: <20241021145642.16368-2-ansuelsmth@gmail.com>


--tBfP0HJf7nOgQAVw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 04:56:38PM +0200, Christian Marangi wrote:
> Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
>=20
> The IP is present on Airoha SoC and on various Mediatek devices and
> other SoC under different names like mtk-eip93 or PKTE.
>=20
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
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

This implies that you should have a non-trivial set of fallbacks, with
the "i" model as the base for that. eg:

"ie", "i"
"is", "i"
"iw", "i"
"ies", "ie, "is", "i" (I dunno which would be a better order here)

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

I don't really get what's going on here. Why is the first compatible the
generic one? That seems suspect to me, as I doubt the crypto block on a
particular SoC varies? I'd expect to see some soc-specific compatibles
with a fallback to the inside-secure IP version that it integrates.

Cheers,
Conor.

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

--tBfP0HJf7nOgQAVw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZxfbgAAKCRB4tDGHoIJi
0gWRAP9jiY6x9l9Ufpjhp/094FdBrAiNEO4VxSjzCIBxqQWXkAD/QLfnL6ZVzcbi
dxCnGvhmIM1SsJP7gycqN6LPJsHwfQg=
=p17h
-----END PGP SIGNATURE-----

--tBfP0HJf7nOgQAVw--
