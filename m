Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792582760;
	b=xKp45FPDYCYFPFtf2s6wQazY8mGCO/gnbokhxpncpuUL18l77JxBK5n3z392HKxUWGOn
	 F6aSCv2BDcMRrRLpuPponeWmgLR6xTNrXm4mlBTdwZUVNMKisnyUXkB74dVW7BNhvOh4n
	 1cSNrrTBuTY/tlND/Pz7HSDlh7OBY661bIGEh/0hgguA523Ip0M+nuixtmbldj+D0fOTS
	 T0rDhT/lYlTPeKi3H6cXSNfVn+EQgCl6yVQ/0StFeDjrnuRetuEKr21pALL4QPYVHnz9P
	 KbrnGZzOgxepYc1Egy0d2pbnPt0fgU3mLHA+iOyl07Ufrdnm1H+t5jYTdHFwtNURE4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792582760;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=+VaxDdm2yeMQ8nyfzutJWB96P5Dynk6cu803aKWGLq8=;
	b=qLpgNxK1FPITNX33TErw7FMeQvB7d+FhszwqJ27e9Is+7vce/NrryT+aVhiOqGb3bnQW
	 iwZkAxPM4lYRJBsLW4G25J+Lp/Wyl3A7Fn5/LMh4mISFT5I9o8QY/1RQqlSO2gfx+RH2X
	 lKOjZIv972fhiGkFlfWQrT7EQprhUfXILBd5txCTFUkdQMxvqwQ4xjuJ/LlDHS6bnczEq
	 WHLOaeU3R+Rbf18vkcae7T3MX4Q7MtYtdKw4/UE7pDWH3uPXYuvvtnonWUlbgYneB1yVu
	 r1NjBC5O8iQUOfvfXWBXsH+vze3nZ3hF+cV9l+h27FycHpkyRu7JCBbbNZvYuKLlRFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=beagleboard.org;
	spf=fail smtp.mailfrom=beagleboard.org;
	dkim=pass header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=Fj2alYtc;
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DF4606A31A
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 11:39:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92DF4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=Fj2alYtc
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cd5e2d696e0so302010a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 04:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1792582759; x=1793187559; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+VaxDdm2yeMQ8nyfzutJWB96P5Dynk6cu803aKWGLq8=;
        b=Fj2alYtcn4FZXplYC9JMUPZa66i3rvRnXP/LB0cycDQzM2Kod+du5mHlGzYL4VDKoH
         NVVZSiocLTE08wAovePgsuJdThGaV8nTx3Dfj24Lw0a73jxgXe9p7e7uV/DSiOl8a8tR
         HVpgpgN54T4XkHMmCxC8Ip/Pw6MeZf86TZ+Kau7gb5ay4Z1TFyc7hxeLdpWwDC7wNL11
         pMf9JP8OTlcrK+G99wo7TIZ6PzTHXbMQflM6mIVjrwStgdbNGiSTR8paRUEM3qW9G56I
         4bOTmvIzFFh42ZcPIs+5L/hyniinaUYeMitFWvtCaSFiZ8sd+nHMF8jcfdz4DcnKJf7m
         BsrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792582759; x=1793187559;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+VaxDdm2yeMQ8nyfzutJWB96P5Dynk6cu803aKWGLq8=;
        b=J+1bsabcX66D4ABAWw1N8pWE2UvTX2N+gbCEpfxAYDgAlM1fCbKdvFS/kDGR7ZkwCO
         BKizwi7o0KQxrGGlIu6VOXQaIg/5X2LJjoJ4l8m1AFCilekwkF/UFxkryzF3bMQPMmRX
         4Q5aO/vNf6qFOG12eWwI+7VYp5RwnN+XOtXFIvB2x1AFtfIHVK7loU9Rqpllk79toUzr
         KgGOngfIetHQ/mdtNiFuC8/uKgjDWeYMGP9XgImTPBgqqK44PKX8ChCJxle/fEZZaIlf
         7D1Al9jebNOB2L8cLENc40XiEknnKfLebn+OcRX7uc9Q/3QVbMGnxTEQ8qiTmdjY10YS
         Lxew==
