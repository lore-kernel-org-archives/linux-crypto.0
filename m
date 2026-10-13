Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0DA50B8DB
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 16:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791909012; cv=none; b=uuRdwQhAHxOCITA07AHUYPOTCrT/b0TbRDXW+VBTvtM3C52HUBflxHr0Y8x8HrFp0mN1Tb48gDipMN3N+T+9XgvYzLMKkwiMkveYQg3D7EsZLdhxV6yu0TSkYSByv9nNe+aW7GXYLuVMkeXUj8xH9nsAhB7YBJlhvd4uCWs55ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791909012; c=relaxed/simple;
	bh=X7JX2w4ntvIjGzutatsHkx+z8Tbd85g8maN+5Y+xR0k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=blZHwRFi6HHalj4hU8RubaewNWI6+ErDMw0VaEVsE0b7k7purOXOumRTlH+sYKlkZfIiwKY81Ynqkdn0V8lzM/eZP7E9RzoavbbcaYglXPc+qJm6GLFFbGU/ykliV5ao3F/QHlV/ja/r4aZ6Ok8DCvTsSKURO9+ULizv3uUYlzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=ZSYUdf8n; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="ZSYUdf8n"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cd5e6f0a22bso19751a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 09:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1791909009; x=1792513809; darn=vger.kernel.org;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tcud5Etzhncfi8d+BnzJtSoqh1QBRSXr7BSsTwrb8t8=;
        b=ZSYUdf8n4q3ULNNbNRT20fJrItRlst3fRmF4V2LLp7g0xJCrJ6C+uMr/biKPQPPo+U
         vXPMqZaT2p8/bgUxes82r3DJfXl9wjeVn00QRsTZveJQ28wJbp8VGykF9CH0egUQcUQW
         Fbdunwa5cVq+UJUm2KJTqiw7JP3OhRsIJwQPDtOuD7+obxsjA28ka1+QxctyAawRMyEn
         kDDFPWt1sMLxd6OxGjDG5SmO9QuSEQ4xHeH9oMsU8TX4xvKwHhZRsKI//as+Ft10/iQz
         4KF4yyxEJLFcTnR94zdE2JdzC5aFhPY79L0gGNTgmViYolGb5PV6YApU0cxSI+T52moj
         JqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791909009; x=1792513809;
        h=content-type:mime-version:user-agent:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=tcud5Etzhncfi8d+BnzJtSoqh1QBRSXr7BSsTwrb8t8=;
        b=J4FzfkOFHD0ScNOJQOA3cVmnjXuIZpWxCRjwTyUsGjBa/lvtg05cwQ4OSIoQY6Gpzl
         vzvUu2PlWet9Elggkq8BhyXZruzo0tHJa1upac3qOBUf7lhlRCxEDfXOO3Fb0pTAaaCa
         DTVrkPRi1xnzwlKvBa5rSkcHhGwQPv25Ns7AIh/c6HHLUFbGxk7/jBrVohO5nio77UWn
         4zuOxl+Qu+B02nkLCZhBCpVgZTvHZrvASMf4Sh2x9xnxYCu3L/LbdACEZFoui8VY0jIe
         4s3OTXrwkLXygKoWBf+lmhStdELb7Ar3xSoytIxYTb8a/3G29HXsX4YPyaCfpzosxH4N
         YTjQ==
X-Forwarded-Encrypted: i=1; AKwUvByzmPej6PMDx8FGQL5mC5yO9fnHyYz5+8ZXYdcQJEndaw8JUPoHzHPCONJSWOYdnLa5tPFoEfaTWi+2Ims=@vger.kernel.org
X-Gm-Message-State: AFq9FYI1Ao7SEKKXFMXV7y0xY4wzf6tobbMx4XNx2WWfxCOPhPlTSLQ8
	ODLUe45OwEJEnxEZKUJRw0f+TcZgbsKXXieMSoApNhjoq5p9ja0ljMqRs7hGNvx17w==
