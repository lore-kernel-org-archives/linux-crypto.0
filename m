Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BCB313E38
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 19:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084154; cv=none; b=WQEIUPDlCv+scjMY8OrsRYawB51IhKLzl96xXc9+tWwrjrGuvq1Bg944UW9XPcHJkQeCryDYGe6Q6vOtJ66BKceZumHBkLvH5neBsmmcJJfhXUxikVtveYRglTDXbXT/3UiJvXZ4fHt4cl9e8UEArD60xfyVrFTP+PArdxZRXWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084154; c=relaxed/simple;
	bh=xwXBQyguUR9lGGYsKqJ2g8lpgrn3qfGcf0LQaVzrkp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rAqrt5jb6T0KzMGCmOfcE3OongcTKnPPHwZnaN2AlXmfIjsqsEwF5+PYWkWYtzStujFGLChmybBN8PUEnALvi7400i4l2rBAjt1Rca+HIIipkpTjDghmfgULPoQU+MXA2gxU0FYUOHQm82V+9yVKrpNkEVDt2M+9YmgEr7/NVgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=onurozkan.dev; spf=pass smtp.mailfrom=onurozkan.dev; dkim=pass (2048-bit key) header.d=onurozkan.dev header.i=@onurozkan.dev header.b=aIh1zRa7; arc=none smtp.client-ip=109.224.244.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=onurozkan.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=onurozkan.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=onurozkan.dev header.i=@onurozkan.dev header.b="aIh1zRa7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=protonmail; t=1780084147; x=1780343347;
	bh=Mj8CpXobtgEqUiyWZOPXwFI3AggRfzcDvN9MYOTsk6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=aIh1zRa7WeaDyGz4A/qMNFWMHUYg3CqH8s5QttIs6XoDtFIQHAQGYwa19OrEHzSCO
	 aqeb0wUu8lj7qTTeElIyy92FkdvBuitGquUqe1Iy4lrO6x1m0iZ8fq2z5e07t2xre5
	 PDl5+SBfKYfW4Ob1IJjkPpsQQGit35c8IiDuQMO71m3smZewAlzo+eGYLyKUVG8Vcs
	 uSut8HozXCdpH8ZsGYtmAiudX2sVbq/T7UjIU6ORJCBzF9cQ2Q5qOXFzDCSxQnKjtE
	 YUZROIwwpnSmJ6av2bGNMJ+b64sogsvP9pO8XDTDAkO0RXxqKLEMTvg9tNwUwArcLF
	 yRgaCCtFUz0/Q==