X-Forwarded-Encrypted: i=1; AKwUvBx17UaCOPro3QXFQfVOapLYCIKBO8jkuQGFeFChoP/KKub5pBRbblf0JiYBE8A24mxUKVsaAl1b4op0elc=@vger.kernel.org
X-Gm-Message-State: AFq9FYI/ZK19t7TUTmk8IQk6kylAgpOf5iD77sGuAMYfjd9wKGB443Tn
	BObU5GbUMYJxEfHArGMOgAQc+R1+Gw8unkctJWYrm+TH258WOm2bBH8WvMNjhSFlgQ==
X-Gm-Gg: AYBFou3wIGghl1coyNs0n132+Ms15b318Mt3o/jTib5mXOKQm5Wj3YDLiG2+uVhqj/N
	1WgZGsuNq3pd7GoDz7dvMI6vihKUOUyuI4RV5DqNqZosromHR8CbJ0AjwPufF0iCMrf2ZE42jrt
	Op9kXylVs9iazPKuHwS5HhUP3zTCUqpGUZXzfFz1BsL5QmahaiPI+5qd1EAfYo3BtONLOu18k5A
	vdDs0mnUb5OFG6pe12YU7d2xmL84JLXDZSNvOMOehIp4tXyX8O1wIjVih16BLd0Z+xIrEVyrSI4
	FrdPX5elUjMOlA+jhz/dudOHvQtHgWeXjiHXIQvqDWuIfMpmdH1KIrLREVS7vPFxGl550uJllh5
	fzL3zQ0Uvli3HkGyiC2wjrAKiS5PKpPRxc5Zp3cKLrbPKobT56D5Z+ms2Px325zTSBt87QpdWUo
	ckyNk3SUkDCGvn4/VNq7Nj4LIg6Xd56N/3E9eHQaUfx1getrEe9pxdVp3tBo06UY9uAPZD4QMTa
	3e/Rbift8cEkk3SixgTkl2jBCyvYTKm6KOzj98rsg1a0R9bD1h+3m90jHvOJYX6YZ8=
X-Received: by 2002:a17:90b:3848:b0:3ab:188b:c5be with SMTP id 98e67ed59e1d1-3ad87084014mr1570077a91.45.1792582758877;
        Wed, 21 Oct 2026 04:39:18 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad813eb9casm4023732a91.15.2026.10.21.04.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 04:39:18 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Wed, 21 Oct 2026 17:07:54 +0530
