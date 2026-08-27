Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9713A383C
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 07:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817343; cv=none; b=UB5gemQ8j1755XXr0UzmBwTnJ1IiODcCyijo6jZ2YP0Uapne1iMuJjSPWnwidyQDFzpgDBtsPhsFwm0ncgZIz66/l1YI6Pgz+VMjwNZ6UoxFuj36sA29c+F9yIYuExdjHLopnsJqODdXFZOC8TenZEjRK6YJzvelT4wLAJR/GT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817343; c=relaxed/simple;
	bh=5+g1es8ujcbaJ+DeAnz49JBmYw1EJz2CqI7iFe1ijrA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nWQYLKaiYeQB9qnfGgqtK4rj8ah1iUYBxZQH3PWfJfNnanAjBzZsObfmcluK10fvyJ7YHKA2LLKAAVgm/AMQqMALNG3f4+XPkCjNXyDKXP5M7zn4sy3HLtnmHUqos0HtO72VWhWSQmHQJwJK91R4Eo/jECi4Rd1DUnoSApQR24w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=Sr7mE+73; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="Sr7mE+73"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc11a905ba5so1294395a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 00:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1787817341; x=1788422141; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ywd5ymW5Sqwc3yq9XUINVOaEavB26DXvRJFclpGXEBQ=;
        b=Sr7mE+73xZBiIzOfnbBWZaV2ajLlrUsgLKM/o2w2TNGKY2ChtZEAwPDXWGUKF+Bohm
         qlKrlIrFLdapgK+AFNWcOIru3QE2fT0yxqBPO4PICA4A08dPbOwPsSIEDu+xs8Q3SRXr
         W2nUepoarC0G/JmnXVXosRq7zdaOCM1eXybFICqrr4gNH6ID6quv0iGO4gMql7DFiHO1
         7o9S152hhpxj8V+FxHvOCxiQ4l7hmzeIUpXvt0jS2Gyx735X+2bE8Cr2ClCHFAVKCn7H
         +AGut4hXnOwH2q7m0UBpE32Tc0oM8qEN2imSaF+YZCP+hwm+ICFGR0vB2UOg5+i8tEk6
         fvuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787817341; x=1788422141;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ywd5ymW5Sqwc3yq9XUINVOaEavB26DXvRJFclpGXEBQ=;
        b=VJwLpGQ92/TNXGGavlyRYXoFcz8vZicbHzthTrcTepnAsFyDDH+/HAjZq7nFn7ul/X
         oNKdB+cJeZLIcv3sNOeLZkf1B3SUMmzXeeXmA49FeLKbgPIJiobyUZYsom+in6HYy3xO
         jQvALntUzcyFQlcS++8HQAklG9FQcLApMTmkSFr7lANB8LmLmiDwF6L4RKyNvefZh0Nc
         fQrFPB5XZDbGZ2NbUUGLj22IEXWYsPKxdfTHLVG4yUql4U78tm4VnAOzRjBh8tvVRTOE
         rgLt/FihoaRhA9WeMWIlPUFmCtCMoqcbdLLcnGDV6QtpgR9zl6lwVPDcc+kEBkuhsZNA
         yd/g==
X-Forwarded-Encrypted: i=1; AHgh+Rp0iJd3QOhCHnyX7W7P5WyJIfKdL3glJ3V5aUWwDfk54QzalfxeLYhNUFMnmvpWdCzTDn2LmwmuDqCxT1Y=@vger.kernel.org
X-Gm-Message-State: AFuF++kbOYmnUxRtcZZh392YmgvjUtgWdPQtDNAl8qJl98scmOZuowKV
	Fg2Nu/aVPf7Te29cL+Yj1d6ovEBQWWpEbxoZE8uxpQRqhUaSwXP55FTQUpa1xvLXpA==
