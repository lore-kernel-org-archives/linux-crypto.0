Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711A73A4267
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 07:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817363; cv=none; b=hNfEjq+n3K6fkbo3U6JJRKQ3s5mGBEnEUixX6bnkoGEktfY/WXZBWE1nWXlWdCyEVbTUaRQb+OegFaDUVwopGvIf333Ija5kwgZKLIA3L6lS24+LR4VG8okZR+fp+20XqA0P7Z4PVxC7Sih8MpoDGKs7moMexRS50RZLQPY0L3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817363; c=relaxed/simple;
	bh=woP4oknrV4W1iL3OCn7b6REW+reH59r7peTdThZwqZM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gNzjXGG9/ruWt8WYAULk9BL3/p4O2nz0UMCJkSEytFvVnHKxtRpqUUixMiG3Ygz0aR+CDJlj2/IC76TYZXmuK8UtQqB6mLZ4WbFkUbts+pxb3WwiKmBPTKiwWWh7A3/R+muEXpD0M1pN/pCp7Iae0s2pVWhANVdXDWp43VqM0oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=I0FMnEjg; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="I0FMnEjg"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc1c73645a1so1144696a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 00:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1787817359; x=1788422159; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JpdW8dGYYPpvIZ3wUmof7nEJxVPBrHgTt9c2tEi6VgY=;
        b=I0FMnEjgPWha98m1uLU3Ft5aCB90BLzRlIU93dJ8ZC+czyqest1A0Ej4dA4vHNY4bj
         bOSviM7fEVlsyRO1gQxpjQ1kAEDHBopyGkr685tS4rVxdtVbse7Yys9g8jaZD0DyKpV4
         cUqEqmxMQVOXhX1rQojMsdgVZao132PODNw/Cz7uFRyTnS4dM7ghC/BxYNmifXo6escD
         Zduf5xsDEdRoXzIOp6kUUXG8Jg4Fgm9TU72ACf/Cmk1nJdJ0u2FICBW+um4yuXOnwFfx
         CtoEar5pQwfTfHiMqAOA4suG2baFmLc9rT8YF6sKnFfZmoG4Zg/hP3HDvd+hkmhNeWO1
         Ellg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787817359; x=1788422159;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JpdW8dGYYPpvIZ3wUmof7nEJxVPBrHgTt9c2tEi6VgY=;
        b=IESW45WJXFE8ZWuTYS7r+L/B6B+zxyoii944ZQdJqQGYgA1Lrr2FacDhvK293F/8u8
         DDIFJMPpSc4JQTkcYtZHleTyGQHb9YnyuX4MN2Y+S36iY5FDZgl4iu0RKzCx6MqAANZH
         sliOA1QRYUJjpRlERhHmvop1KwRnlZC4Mk4Ql6Y6SkM/0kOJCptzOAO0cbRJcBHy45C7
         QnQYJGz+ZdXRBsK7q5+yLmEV9cnQfR8nfZOsc4drlQDvXeTzqvCGWB+7rEr2HLmN/2aX
         9JhYsPMgpgjaR2neQjzM85qDEtQGn6+xG1wDvQbCjTc9sgf+bWulb3TBRdJz0jubFayH
         pCng==
X-Forwarded-Encrypted: i=1; AHgh+RrvYG2j8FVus05Hbt1fNuKaAJUKPuJOBhKg1Y0fHX1cXQ3AX4K8cagnqBlZJpH/ijUJ4BrOc8Kgqu7Puz4=@vger.kernel.org
X-Gm-Message-State: AFuF++kHH6caZewb6bcpnyROxURG/leF4RidGlA9hwbh+BSsjcdYurq7
	a6DHP57B1OT866s8XdhndhhOA+FqcxTPZLkfiYHgtZl4EMOCRy7Ynyq0AZl/3hsIWQ==
X-Gm-Gg: AR+sD12SNOcV9PHSMhTHcEMAhZQnHEof+6v4cJu7JCxUPV2NG3PtFfQDV0CVMozL9eF
	G00GCRCX5TrAfuWd6cZY+dpA0tCm/sJFcaY13ayp1ZsZ26/0GbUrKihNl8DzNfKEFo3+o+QbZzV
	Xyg2YEFXeTsBgeiYqlFG9kFBS0HonljOVUQS8RIB+jtotY2G/BxFinS3qOwml6q2C4PtcMwrlQ/
	4bNAdp3rN8p4lm74rXMzbbSj4iq0BQc2BMXbuQthHgFnm6GUHppIknfOluws+LKzoAN1p6Lh1Dc
	+wZdZ+03VZUwkyOymg5aaFaYpjfAeSNRNTqIqDJv/uGebmWNH2q2+kjitKXNmxF2Ye5NDizEys5
	P4F2y5COxr1YJa16xGzyNa/f697KBqCGFCP90X2qIBIlBriihyntQhjwjiFuoDD9RkfU49xlUoV
	LtQ9aW3mP5FQwnE4dlhvLOXHRqNPPNS81C7aBCP+gtVzOqTTaiykZKAM44A8j+zL8OB2Wz1oc=