Subject: [PATCH v4 6/6] greybus: Add Rust UART node driver
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-gb-uart-transport-v4-6-c308ce821d45@beagleboard.org>
References: <20261021-gb-uart-transport-v4-0-c308ce821d45@beagleboard.org>
In-Reply-To: <20261021-gb-uart-transport-v4-0-c308ce821d45@beagleboard.org>
To: Jason Kridner <jkridner@beagleboard.org>, robertcnelson@gmail.com, 
 Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
 Ayush Singh <ayush@beagleboard.com>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Markus Probst <markus.probst@posteo.de>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Ayush Singh <ayush@beagleboard.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=11876;
 i=ayush@beagleboard.org; h=from:subject:message-id;
 bh=a8QqTGAat63BV9GwbIKilpnLs4ixF9+MdlNnluICNlY=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBq2KQU0rSyFZnLU0rkl3is1ARUQflYsh5UWwRBz
 YOyQ9VfObOJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCatikFAAKCRAFzvXHieVa
 dD0wD/448yTXe/orHFbrDdO5lWc73ZdcB4DyGaStTy/RhyK7QHKC+A7mZh5AIt/TrvryKr/y4qQ
 3T1BT98NSG6b9Bg9EszSCRCB2jjpmUDTDi2u+RLMOydNiLi7NhYsLZ/OAXZkhTPCJWKamJATyt3
 EdWEwiUkm+9Y0AW0nnroAhcLU7i+I4llqwKedrpOHs2wffzqgBWBPuahQhxavU6TfIr5Gm6K8i8
 dKz4Y5cENblMdkflIF9LYzgGRa8rI1InlPHy/q7d1FfwILhkJ9Y9mNrwc/eQxTl4rLYcdBQjsEi
 f7VccGIGXepNm1N5KaDfnP34c/wV5bs4C/lhXXXe9aA0/w3OmoQiWIPgaytWg+jzXFDK/9MMj3L
 GDtTra3VCXzx88YI6ibes0CJCxAUjxFh65/7DyTJCAbjkHMfEHUbE+VYLycyz2c2Q7JmBQS3oGo
 WBxIOgNm2uAFWx1i1vAy/9GUzsox6rFp3stCnxYHYZgL5HmkxQysD4v4h4VbF/f5HaOPp0Xf6OG
 gV0FCDoJrv+/slT+jc4zFf/XTOHutCYAlirPxHvbmrYgutKQl77F1nPn0D8WHEz1t46nrYSQKr0
 Tn3MBpZU2hL3ISw+flZ1Pz5r35hjGWnR2xPXd0LoKYzKCzXmJoy1W88eW/pUbVvfqZZxJTOC/Ux
 x1wrTkzSTIesX5A==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

Add a driver for Greybus nodes attached over a plain serial port. The
node is registered with the software SVC (gb-softsvc), which handles the
SVC protocol on behalf of the AP, so no dedicated coprocessor running
SVC firmware is needed.

Greybus messages are carried over HDLC framing on the wire. Each frame
carries a one-byte address (0x01 for Greybus) and control byte, followed
by the 16-bit CPort ID and the Greybus message itself.

Port parameters are taken from the firmware node: "baudrate" if
present, otherwise 115200, with flow control and parity disabled.

Since gb-uart-node imports types from gb-softsvc, Rust to Rust calling
setup from nova-core [0] is being used.

[0]: https://lore.kernel.org/all/20260622-nova-exports-v5-0-6191773fc977@nvidia.com/

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 MAINTAINERS                     |   1 +
 drivers/greybus/.gitignore      |   1 +
 drivers/greybus/Kconfig         |  15 +++
 drivers/greybus/Makefile        |  10 ++
 drivers/greybus/gb_uart_node.rs | 257 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 284 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 521bc6c67979..5bdd500ef63e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11527,6 +11527,7 @@ M:	Ayush Singh <ayush@beagleboard.org>
 L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
 S:	Maintained
 F:	Documentation/devicetree/bindings/beagle/beagle,beagleconnect-freedom.yaml
+F:	drivers/greybus/gb_uart_node.rs
 
 GREYBUS SUBSYSTEM
 M:	Johan Hovold <johan@kernel.org>
diff --git a/drivers/greybus/.gitignore b/drivers/greybus/.gitignore
new file mode 100644
index 000000000000..ff9c4a3539b4
--- /dev/null
+++ b/drivers/greybus/.gitignore
@@ -0,0 +1 @@
+exports_gb_softsvc_generated.h
diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
index 709563f8c0ad..ce2030161f30 100644
--- a/drivers/greybus/Kconfig
+++ b/drivers/greybus/Kconfig
@@ -61,5 +61,20 @@ config GREYBUS_SOFTSVC
 	  To compile this code as a module, choose M here: the module
 	  will be called gb-softsvc.ko
 
