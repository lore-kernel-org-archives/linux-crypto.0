Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9314121E092
	for <linux-crypto@vger.kernel.org>; Thu, 29 May 2025 23:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748562896; cv=none; b=U+ylJhF/Quc3bd37m17vrnM7rHJBv2Oc0TRJML8jM4PPmQBDDraMVf06e7GfYZkdtpYHbT9a5EerlTo1pbMFubu8tRgE/4gH52c8VpaZXsYB2kogLEDpuuxtd2XHy69jsJaFWbsrwP21NmKTGYRG5eE1ZVM42M3xs7ItL4+Omwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748562896; c=relaxed/simple;
	bh=mQ2X3C83MrQ+ifFd0cXmKRdvIysb8KwRrZHJnS3dFHw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K+fM9ttPeSb1aacVKgqLkMJJy/EWJiJNefWZHoeF8bAVhX+zh0NmjJ5hdyvXt4ZoyjESWm3P9LilIrkL9ajI3rXtBzqvYk62CPdsGtg05eGt1Qmn1yIrQe3pPrtZDBL/3hZCdVJhu/n3alUeK57rRtkXwCq3AboiN/lC6GoLJjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XQs+StU8; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XQs+StU8"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-acae7e7587dso216075166b.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 May 2025 16:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1748562892; x=1749167692; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VCpgeKXbWpRtz3XeS2MBk7nO0oA3f7brSdzLdQTvzhc=;
        b=XQs+StU8IF5aBXMDzuyK2yS1d/Bk5+iNxCmULKpVIg1HW0cD7a0hgFJODEGSYiXueZ
         PPJh02pqRliwbkAT0TNEUGYmhfGFxPKPvdritgJoP0Wx/dYK0UfNeW+Jwq2cxbdvplPH
         2CAc8FG4lQHQWHxj70do4tMGYmODmabgmKXkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748562892; x=1749167692;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VCpgeKXbWpRtz3XeS2MBk7nO0oA3f7brSdzLdQTvzhc=;
        b=ZX/T/4ak44Bek+cmSV3+1ipM2BLu2GjLty7Z8vEuzKeGrXLZBldqo18F32eFyPJ34y
         JDLSRYuvxJ7bjr4sjPBgakj/gQ7ws6bxaXnC+d2IjWIZwoXfcrk/NO0Z2NpnR6eOGHLK
         JutcI+ciw3Z8ZGPgKqkRlxQdsTI2S1NK75VkcTafIsSxefgV0MzVrGRBupZO0JLgpnlD
         iNK+RgTOuNLhEJnv/Z0bj7WXMBF6d0xNI5QXoA0CDm3j/tf+VfVuXoKGjS4/9O37ii9l
         ZEhi0Gs1/fF+gMbKaFJ/6EZ128jFzEZN0R3fck8CpXQo9ewDtGKUGvJErMHr3cPtsweY
         CVXg==
X-Forwarded-Encrypted: i=1; AJvYcCVbko4adtUYuyRImQeyvQCbUepEjoctyvrSAtvyAuvEXipSlMFono4ejZWiaVZvR808q6iOQCvYCvv7e1U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEFss9w0KX8iGfXSZoXCPM7N0tpGGlOszPVk2mAPCvX7m8MNTj
	oKCWZ52n37FOKqCUXZL5zda61bPZA2uyKSfGASF2QY+IX2Jwei954xOVoNJDOCa2zlInUeWLq6p
	WDGcpXv8=
X-Gm-Gg: ASbGnct+EEyoFEcmQWxlRN7xImp65gfU/yukyaxu4/cmcb/oCGUzG3IR+FIVYVkhEcm
	NxOQa2SxZvzDgGS5DSzic20ghPNKB1B4kOFLetJnxYduCSKpd5mvtZTJ7BR0YmfHKy/1GBoledG
	UiRXGhPzw6+JPkk+VNOuxzoIq7OWk37asifYowSLNkMjscBYdaa0v/7GgRYG/TIBIO5y5jS9oPQ
	cLltvKccxup5qqgUqlERCGY2Kj2EF/kDSrBuHEgLWfr567MYq5LaiXJT+irkFx5gt2JLDxyzBCh
	45FVfFW0+UZI39YTAFpTLxDLYkz+5+ZAt7DYojPNY68uOFsNBoO9b0/G5+FNH8lvvXg8+nnbADt
	Sm8htRROr8l3vhdG3VH7JtpYbEl1HjMVthxxK
