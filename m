Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89872E9EC0
	for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751040673; cv=none; b=kD5p7zJu9GjitxTM7ea23dMj+uwySC5mu7Hat74Xe6tfrh43TvgwDomMfS3+TYAxEXIN+fWkw4arxkgPo79rpBKn54v4+5aLs4G0LF3xl5P1ji9Ii49oFRbRpol9Pa9bF82nYEdUGCuzvYYB1m7yEhH7bTMK70pZSQ7HFZ7OgQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751040673; c=relaxed/simple;
	bh=KEdowIP8nmfmWkiMsYe2bhkJS/bTsL8oOIQrNQ8uk1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ME3+gfyHsdHamB8KwyszBwOY2Fuk9NONC49sCLSoxmbqwcvKupbXg/Z+hEnKu7BIhg7NmfKFMivD422+KO0/LuiIFC2Fj3AKqCKK1mfP9QasSfvDQv4BE3wC3tN732q4w6YdrZRd8f+fnAzmHRe+HBqqlOAMMTfxGBMBr54E7tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ENV9/WvX; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ENV9/WvX"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3df2fa612c4so280695ab.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Jun 2025 09:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751040668; x=1751645468; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcIH4pjrPEib5s/3B0d1zkZ9Z/0XhgYXm5HComwjvMU=;
        b=ENV9/WvXqhlCqDzU8pZtFwPIswzwn2FNh9zmda6IepWDui/ZdLS1F6uAZfxTidxmsQ
         YzJdB92nj8gJMA400rcr+ZcCzppMyFVEkrBSwf4EvJ7a2mEcrbVKqPl502sHFQQB5KKz
         pG9Z/kQ+ykI/VjeqBJuqM7vuCzcts7OEQgk8YE8pu71FRm/1lG3ZS9ViorAeBPRwWG6B
         AHwIS8O1u7EmeP3tJJ7WNvpiJvhH2BSFns+2IXttACHOdlI1i55233CRXvkt/J155Noj
         HfArQ7R71rPklTiv9qKvEorzbfOzpPYnzvc7PX5YL68P8JfxyfyvL0MX5oYLpggVqe4R
         thBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751040668; x=1751645468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TcIH4pjrPEib5s/3B0d1zkZ9Z/0XhgYXm5HComwjvMU=;
        b=FgrkfcA346O6nSklgTkZ8SA46qfRzGD2b+yMm/VWQrucM2f+/a5nx27tOVzU54zrNA
         KguVvhYr45DwQ/BNPxnvonv531Mw5bNqCOn90yOEecgrQXwZIzVGE5cq1sAgTrSpOq2t
         ZFaZgiGvgLQZSh/gEAHciTabDdXsLWl+XVWqQEQhk3stP9sLC5xA9nsiaJWdedctWVY3
         CJ1uAEX8oSRBGheLyuaBG5kn6WPvhnyd128n57FFTP9COi8MWWGNEO/fWwhfxAeLRlv9
         boAYsbNw8FZcP5NcnpzsTEXvuVBJKl0Aj52Zk4Xjn6PQVMwjEmxThGzkxUqvWrKS4ZVt
         mSbg==
X-Forwarded-Encrypted: i=1; AJvYcCWZBKTpyQZWqxn0BC7UsmMKVqO3Y/Gz+J7qDTsY9PQa4M59tjTxptKuHUKxHy6aeDTdzhjIw+xDgNOtkdI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQAyOCuVZV6LM/Iy1Kqaxuljqmry3yBOa/GkpVI5NprMTQTcOn
	uWFeiIu9em5NF8vdvnYoxPMX7QB2X8c4NHOD8lYwzL73sXofiOhxLUqZrP4NR0qCiZJdtpET1nC
	jKGCcd4QYyM8XmUxYpLe606RCO4wb2821x+UvtDy3
X-Gm-Gg: ASbGncunNxJnO0HjvtNZo8MgMgVMHhVZvlYkYz1WcE6IN3egUWadZtjvajP1mEcKWlc
	obBK8DTLLZ6SzUvBUGkUQnFMCrKr5n2gxH6+9JjXiur+m+yw7FK9091WrZTdM8wADBpr3O+jiyL
	JeP5aBkPQNl9ppPeAwvTuk10W2vaQOqib+lZvgUjra
