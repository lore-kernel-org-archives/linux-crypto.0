Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07244052B3
	for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2026 05:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499099; cv=none; b=m1YuprLI7iaPFg5lvlcNjl6hHXjLoavFxZqkHhbcYGucwr6L6JB5eBcdpgAYdi3DAnSquO7wFffV4SRXDZSgiaq7cvIie+5byvJQ977WSbR+EwbBKPS0R8yu7iNB4kth6oukG2Yd/G9F6c39sToZG4RU5DTgiquGZ9gMD/QW2u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499099; c=relaxed/simple;
	bh=PVZ9eHReuYnTMoyciAfMl+RD98428HxfjYeb9Wer9fo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ufo8IEO48dMIAQXvtsJsiyQNTRNqaAZv1YL0CNVdVwoGBy2cp9YC29gA6BQh2VUmLHMkkMQqeh46Tr/NfDfZzQ5aLTPsnjb29qx1A2KWj56bHX8HXQLRorVBg7wCrOiwk2AM/KRLU7oSz7Je1pStYc7b4AdvCZCpw9nYq+T4Cgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=NjhBSzJ3; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="NjhBSzJ3"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d944747d41so7364685ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 03 Sep 2026 22:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1788499096; x=1789103896; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z2hQFqjUjUJQ8GhG2goFYJH6oWr2LV0yBObso/k+lbM=;
        b=NjhBSzJ35RF9q3X79+Ui7hi/Zm1kF7BqFPbFFfxSQX7SpXymfN5zapcPR/Bevnd/OZ
         9+rMLuDquz0hKEyQ49/a7Zqy7eI1s1TcrTiaaZ3V1S62arefZoeNrrRz3r3Py5SaZz8Q
         iqGaB+n5NO8L+jWElFLJQZ/Lx6PwnBe9lhqQzIJ3a/B+Is7Zw5DoZSdaS672oAGk35C8
         l1qUobg3bF6dAdqGWIw6tkNKW7hD46CeMwkOnA/txSPnMR8xNz2i4J4T/SSmujb3Ztnw
         BMRRXSH5Q3VVQ0dUn+Ysa9ikZA0fWDerLJ4kqEW+YacDBGBZELYsZwzeGY9DU+00T8vK
         tPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788499096; x=1789103896;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z2hQFqjUjUJQ8GhG2goFYJH6oWr2LV0yBObso/k+lbM=;
        b=lS33tLYp4f4IpyZXB6E4Dtan+g/pfMg1WOt3eDE+evVuoy1tl+loVZXYS/wR8Urdb2
         xVQ4P6RFAPFcOtq4UdK35CIHafpqCDjBmce0HkZMUAvIKS8iyanfue6YFqJQ6dAIAdie
         p/KUSNv0UKR6AQarX3XWjNyewCduibUdQkkNzrUJkOzzNXwMEGd+jX5oR3Pnhf7BVSxC
         GXI3qMGN3o+M3QgDRG7qcMfumTR7BMtH3dzrNpnNV2IetELRW4Q4FYNvnzg9jg61cQzW
         Hz3hLlT4X+xOElIFP6hw3zJ4Z7D6VjnYGAw15CfQqqdNaaRzrBJQyn8fIJTnd+zMUbM4
         9i6g==
X-Forwarded-Encrypted: i=1; AKwUvBxiJjkM0z83mqEEQVeIC1RjdbePXCZQbPvjszv1ZPtlJ9jY8yZXmLdn9qmlmxZAEuwZqevY6d6BQbKwRqM=@vger.kernel.org
X-Gm-Message-State: AFuF++kfbC9PhkLOaONI7G61ftAz5i+ULilCapUzME6npCqsL3Y8UzDr
	TYfEgKAdF3Z6xdUKoxytIEZ3DhdAGzuqdAFLtkSvtWp977pJXqfLCwBGJ+0DDZ6nhA==
X-Gm-Gg: AYBFou1BeirfMGvt+Ovi+Nox4MEBt54zRTFxEbfuyq2m6J1n3EE3vg/rgkAwNWYXU8v
	+5hLwKDvpn8Xu6YbVf9HLhZiNvhnkUsCccoYOR2Uyb7cFMdq/xnQnDwcIChqa/wo0PehrpwEDpR
	VcBAJ8xeoZz6w0cnGdriIyRzzw6k+zahfOfKbuVe06/EdAK8C3SEADjS6gvnTxBPuhTjfEkIxe7
	1UTqsXfEGtUoMkPlGH7SlVs5qOUnbAuTkVbvbJPJIsRpkH4ShU0ZYOE/moh0VdVSuI8A3ooFV0z
	3aAnmriZSgrM3DXbWlPwwoAD6hrH/OzneB6vzqxys5BlRTbBPyxXVBh39b365nM4tkPH+1EA9yk
	zteRDdXvhyrmyRrymjsypI4d7i8n/PwITTvC/y6H1Bl2RmLAOWoh9ou5Mb6XRgW//0Y9YLW1pv/
	D2IGl77RmIMh2pLqB37zx0quKLzr4lXjJ+g4C25pMzjJLyOaZJ/zb1c9u5LuBNiDq0nWKFvsktd
	LC31Omj+9bW1ja+UqWY/duaTEOiVfPRUQ5hJfU=
X-Received: by 2002:a17:90b:5844:b0:398:e436:370 with SMTP id 98e67ed59e1d1-39b260ff0e9mr6299886a91.2.1788499095839;
        Thu, 03 Sep 2026 22:18:15 -0700 (PDT)
