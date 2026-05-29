Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEBE409629
	for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 20:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084881; cv=pass; b=jYLivsJ1wMSxNlGSXJlUfx/mAbn2AMLtsiuKE/Ue2RGj3HOn9i5MBiXB/RqLqhA//Mjz8a46aIcT0gwn6+MzXu/Q20TETTCK+EDpk6XqajvaTjGYZw5/sq2Jj4N4fAnYRKPwr5dq0o6kq0MI/W+/feQIxwehroNuQm966F6sZWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084881; c=relaxed/simple;
	bh=WAqWJZAUb8ZVK4XJy10C2ADixl3jm2LehIxMP/7bG4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K8ix16vo58rrissx4IfVajKiQ/kLkJxXKej/ipGHznS91yGusBUueGCoUZCFAZxNe8DDcEw8SzWqqRQo+UEtjRfQQbMHtecnH6MUyMgIHw4O7JgTQKPQS0DmJRWwojq+WSLKmCaDSSls/dNToEUyu5ujHTi37duMyGZQLHziqyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ij240XLx; arc=pass smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ij240XLx"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-304d4e57d33so207862eec.3
        for <linux-crypto@vger.kernel.org>; Fri, 29 May 2026 13:01:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780084879; cv=none;
        d=google.com; s=arc-20240605;
        b=WL0jmaSv375+ih5QmcgXIsV5OslFLC4Qq7Yod1uczwS1kmxEccEZPqjC//xLNYfNOE
         8Rvh7d0K+WoS2HCTeQBC1DN/4WVk+t+rw40TBcLJXkBXBnaccl9G7dJv6ZHXLeWcAdl0
         nVGASfOfv1tB+Pr/TtyWoHDn3TjAMvRUeqZOyy1GgD5KBPf3PlCucONFvhHtBgGSuxIG
         Y2/Vzut8kt1/1S0BKO0BxnpHdObNeIfB0wcErz+awSfYQ0pP3panMPjQxPXy6carUS2n
         0Doj3ZkC1NKxx+nUggvsgMjd9j0hzHgMdIDJDP+glRXqzYAbDLncX2lSzsdNz8mD+RkD
         AKgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8vkaqpYvNud7y8KMYTCZTszv3lHuyhu6xumlwjXiuUY=;
        fh=Ww55gMeqpZC/heE2QT8Lg1Gtmbe76virIJ7PhhHlUYU=;
        b=F1v6nmRrUKM+xziHoqqupsMGk6lgmOyWdUyDaiuzY1gOzHruI2PnVAqVt51AWk3ajh
         dt6OWSPs9dxvMPkHotijirFrMdMKIdLNLFXi/7tfRrPrCXiE1rCYwXsZ6JXfngZKSJZq
         Kr5oMkaeCigTQa33aC4qBfy5dUP7tUhvxCQc8ivZEY7dvF27ql7zeps44/tfDO7QAU3M
         1j46dpAvNNyjztO8/Rj22Aue7Mfqz5lZkoERyPHBpEaR6FzB885cRFVUnA8j49UCe1ar
         U9yuNTHKO6zGjbqrEpDXaTnGfYUdo/V5mssIf/uBAYN4+qWZ4lPPEPOBT8VbW4Lrdaiy
         Kghw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780084879; x=1780689679; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vkaqpYvNud7y8KMYTCZTszv3lHuyhu6xumlwjXiuUY=;
        b=Ij240XLxaLdOlyikA9a19vn4gS4B/f6TIH+2TyW0c4i7Kg3qrbAkP4DPlzgYM/EKe1
         ZHzYioQyB7XYf3RYz9BEB1yR8lFabXnbrAjl5WBFnJulT3pcQcYWsN/TSAgm3btvkRZg
         NpqUNxzW+sFX9FmfU4rRF+tAKOf/zAmoyFIHBWIYhheweN6BRYExwrJJifJQdcQgSMqZ
         YsuQv+8X0n4yXBQV3Xf83uBUihTz/213XHgwowEDIxMobPKCpF6xJEW8s8eBdtupfY6L
         7dugqzGKYIs+hmI5luLdKg4nLCi1Wn65jZafiNzOecV3jAkyu75SuFp3KU+0ZDahfvu4
         xCnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780084879; x=1780689679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8vkaqpYvNud7y8KMYTCZTszv3lHuyhu6xumlwjXiuUY=;
        b=S/6UeBb/e3A8W7IOKOZaZJ4kx//9Hc8CFsineB7lI3VIW9bhM2ZgJsV3aKYPdtmkxJ
         T58uMLxBbYLsLM+BUYxPKxkxcqy9TbCxduyIqup3ocEGfkq3nq1uIGUf5sSimdV3M+Mi
         zCAd+ZuPiOhj6jQ+owmBSetGmhqisj0txpomZsh226MbmwLBH7HPs4553ZDC1q4qFB6z
         W8M+X+mzyBeZEHJropHLRhnkoWVuOrk8erM/Oz1m1cTJqS1I+iUG5RTar+3rnCxvqMup
         vN4u3y7Ig/ID7F10GW2rNtiLZLo4EOmXB6oS6sbVipIS0/9sqoAKDTD72LX/SkcBAVrb
         Sf4Q==
