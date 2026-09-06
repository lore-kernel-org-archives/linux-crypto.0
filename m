Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD481382F1E
	for <linux-crypto@vger.kernel.org>; Sun,  6 Sep 2026 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788722385; cv=none; b=eCOKX9qBCd7cjc6Y9S4DRVcFxKpYtEty/1oNKdrqRqX/UvoEJrBfILqoVpmkv6WafMsp41yQOQ6Z02ZTGADtm/nAOT58QLOGELpvX65HSxJlq7ECnkWaK0vuGrbiInniTA9sEFeAtLrqL6waNshs7ke3Qo4b2G/BSK+2BWjKbJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788722385; c=relaxed/simple;
	bh=MEfaSMV0i/gNJza23cAbjSRMzpmpe/PWMchm4BFzQk0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fbdOAXLGeSPPuhLZnM4HZx2OetgtTBX7puMo3Hm3f/8tghviw/iHo4PZOcZ34F2EjfGu5cUnBwE8eNs2UmRWFFjzjsFmIWUUd244jHEMdxsbPNhoXqhOJ7hcmSigXPf0tWsho6x+AcUQ/MbqRY9xTge6xxszpjDsos4hFzgv3W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=JuIzcFz0; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="JuIzcFz0"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id 95BF324002A
	for <linux-crypto@vger.kernel.org>; Sun,  6 Sep 2026 21:19:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1788722380;
	bh=0W2/F4zK+3FKQgT/RsjvHOtn5P9Ex9RaU3VQvAg7BCM=;
	h=Message-ID:Subject:From:To:Cc:Date:Autocrypt:Content-Type:
	 MIME-Version:OpenPGP:From;
	b=JuIzcFz0n6ZhoqGsiZJQUoVaLmeFbaBx33p85cyqIVGfgLn7FfkGKDtYr0mqsd2nU
	 sAzsgP2xER1n/Gniwx2E596PAR3MYEiH77Byte+5cITyXKQ66Ks3S4EYaP7wb2S5cP
	 uMwoEW0uxUppXC6o2d26ygD/jD+zEGbJUMEs9dbPOHfTzhsYkap9Nuavoi+kWDeQCu
	 ZDeHqCuaSWgctmzS/wlTuZKeUXtvllHU8FkBdU8HoQddULxkWvjRy1/cyvTAJE0JiI
	 2MEr0PWbtcO9LTnAItHhkPj2L44yD8eYEefRb5+JLX8f3G2RpNSpAIikqXJwvym7GY
	 cfDVmbnWVm5Ww==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4hdKlD4YRfz6tsg;
	Sun,  6 Sep 2026 21:19:36 +0200 (CEST)
Message-ID: <ea8077900e7cfbe338fbe46119cb1f61cf3752e2.camel@posteo.de>
Subject: Re: [PATCH v2 7/7] greybus: Add Rust UART node driver
From: Markus Probst <markus.probst@posteo.de>
To: Gary Guo <gary@garyguo.net>, Ayush Singh <ayush@beagleboard.org>, Jason
 Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com, Johan Hovold
 <johan@kernel.org>,  Alex Elder <elder@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Miguel Ojeda	 <ojeda@kernel.org>, Boqun Feng
 <boqun@kernel.org>, =?ISO-8859-1?Q?Bj=F6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Andreas
 Hindborg	 <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross	 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Daniel Almeida	 <daniel.almeida@collabora.com>, Tamir Duberstein
 <tamird@kernel.org>,  Alexandre Courbot <acourbot@nvidia.com>, Onur
 =?ISO-8859-1?Q?=D6zkan?= <work@onurozkan.dev>, Eric Biggers	
 <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Ayush Singh	
 <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski
	 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Lorenzo Stoakes	
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"	
 <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org
