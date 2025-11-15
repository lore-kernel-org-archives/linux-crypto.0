Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C0F2D77F7
	for <linux-crypto@vger.kernel.org>; Sat, 15 Nov 2025 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763226717; cv=none; b=SL+tHG5Gw8nASsV/LZKu8d8TtXDbhN//H3le5W5Znw9MJMP0IAc+rTy3zEGCHCqs3DHsvxc3bdhMqdx5Git7PpVNJW2y8BR4pAbR8r9q3/98SgdicrrONOC8M8A5h2PhidZ0zxSd1Y6O4CxbI+74TMgOFA2db16bU3IipodcqTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763226717; c=relaxed/simple;
	bh=dfRb5LKPf3DawblS+BQV149Yus51dOjA2Wv2tWMbM9k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=degXqjISwN5NHfvUYT0w3yDAhIKoLfW6WJYYd6I47EFR8VEmWt0PIhh3P8NTL8C2plBKllSj2KvbMhtIuAfS8Yczqd/Ps1AMFy8chd/7DQH4X50sjfVDYfjJDPX/NOt3i0FR2t2rRdS0uY0a4aMoEuHtCJW3D9KRaUQ+EHRYFko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZtWibgkX; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZtWibgkX"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6419e6dab7fso4562609a12.2
        for <linux-crypto@vger.kernel.org>; Sat, 15 Nov 2025 09:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763226713; x=1763831513; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h39FYq2IeCqBpiRFjS0wZXOGV+6LuFS9Jt9x/M8fMQ4=;
        b=ZtWibgkXe40oiIkD1p3VlU2BFwK/lppz0ewJJcOXpHXfiFjdg3q+7E8Pmikwb+awHi
         vJf/ViU99WqbUTQxho79wdiYuVNkNRAu/tS4+/uu88anJS7wt68CD320r+avjaHMYeWN
         uNX9/F5fufCWhGwmXYQrJEo4nWIZy/uFtoSv0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763226713; x=1763831513;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h39FYq2IeCqBpiRFjS0wZXOGV+6LuFS9Jt9x/M8fMQ4=;
        b=wGH/t4yAmXenm/zaFri5CkLrx8SUS8isbrUef3AXoa3FjvbWNccgFejNC4ziIKooV7
         /fNfbzBhXqbNsMtRXztX4yB2mon/FxgJ2jWjdXxsjePwJ5RZ47+DMpxkxj6uINY/Davu
         wJRv2QAkzNOoxr3VlXXiGjioTpcHPo4Jb5Ruw8Tg1Wy1+qJbQhK8JfJVkjo0GskebxSp
         WhKQP2AoNIXQQ3R7guuPYQtT9XpN6Rt0ON6yFUhSyzCRkdfgYShHnA4VWQbTxEG+AVni
         Z+EZLfItIYlEc+J5YPoYjUJ1BnL291cF0CDlPNHvLJEODpXqK/31/YpfPTlAPVbnYpT9
         Hwfw==
X-Forwarded-Encrypted: i=1; AJvYcCVvTuQeep1ebeHdYRoyu8A0UtFqz0NxWnccmOwXcR4F0sR7aQkqCRnutxlWgMUCAF8ZR7YKa8eASZ3fodc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOsTt77WHVmhasXPrEwlFH6qwcjo/zLdkkezxDG0t48NuPaS8Y
	VcHtQ17nSvPMHUhz7+e8SH5duTuYnwvZ1JSTwAoahu2YY5Hrl4qjV+lX4B8rNX3lV1LINCRB7L1
	NpM1IyBM=