Received: from ?IPV6:2405:201:4019:32fc:3c55:6b24:5147:322b? ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db148404d1sm4836965ad.6.2026.09.03.22.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 22:18:15 -0700 (PDT)
Message-ID: <40f71ade-9266-4373-b584-634d91bdf670@beagleboard.org>
Date: Fri, 4 Sep 2026 10:48:05 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/7] greybus: Add Rust UART node driver
To: Markus Probst <markus.probst@posteo.de>,
 Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com,
 Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20260827-gb-uart-transport-v2-0-a03bb1f5fbd1@beagleboard.org>
 <20260827-gb-uart-transport-v2-7-a03bb1f5fbd1@beagleboard.org>
 <08c89a754cd7cd43b0cc6d5f1e84cd6df7253c68.camel@posteo.de>
Content-Language: en-US
From: Ayush Singh <ayush@beagleboard.org>
In-Reply-To: <08c89a754cd7cd43b0cc6d5f1e84cd6df7253c68.camel@posteo.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/26 2:19 AM, Markus Probst wrote:

> On Thu, 2026-08-27 at 13:24 +0530, Ayush Singh wrote:
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
>>   MAINTAINERS                     |   1 +
>>   drivers/greybus/.gitignore      |   1 +
>>   drivers/greybus/Kconfig         |  15 +++
>>   drivers/greybus/Makefile        |  48 ++++++++
>>   drivers/greybus/gb_uart_node.rs | 245 ++++++++++++++++++++++++++++++++++++++++
>>   5 files changed, 310 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index d047090be5f4..49c6dac72748 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -11339,6 +11339,7 @@ M:	Ayush Singh <ayush@beagleboard.com>
>>   L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
>>   S:	Maintained
>>   F:	Documentation/devicetree/bindings/beagle/beagle,beagleconnect-freedom.yaml
>> +F:	drivers/greybus/gb_uart_node.rs
>>   
>>   GREYBUS SUBSYSTEM
>>   M:	Johan Hovold <johan@kernel.org>
>> diff --git a/drivers/greybus/.gitignore b/drivers/greybus/.gitignore
>> new file mode 100644
>> index 000000000000..ff9c4a3539b4
>> --- /dev/null
>> +++ b/drivers/greybus/.gitignore
>> @@ -0,0 +1 @@
>> +exports_gb_softsvc_generated.h
>> diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
>> index 381d1a6ee135..34de913af287 100644
>> --- a/drivers/greybus/Kconfig
>> +++ b/drivers/greybus/Kconfig
>> @@ -60,5 +60,20 @@ config GREYBUS_SOFTSVC
>>   	  To compile this code as a module, choose M here: the module
>>   	  will be called gb-softsvc.ko
>>   
>> +config GREYBUS_UART_NODE
>> +	tristate "Greybus UART node transport"
>> +	depends on RUST
>> +	depends on GREYBUS_SOFTSVC
>> +	depends on RUST_SERIAL_DEV_BUS_ABSTRACTIONS
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
>>   endif	# GREYBUS
>>   
>> diff --git a/drivers/greybus/Makefile b/drivers/greybus/Makefile
>> index e6f594128802..81151963c01e 100644
>> --- a/drivers/greybus/Makefile
>> +++ b/drivers/greybus/Makefile
>> @@ -28,3 +28,51 @@ obj-$(CONFIG_GREYBUS_ES2)	+= gb-es2.o
>>   obj-$(CONFIG_GREYBUS_SOFTSVC)	+= gb-softsvc.o
>>   gb-softsvc-y			+= gb_softsvc.o gb_softsvc_exports.o
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
>> +# Output nova-core's crate metadata for use by nova-drm at compile time.
>> +RUSTFLAGS_gb_softsvc.o += \
>> +	--emit=metadata=$(objtree)/$(obj)/libgb_softsvc.rmeta
>> +
>> +# Allow nova-drm to import nova-core's types.
>> +$(obj)/gb_uart_node.o: $(obj)/gb_softsvc.o
>> +RUSTFLAGS_gb_uart_node.o := -L $(objtree)/$(obj) --extern gb_softsvc
>> diff --git a/drivers/greybus/gb_uart_node.rs b/drivers/greybus/gb_uart_node.rs
>> new file mode 100644
>> index 000000000000..3eb4f8ab3655
>> --- /dev/null
>> +++ b/drivers/greybus/gb_uart_node.rs
>> @@ -0,0 +1,245 @@
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
>> +    new_spinlock, of,
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
>> +                }
>> +                HDLC_ESC => self.rx_in_esc = true,
>> +                _ => {
>> +                    let c = if self.rx_in_esc { *i ^ HDLC_XOR } else { *i };
>> +                    self.rx_in_esc = false;
>> +
>> +                    if self.rx_buf.push_within_capacity(c).is_err() {
>> +                        dev_warn!(self.sdev.as_ref(), "buffer overflow. Dropping frame");
>> +
>> +                        self.rx_buf.clear();
>> +                        self.rx_in_esc = false;
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
> (add me to CC please)
>
> Instead of using a lock here, it might be a better idea to
> synchronize/stop the receive callback before unbind is called in the
> serdev rust abstraction. This would allow the abstraction to provide
> mutable references to the driver data in `receive` and `unbind`. It
> would also remove the Sync requirement.
>
> I will send a patch soon.
>
> Thanks
> - Markus Probst

That sounds great. The lock here was basically only for getting a mut 
ref. I will base the next version on top of your patches.

I have added your email for the next patch version.


Best Regards,

Ayush Singh

