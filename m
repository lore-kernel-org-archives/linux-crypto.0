Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E55E330676
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 07:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817334; cv=none; b=gc4eE0tIvNqcZ0ARjBRD0x2TqYCP8BmFKTzCjc6pR3h4HTA/PNWlHlVarfxai9GqdZ98Ti430AVIBclJCfZwJPO+WYIxGmJjDHEzK06KWMqdTkAGIs+QKhmUuok01yfP2jM61MOON+c0mCL5Jo9ofNqCaaaSI7QHJgP6Hgmn8VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817334; c=relaxed/simple;
	bh=OWYSTHt6TJbWJ48lLoRkYMfUlB6/ZHksNW68FuNNnEI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ouPsLu9NPkkDdf7ucNVP3eYv7POpMl29sooWWPcsPfLKQFP8cdr/6A0kshLb6jkMcquEQmP2dUFRkYz8GucLRAC6WPh2O0wHL7nmRGLkx0m/i1v+eV2UtIdxKvJ57JoXk1ICKoarYE1cp2HTu+mSSnva1QM73ttMtOLk5rf0DEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org; spf=fail smtp.mailfrom=beagleboard.org; dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b=prtR/gcd; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=beagleboard.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=beagleboard.org header.i=@beagleboard.org header.b="prtR/gcd"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84eb992a881so1620145b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 00:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=beagleboard.org; s=google; t=1787817331; x=1788422131; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8t9G20fcrBNzhH4FpOffTnYklz5l8YqDis2NUbHSyHA=;
        b=prtR/gcdZjYV1ayXxFDcYwpJsrKfJAeqsMTrGeLGaAkLABFGrfWmbJlpXS1+LnUAet
         7usa3KlZ/h7K8yfz588iLyNKRoTfrmW2c421P27NWSRvKEn1FlhvU7fps/sMEVIx9lrh
         TtbEvEaYSiI2/+FhljoNa0qLWj08UxdlJvdnRuIqHoR3M3WdTIDGjhYX6P2IfNWNiwEo
         fXDg9AFGvhlL3j+FRXANjAq7AX6Ti8ZHP/fRqAl3DQlNjJi/MRk59KGM2y3TBbPFmnGu
         5sDSjcn52ARMh8ibo9ITr3cKMGOZgl+6XZN33GjC0SRGs0MsMc0aDKjnH5ptSQ2kC2r0
         43Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787817331; x=1788422131;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8t9G20fcrBNzhH4FpOffTnYklz5l8YqDis2NUbHSyHA=;
        b=ngqfd1uNZ0JBuOsGOovbuxiCPi4JYFXXzwTc2e8/tiCryVg1jjsq8TFCciM0u/40eV
         ynG8sWCwCPkxpnrLfWfl0hEarnEiA6/4590QF8AQvRft+s9Ua1RzblCYRPckM6ce7Jqz
         Zt1NHzlckbQOhpdzlQyRUyU7J6Tptdcj0URpUd0CBKxxNzMNZqQ4yCbuKxPjLpm1uKnb
         xd7Wk+q0GPyWVhbazU03kyZZNCTR16tejR0GA3sdEenq3RvEP9exybw2E/1alqjsGH9T
         ipARfJWJvo8u5791M3e15R51RnIQLAi9IZNDIPbz9nvVevtwqSN9soxsIvyRIH9am+7k
         FhJw==
X-Forwarded-Encrypted: i=1; AHgh+RqTQv9Aua3CkywhfVAjxl1RxyO6jqUnqqH4QzTYWMHtYvUqp+0g5iq/e8OHp62I3+eGFZxaMEH+EDMrzes=@vger.kernel.org
X-Gm-Message-State: AFuF++lTxlEIaniHS/D1Jg4BlrSPhXMkizs9N6Tx5AWydoSqp3q7SB5W
	/FSGZpjwvpJjKzOlw4WYB2V/ctnkh5LmTgNLpJc2y3qzfuJkHisxXu2ImnddvEjvxg==
X-Gm-Gg: AR+sD12SbrIIp2f4bpDt1Jyay/e7eTrcxcCuU1ZAVRNlrbSZvx+JL9RUjqEArgW5BW4
	cHwUnUilkrvW25QngyEmDDcVP8Bwk4Bh8eCEH9kdvuMDuVex4V5x3Jot+RyEyLDFc0K3tQ07mFW
	5JUfvNh/u60R1pwOLc0seQARqUsFYgpgxuohHNYcUek4ERiDbXWYC5GymctESjigerZWNUdMOT4
	6Fbq2WaGAJRyS1C9nKrw3us9dWiffTy2OXzebDpIw8SoO129ZhTb1WdO+yZ5Hxv+zS77IeizB6u
	T50rT3WHnjHz8kVKwwYSvtL9LsPPU8Q8yYAXETwk59YwqbfsqTDDkbnoVnZMTzEDIUYcCXQIv2L
	ZeBCwa6UsaNdxXgeS06MByhiovJI1bH9j0FxYu3CnHI53TRva/EYFSHMEcOJNdNf31MAdAvsMu/
	T8Sl3/NdHoTSRA93OAqeQc9ved2woiXvIU7Jp8JLifr9a+UGFsoWAw1H6kgbX3lpPrtA+muTQCn
	YTG0wR+1SA=
X-Received: by 2002:a05:6a21:6190:b0:3c3:a31b:3949 with SMTP id adf61e73a8af0-3cf83c17574mr27718415637.11.1787817331072;
        Thu, 27 Aug 2026 00:55:31 -0700 (PDT)