X-Gm-Gg: AR+sD10twOLDn1kbZGECpInjUKWUG/zGLJ4B7LvmDg4lfgbKaEZFkLWj3jKlS7N0n/m
	TeiEJWpMD3vI4VdRU4PoUp8a4Etdzs38iubErCJy6BJZwep+jzPIeUFDLnGn9Nzd2WeLRHo4xmm
	UGiC7m1KsrOEhiLf0Qfxn5mi773k20hXxDmwdxdaPn/JmUE0KTGqRq8+nBvbdZdeAGPrgvuniNU
	IAkHqS0TKwjOJocPmlkuiXb0luHAeu4ZLy57qH1GUJolYYC+Q9T54IifhaKNGrcRfnPBIchuiil
	q4zVYsK3ky7oqoYWafUgVZrcp0jBBaA8HClT2W0FP6MxiPCX4PJDUid29owf9Mec066dhgXoCE6
	BzamPx0ulq7XTUWIflnCW0ih5HsDF9ZSa7N/lySx9rmf6KdZ5nk7HoomDUWypZg+KdfrBD7HdpX
	Z8emoz79fm4pjI2cdQEE9yhCxDzy4Bz5l9Ic0iPWhVHELX2SPvMoqB5fn93xcdx/ecIjJepXY=
X-Received: by 2002:a17:90b:5291:b0:396:673f:fe56 with SMTP id 98e67ed59e1d1-3966d3d89e6mr28236162a91.9.1787817340607;
        Thu, 27 Aug 2026 00:55:40 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d60c2b4sm24641685eec.5.2026.08.27.00.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 00:55:40 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Thu, 27 Aug 2026 13:24:41 +0530
Subject: [PATCH v2 5/7] drivers: greybus: Add software SVC implementation
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260827-gb-uart-transport-v2-5-a03bb1f5fbd1@beagleboard.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=21766;
 i=ayush@beagleboard.org; h=from:subject:message-id;
 bh=5+g1es8ujcbaJ+DeAnz49JBmYw1EJz2CqI7iFe1ijrA=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqj+1DyYo3hFaElotqb4eS0O2BVsm/x80xPO+Td
 mgrHHHduFGJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCao/tQwAKCRAFzvXHieVa
 dCFCD/49kLdjzLGC44Lu5iz4WEURITkqwfPhzNyxfXNO/7EenX5j57SdvF3wiVNNcwd2oT+iatW
 9HK+h8fjV7i1EQw+XFllUdydduUzKetsdBjyHiAKrWldbX4GOLkB7xu0oeRYIUXRhte45iahO1h
 3s4fMOUNXX6Xq5EKnj7FH8gqSWAnlTGqejzxxrP3SLh8OxALEPzMvZ3PipuHOXBqtQgZF/fTdVj
 PEw0VBKX1kMrh/4qyl2hwrL+2AQu430z+5uoJ+BF9Ty1tGVaPtJyPO3/evdnmt3YMffFwSbEoci
 tQEvStHemmA1Yc3LRBYv0Hehb+wjS6jWydUXgFnfUXbQ3b/pAed3oG2enbOuAkMGYNqFETexcGD
 DQNZhRycf0dbatetvZ0V94h0DRHKdBKFrSD4U1PZlCbMDk3BNqavYSoOQCSq1O1PmKnNefTZj1N
 4KFLrW2ox0MsvKttDlP/W9JcNDZ6/QxmKIS/a8VD+yk/iHYyJKk8fLbJbfsIPACOsw71nBGXu7R
 WtHzuyoEx26Zk7OBj9u54Mf/qgtDotYDc++8on/k1h0qV5FUUB2wAyH7JEXb+b9po6Zh+ysgoeM
 Tkz42pWq9DWD2pk1+Z1m8xP2SdDkHx8hIEUjo+kqXm8/5DMX5SR5E7Md28g3eFxRdJLR60gFvR7
 A3YwxIkue41SZag==
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
 drivers/greybus/Makefile             |   2 +
 drivers/greybus/gb_softsvc.rs        | 504 +++++++++++++++++++++++++++++++++++
 drivers/greybus/gb_softsvc_exports.c |  15 ++
 5 files changed, 539 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 80247a031353..3ba56cdbf056 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11328,6 +11328,12 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/net/ti,cc1352p7.yaml
 F:	drivers/greybus/gb-beagleplay.c
 
