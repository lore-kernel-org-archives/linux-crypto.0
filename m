Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70681993BE
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 09:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724752729; cv=none; b=d8d6PKA7iwjG6fOyNuBL63l8U0KrvpXrbm+W3GU1B/2WjPF9TIAtSd5CL1pLutU9Lt/DekiouRxu0fHW7nSTch29IgYI/h2iy5TqfY92Mv+pL42fHojDZFYBq111VBevQ4V/VfLPQAmFWYffP3oKOFgndxlKx6kZ6JwutkZ2bRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724752729; c=relaxed/simple;
	bh=6tLmOx27L2ZAfG3h/+tuLPWzg+EwtGxY7CoKyhP4LZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i0O2yxVGZtmzwCS9ZBbxE7Qoa/fK+Px+riDvdOgFGe0wwc7y8VFSCCAWIEPcjcGpGxuWp3n/J0nIPw27dDvpTlWSnV7tKUSwpA9brvl1q0co3a2rwxurgL9hYkJWrOYlppmjsTbnItLpP1oD0n5HBjA9MuVJ0Zr3CDRBRH2PqL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvnOXmfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvnOXmfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51005C8B7A9
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 09:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724752729;
	bh=6tLmOx27L2ZAfG3h/+tuLPWzg+EwtGxY7CoKyhP4LZ0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HvnOXmfrNZ+h4h66peVqpDWayzo1RjkgDEegyZxQ5D3U11mnylwn6dCENY/f0lcVX
	 WlTOeK9oJQYo0rV3yjqLRPghu5C1PgHClH3H67gQPv+yNecAX73oBp0qtwyG9IdUjd
	 jzsPxLgdESahNMqgYKp4fBnXbkQsMIw8IuOVUyWKIQiLiE7UIly5ql4/9gPipa4A+C
	 mhIcbL7fk7sZs9IGIndceyVD3Z7QgGkHM6Tqrio3SvrEP+rGyZcttuQzixRxGLXl6U
	 J/p6Qr0ha1JuKecWIktZSllYT26I5RchfZ9Su5P8ftVnOMYfVIb/4mek6Yi96qM+MA
	 8tS/xlb1tYElg==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52f01b8738dso3914880e87.1
        for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 02:58:49 -0700 (PDT)
X-Gm-Message-State: AOJu0YyDm+T8lpsGVel92XGvuLrPh9bG+zGwTdFIIAtuU7a4ltOcRNPW
	gjPS37+Su3L7DFN4Vpjeag9p/18JJeh2VO4JkL+5sEzw4yizZ/IRl0qc6u59TA8dmhUT6pHuGzs
	QZJ3X0wdQughj4h4ZuZLUV5N1BNU=
X-Google-Smtp-Source: AGHT+IHemYbo+JblYktIhOFQus/bcjAHNscgZnKdvS6qmuCOjRLDNJgM+oLmlx21Ab/QUAiUMaxrLJDLjjj8a7puPX4=
X-Received: by 2002:a05:6512:3e08:b0:52c:825e:3b1c with SMTP id
 2adb3069b0e04-53438783f89mr8403331e87.26.1724752727618; Tue, 27 Aug 2024
 02:58:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809231149.222482-1-ebiggers@kernel.org>
In-Reply-To: <20240809231149.222482-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 27 Aug 2024 11:58:36 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHdd268uY_06XYKB5QxjS2TVJryM7H=5bZOUVXV738K+A@mail.gmail.com>
Message-ID: <CAMj1kXHdd268uY_06XYKB5QxjS2TVJryM7H=5bZOUVXV738K+A@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/aes-neonbs - go back to using aes-arm directly
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Russell King <linux@armlinux.org.uk>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 10 Aug 2024 at 01:13, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> In aes-neonbs, instead of going through the crypto API for the parts
> that the bit-sliced AES code doesn't handle, namely AES-CBC encryption
> and single-block AES, just call the ARM scalar AES cipher directly.
>
> This basically goes back to the original approach that was used before
> commit b56f5cbc7e08 ("crypto: arm/aes-neonbs - resolve fallback cipher
> at runtime").  Calling the ARM scalar AES cipher directly is faster,
> simpler, and avoids any chance of bugs specific to the use of fallback
> ciphers such as module loading deadlocks which have happened twice.  The
> deadlocks turned out to be fixable in other ways, but there's no need to
> rely on anything so fragile in the first place.
>
> The rationale for the above-mentioned commit was to allow people to
> choose to use a time-invariant AES implementation for the fallback
> cipher.  There are a couple problems with that rationale, though:
>
> - In practice the ARM scalar AES cipher (aes-arm) was used anyway, since
>   it has a higher priority than aes-fixed-time.  Users *could* go out of
>   their way to disable or blacklist aes-arm, or to lower its priority
>   using NETLINK_CRYPTO, but very few users customize the crypto API to
>   this extent.  Systems with the ARMv8 Crypto Extensions used aes-ce,
>   but the bit-sliced algorithms are irrelevant on such systems anyway.
>
> - Since commit 913a3aa07d16 ("crypto: arm/aes - add some hardening
>   against cache-timing attacks"), the ARM scalar AES cipher is partially
>   hardened against cache-timing attacks.  It actually works like
>   aes-fixed-time, in that it disables interrupts and prefetches its
>   lookup table.  It does use a larger table than aes-fixed-time, but
>   even so, it is not clear that aes-fixed-time is meaningfully more
>   time-invariant than aes-arm.  And of course, the real solution for
>   time-invariant AES is to use a CPU that supports AES instructions.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

I know that this has been queued up already, but for the record:

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
