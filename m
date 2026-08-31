Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49CA349CC6
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 17:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195906; cv=pass; b=rfW5UOrsFyQSh4UJzJSHHVFUkkZ+irOGlw/jCYeH2S3EaJdHDlyRaEJlLKQkgKLBBWHQ0L2byb3kyaxiTmebnRH5jQLKVj24zyf2ZTN+FwcoZCAk9jFTFPb6AucI/UeZr3G1tpDHLyw9SBOr/6uuNfnoibWu+RswvO0XIQL83j4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195906; c=relaxed/simple;
	bh=wbusIXCi4IMQab0ryvgkHW5sveBwQ2NlPsvZNTV8bzk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IQG2o0aXrsD6/H+VQTK3w8UKt5zeV60pWrfV+WTfZiP+tOupdxvWHW4afxRzLPj4HgGjTXWNNltY51ZmOutqJz1EbND71l0iUrREk0k9UKJjVP+VIFFxs3o3CfNZCAySzy8bKWKKgcKIHJkYugBJ0r5KWLuWFRAuYmldUUtQDt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk; spf=none smtp.mailfrom=fireburn.co.uk; dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b=ln9WvdPm; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b="ln9WvdPm"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-66d1447e2b1so163923d50.0
        for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 10:05:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788195903; cv=none;
        d=google.com; s=arc-20260327;
        b=dsMzOPxGqp/814Z5dQlWzUkBeWkNy44HWEGsSOXeVxKfxgRUK+UZYZCutDG9m2Gwuh
         kJv4NKs0VWzzT+8+8jREte7jin2qUclq5p+Cdst+z3qwyPxs0N9MTpKAZosX5Vng2WRp
         k6SQV3/xBWbhstzBfUEYYyFnCcl1M9MNLtv0La61BMv1C1Mi1oOnc/uV5/GCy1H7kvUP
         8yoRoOXnpfOuljRctgN4ZmArlo022gwIwo9/BygWSIF/sJaK9vCmCp5g++OQg5QWbxin
         amUifLJau6WDkJnW4oDl3K9AqrgogaXW6V3eVqUtf3Iv8/AIobkgGoieu+k0p15Veuu7
         nbbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GfeSpY1O8MwrGHI//U6PaOM8wrbbu+iKMbpJd9vFVOw=;
        fh=ZQbCoHEkJqh6lRbAfghJL4L9I7swkHNOsQYRReEXybA=;
        b=FJrX+WYg1wnvIRpEA5G11A6IIlIY1658fWKw4v3PIrq0WQ4NaVH8OY7kue6QI6OQKV
         BGOmzfUrkj+KX0OWHQPn0XatOiosn8DuyvDYW2UU6bcBojCU51s02QOHGD+HtNER0GCO
         rGp5gbm551i6k4Q+f5FwZ9NavHLofJTVsis+ak+3Ecc2C2+s4Q4BjFAdz1pYmOAQv8Yh
         JuJr+W8qiphHaTZfJmen3qNbT1STX4IXQq8IX60ColRb5kf2YwwueyWxxVum1oRJvxn7
         sbKRmHbRD+A75Ga4t5lCxNXiQg1fR2b7untqEmPAJkl0Ba/x4yMLXl8svj0PKz2i1z5M
         WQ2w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20251104.gappssmtp.com; s=20251104; t=1788195903; x=1788800703; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GfeSpY1O8MwrGHI//U6PaOM8wrbbu+iKMbpJd9vFVOw=;
        b=ln9WvdPmeBNhNUZ6fj/wYeV8PAUd+OOikVvvRh/TvI8UpVlrRIuAPwGrUwSiRT39VB
         1rgL4D8rGyjLT2v+wfQSogdk+ZLRNpcXC3k1R3fEX88fY7O+0BYypBFJCTvYBaUrZqkV
         H0/0xZzWQU3D6cflNxwxjDvWeLr8YbV6hUVP+oXCD7DHiC0tCbCVWe4r0egl41c8OCVF
         xY2bPi6aD1bUlT8l3HVf/hSbaYGz+b5ioXh8zrwieUge3TGl4C0dGJSggeu72Zpllnes
         MyCGPiBiJkSqjT9h7YuiygJNmbf12RMTjzRSpX5vLECVBkLDyCVnL62F6fXpx94itWwS
         dkVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788195903; x=1788800703;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GfeSpY1O8MwrGHI//U6PaOM8wrbbu+iKMbpJd9vFVOw=;
        b=CzB7Va+y2PuqzI70pBwVM2BT8n0q6FRRzBHYJTiMI+z/OoNZ0A+coSkzFoFw7pDBvq
         GhGFfmDw+A26mDJELTmmRP+7JtBB8++4zZ3yqHm05lhjWCVddWGIcoegXu8dCINa6b9l
         DvJm73dUr869toZpAMdfWz2IQQPc/1WvZvld8juhTXBGLR3LAuVU9oLOnvINFCu/3Ffn
         Na2T3jZagLsoLrIhEy9TUI4HZHjkSnuvFjofnF23vq2axCW/V5TATfXXFso3bNGEDhZt
         XajWRFeZUSKruebv2Xpr5XWIlF/lIMQDip5l0Dx87jTbfiMs39hGks+BPIUGxNCEDH16
         A+Qg==
