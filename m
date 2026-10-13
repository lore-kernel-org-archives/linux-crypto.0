Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A685C517BA3
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902937; cv=none; b=VK6AI6ocGDWgNolVXqUKNL3UgPBCvAw5uobZu/f3eC2VH7DrDHmIprd1heYuep8nM7zp2y+tlXGaV7KXZTgarM6YnaeCtaR1SwMGDsLA7jpmflM5FamUQy8vUqhx+tHe15DBB3uqvVLc/ZRN9zMSfzKacvYdWsoyYlXNu+87DCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902937; c=relaxed/simple;
	bh=jecSrd243OkE+xvCf0loTXnPVSMa5n4vGB/geb2zZQg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M1bnwmonN3yUAztNJkTfNlQgr1QpOtIvGEoC596ZerVHhukCskPEm3fp/bAwWNnEMA7zciesny24ObsKm9AlL8XeN3IID++eLPFslxQ2RBpVmD7tPIZLUPQ6PKGnvbHfEVIzLsNcq8abbwRFgcQII7I8+zVS6bIQIpbEGKDcVM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=kW4fu0f/; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="kW4fu0f/"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 716B3240105
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 16:48:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1791902926;
	bh=BBc5dj2dLxJ0POZlwzfm/Ymo+AZOtKIHWvZq7eFdmtM=;
	h=Message-ID:Subject:From:To:Cc:Date:Autocrypt:Content-Type:
	 MIME-Version:OpenPGP:From;
	b=kW4fu0f/PG2VgdTSO0tsTa23yTuyOgo3flTLWWawVnJHpwlZ0qhx2n2oLqY//A/cq
	 KzBJh30qNHTw/2VPgQu4lxmrUgxUiJWt6sRHsOWKsNKTbeNc9/jlu/7QXeEgrwDc9Z
	 vHKGTxbzKsaZ9zTvdWWJ9/SriDzev74a4MP1KdaNVLlhyp4v2HsyNGuZZHCPZVpWTI
	 hHAC4d3lhZrYa8NXxGbqY7E1pPRz1lzdkE+4X7RG/kBcte4i0/OAOoHP3aPqtX6ze1
	 nsqNB5m23UFbG+iLQWR3ZirPmHYvp3Iv63yusA2CG9ErAL8pt7Cbcf52ckrPCXE3vG
	 EsaOyvPQDCEtg==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4j3xzX6Yz3z6txm;
	Tue, 13 Oct 2026 16:48:40 +0200 (CEST)
Message-ID: <037d7460eae92dd00f9283dd5595a3257212f0b9.camel@posteo.de>
Subject: Re: [PATCH v3 7/7] greybus: Add Rust UART node driver
From: Markus Probst <markus.probst@posteo.de>
To: Ayush Singh <ayush@beagleboard.org>, Jason Kridner	
 <jkridner@beagleboard.org>, robertcnelson@gmail.com, Johan Hovold	
 <johan@kernel.org>, Alex Elder <elder@kernel.org>, Greg Kroah-Hartman	
 <gregkh@linuxfoundation.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng	
 <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?ISO-8859-1?Q?Bj=F6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg	 <a.hindborg@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross	 <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, Daniel Almeida	 <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>,  Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?ISO-8859-1?Q?=D6zkan?= <work@onurozkan.dev>, Eric Biggers	
 <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Ayush Singh	
 <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski
	 <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Lorenzo Stoakes	
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett"	
 <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org
Date: Tue, 13 Oct 2026 14:48:45 +0000
In-Reply-To: <20261013-gb-uart-transport-v3-7-81d0a8a1acf7@beagleboard.org>
References: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
	 <20261013-gb-uart-transport-v3-7-81d0a8a1acf7@beagleboard.org>
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
 keydata=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
 jfGillcaQOqFZ3WwVqyzG1BUfTow==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-s2hQlaWvxNeAQBzcR+8c"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt


