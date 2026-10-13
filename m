Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379BC4ED1B4
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 12:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892957; cv=none; b=bbOZHf4vMboSI5N2YLm/Y3zpM54y3co/pD4PJe3mMdM0fHOOFQEqX9HVGQisvkGKAwDJb0jfnEMVwsAH0WmWzjClZQ/cjaA//eE1jqvvAS3ZISU2xzcOzEy0qvP2j08JMH7MRhHvrEZG16gTgBd42cKgmmKY8543H9xEH2V4NC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892957; c=relaxed/simple;
	bh=nGsxjhbx9MCg96U4aqm0eCBgu16yp0S0WMMfG5atNeA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TXfC+f76Cxjs4fx2++ZvA/2DMk+y5sEwH6hWhL8lvOa8uDMZWh3lY45vxLIP/9Bsmdp1Kq/1LNZX+d1eHxDvZJHyEihyyBRE9cppKCiQwIXD0naX7LYUwjX8bbHOcPV4a/48qBtn9upDs5FyhEJI4dYKyA0TyS+iAeTaugulf4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=GiN3WJwc; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="GiN3WJwc"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3ab450c0873so2292507a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 05:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1791892955; x=1792497755; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cPDQk+Pu7w11VvyfHDoih/RXZuCuiRsJufRNeX6GVn0=;
        b=GiN3WJwctbdqC/cb5+kEb7F48CXYrcHDs9qYaSj4k6fvno6Ygt7122XroKhY8qJL50
         0ylY5Q8CL67n4W+enHrrVcrPj4QR/jMgwFSl8J7o9DEpiWVqbNT4caJUyXX7aGoAPLyp
         RLoNQGjsM5MsDLO7mlwkHNfzo0kU0SaL1oYpO3qY3RxoQPvKtBGJcuxK6W8fW9g3NHTa
         X1e6JlkfdxVNbL+GdzPZb7em61HVLLnSo92HjrFqyW1zv/AgjLgiX0ULkFJTNE2ckh5T
         XngW/Hj1DCY7M2wwpZsedUFBq+tKxCbY3cMTgFI/c+xHW2PTFylK3iCsdBME5YBulii3
         MhVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791892955; x=1792497755;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cPDQk+Pu7w11VvyfHDoih/RXZuCuiRsJufRNeX6GVn0=;
        b=VrFoAi8ALwgt9d8I2yZ+YPNIveAYALL0q9f43PMh1NkQpP09gFe5I61IWW2ynQA4K1
         2IsUB7jl7YWSkwT2Ca+3Pkiz7CMHrp28BumTlsDqwySOwmkj7y+7giGDI0Pw1KjoeBRi
         JadznR5gQ6Qqc6pSVuMlhAZrlU8KQbHnQ7NDwjTs2hx63u689oDmUth08DgIITd7o6pT
         5ioJkvwQgyeGDfkgYG/9qVLaVq6f2G1AE1aqSes1MSEVp9VBz1xHEfKu6uMbg0uuuSSE
         vlq0EbaCi0nSW47lBdHLuNCbHLncbcBayLG1uDeNY99RwvNXLOI6zV5Rh5+FlYl/MvCg
         WqvQ==
X-Forwarded-Encrypted: i=1; AKwUvBw79DpXUf/gbT5WgYZK4suuhkOqOHmbtqqngXm5SAFYsQFGBQxjMAvVKzcm9E8Io6w4nLr1/KEjBnMNdGs=@vger.kernel.org
X-Gm-Message-State: AFq9FYIXJgs7ooXrorDzpF4NIrKWDksGX7bn7tYBYVKV5MRo6KTmWADk
	EWh8WidgenHbmSxeVTDXwrAaOXAsdwTF+0jX7iT34LafkIwgOIod8p3Mjbs/Eooj1w==
X-Gm-Gg: AYBFou0k2NwAncVqAbCWOdUCFxfTRiVNbhLAEy6MUMd45mSWuaHV3aPoK7ARYqDUSzz
	pK00HhVhJ9aWNf5NLD26eiP5Mh5eY+2PfwHXH5ns2nVQgtw5abZc/PcT7Kkkr2OV7mtsz7h3iqf
	brauMGcl2cicW0IA6iLG29ebkK/k8KER0lXxbZNdHiATB7SIZXrAU8d8Po10yoQycRf4DCWWL/t
	sFJKqtFPQVrnG8Pc2UkmZKMnlbWuIW1w3gDHIJOgXAUsHJXTbSy7C/u286wdwtiCl5X4A9W3tlg
	8JNZGBM37Rdq464M/ELDGdPy5b5bUVrOvdrmzdryZrltX7rFBPRx0i4t78D+9PccfS6IKNCXT9H
	bqsFxIlR1UP27boDvmG9X8q/qhHAK0e9+ULx3jrJCDxah9dsglPNdbvwqxhDoxTjjxNrFmUNMoG
	ZfPp8Rf0AI6i7PB4SmqxAq2MFcAI0sxkQPj53JnNpxOwH9pAewqqoQoyMFy8TkNYRexnkZeFDfj
	RNGYK99pQ==