X-Pm-Submission-Id: 4gRv7J2fbMz1DDLQ
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: Manos Pitsidianakis <manos@pitsidianak.is>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	manos.pitsidianakis@linaro.org
Subject: Re: [PATCH 2/2] rust: add hw_random module
Date: Fri, 29 May 2026 22:48:44 +0300
Message-ID: <20260529194858.32029-1-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260529-rust-hw_random-virtio-rng-v1-2-b3153dd90311@pitsidianak.is>
References: <20260529-rust-hw_random-virtio-rng-v1-0-b3153dd90311@pitsidianak.is> <20260529-rust-hw_random-virtio-rng-v1-2-b3153dd90311@pitsidianak.is>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 29 May 2026 18:50:27 +0300=0D
Manos Pitsidianakis <manos@pitsidianak.is> wrote:=0D
=0D
> Add abstraction for the hardware random number generator core subsystem.=
=0D
> =0D
> The registration is guarded by an atomic boolean, because we cannot yet=0D
> use IRQ disabling spinlocks in Rust. Once they are supported, we should=0D
> switch to that, because it's theoretically possible to construct a data=0D
> race. In practice I do not think it's possible, since registration=0D
> happens once in driver probe and unregistration happens on driver=0D
> teardown; there shouldn't be multiple threads doing their own thing in=0D
> both cases.=0D
=0D
hw_random/core.c seem to use Mutex, why are you not using Mutex<bool> inste=
ad of=0D
flipping atomics which doesn't really serialize register & unregister prope=
rly?=0D
=0D
> =0D
> Signed-off-by: Manos Pitsidianakis <manos@pitsidianak.is>=0D
> ---=0D
>  MAINTAINERS              |   8 ++=0D
>  rust/kernel/hw_random.rs | 320 +++++++++++++++++++++++++++++++++++++++++=
++++++=0D
>  rust/kernel/lib.rs       |   2 +=0D
>  3 files changed, 330 insertions(+)=0D
> =0D
> diff --git a/MAINTAINERS b/MAINTAINERS=0D
> index 4f60b323c796fc0968fd67d1c7afee6802990572..a3b372ccbd07c4ae2c735ba31=
f2acf40472b384a 100644=0D
> --- a/MAINTAINERS=0D
> +++ b/MAINTAINERS=0D
> @@ -11304,6 +11304,14 @@ F:	Documentation/devicetree/bindings/rng/=0D
>  F:	drivers/char/hw_random/=0D
>  F:	include/linux/hw_random.h=0D
>  =0D
> +HARDWARE RANDOM NUMBER GENERATOR CORE [RUST]=0D
> +M:	Manos Pitsidianakis <manos@pitsidianak.is>=0D
> +M:	Herbert Xu <herbert@gondor.apana.org.au>=0D
> +L:	linux-crypto@vger.kernel.org=0D
> +L:	rust-for-linux@vger.kernel.org=0D
> +S:	Maintained=0D
> +F:	rust/kernel/hw_random.rs=0D
> +=0D
>  HARDWARE SPINLOCK CORE=0D
>  M:	Bjorn Andersson <andersson@kernel.org>=0D
>  R:	Baolin Wang <baolin.wang7@gmail.com>=0D
> diff --git a/rust/kernel/hw_random.rs b/rust/kernel/hw_random.rs=0D
> new file mode 100644=0D
> index 0000000000000000000000000000000000000000..29fc180b4a3b4157a45c8fdb2=
d94bf1d9d781a3c=0D
> --- /dev/null=0D
> +++ b/rust/kernel/hw_random.rs=0D
> @@ -0,0 +1,320 @@=0D
> +// SPDX-License-Identifier: GPL-2.0=0D
> +// Author: Manos Pitsidianakis <manos@pitsidianak.is>=0D
> +=0D
> +//! Hardware Random Number Generators=0D
> +//!=0D
> +//! This module provides an abstraction for implementing a hardware rand=
om number generator and=0D
> +//! using it with the kernel's `hw_random` system.=0D
> +//!=0D
> +//! # Example=0D
> +//!=0D
> +//! ```no_run=0D
> +//!# fn no_run() {=0D
> +//!# use kernel::hw_random::*;=0D
> +//!# use kernel::str::CString;=0D
> +//!# use kernel::prelude::*;=0D
> +//! #[pin_data]=0D
> +//! struct ExampleHwRng {}=0D
> +//!=0D
> +//! #[vtable]=0D
> +//! impl HwRngImpl for ExampleHwRng {=0D
> +//!     fn read(&self, data: &mut Buffer<'_>, can_wait: bool) -> Result<=
()> {=0D
> +//!         // write zeroes - in your driver, this should write actual d=
ata from your hardware.=0D
> +//!         data.write(&[0_u8; 8]);=0D
> +//!         Ok(())=0D
> +//!     }=0D
> +//! }=0D
> +//!=0D
> +//! let name =3D CString::try_from(c"example_hwrng").unwrap();=0D
> +//! let my_rng =3D KBox::pin_init(=0D
> +//!                 HwRng::new(=0D
> +//!                     name,=0D
> +//!                     0,=0D
> +//!                     try_pin_init!(ExampleHwRng {})=0D
> +//!                 ),=0D
> +//!                 GFP_KERNEL=0D
> +//!              ).unwrap();=0D
> +//! // Register `my_rng`: after this succeeds, the kernel may call our `=
HwRngImpl` method at any=0D
> +//! // time.=0D
> +//! my_rng.register().unwrap();=0D
> +//!=0D
> +//! // ...=0D
> +//!=0D
> +//! my_rng.unregister();=0D
> +//!# }=0D
> +//!```=0D
> +=0D
> +use crate::{=0D
> +    error::{=0D
> +        from_result,          //=0D
> +        to_result,            //=0D
> +        VTABLE_DEFAULT_ERROR, //=0D
> +    },=0D
> +    prelude::*, //=0D
> +    str::{=0D
> +        CString, //=0D
> +    },=0D
> +    types::{=0D
> +        Opaque, //=0D
> +    },=0D
> +};=0D
> +=0D
> +use core::{=0D
> +    ffi::{=0D
> +        c_int,    //=0D
> +        c_ushort, //=0D
> +        c_void,   //=0D
=0D
You don't need to put "//" to every line. You can simply do:=0D
=0D
	a,=0D
	b,=0D
	c,=0D
	//=0D
=0D
> +    },=0D
> +    mem::{=0D
> +        MaybeUninit, //=0D
> +    },=0D
> +    ptr::{=0D
> +        slice_from_raw_parts,     //=0D
> +        slice_from_raw_parts_mut, //=0D
> +    },=0D
> +    sync::atomic::{=0D
> +        AtomicBool, //=0D
> +        Ordering,   //=0D
> +    },=0D
> +};=0D
> +=0D
> +use pin_init::pin_init_from_closure;=0D
> +=0D
> +/// A buffer to write random bytes in using [`Buffer::write`] that track=
s how many bytes were=0D
> +/// written.=0D
> +///=0D
> +/// See also [`HwRngImpl::read`].=0D
> +pub struct Buffer<'a> {=0D
> +    inner: &'a mut [MaybeUninit<u8>],=0D
> +    written: usize,=0D
> +}=0D
> +=0D
> +impl Buffer<'_> {=0D
> +    /// Returns `true` if the buffer has been filled.=0D
=0D
Either the doc or function name is wrong. Looking at the function logic, th=
is=0D
should be called "is_full"?=0D
=0D
> +    #[inline]=0D
> +    pub const fn is_empty(&self) -> bool {=0D
> +        self.written =3D=3D self.inner.len()=0D
> +    }=0D
> +=0D
> +    /// Returns the number of bytes that can be written.=0D
> +    #[inline]=0D
> +    pub const fn len(&self) -> usize {=0D
> +        self.inner.len() - self.written=0D
> +    }=0D
> +=0D
> +    /// Writes bytes from `buf` into buffer and returns the amount of by=
tes written.=0D
> +    #[inline]=0D
> +    pub fn write(&mut self, buf: &[u8]) -> usize {=0D
> +        let to_copy =3D self.len().min(buf.len());=0D
> +        let ptr =3D buf.as_ptr();=0D
> +        // SAFETY: u8 and MaybeUninit<u8> have the same layout=0D
> +        let buf =3D unsafe { &*slice_from_raw_parts(ptr.cast::<MaybeUnin=
it<u8>>(), to_copy) };=0D
> +        self.inner[self.written..][..to_copy].copy_from_slice(buf);=0D
> +        self.written +=3D to_copy;=0D
> +        to_copy=0D
> +    }=0D
> +}=0D
> +=0D
> +/// An adapter type for the registration of hardware random number gener=
ators drivers.=0D
> +///=0D
> +/// [`struct hwrng`]: srctree/include/linux/hw_random.h=0D
> +#[pin_data(PinnedDrop)]=0D
> +pub struct HwRng<T: HwRngImpl + 'static> {=0D
> +    #[pin]=0D
> +    registration: Opaque<bindings::hwrng>,=0D
> +    registered: AtomicBool,=0D
> +    #[pin]=0D
> +    name: CString,=0D
> +    #[pin]=0D
> +    inner: T,=0D
> +}=0D
> +=0D
> +impl<T: HwRngImpl + 'static> core::ops::Deref for HwRng<T> {=0D
> +    type Target =3D T;=0D
> +=0D
> +    #[inline]=0D
> +    fn deref(&self) -> &Self::Target {=0D
> +        &self.inner=0D
> +    }=0D
> +}=0D
> +=0D
> +// SAFETY: HwRng contains a `*const u8` reference but it is opaque for u=
s in Rust.=0D
> +unsafe impl<T: HwRngImpl + 'static> Send for HwRng<T> {}=0D
> +=0D
> +// SAFETY: `HwRng` has no interior mutability from Rust, and C manages i=
t with the rng_mutex lock.=0D
> +unsafe impl<T: HwRngImpl + 'static> Sync for HwRng<T> {}=0D
> +=0D
> +#[pinned_drop]=0D
> +impl<T: HwRngImpl> PinnedDrop for HwRng<T> {=0D
> +    fn drop(self: Pin<&mut Self>) {=0D
> +        self.unregister();=0D
> +    }=0D
> +}=0D
> +=0D
> +#[vtable]=0D
> +/// Trait for the implementation of hardware RNGs.=0D
=0D
Doc-comment should come first.=0D
=0D
> +pub trait HwRngImpl: Send + Sync {=0D
> +    #[inline]=0D
> +    /// Initialization callback, can be optionally implemented.=0D
> +    fn init(&self) -> Result {=0D
> +        build_error!(VTABLE_DEFAULT_ERROR)=0D
> +    }=0D
> +=0D
> +    #[inline]=0D
> +    /// Cleanup callback, can be optionally implemented.=0D
> +    fn cleanup(&self) {=0D
> +        build_error!(VTABLE_DEFAULT_ERROR)=0D
> +    }=0D
> +=0D
> +    /// Places random bytes in `data`.=0D
> +    fn read(&self, data: &mut Buffer<'_>, can_wait: bool) -> Result<()>;=
=0D
> +}=0D
> +=0D
> +impl<T: HwRngImpl + 'static> HwRng<T> {=0D
> +    /// Create a new [`HwRng`] without registering it.=0D
> +    pub fn new(=0D
> +        name: CString,=0D
> +        quality: c_ushort,=0D
> +        inner: impl PinInit<T, Error>,=0D
> +    ) -> impl PinInit<Self, Error> {=0D
> +        // We use pin_init_from_closure because we need to store the `sl=
ot` address as `priv` field=0D
> +        // of `hwrng` struct.=0D
> +=0D
> +        // SAFETY:=0D
> +        // - when the closure returns `Ok(())`, then it has successfully=
 initialized all fields,=0D
> +        // - when it returns `Err(e)`, it does not need to perform any c=
leanup.=0D
> +        unsafe {=0D
> +            pin_init_from_closure(move |slot: *mut Self| {=0D
> +                inner.__pinned_init(&raw mut (*slot).inner)?;=0D
> +=0D
> +                let registration =3D (&raw mut (*slot).registration).cas=
t::<bindings::hwrng>();=0D
> +                registration.write(bindings::hwrng {=0D
> +                    name: name.as_char_ptr(),=0D
> +                    read: Some(Self::read_callback),=0D
> +                    init: if <T as HwRngImpl>::HAS_INIT {=0D
> +                        Some(Self::init_callback)=0D
> +                    } else {=0D
> +                        None=0D
> +                    },=0D
> +                    cleanup: if <T as HwRngImpl>::HAS_CLEANUP {=0D
> +                        Some(Self::cleanup_callback)=0D
> +                    } else {=0D
> +                        None=0D
> +                    },=0D
> +                    quality,=0D
> +                    priv_: slot as usize,=0D
> +                    ..Default::default()=0D
> +                });=0D
> +=0D
> +                let name_ptr =3D &raw mut (*slot).name;=0D
> +                name_ptr.write(name);=0D
> +=0D
> +                let registered =3D &raw mut (*slot).registered;=0D
> +                registered.write(AtomicBool::new(false));=0D
> +=0D
> +                // All fields of `HwRng` have been initialized=0D
> +                Ok(())=0D
> +            })=0D
> +        }=0D
> +    }=0D
> +=0D
> +    /// Register `self` with the `hwrng` subsystem.=0D
> +    ///=0D
> +    /// After this function successfully returns, the `hwrng` subsystem =
can start calling the=0D
> +    /// [`HwRngImpl`] methods at any time.=0D
> +    ///=0D
> +    /// [`hwrng_register`]: srctree/include/linux/hw_random.h=0D
> +    #[inline]=0D
> +    #[doc(alias =3D "hwrng_register")]=0D
> +    pub fn register(&self) -> Result {=0D
> +        if self=0D
> +            .registered=0D
> +            .compare_exchange(false, true, Ordering::SeqCst, Ordering::A=
cquire)=0D
> +            .is_ok()=0D
> +        {=0D
> +            // SAFETY: `registration` is properly initialized.=0D
> +            if let Err(err) =3D to_result(unsafe {=0D
> +                bindings::hwrng_register(self.registration.get().cast::<=
bindings::hwrng>())=0D
> +            }) {=0D
> +                self.registered.store(false, Ordering::Release);=0D
> +                return Err(err);=0D
> +            }=0D
> +        }=0D
> +        Ok(())=0D
> +    }=0D
> +=0D
> +    /// Unregister `self` from `hwrng` subsystem.=0D
> +    ///=0D
> +    /// [`hwrng_unregister`]: srctree/include/linux/hw_random.h=0D
> +    #[inline]=0D
> +    #[doc(alias =3D "hwrng_unregister")]=0D
> +    pub fn unregister(&self) {=0D
> +        if self=0D
> +            .registered=0D
> +            .compare_exchange(true, false, Ordering::SeqCst, Ordering::A=
cquire)=0D
> +            .is_ok()=0D
> +        {=0D
> +            // SAFETY: Since `registration` is properly initialized and =
registered, destroying is=0D
> +            // safe.=0D
> +            unsafe {=0D
> +                bindings::hwrng_unregister(self.registration.get().cast:=
:<bindings::hwrng>())=0D
> +            };=0D
> +        }=0D
> +    }=0D
> +}=0D
> +=0D
> +impl<T: HwRngImpl + 'static> HwRng<T> {=0D
> +    extern "C" fn init_callback(ptr: *mut bindings::hwrng) -> c_int {=0D
> +        // SAFETY: we set `priv_` as the value of `*mut Self` when initi=
alizing.=0D
> +        let priv_ =3D unsafe { (*ptr).priv_ };=0D
> +        let this_ptr =3D priv_ as *mut Self;=0D
> +=0D
> +        // SAFETY: we set `inner` to point to a valid `T` when initializ=
ing.=0D
> +        let inner: &T =3D unsafe { &(*this_ptr).inner };=0D
> +        from_result(|| {=0D
> +            inner.init()?;=0D
> +            Ok(0)=0D
> +        })=0D
> +    }=0D
> +=0D
> +    extern "C" fn cleanup_callback(ptr: *mut bindings::hwrng) {=0D
> +        // SAFETY: we set `priv_` as the value of `*mut Self` when initi=
alizing.=0D
> +        let priv_ =3D unsafe { (*ptr).priv_ };=0D
> +        let this_ptr =3D priv_ as *mut Self;=0D
> +=0D
> +        // SAFETY: we set `inner` to point to a valid `T` when initializ=
ing.=0D
> +        let inner: &T =3D unsafe { &(*this_ptr).inner };=0D
> +        inner.cleanup();=0D
> +    }=0D
> +=0D
> +    extern "C" fn read_callback(=0D
> +        ptr: *mut bindings::hwrng,=0D
> +        data: *mut c_void,=0D
> +        max: usize,=0D
> +        wait: bool,=0D
> +    ) -> c_int {=0D
> +        if data.is_null() || max =3D=3D 0 {=0D
> +            return 0;=0D
> +        }=0D
> +=0D
> +        // SAFETY: we set `priv_` as the value of `*mut Self` when initi=
alizing.=0D
> +        let priv_ =3D unsafe { (*ptr).priv_ };=0D
> +        let this_ptr =3D priv_ as *mut Self;=0D
> +=0D
> +        let buf_ptr =3D slice_from_raw_parts_mut(data.cast::<MaybeUninit=
<u8>>(), max);=0D
> +        // SAFETY: By the hw_random API contract, data points to a bytes=
 buffer `max` bytes long.=0D
> +        let buf_ref =3D unsafe { &mut *buf_ptr };=0D
> +=0D
> +        let mut buffer =3D Buffer {=0D
> +            inner: buf_ref,=0D
> +            written: 0,=0D
> +        };=0D
> +=0D
> +        // SAFETY: we set `inner` to point to a valid `T` when initializ=
ing.=0D
> +        let inner: &T =3D unsafe { &(*this_ptr).inner };=0D
> +        from_result(|| {=0D
> +            inner.read(&mut buffer, wait)?;=0D
> +            Ok(buffer.written.try_into().unwrap_or(c_int::MAX))=0D
> +        })=0D
> +    }=0D
> +}=0D
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs=0D
> index ea08641919c26faba97cf5dd9b67b0df55fcd698..096b6d9d57d20612864289e87=
a359331058fb01c 100644=0D
> --- a/rust/kernel/lib.rs=0D
> +++ b/rust/kernel/lib.rs=0D
> @@ -74,6 +74,8 @@=0D
>  pub mod fs;=0D
>  #[cfg(CONFIG_GPU_BUDDY =3D "y")]=0D
>  pub mod gpu;=0D
> +#[cfg(CONFIG_HW_RANDOM =3D "y")]=0D
> +pub mod hw_random;=0D
>  #[cfg(CONFIG_I2C =3D "y")]=0D
>  pub mod i2c;=0D
>  pub mod id_pool;=0D
> =0D
> -- =0D
> 2.47.3=0D
> =0D
