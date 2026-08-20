Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089F43F1AD5
	for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 09:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787218021; cv=none; b=g+suKoGaYevSqVFAeswL2tbIxkDzxxFDf3sUpEvO1H2l11OFoIXw3qfZ5pE55sQeWJAqFeETDVZ7DJARpkJ3EXDhizdEoUQ2Kc5DEGi6096sEV23nDAGbbem/BAPdFELIzk1IJbkIEIoL5OiRXKUmZZBat5Gt3Oe5X59sLX8Qt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787218021; c=relaxed/simple;
	bh=UuyGoF4kmMy8N8Cu2tekiMDft2rlXAE3u99nVrxSo9k=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mWPlZQszkuHerAXVg8jW79/Ujv9pQJS4z61t0zlFcp3FOAEKx1uYd9W7uDdJvy+VkzYq1650ZDE7ogGkSKlFmrzepa0B2wXaPk4coeJC/d49898tP14AkfKCuF4qsVaL0ygPkPeUyNnJ90xULsjj/dxJyzYswHnJ6KEg0aXk6Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard-org.20251104.gappssmtp.com header.i=@beagleboard-org.20251104.gappssmtp.com header.b=wPQFewcE; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard-org.20251104.gappssmtp.com header.i=@beagleboard-org.20251104.gappssmtp.com header.b="wPQFewcE"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-ca7bea5e5b3so1378610a12.1
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 02:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard-org.20251104.gappssmtp.com; s=20251104; t=1787218008; x=1787822808; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U7XYavdSPIoY2fWb3V2p0Qog33AFOGvZrGdj1YOTpO4=;
        b=wPQFewcE+NOEkERuX9Z0+SlXXqKdnOax03cQGNYe3xsvSFkZ2q+xO0BFy7wpp+IRgJ
         soL85IE0aJCVAqRrfa8y3z9xcliIvWDjkriHWJHxIbhW6u9hL7e/aF5Cw5UPOl5E4a6B
         xhwDw2RsYHorhZxd1afX+r7ofmgZi7qR6hoh3SujQ7l7Bge8do6uLldhjEe/z6R8z5IL
         kNF1KIO0tjOWjBWFk+BAgU9BxI++F5t/HWesQWT3uikdinh7nrStmCy3uPJ4oLjrAoX9
         gNJtxOEZthfJqI+339vGB9ipOi04IfiLVUkVl7wc6w2UV80TNb3SwwzZH8fQX1AQODwE
         atiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787218008; x=1787822808;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U7XYavdSPIoY2fWb3V2p0Qog33AFOGvZrGdj1YOTpO4=;
        b=swVRD/wXTgB4ihRFeFremJdmFiJrsdss59bSShLW6zz3YmSYD1B+bXRHZOdCES8Lj8
         iIDJzYz8Unze7T4rASIsbN22fHyFfBt+vhetVENUDzfSx1I/OvFnNSNszIRYriiJLE6o
         4f37Ph1YLhwNPpoMXvWCsyAFvfegtZWlZj4hl04PvuNNl8SocWKO3WtkGSd1bbyzYEGH
         TxTtofXKsSIjI+/KgrNuYN6CVzckwg7pWk8YPd4Kpyuz2b7nk6mHWZpRMSVY6gmak043
         3swo5gNVZ4I+7QtzGcsGBfv+flwhQ/q5QyYBVE6I1fC26Zl7khErtD1Ozj3+13tFMuTM
         Jd/g==
X-Forwarded-Encrypted: i=1; AHgh+RrCH5RwcLjBhLJYHsCmbznvIzxd7SeVPmfRljluEFvwFNvGy1wTuUX+L0UpRxHlfEUSFw34QEIHRBa1yNs=@vger.kernel.org
X-Gm-Message-State: AFuF++kEQtrXKMRRnvcspD4mlD9z9ehU2njAyO1HzFKbqB2b5ZVNXpOR
	NAUD1JxUcRFj8ilZ9CrT6OiTMR8CYWXLJcCZfwYW251dhOT7iHWqsxENrM7pYBRnVA==