X-Received: by 2002:a05:6a21:4593:b0:3bf:9b61:f7ae with SMTP id adf61e73a8af0-3cf8413dffdmr29525954637.14.1787817359500;
        Thu, 27 Aug 2026 00:55:59 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d60c2b4sm24641685eec.5.2026.08.27.00.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 00:55:59 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Thu, 27 Aug 2026 13:24:43 +0530
Subject: [PATCH v2 7/7] greybus: Add Rust UART node driver
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260827-gb-uart-transport-v2-7-a03bb1f5fbd1@beagleboard.org>
References: <20260827-gb-uart-transport-v2-0-a03bb1f5fbd1@beagleboard.org>
In-Reply-To: <20260827-gb-uart-transport-v2-0-a03bb1f5fbd1@beagleboard.org>
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
 Uladzislau Rezki <urezki@gmail.com>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Ayush Singh <ayush@beagleboard.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=12372;
 i=ayush@beagleboard.org; h=from:subject:message-id;
 bh=woP4oknrV4W1iL3OCn7b6REW+reH59r7peTdThZwqZM=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqj+1DHhMiSIIYl82UcYte5S2h2+PWFqg5USgDK
 FvjTfvXr6qJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCao/tQwAKCRAFzvXHieVa
 dGPEEACt4vEA02o6w4DZrtBUPxYp9v36RhwEvIb8aKp8HZOwXi9lK4OvAxSRzRzIvhwGrcm+uul
 duNy2HaEyBdO/TfVgZUJrguaHpEfrxlC/I2P3vaooDOvxhG0yVEWmp0qzI5ehHtx0H1vzV4j+cF
 sDYyH5c3SIaFvc2GeGnkSjBHCFWdZzm37CoWNVnRvJdaiTb5rZEzPjf9anj8KWfcelySFDt5pyW
 JfRWLJIwBc5dDalyz0mkTio6EFuUYY0ZTiOv18OfVCQW14B3+gI2576DdEVuYIMtnFd4/wA2jJs
 C2NDO+6T70K7VvPAzJQAX6BuFg+a1jUDxONiLnJsa3m2RBYH+asmEpTVFpF2TOOZi90GxXcWnvx
 x8UFGF6o/omIYlLLB//pkwYiFDQi0XMWjDJxxt8zlLAGRHPO0T6tzzs3pP9sUcDkSzxkrBE9wS5
 gCTWwl95IptjAbOm0bO5oO4b0b457CMumGB8NfxO4oyN7kyh2xZiqqTXFkZXqPlF15BNNBk0CWR
 2IWNC0y0RjPxdbR2t3BRRfko03ejupGyNp/e2dgjFoTXU2vebwkOwNDdOnqJYOkbT13xzl0QOOX
 y7B/Geurl/J/oGJd8549H2AgHojtQhWcIk+XfrFNs/l7Mmixa+wqlMQIHdm7gZyHw1aECuLLOMb
 YxzlAsjoxTHlGpw==
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
 drivers/greybus/Makefile        |  48 ++++++++
 drivers/greybus/gb_uart_node.rs | 245 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 310 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d047090be5f4..49c6dac72748 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11339,6 +11339,7 @@ M:	Ayush Singh <ayush@beagleboard.com>
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
index 381d1a6ee135..34de913af287 100644
--- a/drivers/greybus/Kconfig
+++ b/drivers/greybus/Kconfig
@@ -60,5 +60,20 @@ config GREYBUS_SOFTSVC
 	  To compile this code as a module, choose M here: the module
 	  will be called gb-softsvc.ko
 
+config GREYBUS_UART_NODE
+	tristate "Greybus UART node transport"
+	depends on RUST
+	depends on GREYBUS_SOFTSVC
+	depends on RUST_SERIAL_DEV_BUS_ABSTRACTIONS
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
index e6f594128802..81151963c01e 100644
--- a/drivers/greybus/Makefile
+++ b/drivers/greybus/Makefile
@@ -28,3 +28,51 @@ obj-$(CONFIG_GREYBUS_ES2)	+= gb-es2.o
 obj-$(CONFIG_GREYBUS_SOFTSVC)	+= gb-softsvc.o
 gb-softsvc-y			+= gb_softsvc.o gb_softsvc_exports.o
 