X-Forwarded-Encrypted: i=1; AKwUvBzK3t83a55fOlhqZxajHTH3S/GpXWTu3QKUwN6gdVIGD8OBE2WoiHoLPKGcJVed2MJsN+Aduxdh+zFFOig=@vger.kernel.org
X-Gm-Message-State: AFuF++lmx8ZlbiLGTAxG0+MiOEPaJpEbduu82TqUb5CstAipS0KQTEG9
	3kS14PVcmXRaw+TGK90r7ruh0b6NJKydFPrFD/0XIr8BVlYUcdS6SrJztIujFwLQ5zDgmWyy+O0
	+o1JUSgflA8gzCYWHBMJ6MxQ5ALKPJrBfRJZcg3oV
X-Gm-Gg: AYBFou3PV4aYGiSWgvLN5zI8frbAKfFfYNC3USHqcDvD6HXTLNG5YU79VcQ7Or4RC42
	ro47rEhi0rBL+7dCWB+TxwABUu4fAl49J9GUBSKhPVQOajjWP0iIEtKkBNkyUtc2Io2bXgPYXJ9
	6IchOjGrPA5vqC3pY/0191ujsxGTawus/iUQIYjWRhrdM5GrZLg/Y7BqG4sGht8brdzNye2mHaM
	vQPWz1nCBQQzR06pjKvah4NPf+a78YjtsCkWNDU3TbCe/VnXd68dBvF6lrHlpcSTp4jGRb+WlId
	qs9LWhX2705bp0v/HYa5jWPmy/7E8jej11LmyWVhuU5MCiNimtxsn+ffLSExvwBpXRtlrJo700X
	A0HKWU1R8bNOhCxjPDbmM2yqPlx6LAWSNR4hEFsk8eoGvmA==
X-Received: by 2002:a05:690e:4512:20b0:66f:8594:b85e with SMTP id
 956f58d0204a3-66f8594c483mr815185d50.2.1788195903415; Mon, 31 Aug 2026
 10:05:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826163004.3365-1-mike@fireburn.co.uk> <20260826163004.3365-3-mike@fireburn.co.uk>
 <20260827030352.GB2327@sol>
In-Reply-To: <20260827030352.GB2327@sol>
From: Mike Lothian <mike@fireburn.co.uk>
Date: Mon, 31 Aug 2026 18:04:51 +0100
X-Gm-Features: AcwNN1XRUTonc9UtClpJ99JQyGyLSWDpm68a2GF558801nidk82gsfB0bRqsHB0
Message-ID: <CAHbf0-G7aHw5HMCMfpABnFUpvLHz5R6d7zmyite9xAqzMXJGvQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] rust: crypto: add synchronous RSA akcipher support
To: ebiggers@kernel.org, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, Jason@zx2c4.com, 
	ardb@kernel.org, ojeda@kernel.org, boqun@kernel.org, gary@garyguo.net, 
	bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org, 
	aliceryhl@google.com, tmgross@umich.edu, dakr@kernel.org, 
	daniel.almeida@collabora.com, tamird@kernel.org, acourbot@nvidia.com, 
	work@onurozkan.dev, lyude@redhat.com, gregkh@linuxfoundation.org, 
	lina+kernel@asahilina.net, bqe@google.com, ljs@kernel.org, 
	joelagnelf@nvidia.com, ynorov@nvidia.com, david@davidgow.net, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Aug 2026, Eric Biggers wrote:
