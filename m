Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792582738;
	b=SJ1dG3x4Nfx/sT8tFsp6Rewpth1ZgGo+VPj7SJwhJeRLt2Qjf2hIAvXkQ6NU/h+UtxYp
	 ym6lsnpemVizy3IF6UgCYbbBArf+LvLgCUGVrJyiSiescfo4VrwXBGzlywkaCKYEPDlDJ
	 jl2l5dYwD0ZFdJVxS0xzd7w20z9nEkdwsDsjqmyQq2x6gZRdzB+9rqQbwIPA4sgpq76w0
	 2PT1wLaVX6iHdf1P3YWdWjSyKO1YxQbgIZ8M9M17IhU65AktVClY26FDpTdMJg/qkuxOV
	 xq33sqqRbPmPmQ+v9sc1/eHkptoWhgVPbqJcRK4xDAqh6JLIMlB6KEUwu8BDfyG7/WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792582738;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=fED4JpmOp61wjaCjNReVcAtx8yRLiX3HC88XsoVc9Q8=;
	b=WZMLmV6UvBA6tG9dWsv0HlMr8Un5xuWlH2yC+PceAkyY2tatiy9YgkApS5mxj96zX5Zt
	 b6dHfIvZev/hiHyfVtVLp8lg0YVnV9g1ukl266RJuULutRd8G5GvJoqJY13hGUEWjGB7x
	 uA7qOusIR7t4vuve9F6//97i8/dUZohC+beSh4KxDFMyYZQiJDZ12iqaiNoN3xACThe9o
	 tswbFF+IIfJnXCYuYAg6OoCMhKn3nI4PJqexbIVrKPc/ythvdx5OJS40B2YdEnBFTEBxk
	 tV8rI5vNRCP0VAQDmJ+o98PVG0OHI95aYMNsgRFJH3eKnigL8fqaAT5Huz/K+j+PFNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=beagleboard.org;
	spf=fail smtp.mailfrom=beagleboard.org;
	dkim=pass header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b="aaN/MsJr";
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31463606A31B
	for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 11:38:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31463606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=beagleboard.org header.i=@beagleboard.org header.a=rsa-sha256 header.s=google header.b=aaN/MsJr
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3a4b9732d5aso584533a91.3
        for <linux-crypto@vger.kernel.org>; Wed, 21 Oct 2026 04:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1792582736; x=1793187536; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fED4JpmOp61wjaCjNReVcAtx8yRLiX3HC88XsoVc9Q8=;
        b=aaN/MsJrsh8q/RAW7hA3Pn2XQn6NFMkR94uyo0VWuowASq1sFoLS2yB5swOceVgWRt
         uyuqKBnnGdI9T9qN4I5FRDad0gxGGuTRolgqD2MTsPA3poAkMIepE1jS3Z/XFKhvUFki
         UIUMSIQvECQ+WdnBia0CPjDt7uFwev0c4COQtyzQdGVnnCD2AUNuwOD7kBa3RPIfwtYe
         BoV5CQlWG5S2IAcdHCzs4iR5ljmzjraqgMTDCMyYDU80S/KOV/4YJE50ULAKY4KvRrEZ
         nwqTMfWAYaIkMlhik9RzUNRy9GEg3U6CwFowupP9FA2ixW6Kdj6j9am0J5ivFzIr+3A1
         xtwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792582736; x=1793187536;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fED4JpmOp61wjaCjNReVcAtx8yRLiX3HC88XsoVc9Q8=;
        b=tN3FnzDv3cJJWzSnItOC9cZG87qvF/c4Shh0MFu2mSP1UovEy/1ayhM9oKIs0KUib2
         UkUU9eaqvcTYzUPlJ88+a0YqaWBF2NBX8DgaYJiIRfd+ruBHQp1YQ+yMxusMQsvpWKhN
         Dqvpmf6VaVz6AmzueFLiD+wDoX0SsdBXnRcUi8YIoK8JzV844irZJDdEDC4RHmfQTQ1x
         ExJI+UJD5gwWw67fkyQnRN6aF6UDW/TvrGTEsII+Ar+15ZxIEuqnrU1fUh/fpSZVcZ54
         U2A49b+naSU+FMfUbDkugy/5KoIHE6hc4Hu87XyNQvgfmkulcVCFAXu128frfLtYO5ok
         Qo4A==
