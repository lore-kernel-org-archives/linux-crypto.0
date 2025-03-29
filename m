Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C101D5145
	for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 17:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743270045; cv=none; b=SSRn+Klo+FxAc7jRiT6+pyoclWnVZeadWNkhJ66LoU9QEDaM0H9DKms74aozebf+ctvPuMEzLi1fOTByyGs2QBHEATbjWGDxIICARWBYmJ3j5DaglPBPJRbKGr+sABDZi1OvYmxaKjVTPuBXl+75OlReJq6NhVUbrMi/jA9P2k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743270045; c=relaxed/simple;
	bh=cADv9mH60jdUQLSz4UnQc60dv6pjuR24zJfR7jDKp84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fZOT2bKRGynRKtu+zzs6kOXAFljbOXRQFwApbWW4eQFTDt/kJHNpGgk87HsDc+ONGw/DqWrcqBKdmK9Is8bSWp5G90uPQFlQM8KY0c2b1aKTLopten8Nil9gztDWunj7lVtlbt/Gih0+gI9GuxTn1ikrqAk30c9MWqPajJGHtc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ut8df5gR; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ut8df5gR"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-abbb12bea54so618708766b.0
        for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 10:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1743270041; x=1743874841; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X0UdghMQC3GlspzDKxnOCJK/ZrpjHmGsFb9PQQYuWpg=;
        b=Ut8df5gRyvnDDoq934QVuhhcmNpoJKtJvliWC6ClQl95ZDxq3ABwz0GfRdBZhcOgXS
         gFUEckeV9Z0vjmluSYdTsLDRQE6pNOCUZaF1kjQhizHijG7W6YFqGad7LXGlnrQtWwJ2
         br4t/NMxudEmOUhQSolaT6I0WvETzQpRWl+/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743270041; x=1743874841;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X0UdghMQC3GlspzDKxnOCJK/ZrpjHmGsFb9PQQYuWpg=;
        b=a63GjGMY6ArW9Sgan/5OySDuod1u/M2ZMA3sae7NK2mZDxUNsJ1C9e1SnhZSgXLPHd
         aYFC3VE/2oxboNkpVhazCbV2iHZdXgepIEwO8AeEW8DEbA5pUJuWpTRqHlfoYDaG9Mxk
         ip0zCXelK2pXI/BbdUcG1pWdoLrmyQiwJ9xPJBMq0Yd5eNaqWpbhxWvJUKTJesAGr/0s
         T3n6HMLI94oD3icIUsY3DoFOFYCn9x88ARYeuC+vswrV0QZUdvX63P9oR1+NeAJe9qyv
         JwVmJnmOj5C0g6i6QIF67Ab2H3csTtrpyquwijlZxqxw99b3eZjbmHzguEj1e5xR8but
         Ezrw==
X-Forwarded-Encrypted: i=1; AJvYcCVnPDn0o69Lq2/v/K02nT6K1gv71QAmtzsGl30zHXr+I11+zcZ/CZ4dN9q6iVdq1YchTMcoXqW/gOFg3qo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOjXz9uZI32lKZ3VbcYpdlzbWMYpGA0ZYVpP4vdo83uCA4WkMD
	1t/H1algn0sqvfkh+GXhT4ien8FmroE1rSdBf9KFlMCGYT833W8VDxjpZQg+96TryWQhExxbDbS
	cwQM=
X-Gm-Gg: ASbGnctLA0jLfdy5bAfj1d8SR5dtOtO87Pb5xgV5P+FM96UXrsXccygUf1rSLCoBB2V
	8IB0Dm8AUqghlIVaw0f36sj4DTu/ZktabDqYdO+kgG9c3v9H2xlp4teXNAFJV3DL3hsq6omu4Lb
	HEm/K876w4dxpa2IUhqIdzcT4eyfOCZnOTHbtkjvyz1eq0CawadIdYj38Dmk6twQbSpu/sXCuEU
	yeXLmBo9UuGscBQx1uXqEYXm07l/SNLSTmYa8XOD8Tci1hkXZwFLUVj6ZXk1g2R3CMrX5HJhLKs
	k202DD9uaPHSZ0vQDGgKZMKkE10FZcYLGmG30qn0xm2rECrqHgpcnTePcBas0+UlCqpgDAffykk
	WnO9qCKbCO88rljgMOfs=