X-Gm-Gg: AR+sD11O9dYPzwKKG6sc+fm1Bl+QTqSymwdTYw8DUA6WoVcm5N+FTaAfC0wBaaNeOPs
	AIi+4HH+cv5iC2uu3qoVCW3ZdrbZcsWd9KdWV+weamuBgXB8mN0j1oRyAvU32Yw+G1NYbwJpwyb
	aq1oZrHlzOolgLjy4yHCxJcHlXjUo/+8+Ev8q3vzOpis+8HjFJR/PjkQEsaggIqyE4NLk4o4ILN
	UCKVR5FiBFcRdlT29ZMcQKkGempPgFZgoIwSIm13wCpz1BFNA9OiyQuzEjGrhyFlcjQQFZU7dUb
	f9IfquZlhoHtN2L9JyCMIcfVypvGgVz7kUThPqVl53Qvtzt+KVEEv78KwO4dlyP32n1bPei+Xrq
	7uf3oFrzUXnL6X/M8XfG8iGZ5U83E5Vd6lQnam45KrWRUzbRN/uaAzg6weK0yvGrUjGaOChscdz
	SAS/vuixjO7lyXaCzOmftcNVn+r4HbQ8zg+2Ud+YpHUWMcxEmDY/AUXdi8KsFzja8tW2WndTQ=
X-Received: by 2002:a17:90b:2d8d:b0:392:e5b1:d833 with SMTP id 98e67ed59e1d1-39581252d0fmr21049772a91.13.1787218008393;
        Thu, 20 Aug 2026 02:26:48 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ad6060asm25903254c88.6.2026.08.20.02.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 02:26:47 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Thu, 20 Aug 2026 14:55:48 +0530
Subject: [PATCH 6/7] greybus: Add Rust UART node driver
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-gb-uart-transport-v1-6-282da14ab7b7@beagleboard.org>
References: <20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org>
In-Reply-To: <20260820-gb-uart-transport-v1-0-282da14ab7b7@beagleboard.org>
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
 Conor Dooley <conor+dt@kernel.org>
Cc: greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org, 
 rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, Ayush Singh <ayush@beagleboard.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=12132;
 i=ayush@beagleboard.org; h=from:subject:message-id;
 bh=UuyGoF4kmMy8N8Cu2tekiMDft2rlXAE3u99nVrxSo9k=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqhsgcmcx5fQh2qYflEPpgEjhJIEc+eJYImU/T+
 pxxsFxMhtKJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCaobIHAAKCRAFzvXHieVa
 dPemD/9b3IKtiGh4p4NLG6UoaiRrIA0kMg9nAqiLgYCSqP4I7a99CxMaFCc9nmpzvkq8v31Tmov
 6kxSPylmQMBcCOasM76NAIWHIQEWUVkhJz7EUgfVwrRAiZXj9IPwRtxgue2GQ7jjAS4qV3LbFbN
 hJlN0NU9uT1yAize9W8jdn0yxu6D+5iGK2W/Y5qYcm0283seTnphnIS9X7dr85ZEqa6JBCYJjhs
 l2q10hTg97dHAusY1GOch0JG10QV3H/IxDt9zX4FZXnPfj6QVD6G8feu/EQ701UjzoIjshl1xOJ
 2MFLKpNcxX29bvPm5GgfUgzoNzEhDy7NFH+sQmBmSY3QA97RQ/uNE5QvP8XIhyYzIFRszFl0S7V
 cJeelFGx62CIBwlTfy/wgrDIiAmYqPrl1NmsQbBi7IyRgVZgSTM6Tio/8Md5gCm4BXBw5eNOnF7
 JQS0KZc0lBahablpIk41cY3vkwHAdkVqLkTYBY5WZay3liWdwmIyq62haZDaLWUEkK3Wl4PAkZK
 mJYTTpICNSHMeksrpnQ/6Rsh4/pIE3yBYWEF+x8aW7AMuFouyPO3Rw8RStc1ARuPT8vg3x7qqiT
 mr02PqoZ7fcPbWeF6bmV+JChfZ8vkK5WWbOIUvBaMz9Qkve5TqLKmgB4CjlXNpEfQc73k61atgX
 R7oclwSxexixVEg==
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
 MAINTAINERS                     |   6 ++
 drivers/greybus/.gitignore      |   1 +
 drivers/greybus/Kconfig         |  15 +++
 drivers/greybus/Makefile        |  48 +++++++++
 drivers/greybus/gb_uart_node.rs | 231 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 301 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3ba56cdbf056..037a87b74800 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11334,6 +11334,12 @@ L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/greybus/gb_softsvc.rs
 