X-Forwarded-Encrypted: i=1; AKwUvBy47UkuVp1+cRbeJjmBieK5ojGBqT2aGiZrVNVeQ5l5Shq84dIyHs+1DSLV0NAPG1CqUS/sXfUWC/Hv9hk=@vger.kernel.org
X-Gm-Message-State: AFq9FYLVRC+kryDC7pvWK8ZLmc8XHVj+gWfMc/KqNSaX+88yYwQVs0tl
	9JDHfFaiao/pEova2/Nma3ZYIB4lsn7MaVBZgyhUStQdmDn9yKSqR9J+73nv/EiOmA==
X-Gm-Gg: AYBFou0fra/xMjHDCWkw/5X01eoE5bJx/sN1QN6kELokogAtzLzBLcxSsZpzfvn6Amc
	kA9x3KoNoF6ovOuiW5YX3wenUwYmCNhG8CL7g53jIue+DTvD4kU+B5MN7vij4jpHWx/5IyfeL5c
	vDFDnOBi3b8hASrLBmi+TXZ+5Xfp7BiqUgJPUOJzpJYFN79sNCDTQVYNr6tzAlaa7lbhWO+Bjv+
	UzHFUrhrTIEaYpz8WNe5xtOkY8AoWO/PTrnqRuRfLWl2J6a7BrGDBxZUusLp7S5HAM7qUtGaet7
	WiUUaf8H7Z6L9bRzJBvg2MRkZA82YeaVhAH+mxitwB8JWWcyCwsg2FaV2JnhygAkztAcfTJfvE4
	LxwmQ2R17/e1V5sOJouznTWrUXoJ+f6F+rZ+gInRvcCQhFID4Mmrowi4zar1UbfoQiJ9/0nwU9K
	Dkhcpzdp0p5QOZxtNEaxCe1VsZF6LGsT+2tEU8ZHVoaqnwagQ9PUiovlMglTgloq2X5Lahmq9ly
	3v/iQp/A4siwDLvd0IRxv3WClBgkXP2iP8tye4wVAqfV4a8CQKOIftmf2xzBtYJpPW5
X-Received: by 2002:a17:90b:5645:b0:3ac:b7b9:6471 with SMTP id 98e67ed59e1d1-3ad8707b58bmr1366254a91.65.1792582736386;
        Wed, 21 Oct 2026 04:38:56 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad813eb9casm4023732a91.15.2026.10.21.04.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 04:38:53 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Wed, 21 Oct 2026 17:07:52 +0530
Subject: [PATCH v4 4/6] drivers: greybus: Add software SVC implementation
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
Content-Transfer-Encoding: 8bit
Message-Id: <20261021-gb-uart-transport-v4-4-c308ce821d45@beagleboard.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=23919;
 i=ayush@beagleboard.org; h=from:subject:message-id;
 bh=fs4gndOXpFOPljF0g/QK2l8CP37jJuyhcx7I6Ghu6VQ=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBq2KQUOouQXbdkwjtujP/Xrpo3sCxSrBOiSNXNT
 UH1e14JXlqJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCatikFAAKCRAFzvXHieVa
 dFCHEACmMzPiIr9veD3FNodVRz1vIGJbXeO++YpvCGfcpM5s4mCbzth6uPCr0na1ENE4yFvRJkd
 S/fWudm6Zy7nVz78yxNInE+PQFLm+Gq588oklyMXueu24VhAkQil/4ZjeLxAVepF8au1w+DEAGi
 gv3R0/jLySF6GFUILyDVKAHDv6FtjD61lLyqOxtTDk0DTakeKKdubVuSMd/jz8N7Fd7+ctaZBDd
 7OuHkWLI44zjeUuPEIWX5kz9ciXgU+rsFEY7oFD4H1JRRWQ/vtp+qfJe63Um8oFgskpMtmNrmyJ
 DFWRGjisQcWvr5WGT0D5JO40ibgf0pxKELYBvSgLilOoJIFWH3Ih4cIn9tGiGDWt69aLClSvIms
 3KTCVRVwb/Q7utxq426IVpcYOr7AybxDmcg3MLZAc2X+mXTGvW8LmwaTeKdJpvaqLvq5z/3pmxQ
 LC4OK3hhMM+zCPvQEZb/adbVWURtq1a5IVIqdEAUPZUciiFV4DJbmOq8vQRrn5TTznV2eHN4UAy
 1gtqLZMc52GGb8lZCVAYZnuCNOYzMIrRUJ3eba9esQ+cuJ/zcd7xa+y3VwzL7/w3wPxIvgGnMR3
 3rJA8LiGdQg9QTRm1+PU26KA8pjVcZeLrlx3BLn7l4wsl58s0/pylZP50IqQBCEQY/lyjvNBdQ7
 TgzJfziCybu4kZw==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