X-Google-Smtp-Source: AGHT+IFg6e4a6YEfWbui8xwO9yD9rLdV6FsjD0j7apl8hIGvv47L9p86pecdsvAU0q7wRaa8l3NwHfyIyMgL9Gnaxno=
X-Received: by 2002:a17:903:2ca:b0:237:e45b:4f45 with SMTP id
 d9443c01a7336-23ae4db11d0mr267905ad.1.1751040668255; Fri, 27 Jun 2025
 09:11:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611033150.396172-2-zhihang.shao.iscas@gmail.com>
 <20250624035057.GD7127@sol> <48de9a74-58e8-49c2-8d8a-fa9c71bf0092@cryptogams.org>
 <20250625035446.GC8962@sol> <CABCJKudbdWThfL71L-ccCpCeVZBW7Yhf3JXo9FvaPboRVaXOyg@mail.gmail.com>
 <fa13aa9c-fd72-4aa3-98bc-becaf68a5469@cryptogams.org>
In-Reply-To: <fa13aa9c-fd72-4aa3-98bc-becaf68a5469@cryptogams.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 27 Jun 2025 09:10:30 -0700
X-Gm-Features: Ac12FXznZZZX9Qm6z0k4xbwNRAF0CTs4EHV5XI2tFLn6EJECgfKuduEu2PnIjzI
Message-ID: <CABCJKucHNWz6J9vvDvKh_Je8eQTJO_1r0f6jsDTsDmfaxdBygg@mail.gmail.com>
Subject: Re: [PATCH v4] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS implementation
To: Andy Polyakov <appro@cryptogams.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Zhihang Shao <zhihang.shao.iscas@gmail.com>, 
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org, 
	herbert@gondor.apana.org.au, paul.walmsley@sifive.com, alex@ghiti.fr, 
	zhang.lyra@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2025 at 2:07=E2=80=AFAM Andy Polyakov <appro@cryptogams.org=
> wrote:
>
> > we would need
> > to use SYM_TYPED_FUNC_START to emit CFI type information for them.
>
> I'm confused. My understanding is that SYM_TYPED_FUNC_START is about
> clang -fsanitize=3Dkcfi, which is a different mechanism. Well, you might
> be referring to future developments...

CONFIG_CFI_CLANG is supported in the kernel right now, which is why we
need to make sure indirect call targets in assembly code are properly
annotated.

Like I said, if RISC-V gains kernel-mode Zicfilp support later, I
would expect the SYM_TYPED_FUNC_START macro to be overridden to
include the lpad instruction as well, similarly to other architectures
that already support landing pad instructions. In either case, instead
of including raw lpad instructions in the code, it should be up to the
kernel to decide if landing pads (or other CFI annotations) are needed
for the function.

> > Also, if the kernel decides to use type-based landing pad labels for
> > finer-grained CFI, "lpad 0" isn't going to work anyway.
>
> It would, it simply won't be fine-graned.

Sorry for not being clear. If the kernel implements a fine-grained
Zicfilp scheme, we wouldn't want universal indirect call targets (i.e.
lpad 0) anywhere in the code. And even if we implement coarse-grained
Zicfilp, we would only want landing pads in functions where they're
needed to minimize the number of call targets.

> > Perhaps it
> > would make sense to just drop the lpad instruction in kernel builds
> > for now to avoid confusion?
>
> Let's say I go for
>
> #ifdef __KERNEL__
> SYM_TYPED_FUNC_START(poly1305_init, ...)
> #else
> .globl  poly1305_init
> .type   poly1305_init,\@function
> poly1305_init:
> # ifdef __riscv_zicfilp
>         lpad    0
> # endif
> #endif
>
> Would it be sufficient to #include <linux/cfi_types.h>?

Yes, but this requires the function to be indirectly called, because
with CFI_CLANG the compiler only emits CFI type information for
functions that are address-taken in C. If, like Eric suggested, these
functions are not currently indirectly called, I would simply leave
out the lpad instructions for kernel builds and worry about
kernel-mode CFI annotations when they're actually needed:

# if defined(__riscv_zicfilp) && !defined(__KERNEL__)
        lpad    0
# endif

Sami