+config GREYBUS_UART_NODE
+	tristate "Greybus UART node transport"
+	depends on GREYBUS_SOFTSVC
+	depends on RUST_SERIAL_DEV_BUS_ABSTRACTIONS
+	depends on RUST_GREYBUS_ABSTRACTIONS
+	select RUST_CRC_CCITT_ABSTRACTIONS
+	help
+	  Select this option if you have a Greybus node connected over a
+	  serial port. The node is registered with the software SVC, which
+	  handles the SVC protocol on behalf of the AP, so no dedicated
+	  coprocessor running SVC firmware is required.
+
+	  To compile this code as a module, choose M here: the module
+	  will be called gb-uart-node.ko
+
 endif	# GREYBUS
 
diff --git a/drivers/greybus/Makefile b/drivers/greybus/Makefile
index 0fa802fdf6ca..bf4d08f728fe 100644
--- a/drivers/greybus/Makefile
+++ b/drivers/greybus/Makefile
@@ -28,6 +28,12 @@ obj-$(CONFIG_GREYBUS_ES2)	+= gb-es2.o
 obj-$(CONFIG_GREYBUS_SOFTSVC)	+= gb-softsvc.o
 gb-softsvc-y			+= gb_softsvc.o gb_softsvc_exports.o
 
+obj-$(CONFIG_GREYBUS_UART_NODE)	+= gb-uart-node.o
+gb-uart-node-y			+= gb_uart_node.o
+
+# Export Rust symbols from gb-softsvc only if gb-uart-node actually references them.
+gb-softsvc-export-deps := $(if $(CONFIG_GREYBUS_UART_NODE),$(obj)/gb_uart_node.o)
+
 rust_needed_exports = \
 	{ $(if $(strip $(2)),$(NM) -u $(2);,) echo "__DEFINED_RUST_SYMBOLS__"; \
 	  $(NM) -p --defined-only $(1); } | \
@@ -66,3 +72,7 @@ endif
 # Output gb_softsvc's crate metadata for use by gb_uart_node at compile time.
 RUSTFLAGS_gb_softsvc.o += \
 	--emit=metadata=$(objtree)/$(obj)/libgb_softsvc.rmeta