--=-s2hQlaWvxNeAQBzcR+8c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-10-13 at 17:30 +0530, Ayush Singh wrote:
> Add a driver for Greybus nodes attached over a plain serial port. The
> node is registered with the software SVC (gb-softsvc), which handles the
> SVC protocol on behalf of the AP, so no dedicated coprocessor running
> SVC firmware is needed.
>=20
> Greybus messages are carried over HDLC framing on the wire. Each frame
> carries a one-byte address (0x01 for Greybus) and control byte, followed
> by the 16-bit CPort ID and the Greybus message itself.
>=20
> Port parameters are taken from the firmware node: "baudrate" if
> present, otherwise 115200, with flow control and parity disabled.
>=20
> Since gb-uart-node imports types from gb-softsvc, Rust to Rust calling
> setup from nova-core [0] is being used.
>=20
> [0]: https://lore.kernel.org/all/20260622-nova-exports-v5-0-6191773fc977@=
nvidia.com/
>=20
> Signed-off-by: Ayush Singh <ayush@beagleboard.org>
> ---
>  MAINTAINERS                     |   1 +
>  drivers/greybus/.gitignore      |   1 +
>  drivers/greybus/Kconfig         |  15 +++
>  drivers/greybus/Makefile        |  48 ++++++++
>  drivers/greybus/gb_uart_node.rs | 253 ++++++++++++++++++++++++++++++++++=
++++++
>  5 files changed, 318 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 521bc6c67979..5bdd500ef63e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11527,6 +11527,7 @@ M:	Ayush Singh <ayush@beagleboard.org>
>  L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/beagle/beagle,beagleconnect-freedom=
.yaml
> +F:	drivers/greybus/gb_uart_node.rs
> =20
>  GREYBUS SUBSYSTEM
>  M:	Johan Hovold <johan@kernel.org>
> diff --git a/drivers/greybus/.gitignore b/drivers/greybus/.gitignore
> new file mode 100644
> index 000000000000..ff9c4a3539b4
> --- /dev/null
> +++ b/drivers/greybus/.gitignore
> @@ -0,0 +1 @@
> +exports_gb_softsvc_generated.h
> diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
> index 709563f8c0ad..ce2030161f30 100644
> --- a/drivers/greybus/Kconfig
> +++ b/drivers/greybus/Kconfig
> @@ -61,5 +61,20 @@ config GREYBUS_SOFTSVC
>  	  To compile this code as a module, choose M here: the module
>  	  will be called gb-softsvc.ko
> =20
> +config GREYBUS_UART_NODE
> +	tristate "Greybus UART node transport"
> +	depends on GREYBUS_SOFTSVC
> +	depends on RUST_SERIAL_DEV_BUS_ABSTRACTIONS
> +	depends on RUST_GREYBUS_ABSTRACTIONS
> +	select RUST_CRC_CCITT_ABSTRACTIONS
> +	help
> +	  Select this option if you have a Greybus node connected over a
> +	  serial port. The node is registered with the software SVC, which
> +	  handles the SVC protocol on behalf of the AP, so no dedicated
> +	  coprocessor running SVC firmware is required.
> +
> +	  To compile this code as a module, choose M here: the module
> +	  will be called gb-uart-node.ko
> +
>  endif	# GREYBUS
> =20
> diff --git a/drivers/greybus/Makefile b/drivers/greybus/Makefile
> index e6f594128802..bf4d08f728fe 100644
> --- a/drivers/greybus/Makefile
> +++ b/drivers/greybus/Makefile
> @@ -28,3 +28,51 @@ obj-$(CONFIG_GREYBUS_ES2)	+=3D gb-es2.o
>  obj-$(CONFIG_GREYBUS_SOFTSVC)	+=3D gb-softsvc.o
>  gb-softsvc-y			+=3D gb_softsvc.o gb_softsvc_exports.o
> =20
> +obj-$(CONFIG_GREYBUS_UART_NODE)	+=3D gb-uart-node.o
> +gb-uart-node-y			+=3D gb_uart_node.o
> +
> +# Export Rust symbols from gb-softsvc only if gb-uart-node actually refe=
rences them.
> +gb-softsvc-export-deps :=3D $(if $(CONFIG_GREYBUS_UART_NODE),$(obj)/gb_u=
art_node.o)
> +
> +rust_needed_exports =3D \
> +	{ $(if $(strip $(2)),$(NM) -u $(2);,) echo "__DEFINED_RUST_SYMBOLS__"; =
\
> +	  $(NM) -p --defined-only $(1); } | \
> +	awk -v fmt=3D'$(3)' ' \
> +		/^__DEFINED_RUST_SYMBOLS__$$/ { defs =3D 1; next } \
> +		!defs { if ($$NF ~ /^_R/) needed[$$NF] =3D 1; next } \
> +		defs && $$2 ~ /(T|R|D|B)/ && $$3 ~ /^_R/ && \
> +			$$3 !~ /_(init|cleanup)_module$$/ && \
> +			$$3 !~ /__(pfx|cfi|odr_asan)/ && \
> +			$$3 in needed { printf fmt, $$3 } \
> +	'
> +
> +quiet_cmd_exports =3D EXPORTS $@
> +      cmd_exports =3D \
> +	$(call rust_needed_exports,$<,$(gb-softsvc-export-deps),EXPORT_SYMBOL_R=
UST_GPL(%s);\n) > $@
> +
> +$(obj)/exports_gb_softsvc_generated.h: $(obj)/gb_softsvc.o $(gb-softsvc-=
export-deps) FORCE
> +	$(call if_changed,exports)
> +
> +targets +=3D exports_gb_softsvc_generated.h
> +
> +$(obj)/gb_softsvc_exports.o: $(obj)/exports_gb_softsvc_generated.h
> +CFLAGS_gb_softsvc_exports.o :=3D -I $(objtree)/$(obj)
> +
> +ifdef CONFIG_MODVERSIONS
> +# The C export shim declares Rust symbols as `extern int`, so reuse its =
export
> +# list but generate symbol CRCs from the Rust object instead of the shim=
's DWARF.
> +$(obj)/gb_softsvc_exports.o: private cmd_gensymtypes_c =3D \
> +	$(call getexportsymbols,\1) | \
> +	$(objtree)/scripts/gendwarfksyms/gendwarfksyms \
> +		$(if $(KBUILD_GENDWARFKSYMS_STABLE), --stable) \
> +		$(if $(KBUILD_SYMTYPES), --symtypes $(@:.o=3D.symtypes),) \
> +		$(obj)/gb_softsvc.o
> +endif
> +
> +# Output gb_softsvc's crate metadata for use by gb_uart_node at compile =
time.
> +RUSTFLAGS_gb_softsvc.o +=3D \
> +	--emit=3Dmetadata=3D$(objtree)/$(obj)/libgb_softsvc.rmeta
> +
> +# Allow nova-drm to import nova-core's types.
> +$(obj)/gb_uart_node.o: $(obj)/gb_softsvc.o
> +RUSTFLAGS_gb_uart_node.o :=3D -L $(objtree)/$(obj) --extern gb_softsvc
> diff --git a/drivers/greybus/gb_uart_node.rs b/drivers/greybus/gb_uart_no=
de.rs
> new file mode 100644
> index 000000000000..f719ee35e8f3
> --- /dev/null
> +++ b/drivers/greybus/gb_uart_node.rs
> @@ -0,0 +1,253 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Greybus UART Node driver
> +
> +use kernel::{
> +    alloc::Flags,
> +    crc_ccitt::crc_ccitt,
> +    device::{
> +        AsBusDevice,
> +        Bound,
> +        Core, //
> +    },
> +    error::code,
> +    new_spinlock,
> +    of, //
> +    prelude::*,
> +    serdev,
> +    sync::{
> +        aref::ARef,
> +        Arc,
> +        SpinLock, //
> +    },
> +};
> +
> +use zerocopy::little_endian;
> +use zerocopy_derive::{FromBytes, Immutable, KnownLayout};
> +
> +const HDLC_MAX_FRAME_LEN: usize =3D 256;
> +
> +const HDLC_FRAME: u8 =3D 0x7E;
> +const HDLC_ESC: u8 =3D 0x7D;
> +const HDLC_XOR: u8 =3D 0x20;
> +const HDLC_EXPECTED_CRC: u16 =3D 0xf0b8;
> +
> +const ADDRESS_GREYBUS: u8 =3D 0x01;
> +
> +#[repr(C, packed)]
> +#[derive(FromBytes, Immutable, KnownLayout)]
> +struct GreybusFrame {
> +    cport: little_endian::U16,
> +    msg: [u8],
> +}
> +
> +struct HdlcRx {
> +    rx_buf: KVec<u8>,
> +    rx_in_esc: bool,
> +    rx_overflow: bool,
> +    sdev: ARef<serdev::Device>,
> +    node: gb_softsvc::Module,
> +}
> +
> +impl HdlcRx {
> +    fn new(sdev: ARef<serdev::Device>, node: gb_softsvc::Module) -> Resu=
lt<Self> {
> +        Ok(Self {
> +            node,
> +            sdev,
> +            rx_buf: KVec::with_capacity(HDLC_MAX_FRAME_LEN, GFP_KERNEL)?=
,
> +            rx_in_esc: false,
> +            rx_overflow: false,
> +        })
> +    }
> +
> +    fn frame_finish(&self) -> Result<()> {
> +        if self.rx_buf.len() < 4 {
> +            return Err(code::EFAULT);
> +        }
> +
> +        let crc =3D crc_ccitt(0xffff, &self.rx_buf);
> +        if crc !=3D HDLC_EXPECTED_CRC {
> +            dev_warn!(self.sdev.as_ref(), "CRC failed {}", crc);
> +            return Ok(());
> +        }
> +
> +        let addr =3D self.rx_buf[0];
> +        let _ctrl =3D self.rx_buf[1];
> +        let payload =3D &self.rx_buf[2..self.rx_buf.len() - size_of::<u1=
6>()];
> +
> +        match addr {
> +            ADDRESS_GREYBUS =3D> {
> +                let frame =3D GreybusFrame::ref_from_bytes(payload).map_=
err(|_| code::EINVAL)?;
> +                self.node.submit_message(0, frame.cport.into(), &frame.m=
sg)
> +            }
> +            _ =3D> Err(code::EINVAL),
> +        }
> +    }
> +
> +    fn rx(&mut self, data: &[u8]) -> usize {
> +        for i in data.iter() {
> +            match *i {
> +                HDLC_FRAME =3D> {
> +                    if !self.rx_buf.is_empty() {
> +                        if let Err(e) =3D self.frame_finish() {
> +                            dev_warn!(self.sdev.as_ref(), "bad frame: {e=
:?}\n");
> +                        }
> +                    }
> +
> +                    self.rx_buf.clear();
> +                    self.rx_in_esc =3D false;
> +                    self.rx_overflow =3D false;
> +                }
> +                HDLC_ESC =3D> self.rx_in_esc =3D true,
> +                // Skip data if buffer has overflown.
> +                _ if self.rx_overflow =3D> {}
> +                _ =3D> {
> +                    let c =3D if self.rx_in_esc { *i ^ HDLC_XOR } else {=
 *i };
> +                    self.rx_in_esc =3D false;
> +
> +                    if self.rx_buf.push_within_capacity(c).is_err() {
> +                        dev_warn!(self.sdev.as_ref(), "buffer overflow. =
Dropping frame");
> +
> +                        self.rx_overflow =3D true;
> +                        self.rx_buf.clear();
> +                    }
> +                }
> +            }
> +        }
> +
> +        data.len()
> +    }
> +}
> +
> +struct GbNode {
> +    sdev: ARef<serdev::Device>,
> +}
> +
> +impl GbNode {
> +    const fn new(sdev: ARef<serdev::Device>) -> Self {
> +        Self { sdev }
> +    }
> +
> +    fn fill_buf(mut crc: u16, data: &[u8], buf: &mut KVec<u8>) -> Result=
<u16> {
> +        for i in data {
> +            crc =3D crc_ccitt(crc, &[*i]);
> +            if *i =3D=3D HDLC_ESC || *i =3D=3D HDLC_FRAME {
> +                buf.push_within_capacity(HDLC_ESC)?;
> +                buf.push_within_capacity(i ^ HDLC_XOR)?;
> +            } else {
> +                buf.push_within_capacity(*i)?;
> +            }
> +        }
> +
> +        Ok(crc)
> +    }
> +}
> +
> +impl gb_softsvc::InterfaceOps for GbNode {
> +    fn write(&self, data: &[u8], cport: u16, gfp_mask: Flags) -> Result<=
()> {
> +        // SAFETY: `GbNode` only exists while its serdev driver is bound=
, so the device is in the
> +        // `Bound` state for the duration of this call.
> +        let bound: &serdev::Device<Bound> =3D
> +            unsafe { serdev::Device::from_device(self.sdev.as_ref().as_b=
ound()) };
> +
> +        let mut buf =3D KVec::with_capacity(HDLC_MAX_FRAME_LEN, gfp_mask=
)?;
> +
> +        let mut crc =3D 0xffff;
> +
> +        buf.push_within_capacity(HDLC_FRAME)?;
> +
> +        crc =3D Self::fill_buf(crc, &[ADDRESS_GREYBUS, 0x03], &mut buf)?=
;
> +        crc =3D Self::fill_buf(crc, &cport.to_le_bytes(), &mut buf)?;
> +        crc =3D Self::fill_buf(crc, data, &mut buf)?;
> +
> +        crc ^=3D 0xffff;
> +        Self::fill_buf(crc, &crc.to_le_bytes(), &mut buf)?;
> +
> +        buf.push_within_capacity(HDLC_FRAME)?;
> +
> +        bound.write_all(&buf, 0)?;
> +
> +        Ok(())
> +    }
> +}
> +
> +#[pin_data]
> +struct GbUartNode {
> +    #[pin]
> +    rx: SpinLock<Option<HdlcRx>>,
> +}
> +
> +impl GbUartNode {
> +    fn init(sdev: &serdev::Device<Core<'_>>) -> Result<HdlcRx> {
> +        if sdev
> +            .set_baudrate(
> +                sdev.as_ref()
> +                    .fwnode()
> +                    .and_then(|fwnode| fwnode.property_read(c"baudrate")=
.optional())
> +                    .unwrap_or(115200),
> +            )
> +            .is_err()
> +        {
> +            return Err(EINVAL);
> +        }
> +        sdev.set_flow_control(false);
> +        sdev.set_parity(serdev::Parity::None)?;
> +
> +        let node =3D gb_softsvc::Module::new(&[Arc::new(GbNode::new(sdev=
.into()), GFP_KERNEL)?])?;
> +
> +        HdlcRx::new(sdev.into(), node)
> +    }
> +}
> +
> +kernel::of_device_table!(
> +    OF_TABLE,
> +    <GbUartNode as serdev::Driver>::IdInfo,
> +    [(of::DeviceId::new(c"beagle,beagleconnect-freedom"), ())]
> +);
> +
> +#[vtable]
> +impl serdev::Driver for GbUartNode {
> +    type IdInfo =3D ();
> +    type Data<'bound> =3D Self;
> +    const OF_ID_TABLE: Option<of::IdTable<Self::IdInfo>> =3D Some(&OF_TA=
BLE);
> +
> +    fn probe<'bound>(
> +        sdev: &'bound serdev::Device<Core<'_>>,
> +        _info: Option<&'bound Self::IdInfo>,
> +    ) -> impl PinInit<Self, Error> + 'bound {
> +        dev_dbg!(sdev.as_ref(), "Probe gb_uart_node.\n");
> +
> +        try_pin_init!(Self {
> +            rx <- new_spinlock!(Some(Self::init(sdev)?), "gb_uart_node::=
rx"),
> +        }? Error)
> +    }
> +
> +    fn receive<'bound>(
> +        _sdev: &'bound serdev::Device<Bound>,
> +        this: Pin<&Self>,
> +        data: &[u8],
> +    ) -> usize {
> +        if let Some(mut guard) =3D this.rx.try_lock() {
> +            if let Some(ref mut hdlc_rx) =3D *guard {
> +                return hdlc_rx.rx(data);
> +            }
> +        }
> +
> +        0
> +    }
> +
> +    fn unbind<'bound>(_: &'bound serdev::Device<Core<'_>>, this: Pin<&Se=
lf::Data<'bound>>) {
> +        // Getting a bound device is not possible after this point. So d=
rop HdlcRx.
> +        // This also drops HdlcRx::node, which should ensure that GbNode=
::write will not be called
> +        // after this point.
> +        let _ =3D this.rx.lock().take();
Not exactly.