X-Google-Smtp-Source: AGHT+IHjnOGYeZQLU7l1/gHVRVLGKx1ChEjW89VKyaeZ4V6OjLjWwQvoUO+5YrOJ16K3zcdVO82QBg==
X-Received: by 2002:a17:907:3f12:b0:ac6:b639:5a1a with SMTP id a640c23a62f3a-ac738b0ba28mr319975866b.28.1743270041146;
        Sat, 29 Mar 2025 10:40:41 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71961f8cfsm359200266b.123.2025.03.29.10.40.40
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Mar 2025 10:40:40 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac289147833so555650266b.2
        for <linux-crypto@vger.kernel.org>; Sat, 29 Mar 2025 10:40:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWGreGb3fCk4V9i/MBENjmNVPh94GqSYkGWPs1TImQxYxV7e3DtaMFlmSLltGi7yFLc9bSzEYvRROYdjSE=@vger.kernel.org
X-Received: by 2002:a17:907:7f87:b0:ac3:f0b7:6ad3 with SMTP id
 a640c23a62f3a-ac738c1b69fmr310358366b.40.1743270039866; Sat, 29 Mar 2025
 10:40:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZOxnTFhchkTvKpZV@gondor.apana.org.au> <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au> <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au> <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au> <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au> <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au> <20250325152541.GA1661@sol.localdomain>
In-Reply-To: <20250325152541.GA1661@sol.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 29 Mar 2025 10:40:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=whoeJQqyn73_CQVVhMXjb7-C_atv2m6s_Ssw7Ln9KfpTg@mail.gmail.com>
X-Gm-Features: AQ5f1JozuZltVVXOxl16yiJ5dITk50jYErxouJq_h3URJNHiBCiZvEEX-32vNbc
Message-ID: <CAHk-=whoeJQqyn73_CQVVhMXjb7-C_atv2m6s_Ssw7Ln9KfpTg@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.15
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Mar 2025 at 08:25, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Each hash request can also contain an entire scatterlist.  It's overkill for
> what is actually needed for multibuffer hashing, which is a simple API that
> hashes two buffers specified by virtual address.  Herbert's API creates lots of
> unnecessary edge cases, most of which lack any testing.

Isn't that the whole *point* of the generic crypto layer?

Honestly, I think anybody who cares about modern CPU-based crypto
should do what wireguard did: stop using the generic crypto layer,
because it's fundamentally designed for odd async hardware in strange
*legacy* models, and the whole basic design is around the indirection
that allows different crypto engines.

Because that's the *point* of that code. I mean, a large part of the
*design* of it is centered around having external crypto engines. And
the thing you worry about is pretty much the opposite of that.

So if what you want is just fast modern crypto on the CPU, the generic
interfaces are just odd and complicated.

Yes, they get less complicated if you limit yourself to the
synchronous interfaces - which is, as you point out - why most people
do exactly that.

Put another way: I don't disagree with you, but at the same time my
reaction is that the generic crypto layer does what it has always
done.

I get the feeling that you are arguing for avoiding the overheads and
abstractions, and I'm not disagreeing. But overheads and abstractions
is what that crypto layer is *for*.

I mean, you can do

        tfm = crypto_alloc_shash("crc32c", 0, 0);

and jump through the crazy hoops with the indirection of going through
that tfm ("transformation object") that allocates a lot of extra info
and works with other things. And it's designed to work with various
non-CPU addresses etc.

Or you can just do

        crc = crc32c(crc, virt, cur_len);

and you're done - at the cost of only working with regular virtually
mapped addresses. Your choice.

So I think you want to do the wireguard thing, and use the fixed and
simple cases.

Yes, those interfaces only exist for a subset of things, but I think
that subset of things is (a) the relevant subset and (b) the ones
you'd do the whole parallel execution for anyway (afaik you did
sha256).

              Linus