A Greybus network requires an SVC (Supervisory Controller) to bring
interfaces up, assign device IDs and connect CPorts to the AP. On a
UniPro network the SVC is a real entity on the bus, but transports that
merely carry Greybus messages - a UART, an I2C bus, a network link -
have no such entity, so every host driver for those transports ends up
open-coding an SVC emulation of its own.

Add gb-softsvc, a Rust implementation of the SVC that lives in the
kernel and registers itself as a Greybus host device. It answers the
SVC-side operations the core expects during interface bring-up and
teardown.

Host drivers use it through a small in-kernel interface. A driver
implements the NodeOps trait to send data towards its node and then
calls module_insert() to announce a new node, submit_message() to hand
incoming Greybus messages back to the core, and module_remove() on
disconnect. Interface IDs are allocated by the SVC and returned from
module_insert().

Connection create/destroy and interface activate/resume currently just
acknowledge the request; callbacks into NodeOps can be added later if
transports need to act on them.

gb_softsvc_exports.c exports the Rust symbols for dependent modules, as
the build system does not yet support Rust cross-module dependencies
natively. This hack is taken from nova-core [0].

[0]: https://lore.kernel.org/all/20260622-nova-exports-v5-0-6191773fc977@nvidia.com/

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 MAINTAINERS                          |   6 +
 drivers/greybus/Kconfig              |  12 +
 drivers/greybus/Makefile             |  40 +++
 drivers/greybus/gb_softsvc.rs        | 520 +++++++++++++++++++++++++++++++++++
 drivers/greybus/gb_softsvc_exports.c |  15 +
 5 files changed, 593 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4d98db7618c3..c9126dc205db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11516,6 +11516,12 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/ti,cc1352p7.yaml
 F:	drivers/greybus/gb-beagleplay.c
 
+GREYBUS SOFTSVC DRIVERS
+M:	Ayush Singh <ayush@beagleboard.org>
+L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/greybus/gb_softsvc.rs
+
 GREYBUS SUBSYSTEM
 M:	Johan Hovold <johan@kernel.org>
 M:	Alex Elder <elder@kernel.org>
diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
index d9f52024d1c2..709563f8c0ad 100644
--- a/drivers/greybus/Kconfig
+++ b/drivers/greybus/Kconfig
@@ -49,5 +49,17 @@ config GREYBUS_ES2
 	  To compile this code as a module, choose M here: the module
 	  will be called gb-es2.ko
 
+config GREYBUS_SOFTSVC
+	tristate "Greybus software SVC"
+	depends on RUST_GREYBUS_ABSTRACTIONS
+	help
+	  Select this option to enable a software implementation of the
+	  Greybus SVC (Supervisory Controller) running in the kernel. It can
+	  be used by host drivers that talk to a Greybus network which does
+	  not provide an SVC of its own.
+
+	  To compile this code as a module, choose M here: the module
+	  will be called gb-softsvc.ko
+
 endif	# GREYBUS
 
diff --git a/drivers/greybus/Makefile b/drivers/greybus/Makefile
index d986e94f8897..0fa802fdf6ca 100644
--- a/drivers/greybus/Makefile
+++ b/drivers/greybus/Makefile
@@ -25,4 +25,44 @@ gb-es2-y := es2.o
 
 obj-$(CONFIG_GREYBUS_ES2)	+= gb-es2.o
 
