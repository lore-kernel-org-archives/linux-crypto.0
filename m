Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC43C51E422
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 16:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791910614; cv=none; b=aa4yFdK+FWX4aWO4i7fq9Py/Uo0drInYY9oLi2cEwEmlwgkCC9k/ZKBRnmD1HHGviCqmwLE2FEYl4SNY4TtaKwZuYtmxrX0KRyBqvrZP/HmOx75OWvV8hQeUxaJ7cWcAVOd6b377/a2ltEdZI3ege0Fs9Q8hXC18qdMkfpMLv0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791910614; c=relaxed/simple;
	bh=mJHqwcgSVpk5DTKtY14oLAv+WKBo5mqYQNIS5dMW+c4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F/IC7WKNOfefbvM74JSIrMW4xCBPUTrVSg45mP2L+36p9qANv/VvE7CMnYTkNKFFMaPd36WV2R/hkA7jaM84dedMXW841eGXMNrqpdJzsND5Z/5QiwUXD0axSdEzVGSfqRX7aSNzMYPjASuR/GniTXrVxpcTTYhr8/SP7LmdFfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=kY42KNp5; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="kY42KNp5"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 6E31F240101
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 18:56:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1791910609;
	bh=84UAUybAcmHwu6PdtmUeT5FxMfPcwDy64JHXJjt4vm4=;
	h=Message-ID:Subject:From:To:Cc:Date:Autocrypt:Content-Type:
	 MIME-Version:OpenPGP:From;
	b=kY42KNp56C5Nva02G8fDyJ/kF7y+j5oHcxnKd9pvILxEDJ43YiOUVBOVZVqJLNH5g
	 6rdDYejx6JPOkbinOPnen+DImuW9HXvL16Mh8eLHV2Kzkw8JNIvu6cw6tnWZxgM6Ix
	 kCd6EzayfUzGpxTK0VLGCkIweqlyu0rWmkFJ7bHc+uEJUdlfqA4T3rGKP2uS5VVoeH
	 lCQlbftUlOhCd3lO8veYi/P/2IVqettlor7rHVcOKOZOGa0iVLedEuOS0UeUS5Al2P
	 6RoxwUS2rlK3Gp2dBC9qFjDl22oePPEs4dPWFXPGnO67nIpgcw61Rg9GGTC49mG6/d
	 NUrYMiV+AzfZA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4j40qK2nhHz6ty0;
	Tue, 13 Oct 2026 18:56:45 +0200 (CEST)
Message-ID: <7c5619f34cdf696a8be2215ee8a4120e3f0ff1a9.camel@posteo.de>
Subject: Re: [PATCH v3 7/7] greybus: Add Rust UART node driver
From: Markus Probst <markus.probst@posteo.de>
To: Ayush Singh <ayush@beagleboard.org>
Cc: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com, Johan
 Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, Greg
 Kroah-Hartman	 <gregkh@linuxfoundation.org>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng	 <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?ISO-8859-1?Q?Bj=F6rn?= Roy Baron
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
 <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
	greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org
Date: Tue, 13 Oct 2026 16:56:47 +0000
In-Reply-To: <87y0c14l8b.fsf@beagleboard.org>
References: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
		<20261013-gb-uart-transport-v3-7-81d0a8a1acf7@beagleboard.org>
		<037d7460eae92dd00f9283dd5595a3257212f0b9.camel@posteo.de>
	 <87y0c14l8b.fsf@beagleboard.org>
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
 keydata=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
 jfGillcaQOqFZ3WwVqyzG1BUfTow==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-UqXBVxT8d+O+osTm5faS"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt


--=-UqXBVxT8d+O+osTm5faS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-10-13 at 21:59 +0530, Ayush Singh wrote:
> Markus Probst <markus.probst@posteo.de> writes:
>=20
> > On Tue, 2026-10-13 at 17:30 +0530, Ayush Singh wrote:
> > > Add a driver for Greybus nodes attached over a plain serial port. The
> > > node is registered with the software SVC (gb-softsvc), which handles =
the
> > > SVC protocol on behalf of the AP, so no dedicated coprocessor running
> > > SVC firmware is needed.
> > >=20
> > > Greybus messages are carried over HDLC framing on the wire. Each fram=
e
> > > carries a one-byte address (0x01 for Greybus) and control byte, follo=
wed
> > > by the 16-bit CPort ID and the Greybus message itself.
> > >=20
> > > Port parameters are taken from the firmware node: "baudrate" if
> > > present, otherwise 115200, with flow control and parity disabled.
> > >=20
> > > Since gb-uart-node imports types from gb-softsvc, Rust to Rust callin=
g
> > > setup from nova-core [0] is being used.
> > >=20
> > > [0]: https://lore.kernel.org/all/20260622-nova-exports-v5-0-6191773fc=
977@nvidia.com/
> > >=20
> > > Signed-off-by: Ayush Singh <ayush@beagleboard.org>
> > > ---
> > >  MAINTAINERS                     |   1 +
> > >  drivers/greybus/.gitignore      |   1 +
> > >  drivers/greybus/Kconfig         |  15 +++
> > >  drivers/greybus/Makefile        |  48 ++++++++
> > >  drivers/greybus/gb_uart_node.rs | 253 ++++++++++++++++++++++++++++++=
++++++++++
> > >  5 files changed, 318 insertions(+)
> > >=20
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 521bc6c67979..5bdd500ef63e 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -11527,6 +11527,7 @@ M:	Ayush Singh <ayush@beagleboard.org>
> > >  L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
> > >  S:	Maintained
> > >  F:	Documentation/devicetree/bindings/beagle/beagle,beagleconnect-fre=
edom.yaml
> > > +F:	drivers/greybus/gb_uart_node.rs
> > > =20
> > >  GREYBUS SUBSYSTEM
> > >  M:	Johan Hovold <johan@kernel.org>
> > > diff --git a/drivers/greybus/.gitignore b/drivers/greybus/.gitignore
> > > new file mode 100644
> > > index 000000000000..ff9c4a3539b4
> > > --- /dev/null
> > > +++ b/drivers/greybus/.gitignore
> > > @@ -0,0 +1 @@
> > > +exports_gb_softsvc_generated.h
> > > diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
> > > index 709563f8c0ad..ce2030161f30 100644
> > > --- a/drivers/greybus/Kconfig
> > > +++ b/drivers/greybus/Kconfig
> > > @@ -61,5 +61,20 @@ config GREYBUS_SOFTSVC
> > >  	  To compile this code as a module, choose M here: the module
> > >  	  will be called gb-softsvc.ko
> > > =20
> > > +config GREYBUS_UART_NODE
> > > +	tristate "Greybus UART node transport"
> > > +	depends on GREYBUS_SOFTSVC
> > > +	depends on RUST_SERIAL_DEV_BUS_ABSTRACTIONS
> > > +	depends on RUST_GREYBUS_ABSTRACTIONS
> > > +	select RUST_CRC_CCITT_ABSTRACTIONS
> > > +	help
> > > +	  Select this option if you have a Greybus node connected over a
> > > +	  serial port. The node is registered with the software SVC, which
> > > +	  handles the SVC protocol on behalf of the AP, so no dedicated
> > > +	  coprocessor running SVC firmware is required.
> > > +
> > > +	  To compile this code as a module, choose M here: the module
> > > +	  will be called gb-uart-node.ko
> > > +
> > >  endif	# GREYBUS
> > > =20
> > > diff --git a/drivers/greybus/Makefile b/drivers/greybus/Makefile
> > > index e6f594128802..bf4d08f728fe 100644
> > > --- a/drivers/greybus/Makefile
> > > +++ b/drivers/greybus/Makefile
> > > @@ -28,3 +28,51 @@ obj-$(CONFIG_GREYBUS_ES2)	+=3D gb-es2.o
> > >  obj-$(CONFIG_GREYBUS_SOFTSVC)	+=3D gb-softsvc.o
> > >  gb-softsvc-y			+=3D gb_softsvc.o gb_softsvc_exports.o
> > > =20
> > > +obj-$(CONFIG_GREYBUS_UART_NODE)	+=3D gb-uart-node.o
> > > +gb-uart-node-y			+=3D gb_uart_node.o
> > > +
> > > +# Export Rust symbols from gb-softsvc only if gb-uart-node actually =
references them.
> > > +gb-softsvc-export-deps :=3D $(if $(CONFIG_GREYBUS_UART_NODE),$(obj)/=
gb_uart_node.o)
> > > +
> > > +rust_needed_exports =3D \
> > > +	{ $(if $(strip $(2)),$(NM) -u $(2);,) echo "__DEFINED_RUST_SYMBOLS_=
_"; \
> > > +	  $(NM) -p --defined-only $(1); } | \
> > > +	awk -v fmt=3D'$(3)' ' \
> > > +		/^__DEFINED_RUST_SYMBOLS__$$/ { defs =3D 1; next } \
> > > +		!defs { if ($$NF ~ /^_R/) needed[$$NF] =3D 1; next } \
> > > +		defs && $$2 ~ /(T|R|D|B)/ && $$3 ~ /^_R/ && \
> > > +			$$3 !~ /_(init|cleanup)_module$$/ && \
> > > +			$$3 !~ /__(pfx|cfi|odr_asan)/ && \
> > > +			$$3 in needed { printf fmt, $$3 } \
> > > +	'
> > > +
> > > +quiet_cmd_exports =3D EXPORTS $@
> > > +      cmd_exports =3D \
> > > +	$(call rust_needed_exports,$<,$(gb-softsvc-export-deps),EXPORT_SYMB=
OL_RUST_GPL(%s);\n) > $@
> > > +
> > > +$(obj)/exports_gb_softsvc_generated.h: $(obj)/gb_softsvc.o $(gb-soft=
svc-export-deps) FORCE
> > > +	$(call if_changed,exports)
> > > +
> > > +targets +=3D exports_gb_softsvc_generated.h
> > > +
> > > +$(obj)/gb_softsvc_exports.o: $(obj)/exports_gb_softsvc_generated.h
> > > +CFLAGS_gb_softsvc_exports.o :=3D -I $(objtree)/$(obj)
> > > +
> > > +ifdef CONFIG_MODVERSIONS
> > > +# The C export shim declares Rust symbols as `extern int`, so reuse =
its export
> > > +# list but generate symbol CRCs from the Rust object instead of the =
shim's DWARF.
> > > +$(obj)/gb_softsvc_exports.o: private cmd_gensymtypes_c =3D \
> > > +	$(call getexportsymbols,\1) | \
> > > +	$(objtree)/scripts/gendwarfksyms/gendwarfksyms \
> > > +		$(if $(KBUILD_GENDWARFKSYMS_STABLE), --stable) \
> > > +		$(if $(KBUILD_SYMTYPES), --symtypes $(@:.o=3D.symtypes),) \
> > > +		$(obj)/gb_softsvc.o
> > > +endif
> > > +
> > > +# Output gb_softsvc's crate metadata for use by gb_uart_node at comp=
ile time.
> > > +RUSTFLAGS_gb_softsvc.o +=3D \
> > > +	--emit=3Dmetadata=3D$(objtree)/$(obj)/libgb_softsvc.rmeta
> > > +
> > > +# Allow nova-drm to import nova-core's types.
> > > +$(obj)/gb_uart_node.o: $(obj)/gb_softsvc.o
> > > +RUSTFLAGS_gb_uart_node.o :=3D -L $(objtree)/$(obj) --extern gb_softs=
vc
> > > diff --git a/drivers/greybus/gb_uart_node.rs b/drivers/greybus/gb_uar=
t_node.rs
> > > new file mode 100644
> > > index 000000000000..f719ee35e8f3
> > > --- /dev/null
> > > +++ b/drivers/greybus/gb_uart_node.rs
> > > @@ -0,0 +1,253 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +
> > > +//! Greybus UART Node driver
> > > +
> > > +use kernel::{
> > > +    alloc::Flags,
> > > +    crc_ccitt::crc_ccitt,
> > > +    device::{
> > > +        AsBusDevice,
> > > +        Bound,
> > > +        Core, //
> > > +    },
> > > +    error::code,
> > > +    new_spinlock,
> > > +    of, //
> > > +    prelude::*,
> > > +    serdev,
> > > +    sync::{
> > > +        aref::ARef,
> > > +        Arc,
> > > +        SpinLock, //
> > > +    },
> > > +};
> > > +
> > > +use zerocopy::little_endian;
> > > +use zerocopy_derive::{FromBytes, Immutable, KnownLayout};
> > > +
> > > +const HDLC_MAX_FRAME_LEN: usize =3D 256;
> > > +
> > > +const HDLC_FRAME: u8 =3D 0x7E;
> > > +const HDLC_ESC: u8 =3D 0x7D;
> > > +const HDLC_XOR: u8 =3D 0x20;
> > > +const HDLC_EXPECTED_CRC: u16 =3D 0xf0b8;
> > > +
> > > +const ADDRESS_GREYBUS: u8 =3D 0x01;
> > > +
> > > +#[repr(C, packed)]
> > > +#[derive(FromBytes, Immutable, KnownLayout)]
> > > +struct GreybusFrame {
> > > +    cport: little_endian::U16,
> > > +    msg: [u8],
> > > +}
> > > +
> > > +struct HdlcRx {
> > > +    rx_buf: KVec<u8>,
> > > +    rx_in_esc: bool,
> > > +    rx_overflow: bool,
> > > +    sdev: ARef<serdev::Device>,
> > > +    node: gb_softsvc::Module,
> > > +}
> > > +
> > > +impl HdlcRx {
> > > +    fn new(sdev: ARef<serdev::Device>, node: gb_softsvc::Module) -> =
Result<Self> {
> > > +        Ok(Self {
> > > +            node,
> > > +            sdev,
> > > +            rx_buf: KVec::with_capacity(HDLC_MAX_FRAME_LEN, GFP_KERN=
EL)?,
> > > +            rx_in_esc: false,
> > > +            rx_overflow: false,
> > > +        })
> > > +    }
> > > +
> > > +    fn frame_finish(&self) -> Result<()> {
> > > +        if self.rx_buf.len() < 4 {
> > > +            return Err(code::EFAULT);
> > > +        }
> > > +
> > > +        let crc =3D crc_ccitt(0xffff, &self.rx_buf);
> > > +        if crc !=3D HDLC_EXPECTED_CRC {
> > > +            dev_warn!(self.sdev.as_ref(), "CRC failed {}", crc);
> > > +            return Ok(());
> > > +        }
> > > +
> > > +        let addr =3D self.rx_buf[0];
> > > +        let _ctrl =3D self.rx_buf[1];
> > > +        let payload =3D &self.rx_buf[2..self.rx_buf.len() - size_of:=
:<u16>()];
> > > +
> > > +        match addr {
> > > +            ADDRESS_GREYBUS =3D> {
> > > +                let frame =3D GreybusFrame::ref_from_bytes(payload).=
map_err(|_| code::EINVAL)?;
> > > +                self.node.submit_message(0, frame.cport.into(), &fra=
me.msg)
> > > +            }
> > > +            _ =3D> Err(code::EINVAL),
> > > +        }
> > > +    }
> > > +
> > > +    fn rx(&mut self, data: &[u8]) -> usize {
> > > +        for i in data.iter() {
> > > +            match *i {
> > > +                HDLC_FRAME =3D> {
> > > +                    if !self.rx_buf.is_empty() {
> > > +                        if let Err(e) =3D self.frame_finish() {
> > > +                            dev_warn!(self.sdev.as_ref(), "bad frame=
: {e:?}\n");
> > > +                        }
> > > +                    }
> > > +
> > > +                    self.rx_buf.clear();
> > > +                    self.rx_in_esc =3D false;
> > > +                    self.rx_overflow =3D false;
> > > +                }
> > > +                HDLC_ESC =3D> self.rx_in_esc =3D true,
> > > +                // Skip data if buffer has overflown.
> > > +                _ if self.rx_overflow =3D> {}
> > > +                _ =3D> {
> > > +                    let c =3D if self.rx_in_esc { *i ^ HDLC_XOR } el=
se { *i };
> > > +                    self.rx_in_esc =3D false;
> > > +
> > > +                    if self.rx_buf.push_within_capacity(c).is_err() =
{
> > > +                        dev_warn!(self.sdev.as_ref(), "buffer overfl=
ow. Dropping frame");
> > > +
> > > +                        self.rx_overflow =3D true;
> > > +                        self.rx_buf.clear();
> > > +                    }
> > > +                }
> > > +            }
> > > +        }
> > > +
> > > +        data.len()
> > > +    }
> > > +}
> > > +
> > > +struct GbNode {
> > > +    sdev: ARef<serdev::Device>,
> > > +}
> > > +
> > > +impl GbNode {
> > > +    const fn new(sdev: ARef<serdev::Device>) -> Self {
> > > +        Self { sdev }
> > > +    }
> > > +
> > > +    fn fill_buf(mut crc: u16, data: &[u8], buf: &mut KVec<u8>) -> Re=
sult<u16> {
> > > +        for i in data {
> > > +            crc =3D crc_ccitt(crc, &[*i]);
> > > +            if *i =3D=3D HDLC_ESC || *i =3D=3D HDLC_FRAME {
> > > +                buf.push_within_capacity(HDLC_ESC)?;
> > > +                buf.push_within_capacity(i ^ HDLC_XOR)?;
> > > +            } else {
> > > +                buf.push_within_capacity(*i)?;
> > > +            }
> > > +        }
> > > +
> > > +        Ok(crc)
> > > +    }
> > > +}
> > > +
> > > +impl gb_softsvc::InterfaceOps for GbNode {
> > > +    fn write(&self, data: &[u8], cport: u16, gfp_mask: Flags) -> Res=
ult<()> {
> > > +        // SAFETY: `GbNode` only exists while its serdev driver is b=
ound, so the device is in the
> > > +        // `Bound` state for the duration of this call.
> > > +        let bound: &serdev::Device<Bound> =3D
> > > +            unsafe { serdev::Device::from_device(self.sdev.as_ref().=
as_bound()) };
> > > +
> > > +        let mut buf =3D KVec::with_capacity(HDLC_MAX_FRAME_LEN, gfp_=
mask)?;
> > > +
> > > +        let mut crc =3D 0xffff;
> > > +
> > > +        buf.push_within_capacity(HDLC_FRAME)?;
> > > +
> > > +        crc =3D Self::fill_buf(crc, &[ADDRESS_GREYBUS, 0x03], &mut b=
uf)?;
> > > +        crc =3D Self::fill_buf(crc, &cport.to_le_bytes(), &mut buf)?=
;
> > > +        crc =3D Self::fill_buf(crc, data, &mut buf)?;
> > > +
> > > +        crc ^=3D 0xffff;
> > > +        Self::fill_buf(crc, &crc.to_le_bytes(), &mut buf)?;
> > > +
> > > +        buf.push_within_capacity(HDLC_FRAME)?;
> > > +
> > > +        bound.write_all(&buf, 0)?;
> > > +
> > > +        Ok(())
> > > +    }
> > > +}
> > > +
> > > +#[pin_data]
> > > +struct GbUartNode {
> > > +    #[pin]
> > > +    rx: SpinLock<Option<HdlcRx>>,
> > > +}
> > > +
> > > +impl GbUartNode {
> > > +    fn init(sdev: &serdev::Device<Core<'_>>) -> Result<HdlcRx> {
> > > +        if sdev
> > > +            .set_baudrate(
> > > +                sdev.as_ref()
> > > +                    .fwnode()
> > > +                    .and_then(|fwnode| fwnode.property_read(c"baudra=
te").optional())
> > > +                    .unwrap_or(115200),
> > > +            )
> > > +            .is_err()
> > > +        {
> > > +            return Err(EINVAL);
> > > +        }
> > > +        sdev.set_flow_control(false);
> > > +        sdev.set_parity(serdev::Parity::None)?;
> > > +
> > > +        let node =3D gb_softsvc::Module::new(&[Arc::new(GbNode::new(=
sdev.into()), GFP_KERNEL)?])?;
> > > +
> > > +        HdlcRx::new(sdev.into(), node)
> > > +    }
> > > +}
> > > +
> > > +kernel::of_device_table!(
> > > +    OF_TABLE,
> > > +    <GbUartNode as serdev::Driver>::IdInfo,
> > > +    [(of::DeviceId::new(c"beagle,beagleconnect-freedom"), ())]
> > > +);
> > > +
> > > +#[vtable]
> > > +impl serdev::Driver for GbUartNode {
> > > +    type IdInfo =3D ();
> > > +    type Data<'bound> =3D Self;
> > > +    const OF_ID_TABLE: Option<of::IdTable<Self::IdInfo>> =3D Some(&O=
F_TABLE);
> > > +
> > > +    fn probe<'bound>(
> > > +        sdev: &'bound serdev::Device<Core<'_>>,
> > > +        _info: Option<&'bound Self::IdInfo>,
> > > +    ) -> impl PinInit<Self, Error> + 'bound {
> > > +        dev_dbg!(sdev.as_ref(), "Probe gb_uart_node.\n");
> > > +
> > > +        try_pin_init!(Self {
> > > +            rx <- new_spinlock!(Some(Self::init(sdev)?), "gb_uart_no=
de::rx"),
> > > +        }? Error)
> > > +    }
> > > +
> > > +    fn receive<'bound>(
> > > +        _sdev: &'bound serdev::Device<Bound>,
> > > +        this: Pin<&Self>,
> > > +        data: &[u8],
> > > +    ) -> usize {
> > > +        if let Some(mut guard) =3D this.rx.try_lock() {
> > > +            if let Some(ref mut hdlc_rx) =3D *guard {
> > > +                return hdlc_rx.rx(data);
> > > +            }
> > > +        }
> > > +
> > > +        0
> > > +    }
> > > +
> > > +    fn unbind<'bound>(_: &'bound serdev::Device<Core<'_>>, this: Pin=
<&Self::Data<'bound>>) {
> > > +        // Getting a bound device is not possible after this point. =
So drop HdlcRx.
> > > +        // This also drops HdlcRx::node, which should ensure that Gb=
Node::write will not be called
> > > +        // after this point.
> > > +        let _ =3D this.rx.lock().take();
> > Not exactly.
> >=20
> > e.g.
> > ```
> > struct SerdevDriver<'bound> {
> >   dev: &'bound serdev::Device<Bound>,
> > }
> >=20
> > impl<'bound> Drop for SerdevDriver<'bound> {
> >=20
> >   fn drop(&mut self) {
> >     // Access to a bound device should still be possible here.
> >   }
> >=20
> > }
> > ```
> >=20
> > So afaik there should be no advantage of manually dropping it here.
> > Drop of `GbUartNode` should automatically drop the spinlock and the
> > data contained. The bound serial device is still valid at this point.
> >=20
> > This would likely make the usage of Option<> obsolete too.
> >=20
> > Thanks
> > - Markus Probst
>=20
> My understanding was that the state of serdev device is unknown between
> unbind and Drop calls. That would make the unsafe Bound device conversion
> in GbNode::write unsound.
>=20
> If I don't need to do the early drop, yes, that would remove the Option
> which would be great.

.write is still valid inside Drop.

Currently there is a small difference between unbind and Drop though
(that shouldn't matter here):

while unbind, data can still be received.
while Drop, data can only be sent. No data will be received (Drop and
receive never runs concurrently).

Thanks
- Markus Probst


>=20
> >=20
> > > +    }
> > > +}
> > > +
> > > +kernel::module_serdev_device_driver! {
> > > +    type: GbUartNode,
> > > +    name: "gb_uart_node",
> > > +    authors: ["Ayush Singh <ayush@beagleboard.org>"],
> > > +    description: "Greybus node connected over UART",
> > > +    license: "GPL v2",
> > > +}
> >=20
>=20
>=20
> Best Regards,
> Ayush Singh

--=-UqXBVxT8d+O+osTm5faS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQJPBAABCAA5FiEEgnQYxPSsWOdyMMRzNHYf+OetQ9IFAmrOYr0bFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyAAoJEDR2H/jnrUPSI+cP/RuVl+xdxJtdCnt/p3NA
DLBfxnTSo79NYIOowgE/fES/7vwnt3sWWJ5csSUGuPuIdu6eOvl8+WIOiEDHruJM
UpV1hoBlBgqHAVwYs+aMJRmJ1ZIYTVskWEyqG5EW2/PjrqQ1DAO7z3950LUNEnQd
x2yFKskDvvfeU4Jfrtcqv8nYD48APJtvaSK0Q0nuFl8c/4zMJpUXpvSoeRSqxFO9
27ZP2UzgJPbRAvvgF3mcmhYJs7TJO29PXJDQIZdO2dRR+qkJ9T/afA0cBEMbnYQo
B+Vw9I8JKD75CICJeK5h5Y4akCauBFPjKZDPJIhwOo+7jZy9qqT4FuUnTZBxaXGn
ijZo4nP1EmQ623cygDqXZubtjsm5P1prBFqF7pz0oW4iTit/wPJO9CNvPO1Uw54o
GepcRaTdIaK9yTTei3yH5GAoGFOqQ/GPoanfN78itXMalAv4n3+cKb+u6NgY4RDE
N7oo6dpeDm5lOsO/33nvoVOF856cZeP+bvE/C7H2T05M5unPNaDzX2KOvd5lS9nu
UnO+RihOqLI9B3GoQ4p7FqnAyytsz3vqWGtlpnq7uSBS2hXJA8b+yF1E/I9oM19S
wSeVv/FTX1dWs4E91h7m/idZG/DAjb/G4mHC88XQSBmnjGqFA2gdmz8gZZzai+6S
WSMuFxoSHmTdBoes/NeojKFp
=N4cC
-----END PGP SIGNATURE-----

--=-UqXBVxT8d+O+osTm5faS--