> > +config RUST_CRYPTO_LIB_AES
> This is being added in the wrong patch.
[...]
> Likewise.

Sorry I'll get that sorted

> As I've been commenting on other of these bindings patches, it also
> doesn't really make sense to have the kconfig symbol be in lib/ but then
> have the actual code be in rust/. They should be in the same place.

That one isn't specific to these two patches, so I'm following Miguel's
reply on it and I'll go with whatever comes out.

> If you need RSA, then please just create an API for RSA specifically.
> The crypto_akcipher abstraction has never worked well, due to
> differences between the algorithms and various other reasons.

Will do. The generic akcipher wrapper goes and v4 has an RSA-only API.

The only operation I need is RSAES-OAEP-SHA256 public-key encryption
with a caller-supplied seed. The seed is explicit so the driver can pass
the kernel CSPRNG while the tests pass published deterministic vectors.
Would you rather that was a narrow Rust wrapper over the existing rsa
transform, or something in lib/crypto?

> > +__rust_helper void rust_helper_memzero_explicit(void *s, size_t count)
> Isn't there a standard Rust solution for this?
[...]
> > +__rust_helper void rust_helper_aes_enckey_zero(struct aes_enckey *key)
> Similarly, isn't there a standard Rust solution to zeroize memory?

There isn't one in the Rust standard library, so the memzero_explicit
forwarder stays -- Miguel covered that in his reply.

The aes_enckey_zero one was just wrong: it could have called the
memzero_explicit helper instead of existing at all. Miguel said the
same. v4 has one safe zeroize() in the kernel crate, used by Secret and
Aes128, and that helper is gone.

Mike


On Thu, 27 Aug 2026 at 04:05, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Aug 26, 2026 at 05:29:49PM +0100, Mike Lothian wrote:
> > +config RUST_CRYPTO_LIB_AES
> > +     bool
> > +     depends on RUST
> > +     select CRYPTO_LIB_AES
> > +     select CRYPTO_LIB_AES_CBC_MACS
> > +     help
> > +       Enable the Rust bindings for the synchronous AES library functions.
> > +       The selected C libraries are built into the kernel because Rust
> > +       abstractions are part of the built-in kernel crate.
>
> This is being added in the wrong patch.
>
> >  config CRYPTO_LIB_AESGCM
> >       tristate
> >       select CRYPTO_LIB_AES
> > @@ -216,6 +226,15 @@ config CRYPTO_LIB_SHA256
> >         Select this if your module uses any of these functions from
> >         <crypto/sha2.h>.
> >
> > +config RUST_CRYPTO_LIB_SHA256
> > +     bool
> > +     depends on RUST
> > +     select CRYPTO_LIB_SHA256
> > +     help
> > +       Enable the Rust bindings for the synchronous SHA-256 and HMAC-SHA256
> > +       library functions. The selected C library is built into the kernel
> > +       because Rust abstractions are part of the built-in kernel crate.
>
> Likewise.
>
> As I've been commenting on other of these bindings patches, it also
> doesn't really make sense to have the kconfig symbol be in lib/ but then
> have the actual code be in rust/.  They should be in the same place.
>
> > +__rust_helper void rust_helper_memzero_explicit(void *s, size_t count)
> > +{
> > +     memzero_explicit(s, count);
> > +}
>
> Isn't there a standard Rust solution for this?
>
> > +#ifdef CONFIG_RUST_CRYPTO_AKCIPHER
> > +__rust_helper void rust_helper_crypto_free_akcipher(struct crypto_akcipher *tfm)
> > +{
> > +     crypto_free_akcipher(tfm);
> > +}
>
> If you need RSA, then please just create an API for RSA specifically.
> The crypto_akcipher abstraction has never worked well, due to
> differences between the algorithms and various other reasons.
>
> > +__rust_helper void rust_helper_aes_enckey_zero(struct aes_enckey *key)
> > +{
> > +     memzero_explicit(key, sizeof(*key));
> > +}
>
> Similarly, isn't there a standard Rust solution to zeroize memory?
>
> - Eric