+obj-$(CONFIG_GREYBUS_SOFTSVC)	+= gb-softsvc.o
+gb-softsvc-y			+= gb_softsvc.o gb_softsvc_exports.o
 
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
diff --git a/drivers/greybus/gb_softsvc.rs b/drivers/greybus/gb_softsvc.rs
new file mode 100644
index 000000000000..f88d9b3fd565
--- /dev/null
+++ b/drivers/greybus/gb_softsvc.rs
@@ -0,0 +1,520 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Greybus software SVC.
+//!
+//! A Greybus network needs an SVC to bring interfaces up and to connect their CPorts to the AP.
+//! Transports that carry Greybus without one - a UART or an I2C bus rather than a UniPro network -
+//! have to provide it themselves.
+//!
+//! This module implements that SVC in software.
+
+use kernel::{
+    alloc::Flags,
+    c_str,
+    error::code,
+    faux,
+    greybus::{
+        self,
+        hd,
+        protocols,
+        CPORT_ID_MAX,
+        GB_OPERATION_SIZE_MAX, //
+    },
+    id_pool::IdPool,
+    new_spinlock,
+    prelude::*,
+    sync::{
+        aref::ARef,
+        Arc,
+        SpinLock, //
+    },
+    transmute::AsBytes,
+};
+use pin_init::init_array_from_fn;
+
+const SVC_VERSION_MAJOR: u8 = 0;
+const SVC_VERSION_MINOR: u8 = 1;
+
+const ENDO_ID: u16 = 0;
+const AP_INF_ID: u8 = 0;
+
+const TOSHIBA_DMID: u32 = 0x0126;
+
+const MAX_INTF_ID: u8 = u8::MAX;
+const INTF_ID_START: u8 = 1;
+const INTF_MAP_LEN: usize = (MAX_INTF_ID - INTF_ID_START) as usize;
+
+#[repr(C, packed)]
+struct Msg<P> {
+    hdr: protocols::GbOperationMsgHdr,
+    payload: P,
+}
+
+// SAFETY: `Msg` is `repr(C, packed)`, so it has no padding between its fields, and both fields
+// are `AsBytes`, so neither has uninitialized bytes of its own.
+unsafe impl<P: AsBytes> AsBytes for Msg<P> {}
+
+impl<P> Msg<P> {
+    const GB_SIZE: u16 = size_of::<Self>() as u16;
+
+    /// Builds a request of type `ty`.
+    ///
+    /// An `operation_id` of zero marks a unidirectional request, for which the AP sends no
+    /// response.
+    const fn request(operation_id: u16, ty: u8, payload: P) -> Self {
+        Self {
+            hdr: protocols::GbOperationMsgHdr::new(Self::GB_SIZE, operation_id, ty, 0),
+            payload,
+        }
+    }
+
+    /// Builds the response to `request`, carrying `result`.
+    const fn response(request: &protocols::GbOperationMsgHdr, result: u8, payload: P) -> Self {
+        Self {
+            hdr: protocols::GbOperationMsgHdr::new(
+                Self::GB_SIZE,
+                request.operation_id(),
+                request.msg_type() | protocols::MESSAGE_TYPE_RESPONSE,
+                result,
+            ),
+            payload,
+        }
+    }
+}
+
+const _: () = assert!(size_of::<Msg<()>>() == size_of::<protocols::GbOperationMsgHdr>());
+
+module! {
+    type: GreybusSoftSvc,
+    name: "gb_softsvc",
+    authors: ["Ayush Singh <ayush@beagleboard.org>"],
+    description: "Greybus software SVC implementation",
+    license: "GPL",
+}
+
+kernel::sync::global_lock! {
+    unsafe(uninit) static GLOBAL_STATE: Mutex<Option<GlobalState>> = None;
+}
+
+struct GlobalState {
+    svc: Arc<Svc>,
+    gb_hd: ARef<hd::Device>,
+}
+
+impl GlobalState {
+    fn new(svc: Arc<Svc>, gb_hd: ARef<hd::Device>) -> Self {
+        Self { svc, gb_hd }
+    }
+}
+
+#[pin_data]
+struct Svc {
+    #[pin]
+    svc_operation_id: SpinLock<IdPool>,
+    // Pos 0 = INTF_ID_START
+    #[pin]
+    intf_map: SpinLock<[Option<Arc<dyn InterfaceOps>>; INTF_MAP_LEN]>,
+}
+
+impl Svc {
+    fn new() -> impl PinInit<Self, Error> {
+        pin_init!(Self {
+            intf_map <- new_spinlock!(init_array_from_fn(|_| None)),
+            svc_operation_id <- new_spinlock!(IdPool::with_capacity(u16::MAX.into(), GFP_KERNEL)?)
+        }? Error)
+    }
+
+    fn new_operation_id(&self) -> Result<u16> {
+        let mut ida = self.svc_operation_id.lock();
+        let res = ida.find_unused_id(1).ok_or(code::EOVERFLOW)?.acquire() as u16;
+
+        Ok(res)
+    }
+
+    fn release_operation_id(&self, id: u16) {
+        let mut ida = self.svc_operation_id.lock();
+        ida.release_id(id as usize);
+    }
+
+    fn map_insert(&self, intfs: &[Arc<dyn InterfaceOps>]) -> Result<u8> {
+        fn find_empty_window(
+            intf_map: &[Option<Arc<dyn InterfaceOps>>; INTF_MAP_LEN],
+            count: usize,
+        ) -> Result<u8> {
+            for (id, window) in intf_map.windows(count).enumerate() {
+                if window.iter().all(|x| x.is_none()) {
+                    return Ok(id as u8);
+                }
+            }
+
+            Err(code::EOVERFLOW)
+        }
+
+        let mut guard = self.intf_map.lock();
+
+        let pos = find_empty_window(&guard, intfs.len())?;
+        for (i, intf) in intfs.iter().cloned().enumerate() {
+            guard[usize::from(pos) + i] = Some(intf);
+        }
+
+        Ok(pos + INTF_ID_START)
+    }
+
+    fn map_remove(&self, primary_id: u8, intf_count: u8, dev: &kernel::device::Device) {
+        let id = match primary_id.checked_sub(INTF_ID_START) {
+            Some(x) => x,
+            None => {
+                dev_warn!(dev, "Invalid interace id");
+                return;
+            }
+        };
+
+        for i in 0..intf_count {
+            let _ = self.intf_map.lock()[usize::from(id + i)].take();
+        }
+    }
+
+    fn intf_by_id(&self, id: u8) -> Result<Arc<dyn InterfaceOps>> {
+        let id = id - INTF_ID_START;
+        let guard = self.intf_map.lock();
+
+        guard
+            .get(usize::from(id))
+            .ok_or(code::ENODEV)?
+            .as_ref()
+            .ok_or(code::ENODEV)
+            .cloned()
+    }
+
+    fn send_request<P: AsBytes>(&self, hd: &hd::Device, ty: u8, payload: P) -> Result<()> {
+        let msg = Msg::request(self.new_operation_id()?, ty, payload);
+        hd.data_rcvd(protocols::GB_SVC_CPORT_ID, msg.as_bytes());
+        Ok(())
+    }
+
+    fn module_insert(&self, hd: &hd::Device, intfs: &[Arc<dyn InterfaceOps>]) -> Result<u8> {
+        let intf_id = self.map_insert(intfs)?;
+        // map_insert already checks that intf len fits in u8
+        let intf_count = intfs.len() as u8;
+
+        let payload = protocols::GbSvcModuleInsertedRequest::new(intf_id, intf_count, 0);
+        let res = self.send_request(hd, protocols::GB_SVC_TYPE_MODULE_INSERTED, payload);
+
+        if res.is_err() {
+            self.map_remove(intf_id, intf_count, hd.as_ref());
+        }
+
+        res.map(|()| intf_id)
+    }
+
+    fn module_remove(&self, hd: &hd::Device, intf_id: u8, intf_count: u8) -> Result<()> {
+        let payload = protocols::GbSvcModuleRemovedRequest::new(intf_id);
+        let res = self.send_request(hd, protocols::GB_SVC_TYPE_MODULE_REMOVED, payload);
+
+        if res.is_err() {
+            dev_warn!(
+                hd.as_ref(),
+                "Failed to send module_removed svc request for {}",
+                intf_id
+            );
+        }
+
+        self.map_remove(intf_id, intf_count, hd.as_ref());
+
+        Ok(())
+    }
+
+    fn send_version(&self, hd: &hd::Device) -> Result<()> {
+        dev_info!(hd.as_ref(), "Sending SVC version request");
+
+        let payload = protocols::GbSvcVersionRequest::new(SVC_VERSION_MAJOR, SVC_VERSION_MINOR);
+        self.send_request(hd, protocols::GB_SVC_TYPE_PROTOCOL_VERSION, payload)?;
+
+        Ok(())
+    }
+
+    fn send_svc_hello(&self, hd: &hd::Device) -> Result<()> {
+        dev_info!(hd.as_ref(), "Sending SVC Hello request");
+
+        let payload = protocols::GbSvcHelloRequest::new(ENDO_ID, AP_INF_ID);
+        self.send_request(hd, protocols::GB_SVC_TYPE_SVC_HELLO, payload)?;
+
+        Ok(())
+    }
+
+    fn send_response<P: AsBytes>(
+        &self,
+        hd: &hd::Device,
+        msg: &protocols::GbOperationMsgHdr,
+        payload: P,
+    ) {
+        let msg = Msg::response(msg, 0, payload);
+        hd.data_rcvd(protocols::GB_SVC_CPORT_ID, msg.as_bytes());
+    }
+
+    fn intf_set_pwrm(&self, hd: &hd::Device, msg: &greybus::Message) -> Result<()> {
+        let req_msg: &protocols::GbSvcIntfSetPwrmRequest = msg.payload().ok_or(code::EINVAL)?;
+        let result_code = if req_msg.tx_mode() == protocols::GB_SVC_UNIPRO_HIBERNATE_MODE
+            && req_msg.rx_mode() == protocols::GB_SVC_UNIPRO_HIBERNATE_MODE
+        {
+            protocols::GB_SVC_SETPWRM_PWR_OK
+        } else {
+            protocols::GB_SVC_SETPWRM_PWR_LOCAL
+        };
+
+        let payload = protocols::GbSvcIntfSetPwrmResponse::new(result_code);
+        self.send_response(hd, msg.header(), payload);
+
+        Ok(())
+    }
+
+    fn dme_peer_get(&self, hd: &hd::Device, hdr: &protocols::GbOperationMsgHdr) {
+        let payload = protocols::GbSvcDmePeerGetResponse::new(0, TOSHIBA_DMID);
+        self.send_response(hd, hdr, payload);
+    }
+
+    fn dme_peer_set(&self, hd: &hd::Device, hdr: &protocols::GbOperationMsgHdr) {
+        let payload = protocols::GbSvcDmePeerSetResponse::new(0);
+        self.send_response(hd, hdr, payload);
+    }
+
+    fn pwrmon_rail_count_get(&self, hd: &hd::Device, hdr: &protocols::GbOperationMsgHdr) {
+        let payload = protocols::GbSvcPwrmonRailCountGetResponse::new(0);
+        self.send_response(hd, hdr, payload);
+    }
+
+    fn intf_vsys_enable_disable(&self, hd: &hd::Device, hdr: &protocols::GbOperationMsgHdr) {
+        let payload = protocols::GbSvcIntfVsysResponse::new(protocols::GB_SVC_INTF_VSYS_OK);
+        self.send_response(hd, hdr, payload);
+    }
+
+    fn intf_refclk_enable_disable(&self, hd: &hd::Device, hdr: &protocols::GbOperationMsgHdr) {
+        let payload = protocols::GbSvcIntfRefclkResponse::new(protocols::GB_SVC_INTF_VSYS_OK);
+        self.send_response(hd, hdr, payload);
+    }
+
+    fn intf_unipro_enable_disable(&self, hd: &hd::Device, hdr: &protocols::GbOperationMsgHdr) {
+        let payload = protocols::GbSvcIntfUniproResponse::new(protocols::GB_SVC_INTF_UNIPRO_OK);
+        self.send_response(hd, hdr, payload);
+    }
+
+    fn intf_activate(&self, hd: &hd::Device, msg: &greybus::Message) {
+        let payload = protocols::GbSvcIntfActivateResponse::new(
+            protocols::GB_SVC_OP_SUCCESS,
+            protocols::GB_SVC_INTF_TYPE_GREYBUS,
+        );
+
+        // TODO: Maybe call a callback?
+
+        self.send_response(hd, msg.header(), payload);
+    }
+
+    fn intf_resume(&self, hd: &hd::Device, msg: &greybus::Message) {
+        let payload = protocols::GbSvcIntfResumeResponse::new(protocols::GB_SVC_OP_SUCCESS);
+
+        // TODO: Maybe call a callback?
+
+        self.send_response(hd, msg.header(), payload);
+    }
+
+    fn conn_create(&self, hd: &hd::Device, msg: &greybus::Message) -> Result<()> {
+        // TODO: Evaluate if we need to add callback to NodeOps
+        self.send_response(hd, msg.header(), ());
+
+        Ok(())
+    }
+
+    fn conn_destroy(&self, hd: &hd::Device, msg: &greybus::Message) -> Result<()> {
+        // TODO: Evaluate if we need to add callback to NodeOps
+        self.send_response(hd, msg.header(), ());
+
+        Ok(())
+    }
+
+    fn handler(&self, hd: &hd::Device, msg: &greybus::Message) -> Result<()> {
+        let hdr = msg.header();
+
+        if hdr.is_response() {
+            self.release_operation_id(hdr.operation_id());
+        }
+
+        match (hdr.is_response(), hdr.request_type()) {
+            (
+                false,
+                protocols::GB_SVC_TYPE_INTF_DEVICE_ID
+                | protocols::GB_SVC_TYPE_ROUTE_CREATE
+                | protocols::GB_SVC_TYPE_ROUTE_DESTROY
+                | protocols::GB_SVC_TYPE_PING,
+            ) => self.send_response(hd, hdr, ()),
+            (false, protocols::GB_SVC_TYPE_CONN_CREATE) => self.conn_create(hd, msg)?,
+            (false, protocols::GB_SVC_TYPE_CONN_DESTROY) => self.conn_destroy(hd, msg)?,
+            (false, protocols::GB_SVC_TYPE_DME_PEER_GET) => self.dme_peer_get(hd, hdr),
+            (false, protocols::GB_SVC_TYPE_DME_PEER_SET) => self.dme_peer_set(hd, hdr),
+            (false, protocols::GB_SVC_TYPE_INTF_SET_PWRM) => self.intf_set_pwrm(hd, msg)?,
+            (false, protocols::GB_SVC_TYPE_PWRMON_RAIL_COUNT_GET) => {
+                self.pwrmon_rail_count_get(hd, hdr)
+            }
+            (
+                false,
+                protocols::GB_SVC_TYPE_INTF_VSYS_ENABLE | protocols::GB_SVC_TYPE_INTF_VSYS_DISABLE,
+            ) => self.intf_vsys_enable_disable(hd, hdr),
+            (
+                false,
+                protocols::GB_SVC_TYPE_INTF_REFCLK_ENABLE
+                | protocols::GB_SVC_TYPE_INTF_REFCLK_DISABLE,
+            ) => self.intf_refclk_enable_disable(hd, hdr),
+            (
+                false,
+                protocols::GB_SVC_TYPE_INTF_UNIPRO_ENABLE
+                | protocols::GB_SVC_TYPE_INTF_UNIPRO_DISABLE,
+            ) => self.intf_unipro_enable_disable(hd, hdr),
+            (false, protocols::GB_SVC_TYPE_INTF_ACTIVATE) => self.intf_activate(hd, msg),
+            (false, protocols::GB_SVC_TYPE_INTF_RESUME) => self.intf_resume(hd, msg),
+            (true, protocols::GB_SVC_TYPE_PROTOCOL_VERSION) => self.send_svc_hello(hd)?,
+            (
+                true,
+                protocols::GB_SVC_TYPE_MODULE_INSERTED
+                | protocols::GB_SVC_TYPE_SVC_HELLO
+                | protocols::GB_SVC_TYPE_MODULE_REMOVED,
+            ) => {}
+            _ => return Err(code::ENOTSUPP),
+        };
+
+        Ok(())
+    }
+}
+
+struct GbHdDriver(Arc<Svc>);
+
+#[vtable]
+impl hd::HdDriver for GbHdDriver {
+    fn message_send(
+        data: &Self,
+        hd: &hd::Device,
+        dest_cport_id: u16,
+        msg: &greybus::Message,
+        gfp_mask: Flags,
+    ) -> Result {
+        if dest_cport_id == protocols::GB_SVC_CPORT_ID {
+            data.0.handler(hd, msg)
+        } else {
+            let conn = msg.operation().connection();
+            let intf = data.0.intf_by_id(conn.interface().unwrap().id())?;
+
+            let mut buf = KVec::with_capacity(msg.header().size().into(), gfp_mask)?;
+
+            buf.extend_from_slice(msg.header().as_bytes(), gfp_mask)?;
+            buf.extend_from_slice(msg.payload_bytes(), gfp_mask)?;
+
+            intf.write(&buf, conn.intf_cport_id(), gfp_mask)
+        }
+    }
+
+    fn message_cancel(_msg: &greybus::Message) {}
+}
+
+struct GreybusSoftSvc {
+    _hd: hd::Registration<GbHdDriver>,
+    _faux: faux::Registration,
+}
+
+impl kernel::Module for GreybusSoftSvc {
+    fn init(_module: &'static ThisModule) -> Result<Self> {
+        pr_info!("gb_softsvc (init)\n");
+
+        // SAFETY: This runs once at module init, before anything else can reach `GLOBAL_STATE`.
+        unsafe { GLOBAL_STATE.init() };
+
+        let faux = faux::Registration::new(c_str!("gb-softsvc"), None)?;
+        let svc = Arc::pin_init(Svc::new(), GFP_KERNEL)?;
+        let data = GbHdDriver(svc.clone());
+
+        let dev = faux.as_ref().as_ref();
+        let hd = hd::Registration::new(dev, GB_OPERATION_SIZE_MAX, CPORT_ID_MAX + 1, Ok(data))?;
+
+        svc.send_version(hd.as_ref())?;
+
+        let global_state = GlobalState::new(svc.clone(), hd.as_ref().into());
+        let _ = GLOBAL_STATE.lock().replace(global_state);
+
+        Ok(GreybusSoftSvc {
+            _hd: hd,
+            _faux: faux,
+        })
+    }
+}
+
+impl Drop for GreybusSoftSvc {
+    fn drop(&mut self) {
+        let _ = GLOBAL_STATE.lock().take();
+        pr_info!("gb_softsvc (exit)\n");
+    }
+}
+
+/// The operations a Greybus interface provides.
+///
+/// A node is whatever sits behind an interface — a real transport, an in-kernel emulation, or
+/// anything else that can accept Greybus traffic. This module does not care which.
+pub trait InterfaceOps: Send + Sync {
+    /// Delivers `data` to the node's `cport`.
+    fn write(&self, data: &[u8], cport: u16, gfp_mask: Flags) -> Result<()>;
+}
+
+/// A module attached to the Greybus network.
+pub struct Module {
+    id: u8,
+    intf_count: u8,
+    gb_hd: ARef<hd::Device>,
+    svc: Arc<Svc>,
+}
+
+impl Module {
+    /// Attaches `node` as a new module and returns the interface id assigned to it.
+    pub fn new(intfs: &[Arc<dyn InterfaceOps>]) -> Result<Self> {
+        let Ok(intf_count) = u8::try_from(intfs.len()) else {
+            return Err(code::E2BIG);
+        };
+
+        if intf_count == 0 {
+            return Err(code::EINVAL);
+        }
+
+        let guard = GLOBAL_STATE.lock();
+        let state = guard.as_ref().ok_or(code::EAGAIN)?;
+        let id = state.svc.module_insert(&state.gb_hd, intfs)?;
+
+        Ok(Self {
+            id,
+            intf_count,
+            gb_hd: state.gb_hd.clone(),
+            svc: state.svc.clone(),
+        })
+    }
+
+    /// Delivers `msg`, received from interface `id` on its `cport`, to the Greybus core.
+    ///
+    /// `intf_id_rel` is the id relative to the actual interface. Eq, if an Module has 3 interfaces
+    /// then the relative id will be 0 or 1 or 2
+    /// `cport` is the interface-side CPort id.
+    ///
+    /// Fails with `EINVAL` if no connection is bound to that pair, or `EAGAIN` if the
+    /// host device has not been brought up yet.
+    pub fn submit_message(&self, intf_id_rel: u8, cport: u16, msg: &[u8]) -> Result<()> {
+        if intf_id_rel >= self.intf_count {
+            return Err(code::EINVAL);
+        }
+
+        self.gb_hd
+            .data_rcvd_by_intf(self.id + intf_id_rel, cport, msg)
+    }
+}
+
+/// Dropping the module drops all the interfaces of the module. So none of the interface ops should
+/// be called after this point.
+impl Drop for Module {
+    fn drop(&mut self) {
+        let _ = self
+            .svc
+            .module_remove(&self.gb_hd, self.id, self.intf_count);
+    }
+}
diff --git a/drivers/greybus/gb_softsvc_exports.c b/drivers/greybus/gb_softsvc_exports.c
new file mode 100644
index 000000000000..a0e360c4d137
--- /dev/null
+++ b/drivers/greybus/gb_softsvc_exports.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+// SPDX-FileCopyrightText: Copyright (c) 2026 BeagleBoard.org. All rights reserved.
+
+/*
+ * Exports Rust symbols from the `gb_softsvc` crate for use by dependent modules.
+ *
+ * This is a workaround until the build system supports Rust cross-module
+ * dependencies natively.
+ */
+
+#include <linux/export.h>
+
+#define EXPORT_SYMBOL_RUST_GPL(sym) extern int sym; EXPORT_SYMBOL_GPL(sym)
+
+#include "exports_gb_softsvc_generated.h"

-- 
2.56.0

