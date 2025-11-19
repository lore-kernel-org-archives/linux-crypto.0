Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BEF1DF980
	for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 16:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763569401; cv=none; b=PDnEvXIu20OY7djK5RuhmI1jmrD79LkwYOFTmxHSvwNrUdtFwpS67LH2BIczx77S8ePIJ3OhYmZzMkQE8F97q2jA6aPbDNF9Vco39tq/vF8Q7MwJdKWix1CxBsNoRvDH4oM16paOGq5ISFnTCo4girWahdTGmZ7SvbEF2qA06Po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763569401; c=relaxed/simple;
	bh=UKD3Ih/vdXts1YAdrLZqIWg/yDwIkFf0XJQHTJ83sEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aiZTtzvCI7FHMkAK2t5fQJOToCiO+m7VDe3rGT9fT8v0616Onkc2g2Q9oRKAvCC8RQf+KDZewLXhoW+RqCgZkfRjBmzKaJKNkq1MP2GsZrvZ1nfO2TxLgKYzcvaXa6FgkarxiuMJcFxOhMPzexI7u3vkYCiFI+rzyxCPAEUs6GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YIGVyaEu; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YIGVyaEu"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso2377064a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 08:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763569397; x=1764174197; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2SE94M0Eu3i3U+0dCVoKdz4qQM+FPRKFn1N8b2gaTM=;
        b=YIGVyaEuwe5zgDLaH1+3qdmdUjtvmSjcl8+iLusegRw2/9iMu7T9+Jjc8EgYrMUWeU
         ISOx0kKsUL/ILEMFlte3tN+PeEHKIei6G8poUqeQ5n+vMFW4XfBO056yy322bSr3VPVF
         QNi3xVMrKY7bSrDocXl6wrCFdCilG4OGlMdKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763569397; x=1764174197;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2SE94M0Eu3i3U+0dCVoKdz4qQM+FPRKFn1N8b2gaTM=;
        b=npIXfCOjpA/s/Z0SeVcg7L7FUpqqBhgfCtvlI4g6kFVOIQwQqD9ahxN+y8g0dLK11V
         P6DhQAfa63Uv2MKJsAF9gfo6ovO6WIAJMIfSTlKBZ7eNz3IePiQCuFok6SYXazRqn7Mj
         oWHSlnh8c3CLfiJkfrVC28KanXaGttwfzxo7aZLa05/b8MLHKv2Vs4snAY909uTbfOTJ
         gIfxva8TgzBzIqee7hjup3izh5I9Ghg+1isAVcd6+3W3B+Sge3h1RYSbXFlBzaSCGOfh
         5+EPfJ/g2ZoLDqawMWhoxgMJuZzBoIa+a+rY53lDkPDz0/eJNAfj7ihdLxtSzUzwTpX6
         M98A==
X-Forwarded-Encrypted: i=1; AJvYcCVFI0V1rF5fVzPgBQzCFZCQ2p2JxVGswF1YIWLVq2Uc9sYsh4j/7ao/lCqH5E/71P+/4NZccYDRoVQ0Qhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUrJ8cBpYz/ctKkAOir3R31hHZ2YQLEok/HhNWpAh2nVyCsu3a
	Z8eIC22/RBIIDLRW/fetAZdzkDzp/AdjDjlrwmptdhYMsEYHI55BrWKF0RsION1Xtv+rA4dLQXv
	LekRVS7w=