Date: Sun, 06 Sep 2026 19:19:39 +0000
In-Reply-To: <DL8GRCH5DTRQ.KJE7HHIOKW8A@garyguo.net>
References: <20260827-gb-uart-transport-v2-0-a03bb1f5fbd1@beagleboard.org>
	 <20260827-gb-uart-transport-v2-7-a03bb1f5fbd1@beagleboard.org>
	 <08c89a754cd7cd43b0cc6d5f1e84cd6df7253c68.camel@posteo.de>
	 <40f71ade-9266-4373-b584-634d91bdf670@beagleboard.org>
	 <2dd208b5371196804b1adc3fd00e5265dc0e814c.camel@posteo.de>
	 <DL8GRCH5DTRQ.KJE7HHIOKW8A@garyguo.net>
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
 keydata=mQINBGiDvXgBEADAXUceKafpl46S35UmDh2wRvvx+UfZbcTjeQOlSwKP7YVJ4JOZrVs93
 qReNLkOWguIqPBxR9blQ4nyYrqSCV+MMw/3ifyXIm6Pw2YRUDg+WTEOjTixRCoWDgUj1nOsvJ9tVA
 m76Ww+/pAnepVRafMID0rqEfD9oGv1YrfpeFJhyE2zUw3SyyNLIKWD6QeLRhKQRbSnsXhGLFBXCqt
 9k5JARhgQof9zvztcCVlT5KVvuyfC4H+HzeGmu9201BVyihJwKdcKPq+n/aY5FUVxNTgtI9f8wIbm
 fAjaoT1pjXSp+dszakA98fhONM98pOq723o/1ZGMZukyXFfsDGtA3BB79HoopHKujLGWAGskzClwT
 jRQxBqxh/U/lL1pc+0xPWikTNCmtziCOvv0KA0arDOMQlyFvImzX6oGVgE4ksKQYbMZ3Ikw6L1Rv1
 J+FvN0aNwOKgL2ztBRYscUGcQvA0Zo1fGCAn/BLEJvQYShWKeKqjyncVGoXFsz2AcuFKe1pwETSsN
 6OZncjy32e4ktgs07cWBfx0v62b8md36jau+B6RVnnodaA8++oXl3FRwiEW8XfXWIjy4umIv93tb8
 8ekYsfOfWkTSewZYXGoqe4RtK80ulMHb/dh2FZQIFyRdN4HOmB4FYO5sEYFr9YjHLmDkrUgNodJCX
 CeMe4BO4iaxUQARAQABtCdNYXJrdXMgUHJvYnN0IDxtYXJrdXMucHJvYnN0QHBvc3Rlby5kZT6JAl
 QEEwEIAD4CGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AWIQSCdBjE9KxY53IwxHM0dh/4561
 D0gUCaIZ9HQIZAQAKCRA0dh/4561D0pKmD/92zsCfbD+SrvBpNWtbit7J9wFBNr9qSFFm2n/65qen
 NNWKDrCzDsjRbALMHSO8nigMWzjofbVjj8Nf7SDcdapRjrMCnidS0DuW3pZBo6W0sZqV/fLx+AzgQ
 7PAr6jtBbUoKW/GCGHLLtb6Hv+zjL17KGVO0DdQeoHEXMa48mJh8rS7VlUzVtpbxsWbb1wRZJTD88
 ALDOLTWGqMbCTFDKFfGcqBLdUT13vx706Q29wrDiogmQhLGYKc6fQzpHhCLNhHTl8ZVLuKVY3wTT+
 f9TzW1BDzFTAe3ZXsKhrzF+ud7vr6ff9p1Zl+Nujz94EDYHi/5Yrtp//+N/ZjDGDmqZOEA86/Gybu
 6XE/v4S85ls0cAe37WTqsMCJjVRMP52r7Y1AuOONJDe3sIsDge++XFhwfGPbZwBnwd4gEVcdrKhnO
 ntuP9TvBMFWeTvtLqlWJUt7n8f/ELCcGoO5acai1iZ59GC81GLl2izObOLNjyv3G6hia/w50Mw9MU
 dAdZQ2MxM6k+x4L5XeysdcR/2AydVLtu2LGFOrKyEe0M9XmlE6OvziWXvVVwomvTN3LaNUmaINhr7
 pHTFwDiZCSWKnwnvD2+jA1trKq1xKUQY1uGW9XgSj98pKyixHWoeEpydr+alSTB43c3m0351/9rYT
 TTi4KSk73wtapPKtaoIR3rOFHLQXbWFya3VzLnByb2JzdEBwb3N0ZW8uZGWJAlEEEwEIADsWIQSCd
 BjE9KxY53IwxHM0dh/4561D0gUCaIO9eAIbAwULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgAAKCR
 A0dh/4561D0oHZEACEmk5Ng9+OXoVxJJ+c9slBI2lYxyBO84qkWjoJ/0GpwoHk1IpyL+i+kF1Bb7y
 Hx9Tiz8ENYX7xIPTZzS8hXs1ksuo76FQUyD6onA/69xZIrYZ0NSA5HUo62qzzMSZL7od5e12R6OPR
 lR0PIuc4ecOGCEq3BLRPfZSYrL54tiase8HubXsvb6EBQ8jPI8ZUlr96ZqFEwrQZF/3ihyV6LILLk
 geExgwlTzo5Wv3piOXPTITBuzuFhBJqEnT25q2j8OumGQ+ri8oVeAzx24g1kc11pwpR0sowfa5MvZ
 WrrBcaIL7uJfR/ig7FyGnTQ1nS3btf3p0v8A3fc4eUu/K2No3l2huJp3+LHhCmpmeykOhSB63Mj3s
 3Q87LD0HE0HBkTEMwp+sD97ZRpO67H5shzJRanUaDTb/mREfzpJmRT1uuec0X2zItL7a6itgMJvYI
 KG29aJLX3fTzzVzFGPgzVZYEdhu4y53p0qEGrrC1JtKR6DRPE1hb/OdWOkjmJ75+PPLD9U5IuRd6y
 sHJWsEBR1F0wkMPkEofWsvMYJzWXx/rvTWO8N4D6HigTgBXAXNgbc3IHpHlkvKoBJptv6DRVRtIrz
 0G0cfBY0Sm7he4N2IYDWWdGnPBZ3rlLSdj5EiBU2YWgIgtLrb8ZNJ3ZlhYluGnBJDGRqy2jC9s1jY
 66sLA9rQZMHhJTzMyIDwweGlvMzJAcG9zdGVvLmV1PokCbQQTAQgAVxYhBIJ0GMT0rFjncjDEczR2
 H/jnrUPSBQJpa71VGxSAAAAAAAQADm1hbnUyLDIuNSsxLjExLDIsMgIbAwULCQgHAgIiAgYVCgkIC
 wIEFgIDAQIeBwIXgAAKCRA0dh/4561D0gKJD/9uOQKYlsDoQX65Gd0LiMT0C+5vXgr3VI0PHDOwcv
 51fJ3A1vNyPZRFPGrz8+mDEXUQOF/INfnz5Tu1QHwf+iYcWcTGAN/FHgVR6ET6VBNU2hJaKhu+Ggo
 kjYyJTOvyX+3yNRUfSny0GjTjIPuPTErjqmHF+BtjXslpgwqnNMznf3lRIuUjRORupos6p3k1DndE
 5vzUTmXSvMyXyOD2KhBl/kL76k0bHYyAQytZPag12pltrtFbA/r2phDGN2si8PooDT99bSTJjaM45
 MTAAHbHKJfvgfK41bNFD5mMtpWpL195XRtS0Nrxdg3PaYBxN5gtTG0RyZfpYRlkdEhm+jj/8RxuSG
 i/qdhRdbiI7K2IELWeQVHSNDi9JabR/UzlR4NSnhfAjRIVlRM+eFbUl8XwxwVrAkojF5IraH2qRvg
 VCmuFsHUW07FUlrDrzpjXsD73cKppoFGDCdDR0BHJepXbFLS9+AqkT+guRJlnCTg2p+TQtnbwPgKp
 Vj98JixovCl99zRYTsL2bRNU5+q8iET65VMJ1ydyNanvLd5vI/NqDkXhlXLsGmdaDTtu4R21PkToX
 dQNGrZ91M9nlIBKw8Y7c7xZ4098qX2b8JX/CxD+gC1r4C8vuA3GkhFLx+KlkON7LyiJPkrePp6Qky
 jfGillcaQOqFZ3WwVqyzG1BUfTow==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-8SCNhw0esch3zdyg25Ni"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt


