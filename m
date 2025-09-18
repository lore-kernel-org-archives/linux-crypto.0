Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316DE2E54D1
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 21:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758232501; cv=none; b=McNGT1afunTt7VDzUyv97KfcaGUYCymMVQk/rkMe3xGdfqoLGpvlgmPymzrXR8TFQ1F7UI9GOsUk73CzEHUPQ72wNShFOxNaiDA3zGgRM9pAJlAxoLO60cv1RA2h9Guucmf6YeLQmA7NvmnpXhEdcCd6JN7fdL4PzdkDDLCPcPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758232501; c=relaxed/simple;
	bh=OBdCMGeWv7G/tkOmZiDbcUQKLH/CnWF06gVEbnVu89c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NdhfLfGL4VNKM8ILrpGoy8srFfWFUeZXkmrD1Obt0bu/oQ1DAsM6IOYf1j8iy09eCv0GoM8YX+oe/VX0glrtpI6d7Oy0I9Zk+zhjf09Ic0763DSs+kQQjVbVRX2IZvmoHfDwZby3NW6diOLEbXzJVAiw3HxVa5i6IDBqD78d+Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dh7r3dpc; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dh7r3dpc"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5688ac2f39dso1798283e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 14:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1758232497; x=1758837297; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mLiszfQw8YctXWgw7Rv1CzeIAYsEhv/enJDimwborHo=;
        b=dh7r3dpcNwJyxGAgWS96RPWYNUEYVapVoBbPCwNUZL6/pXFRrZch4BCZ1jTLeB7Ux0
         LFYbX8ZUVB8jhhx0T5NBrJ62sKWgbPrWw4ziSPENm1s6zPJj7uO/ev73wTpcQU8WfJJ3
         sqi0ZhCiDOpIUv/y6TYOyMHavt6bcYezEMLeU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758232497; x=1758837297;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mLiszfQw8YctXWgw7Rv1CzeIAYsEhv/enJDimwborHo=;
        b=VlwZq3tjEq88BDPZxOUAb9TBfnqogmbijOtMiKWN228dGX3Zetu86wSkzIb5oX8BjO
         sVJdC+XMRkW0Sd9qNNjWutPVIln31iXTB5lXkJfQGaxl2t9Ye3yMORT6cOeb4JpkHz0h
         EJHTV3hjYg1KNAYt91DRXX6/g860RdNFI97AtQn6psa1DaRdKyO5N24Lz4CeyzjW+8Tt
         8OP6fZSxPigdnHA95Cc2GweSgd1kWPLTVSwLkAwtSIt8RG+3TWUtZVG5fC/NYVkjh33V
         EVBt1h+68NIoJygya2P/TaAwEGMEjXJ9BGiUevs/w9U+y/0rK7gOS7NhaQSqFkZROVor
         sk/w==
X-Forwarded-Encrypted: i=1; AJvYcCXRVrHLK3Q1oVmeUHHK1FPRb3D9j3E8tfQbf6wdbtpiuVGFJk/9wao5UdKZydRRkD2yrTtLfpaB8Wo651I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwleMVIwvQ0kUDTykKNY+XJHHdmF3LeD2RafGAD7J5IRtcJ3u/I
	vNMsSVJh79t9LiVwEqb+8okmmGk3JpVNspTOG6dLPgLdOshplO8PbQEEKkQAtvjmThMYaw8hj42
	+xiOEi+9dqA==