+
+# Allow nova-drm to import nova-core's types.
+$(obj)/gb_uart_node.o: $(obj)/gb_softsvc.o
+RUSTFLAGS_gb_uart_node.o := -L $(objtree)/$(obj) --extern gb_softsvc
diff --git a/drivers/greybus/gb_uart_node.rs b/drivers/greybus/gb_uart_node.rs
new file mode 100644
index 000000000000..f3779737c75e
--- /dev/null
+++ b/drivers/greybus/gb_uart_node.rs
@@ -0,0 +1,257 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Greybus UART Node driver
+
+use kernel::{
+    alloc::Flags,
+    crc_ccitt::crc_ccitt,
+    device::{
+        AsBusDevice,
+        Bound,
+        Core, //
+    },
+    error::code,
+    new_spinlock,
+    of, //
+    prelude::*,
+    serdev,
+    sync::{
+        aref::ARef,
+        Arc,
+        SpinLock, //
+    },
+};
+
+use zerocopy::little_endian;
+use zerocopy_derive::{FromBytes, Immutable, KnownLayout};
+
+/// Most greybus implementations will have a limit on greybus message length. The theoretical limit
+/// is [`u16::MAX`], but the real limits are much more modest. 256 seems to be the limit I use on
+/// most of my peers, but let's use 512 to be on safe side in kernel. The only real big request that
+/// I frequently encounter is manifest_get. However, if camera protocol ends up being supported at
+/// some point, this might need to be increased.
+const HDLC_MAX_FRAME_LEN: usize = 512;
+const HDLC_FRAME_HEADER_LEN: usize =
+    2 * size_of_val(&HDLC_FRAME) + 2 * size_of::<u16>() + 2 * size_of::<u8>();
+const HDLC_MAX_MSG_LEN: usize = HDLC_MAX_FRAME_LEN - HDLC_FRAME_HEADER_LEN;
+
+const HDLC_FRAME: u8 = 0x7E;
+const HDLC_ESC: u8 = 0x7D;
+const HDLC_XOR: u8 = 0x20;
+const HDLC_EXPECTED_CRC: u16 = 0xf0b8;
+
+const ADDRESS_GREYBUS: u8 = 0x01;
+
+#[repr(C, packed)]
+#[derive(FromBytes, Immutable, KnownLayout)]
+struct GreybusFrame {
+    cport: little_endian::U16,
+    msg: [u8],
+}
+
+struct HdlcRx {
+    rx_buf: KVec<u8>,
+    rx_in_esc: bool,
+    rx_overflow: bool,
+    sdev: ARef<serdev::Device>,
+    node: gb_softsvc::Module,
+}
+
+impl HdlcRx {
+    fn new(sdev: ARef<serdev::Device>, node: gb_softsvc::Module) -> Result<Self> {
+        Ok(Self {
+            node,
+            sdev,
+            rx_buf: KVec::with_capacity(HDLC_MAX_FRAME_LEN, GFP_KERNEL)?,
+            rx_in_esc: false,
+            rx_overflow: false,
+        })
+    }
+
+    fn frame_finish(&self) -> Result<()> {
+        if self.rx_buf.len() < 4 {
+            return Err(code::EFAULT);
+        }
+
+        let crc = crc_ccitt(0xffff, &self.rx_buf);
+        if crc != HDLC_EXPECTED_CRC {
+            dev_warn!(self.sdev.as_ref(), "CRC failed {}", crc);
+            return Ok(());
+        }
+
+        let addr = self.rx_buf[0];
+        let _ctrl = self.rx_buf[1];
+        let payload = &self.rx_buf[2..self.rx_buf.len() - size_of::<u16>()];
+
+        match addr {
+            ADDRESS_GREYBUS => {
+                let frame = GreybusFrame::ref_from_bytes(payload).map_err(|_| code::EINVAL)?;
+                self.node.submit_message(0, frame.cport.into(), &frame.msg)
+            }
+            _ => Err(code::EINVAL),
+        }
+    }
+
+    fn rx(&mut self, data: &[u8]) -> usize {
+        for i in data.iter() {
+            match *i {
+                HDLC_FRAME => {
+                    if !self.rx_buf.is_empty() {
+                        if let Err(e) = self.frame_finish() {
+                            dev_warn!(self.sdev.as_ref(), "bad frame: {e:?}\n");
+                        }
+                    }
+
+                    self.rx_buf.clear();
+                    self.rx_in_esc = false;
+                    self.rx_overflow = false;
+                }
+                HDLC_ESC => self.rx_in_esc = true,
+                // Skip data if buffer has overflown.
+                _ if self.rx_overflow => {}
+                _ => {
+                    let c = if self.rx_in_esc { *i ^ HDLC_XOR } else { *i };
+                    self.rx_in_esc = false;
+
+                    if self.rx_buf.push_within_capacity(c).is_err() {
+                        dev_warn!(self.sdev.as_ref(), "buffer overflow. Dropping frame");
+
+                        self.rx_overflow = true;
+                        self.rx_buf.clear();
+                    }
+                }
+            }
+        }
+
+        data.len()
+    }
+}
+
+struct GbNode {
+    sdev: ARef<serdev::Device>,
+}
+
+impl GbNode {
+    const fn new(sdev: ARef<serdev::Device>) -> Self {
+        Self { sdev }
+    }
+
+    fn fill_buf(mut crc: u16, data: &[u8], buf: &mut KVec<u8>) -> Result<u16> {
+        for i in data {
+            crc = crc_ccitt(crc, &[*i]);
+            if *i == HDLC_ESC || *i == HDLC_FRAME {
+                buf.push_within_capacity(HDLC_ESC)?;
+                buf.push_within_capacity(i ^ HDLC_XOR)?;
+            } else {
+                buf.push_within_capacity(*i)?;
+            }
+        }
+
+        Ok(crc)
+    }
+}
+
+impl gb_softsvc::InterfaceOps for GbNode {
+    fn write(&self, data: &[u8], cport: u16, gfp_mask: Flags) -> Result<()> {
+        // SAFETY: `GbNode` only exists while its serdev driver is bound, so the device is in the
+        // `Bound` state for the duration of this call.
+        let bound: &serdev::Device<Bound> =
+            unsafe { serdev::Device::from_device(self.sdev.as_ref().as_bound()) };
+
+        // Drop messages which are bigger than what is supported.
+        if data.len() > HDLC_MAX_MSG_LEN {
+            return Err(code::E2BIG);
+        }
+
+        let mut buf = KVec::with_capacity(HDLC_MAX_FRAME_LEN, gfp_mask)?;
+
+        let mut crc = 0xffff;
+
+        buf.push_within_capacity(HDLC_FRAME)?;
+
+        crc = Self::fill_buf(crc, &[ADDRESS_GREYBUS, 0x03], &mut buf)?;
+        crc = Self::fill_buf(crc, &cport.to_le_bytes(), &mut buf)?;
+        crc = Self::fill_buf(crc, data, &mut buf)?;
+
+        crc ^= 0xffff;
+        Self::fill_buf(crc, &crc.to_le_bytes(), &mut buf)?;
+
+        buf.push_within_capacity(HDLC_FRAME)?;
+
+        bound.write_all(&buf, 0)?;
+
+        Ok(())
+    }
+}
+
+#[pin_data]
+struct GbUartNode {
+    #[pin]
+    rx: SpinLock<HdlcRx>,
+}
+
+impl GbUartNode {
+    fn init(sdev: &serdev::Device<Core<'_>>) -> Result<HdlcRx> {
+        if sdev
+            .set_baudrate(
+                sdev.as_ref()
+                    .fwnode()
+                    .and_then(|fwnode| fwnode.property_read(c"current-speed").optional())
+                    .unwrap_or(115200),
+            )
+            .is_err()
+        {
+            return Err(EINVAL);
+        }
+        sdev.set_flow_control(false);
+        sdev.set_parity(serdev::Parity::None)?;
+
+        let node = gb_softsvc::Module::new(&[Arc::new(GbNode::new(sdev.into()), GFP_KERNEL)?])?;
+
+        HdlcRx::new(sdev.into(), node)
+    }
+}
+
+kernel::of_device_table!(
+    OF_TABLE,
+    <GbUartNode as serdev::Driver>::IdInfo,
+    [(of::DeviceId::new(c"beagle,beagleconnect-freedom"), ())]
+);
+
+#[vtable]
+impl serdev::Driver for GbUartNode {
+    type IdInfo = ();
+    type Data<'bound> = Self;
+    const OF_ID_TABLE: Option<of::IdTable<Self::IdInfo>> = Some(&OF_TABLE);
+
+    fn probe<'bound>(
+        sdev: &'bound serdev::Device<Core<'_>>,
+        _info: Option<&'bound Self::IdInfo>,
+    ) -> impl PinInit<Self, Error> + 'bound {
+        dev_dbg!(sdev.as_ref(), "Probe gb_uart_node.\n");
+
+        try_pin_init!(Self {
+            rx <- new_spinlock!(Self::init(sdev)?, "gb_uart_node::rx"),
+        }? Error)
+    }
+
+    fn receive<'bound>(
+        _sdev: &'bound serdev::Device<Bound>,
+        this: Pin<&Self>,
+        data: &[u8],
+    ) -> usize {
+        if let Some(mut guard) = this.rx.try_lock() {
+            return guard.rx(data);
+        }
+
+        0
+    }
+}
+
+kernel::module_serdev_device_driver! {
+    type: GbUartNode,
+    name: "gb_uart_node",
+    authors: ["Ayush Singh <ayush@beagleboard.org>"],
+    description: "Greybus node connected over UART",
+    license: "GPL v2",
+}

-- 
2.56.0

