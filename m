Received: from mail.nessuent.net (mail.nessuent.net [188.245.177.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9853E0C4C;
	Fri, 29 May 2026 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.245.177.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780069853; cv=none; b=IMSEikAy6V3XAHYygSfbUNnbigU6NKbHLDY/RaA7YzA8zvjXpMzWhxjQBNJu8Yyu9WAS3V4sXorn3FoWkaHdvuTq6eO9ccBkcmhBg2V+Fp6he94oKrY6jiAQ/tHRT9H8ZNjWl5VMtDZG5t6Xn5OgdCT02bKHTQffYfLZJhbgYUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780069853; c=relaxed/simple;
	bh=oRUSy6GjfKCGaxtXSkaaWCKqLDZmjWp5yKRFlQ2xNuk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Po3NcFme4pz42wkOKsgYUr1uIVchzE/00glJXsl7o0/maTc/gJ+gGEHHQCRNcuPHfRJoP9uD9NhCSgwF+aEBu7eWvB3Rq06UGyl1itm8ZyZW5E7nsMOS44LtIaQ9KRCiRLMLqj9t71LSm5iFfOyeYjJyH33HzWXbeppQzaRS7Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pitsidianak.is; spf=pass smtp.mailfrom=pitsidianak.is; dkim=pass (4096-bit key) header.d=pitsidianak.is header.i=@pitsidianak.is header.b=qQlAmHnf; arc=none smtp.client-ip=188.245.177.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pitsidianak.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pitsidianak.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=pitsidianak.is header.i=@pitsidianak.is header.b="qQlAmHnf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pitsidianak.is;
	s=mailSelector; t=1780069843;
	bh=oRUSy6GjfKCGaxtXSkaaWCKqLDZmjWp5yKRFlQ2xNuk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From:Subject;
	b=qQlAmHnfwkidTph/8R5jq+Kt7VbXJQGOUZxLcLgQEk/fhPvT0d5YREQoVWXfCLw1q
	 FS+C0UX3ZkNipTuYd/pxe7mMRHokx2jiQnqyvum4iz1daK7UkGq09ZCHLlwihC8LYI
	 ycqjOJPhC7p/DzDJG2xkHs1d8p0lO7XVun+UpwKJXCTVU0ccIGkXH90qaaOPnsUrhX
	 zne4YvK3xbtpsmVRq4Vn667yaQHpbNLMiq89Nor0hhJ4GAkzKK3neilU9fKTfwMKoH
	 wR+BaUSRp5+46iiY3TsV9X1ZT/viZFAF1TgguTNtVImfcPURcPkPRefVJWQweDdTBp
	 HIZG9opWh1Sf+5jMJ7j2rPl5XElXjuMWd9/ZTbwZugnlICnYd1cSLXOZX2qgbuLHIl
	 noxbQI7MkSLrkuL7gD6N6yGH8958p/mG2G2hnbIKEXO/vd742+eTYTIel5hI0eiK71
	 WCqVzX0dVZe0gMCKGNw3YdR9QWuz1UR9OeRL3geTnI/xW0Tn/FD/WP5ZP635yxm/8V
	 4LDt1BeFeMCZDesP5vYMC4WAzDMcX3RgXDAmDAU2bLLOlGozHTs0hfGt41C6uaGgWM
	 7NO8VyB2w7HWCC0kutm2K1zkFdSQpO5OxtBy3O5nZ++rTRmjvuf7roPfLf/+scc7qS
	 t1xJW70ydB7Mkr0HAlbrwiQg=
From: Manos Pitsidianakis <manos@pitsidianak.is>
Date: Fri, 29 May 2026 18:50:27 +0300
Subject: [PATCH 2/2] rust: add hw_random module
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260529-rust-hw_random-virtio-rng-v1-2-b3153dd90311@pitsidianak.is>
References: <20260529-rust-hw_random-virtio-rng-v1-0-b3153dd90311@pitsidianak.is>
In-Reply-To: <20260529-rust-hw_random-virtio-rng-v1-0-b3153dd90311@pitsidianak.is>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, manos.pitsidianakis@linaro.org
X-Developer-Signature: v=1; a=openpgp-sha256; l=12364; i=manos@pitsidianak.is;
 h=from:subject:message-id; bh=oRUSy6GjfKCGaxtXSkaaWCKqLDZmjWp5yKRFlQ2xNuk=;
 b=LS0tLS1CRUdJTiBQR1AgTUVTU0FHRS0tLS0tCgpvd0VCYlFLUy9aQU5Bd0FLQVhjcHgzQi9mZ
 25RQWNzbVlnQnFHYlhNUmtXNWVQQ3R1bHRySnU4ZHhYbFo4QUhyCnRTOFh0a2kvUENjNUJST0U4
 U09KQWpNRUFBRUtBQjBXSVFUTVhCdE9SS0JXODRkd0hSQjNLY2R3ZjM0SjBBVUMKYWhtMXpBQUt
 DUkIzS2Nkd2YzNEowTHd2RC85d1pTVVQydEUva3VEZUtDUlovL1lQZVlaNVMrQzV5c1pHaWVVcQ
 p3cTJCVjdqeUhJUGZ1OU5GOXcxNUp1RjZrTGxSa1RHRlBGTHNpUHlIUjcrVFZ5d0VEdDB4b2Zaa
 EVJdFoySGFvCi9YVlpvMlRBc3RmL0N2OEtTTGEwczlOK0VmZnl6dEZLOGR4V1h4MzFhQWZsOG9Q
 SjRhNW8rQnpWSHQ3bVNQdUUKQ245L1V1VTZLQ0JkVGRqRkthaWdjalpKWDhHcG5Mbk80SzhkVDZ
 wUjBKZ1lTYlBFTmhNZDMrRGJWUStTbnlvdgpnOHNGaXl0eGxUZkJGV0g4Ky9wRTg2UjJNaEl1UD
 hVQ2VVWlZqaldsRDIvOEFTQUhKd0dPZ2RNemZLY3R5eTdnCkZML2s5dTRxaDhUOWlGR0NPYXJIQ
 ys0dDh6WGFUS0ViVHhjZ0NMTkpUZ3NrTzN3K2ZDOFB6RVFhRHpxcjhBamYKSkpDUlZOb1d3QnMz
 UVhFOTlaTEVVTkVhYmlkcFBrOU1Fa2lkUG1CYnlHQlM5elRxZW1QNnFPNFVxNk5Ec3R1bgpXbVc
 1cmUwdW5CTHNLOUcwMjhyaHJVdVQxQlN0bFhxTUtKVWVHdmJxUGdlVWRUaTI2TFdURmg5QlZ3ME
 kxUzZmCnJwbUlpZE5ocDUranVHNDBnNW1DSnRkVW9YemVRRDRpcWZnZTcxUjhvQ0hENlhPeWI1Q
 0dIb1p3NFJZVlQ2MVcKaGZhWXBWWEN0RUhVa0F3dmJ0T3NyWTVSVWxmTW9zNy82U1MweFhKSVk0
 K3ovTkdYc2FZZUplWnUvWkZhU3dZRAptNjRhcC85Q3k4cWJIMmMySG1SR2VFc3pzeklEUFo1ZW1
 CSzlSNS9NcTQ0amlHOURqWEVxM0tEYms5c2thak1LCmMzR0c3UT09Cj1qSCtUCi0tLS0tRU5EIF
 BHUCBNRVNTQUdFLS0tLS0K
X-Developer-Key: i=manos@pitsidianak.is; a=openpgp;
 fpr=7C721DF9DB3CC7182311C0BF68BC211D47B421E1

Add abstraction for the hardware random number generator core subsystem.

The registration is guarded by an atomic boolean, because we cannot yet
use IRQ disabling spinlocks in Rust. Once they are supported, we should
switch to that, because it's theoretically possible to construct a data
race. In practice I do not think it's possible, since registration
happens once in driver probe and unregistration happens on driver
teardown; there shouldn't be multiple threads doing their own thing in
both cases.

Signed-off-by: Manos Pitsidianakis <manos@pitsidianak.is>
---
 MAINTAINERS              |   8 ++
 rust/kernel/hw_random.rs | 320 +++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs       |   2 +
 3 files changed, 330 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4f60b323c796fc0968fd67d1c7afee6802990572..a3b372ccbd07c4ae2c735ba31f2acf40472b384a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11304,6 +11304,14 @@ F:	Documentation/devicetree/bindings/rng/
 F:	drivers/char/hw_random/
 F:	include/linux/hw_random.h
 
+HARDWARE RANDOM NUMBER GENERATOR CORE [RUST]
+M:	Manos Pitsidianakis <manos@pitsidianak.is>
+M:	Herbert Xu <herbert@gondor.apana.org.au>
+L:	linux-crypto@vger.kernel.org
+L:	rust-for-linux@vger.kernel.org
+S:	Maintained
+F:	rust/kernel/hw_random.rs
+
 HARDWARE SPINLOCK CORE
 M:	Bjorn Andersson <andersson@kernel.org>
 R:	Baolin Wang <baolin.wang7@gmail.com>
diff --git a/rust/kernel/hw_random.rs b/rust/kernel/hw_random.rs
new file mode 100644
index 0000000000000000000000000000000000000000..29fc180b4a3b4157a45c8fdb2d94bf1d9d781a3c
--- /dev/null
+++ b/rust/kernel/hw_random.rs
@@ -0,0 +1,320 @@
+// SPDX-License-Identifier: GPL-2.0
+// Author: Manos Pitsidianakis <manos@pitsidianak.is>
+
+//! Hardware Random Number Generators
+//!
+//! This module provides an abstraction for implementing a hardware random number generator and
+//! using it with the kernel's `hw_random` system.
+//!
+//! # Example
+//!
+//! ```no_run
+//!# fn no_run() {
+//!# use kernel::hw_random::*;
+//!# use kernel::str::CString;
+//!# use kernel::prelude::*;
+//! #[pin_data]
+//! struct ExampleHwRng {}
+//!
+//! #[vtable]
+//! impl HwRngImpl for ExampleHwRng {
+//!     fn read(&self, data: &mut Buffer<'_>, can_wait: bool) -> Result<()> {
+//!         // write zeroes - in your driver, this should write actual data from your hardware.
+//!         data.write(&[0_u8; 8]);
+//!         Ok(())
+//!     }
+//! }
+//!
+//! let name = CString::try_from(c"example_hwrng").unwrap();
+//! let my_rng = KBox::pin_init(
+//!                 HwRng::new(
+//!                     name,
+//!                     0,
+//!                     try_pin_init!(ExampleHwRng {})
+//!                 ),
+//!                 GFP_KERNEL
+//!              ).unwrap();
+//! // Register `my_rng`: after this succeeds, the kernel may call our `HwRngImpl` method at any
+//! // time.
+//! my_rng.register().unwrap();
+//!
+//! // ...
+//!
+//! my_rng.unregister();
+//!# }
+//!```
+
+use crate::{
+    error::{
+        from_result,          //
+        to_result,            //
+        VTABLE_DEFAULT_ERROR, //
+    },
+    prelude::*, //
+    str::{
+        CString, //
+    },
+    types::{
+        Opaque, //
+    },
+};
+
+use core::{
+    ffi::{
+        c_int,    //
+        c_ushort, //
+        c_void,   //
+    },
+    mem::{
+        MaybeUninit, //
+    },
+    ptr::{
+        slice_from_raw_parts,     //
+        slice_from_raw_parts_mut, //
+    },
+    sync::atomic::{
+        AtomicBool, //
+        Ordering,   //
+    },
+};
+
+use pin_init::pin_init_from_closure;
+
+/// A buffer to write random bytes in using [`Buffer::write`] that tracks how many bytes were
+/// written.
+///
+/// See also [`HwRngImpl::read`].
+pub struct Buffer<'a> {
+    inner: &'a mut [MaybeUninit<u8>],
+    written: usize,
+}
+
+impl Buffer<'_> {
+    /// Returns `true` if the buffer has been filled.
+    #[inline]
+    pub const fn is_empty(&self) -> bool {
+        self.written == self.inner.len()
+    }
+
+    /// Returns the number of bytes that can be written.
+    #[inline]
+    pub const fn len(&self) -> usize {
+        self.inner.len() - self.written
+    }
+
+    /// Writes bytes from `buf` into buffer and returns the amount of bytes written.
+    #[inline]
+    pub fn write(&mut self, buf: &[u8]) -> usize {
+        let to_copy = self.len().min(buf.len());
+        let ptr = buf.as_ptr();
+        // SAFETY: u8 and MaybeUninit<u8> have the same layout
+        let buf = unsafe { &*slice_from_raw_parts(ptr.cast::<MaybeUninit<u8>>(), to_copy) };
+        self.inner[self.written..][..to_copy].copy_from_slice(buf);
+        self.written += to_copy;
+        to_copy
+    }
+}
+
+/// An adapter type for the registration of hardware random number generators drivers.
+///
+/// [`struct hwrng`]: srctree/include/linux/hw_random.h
+#[pin_data(PinnedDrop)]
+pub struct HwRng<T: HwRngImpl + 'static> {
+    #[pin]
+    registration: Opaque<bindings::hwrng>,
+    registered: AtomicBool,
+    #[pin]
+    name: CString,
+    #[pin]
+    inner: T,
+}
+
+impl<T: HwRngImpl + 'static> core::ops::Deref for HwRng<T> {
+    type Target = T;
+
+    #[inline]
+    fn deref(&self) -> &Self::Target {
+        &self.inner
+    }
+}
+
+// SAFETY: HwRng contains a `*const u8` reference but it is opaque for us in Rust.
+unsafe impl<T: HwRngImpl + 'static> Send for HwRng<T> {}
+
+// SAFETY: `HwRng` has no interior mutability from Rust, and C manages it with the rng_mutex lock.
+unsafe impl<T: HwRngImpl + 'static> Sync for HwRng<T> {}
+
+#[pinned_drop]
+impl<T: HwRngImpl> PinnedDrop for HwRng<T> {
+    fn drop(self: Pin<&mut Self>) {
+        self.unregister();
+    }
+}
+
+#[vtable]
+/// Trait for the implementation of hardware RNGs.
+pub trait HwRngImpl: Send + Sync {
+    #[inline]
+    /// Initialization callback, can be optionally implemented.
+    fn init(&self) -> Result {
+        build_error!(VTABLE_DEFAULT_ERROR)
+    }
+
+    #[inline]
+    /// Cleanup callback, can be optionally implemented.
+    fn cleanup(&self) {
+        build_error!(VTABLE_DEFAULT_ERROR)
+    }
+
+    /// Places random bytes in `data`.
+    fn read(&self, data: &mut Buffer<'_>, can_wait: bool) -> Result<()>;
+}
+
+impl<T: HwRngImpl + 'static> HwRng<T> {
+    /// Create a new [`HwRng`] without registering it.
+    pub fn new(
+        name: CString,
+        quality: c_ushort,
+        inner: impl PinInit<T, Error>,
+    ) -> impl PinInit<Self, Error> {
+        // We use pin_init_from_closure because we need to store the `slot` address as `priv` field
+        // of `hwrng` struct.
+
+        // SAFETY:
+        // - when the closure returns `Ok(())`, then it has successfully initialized all fields,
+        // - when it returns `Err(e)`, it does not need to perform any cleanup.
+        unsafe {
+            pin_init_from_closure(move |slot: *mut Self| {
+                inner.__pinned_init(&raw mut (*slot).inner)?;
+
+                let registration = (&raw mut (*slot).registration).cast::<bindings::hwrng>();
+                registration.write(bindings::hwrng {
+                    name: name.as_char_ptr(),
+                    read: Some(Self::read_callback),
+                    init: if <T as HwRngImpl>::HAS_INIT {
+                        Some(Self::init_callback)
+                    } else {
+                        None
+                    },
+                    cleanup: if <T as HwRngImpl>::HAS_CLEANUP {
+                        Some(Self::cleanup_callback)
+                    } else {
+                        None
+                    },
+                    quality,
+                    priv_: slot as usize,
+                    ..Default::default()
+                });
+
+                let name_ptr = &raw mut (*slot).name;
+                name_ptr.write(name);
+
+                let registered = &raw mut (*slot).registered;
+                registered.write(AtomicBool::new(false));
+
+                // All fields of `HwRng` have been initialized
+                Ok(())
+            })
+        }
+    }
+
+    /// Register `self` with the `hwrng` subsystem.
+    ///
+    /// After this function successfully returns, the `hwrng` subsystem can start calling the
+    /// [`HwRngImpl`] methods at any time.
+    ///
+    /// [`hwrng_register`]: srctree/include/linux/hw_random.h
+    #[inline]
+    #[doc(alias = "hwrng_register")]
+    pub fn register(&self) -> Result {
+        if self
+            .registered
+            .compare_exchange(false, true, Ordering::SeqCst, Ordering::Acquire)
+            .is_ok()
+        {
+            // SAFETY: `registration` is properly initialized.
+            if let Err(err) = to_result(unsafe {
+                bindings::hwrng_register(self.registration.get().cast::<bindings::hwrng>())
+            }) {
+                self.registered.store(false, Ordering::Release);
+                return Err(err);
+            }
+        }
+        Ok(())
+    }
+
+    /// Unregister `self` from `hwrng` subsystem.
+    ///
+    /// [`hwrng_unregister`]: srctree/include/linux/hw_random.h
+    #[inline]
+    #[doc(alias = "hwrng_unregister")]
+    pub fn unregister(&self) {
+        if self
+            .registered
+            .compare_exchange(true, false, Ordering::SeqCst, Ordering::Acquire)
+            .is_ok()
+        {
+            // SAFETY: Since `registration` is properly initialized and registered, destroying is
+            // safe.
+            unsafe {
+                bindings::hwrng_unregister(self.registration.get().cast::<bindings::hwrng>())
+            };
+        }
+    }
+}
+
+impl<T: HwRngImpl + 'static> HwRng<T> {
+    extern "C" fn init_callback(ptr: *mut bindings::hwrng) -> c_int {
+        // SAFETY: we set `priv_` as the value of `*mut Self` when initializing.
+        let priv_ = unsafe { (*ptr).priv_ };
+        let this_ptr = priv_ as *mut Self;
+
+        // SAFETY: we set `inner` to point to a valid `T` when initializing.
+        let inner: &T = unsafe { &(*this_ptr).inner };
+        from_result(|| {
+            inner.init()?;
+            Ok(0)
+        })
+    }
+
+    extern "C" fn cleanup_callback(ptr: *mut bindings::hwrng) {
+        // SAFETY: we set `priv_` as the value of `*mut Self` when initializing.
+        let priv_ = unsafe { (*ptr).priv_ };
+        let this_ptr = priv_ as *mut Self;
+
+        // SAFETY: we set `inner` to point to a valid `T` when initializing.
+        let inner: &T = unsafe { &(*this_ptr).inner };
+        inner.cleanup();
+    }
+
+    extern "C" fn read_callback(
+        ptr: *mut bindings::hwrng,
+        data: *mut c_void,
+        max: usize,
+        wait: bool,
+    ) -> c_int {
+        if data.is_null() || max == 0 {
+            return 0;
+        }
+
+        // SAFETY: we set `priv_` as the value of `*mut Self` when initializing.
+        let priv_ = unsafe { (*ptr).priv_ };
+        let this_ptr = priv_ as *mut Self;
+
+        let buf_ptr = slice_from_raw_parts_mut(data.cast::<MaybeUninit<u8>>(), max);
+        // SAFETY: By the hw_random API contract, data points to a bytes buffer `max` bytes long.
+        let buf_ref = unsafe { &mut *buf_ptr };
+
+        let mut buffer = Buffer {
+            inner: buf_ref,
+            written: 0,
+        };
+
+        // SAFETY: we set `inner` to point to a valid `T` when initializing.
+        let inner: &T = unsafe { &(*this_ptr).inner };
+        from_result(|| {
+            inner.read(&mut buffer, wait)?;
+            Ok(buffer.written.try_into().unwrap_or(c_int::MAX))
+        })
+    }
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index ea08641919c26faba97cf5dd9b67b0df55fcd698..096b6d9d57d20612864289e87a359331058fb01c 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -74,6 +74,8 @@
 pub mod fs;
 #[cfg(CONFIG_GPU_BUDDY = "y")]
 pub mod gpu;
+#[cfg(CONFIG_HW_RANDOM = "y")]
+pub mod hw_random;
 #[cfg(CONFIG_I2C = "y")]
 pub mod i2c;
 pub mod id_pool;

-- 
2.47.3