--=-8SCNhw0esch3zdyg25Ni
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2026-09-06 at 20:00 +0100, Gary Guo wrote:
> On Sun Sep 6, 2026 at 6:39 PM BST, Markus Probst wrote:
> > On Fri, 2026-09-04 at 10:48 +0530, Ayush Singh wrote:
> > > On 9/4/26 2:19 AM, Markus Probst wrote:
> > >=20
> > > > On Thu, 2026-08-27 at 13:24 +0530, Ayush Singh wrote:
> > > > > Add a driver for Greybus nodes attached over a plain serial port.=
 The
> > > > > node is registered with the software SVC (gb-softsvc), which hand=
les the
> > > > > SVC protocol on behalf of the AP, so no dedicated coprocessor run=
ning
> > > > > SVC firmware is needed.
> > > > >=20
> > > > > Greybus messages are carried over HDLC framing on the wire. Each =
frame
> > > > > carries a one-byte address (0x01 for Greybus) and control byte, f=
ollowed
> > > > > by the 16-bit CPort ID and the Greybus message itself.
> > > > >=20
> > > > > Port parameters are taken from the firmware node: "baudrate" if
> > > > > present, otherwise 115200, with flow control and parity disabled.
> > > > >=20
> > > > > Since gb-uart-node imports types from gb-softsvc, Rust to Rust ca=
lling
> > > > > setup from nova-core [0] is being used.
> > > > >=20
> > > > > [0]: https://lore.kernel.org/all/20260622-nova-exports-v5-0-61917=
73fc977@nvidia.com/
> > > > >=20
> > > > > Signed-off-by: Ayush Singh <ayush@beagleboard.org>
> > > > > ---
> > > > >   MAINTAINERS                     |   1 +
> > > > >   drivers/greybus/.gitignore      |   1 +
> > > > >   drivers/greybus/Kconfig         |  15 +++
> > > > >   drivers/greybus/Makefile        |  48 ++++++++
> > > > >   drivers/greybus/gb_uart_node.rs | 245 +++++++++++++++++++++++++=
+++++++++++++++
> > > > >   5 files changed, 310 insertions(+)
> > > > >=20
> > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > index d047090be5f4..49c6dac72748 100644
> > > > > --- a/MAINTAINERS
> > > > > +++ b/MAINTAINERS
> > > > > @@ -11339,6 +11339,7 @@ M:	Ayush Singh <ayush@beagleboard.com>
> > > > >   L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
> > > > >   S:	Maintained
> > > > >   F:	Documentation/devicetree/bindings/beagle/beagle,beagleconnec=
t-freedom.yaml
> > > > > +F:	drivers/greybus/gb_uart_node.rs
> > > > >  =20
> > > > >   GREYBUS SUBSYSTEM
> > > > >   M:	Johan Hovold <johan@kernel.org>
> > > > > diff --git a/drivers/greybus/.gitignore b/drivers/greybus/.gitign=
ore
> > > > > new file mode 100644
> > > > > index 000000000000..ff9c4a3539b4
> > > > > --- /dev/null
> > > > > +++ b/drivers/greybus/.gitignore
> > > > > @@ -0,0 +1 @@
> > > > > +exports_gb_softsvc_generated.h
> > > > > diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
> > > > > index 381d1a6ee135..34de913af287 100644
> > > > > --- a/drivers/greybus/Kconfig
> > > > > +++ b/drivers/greybus/Kconfig
> > > > > @@ -60,5 +60,20 @@ config GREYBUS_SOFTSVC
> > > > >   	  To compile this code as a module, choose M here: the module
> > > > >   	  will be called gb-softsvc.ko
> > > > >  =20
> > > > > +config GREYBUS_UART_NODE
> > > > > +	tristate "Greybus UART node transport"
> > > > > +	depends on RUST
> > > > > +	depends on GREYBUS_SOFTSVC
> > > > > +	depends on RUST_SERIAL_DEV_BUS_ABSTRACTIONS
> > > > > +	select RUST_CRC_CCITT_ABSTRACTIONS
> > > > > +	help
> > > > > +	  Select this option if you have a Greybus node connected over =
a
> > > > > +	  serial port. The node is registered with the software SVC, wh=
ich
> > > > > +	  handles the SVC protocol on behalf of the AP, so no dedicated
> > > > > +	  coprocessor running SVC firmware is required.
> > > > > +
> > > > > +	  To compile this code as a module, choose M here: the module
> > > > > +	  will be called gb-uart-node.ko
> > > > > +
> > > > >   endif	# GREYBUS
> > > > >  =20
> > > > > diff --git a/drivers/greybus/Makefile b/drivers/greybus/Makefile
> > > > > index e6f594128802..81151963c01e 100644
> > > > > --- a/drivers/greybus/Makefile
> > > > > +++ b/drivers/greybus/Makefile
> > > > > @@ -28,3 +28,51 @@ obj-$(CONFIG_GREYBUS_ES2)	+=3D gb-es2.o
> > > > >   obj-$(CONFIG_GREYBUS_SOFTSVC)	+=3D gb-softsvc.o
> > > > >   gb-softsvc-y			+=3D gb_softsvc.o gb_softsvc_exports.o
> > > > >  =20
> > > > > +obj-$(CONFIG_GREYBUS_UART_NODE)	+=3D gb-uart-node.o
> > > > > +gb-uart-node-y			+=3D gb_uart_node.o
> > > > > +
> > > > > +# Export Rust symbols from gb-softsvc only if gb-uart-node actua=
lly references them.
> > > > > +gb-softsvc-export-deps :=3D $(if $(CONFIG_GREYBUS_UART_NODE),$(o=
bj)/gb_uart_node.o)
> > > > > +
> > > > > +rust_needed_exports =3D \
> > > > > +	{ $(if $(strip $(2)),$(NM) -u $(2);,) echo "__DEFINED_RUST_SYMB=
OLS__"; \
> > > > > +	  $(NM) -p --defined-only $(1); } | \
> > > > > +	awk -v fmt=3D'$(3)' ' \
> > > > > +		/^__DEFINED_RUST_SYMBOLS__$$/ { defs =3D 1; next } \
> > > > > +		!defs { if ($$NF ~ /^_R/) needed[$$NF] =3D 1; next } \
> > > > > +		defs && $$2 ~ /(T|R|D|B)/ && $$3 ~ /^_R/ && \
> > > > > +			$$3 !~ /_(init|cleanup)_module$$/ && \
> > > > > +			$$3 !~ /__(pfx|cfi|odr_asan)/ && \
> > > > > +			$$3 in needed { printf fmt, $$3 } \
> > > > > +	'
> > > > > +
> > > > > +quiet_cmd_exports =3D EXPORTS $@
> > > > > +      cmd_exports =3D \
> > > > > +	$(call rust_needed_exports,$<,$(gb-softsvc-export-deps),EXPORT_=
SYMBOL_RUST_GPL(%s);\n) > $@
> > > > > +
> > > > > +$(obj)/exports_gb_softsvc_generated.h: $(obj)/gb_softsvc.o $(gb-=
softsvc-export-deps) FORCE
> > > > > +	$(call if_changed,exports)
> > > > > +
> > > > > +targets +=3D exports_gb_softsvc_generated.h
> > > > > +
> > > > > +$(obj)/gb_softsvc_exports.o: $(obj)/exports_gb_softsvc_generated=
.h
> > > > > +CFLAGS_gb_softsvc_exports.o :=3D -I $(objtree)/$(obj)
> > > > > +
> > > > > +ifdef CONFIG_MODVERSIONS
> > > > > +# The C export shim declares Rust symbols as `extern int`, so re=
use its export
> > > > > +# list but generate symbol CRCs from the Rust object instead of =
the shim's DWARF.
> > > > > +$(obj)/gb_softsvc_exports.o: private cmd_gensymtypes_c =3D \
> > > > > +	$(call getexportsymbols,\1) | \
> > > > > +	$(objtree)/scripts/gendwarfksyms/gendwarfksyms \
> > > > > +		$(if $(KBUILD_GENDWARFKSYMS_STABLE), --stable) \
> > > > > +		$(if $(KBUILD_SYMTYPES), --symtypes $(@:.o=3D.symtypes),) \
> > > > > +		$(obj)/gb_softsvc.o
> > > > > +endif
> > > > > +
> > > > > +# Output nova-core's crate metadata for use by nova-drm at compi=
le time.
> > > > > +RUSTFLAGS_gb_softsvc.o +=3D \
> > > > > +	--emit=3Dmetadata=3D$(objtree)/$(obj)/libgb_softsvc.rmeta
> > > > > +
> > > > > +# Allow nova-drm to import nova-core's types.
> > > > > +$(obj)/gb_uart_node.o: $(obj)/gb_softsvc.o
> > > > > +RUSTFLAGS_gb_uart_node.o :=3D -L $(objtree)/$(obj) --extern gb_s=
oftsvc
> > > > > diff --git a/drivers/greybus/gb_uart_node.rs b/drivers/greybus/gb=
_uart_node.rs
> > > > > new file mode 100644
> > > > > index 000000000000..3eb4f8ab3655
> > > > > --- /dev/null
> > > > > +++ b/drivers/greybus/gb_uart_node.rs
> > > > > @@ -0,0 +1,245 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > +
> > > > > +//! Greybus UART Node driver
> > > > > +
> > > > > +use kernel::{
> > > > > +    alloc::Flags,
> > > > > +    crc_ccitt::crc_ccitt,
> > > > > +    device::{
> > > > > +        AsBusDevice,
> > > > > +        Bound,
> > > > > +        Core, //
> > > > > +    },
> > > > > +    error::code,
> > > > > +    new_spinlock, of,
> > > > > +    prelude::*,
> > > > > +    serdev,
> > > > > +    sync::{
> > > > > +        aref::ARef,
> > > > > +        Arc,
> > > > > +        SpinLock, //
> > > > > +    },
> > > > > +};
> > > > > +
> > > > > +use zerocopy::little_endian;
> > > > > +use zerocopy_derive::{FromBytes, Immutable, KnownLayout};
> > > > > +
> > > > > +const HDLC_MAX_FRAME_LEN: usize =3D 256;
> > > > > +
> > > > > +const HDLC_FRAME: u8 =3D 0x7E;
> > > > > +const HDLC_ESC: u8 =3D 0x7D;
> > > > > +const HDLC_XOR: u8 =3D 0x20;
> > > > > +const HDLC_EXPECTED_CRC: u16 =3D 0xf0b8;
> > > > > +
> > > > > +const ADDRESS_GREYBUS: u8 =3D 0x01;
> > > > > +
> > > > > +#[repr(C, packed)]
> > > > > +#[derive(FromBytes, Immutable, KnownLayout)]
> > > > > +struct GreybusFrame {
> > > > > +    cport: little_endian::U16,
> > > > > +    msg: [u8],
> > > > > +}
> > > > > +
> > > > > +struct HdlcRx {
> > > > > +    rx_buf: KVec<u8>,
> > > > > +    rx_in_esc: bool,
> > > > > +    sdev: ARef<serdev::Device>,
> > > > > +    node: gb_softsvc::Module,
> > > > > +}
> > > > > +
> > > > > +impl HdlcRx {
> > > > > +    fn new(sdev: ARef<serdev::Device>, node: gb_softsvc::Module)=
 -> Result<Self> {
> > > > > +        Ok(Self {
> > > > > +            node,
> > > > > +            sdev,
> > > > > +            rx_buf: KVec::with_capacity(HDLC_MAX_FRAME_LEN, GFP_=
KERNEL)?,
> > > > > +            rx_in_esc: false,
> > > > > +        })
> > > > > +    }
> > > > > +
> > > > > +    fn frame_finish(&self) -> Result<()> {
> > > > > +        if self.rx_buf.len() < 4 {
> > > > > +            return Err(code::EFAULT);
> > > > > +        }
> > > > > +
> > > > > +        let crc =3D crc_ccitt(0xffff, &self.rx_buf);
> > > > > +        if crc !=3D HDLC_EXPECTED_CRC {
> > > > > +            dev_warn!(self.sdev.as_ref(), "CRC failed {}", crc);
> > > > > +            return Ok(());
> > > > > +        }
> > > > > +
> > > > > +        let addr =3D self.rx_buf[0];
> > > > > +        let _ctrl =3D self.rx_buf[1];
> > > > > +        let payload =3D &self.rx_buf[2..self.rx_buf.len() - size=
_of::<u16>()];
> > > > > +
> > > > > +        match addr {
> > > > > +            ADDRESS_GREYBUS =3D> {
> > > > > +                let frame =3D GreybusFrame::ref_from_bytes(paylo=
ad).map_err(|_| code::EINVAL)?;
> > > > > +                self.node.submit_message(0, frame.cport.into(), =
&frame.msg)
> > > > > +            }
> > > > > +            _ =3D> Err(code::EINVAL),
> > > > > +        }
> > > > > +    }
> > > > > +
> > > > > +    fn rx(&mut self, data: &[u8]) -> usize {
> > > > > +        for i in data.iter() {
> > > > > +            match *i {
> > > > > +                HDLC_FRAME =3D> {
> > > > > +                    if !self.rx_buf.is_empty() {
> > > > > +                        if let Err(e) =3D self.frame_finish() {
> > > > > +                            dev_warn!(self.sdev.as_ref(), "bad f=
rame: {e:?}\n");
> > > > > +                        }
> > > > > +                    }
> > > > > +
> > > > > +                    self.rx_buf.clear();
> > > > > +                    self.rx_in_esc =3D false;
> > > > > +                }
> > > > > +                HDLC_ESC =3D> self.rx_in_esc =3D true,
> > > > > +                _ =3D> {
> > > > > +                    let c =3D if self.rx_in_esc { *i ^ HDLC_XOR =
} else { *i };
> > > > > +                    self.rx_in_esc =3D false;
> > > > > +
> > > > > +                    if self.rx_buf.push_within_capacity(c).is_er=
r() {
> > > > > +                        dev_warn!(self.sdev.as_ref(), "buffer ov=
erflow. Dropping frame");
> > > > > +
> > > > > +                        self.rx_buf.clear();
> > > > > +                        self.rx_in_esc =3D false;
> > > > > +                    }
> > > > > +                }
> > > > > +            }
> > > > > +        }
> > > > > +
> > > > > +        data.len()
> > > > > +    }
> > > > > +}
> > > > > +
> > > > > +struct GbNode {
> > > > > +    sdev: ARef<serdev::Device>,
> > > > > +}
> > > > > +
> > > > > +impl GbNode {
> > > > > +    const fn new(sdev: ARef<serdev::Device>) -> Self {
> > > > > +        Self { sdev }
> > > > > +    }
> > > > > +
> > > > > +    fn fill_buf(mut crc: u16, data: &[u8], buf: &mut KVec<u8>) -=
> Result<u16> {
> > > > > +        for i in data {
> > > > > +            crc =3D crc_ccitt(crc, &[*i]);
> > > > > +            if *i =3D=3D HDLC_ESC || *i =3D=3D HDLC_FRAME {
> > > > > +                buf.push_within_capacity(HDLC_ESC)?;
> > > > > +                buf.push_within_capacity(i ^ HDLC_XOR)?;
> > > > > +            } else {
> > > > > +                buf.push_within_capacity(*i)?;
> > > > > +            }
> > > > > +        }
> > > > > +
> > > > > +        Ok(crc)
> > > > > +    }
> > > > > +}
> > > > > +
> > > > > +impl gb_softsvc::InterfaceOps for GbNode {
> > > > > +    fn write(&self, data: &[u8], cport: u16, gfp_mask: Flags) ->=
 Result<()> {
> > > > > +        // SAFETY: `GbNode` only exists while its serdev driver =
is bound, so the device is in the
> > > > > +        // `Bound` state for the duration of this call.
> > > > > +        let bound: &serdev::Device<Bound> =3D
> > > > > +            unsafe { serdev::Device::from_device(self.sdev.as_re=
f().as_bound()) };
> > > > > +
> > > > > +        let mut buf =3D KVec::with_capacity(HDLC_MAX_FRAME_LEN, =
gfp_mask)?;
> > > > > +
> > > > > +        let mut crc =3D 0xffff;
> > > > > +
> > > > > +        buf.push_within_capacity(HDLC_FRAME)?;
> > > > > +
> > > > > +        crc =3D Self::fill_buf(crc, &[ADDRESS_GREYBUS, 0x03], &m=
ut buf)?;
> > > > > +        crc =3D Self::fill_buf(crc, &cport.to_le_bytes(), &mut b=
uf)?;
> > > > > +        crc =3D Self::fill_buf(crc, data, &mut buf)?;
> > > > > +
> > > > > +        crc ^=3D 0xffff;
> > > > > +        Self::fill_buf(crc, &crc.to_le_bytes(), &mut buf)?;
> > > > > +
> > > > > +        buf.push_within_capacity(HDLC_FRAME)?;
> > > > > +
> > > > > +        bound.write_all(&buf, 0)?;
> > > > > +
> > > > > +        Ok(())
> > > > > +    }
> > > > > +}
> > > > > +
> > > > > +#[pin_data]
> > > > > +struct GbUartNode {
> > > > > +    #[pin]
> > > > > +    rx: SpinLock<Option<HdlcRx>>,
> > > > (add me to CC please)
> > > >=20
> > > > Instead of using a lock here, it might be a better idea to
> > > > synchronize/stop the receive callback before unbind is called in th=
e
> > > > serdev rust abstraction. This would allow the abstraction to provid=
e
> > > > mutable references to the driver data in `receive` and `unbind`. It
> > > > would also remove the Sync requirement.
> > > >=20
> > > > I will send a patch soon.
> > > >=20
> > > > Thanks
> > > > - Markus Probst
> > >=20
> > > That sounds great. The lock here was basically only for getting a mut=
=20
> > > ref. I will base the next version on top of your patches.
> > >=20
> > > I have added your email for the next patch version.
> > It appears that "would break the driver core's lifetime design", so I
> > have to drop the patch.
> >=20
> > You will still need the SpinLock.
>=20
> You can still do sychronization to allow this, just not using things from
> drvdata. For example, if you move this "active: Mutex<bool>" to be part o=
f
> `serdev_device`, then you don't need to access `drvdata` to set the activ=
e
> field.
>=20
> That'll be actually more inline with what other buses are doing, where dr=
vdata
> is exclusively for the drivers, and for the bus.
I am not sure what the active mutex has to do with.

In fact, the `active` mutex will be removed anyway [1].

The patch [2] would provide mutable references to callbacks.
According to Danilo, "The whole design is based on the guarantee that
we never construct a mutable reference of the bus device private data."
[3] (which the patch would violate).


Thanks
- Markus Probst

[1]
https://lore.kernel.org/rust-for-linux/20260906-rust_serdev_probe_refactor-=
v1-2-69cdae0074ec@posteo.de/

[2]
https://lore.kernel.org/rust-for-linux/20260906-rust_serdev_probe_refactor-=
v1-5-69cdae0074ec@posteo.de/

[3]
https://lore.kernel.org/rust-for-linux/DL8DCNMSENDS.3T14U5W1Y32IX@kernel.or=
g/

>=20
> Best,
> Gary

--=-8SCNhw0esch3zdyg25Ni
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQJPBAABCAA5FiEEgnQYxPSsWOdyMMRzNHYf+OetQ9IFAmqdvL8bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyAAoJEDR2H/jnrUPSFLAP/0wSK2Snuxw4jdU16cKm
q5Y7FyUj81ul2vnc7ImAVXdetVCohUjSUGFG11ugdvVKoi0A8OYYDcRe2ImqBu0o
uVHmRfHEqSk+ea9MRVb6zPljRCIP9iDlK1T8tUkSuN7nROi5Kp5LKHytIZAu4QQI
0HCmq5rxhBTciWRHDc+ugcl6ENyz4Z2JKbl9UI7A+t2dqkQEurXbFpxOUzcUyaAn
MKSm9KbMEvMwlgwIU+iOgYLu+jbJy4JwhGVlkcNEG+hbg/wmV05yiogwHm5Mh9rL
OBr1R1abJxPLGOk06cqKStQFS+J2uNJm3raS+Kawt1uxSr3KyG4sSSnif4nkTPMu
dXYRB6p+QarE0ww4mO4/VpCPmZJZngdtzSjJDpWgVrsvzN8v1sxVT3tUUl712UBq
4O91dM5FGfRQqil4Q/ofjPMhvZOpbIrQRaRIknhWIJ2nRff9HMF6ejMCtdFIE8gP
+T9MpWsMmRIWXsps+2MksLkQNTcXzQYm9FmI6TjVGRCJZwqej4MpHr84PnHRLZPe
6ZavFtVG3mrvAX46x1q6aIjI40Tg5sAM3duNpp7kEfLp2O22Y65YSoGJfK/tOS8m
yfet8LGePiCxJctB1xTvygWUd7jJ0WGC/gV5g68p9BGv24JK9TkNH1biWH6Y9+ja
TuRNTjcZ8SK9mzgU9RIoYYKu
=wFxE
-----END PGP SIGNATURE-----

--=-8SCNhw0esch3zdyg25Ni--