X-Google-Smtp-Source: AGHT+IFiREpfW3n98aSFDZxiH5F3LrNrlIDf9AAQ6jc6i8ET3JTsQB2zNBXPHzNRr3R4tZPuEaTDlA==
X-Received: by 2002:a17:906:7954:b0:ad5:d0e:9605 with SMTP id a640c23a62f3a-adb3229f18bmr117022166b.32.1748562892138;
        Thu, 29 May 2025 16:54:52 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad6ac07sm225999366b.177.2025.05.29.16.54.51
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 May 2025 16:54:51 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6049431b409so2425098a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 29 May 2025 16:54:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXG4DqhVM2Qrs5UIggq3xnNmJ6GFZfgzNFuKhKJ5Dpx4TnVEiYuXVktgK/poaBfEsv0X+qqMRmjuXGWY7s=@vger.kernel.org
X-Received: by 2002:a05:6402:35c6:b0:5f8:357e:bb1 with SMTP id
 4fb4d7f45d1cf-6056e1597eamr926476a12.22.1748562890813; Thu, 29 May 2025
 16:54:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428170040.423825-1-ebiggers@kernel.org> <20250428170040.423825-9-ebiggers@kernel.org>
 <20250529110526.6d2959a9.alex.williamson@redhat.com> <20250529173702.GA3840196@google.com>
 <CAHk-=whCp-nMWyLxAot4e6yVMCGANTUCWErGfvmwqNkEfTQ=Sw@mail.gmail.com> <20250529211639.GD23614@sol>
In-Reply-To: <20250529211639.GD23614@sol>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 May 2025 16:54:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh+H-9649NHK5cayNKn0pmReH41rvG6hWee+oposb3EUg@mail.gmail.com>
X-Gm-Features: AX0GCFuuQZJkBnHy-mtAufGSUKbxBrKrMtOhVAT8ZxGCHwWeq3lbFPW0g13cPtE
Message-ID: <CAHk-=wh+H-9649NHK5cayNKn0pmReH41rvG6hWee+oposb3EUg@mail.gmail.com>
Subject: Re: [PATCH v4 08/13] crypto: s390/sha256 - implement library instead
 of shash
To: Eric Biggers <ebiggers@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	sparclinux@vger.kernel.org, linux-s390@vger.kernel.org, x86@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 May 2025 at 14:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> So using crc32c() + ext4 + x86 as an example (but SHA-256 would be very
> similar), the current behavior is that ext4.ko depends on the crc32c_arch()
> symbol.

Yes, I think that's a good example.

I think it's an example of something that "works", but it certainly is
a bit hacky.

Wouldn't it be nicer if just plain "crc32c()" did the right thing,
instead of users having to do strange hacks just to get the optimized
version that they are looking for?

> Does any of the infrastructure to handle "this symbol is in multiple modules and
> they must be loaded in this particular order" actually exist, though?

Hmm. I was sure we already did that for other things, but looking
around, I'm not finding any cases.

Or rather, I _am_ finding cases where we export the same symbol from
different code, but all the ones I found were being careful to not be
active at the same time.

I really thought we had cases where depending on which module you
loaded you got different implementations, but it looks like it either
was some historical thing that no longer exists - or that I need to go
take my meds.

> IMO this sounds questionable compared to just using static keys and/or branches,
> which we'd need anyway to support the non-modular case.

I really wish the non-modular case used static calls, not static keys
like it does now.

In fact, that should work even for modular users.

Of course, not all architectures actually do the optimized thing, and
the generic fallback uses indirect calls through a function pointer,
but hey, if an architecture didn't bother with the rewriting code that
is fixable - if the architecture maintainer cares.

(On some architectures, indirect calls are not noticeably slower than
direct calls - because you have to load the address from some global
pointer area anyway - so not having the rewriting can be a "we don't
need it" thing)

               Linus