X-Gm-Gg: AYBFou0XNmGzvyzNx404/12G6dvnYsFREebTJp+HPTQNeigtWdcHNqWeT/Cm2ewa5Ai
	lIQU/tgD4p48EveRkHyQBJxP2yIqUhzNCmXn7bU7HxBYthv3ser+VfO4oCzT1uxkP7Ddx79osqT
	HR86OuFm4KyKncQxhzP6tCowbw33UuCeWvetF2wL0HePVba0KuUUbFJUquC7JUBudFvqgsRWWWL
	+dIThIQI6UBKRZEDtT8RLaxsdNMRQrdU6dSuBBx8+nsaQsCewa5gNSpXcdsbJQexwlLBP3pA7e7
	Dkl1vrUHSpwow0ED3eTd4T/evkY7WydE9ioc97xn6R3UOlEOn9BmMItJCT3/ELWqXPdIvJocXlY
	A7r1kES/OEoqZe+rhS1Mc6LxjcBtQrGp9tnNx/+FiBqm0i2mG/dp00DnLSPv8OGroboiNFISgTh
	0gUh71mn2I0awmheWlzC4I/yZOUXcJv0bbb7c1FRy0p/kbdqtB4WND4cv9VNMeKDIVi2O/c0vd
X-Received: by 2002:a05:6a20:9c15:b0:3e0:bbb8:bbdb with SMTP id adf61e73a8af0-3e16be9eb80mr11365286637.47.1791909008452;
        Tue, 13 Oct 2026 09:30:08 -0700 (PDT)
Received: from fedorapc ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd61fc465c3sm813399a12.27.2026.10.13.09.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 09:30:07 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
To: Markus Probst <markus.probst@posteo.de>
Cc: Ayush Singh <ayush@beagleboard.org>,  Jason Kridner
 <jkridner@beagleboard.org>,  robertcnelson@gmail.com,  Johan Hovold
 <johan@kernel.org>,  Alex Elder <elder@kernel.org>,  Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,  Miguel Ojeda <ojeda@kernel.org>,  Boqun
 Feng <boqun@kernel.org>,  Gary Guo <gary@garyguo.net>,  =?utf-8?Q?Bj?=
 =?utf-8?Q?=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,  Benno Lossin <lossin@kernel.org>,  Andreas
 Hindborg <a.hindborg@kernel.org>,  Alice Ryhl <aliceryhl@google.com>,
  Trevor Gross <tmgross@umich.edu>,  Danilo Krummrich <dakr@kernel.org>,
  Daniel Almeida <daniel.almeida@collabora.com>,  Tamir Duberstein
 <tamird@kernel.org>,  Alexandre Courbot <acourbot@nvidia.com>,  Onur
 =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>,  Eric Biggers <ebiggers@kernel.org>,  Ard Biesheuvel
 <ardb@kernel.org>,  Ayush Singh <ayush@beagleboard.com>,  Rob Herring
 <robh@kernel.org>,  Krzysztof Kozlowski <krzk+dt@kernel.org>,  Conor
 Dooley <conor+dt@kernel.org>,  Lorenzo Stoakes <ljs@kernel.org>,
  Vlastimil Babka <vbabka@kernel.org>,  "Liam R. Howlett"
 <liam@infradead.org>,  Uladzislau Rezki <urezki@gmail.com>,
  greybus-dev@lists.linaro.org,  linux-kernel@vger.kernel.org,
  rust-for-linux@vger.kernel.org,  linux-crypto@vger.kernel.org,
  devicetree@vger.kernel.org