+obj-$(CONFIG_GREYBUS_UART_NODE)	+= gb-uart-node.o
+gb-uart-node-y			+= gb_uart_node.o
+
+# Export Rust symbols from gb-softsvc only if gb-uart-node actually references them.
+gb-softsvc-export-deps := $(if $(CONFIG_GREYBUS_UART_NODE),$(obj)/gb_uart_node.o)
+
+rust_needed_exports = \
+	{ $(if $(strip $(2)),$(NM) -u $(2);,) echo "__DEFINED_RUST_SYMBOLS__"; \
+	  $(NM) -p --defined-only $(1); } | \
+	awk -v fmt='$(3)' ' \
+		/^__DEFINED_RUST_SYMBOLS__$$/ { defs = 1; next } \
+		!defs { if ($$NF ~ /^_R/) needed[$$NF] = 1; next } \
+		defs && $$2 ~ /(T|R|D|B)/ && $$3 ~ /^_R/ && \
+			$$3 !~ /_(init|cleanup)_module$$/ && \
+			$$3 !~ /__(pfx|cfi|odr_asan)/ && \
+			$$3 in needed { printf fmt, $$3 } \
+	'
+
+quiet_cmd_exports = EXPORTS $@
+      cmd_exports = \
+	$(call rust_needed_exports,$<,$(gb-softsvc-export-deps),EXPORT_SYMBOL_RUST_GPL(%s);\n) > $@
+
+$(obj)/exports_gb_softsvc_generated.h: $(obj)/gb_softsvc.o $(gb-softsvc-export-deps) FORCE
+	$(call if_changed,exports)
+
+targets += exports_gb_softsvc_generated.h
+
+$(obj)/gb_softsvc_exports.o: $(obj)/exports_gb_softsvc_generated.h
+CFLAGS_gb_softsvc_exports.o := -I $(objtree)/$(obj)
+
+ifdef CONFIG_MODVERSIONS
+# The C export shim declares Rust symbols as `extern int`, so reuse its export
+# list but generate symbol CRCs from the Rust object instead of the shim's DWARF.
+$(obj)/gb_softsvc_exports.o: private cmd_gensymtypes_c = \
+	$(call getexportsymbols,\1) | \
+	$(objtree)/scripts/gendwarfksyms/gendwarfksyms \
+		$(if $(KBUILD_GENDWARFKSYMS_STABLE), --stable) \
+		$(if $(KBUILD_SYMTYPES), --symtypes $(@:.o=.symtypes),) \
+		$(obj)/gb_softsvc.o
+endif
+
+# Output nova-core's crate metadata for use by nova-drm at compile time.
+RUSTFLAGS_gb_softsvc.o += \
+	--emit=metadata=$(objtree)/$(obj)/libgb_softsvc.rmeta
+
+# Allow nova-drm to import nova-core's types.
+$(obj)/gb_uart_node.o: $(obj)/gb_softsvc.o
+RUSTFLAGS_gb_uart_node.o := -L $(objtree)/$(obj) --extern gb_softsvc
diff --git a/drivers/greybus/gb_uart_node.rs b/drivers/greybus/gb_uart_node.rs
new file mode 100644
index 000000000000..3eb4f8ab3655
--- /dev/null
+++ b/drivers/greybus/gb_uart_node.rs
@@ -0,0 +1,245 @@
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
+    new_spinlock, of,
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
+const HDLC_MAX_FRAME_LEN: usize = 256;
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
+                }
+                HDLC_ESC => self.rx_in_esc = true,
+                _ => {
+                    let c = if self.rx_in_esc { *i ^ HDLC_XOR } else { *i };
+                    self.rx_in_esc = false;
+
+                    if self.rx_buf.push_within_capacity(c).is_err() {
+                        dev_warn!(self.sdev.as_ref(), "buffer overflow. Dropping frame");
+
+                        self.rx_buf.clear();
+                        self.rx_in_esc = false;
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
+    rx: SpinLock<Option<HdlcRx>>,
+}
+
+impl GbUartNode {
+    fn init(sdev: &serdev::Device<Core<'_>>) -> Result<HdlcRx> {
+        if sdev
+            .set_baudrate(
+                sdev.as_ref()
+                    .fwnode()
+                    .and_then(|fwnode| fwnode.property_read(c"baudrate").optional())
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
+            rx <- new_spinlock!(Some(Self::init(sdev)?), "gb_uart_node::rx"),
+        }? Error)
+    }
+
+    fn receive<'bound>(
+        _sdev: &'bound serdev::Device<Bound>,
+        this: Pin<&Self>,
+        data: &[u8],
+    ) -> usize {
+        if let Some(mut guard) = this.rx.try_lock() {
+            if let Some(ref mut hdlc_rx) = *guard {
+                return hdlc_rx.rx(data);
+            }
+        }
+
+        0
+    }
+
+    fn unbind<'bound>(_: &'bound serdev::Device<Core<'_>>, this: Pin<&Self::Data<'bound>>) {
+        // Getting a bound device is not possible after this point. So drop HdlcRx.
+        let _ = this.rx.lock().take();
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
2.55.0

