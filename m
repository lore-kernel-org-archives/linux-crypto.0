Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B07C001DC
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 16:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbjGNQVH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 12:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbjGNQVG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 12:21:06 -0400
Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF801FF1
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jul 2023 09:21:01 -0700 (PDT)
Date:   Fri, 14 Jul 2023 16:20:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
        s=protonmail; t=1689351660; x=1689610860;
        bh=nWFlQxK6fdwpZ4SKRRwd1SlVW4M/ZwGH2Jr4TZigQNk=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=RZajsvAphS2ioNsn2ZLBZ7zfarFiycw9FHp3oEJfDHgSp6GB8CjgT9gSN9p0dJG31
         kVdQQlcusLURUsKJNyZe+WxHs3fAUkaBXMhDyo8+ifcuI0I/dGo+uJpzu4xZs2a5xH
         UREDn4PxTX7za/n9xeQjLo9+BZw+A1SnyjoScDrtbWlObkoD543dpua76HeLDhzmiC
         KbySJWsGTK9cOdybtqe/MyMfUG+n5zrsEIIIT5ql8WYEN0vD7i6EtMZP0cTFRSaky5
         bjOtH58wsZVcgMwqAUBgC7lR2t/PiPF3YbXwn0XlqbVs0jBJ3AostbXTyY41bQrwj+
         vrCmkyUrmfGgQ==
To:     FUJITA Tomonori <fujita.tomonori@gmail.com>
From:   Benno Lossin <benno.lossin@proton.me>
Cc:     rust-for-linux@vger.kernel.org, linux-crypto@vger.kernel.org,
        alex.gaynor@gmail.com, herbert@gondor.apana.org.au,
        ebiggers@kernel.org
Subject: Re: [PATCH v2 2/3] rust: crypto abstractions for random number generator API
Message-ID: <-xQIPlnP549kG6X754m3g70WVVQE7-ihc6XyZfhT7wxHDQiQZ2fr8JorXfRoNvK2-5pGlYWVPqBbkXXLSPRCjtLtMnoPCfau5n8P8AVqqi8=@proton.me>
In-Reply-To: <20230710102225.155019-3-fujita.tomonori@gmail.com>
References: <20230710102225.155019-1-fujita.tomonori@gmail.com> <20230710102225.155019-3-fujita.tomonori@gmail.com>
Feedback-ID: 71780778:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> This patch adds basic abstractions for random number generator API,
> wrapping crypto_rng structure.
>=20
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
> ---
>  rust/bindings/bindings_helper.h |   1 +
>  rust/helpers.c                  |  12 ++++
>  rust/kernel/crypto.rs           |   1 +
>  rust/kernel/crypto/rng.rs       | 101 ++++++++++++++++++++++++++++++++
>  4 files changed, 115 insertions(+)
>  create mode 100644 rust/kernel/crypto/rng.rs
>=20
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_hel=
per.h
> index 2f198c6d5de5..089ac38c6461 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -7,6 +7,7 @@
>   */
>=20
>  #include <crypto/hash.h>
> +#include <crypto/rng.h>
>  #include <linux/errname.h>
>  #include <linux/slab.h>
>  #include <linux/refcount.h>
> diff --git a/rust/helpers.c b/rust/helpers.c
> index 7966902ed8eb..e4dcd611738f 100644
> --- a/rust/helpers.c
> +++ b/rust/helpers.c
> @@ -19,6 +19,7 @@
>   */
>=20
>  #include <crypto/hash.h>
> +#include <crypto/rng.h>
>  #include <linux/bug.h>
>  #include <linux/build_bug.h>
>  #include <linux/err.h>
> @@ -52,6 +53,17 @@ int rust_helper_crypto_shash_init(struct shash_desc *d=
esc) {
>  =09return crypto_shash_init(desc);
>  }
>  EXPORT_SYMBOL_GPL(rust_helper_crypto_shash_init);
> +
> +void rust_helper_crypto_free_rng(struct crypto_rng *tfm) {
> +=09crypto_free_rng(tfm);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_crypto_free_rng);
> +
> +int rust_helper_crypto_rng_generate(struct crypto_rng *tfm, const u8 *sr=
c,
> +=09unsigned int slen, u8 *dst, unsigned int dlen) {
> +=09return crypto_rng_generate(tfm, src, slen, dst, dlen);
> +}
> +EXPORT_SYMBOL_GPL(rust_helper_crypto_rng_generate);
>  #endif
>=20
>  __noreturn void rust_helper_BUG(void)
> diff --git a/rust/kernel/crypto.rs b/rust/kernel/crypto.rs
> index f80dd7bd3381..a1995e6c85d4 100644
> --- a/rust/kernel/crypto.rs
> +++ b/rust/kernel/crypto.rs
> @@ -3,3 +3,4 @@
>  //! Cryptography.
>=20
>  pub mod hash;
> +pub mod rng;
> diff --git a/rust/kernel/crypto/rng.rs b/rust/kernel/crypto/rng.rs
> new file mode 100644
> index 000000000000..683f5ee464ce
> --- /dev/null
> +++ b/rust/kernel/crypto/rng.rs
> @@ -0,0 +1,101 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Random number generator.
> +//!
> +//! C headers: [`include/crypto/rng.h`](../../../../include/crypto/rng.h=
)
> +
> +use crate::{
> +    error::{code::EINVAL, from_err_ptr, to_result, Result},
> +    str::CStr,
> +};
> +
> +/// Type of Random number generator.
> +///
> +/// # Invariants
> +///
> +/// The pointer is valid.
> +enum RngType {
> +    /// Uses `crypto_default_rng`
> +    // We don't need to keep an pointer for the default but simpler.
> +    Default(*mut bindings::crypto_rng),
> +
> +    /// Allocated via `crypto_alloc_rng.
> +    Allocated(*mut bindings::crypto_rng),
> +}