+GREYBUS SOFTSVC DRIVERS
+M:	Ayush Singh <ayush@beagleboard.com>
+L:	greybus-dev@lists.linaro.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/greybus/gb_softsvc.rs
+
 GREYBUS SUBSYSTEM
 M:	Johan Hovold <johan@kernel.org>
 M:	Alex Elder <elder@kernel.org>
diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
index 3bf3b8691442..381d1a6ee135 100644
--- a/drivers/greybus/Kconfig
+++ b/drivers/greybus/Kconfig
@@ -48,5 +48,17 @@ config GREYBUS_ES2
 	  To compile this code as a module, choose M here: the module
 	  will be called gb-es2.ko
 
+config GREYBUS_SOFTSVC
+	tristate "Greybus software SVC"
+	depends on RUST
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
index d986e94f8897..e6f594128802 100644
--- a/drivers/greybus/Makefile
+++ b/drivers/greybus/Makefile
@@ -25,4 +25,6 @@ gb-es2-y := es2.o
 
 obj-$(CONFIG_GREYBUS_ES2)	+= gb-es2.o
 
+obj-$(CONFIG_GREYBUS_SOFTSVC)	+= gb-softsvc.o
+gb-softsvc-y			+= gb_softsvc.o gb_softsvc_exports.o
 
diff --git a/drivers/greybus/gb_softsvc.rs b/drivers/greybus/gb_softsvc.rs
new file mode 100644
index 000000000000..79e2752e42ba
--- /dev/null
+++ b/drivers/greybus/gb_softsvc.rs
@@ -0,0 +1,504 @@
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
+    new_mutex, new_spinlock,
+    prelude::*,
+    sync::{
+        aref::ARef,
+        Arc,
+        Mutex,
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
+// SAFETY: `Msg` is a POD type with no padding and no interior mutability.
+unsafe impl<P> kernel::transmute::AsBytes for Msg<P> {}
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
+    intf_map: Mutex<[Option<Arc<dyn InterfaceOps>>; INTF_MAP_LEN]>,
+}
+
+impl Svc {
+    fn new() -> impl PinInit<Self, Error> {
+        pin_init!(Self {
+            intf_map <- new_mutex!(init_array_from_fn(|_| None)),
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
+        fn inner(
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
+        let pos = inner(&guard, intfs.len())?;
+        for (i, intf) in intfs.iter().cloned().enumerate() {
+            guard[usize::from(pos) + i] = Some(intf);
+        }
+
+        Ok(pos + INTF_ID_START)
+    }
+
+    fn map_remove(&self, primary_id: u8, intf_count: u8) {
+        let id = primary_id - INTF_ID_START;
+        let mut guard = self.intf_map.lock();
+
+        for i in 0..intf_count {
+            let _ = guard[usize::from(id + i)].take();
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
+    fn send_request<P>(&self, hd: &hd::Device, ty: u8, payload: P) -> Result<()> {
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
+            self.map_remove(intf_id, intf_count);
+        }
+
+        res.map(|()| intf_id)
+    }
+
+    fn module_remove(&self, hd: &hd::Device, intf_id: u8, intf_count: u8) -> Result<()> {
+        self.map_remove(intf_id, intf_count);
+        let payload = protocols::GbSvcModuleRemovedRequest::new(intf_id);
+        self.send_request(hd, protocols::GB_SVC_TYPE_MODULE_REMOVED, payload)?;
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
+    fn send_response<P>(&self, hd: &hd::Device, msg: &protocols::GbOperationMsgHdr, payload: P) {
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
+    fn handler(&self, msg: &greybus::Message) -> Result<()> {
+        let hdr = msg.header();
+        let hd = msg.operation().connection().host_device();
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
+        dest_cport_id: u16,
+        msg: &greybus::Message,
+        gfp_mask: Flags,
+    ) -> Result {
+        if dest_cport_id == protocols::GB_SVC_CPORT_ID {
+            data.0.handler(msg)
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
+        let intf = self
+            .gb_hd
+            .find_connection_by_intf(self.id + intf_id_rel, cport)
+            .ok_or(code::EINVAL)?;
+        self.gb_hd.data_rcvd(intf.hd_cport_id(), msg);
+
+        Ok(())
+    }
+}
+
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
2.55.0