+GREYBUS UART NODE DRIVERS
+M:	Ayush Singh <ayush@beagleboard.com>
+L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/greybus/gb_uart_node.rs
+
 GREYBUS SUBSYSTEM
 M:	Johan Hovold <johan@kernel.org>
 M:	Alex Elder <elder@kernel.org>
diff --git a/drivers/greybus/.gitignore b/drivers/greybus/.gitignore
new file mode 100644
index 000000000000..ff9c4a3539b4
--- /dev/null
+++ b/drivers/greybus/.gitignore
@@ -0,0 +1 @@
+exports_gb_softsvc_generated.h
diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
index 30bc491841e1..b6f687e6da1a 100644
--- a/drivers/greybus/Kconfig
+++ b/drivers/greybus/Kconfig
@@ -53,5 +53,20 @@ config GREYBUS_SOFTSVC
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
index 000000000000..125812246758
--- /dev/null
+++ b/drivers/greybus/gb_uart_node.rs
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Greybus UART Node driver
+
+use kernel::crc_ccitt::crc_ccitt;
+use kernel::device::AsBusDevice;
+use kernel::device::{Bound, Core};
+use kernel::error::code;
+use kernel::sync::aref::ARef;
+use kernel::sync::{Arc, SpinLock};
+use kernel::{new_spinlock, of, prelude::*, serdev};
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
+        let payload = &self.rx_buf[2..self.rx_buf.len() - size_of::<u8>()];
+
+        match addr {
+            ADDRESS_GREYBUS => {
+                let frame = GreybusFrame::ref_from_bytes(payload).map_err(|_| code::EINVAL)?;
+                self.node.submit_message(frame.cport.into(), &frame.msg)
+            }
+            _ => Err(code::EINVAL),
+        }
+    }
+
+    fn rx(&mut self, data: &[u8]) -> usize {
+        for (count, i) in data.iter().enumerate() {
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
+                    if self.rx_buf.push(c, GFP_KERNEL).is_err() {
+                        return count;
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
+    fn write_all(mut crc: u16, bound: &serdev::Device<Bound>, data: &[u8]) -> Result<u16> {
+        for i in data {
+            if *i == HDLC_ESC || *i == HDLC_FRAME {
+                let buf = &[HDLC_ESC, i ^ HDLC_XOR];
+                bound.write_all(buf, 0)?;
+                crc = crc_ccitt(crc, buf);
+            } else {
+                bound.write_all(&[*i], 0)?;
+                crc = crc_ccitt(crc, &[*i]);
+            }
+        }
+
+        Ok(crc)
+    }
+}
+
+impl gb_softsvc::InterfaceOps for GbNode {
+    fn write(&self, data: &[u8], cport: u16) -> Result<()> {
+        // SAFETY: `GbNode` only exists while its serdev driver is bound, so the device is in the
+        // `Bound` state for the duration of this call.
+        let bound: &serdev::Device<Bound> =
+            unsafe { serdev::Device::from_device(self.sdev.as_ref().as_bound()) };
+
+        let mut crc = 0xffff;
+
+        bound.write_all(&[HDLC_FRAME], 0)?;
+
+        crc = Self::write_all(crc, bound, &[ADDRESS_GREYBUS, 0x03])?;
+        crc = Self::write_all(crc, bound, &cport.to_le_bytes())?;
+        crc = Self::write_all(crc, bound, data)?;
+
+        crc ^= 0xffff;
+        Self::write_all(crc, bound, &crc.to_le_bytes())?;
+
+        bound.write_all(&[HDLC_FRAME], 0)?;
+
+        Ok(())
+    }
+}
+
+#[pin_data(PinnedDrop)]
+struct GbUartNode {
+    sdev: ARef<serdev::Device>,
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
+        let rx = Self::init(sdev);
+
+        try_pin_init!(Self {
+            sdev: sdev.into(),
+            rx <- new_spinlock!(rx?, "gb_uart_node::rx"),
+        }? Error)
+    }
+
+    fn receive<'bound>(
+        _sdev: &'bound serdev::Device<Bound>,
+        this: Pin<&Self>,
+        data: &[u8],
+    ) -> usize {
+        let Some(mut guard) = this.rx.try_lock() else {
+            return 0;
+        };
+
+        guard.rx(data)
+    }
+}
+
+#[pinned_drop]
+impl PinnedDrop for GbUartNode {
+    fn drop(self: Pin<&mut Self>) {
+        dev_dbg!(self.sdev.as_ref(), "Remove gb_uart_node.\n");
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

