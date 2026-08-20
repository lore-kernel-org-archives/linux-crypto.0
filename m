Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3D3353A8D;
	Thu, 20 Aug 2026 18:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787250801; cv=none; b=sYM6Pahvj28n6f+N93bedEI1RiSHlaPOGOnek0nQLv0mWZ0S7pO3w4kH7+RzNphxm1ZPYBvpKiv2SfGe279FsGPMeao4CzwevL9n1zyT8vno3epFEye1qiLsp/S855HTmavFt3oPdPffLpfnN/RKn4Yh5zI+35sU/x8IF2yQ7zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787250801; c=relaxed/simple;
	bh=UqB/dwHwXnZfh2VWnULlLZDFBTlJBsIxh4q8ia4I734=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WINRKXl+Qsp7hE5IGO7kMzv26pPut4A+gbFQJNUilPTcPKnMp4Jscrd6UkGZbBcT/8AiiT4cHUXH0MbzUzE3ekd/HxoQfpilM31zLSDCDnWXmdYAhcCJdan3QhFjUwZwa3ZDTwew9Lv98PiRsmo5MS4rodZEHAvCVENa45dNau4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G63YqMRk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G63YqMRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498061F00A3D;
	Thu, 20 Aug 2026 18:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787250799;
	bh=F2dRrOK0MCAkDIp4fOzdetA+pyw32S3jmLYP2LSLceA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G63YqMRk567nr4M1yDdJ3W23EYScIQs2KKdRE0rYlK58lhQ5DpyHLayaMyJMmRXHQ
	 UGia96ZnRPcCPP5IEsu4OaonxtfBrQ3T7EugyNSz5PxWYcT1Z7lO6C4gNsiqg5RLAC
	 SXBjYNc3rWFZdZ1zJw7R99CMDAMOX7fMg74SFNMBoAArSY7RqWBNXlDiDT3+usYvv3
	 4UB+LEwtBBtmJep/Rxx98BE6mmThlFsSd59ZwZ6QKpIeGUTcWOSpbHYzOQIqXEurNZ
	 5viu0yUrteUo061aqpEBMemvpYVgCfvHaZM3WeOKhzwxtg50UrO7TYNuWtR9lDtldD
	 lpuHaN2OJc9CQ==
Date: Thu, 20 Aug 2026 19:33:12 +0100
From: Conor Dooley <conor@kernel.org>
To: Ayush Singh <ayush@beagleboard.org>
Cc: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com,
	Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, greybus-dev@lists.linaro.org,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 7/7] dt-bindings: beagle: Add BeagleConnect Freedom
Message-ID: <20260820-anytime-barrel-9a0547910a2c@spud>
References: <20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org>
 <20260820-gb-uart-transport-v1-7-282da14ab7b7@beagleboard.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="j2SR/aNcWPdTYXYY"
Content-Disposition: inline
In-Reply-To: <20260820-gb-uart-transport-v1-7-282da14ab7b7@beagleboard.org>

--j2SR/aNcWPdTYXYY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 20, 2026 at 02:55:49PM +0530, Ayush Singh wrote:
> Add devicetree bindings for the BeagleBoard.org BeagleConnect Freedom,
> a wireless-enabled board based on the TI CC1352P7. The board exposes an
> MCU that can be attached to a host over USB, UART, SPI or I2C, and is
> described as a child node of the corresponding bus.
>=20
> Signed-off-by: Ayush Singh <ayush@beagleboard.org>
> ---
>  .../beagle/beagle,beagleconnect-freedom.yaml       | 30 ++++++++++++++++=
++++++
>  MAINTAINERS                                        |  1 +
>  2 files changed, 31 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/beagle/beagle,beagleconnec=
t-freedom.yaml b/Documentation/devicetree/bindings/beagle/beagle,beagleconn=
ect-freedom.yaml
> new file mode 100644
> index 000000000000..5a246f81261e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/beagle/beagle,beagleconnect-freed=
om.yaml
> @@ -0,0 +1,30 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/beagle/beagle,beagleconnect-freedom.y=
aml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: BeagleBoard.org BeagleConnect Freedom
> +
> +description:
> +  The BeagleBoard.org BeagleConnect Freedom board connected over USB, UA=
RT, SPI or I2C.
> +
> +maintainers:
> +  - Ayush Singh <ayush@beagleboard.org>
> +
> +properties:
> +  compatible:
> +    const: beagle,beagleconnect-freedom

These compatible only devices always look suspect to me, I feel like
these things probably at least have an optional regulator if the power
source for the freedom is provided by the device running linux.

You're also short the required properties for dealing with anything
other than uart, so spi or i2c. (I assume USB doesn't need devicetree to
function).

pw-bot: changes-requested

Thanks,
Conor.

> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    serial {
> +      mcu {
> +        compatible =3D "beagle,beagleconnect-freedom";
> +      };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 037a87b74800..49c6dac72748 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11338,6 +11338,7 @@ GREYBUS UART NODE DRIVERS
>  M:	Ayush Singh <ayush@beagleboard.com>
>  L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
>  S:	Maintained
> +F:	Documentation/devicetree/bindings/beagle/beagle,beagleconnect-freedom=
=2Eyaml
>  F:	drivers/greybus/gb_uart_node.rs
> =20
>  GREYBUS SUBSYSTEM
>=20
> --=20
> 2.55.0
>=20

--j2SR/aNcWPdTYXYY
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaodIaAAKCRB4tDGHoIJi
0o4EAQD3MP/GgYlSZSQT6kBtNqBNMlLUCum5/jK7ItWG6lh4QAD/Yyz859M9yNiX
TGCkKM35r9tRDJyMK2UVSVTiVWQhLg0=
=nz6B
-----END PGP SIGNATURE-----

--j2SR/aNcWPdTYXYY--