Subject: Re: [PATCH v3 7/7] greybus: Add Rust UART node driver
In-Reply-To: <037d7460eae92dd00f9283dd5595a3257212f0b9.camel@posteo.de>
	(Markus Probst's message of "Tue, 13 Oct 2026 14:48:45 +0000")
References: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
	<20261013-gb-uart-transport-v3-7-81d0a8a1acf7@beagleboard.org>
	<037d7460eae92dd00f9283dd5595a3257212f0b9.camel@posteo.de>
Date: Tue, 13 Oct 2026 21:59:56 +0530
Message-ID: <87y0c14l8b.fsf@beagleboard.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Markus Probst <markus.probst@posteo.de> writes:

> On Tue, 2026-10-13 at 17:30 +0530, Ayush Singh wrote:
>> Add a driver for Greybus nodes attached over a plain serial port. The
>> node is registered with the software SVC (gb-softsvc), which handles the
>> SVC protocol on behalf of the AP, so no dedicated coprocessor running
>> SVC firmware is needed.
>> 
>> Greybus messages are carried over HDLC framing on the wire. Each frame
>> carries a one-byte address (0x01 for Greybus) and control byte, followed
>> by the 16-bit CPort ID and the Greybus message itself.
>> 
>> Port parameters are taken from the firmware node: "baudrate" if
>> present, otherwise 115200, with flow control and parity disabled.
>> 
>> Since gb-uart-node imports types from gb-softsvc, Rust to Rust calling
>> setup from nova-core [0] is being used.
>> 
>> [0]: https://lore.kernel.org/all/20260622-nova-exports-v5-0-6191773fc977@nvidia.com/
>> 
>> Signed-off-by: Ayush Singh <ayush@beagleboard.org>
>> ---
>>  MAINTAINERS                     |   1 +
>>  drivers/greybus/.gitignore      |   1 +
>>  drivers/greybus/Kconfig         |  15 +++
>>  drivers/greybus/Makefile        |  48 ++++++++
>>  drivers/greybus/gb_uart_node.rs | 253 ++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 318 insertions(+)
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 521bc6c67979..5bdd500ef63e 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -11527,6 +11527,7 @@ M:	Ayush Singh <ayush@beagleboard.org>
>>  L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
>>  S:	Maintained
>>  F:	Documentation/devicetree/bindings/beagle/beagle,beagleconnect-freedom.yaml
>> +F:	drivers/greybus/gb_uart_node.rs
>>  
>>  GREYBUS SUBSYSTEM
>>  M:	Johan Hovold <johan@kernel.org>
>> diff --git a/drivers/greybus/.gitignore b/drivers/greybus/.gitignore
>> new file mode 100644
>> index 000000000000..ff9c4a3539b4
>> --- /dev/null
>> +++ b/drivers/greybus/.gitignore
>> @@ -0,0 +1 @@
>> +exports_gb_softsvc_generated.h
>> diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
>> index 709563f8c0ad..ce2030161f30 100644
>> --- a/drivers/greybus/Kconfig
>> +++ b/drivers/greybus/Kconfig
>> @@ -61,5 +61,20 @@ config GREYBUS_SOFTSVC
>>  	  To compile this code as a module, choose M here: the module
>>  	  will be called gb-softsvc.ko
>>  
>> +config GREYBUS_UART_NODE
>> +	tristate "Greybus UART node transport"
>> +	depends on GREYBUS_SOFTSVC
>> +	depends on RUST_SERIAL_DEV_BUS_ABSTRACTIONS
>> +	depends on RUST_GREYBUS_ABSTRACTIONS
>> +	select RUST_CRC_CCITT_ABSTRACTIONS
>> +	help
>> +	  Select this option if you have a Greybus node connected over a
>> +	  serial port. The node is registered with the software SVC, which
>> +	  handles the SVC protocol on behalf of the AP, so no dedicated
>> +	  coprocessor running SVC firmware is required.
>> +
>> +	  To compile this code as a module, choose M here: the module
>> +	  will be called gb-uart-node.ko
>> +
>>  endif	# GREYBUS
>>  
>> diff --git a/drivers/greybus/Makefile b/drivers/greybus/Makefile
>> index e6f594128802..bf4d08f728fe 100644
>> --- a/drivers/greybus/Makefile
>> +++ b/drivers/greybus/Makefile
>> @@ -28,3 +28,51 @@ obj-$(CONFIG_GREYBUS_ES2)	+= gb-es2.o
>>  obj-$(CONFIG_GREYBUS_SOFTSVC)	+= gb-softsvc.o
>>  gb-softsvc-y			+= gb_softsvc.o gb_softsvc_exports.o
>>  
>> +obj-$(CONFIG_GREYBUS_UART_NODE)	+= gb-uart-node.o
>> +gb-uart-node-y			+= gb_uart_node.o
>> +
>> +# Export Rust symbols from gb-softsvc only if gb-uart-node actually references them.
>> +gb-softsvc-export-deps := $(if $(CONFIG_GREYBUS_UART_NODE),$(obj)/gb_uart_node.o)
>> +
>> +rust_needed_exports = \
>> +	{ $(if $(strip $(2)),$(NM) -u $(2);,) echo "__DEFINED_RUST_SYMBOLS__"; \
>> +	  $(NM) -p --defined-only $(1); } | \
>> +	awk -v fmt='$(3)' ' \
>> +		/^__DEFINED_RUST_SYMBOLS__$$/ { defs = 1; next } \
>> +		!defs { if ($$NF ~ /^_R/) needed[$$NF] = 1; next } \
>> +		defs && $$2 ~ /(T|R|D|B)/ && $$3 ~ /^_R/ && \
>> +			$$3 !~ /_(init|cleanup)_module$$/ && \
>> +			$$3 !~ /__(pfx|cfi|odr_asan)/ && \
>> +			$$3 in needed { printf fmt, $$3 } \
>> +	'
>> +
>> +quiet_cmd_exports = EXPORTS $@
>> +      cmd_exports = \
>> +	$(call rust_needed_exports,$<,$(gb-softsvc-export-deps),EXPORT_SYMBOL_RUST_GPL(%s);\n) > $@
>> +
>> +$(obj)/exports_gb_softsvc_generated.h: $(obj)/gb_softsvc.o $(gb-softsvc-export-deps) FORCE
>> +	$(call if_changed,exports)
>> +
>> +targets += exports_gb_softsvc_generated.h
>> +
>> +$(obj)/gb_softsvc_exports.o: $(obj)/exports_gb_softsvc_generated.h
>> +CFLAGS_gb_softsvc_exports.o := -I $(objtree)/$(obj)
>> +
>> +ifdef CONFIG_MODVERSIONS
>> +# The C export shim declares Rust symbols as `extern int`, so reuse its export
>> +# list but generate symbol CRCs from the Rust object instead of the shim's DWARF.
>> +$(obj)/gb_softsvc_exports.o: private cmd_gensymtypes_c = \
>> +	$(call getexportsymbols,\1) | \
>> +	$(objtree)/scripts/gendwarfksyms/gendwarfksyms \
>> +		$(if $(KBUILD_GENDWARFKSYMS_STABLE), --stable) \
>> +		$(if $(KBUILD_SYMTYPES), --symtypes $(@:.o=.symtypes),) \
>> +		$(obj)/gb_softsvc.o
>> +endif
>> +
>> +# Output gb_softsvc's crate metadata for use by gb_uart_node at compile time.
>> +RUSTFLAGS_gb_softsvc.o += \
>> +	--emit=metadata=$(objtree)/$(obj)/libgb_softsvc.rmeta
>> +
>> +# Allow nova-drm to import nova-core's types.
>> +$(obj)/gb_uart_node.o: $(obj)/gb_softsvc.o
>> +RUSTFLAGS_gb_uart_node.o := -L $(objtree)/$(obj) --extern gb_softsvc
>> diff --git a/drivers/greybus/gb_uart_node.rs b/drivers/greybus/gb_uart_node.rs
>> new file mode 100644
>> index 000000000000..f719ee35e8f3
>> --- /dev/null
>> +++ b/drivers/greybus/gb_uart_node.rs
>> @@ -0,0 +1,253 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +//! Greybus UART Node driver
>> +
>> +use kernel::{
>> +    alloc::Flags,
>> +    crc_ccitt::crc_ccitt,
>> +    device::{
>> +        AsBusDevice,
>> +        Bound,
>> +        Core, //
>> +    },
>> +    error::code,
>> +    new_spinlock,
>> +    of, //
>> +    prelude::*,
>> +    serdev,
>> +    sync::{
>> +        aref::ARef,
>> +        Arc,
>> +        SpinLock, //
>> +    },
>> +};
>> +
>> +use zerocopy::little_endian;
>> +use zerocopy_derive::{FromBytes, Immutable, KnownLayout};
>> +
>> +const HDLC_MAX_FRAME_LEN: usize = 256;
>> +
>> +const HDLC_FRAME: u8 = 0x7E;
>> +const HDLC_ESC: u8 = 0x7D;
>> +const HDLC_XOR: u8 = 0x20;
>> +const HDLC_EXPECTED_CRC: u16 = 0xf0b8;
>> +
>> +const ADDRESS_GREYBUS: u8 = 0x01;
>> +
>> +#[repr(C, packed)]
>> +#[derive(FromBytes, Immutable, KnownLayout)]
>> +struct GreybusFrame {
>> +    cport: little_endian::U16,
>> +    msg: [u8],
>> +}
>> +
>> +struct HdlcRx {
>> +    rx_buf: KVec<u8>,
>> +    rx_in_esc: bool,
>> +    rx_overflow: bool,
>> +    sdev: ARef<serdev::Device>,
>> +    node: gb_softsvc::Module,
>> +}
>> +
>> +impl HdlcRx {
>> +    fn new(sdev: ARef<serdev::Device>, node: gb_softsvc::Module) -> Result<Self> {
>> +        Ok(Self {
>> +            node,
>> +            sdev,
>> +            rx_buf: KVec::with_capacity(HDLC_MAX_FRAME_LEN, GFP_KERNEL)?,
>> +            rx_in_esc: false,
>> +            rx_overflow: false,
>> +        })
>> +    }
>> +
>> +    fn frame_finish(&self) -> Result<()> {
>> +        if self.rx_buf.len() < 4 {
>> +            return Err(code::EFAULT);
>> +        }
>> +
>> +        let crc = crc_ccitt(0xffff, &self.rx_buf);
>> +        if crc != HDLC_EXPECTED_CRC {
>> +            dev_warn!(self.sdev.as_ref(), "CRC failed {}", crc);
>> +            return Ok(());
>> +        }
>> +
>> +        let addr = self.rx_buf[0];
>> +        let _ctrl = self.rx_buf[1];
>> +        let payload = &self.rx_buf[2..self.rx_buf.len() - size_of::<u16>()];
>> +
>> +        match addr {
>> +            ADDRESS_GREYBUS => {
>> +                let frame = GreybusFrame::ref_from_bytes(payload).map_err(|_| code::EINVAL)?;
>> +                self.node.submit_message(0, frame.cport.into(), &frame.msg)
>> +            }
>> +            _ => Err(code::EINVAL),
>> +        }
>> +    }
>> +
>> +    fn rx(&mut self, data: &[u8]) -> usize {
>> +        for i in data.iter() {
>> +            match *i {
>> +                HDLC_FRAME => {
>> +                    if !self.rx_buf.is_empty() {
>> +                        if let Err(e) = self.frame_finish() {
>> +                            dev_warn!(self.sdev.as_ref(), "bad frame: {e:?}\n");
>> +                        }
>> +                    }
>> +
>> +                    self.rx_buf.clear();
>> +                    self.rx_in_esc = false;
>> +                    self.rx_overflow = false;
>> +                }
>> +                HDLC_ESC => self.rx_in_esc = true,
>> +                // Skip data if buffer has overflown.
>> +                _ if self.rx_overflow => {}
>> +                _ => {
>> +                    let c = if self.rx_in_esc { *i ^ HDLC_XOR } else { *i };
>> +                    self.rx_in_esc = false;
>> +
>> +                    if self.rx_buf.push_within_capacity(c).is_err() {
>> +                        dev_warn!(self.sdev.as_ref(), "buffer overflow. Dropping frame");
>> +
>> +                        self.rx_overflow = true;
>> +                        self.rx_buf.clear();
>> +                    }
>> +                }
>> +            }
>> +        }
>> +
>> +        data.len()
>> +    }
>> +}
>> +
>> +struct GbNode {
>> +    sdev: ARef<serdev::Device>,
>> +}
>> +
>> +impl GbNode {
>> +    const fn new(sdev: ARef<serdev::Device>) -> Self {
>> +        Self { sdev }
>> +    }
>> +
>> +    fn fill_buf(mut crc: u16, data: &[u8], buf: &mut KVec<u8>) -> Result<u16> {
>> +        for i in data {
>> +            crc = crc_ccitt(crc, &[*i]);
>> +            if *i == HDLC_ESC || *i == HDLC_FRAME {
>> +                buf.push_within_capacity(HDLC_ESC)?;
>> +                buf.push_within_capacity(i ^ HDLC_XOR)?;
>> +            } else {
>> +                buf.push_within_capacity(*i)?;
>> +            }
>> +        }
>> +
>> +        Ok(crc)
>> +    }
>> +}
>> +
>> +impl gb_softsvc::InterfaceOps for GbNode {
>> +    fn write(&self, data: &[u8], cport: u16, gfp_mask: Flags) -> Result<()> {
>> +        // SAFETY: `GbNode` only exists while its serdev driver is bound, so the device is in the
>> +        // `Bound` state for the duration of this call.
>> +        let bound: &serdev::Device<Bound> =
>> +            unsafe { serdev::Device::from_device(self.sdev.as_ref().as_bound()) };
>> +
>> +        let mut buf = KVec::with_capacity(HDLC_MAX_FRAME_LEN, gfp_mask)?;
>> +
>> +        let mut crc = 0xffff;
>> +
>> +        buf.push_within_capacity(HDLC_FRAME)?;
>> +
>> +        crc = Self::fill_buf(crc, &[ADDRESS_GREYBUS, 0x03], &mut buf)?;
>> +        crc = Self::fill_buf(crc, &cport.to_le_bytes(), &mut buf)?;
>> +        crc = Self::fill_buf(crc, data, &mut buf)?;
>> +
>> +        crc ^= 0xffff;
>> +        Self::fill_buf(crc, &crc.to_le_bytes(), &mut buf)?;
>> +
>> +        buf.push_within_capacity(HDLC_FRAME)?;
>> +
>> +        bound.write_all(&buf, 0)?;
>> +
>> +        Ok(())
>> +    }
>> +}
>> +
>> +#[pin_data]
>> +struct GbUartNode {
>> +    #[pin]
>> +    rx: SpinLock<Option<HdlcRx>>,
>> +}
>> +
>> +impl GbUartNode {
>> +    fn init(sdev: &serdev::Device<Core<'_>>) -> Result<HdlcRx> {
>> +        if sdev
>> +            .set_baudrate(
>> +                sdev.as_ref()
>> +                    .fwnode()
>> +                    .and_then(|fwnode| fwnode.property_read(c"baudrate").optional())
>> +                    .unwrap_or(115200),
>> +            )
>> +            .is_err()
>> +        {
>> +            return Err(EINVAL);
>> +        }
>> +        sdev.set_flow_control(false);
>> +        sdev.set_parity(serdev::Parity::None)?;
>> +
>> +        let node = gb_softsvc::Module::new(&[Arc::new(GbNode::new(sdev.into()), GFP_KERNEL)?])?;
>> +
>> +        HdlcRx::new(sdev.into(), node)
>> +    }
>> +}
>> +
>> +kernel::of_device_table!(
>> +    OF_TABLE,
>> +    <GbUartNode as serdev::Driver>::IdInfo,
>> +    [(of::DeviceId::new(c"beagle,beagleconnect-freedom"), ())]
>> +);
>> +
>> +#[vtable]
>> +impl serdev::Driver for GbUartNode {
>> +    type IdInfo = ();
>> +    type Data<'bound> = Self;
>> +    const OF_ID_TABLE: Option<of::IdTable<Self::IdInfo>> = Some(&OF_TABLE);
>> +
>> +    fn probe<'bound>(
>> +        sdev: &'bound serdev::Device<Core<'_>>,
>> +        _info: Option<&'bound Self::IdInfo>,
>> +    ) -> impl PinInit<Self, Error> + 'bound {
>> +        dev_dbg!(sdev.as_ref(), "Probe gb_uart_node.\n");
>> +
>> +        try_pin_init!(Self {
>> +            rx <- new_spinlock!(Some(Self::init(sdev)?), "gb_uart_node::rx"),
>> +        }? Error)
>> +    }
>> +
>> +    fn receive<'bound>(
>> +        _sdev: &'bound serdev::Device<Bound>,
>> +        this: Pin<&Self>,
>> +        data: &[u8],
>> +    ) -> usize {
>> +        if let Some(mut guard) = this.rx.try_lock() {
>> +            if let Some(ref mut hdlc_rx) = *guard {
>> +                return hdlc_rx.rx(data);
>> +            }
>> +        }
>> +
>> +        0
>> +    }
>> +
>> +    fn unbind<'bound>(_: &'bound serdev::Device<Core<'_>>, this: Pin<&Self::Data<'bound>>) {
>> +        // Getting a bound device is not possible after this point. So drop HdlcRx.
>> +        // This also drops HdlcRx::node, which should ensure that GbNode::write will not be called
>> +        // after this point.
>> +        let _ = this.rx.lock().take();
> Not exactly.
>
> e.g.
> ```
> struct SerdevDriver<'bound> {
>   dev: &'bound serdev::Device<Bound>,
> }
>
> impl<'bound> Drop for SerdevDriver<'bound> {
>
>   fn drop(&mut self) {
>     // Access to a bound device should still be possible here.
>   }
>
> }
> ```
>
> So afaik there should be no advantage of manually dropping it here.
> Drop of `GbUartNode` should automatically drop the spinlock and the
> data contained. The bound serial device is still valid at this point.
>
> This would likely make the usage of Option<> obsolete too.
>
> Thanks
> - Markus Probst

My understanding was that the state of serdev device is unknown between
unbind and Drop calls. That would make the unsafe Bound device conversion
in GbNode::write unsound.

If I don't need to do the early drop, yes, that would remove the Option
which would be great.

>
>> +    }
>> +}
>> +
>> +kernel::module_serdev_device_driver! {
>> +    type: GbUartNode,
>> +    name: "gb_uart_node",
>> +    authors: ["Ayush Singh <ayush@beagleboard.org>"],
>> +    description: "Greybus node connected over UART",
>> +    license: "GPL v2",
>> +}
>


Best Regards,
Ayush Singh

-- 
BeagleBoard.org Foundation
https://www.beagleboard.org