X-Received: by 2002:a17:90b:2644:b0:3ab:d45c:59da with SMTP id 98e67ed59e1d1-3abd45c5a6amr5432086a91.40.1791892955192;
        Tue, 13 Oct 2026 05:02:35 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab8a393666sm16566838a91.15.2026.10.13.05.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 05:02:33 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Tue, 13 Oct 2026 17:30:45 +0530
Subject: [PATCH v3 7/7] greybus: Add Rust UART node driver
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-gb-uart-transport-v3-7-81d0a8a1acf7@beagleboard.org>
References: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
In-Reply-To: <20261013-gb-uart-transport-v3-0-81d0a8a1acf7@beagleboard.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=12749;
 i=ayush@beagleboard.org; h=from:subject:message-id;
 bh=nGsxjhbx9MCg96U4aqm0eCBgu16yp0S0WMMfG5atNeA=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqzh2D5HR3YnxQ03GSS/difzCuGHAxgC3R3phEv
 pFwr8cu6FSJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCas4dgwAKCRAFzvXHieVa
 dEyUEADerXJcu4asewB4uMzuiXmET0pnKTeeQRTEXjtXeinE+SEaO1rmdL2e7XZo0M90R3yWsD1
 iavKmWCc8pH8YhfMPYvyKn+xV9Rb1chkigfBDjZiavV+vtWI84UWxFzNdGn/85VpRYKpcOSgiUX
 KpIP7J5OqnibmEgz1yo/yc7fmMwxchfzV7fsHC36xxykFkDOOosPkFQV25Pmh5McaNH+B48khfd
 QGzfUkw0Ux6A5MNU6LQjYLNFMSY9ptR+IowCcnZshftpO7n+HoVn5TBa7AfcGUKCgSCrERq7Zno
 f6QOmeJeiSfq9GbRgyXl5j4/Y/UdkcJi2rAckP8FkPGpajd/+E+VJ2jjOr39laaypqcHIkhoQES
 mUJLGe0A5vJ1c3RjQCy9uiJriGFfagF5SqjSrsGJNWAZngSJvRNJetXfnPtcd3exReRGRdaPrj6
 z8KyzgYw2/DRoRgY/27FacrkStOnOL3AIadYsyvo6AivqQI6OiUYoWpZAaaqjImB950iaJxzPOu
 SAcOCFqEgQr9yVuCBVScaeheul8jdDx4YEkiw/UQv8Z3wm5Kz1KCFpBH6gMpTL03eBQyS7kbomg
 vqYUoisqroHkozCHnFz/9cQ2CC9DBJ2WWxnmN1WPCDOngRKrByjbdzDtr8ETA5Ourf7KxgToHGG
 5n7Z/7OroUx+koQ==
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
 drivers/greybus/gb_uart_node.rs | 253 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 318 insertions(+)

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
index e6f594128802..bf4d08f728fe 100644
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
+# Output gb_softsvc's crate metadata for use by gb_uart_node at compile time.
+RUSTFLAGS_gb_softsvc.o += \
+	--emit=metadata=$(objtree)/$(obj)/libgb_softsvc.rmeta
+
+# Allow nova-drm to import nova-core's types.
+$(obj)/gb_uart_node.o: $(obj)/gb_softsvc.o
+RUSTFLAGS_gb_uart_node.o := -L $(objtree)/$(obj) --extern gb_softsvc
diff --git a/drivers/greybus/gb_uart_node.rs b/drivers/greybus/gb_uart_node.rs
new file mode 100644
index 000000000000..f719ee35e8f3
--- /dev/null
+++ b/drivers/greybus/gb_uart_node.rs
@@ -0,0 +1,253 @@
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
+        // This also drops HdlcRx::node, which should ensure that GbNode::write will not be called
+        // after this point.
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
2.56.0