You could also do this:
```
enum RngType {
    Default,
    Allocated(NonNull<bindings::crypto_rng>),
}
```

Assuming that `crypto_alloc_rng` never returns null.
Then this definition will the same size as a plain pointer.

> +
> +/// Corresponds to the kernel's `struct crypto_rng`.
> +pub struct Rng(RngType);
> +
> +impl Drop for Rng {
> +    fn drop(&mut self) {
> +        match self.0 {
> +            RngType::Default(_) =3D> {
> +                // SAFETY: it's safe because `crypto_get_default_rng()` =
was called during
> +                // the initialization.
> +                unsafe {
> +                    bindings::crypto_put_default_rng();
> +                }
> +            }
> +            RngType::Allocated(ptr) =3D> {
> +                // SAFETY: The type invariants of `RngType` guarantees t=
hat the pointer is valid.
> +                unsafe { bindings::crypto_free_rng(ptr) };
> +            }
> +        }
> +    }
> +}
> +
> +impl Rng {
> +    /// Creates a [`Rng`] instance.
> +    pub fn new(name: &CStr, t: u32, mask: u32) -> Result<Self> {
> +        // SAFETY: There are no safety requirements for this FFI call.
> +        let ptr =3D unsafe { from_err_ptr(bindings::crypto_alloc_rng(nam=
e.as_char_ptr(), t, mask)) }?;
> +        // INVARIANT: `ptr` is valid and non-null since `crypto_alloc_rn=
g`
> +        // returned a valid pointer which was null-checked.
> +        Ok(Self(RngType::Allocated(ptr)))
> +    }
> +
> +    /// Creates a [`Rng`] instance with a default algorithm.
> +    pub fn new_with_default() -> Result<Self> {
> +        // SAFETY: There are no safety requirements for this FFI call.
> +        to_result(unsafe { bindings::crypto_get_default_rng() })?;
> +        // INVARIANT: The C API guarantees that `crypto_default_rng` is =
valid until
> +        // `crypto_put_default_rng` is called.
> +        Ok(Self(RngType::Default(unsafe {
> +            bindings::crypto_default_rng

You are accessing a `mut static`, this is `unsafe` (hence the need
for an `unsafe` block) and needs a safety comment, why is it safe to
access this mutable static? What synchronizes the access (is it not needed)=
?

> +        })))
> +    }
> +
> +    /// Get a random number.
> +    pub fn generate(&mut self, src: &[u8], dst: &mut [u8]) -> Result {
> +        if src.len() > u32::MAX as usize || dst.len() > u32::MAX as usiz=
e {
> +            return Err(EINVAL);
> +        }
> +        let ptr =3D match self.0 {
> +            RngType::Default(ptr) =3D> ptr,
> +            RngType::Allocated(ptr) =3D> ptr,
> +        };
> +        // SAFETY: The type invariants of `RngType' guarantees that the =
pointer is valid.
> +        to_result(unsafe {
> +            bindings::crypto_rng_generate(
> +                ptr,
> +                src.as_ptr(),
> +                src.len() as u32,
> +                dst.as_mut_ptr(),
> +                dst.len() as u32,
> +            )
> +        })
> +    }
> +
> +    /// Re-initializes the [`Rng`] instance.
> +    pub fn reset(&mut self, seed: &[u8]) -> Result {
> +        if seed.len() > u32::MAX as usize {
> +            return Err(EINVAL);
> +        }
> +        let ptr =3D match self.0 {
> +            RngType::Default(ptr) =3D> ptr,
> +            RngType::Allocated(ptr) =3D> ptr,
> +        };
> +        // SAFETY: The type invariants of `RngType' guarantees that the =
pointer is valid.
> +        to_result(unsafe { bindings::crypto_rng_reset(ptr, seed.as_ptr()=
, seed.len() as u32) })

If I read this correctly, then if I have to threads each with a `Default`
crypto rng, then one could be reset as the other is concurrently
generating some random numbers, right? This *should* be fine, but does
it make sense to do it? Or should there only be one thread accessing
the default crypto rng?

--
Cheers,
Benno

> +    }
> +}
> --
> 2.34.1
>=20

