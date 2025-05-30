Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE693201100;
	Fri, 30 May 2025 16:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748621511; cv=none; b=HxJF8VdyNoXmF0S0kfmkfDEN1NVEGt5DtYO1czthVR1ihTAuARvEqAGfjFVh78Ml7zcshjJNGjJtwK/oyazjs9Pz5FO4v48FNahmPlZsddzIN8PbP7z87ZAE69tW5NZN2uYiUjzqwzb/yvgsnJ4CvtGRI+Yo4NkAFLvAiC9i1no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748621511; c=relaxed/simple;
	bh=wTQk6PCp/lFFKGrig6/uLoqINdQiBMib30kvAzZasYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BU8oKPsPcAKFqOAZvo0nnAOB6k+UoggP3+5oe9IzlP0yM2e+WQ+m01K0/CFeZUbrcOb+mx+TQIWLK/su/v+acYpoLaBh0Lxq9ObaJPxqk3mY0ZisTFEe5dlvpJx0iLXjVPOJiAppKaUrScWuMVlQiTc9M0HSIFID7khFoC1DGPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uv+vLdpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uv+vLdpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4570CC4CEE9;
	Fri, 30 May 2025 16:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748621511;
	bh=wTQk6PCp/lFFKGrig6/uLoqINdQiBMib30kvAzZasYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uv+vLdpkySLW3HE3WdXeTQ7ATCtjuH6p8unU0fNiyR5OqNTLXySrn45eSAfY3hjQS
	 eCCJytd+GZadvja28z60ZKOrDNucABl1Xi1bC9y4LFKIcLZRvCqptVCKIpa5KZj6Ma
	 HqF54hlf4ST6LxJ6njDal4HYtRHr+oZy4eW7hYePitcPABE2JBCUBWZ0zb0UX5Hwiv
	 fImxIPboA7qBS9IyUix0weLO6B78CLk/7H910GFAkT5HMguRDYxYoReopdJOXTKZKN
	 rEluHo/3rxzsdRFuVqa6u675+hI+gudMinKkf1DhJ9bxb3pJVPM/PDU2sYghU0WJRW
	 YZxWLUuQMcCjQ==
Date: Fri, 30 May 2025 17:11:47 +0100
From: Conor Dooley <conor@kernel.org>
To: Harsh Jain <h.jain@amd.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	mounika.botcha@amd.com, sarat.chand.savitala@amd.com,
	mohan.dhanawade@amd.com, michal.simek@amd.com
Subject: Re: [PATCH 1/3] dt-bindings: crypto: Add node for True Random Number
 Generator
Message-ID: <20250530-gab-vocally-110247b8f60c@spud>
References: <20250529113116.669667-1-h.jain@amd.com>
 <20250529113116.669667-2-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rnbGi+IB0VKW4Vv3"
Content-Disposition: inline
In-Reply-To: <20250529113116.669667-2-h.jain@amd.com>


--rnbGi+IB0VKW4Vv3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2025 at 05:01:14PM +0530, Harsh Jain wrote:
> Add TRNG node compatible string and reg properities.
>=20
> Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
> Signed-off-by: Harsh Jain <h.jain@amd.com>

The signoff chain here looks wrong, since there's no From: field in the
patch, meaning that you are the author and submitter, but the order of
signoffs suggests that Mounika is the author. If you are in fact the
author and submitter, what was their role?

> ---
>  .../bindings/crypto/xlnx,versal-trng.yaml     | 36 +++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-=
trng.yaml
>=20
> diff --git a/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.ya=
ml b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
> new file mode 100644
> index 000000000000..547ed91aa873
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
> @@ -0,0 +1,36 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/crypto/xlnx,versal-trng.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Xilinx Versal True Random Number Generator Hardware Accelerator
> +
> +maintainers:
> +  - Harsh Jain <h.jain@amd.com>
> +  - Mounika Botcha <mounika.botcha@amd.com>
> +
> +description:
> +  The Versal True Random Number Generator cryptographic accelerator
> +  is used to generate the random number.

I would be surprised if the random number generator did not generate
random numbers. I think you can probably just drop the description
entirely in the future

> +
> +properties:
> +  compatible:
> +    const: xlnx,versal-trng
> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    trng@f1230000 {

"rng" I think is the standard node name here, since you need to respin
to fix the signoff chain.

> +        compatible =3D "xlnx,versal-trng";
> +        reg =3D <0xf1230000 0x1000>;
> +    };
> +...
> +
> --=20
> 2.34.1
>=20
>=20

--rnbGi+IB0VKW4Vv3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaDnYwwAKCRB4tDGHoIJi
0qw+AQCgQ0LZa9b6N09ngLAbztgXvj3A6gqZby43kH6gVRJjWQEAg2RePIl9eUus
YDao47stg69hvfxUVfvQ19C3FVnbKwI=
=Pldf
-----END PGP SIGNATURE-----

--rnbGi+IB0VKW4Vv3--