X-Forwarded-Encrypted: i=1; AFNElJ9OBHEgEpQ1Mv581Omr89eWfIRy9L4meEgkrZSZdKvKKm8ft/8OLe87ZMdqQSo+pb6i6oOrX+yem4lENBs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSTUNhwttgQLy+oKYfQUqRB/CLFbsEk8G2u55MlgLav60z1hUY
	Ar7aNmITkP8CRoeuuN9fTk9uDwAj2/SfzuXOd+fJMItU6Pt8XtASh2+v9N4xPYynI+1zOd1RpqH
	uPLcIRTAjfMkWCHL6Fnh9zuI3zoDzLKg=
X-Gm-Gg: Acq92OGZbqI3WiYwtI/2EHbhYXts5Inosx8jNHjtSoi1NGDf81aKpdAQhNlKUDgJQ/0
	iAt3c3Dk73neFySf6m+J9OIfW0lL7zxSHV0C+zy0weumzPc2XngdQDrEjiDHXlN0fiqtSxXb7ph
	38kckHCI5GEBbIN74se5ho+TQ2obTCmRMF7aOW1UBM2eJcEw0Pb7fpaWABdp/MlzB7i8gqfN5T6
	cpb6sl6NJNYe94PIsyLCsOmS8oLLSGDXKLykZEnYwPjAWmUDhwM+lqdLjCFToR94kzdEb7TFgPH
	/GfTXnANZafN5gwE+pbsif5C7dfYHDyj/zilYJHteLwzULc0hmfzCaFkVF2Fpm+tGB1eTFpfbSf
	1ZJ52iqdJBRbCeVNZx8bz0CXp1mF5Ac/TLg==
X-Received: by 2002:a05:7300:a198:b0:304:8361:a8a7 with SMTP id
 5a478bee46e88-304fa65a384mr230358eec.4.1780084878730; Fri, 29 May 2026
 13:01:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260529-rust-hw_random-virtio-rng-v1-0-b3153dd90311@pitsidianak.is>
 <20260529-rust-hw_random-virtio-rng-v1-2-b3153dd90311@pitsidianak.is>
In-Reply-To: <20260529-rust-hw_random-virtio-rng-v1-2-b3153dd90311@pitsidianak.is>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 29 May 2026 22:01:05 +0200
X-Gm-Features: AVHnY4Jfj_91jzMh-qh9topX7s7sVODf53cEMcX8mNsDRMgdtiN6qqERypjB-dw
Message-ID: <CANiq72nATB8rVvHEwS_GHoTP7a-gdsJZdvcu3stY6PpzCKih5w@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust: add hw_random module
To: Manos Pitsidianakis <manos@pitsidianak.is>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, manos.pitsidianakis@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Manos,

Some quick doc nits I noticed while managing our list...

On Fri, May 29, 2026 at 5:50=E2=80=AFPM Manos Pitsidianakis
<manos@pitsidianak.is> wrote:
>
> +//! # Example

"Examples" is the section name we use.

> +//!# fn no_run() {
> +//!# use kernel::hw_random::*;
> +//!# use kernel::str::CString;
> +//!# use kernel::prelude::*;

Missing indentation.

> +//!     fn read(&self, data: &mut Buffer<'_>, can_wait: bool) -> Result<=
()> {

-> Result

> +//!         // write zeroes - in your driver, this should write actual d=
ata from your hardware.

"Write"

> +//! let name =3D CString::try_from(c"example_hwrng").unwrap();

Could you avoid `unwrap()`s, perhaps using `?` etc.? It is not
critical, but good practice to try to show how "real code" would be
written.

> +        from_result,          //
> +        to_result,            //
> +        VTABLE_DEFAULT_ERROR, //

Please only use the slashes in the last one:

> +    },

...but add one here, since this level doesn't have it.

> +    /// Returns `true` if the buffer has been filled.

[`true`]

> +        // SAFETY: u8 and MaybeUninit<u8> have the same layout

Please use Markdown (but no intra-doc links needed) in comments too, e.g.

  `u8` ... `MaybeUninit<u8>`

There are other instances below.

> +/// [`struct hwrng`]: srctree/include/linux/hw_random.h

Is this reference used?

> +#[vtable]
> +/// Trait for the implementation of hardware RNGs.

Attributes after documentation.

Other instances below too.

> +    /// [`hwrng_unregister`]: srctree/include/linux/hw_random.h
> +    #[inline]
> +    #[doc(alias =3D "hwrng_unregister")]

Is this one for the alias? How does it behave when rendered?

> +    pub fn unregister(&self) {
> +        if self
> +            .registered
> +            .compare_exchange(true, false, Ordering::SeqCst, Ordering::A=
cquire)
> +            .is_ok()

We are starting to add `// ORDERING: ...` comments for things like
this, so it would be nice to have them here already.

> +        // SAFETY: we set `priv_` as the value of `*mut Self` when initi=
alizing.

Please start comments capitalized. Other instances elsewhere too.

Cheers,
Miguel
