Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6B0C001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 16:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbjGNQUR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 12:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbjGNQUQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 12:20:16 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8351211F
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jul 2023 09:20:14 -0700 (PDT)
Date:   Fri, 14 Jul 2023 16:19:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
        s=wzv2u5qanffsboo7w52ekd5hsq.protonmail; t=1689351609; x=1689610809;
        bh=/yhQ5h8Y6Wx7uVirBAiqkZnzC9Cwt6EWBQxKLZ+LIa0=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=cFrZY0Ad/LwkfgiMtCmiVASkLE8UM7V8yR2fXPsH3E+qRUioXjEZcJGtfdCCz+yX8
         gI+dCMt+1RQkpKwZWo6Wg3rljR7REhAXxe7g8yWyt+bPiDmoiv4dokoAcXW11VDtt7
         5CP06/Tk6Tj/gGHN8rEUKnxmyMnZ0b8gIZBN2rEJptNKUqZpiYX5PTDlc0AhfALQfr
         9ZPs+Qdoc52jcUlYxwIKBTI+rgG9i3PkcQZmbOih3dtRaSvRcLjKowj53wHLraZCQW
         fmMwOsAjoCjUKqWB3mhT0tbRs37T43fPxdbhx6nXIY59mZ/6N2OUZGifqbpr+E0rAt
         RSMVGE1e02sQQ==
To:     FUJITA Tomonori <fujita.tomonori@gmail.com>
From:   Benno Lossin <benno.lossin@proton.me>
Cc:     rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org,
        alex.gaynor@gmail.com, herbert@gondor.apana.org.au,
        ebiggers@kernel.org