X-Gm-Gg: ASbGnct9otWyA2qpaOi0B5bkrWNG7UmIBz8YEdbgSkcVSIuNRenP3C+ZXiPWOnp/QI5
	SM4joFymFz0g9W6PqphOjm7ltcePwd4GV4evxqm1VPcFACGBSJadWmQzuBzmtSsstuFguKdJFW1
	fg+A68ol6d0tJvT3/nrAi5LLYhZ/KlXlYWcDBGRI+LkqbJKOcS7QBekQpzka7oaYjmp6jxC8YCn
	F7ZdDTI44hy7bTD0nisss94WDICWwzBHWQTKJMPaES+wwG2DVRvBRhy2MO/4GE8SIrd01Gpf/4m
	mNCI/OETdhUVGn7A1aEahikJuugXjyLeMTCXttRNiUpjfUH4xBrP30dxn4lIGHs1WoAdAInG308
	M0Gy4vbxGcznEwQ+2FFMuUhKzwjdpXgJCLBc2ldFS4T1J575hiUoT1VJc10dPyzYQZcZwo4ylO1
	s8abylNXHnMO8b5AyD4j8=
X-Google-Smtp-Source: AGHT+IG1QCQKHKvplK0sW0E/OaXHAP2sfBfCuz1VRIFg85SqQJ4c1JCbjugOROM1jUaMPizGKFehuA==
X-Received: by 2002:a05:6512:3d1d:b0:55f:4ac2:a5a8 with SMTP id 2adb3069b0e04-579e00ca14bmr333261e87.13.1758232497032;
        Thu, 18 Sep 2025 14:54:57 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-579a1bacef8sm389397e87.103.2025.09.18.14.54.56
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 14:54:56 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-35e5eda335dso12050351fa.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 14:54:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXqHHz6X7lc4/FgKjUdx5NqUWJoFUlybsenEsMD3KCXGrjjWhOzuXBEtJWEvYNbh+6HbMdtX98s6FRTmko=@vger.kernel.org
X-Received: by 2002:a17:906:dc89:b0:b0f:a22a:4c30 with SMTP id
 a640c23a62f3a-b24f5685fdemr62738866b.47.1758232077501; Thu, 18 Sep 2025
 14:47:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com> <CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com>
 <aMx4-B_WAtX2aiKx@elver.google.com>
In-Reply-To: <aMx4-B_WAtX2aiKx@elver.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Sep 2025 14:47:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgQO7c0zc8_VwaVSzG3fEVFFcjWzVBKM4jYjv8UiD2dkg@mail.gmail.com>
X-Gm-Features: AS18NWBxHuMwwtU-EoNbPFA3uJ1YRJkAKqdurj12n-PWNJgH6ecKwZ8QZrX3P28
Message-ID: <CAHk-=wgQO7c0zc8_VwaVSzG3fEVFFcjWzVBKM4jYjv8UiD2dkg@mail.gmail.com>
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Sept 2025 at 14:26, Marco Elver <elver@google.com> wrote:
>
> Fair points. "Context Analysis" makes sense, but it makes the thing
> (e.g. lock) used to establish that context a little awkward to refer to
> -- see half-baked attempt at reworking the documentation below.

Yeah, I agree that some of that reads more than a bit oddly.

I wonder if we could talk about "context analysis", but then when
discussing what is *held* for a particular context, call that a
"context token" or something like that?

But I don't mind your "Context guard" notion either. I'm not loving
it, but it's not offensive to me either.

Then the language would be feel fairly straightforward,

Eg:

> +Context analysis is a way to specify permissibility of operations to depend on
> +contexts being held (or not held).

That "contexts being held" sounds odd, but talking about "context
markers", or "context tokens" would seem natural.

An alternative would be to not talk about markers / tokens / guards at
all, but simply about a context being *active*.

IOW, instead of wording it like this:

> +The set of contexts that are actually held by a given thread at a given point
> +in program execution is a run-time concept.

that talks about "being held", you could just state it in the sense of
the "set of contexts being active", and that immediately reads fairly
naturally, doesn't it?

Because a context is a *state* you are in, it's not something you hold on to.

The tokens - or whatever - would be only some internal implementation
detail of how the compiler keeps track of which state is active, not
the conceptual idea itself.

So you name states, and you have functions to mark those context
states as being entered or exited, but you don't really even have to
talk about "holding" anything.

No?

               Linus
