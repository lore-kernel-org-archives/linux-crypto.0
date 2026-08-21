Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8126936D9EB;
	Fri, 21 Aug 2026 17:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787332868; cv=none; b=DcgH/8P86a9zXPMsKHPr4SA9/yjStetvjF6kwJZdePyoI55l1ANQGgpE/iMgcuSmLi0U1C9zgGaHpV0gsiYj46O7kAN6plMRriMCQsP5OqODrhBq9zOVDNQlt9nJfmEI8VJ3WER5pCjyoLClHaY2ah1LiRYCHd4vac1DpC7uzk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787332868; c=relaxed/simple;
	bh=YaNpjgrpuouOPA/UV+QOTlHjV+5P6sII21PqrushHRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A7NBaoBIbuAYmdPYZCN7lE0ySd0vviMW2nU55n0TcRcy3DGJHDxLCeBQSao3DR3W/7H78weT9z/KfVPmsRodpzPrziHt1FGMZpn+QY5EtsqBky4NRnpz1D+ZWiBAy5oYY8nwuk36WXR07L4LMnp94O/x88/DRXMlzBBTju8s83o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c3k6Yuec; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3k6Yuec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71951F000E9;
	Fri, 21 Aug 2026 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787332866;
	bh=k8yK5B9qpvP8r3TX2oQi9M7VMrLKTb2kWkuu0dF51TQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c3k6Yuec371NWtcRzkqBB4dL9GrTTA7Pr3AGCHr2Vim0ndozcMljYJ6P+5DMs4ER0
	 DygunbUDh4id6Jsrg12Mjw5YHQ4B5obSwt5SsS7b2BsFT4wZyM6c8r2Vup4zVkYf+0
	 cHD+7Fo0O5x/+wNRAZ6jdAjXcXYeXJo+NNp00lwp9+Mj+iiyNIPTPq54BsMBCtvGHk
	 hkBosHkF10yD3e1ApCgpNE5DNqvVDSvElS+ORbWQwbbwUd8aB+XjfUyzBPKsJQJdQH
	 oHHfgKc3TgSElEH2qTWB5+7m5HozXt5ndGHzR5SG59mZlJJUAllRxQ2eNffYyibzRu
	 Ww+82HrXMjMTg==
Date: Fri, 21 Aug 2026 18:20:58 +0100
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
Message-ID: <20260821-zesty-penalty-a9a485150545@spud>
References: <20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org>
 <20260820-gb-uart-transport-v1-7-282da14ab7b7@beagleboard.org>
 <20260820-anytime-barrel-9a0547910a2c@spud>
 <f93c5f18-580c-46ce-971f-8e2073485b4b@beagleboard.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="a75x6krVk/Unrjav"
Content-Disposition: inline
In-Reply-To: <f93c5f18-580c-46ce-971f-8e2073485b4b@beagleboard.org>

--a75x6krVk/Unrjav
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2026 at 11:01:16AM +0530, Ayush Singh wrote:
> On 8/21/26 12:03 AM, Conor Dooley wrote:
>=20
> > On Thu, Aug 20, 2026 at 02:55:49PM +0530, Ayush Singh wrote:
> > > Add devicetree bindings for the BeagleBoard.org BeagleConnect Freedom,
> > > a wireless-enabled board based on the TI CC1352P7. The board exposes =
an
> > > MCU that can be attached to a host over USB, UART, SPI or I2C, and is
> > > described as a child node of the corresponding bus.
> > >=20
> > > Signed-off-by: Ayush Singh <ayush@beagleboard.org>
> > > ---
> > >   .../beagle/beagle,beagleconnect-freedom.yaml       | 30 +++++++++++=
+++++++++++
> > >   MAINTAINERS                                        |  1 +
> > >   2 files changed, 31 insertions(+)
> > >=20
> > > diff --git a/Documentation/devicetree/bindings/beagle/beagle,beagleco=
nnect-freedom.yaml b/Documentation/devicetree/bindings/beagle/beagle,beagle=
connect-freedom.yaml
> > > new file mode 100644
> > > index 000000000000..5a246f81261e
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/beagle/beagle,beagleconnect-f=
reedom.yaml
> > > @@ -0,0 +1,30 @@
> > > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/beagle/beagle,beagleconnect-freed=
om.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: BeagleBoard.org BeagleConnect Freedom
> > > +
> > > +description:
> > > +  The BeagleBoard.org BeagleConnect Freedom board connected over USB=
, UART, SPI or I2C.
> > > +
> > > +maintainers:
> > > +  - Ayush Singh <ayush@beagleboard.org>
> > > +
> > > +properties:
> > > +  compatible:
> > > +    const: beagle,beagleconnect-freedom
> > These compatible only devices always look suspect to me, I feel like
> > these things probably at least have an optional regulator if the power
> > source for the freedom is provided by the device running linux.
>=20
> Well, the power source can be provided, yes, so will add that. In my
> testing, I was powering the BeagleConnect Freedom [0] via USB to view log=
s.
>=20
>=20
> > You're also short the required properties for dealing with anything
> > other than uart, so spi or i2c. (I assume USB doesn't need devicetree to
> > function).
>=20
> I have only tested with UART at the moment. Is just having
> `additional_properties: true` sufficient? I think the reg property is the

No, only bindings intended to be included by others should have that.
You should ref spi-peripheral-props if anything is relevant and have
"{additional,unevaluated}Properties: false" depending on whether or not
anything other than reg is.

> only thing SPI and I2C will require setting here.

Ye, then add a "reg: maxItems: 1" for those cases then.

pw-bot: changes-requested

Cheers,
Conor.

>=20
>=20
> > pw-bot: changes-requested
> >=20
> > Thanks,
> > Conor.
>=20
>=20
> Best Regards,
>=20
> Ayush Singh
>=20
>=20
> [0]: https://www.beagleboard.org/boards/beagleconnect-freedom
>=20

--a75x6krVk/Unrjav
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaoiI+gAKCRB4tDGHoIJi
0nrIAQDkVc0ubhHL6rF29gNzJsw62O50YydlTCW6qD1J46ffUAEAgwWA8wEm8jw9
fDvkjHAubs365zbZ3rQWbMMVTfa+0QY=
=oN7i
-----END PGP SIGNATURE-----

--a75x6krVk/Unrjav--