X-Gm-Gg: ASbGncswO4Syffq3ua9NxCrH9OfHqWGu5MxZOJp23oup8EAKDl7ldeo3jVh9F+lHYla
	PmnAEd39RaOrOlyOiRaoaO4hFiq9dyl3HtJbhk1doFy/wN6AwiDWbPLXRKqtHmRmLhy3s5vN0l5
	APd2bzhT/T2ZSX6PeTriCrZ58tSKa69ClDSuxYrbfBTasodNRfYLnCjUAQ5ATFQXDM6ra16CnEK
	y2zR5s7S9d+5dgoIdmp9DLlQjwb3oTKdcR4tGWB4okmqwIjyPqhgr3xBRBWe9kHpFIllofTxVFm
	VvoENl9y9bnyTckDJrirUKXvl9/q1o55tE83PfPOGJ8zDbVvUzgZP5HefnhVYl+TcAAq6dDj9dd
	q2CaM8xoSxS+43GA/FMcegGOw2YV4GctEOubGE3ZlhaxLdP17KnbXwPU+eNSrrbKA7Xm3AdB16F
	WhEfLryK58+a7GqFpjv/98wPW7S+M5Ir693gxIFL5fEA9biTUHWJbKbRfjBmvl
X-Google-Smtp-Source: AGHT+IHD3kAHKUCf3kHNMdXglbH/R5XAHjEZ3y/hJ9WMsYg5TGfY/tDYlGWeiaSzgrDLkeayVQDNYg==
X-Received: by 2002:a05:6402:2110:b0:640:ec57:f83a with SMTP id 4fb4d7f45d1cf-64350e1e3acmr6439169a12.13.1763226713133;
        Sat, 15 Nov 2025 09:11:53 -0800 (PST)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a3d8294sm6114860a12.3.2025.11.15.09.11.48
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Nov 2025 09:11:51 -0800 (PST)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b736fca06ceso211168866b.1
        for <linux-crypto@vger.kernel.org>; Sat, 15 Nov 2025 09:11:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX2NaR50iepgbyTddC8XyEJrjEla1YN3r649tb6/hlnDTmS8x/K2wQ2GieQpPWhNJpafwnCSJi0G6pgi58=@vger.kernel.org
X-Received: by 2002:a17:906:6a08:b0:b72:599:5385 with SMTP id
 a640c23a62f3a-b7367bab9e7mr727036766b.61.1763226707931; Sat, 15 Nov 2025
 09:11:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251114180706.318152-2-ardb+git@google.com> <aRePu_IMV5G76kHK@zx2c4.com>
 <CAMj1kXG0RKOE4uQHfWnY1vU_FS+KUkZNNOLCrhC8dfbtf4PUjA@mail.gmail.com> <20251115021430.GA2148@sol>
In-Reply-To: <20251115021430.GA2148@sol>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 15 Nov 2025 09:11:31 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj6J5L5Y+oHc-i9BrDONpSbtt=iEemcyUm3dYnZ3pXxxg@mail.gmail.com>
X-Gm-Features: AWmQ_blPfFFvXaB9jz5v4DGmY2d9vuCh-jr5Qbb1qJZNa0_hsf9I051ThaeNje8
Message-ID: <CAHk-=wj6J5L5Y+oHc-i9BrDONpSbtt=iEemcyUm3dYnZ3pXxxg@mail.gmail.com>
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org, arnd@arndb.de, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Nov 2025 at 18:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> I think it's worthwhile adding it to get better warnings, though we
> should check with Linus whether he'd be okay with kernel code starting
> to use this relatively obscure feature of C.

I wouldn't worry about the feature being obscure. We very obviously
use entirely non-standard features, and regularly depend on "sane
implementation" as opposed to any documentation language-lawyering.

And we already have existing users of this syntax, so it's not even
new to the kernel - it's just obscure and unusual.

The main issue with the whole 'static' thing is just that the syntax
is such a horrible hack, where people obviously picked an existing
keyword that made absolutely no sense, but was also guaranteed to have
no backwards compatibility issues.

So the syntax is disgusting and nonsensical, but the feature certainly
isn't wrong.

So *if* we end up using this syntax more widely, I suspect we'd want
to have a macro that makes the semantics more obvious, even if it's
something silly and trivial like

   #define min_array_size(n) static n

just so that people who aren't familiar with that crazy syntax
understand what it means.

But as mentioned, we already have a handful of users, and I don't
think it has ever caused any actual confusion or that people have even
noticed. So that wrapper would be more of a "if it becomes a more
common pattern, maybe we could document it better", although the
counter-argument is that "if it really becomes common, people will be
aware of it anyway".

Anyway, I have no objections to the crypto code using that odd syntax.
It's _odd_, but absolutely not wrong.

                Linus