Received: from [192.168.29.54] ([2405:201:4019:32fc:3c55:6b24:5147:322b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d60c2b4sm24641685eec.5.2026.08.27.00.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 00:55:30 -0700 (PDT)
From: Ayush Singh <ayush@beagleboard.org>
Date: Thu, 27 Aug 2026 13:24:40 +0530
Subject: [PATCH v2 4/7] rust: kernel: Add greybus abstractions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260827-gb-uart-transport-v2-4-a03bb1f5fbd1@beagleboard.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=39708;
 i=ayush@beagleboard.org; h=from:subject:message-id;
 bh=OWYSTHt6TJbWJ48lLoRkYMfUlB6/ZHksNW68FuNNnEI=;
 b=owEBbQKS/ZANAwAKAQXO9ceJ5Vp0AcsmYgBqj+1DEpDjLIfyoTS7GYUs9Im22Mfiu+raJPqwM
 iG8/aWl8aSJAjMEAAEKAB0WIQTfzBMe8k8tZW+lBNYFzvXHieVadAUCao/tQwAKCRAFzvXHieVa
 dM72D/0RxiZkc9R+ttiDDZZ+l02H1nS6INEk+vmLoRQ6HYh3407e7eRjbetbeqVdz4nytqb64cR
 8CtHTt3pgyBYXvppI2+yvT6GQFmQg+v0yPtT6yN42hp8bTZGjtxFZlahxFYiUD9YxdYeEr+WUmX
 0frI02/j38bC1I/YBIAGdRPwkseLbqT7inQN3DZnNVNs9PT9CDKe858iwGCWDU6ceU+UQ1cuzn6
 7QyT4duqYbLwuLFG+k4FLFBh2QusEpPjxgekHICkvS47tpUQ6+n/4ICyTdTsJ9sVYBA/AOrmtxl
 X/ffZGE+k6KwZqkgWkcIbqq87eNHLrgVw1360akif1A807TtmVaafl6s6SnG226InJjIFmA7mvH
 hkLUPmf7pMh0piBnKV0ONx9gYWtWw4vcWUBCxrfbDpvF69hO4Txyngy/Zd1dqidJi/rjLaaNYrU
 A/jci/aaBCd4McpwIUZbELrTE1x1zlbo6p+YRrUf1m+e4QY1r6N9ougyb+tFzJJ7lf2QUs2OOWT
 u/aDCPsoKxoOy+l0SwdEaozSQmDGme1bIE4o+RYp2TQdCe7KyfdrRBQkXT/1WgEE959mubtE67l
 xIbhsgIED8SOLKt/eknhVXwdjbc5maYrB0eUwflES/hi4+cg7PwxGUlIN4XBex7D2VB349VcE7H
 IQ65b0mghHt/1tg==
X-Developer-Key: i=ayush@beagleboard.org; a=openpgp;
 fpr=DFCC131EF24F2D656FA504D605CEF5C789E55A74

Add Rust abstractions for the Greybus core, enough to implement a
Greybus host driver in Rust.

The abstractions are split into 3 modules:

- Top level mod.rs: Basic abstractions greybus structures.
- hd.rs: Greybus Host Device specific abstractions.
- protocols.rs: Abstractions for greybus_protocols.h, i.e. greybus
  protocol types and constants.

Only the APIs used by gb-softsvc and gb-uart-node driver are covered.
As such, protocols.rs also only contains abstractions for greybus
structures that are used by SVC and some types such as Greybus Interface
do not implement AlwaysRefCounted at the moment.

HdDriver Note
**************

In C message_send callback, it is possible for the caller to defer
calling gb_message_sent. This is used in es2 driver. However, looking at
the internals, it does not seem like the message owenership is actually
transferred to the caller in real terms. Instead, it is more like the
caller is shared ownership. This is evident ny the fact that
message_cancel can be called at any point, and depending on wheather the
message is request or response, the message can become invalid after the
message_cancel callback. Thus the driver is expected to ensure that no
dangling references to that message exist.

Since gb_message is not an internally ref counted structure in true
terms (it does seem to use the ref counting in the internal operation),
and since double calls to gb_message_sent are not really allowed, I have
made the decision to call gb_message_sent on a message in the
abstractions rather than making the driver call it. This means the
driver only gets a reference to the message, and never owns it. This
does prevent a driver to use it in the way es2 currently does, but seems
much less of a footgun.

Another possibility would be to implement AlwaysRefCounted on Message
and pass the calls to gb_operation_get/put, but I have not gone through
the internals enough to figure out if this is correct in all cases.

Signed-off-by: Ayush Singh <ayush@beagleboard.org>
---
 MAINTAINERS                      |   1 +
 drivers/greybus/Kconfig          |   7 +
 rust/bindings/bindings_helper.h  |   1 +
 rust/kernel/alloc.rs             |   5 +
 rust/kernel/greybus/hd.rs        | 333 +++++++++++++++++++++++++++++++++
 rust/kernel/greybus/mod.rs       | 232 +++++++++++++++++++++++
 rust/kernel/greybus/protocols.rs | 392 +++++++++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs               |   2 +
 8 files changed, 973 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1e3b42eff741..80247a031353 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11338,6 +11338,7 @@ F:	drivers/greybus/
 F:	drivers/staging/greybus/
 F:	include/linux/greybus.h
 F:	include/linux/greybus/
+F:	rust/kernel/greybus/
 
 GREYBUS UART PROTOCOLS DRIVERS
 M:	David Lin <dtwlin@gmail.com>
diff --git a/drivers/greybus/Kconfig b/drivers/greybus/Kconfig
index c3f056d28b01..3bf3b8691442 100644
--- a/drivers/greybus/Kconfig
+++ b/drivers/greybus/Kconfig
@@ -15,6 +15,13 @@ menuconfig GREYBUS
 	  To compile this code as a module, choose M here: the module
 	  will be called greybus.ko
 
+config RUST_GREYBUS_ABSTRACTIONS
+	bool "Rust greybus abstractions"
+	depends on RUST
+	select GREYBUS
+	help
+	  This enables the Rust abstraction for the Greybus API.
+
 if GREYBUS
 
 config GREYBUS_BEAGLEPLAY
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 6eb3caaee497..ded5300e75da 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -62,6 +62,7 @@
 #include <linux/file.h>
 #include <linux/firmware.h>
 #include <linux/fs.h>
+#include <linux/greybus.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
 #include <linux/io-pgtable.h>
diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 21067bde6860..d0ba4d91b3d3 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -38,6 +38,11 @@
 pub struct Flags(u32);
 
 impl Flags {
+    /// Create from gfp_t
+    pub(crate) fn new(v: bindings::gfp_t) -> Self {
+        Self(v)
+    }
+
     /// Get the raw representation of this flag.
     pub(crate) fn as_raw(self) -> u32 {
         self.0
diff --git a/rust/kernel/greybus/hd.rs b/rust/kernel/greybus/hd.rs
new file mode 100644
index 000000000000..ee2a4930ff2e
--- /dev/null
+++ b/rust/kernel/greybus/hd.rs
@@ -0,0 +1,333 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Greybus host device abstractions.
+//!
+//! A driver implements the transmit path through [`HdDriver`] and feeds received data back into
+//! the core with [`Device::data_rcvd`].
+//!
+//! A host device is created, populated with driver private data and added to the Greybus bus by
+//! constructing a [`Registration`], which owns the underlying `struct gb_host_device`. Dropping
+//! the registration drops the private data and removes the device from the bus, so it is normally
+//! stored in the driver data of the parent device and torn down implicitly when that device goes
+//! away.
+//!
+//! Individual references to a live host device are represented by [`ARef<Device>`], which keeps
+//! the embedded `struct device` reference count balanced.
+//!
+//! C header: [`include/linux/greybus/hd.h`](srctree/include/linux/greybus/hd.h)
+//!
+//! # Examples
+//!
+//! ```ignore
+//! use kernel::{device, prelude::*};
+//!
+//! struct MyHd {
+//!     // transport state
+//! }
+//!
+//! #[vtable]
+//! impl HdDriver for MyHd {
+//!     fn message_send(data: &Self, dest_cport_id: u16, msg: Message) -> Result {
+//!         // Copy what is needed out of `msg`, queue it, and return without sleeping.
+//!         // Call `HostDevice::message_sent()` once the core may release the message.
+//!         Ok(())
+//!     }
+//!
+//!     fn message_cancel(_msg: Message) {}
+//! }
+//!
+//! fn probe(parent: &device::Device) -> Result<Registration<MyHd>> {
+//!     Registration::new(parent, BUFFER_SIZE_MAX, NUM_CPORTS, try_pin_init!(MyHd {}))
+//! }
+//! ```
+
+use core::{
+    marker::PhantomData,
+    ptr::{
+        addr_of_mut,
+        NonNull, //
+    },
+};
+
+use crate::{
+    alloc::Flags,
+    device,
+    error::{
+        code,
+        from_err_ptr,
+        to_result, //
+    },
+    greybus::{
+        Connection,
+        Message, //
+    },
+    prelude::*,
+    sync::aref::{
+        ARef,
+        AlwaysRefCounted, //
+    },
+    types::Opaque,
+};
+
+/// The set of callbacks a Greybus host driver can provide.
+#[vtable]
+pub trait HdDriver: Send + Sync + Sized + 'static {
+    /// Transmits `msg` to `dest_cport_id`.
+    ///
+    /// This may be called in atomic context and therefore must not sleep; queue the message and
+    /// return. Once the core is allowed to release the message, call
+    /// [`HostDevice::message_sent`].
+    ///
+    /// The message is only borrowed for the duration of this call: copy what is needed out of it,
+    /// do not stash the reference.
+    fn message_send(data: &Self, dest_cport_id: u16, msg: &Message, gfp_mask: Flags) -> Result;
+
+    /// Aborts the transmission of a message previously handed to [`HdDriver::message_send`].
+    ///
+    /// Always called in process context.
+    fn message_cancel(msg: &Message);
+}
+
+/// Builds the C callback table for a [`HdDriver`] implementation.
+struct HdDriverVTable<T: HdDriver>(PhantomData<T>);
+
+impl<T: HdDriver> HdDriverVTable<T> {
+    const DRIVER: bindings::gb_hd_driver = bindings::gb_hd_driver {
+        // Both are mandatory, hence no `HAS_*` check. See [`HdDriver`].
+        message_send: Some(Self::message_send),
+        message_cancel: Some(Self::message_cancel),
+        // Every other callback is left `NULL`, which the Greybus core takes as "use the default
+        // behaviour".
+        ..pin_init::zeroed()
+    };
+
+    const fn build() -> &'static bindings::gb_hd_driver {
+        &Self::DRIVER
+    }
+
+    /// # Safety
+    ///
+    /// `hd` must point at a registered host device whose private area holds a pointer to a live
+    /// `T`, and `msg` must point at a valid message.
+    unsafe extern "C" fn message_send(
+        hd: *mut bindings::gb_host_device,
+        dest_cport_id: u16,
+        msg: *mut bindings::gb_message,
+        gfp_mask: bindings::gfp_t,
+    ) -> c_int {
+        // SAFETY: `gb_host_device` and `HostDevice` have the same layout.
+        let hd = unsafe { Device::<device::CoreInternal<'_>>::from_raw(hd) };
+        // SAFETY: `message_send` is only ever called after a successful call to
+        // `gb_hd_add`, hence it's guaranteed that `Device::set_drvdata()` has been called
+        // and stored a `Pin<KBox<T>>`.
+        let data = unsafe { hd.as_ref().drvdata_borrow() };
+        // SAFETY: The caller guarantees `msg` is valid for the duration of this call.
+        let msg = unsafe { Message::from_raw(msg) };
+
+        match T::message_send(&data, dest_cport_id, msg, Flags::new(gfp_mask)) {
+            Ok(()) => {
+                // SAFETY: `msg` is still valid since `sent` is not called anywhere else.
+                unsafe { msg.sent(0) };
+                0
+            }
+            Err(e) => e.to_errno(),
+        }
+    }
+
+    /// # Safety
+    ///
+    /// `msg` must point at a valid message of a registered host device of this driver.
+    unsafe extern "C" fn message_cancel(msg: *mut bindings::gb_message) {
+        // SAFETY: The caller guarantees `msg` is valid for the duration of this call.
+        let msg = unsafe { Message::from_raw(msg) };
+        T::message_cancel(msg);
+    }
+}
+
+/// A Greybus host device.
+///
+/// # Invariants
+///
+/// The wrapped value is a valid `struct gb_host_device` created by `gb_hd_create()`, and every
+/// [`ARef<HostDevice>`] owns an increment on its reference count.
+#[repr(transparent)]
+pub struct Device<Ctx = device::Normal> {
+    ptr: Opaque<bindings::gb_host_device>,
+    _ctx: PhantomData<Ctx>,
+}
+
+// SAFETY: `gb_host_device` is reference counted through its embedded `struct device`, which may be
+// used from any thread.
+unsafe impl<Ctx> Send for Device<Ctx> {}
+
+// SAFETY: `gb_host_device` has its own internal locking, so it is safe to share references to it
+// across threads.
+unsafe impl<Ctx> Sync for Device<Ctx> {}
+
+// SAFETY: The embedded `struct device` carries the reference count, and `gb_hd_put()` is just
+// `put_device()` on it, so the object stays alive for as long as increments are outstanding.
+unsafe impl<Ctx> AlwaysRefCounted for Device<Ctx> {
+    #[inline]
+    fn inc_ref(&self) {
+        // SAFETY: By the type invariant there is a live reference to the host device, and `dev` is
+        // its embedded `struct device`.
+        unsafe { bindings::get_device(&raw mut (*self.ptr.get()).dev) };
+    }
+
+    #[inline]
+    unsafe fn dec_ref(obj: NonNull<Self>) {
+        // SAFETY: The caller guarantees it owns an increment on the reference count.
+        unsafe { bindings::gb_hd_put(obj.as_ptr().cast()) }
+    }
+}
+
+impl<Ctx> Device<Ctx> {
+    /// # Safety
+    ///
+    /// `ptr` must be a valid pointer to a `struct gb_host_device`.
+    #[inline]
+    pub(crate) const unsafe fn from_raw<'a>(ptr: *mut bindings::gb_host_device) -> &'a Self {
+        // SAFETY: `Device` is a transparent wrapper of `Opaque<bindings::gb_host_device>`.
+        unsafe { &*ptr.cast() }
+    }
+
+    #[inline]
+    pub(crate) fn as_raw(&self) -> *mut bindings::gb_host_device {
+        self.ptr.get()
+    }
+
+    /// Hands a message received on `hd_cport_id` to the Greybus core.
+    #[inline]
+    pub fn data_rcvd(&self, cport_id: u16, msg: &[u8]) {
+        // SAFETY: By the type invariant of `Self`, `self.as_raw()` is a pointer to a valid
+        // `struct gb_host_device`. `msg` is valid for reads of ``msg.len()` bytes for the duration
+        // of the call, and the core only reads through the pointer — it copies the payload into
+        // the operation before returning — so handing it a `*mut` derived from a shared reference
+        // is sound.
+        //
+        // TODO: The C signature of this function should be changed to take const pointer for msg.
+        unsafe {
+            bindings::greybus_data_rcvd(self.as_raw(), cport_id, msg.as_ptr().cast_mut(), msg.len())
+        }
+    }
+
+    /// Looks up the connection bound to `cport` on interface `id`.
+    pub fn find_connection_by_intf(&self, id: u8, cport: u16) -> Option<ARef<Connection>> {
+        // SAFETY: By the type invariant of `Self`, `self.as_raw()` is a pointer to a valid
+        // `struct gb_host_device`.
+        let ptr = NonNull::new(unsafe {
+            bindings::gb_connection_hd_find_by_intf(self.as_raw(), id, cport)
+        })?;
+
+        // SAFETY: ptr is a valid gb_connection
+        Some(unsafe { ARef::from_raw(ptr.cast()) })
+    }
+}
+
+impl<Ctx: device::DeviceContext> AsRef<device::Device<Ctx>> for Device<Ctx> {
+    #[inline]
+    fn as_ref(&self) -> &device::Device<Ctx> {
+        // SAFETY: By the type invariant of `Self`, `self.as_raw()` is a pointer to a valid
+        // `struct gb_host_device`. `dev` points to a valid `struct device`.
+        unsafe { device::Device::from_raw(addr_of_mut!((*self.as_raw()).dev)) }
+    }
+}
+
+/// A host device owned by its driver, together with the driver's private data `T`.
+///
+/// Created and added to the Greybus bus on construction, removed on drop.
+///
+/// # Invariants
+///
+/// `ptr` points at a valid `struct gb_host_device` obtained from `gb_hd_create()`, whose driver
+/// data holds a live `T`
+#[repr(transparent)]
+pub struct Registration<T> {
+    ptr: NonNull<bindings::gb_host_device>,
+    _data: PhantomData<T>,
+}
+
+impl<T: HdDriver> Registration<T> {
+    /// Creates a host device under `parent` and adds it to the Greybus bus.
+    ///
+    /// `buffer_size_max` is the largest message the transport can carry in one go, header
+    /// included. `num_cports` is the number of cports that the greybus host device can connect to.
+    ///
+    /// `data` is initialised in place before the device is added, so callbacks may run against it
+    /// from the moment `gb_hd_add()` succeeds.
+    pub fn new(
+        parent: &device::Device,
+        buffer_size_max: usize,
+        num_cports: usize,
+        data: impl PinInit<T, Error>,
+    ) -> Result<Self> {
+        // SAFETY: `parent` is a valid device, and the driver table is `'static`. The core only
+        // ever reads through the driver pointer, so casting away `const` is fine.
+        let hd = from_err_ptr(unsafe {
+            bindings::gb_hd_create(
+                core::ptr::from_ref(HdDriverVTable::<T>::build()).cast_mut(),
+                parent.as_raw(),
+                buffer_size_max,
+                num_cports,
+            )
+        })?;
+
+        // SAFETY: `hd` is a valid pointer to `gb_host_device`.
+        let hd_dev: &Device<device::CoreInternal<'_>> = unsafe { Device::from_raw(hd) };
+        hd_dev.as_ref().set_drvdata(data)?;
+
+        // SAFETY: By the type invariant the host device is valid, and it has not been added yet.
+        to_result(unsafe { bindings::gb_hd_add(hd) })?;
+
+        // INVARIANT: `gb_hd_create()` returns a valid `gb_host_device` on success,
+        // and we own the reference it returns until `Drop`.
+        Ok(Self {
+            ptr: NonNull::new(hd).ok_or(code::ENOMEM)?,
+            _data: PhantomData,
+        })
+    }
+}
+
+impl<T> Registration<T> {
+    fn as_raw(&self) -> *mut bindings::gb_host_device {
+        self.ptr.as_ptr()
+    }
+}
+
+impl<T> AsRef<Device> for Registration<T> {
+    #[inline]
+    fn as_ref(&self) -> &Device {
+        // SAFETY: By the type invariant the host device is valid.
+        unsafe { Device::from_raw(self.as_raw()) }
+    }
+}
+
+impl<T> Drop for Registration<T> {
+    fn drop<'a>(&'a mut self) {
+        // SAFETY: By the type invariant of `Self`, `self.as_raw()` is a pointer to a valid
+        // `struct gb_host_device`.
+        unsafe { bindings::gb_hd_del(self.as_raw()) }
+
+        {
+            // SAFETY: `hd` is a valid pointer to `gb_host_device`.
+            let hd_dev = unsafe { Device::<device::CoreInternal<'_>>::from_raw(self.as_raw()) };
+            // SAFETY: The driver data was set to a `T` in `Registration::new()` and has not been
+            // taken since, and this is the only place that takes it.
+            drop(unsafe { hd_dev.as_ref().drvdata_obtain::<T>() });
+        }
+
+        // SAFETY: By the type invariant of `Self`, `self.as_raw()` is a pointer to a valid
+        // `struct gb_host_device`.
+        unsafe { bindings::gb_hd_put(self.as_raw()) };
+    }
+}
+
+// SAFETY: The greybus host device API is thread-safe as guaranteed by the device core, as long as
+// gb_hd_del() is guaranteed to only be called once - which is guaranteed by our type not
+// having Copy/Clone.
+unsafe impl<T: Send> Send for Registration<T> {}
+
+// SAFETY: The greybus device API is thread-safe as guaranteed by the device core, as long as
+// gb_hd_del() is guaranteed to only be called once - which is guaranteed by our type not
+// having Copy/Clone.
+unsafe impl<T: Sync> Sync for Registration<T> {}
diff --git a/rust/kernel/greybus/mod.rs b/rust/kernel/greybus/mod.rs
new file mode 100644
index 000000000000..791aac38ec29
--- /dev/null
+++ b/rust/kernel/greybus/mod.rs
@@ -0,0 +1,232 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Abstractions for the Greybus core.
+//!
+//! C header: [`include/linux/greybus.h`](srctree/include/linux/greybus.h)
+//!
+//! Greybus host drivers ("host devices") bridge the Greybus core to whatever transport actually
+//! carries the traffic. A host driver creates a [`HostDevice`], registers it, and implements
+//! [`HdDriver`] to transmit the messages the core hands it.
+
+use core::ptr::NonNull;
+
+use crate::{
+    sync::aref::AlwaysRefCounted,
+    transmute::FromBytes,
+    types::Opaque, //
+};
+
+pub mod hd;
+pub mod protocols;
+
+/// The largest Greybus message, header included.
+///
+/// Bounded by the 16-bit `size` field in the operation header.
+pub const GB_OPERATION_SIZE_MAX: usize = u16::MAX as usize;
+
+/// The largest valid CPort id.
+///
+/// Ids above this are reserved by the protocol; a host device's `num_cports` cannot exceed
+/// `CPORT_ID_MAX + 1`.
+pub const CPORT_ID_MAX: usize = bindings::CPORT_ID_MAX as usize;
+
+/// A Greybus message handed to a host driver for transmission.
+///
+/// # Invariants
+///
+/// The shared reference is only ever handed out for the duration of a [`HdDriver`] callback, during
+/// which the Greybus core guarantees the message and its buffer stay alive.
+#[repr(transparent)]
+pub struct Message(Opaque<bindings::gb_message>);
+
+impl Message {
+    /// # Safety
+    ///
+    /// `ptr` must be non-null and point at a valid `struct gb_message` which outlives the
+    /// returned `Self`.
+    #[inline]
+    pub(crate) const unsafe fn from_raw<'a>(ptr: *mut bindings::gb_message) -> &'a Self {
+        // SAFETY: `Message` is a transparent wrapper of `Opaque<bindings::gb_message>`.
+        unsafe { &*ptr.cast() }
+    }
+
+    /// Returns the operation header at the start of the message.
+    #[inline]
+    pub const fn header(&self) -> &protocols::GbOperationMsgHdr {
+        // SAFETY: `header` points at a valid `gb_operation_msg_hdr` for as long as the message is
+        // alive, and `GbOperationMsgHdr` is a transparent wrapper of it.
+        unsafe { &*(*self.0.get()).header.cast() }
+    }
+
+    /// # Safety
+    ///
+    /// `Message` is not valid after this call.
+    #[inline]
+    pub(crate) unsafe fn sent(&self, status: i32) {
+        // SAFETY: By the type invariant the message is valid and still owned by the transport,
+        // and its connection and host device are alive for as long as it is.
+        unsafe {
+            bindings::greybus_message_sent(
+                self.operation().connection().host_device().as_raw(),
+                self.0.get(),
+                status,
+            );
+        }
+    }
+
+    /// Returns the payload, i.e. the message without its operation header.
+    pub const fn payload_bytes(&self) -> &[u8] {
+        // SAFETY: By the type invariant the message is valid.
+        let payload = unsafe { (*self.0.get()).payload };
+        // SAFETY: By the type invariant the message is valid.
+        let payload_size = unsafe { (*self.0.get()).payload_size };
+
+        if payload.is_null() || payload_size == 0 {
+            return &[];
+        }
+
+        // SAFETY: A non-null `payload` points at `payload_size` initialized bytes.
+        unsafe { core::slice::from_raw_parts(payload.cast::<u8>(), payload_size) }
+    }
+
+    /// Interprets the message payload as a `T`.
+    ///
+    /// Returns `None` if the payload is too short or misaligned for `T`.
+    #[inline]
+    pub fn payload<T: FromBytes>(&self) -> Option<&T> {
+        T::from_bytes(self.payload_bytes())
+    }
+
+    /// Returns the operation this message belongs to.
+    #[inline]
+    pub const fn operation(&self) -> &Operation {
+        // SAFETY: By the type invariant the message is valid, and its `operation` is set for as
+        // long as the message is alive.
+        unsafe { Operation::from_raw((*self.0.get()).operation) }
+    }
+}
+
+/// A Greybus operation.
+///
+/// # Invariants
+///
+/// The wrapped value is a valid `struct gb_operation`.
+#[repr(transparent)]
+pub struct Operation(Opaque<bindings::gb_operation>);
+
+impl Operation {
+    /// # Safety
+    ///
+    /// `ptr` must be a valid pointer to a `struct gb_operation`.
+    #[inline]
+    pub(crate) const unsafe fn from_raw<'a>(ptr: *mut bindings::gb_operation) -> &'a Self {
+        // SAFETY: `Operation` is a transparent wrapper of `Opaque<bindings::gb_operation>`.
+        unsafe { &*ptr.cast() }
+    }
+
+    /// Returns the connection this operation travels on.
+    #[inline]
+    pub const fn connection(&self) -> &Connection {
+        // SAFETY: By the type invariant the operation is valid, and its `connection` is alive for
+        // as long as the operation is.
+        unsafe { Connection::from_raw((*self.0.get()).connection) }
+    }
+}
+
+/// A Greybus connection.
+///
+/// # Invariants
+///
+/// The wrapped value is a valid `struct gb_connection`.
+#[repr(transparent)]
+pub struct Connection(Opaque<bindings::gb_connection>);
+
+// SAFETY: `gb_connection_put()` drops the reference acquired by `gb_connection_get()`, so the
+// connection stays alive for as long as increments are outstanding.
+unsafe impl AlwaysRefCounted for Connection {
+    #[inline]
+    fn inc_ref(&self) {
+        // SAFETY: By the type invariant there is a live reference to the connection.
+        unsafe { bindings::gb_connection_get(self.0.get()) }
+    }
+
+    #[inline]
+    unsafe fn dec_ref(obj: NonNull<Self>) {
+        // SAFETY: The caller guarantees it owns an increment on the reference count.
+        unsafe { bindings::gb_connection_put(obj.as_ptr().cast()) }
+    }
+}
+
+impl Connection {
+    /// # Safety
+    ///
+    /// `ptr` must be a valid pointer to a `struct gb_connection`.
+    #[inline]
+    pub(crate) const unsafe fn from_raw<'a>(ptr: *mut bindings::gb_connection) -> &'a Self {
+        // SAFETY: `Connection` is a transparent wrapper of `Opaque<bindings::gb_connection>`.
+        unsafe { &*ptr.cast() }
+    }
+
+    /// Returns the interface at the far end of the connection.  In cases like SVC connection,
+    /// interface can be NULL.
+    #[inline]
+    pub const fn interface(&self) -> Option<&Interface> {
+        // SAFETY: By the type invariant the connection is valid.
+        let intf_ptr = unsafe { (*self.0.get()).intf };
+
+        if intf_ptr.is_null() {
+            None
+        } else {
+            // SAFETY: By the previous check,  intf_ptr is valid.
+            Some(unsafe { Interface::from_raw(intf_ptr) })
+        }
+    }
+
+    /// Returns the CPort id this connection uses on the interface.
+    #[inline]
+    pub const fn intf_cport_id(&self) -> u16 {
+        // SAFETY: By the type invariant the connection is valid.
+        unsafe { (*self.0.get()).intf_cport_id }
+    }
+
+    /// Returns the CPort id this connection uses on the host device.
+    #[inline]
+    pub const fn hd_cport_id(&self) -> u16 {
+        // SAFETY: By the type invariant the connection is valid.
+        unsafe { (*self.0.get()).hd_cport_id }
+    }
+
+    /// Returns the host device this connection belongs to.
+    #[inline]
+    pub const fn host_device(&self) -> &hd::Device {
+        // SAFETY: By the type invariant the connection is valid, and its `hd` is alive for as
+        // long as the connection is.
+        unsafe { hd::Device::from_raw((*self.0.get()).hd) }
+    }
+}
+
+/// A Greybus interface.
+///
+/// # Invariants
+///
+/// The wrapped value is a valid `struct gb_interface`.
+#[repr(transparent)]
+pub struct Interface(Opaque<bindings::gb_interface>);
+
+impl Interface {
+    /// # Safety
+    ///
+    /// `ptr` must be a valid pointer to a `struct gb_interface`.
+    #[inline]
+    pub(crate) const unsafe fn from_raw<'a>(ptr: *mut bindings::gb_interface) -> &'a Self {
+        // SAFETY: `Interface` is a transparent wrapper of `Opaque<bindings::gb_interface>`.
+        unsafe { &*ptr.cast() }
+    }
+
+    /// Returns the interface id, unique within its host device.
+    #[inline]
+    pub const fn id(&self) -> u8 {
+        // SAFETY: By the type invariant the interface is valid.
+        unsafe { (*self.0.get()).interface_id }
+    }
+}
diff --git a/rust/kernel/greybus/protocols.rs b/rust/kernel/greybus/protocols.rs
new file mode 100644
index 000000000000..4658ace5e323
--- /dev/null
+++ b/rust/kernel/greybus/protocols.rs
@@ -0,0 +1,392 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Greybus wire format definitions.
+//!
+//! Thin `repr(transparent)` wrappers over the generated bindings for the operation header and the
+//! SVC protocol messages, plus the constants that go in their type and result fields. The
+//! wrappers exist to keep the byte-order conversions in one place: constructors take native-endian
+//! values and store little-endian, accessors convert back.
+
+/// Set in the header type field to mark a message as a response to the operation of the same id.
+pub const MESSAGE_TYPE_RESPONSE: u8 = 0x80;
+
+/// The CPort id reserved for the SVC connection on every host device.
+pub const GB_SVC_CPORT_ID: u16 = bindings::GB_SVC_CPORT_ID as u16;
+
+/// Defines `u8` constants from same-named `bindings` values.
+macro_rules! gb_u8_consts {
+    ($($name:ident),* $(,)?) => {
+        $(
+            #[allow(missing_docs)]
+            pub const $name: u8 = bindings::$name as u8;
+        )*
+    };
+}
+
+// SVC Operation Types
+gb_u8_consts! {
+    GB_SVC_TYPE_PROTOCOL_VERSION,
+    GB_SVC_TYPE_SVC_HELLO,
+    GB_SVC_TYPE_INTF_DEVICE_ID,
+    GB_SVC_TYPE_INTF_RESET,
+    GB_SVC_TYPE_CONN_CREATE,
+    GB_SVC_TYPE_CONN_DESTROY,
+    GB_SVC_TYPE_DME_PEER_GET,
+    GB_SVC_TYPE_DME_PEER_SET,
+    GB_SVC_TYPE_ROUTE_CREATE,
+    GB_SVC_TYPE_ROUTE_DESTROY,
+    GB_SVC_TYPE_TIMESYNC_ENABLE,
+    GB_SVC_TYPE_TIMESYNC_DISABLE,
+    GB_SVC_TYPE_TIMESYNC_AUTHORITATIVE,
+    GB_SVC_TYPE_INTF_SET_PWRM,
+    GB_SVC_TYPE_INTF_EJECT,
+    GB_SVC_TYPE_PING,
+    GB_SVC_TYPE_PWRMON_RAIL_COUNT_GET,
+    GB_SVC_TYPE_PWRMON_RAIL_NAMES_GET,
+    GB_SVC_TYPE_PWRMON_SAMPLE_GET,
+    GB_SVC_TYPE_PWRMON_INTF_SAMPLE_GET,
+    GB_SVC_TYPE_TIMESYNC_WAKE_PINS_ACQUIRE,
+    GB_SVC_TYPE_TIMESYNC_WAKE_PINS_RELEASE,
+    GB_SVC_TYPE_TIMESYNC_PING,
+    GB_SVC_TYPE_MODULE_INSERTED,
+    GB_SVC_TYPE_MODULE_REMOVED,
+    GB_SVC_TYPE_INTF_VSYS_ENABLE,
+    GB_SVC_TYPE_INTF_VSYS_DISABLE,
+    GB_SVC_TYPE_INTF_REFCLK_ENABLE,
+    GB_SVC_TYPE_INTF_REFCLK_DISABLE,
+    GB_SVC_TYPE_INTF_UNIPRO_ENABLE,
+    GB_SVC_TYPE_INTF_UNIPRO_DISABLE,
+    GB_SVC_TYPE_INTF_ACTIVATE,
+    GB_SVC_TYPE_INTF_RESUME,
+    GB_SVC_TYPE_INTF_MAILBOX_EVENT,
+    GB_SVC_TYPE_INTF_OOPS,
+}
+
+// UNIPRO modes
+gb_u8_consts! {
+    GB_SVC_UNIPRO_FAST_MODE,
+    GB_SVC_UNIPRO_SLOW_MODE,
+    GB_SVC_UNIPRO_FAST_AUTO_MODE,
+    GB_SVC_UNIPRO_SLOW_AUTO_MODE,
+    GB_SVC_UNIPRO_MODE_UNCHANGED,
+    GB_SVC_UNIPRO_HIBERNATE_MODE,
+    GB_SVC_UNIPRO_OFF_MODE,
+}
+
+// PWR States
+gb_u8_consts! {
+    GB_SVC_SETPWRM_PWR_OK,
+    GB_SVC_SETPWRM_PWR_LOCAL,
+    GB_SVC_SETPWRM_PWR_REMOTE,
+    GB_SVC_SETPWRM_PWR_BUSY,
+    GB_SVC_SETPWRM_PWR_ERROR_CAP,
+    GB_SVC_SETPWRM_PWR_FATAL_ERROR,
+}
+
+// Vsys Result
+gb_u8_consts! {
+    GB_SVC_INTF_VSYS_OK,
+    GB_SVC_INTF_VSYS_FAIL,
+}
+
+// Refclk Result
+gb_u8_consts! {
+    GB_SVC_INTF_REFCLK_OK,
+    GB_SVC_INTF_REFCLK_FAIL,
+}
+
+// Unipro Result
+gb_u8_consts! {
+    GB_SVC_INTF_UNIPRO_OK,
+    GB_SVC_INTF_UNIPRO_FAIL,
+    GB_SVC_INTF_UNIPRO_NOT_OFF,
+}
+
+// Op Codes
+gb_u8_consts! {
+    GB_SVC_OP_SUCCESS,
+    GB_SVC_OP_UNKNOWN_ERROR,
+    GB_SVC_INTF_NOT_DETECTED,
+    GB_SVC_INTF_NO_UPRO_LINK,
+    GB_SVC_INTF_UPRO_NOT_DOWN,
+    GB_SVC_INTF_UPRO_NOT_HIBERNATED,
+    GB_SVC_INTF_NO_V_SYS,
+    GB_SVC_INTF_V_CHG,
+    GB_SVC_INTF_WAKE_BUSY,
+    GB_SVC_INTF_NO_REFCLK,
+    GB_SVC_INTF_RELEASING,
+    GB_SVC_INTF_NO_ORDER,
+    GB_SVC_INTF_MBOX_SET,
+    GB_SVC_INTF_BAD_MBOX,
+    GB_SVC_INTF_OP_TIMEOUT,
+    GB_SVC_PWRMON_OP_NOT_PRESENT,
+}
+
+// Greybus Interface Types
+gb_u8_consts! {
+    GB_SVC_INTF_TYPE_UNKNOWN,
+    GB_SVC_INTF_TYPE_DUMMY,
+    GB_SVC_INTF_TYPE_UNIPRO,
+    GB_SVC_INTF_TYPE_GREYBUS,
+}
+
+/// The header every Greybus message starts with.
+///
+/// # Invariants
+///
+/// The `size` field covers the header and the payload that follows it.
+#[repr(transparent)]
+pub struct GbOperationMsgHdr(bindings::gb_operation_msg_hdr);
+
+// SAFETY: `gb_operation_msg_hdr` is a POD type with no padding and no interior mutability.
+unsafe impl kernel::transmute::AsBytes for GbOperationMsgHdr {}
+
+impl GbOperationMsgHdr {
+    /// Builds a header. `size` is the whole message, this header included.
+    #[inline]
+    pub const fn new(size: u16, operation_id: u16, type_: u8, result: u8) -> Self {
+        Self(bindings::gb_operation_msg_hdr {
+            size: size.to_le(),
+            operation_id: operation_id.to_le(),
+            type_,
+            result,
+            pad: [0u8; 2],
+        })
+    }
+
+    /// Returns the type field, response bit included.
+    #[inline]
+    pub const fn msg_type(&self) -> u8 {
+        self.0.type_
+    }
+
+    /// Returns whether this is a response rather than a request.
+    #[inline]
+    pub const fn is_response(&self) -> bool {
+        self.0.type_ & MESSAGE_TYPE_RESPONSE != 0
+    }
+
+    /// Returns the operation id pairing a response with its request. Zero for unidirectional
+    /// messages.
+    #[inline]
+    pub const fn operation_id(&self) -> u16 {
+        u16::from_le(self.0.operation_id)
+    }
+
+    /// Returns the type field with the response bit cleared.
+    #[inline]
+    pub const fn request_type(&self) -> u8 {
+        self.msg_type() & !MESSAGE_TYPE_RESPONSE
+    }
+
+    /// Returns the whole message size, this header included.
+    #[inline]
+    pub const fn size(&self) -> u16 {
+        u16::from_le(self.0.size)
+    }
+}
+
+/// Request for [`GB_SVC_TYPE_PROTOCOL_VERSION`].
+#[repr(transparent)]
+pub struct GbSvcVersionRequest(bindings::gb_svc_version_request);
+
+impl GbSvcVersionRequest {
+    /// Creates a request advertising SVC protocol version `major`.`minor`.
+    #[inline]
+    pub const fn new(major: u8, minor: u8) -> Self {
+        Self(bindings::gb_svc_version_request { major, minor })
+    }
+}
+
+/// Request for [`GB_SVC_TYPE_SVC_HELLO`].
+#[repr(transparent)]
+pub struct GbSvcHelloRequest(bindings::gb_svc_hello_request);
+
+impl GbSvcHelloRequest {
+    /// Creates a hello request identifying the endo as `endo_id` and the AP's own interface as
+    /// `interface_id`.
+    #[inline]
+    pub const fn new(endo_id: u16, interface_id: u8) -> Self {
+        Self(bindings::gb_svc_hello_request {
+            endo_id: endo_id.to_le(),
+            interface_id,
+        })
+    }
+}
+
+/// Request for [`GB_SVC_TYPE_INTF_SET_PWRM`].
+#[repr(transparent)]
+pub struct GbSvcIntfSetPwrmRequest(bindings::gb_svc_intf_set_pwrm_request);
+
+// SAFETY: `gb_svc_intf_set_pwrm_request` is a struct of `u8` fields, so every bit pattern of its
+// size is a valid instance.
+unsafe impl kernel::transmute::FromBytes for GbSvcIntfSetPwrmRequest {}
+
+impl GbSvcIntfSetPwrmRequest {
+    /// Returns the requested TX gear, one of the `GB_SVC_UNIPRO_*` modes.
+    #[inline]
+    pub const fn tx_mode(&self) -> u8 {
+        self.0.tx_mode
+    }
+
+    /// Returns the requested RX gear, one of the `GB_SVC_UNIPRO_*` modes.
+    #[inline]
+    pub const fn rx_mode(&self) -> u8 {
+        self.0.rx_mode
+    }
+}
+
+/// Response to [`GB_SVC_TYPE_INTF_SET_PWRM`].
+#[repr(transparent)]
+pub struct GbSvcIntfSetPwrmResponse(bindings::gb_svc_intf_set_pwrm_response);
+
+impl GbSvcIntfSetPwrmResponse {
+    /// `result_code` is one of the `GB_SVC_SETPWRM_PWR_*` codes.
+    #[inline]
+    pub const fn new(result_code: u8) -> Self {
+        Self(bindings::gb_svc_intf_set_pwrm_response { result_code })
+    }
+}
+
+/// Response to [`GB_SVC_TYPE_DME_PEER_GET`].
+#[repr(transparent)]
+pub struct GbSvcDmePeerGetResponse(bindings::gb_svc_dme_peer_get_response);
+
+impl GbSvcDmePeerGetResponse {
+    /// `result_code` is the UniPro `ConfigResultCode`; `attr_value` is the UniPro attribute
+    /// value.
+    #[inline]
+    pub const fn new(result_code: u16, attr_value: u32) -> Self {
+        Self(bindings::gb_svc_dme_peer_get_response {
+            result_code: result_code.to_le(),
+            attr_value: attr_value.to_le(),
+        })
+    }
+}
+
+/// Response to [`GB_SVC_TYPE_DME_PEER_SET`].
+#[repr(transparent)]
+pub struct GbSvcDmePeerSetResponse(bindings::gb_svc_dme_peer_set_response);
+
+impl GbSvcDmePeerSetResponse {
+    /// `result_code` is the UniPro `ConfigResultCode`.
+    #[inline]
+    pub const fn new(result_code: u16) -> Self {
+        Self(bindings::gb_svc_dme_peer_set_response {
+            result_code: result_code.to_le(),
+        })
+    }
+}
+
+/// Response to [`GB_SVC_TYPE_PWRMON_RAIL_COUNT_GET`].
+#[repr(transparent)]
+pub struct GbSvcPwrmonRailCountGetResponse(bindings::gb_svc_pwrmon_rail_count_get_response);
+
+impl GbSvcPwrmonRailCountGetResponse {
+    /// Creates a response reporting `rail_count` available rails.
+    #[inline]
+    pub const fn new(rail_count: u8) -> Self {
+        Self(bindings::gb_svc_pwrmon_rail_count_get_response { rail_count })
+    }
+}
+
+/// Response to [`GB_SVC_TYPE_INTF_VSYS_ENABLE`] and [`GB_SVC_TYPE_INTF_VSYS_DISABLE`].
+#[repr(transparent)]
+pub struct GbSvcIntfVsysResponse(bindings::gb_svc_intf_vsys_response);
+
+impl GbSvcIntfVsysResponse {
+    /// `result_code` is [`GB_SVC_INTF_VSYS_OK`] or [`GB_SVC_INTF_VSYS_FAIL`].
+    #[inline]
+    pub const fn new(result_code: u8) -> Self {
+        Self(bindings::gb_svc_intf_vsys_response { result_code })
+    }
+}
+
+/// Response to [`GB_SVC_TYPE_INTF_REFCLK_ENABLE`] and [`GB_SVC_TYPE_INTF_REFCLK_DISABLE`].
+#[repr(transparent)]
+pub struct GbSvcIntfRefclkResponse(bindings::gb_svc_intf_refclk_response);
+
+impl GbSvcIntfRefclkResponse {
+    /// `result_code` is [`GB_SVC_INTF_REFCLK_OK`] or [`GB_SVC_INTF_REFCLK_FAIL`].
+    #[inline]
+    pub const fn new(result_code: u8) -> Self {
+        Self(bindings::gb_svc_intf_refclk_response { result_code })
+    }
+}
+
+/// Response to [`GB_SVC_TYPE_INTF_UNIPRO_ENABLE`] and [`GB_SVC_TYPE_INTF_UNIPRO_DISABLE`].
+#[repr(transparent)]
+pub struct GbSvcIntfUniproResponse(bindings::gb_svc_intf_unipro_response);
+
+impl GbSvcIntfUniproResponse {
+    /// `result_code` is one of the `GB_SVC_INTF_UNIPRO_*` codes.
+    #[inline]
+    pub const fn new(result_code: u8) -> Self {
+        Self(bindings::gb_svc_intf_unipro_response { result_code })
+    }
+}
+
+/// Response to [`GB_SVC_TYPE_INTF_ACTIVATE`].
+#[repr(transparent)]
+pub struct GbSvcIntfActivateResponse(bindings::gb_svc_intf_activate_response);
+
+impl GbSvcIntfActivateResponse {
+    /// `status` is one of the `GB_SVC_OP_*` codes; `intf_type` is one of the
+    /// `GB_SVC_INTF_TYPE_*` values and is only meaningful when `status` is
+    /// [`GB_SVC_OP_SUCCESS`].
+    #[inline]
+    pub const fn new(status: u8, intf_type: u8) -> Self {
+        Self(bindings::gb_svc_intf_activate_response { status, intf_type })
+    }
+}
+
+/// Response to [`GB_SVC_TYPE_INTF_RESUME`].
+#[repr(transparent)]
+pub struct GbSvcIntfResumeResponse(bindings::gb_svc_intf_resume_response);
+
+impl GbSvcIntfResumeResponse {
+    /// `status` is one of the `GB_SVC_OP_*` codes.
+    #[inline]
+    pub const fn new(status: u8) -> Self {
+        Self(bindings::gb_svc_intf_resume_response { status })
+    }
+}
+
+/// Request for [`GB_SVC_TYPE_MODULE_INSERTED`].
+#[repr(transparent)]
+pub struct GbSvcModuleInsertedRequest(bindings::gb_svc_module_inserted_request);
+
+impl GbSvcModuleInsertedRequest {
+    /// The module spans `intf_count` consecutive interfaces starting at `primary_intf_id`.
+    /// `flags` is a mask of `GB_SVC_MODULE_INSERTED_FLAG_*` values.
+    #[inline]
+    pub const fn new(primary_intf_id: u8, intf_count: u8, flags: u16) -> Self {
+        Self(bindings::gb_svc_module_inserted_request {
+            primary_intf_id,
+            intf_count,
+            flags: flags.to_le(),
+        })
+    }
+}
+
+/// Request for [`GB_SVC_TYPE_MODULE_REMOVED`].
+#[repr(transparent)]
+pub struct GbSvcModuleRemovedRequest(bindings::gb_svc_module_removed_request);
+
+// SAFETY: `gb_svc_module_removed_request` is a struct of `u8` field, so every bit pattern of its
+// size is a valid instance.
+unsafe impl kernel::transmute::FromBytes for GbSvcModuleRemovedRequest {}
+
+impl GbSvcModuleRemovedRequest {
+    /// `primary_intf_id` identifies the module, and matches the one given when it was inserted.
+    #[inline]
+    pub const fn new(primary_intf_id: u8) -> Self {
+        Self(bindings::gb_svc_module_removed_request { primary_intf_id })
+    }
+
+    /// Returns the primary_intf_id field.
+    #[inline]
+    pub const fn primary_intf_id(&self) -> u8 {
+        self.0.primary_intf_id
+    }
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 45c4f4db51d2..fca4f1795fea 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -80,6 +80,8 @@
 pub mod fs;
 #[cfg(CONFIG_GPU_BUDDY = "y")]
 pub mod gpu;
+#[cfg(CONFIG_RUST_GREYBUS_ABSTRACTIONS)]
+pub mod greybus;
 #[cfg(CONFIG_I2C = "y")]
 pub mod i2c;
 pub mod id_pool;

-- 
2.55.0