X-Gm-Gg: ASbGnct5MjQZsdg3g9RhPScp4fAi4IKE1YVfszDyMLSnbTPq7OuIa7tgPS7jkmm7S9d
	YgnOovJh91Rv6mn8y7DrtzwO4ZqE05WytQYu+MSiWFfDgWIJpaPEzU2FUmxNM0Lt0h+4pmP3i3V
	t5wRBCLe3xYPpxwdUoCUpGh1WMkSUPoQYdQ0kLhkV+EoJ0j9xrW8nKUR8yF000DVhAWb8VEE9Ft
	yQG0Rvr0hkLzKfIX5TSvAf802X5qYo0lLF0jGlz/lNwrc0/7/Z5tMhW9VlEvQ37CKSIHC2VEWga
	1UKgnBz1tOZRw6aJCxJvXTtmD4aBD71zJcORYHaXEnEqKeP/LMHy+bWtbeaEQh9SfNh/Qjyll89
	N3kQsgtNXKigimOLc6NPF+SpYPzSgi0ZAJ4vWFlmVOnLoq32niZOgGTQwwKH05hz+WzfxtLErLj
	RrfFjpmUt+uVV6xlk9jJnKyTpbA3zNeECZW5z+JT2Zxzhg4kPmJPFQpPyJFtjgG8GzbVAqCUzNB
	NWq+PZQsw==
X-Google-Smtp-Source: AGHT+IEVPRHMM1dF9XoCJxJ0q0PY14MufTxpL94zsmySSoLm55jAjkagI7ZOF9FMXb554p0jI4buyg==
X-Received: by 2002:a05:6402:51d3:b0:643:11fc:7115 with SMTP id 4fb4d7f45d1cf-6451f94dd50mr2757074a12.11.1763569397172;
        Wed, 19 Nov 2025 08:23:17 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a3d8294sm15472162a12.3.2025.11.19.08.23.16
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Nov 2025 08:23:16 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64165cd689eso1634651a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Nov 2025 08:23:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX+9J3aOLp4jZh5A1uWKfTVZwRmorkU9igHo/qhviSoAP7OObC/AjsZ151fbv1Hq0Lx0eWRMpOh4/OG4LA=@vger.kernel.org
X-Received: by 2002:a17:907:3f22:b0:b70:83a2:3f5a with SMTP id
 a640c23a62f3a-b7637f09c18mr367914966b.0.1763569393225; Wed, 19 Nov 2025
 08:23:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118170240.689299-2-Jason@zx2c4.com> <202511192000.TLYrcg0Z-lkp@intel.com>
In-Reply-To: <202511192000.TLYrcg0Z-lkp@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 19 Nov 2025 08:22:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9+OtEku8u9vfEUzMe5LMN-j5VjkDoo-KyKrcjN0oxrA@mail.gmail.com>
X-Gm-Features: AWmQ_blvNYn7H28EA66iZpW2y6IrvCN6ellqnQuobuFiTc4oP03NDclyafTOCUE
Message-ID: <CAHk-=wj9+OtEku8u9vfEUzMe5LMN-j5VjkDoo-KyKrcjN0oxrA@mail.gmail.com>
Subject: Re: [PATCH libcrypto 2/2] crypto: chacha20poly1305: statically check
 fixed array lengths
To: kernel test robot <lkp@intel.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Eric Biggers <ebiggers@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>, linux-crypto@vger.kernel.org, 
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

 On Wed, 19 Nov 2025 at 04:46, kernel test robot <lkp@intel.com> wrote:
>
> >> drivers/net/wireguard/cookie.c:193:2: warning: array argument is too small; contains 31 elements, callee requires at least 32 [-Warray-bounds]

Hmm. Is this a compiler bug?

That checker->cookie_encryption_key is declared as

        u8 cookie_encryption_key[NOISE_SYMMETRIC_KEY_LEN];

and NOISE_SYMMETRIC_KEY_LEN is an enum that is defined to be the same
as CHACHA20POLY1305_KEY_SIZE, which is 32.

And the compiler is aware of that:

>    include/crypto/chacha20poly1305.h:32:20: note: callee declares array parameter as static here
>       32 |                                const u8 key[min_array_size(CHACHA20POLY1305_KEY_SIZE)]);
>          |                                         ^  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

but still talks about "contains 31 elements".

Is this some confusion with the compiler thinking that a "const u8[]"
is a string, and then at some point subtracted one as the max length,
and then is confused due to that?

Because if compilers screw this up, we can't do that 'static' thing,
regardless of name. I'm  not willing to play silly buggers with broken
compiler warnings.

               Linus