e.g.
```
struct SerdevDriver<'bound> {
  dev: &'bound serdev::Device<Bound>,
}

impl<'bound> Drop for SerdevDriver<'bound> {

  fn drop(&mut self) {
    // Access to a bound device should still be possible here.
  }

}
```

So afaik there should be no advantage of manually dropping it here.
Drop of `GbUartNode` should automatically drop the spinlock and the
data contained. The bound serial device is still valid at this point.

This would likely make the usage of Option<> obsolete too.

Thanks
- Markus Probst

> +    }
> +}
> +
> +kernel::module_serdev_device_driver! {
> +    type: GbUartNode,
> +    name: "gb_uart_node",
> +    authors: ["Ayush Singh <ayush@beagleboard.org>"],
> +    description: "Greybus node connected over UART",
> +    license: "GPL v2",
> +}

--=-s2hQlaWvxNeAQBzcR+8c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQJPBAABCAA5FiEEgnQYxPSsWOdyMMRzNHYf+OetQ9IFAmrORMgbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyAAoJEDR2H/jnrUPShvQP/RgPwh2sXkj8Wwfjp2VD
ALdPBLJjaqiua/gz40bnNHcUuJi48E26eIHMQeY//Cyo+ofEPggwum55EzqoRC8Z
n3COhoW6MaALYaijS09rtzDpGV/MSPgYJkizBExcwZ8AZmMAG8OY/+6kGkXsehbK
kwU6RWNizq9JCSh2rY3GcR0GttnIV0Zt4W7VmRn595ecTfXdxb2wp5sS+kn6SxHN
ShgGAf8j2nYXrMrACIYAf/DSkuo8oEHHO2zeNJwA+N7DOxQ1vGrzpgj00+Qaw+Sv
ORR+C3Z/pOyCVaVRNi3T2D27GgG+94wTx1OM2U7fdSgh1xW9IoIzSRZdD0jw4wof
gEQ+o6chqw2yRSyN4MDKMMf5Fi9HnI/EuAhD6/RNhbmJT8m+Gw2iRS12ioBrNNgM
gMDONU435I4FFhMEHMhQjBb7jQaBTFk1iCj5V0+pU1aLWJd65/wiGsqNmqxby24h
VeRenVFB72AUBqT3fheiQiEEEdjpf+i1jg6/GXcPCvkDk5rnvY2+oFOnZuWOy3fX
oqVasPFXe/EaJ7EWJXC1LoK8ycI5PVT5b1/4nMFY9tAzGxqihboJjccFuNqT7lc+
RiXMPGFz9MydTQAGBAUXGSyHfNlW/evD4uQ1N0HgIroi897WJG7N8vGXYNWfj9xI
wrJvxgMMsTXnjAylHsyMuwxy
=5QyA
-----END PGP SIGNATURE-----

--=-s2hQlaWvxNeAQBzcR+8c--