Subject: Re: [PATCH v2 1/3] rust: crypto abstractions for synchronous message digest API
Message-ID: <kGKeFd4FklmCgr8eKZ_r5y0rTj66RHZCBoyJrd8wktnjGsdulyotH3j47GIxNqdNOteosNrCU4NxLbq1FTTBxGMZ3wrWIoxGOq8k-mDz1kE=@proton.me>
In-Reply-To: <20230710102225.155019-2-fujita.tomonori@gmail.com>
References: <20230710102225.155019-1-fujita.tomonori@gmail.com> <20230710102225.155019-2-fujita.tomonori@gmail.com>
Feedback-ID: 71780778:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> This patch adds basic abstractions for synchronous message digest API,
> wrapping crypto_shash and shash_desc structures.
>=20
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> ---
>  rust/bindings/bindings_helper.h |   1 +
>  rust/helpers.c                  |  26 +++++++
>  rust/kernel/crypto.rs           |   5 ++
>  rust/kernel/crypto/hash.rs      | 128 ++++++++++++++++++++++++++++++++
>  rust/kernel/lib.rs              |   2 +
>  5 files changed, 162 insertions(+)
>  create mode 100644 rust/kernel/crypto.rs
>  create mode 100644 rust/kernel/crypto/hash.rs
>=20
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_hel=
per.h
> index 3e601ce2548d..2f198c6d5de5 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -6,6 +6,7 @@
>   * Sorted alphabetically.
>   */
>=20
> +#include <crypto/hash.h>
>  #include <linux/errname.h>
>  #include <linux/slab.h>
>  #include <linux/refcount.h>
> diff --git a/rust/helpers.c b/rust/helpers.c
> index bb594da56137..7966902ed8eb 100644
> --- a/rust/helpers.c
> +++ b/rust/helpers.c
> @@ -18,6 +18,7 @@
>   * accidentally exposed.
>   */
>=20
> +#include <crypto/hash.h>
>  #include <linux/bug.h>
>  #include <linux/build_bug.h>
>  #include <linux/err.h>
> @@ -28,6 +29,31 @@
>  #include <linux/sched/signal.h>
>  #include <linux/wait.h>
>=20
> +#ifdef CONFIG_CRYPTO
> +void rust_helper_crypto_free_shash(struct crypto_shash *tfm)
> +{
> +=09crypto_free_shash(tfm);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_crypto_free_shash);
> +
> +unsigned int rust_helper_crypto_shash_digestsize(struct crypto_shash *tf=
m)
> +{
> +    return crypto_shash_digestsize(tfm);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_digestsize);
> +
> +unsigned int rust_helper_crypto_shash_descsize(struct crypto_shash *tfm)
> +{
> +    return crypto_shash_descsize(tfm);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_descsize);
> +
> +int rust_helper_crypto_shash_init(struct shash_desc *desc) {
> +=09return crypto_shash_init(desc);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_init);
> +#endif
> +
>  __noreturn void rust_helper_BUG(void)
>  {
>  =09BUG();
> diff --git a/rust/kernel/crypto.rs b/rust/kernel/crypto.rs
> new file mode 100644
> index 000000000000..f80dd7bd3381
> --- /dev/null
> +++ b/rust/kernel/crypto.rs
> @@ -0,0 +1,5 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Cryptography.
> +
> +pub mod hash;
> diff --git a/rust/kernel/crypto/hash.rs b/rust/kernel/crypto/hash.rs
> new file mode 100644
> index 000000000000..cdbc8e70e8f5
> --- /dev/null
> +++ b/rust/kernel/crypto/hash.rs
> @@ -0,0 +1,128 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Cryptographic Hash operations.
> +//!
> +//! C headers: [`include/crypto/hash.h`](../../../../include/crypto/hash=
.h)
> +
> +use crate::{
> +    error::{
> +        code::{EINVAL, ENOMEM},
> +        from_err_ptr, to_result, Result,
> +    },
> +    str::CStr,
> +};
> +use alloc::alloc::{alloc, dealloc};
> +use core::alloc::Layout;
> +
> +/// Corresponds to the kernel's `struct crypto_shash`.
> +///
> +/// # Invariants
> +///
> +/// The pointer is valid.
> +pub struct Shash(*mut bindings::crypto_shash);
> +
> +impl Drop for Shash {
> +    fn drop(&mut self) {
> +        // SAFETY: The type invariant guarantees that the pointer is val=
id.
> +        unsafe { bindings::crypto_free_shash(self.0) }
> +    }
> +}
> +
> +impl Shash {
> +    /// Creates a [`Shash`] object for a message digest handle.
> +    pub fn new(name: &CStr, t: u32, mask: u32) -> Result<Shash> {
> +        // SAFETY: There are no safety requirements for this FFI call.
> +        let ptr =3D
> +            unsafe { from_err_ptr(bindings::crypto_alloc_shash(name.as_c=
har_ptr(), t, mask)) }?;
> +        // INVARIANT: `ptr` is valid and non-null since `crypto_alloc_sh=
ash`
> +        // returned a valid pointer which was null-checked.
> +        Ok(Self(ptr))
> +    }
> +
> +    /// Sets optional key used by the hashing algorithm.
> +    pub fn setkey(&mut self, data: &[u8]) -> Result {
> +        // SAFETY: The type invariant guarantees that the pointer is val=
id.
> +        to_result(unsafe {
> +            bindings::crypto_shash_setkey(self.0, data.as_ptr(), data.le=
n() as u32)
> +        })
> +    }
> +
> +    /// Returns the size of the result of the transformation.
> +    pub fn digestsize(&self) -> u32 {
> +        // SAFETY: The type invariant guarantees that the pointer is val=
id.
> +        unsafe { bindings::crypto_shash_digestsize(self.0) }
> +    }
> +}
> +
> +/// Corresponds to the kernel's `struct shash_desc`.
> +///
> +/// # Invariants
> +///
> +/// The field `ptr` is valid.
> +pub struct ShashDesc<'a> {
> +    ptr: *mut bindings::shash_desc,
> +    tfm: &'a Shash,
> +    size: usize,
> +}
> +
> +impl Drop for ShashDesc<'_> {
> +    fn drop(&mut self) {
> +        // SAFETY: The type invariant guarantees that the pointer is val=
id.
> +        unsafe {
> +            dealloc(
> +                self.ptr.cast(),
> +                Layout::from_size_align(self.size, 2).unwrap(),
> +            );
> +        }
> +    }
> +}
> +
> +impl<'a> ShashDesc<'a> {
> +    /// Creates a [`ShashDesc`] object for a request data structure for =
message digest.
> +    pub fn new(tfm: &'a Shash) -> Result<Self> {
> +        // SAFETY: The type invariant guarantees that `tfm.0` pointer is=
 valid.
> +        let size =3D core::mem::size_of::<bindings::shash_desc>()
> +            + unsafe { bindings::crypto_shash_descsize(tfm.0) } as usize=
;
> +        let layout =3D Layout::from_size_align(size, 2)?;

I still do not like this arbitrary `2` constant as the alignment. Why is
this correct? It should be explained in the code. Otherwise use a
different way to compute the layout via `Layout::new()` and/or
`Layout::repeat`/`Layout::extend` etc.

--
Cheers,
Benno

> +        // SAFETY: It's safe because layout has non-zero size.
> +        let ptr =3D unsafe { alloc(layout) } as *mut bindings::shash_des=
c;
> +        if ptr.is_null() {
> +            return Err(ENOMEM);
> +        }
> +        // INVARIANT: `ptr` is valid and non-null since `alloc`
> +        // returned a valid pointer which was null-checked.
> +        let mut desc =3D ShashDesc { ptr, tfm, size };
> +        // SAFETY: `desc.ptr` is valid and non-null since `alloc`
> +        // returned a valid pointer which was null-checked.
> +        // Additionally, The type invariant guarantees that `tfm.0` is v=
alid.
> +        unsafe { (*desc.ptr).tfm =3D desc.tfm.0 };
> +        desc.reset()?;
> +        Ok(desc)
> +    }
> +
> +    /// Re-initializes message digest.
> +    pub fn reset(&mut self) -> Result {
> +        // SAFETY: The type invariant guarantees that the pointer is val=
id.
> +        to_result(unsafe { bindings::crypto_shash_init(self.ptr) })
> +    }
> +
> +    /// Adds data to message digest for processing.
> +    pub fn update(&mut self, data: &[u8]) -> Result {
> +        if data.len() > u32::MAX as usize {
> +            return Err(EINVAL);
> +        }
> +        // SAFETY: The type invariant guarantees that the pointer is val=
id.
> +        to_result(unsafe {
> +            bindings::crypto_shash_update(self.ptr, data.as_ptr(), data.=
len() as u32)
> +        })
> +    }
> +
> +    /// Calculates message digest.
> +    pub fn finalize(&mut self, output: &mut [u8]) -> Result {
> +        if self.tfm.digestsize() as usize > output.len() {
> +            return Err(EINVAL);
> +        }
> +        // SAFETY: The type invariant guarantees that the pointer is val=
id.
> +        to_result(unsafe { bindings::crypto_shash_final(self.ptr, output=
.as_mut_ptr()) })
> +    }
> +}
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 85b261209977..3cb8bd8a17d9 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -31,6 +31,8 @@
>  #[cfg(not(testlib))]
>  mod allocator;
>  mod build_assert;
> +#[cfg(CONFIG_CRYPTO)]
> +pub mod crypto;
>  pub mod error;
>  pub mod init;
>  pub mod ioctl;
> --
> 2.34.1
>=20

