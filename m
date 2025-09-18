Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A0E30FC2C
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758210928; cv=none; b=NUj2zAMYLDsgjUacGn5TxND4Mkv0EY4VXQTIwBINQDPEg+2vG2dLgMZloTwNR8zKLJXXcJw0U7/nvO8hKHbsBs1r/9jgdp8F7YrOhozdIBYB6Ys6ZKvPN+3ISXQPiNcieGUSGlqpws6x3mzt2VHmBKz+44AIiblQ7yLFlPiN9CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758210928; c=relaxed/simple;
	bh=XhR1h2E8azi9+Iqslf03I/SakVc5s2CaBmw/N8HkwwM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MI3r+pXC4+Sv3LCYrV6MLIPjE3vCB003NIAffBHhiI4KLon4iHwPROfAkfuFu3RVauBsh8Y5RX2YNCyEKHsUjaP07s63BwVp6jhtuJklxETnEdGU3FGZWY5wvVqaEBnJ7n7kQbNIn+U2Zl3fjwE8R5CdU5rhUvVHOZVQd3ghAKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bqxf2N3F; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bqxf2N3F"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-55f720ffe34so1281067e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 08:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1758210924; x=1758815724; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hpKO6CsQCuex3g+QZ22KGPC+ZgcKRmVKS1THDCqCkXc=;
        b=Bqxf2N3F5NSYL8kwf7W4/00AKQuTr8tL3s4hH7IyRhCjn0rCsR1YZ0V1nLg/RiPlaP
         0sTbuxc9MH3nEC+GzmQi9BwaA1mY5D3sRNgICuuiVsZpqq9AJ9et9AyP84mj4EW2lZuC
         2dCUGHw3Fy/PwW4Pb7OoTmklu/DXQhmBH5pg4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758210924; x=1758815724;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hpKO6CsQCuex3g+QZ22KGPC+ZgcKRmVKS1THDCqCkXc=;
        b=w9SXUKT/Dpk5CPaaH6tsYhJfBKmfdMA6g4/ZedPtCtSvr3x/LPKDHAhEv46+gbdCEh
         0OmPq/cbbEwoqFfGcbuR5GbSAeZc1nu+c6fS5bp3IYLOghFcxTDiyb3IXP7qZGad5xzx
         6pVHXiTgYYIQv15jxR612Y4k9NgRqmutXA9aC2WBhVz5ailjD+o82+jQYdr0Thhj4DNk
         egfPrcEgeLx3BJ+i9hkPfHE098MWMjKfCHAaDt25R1Le+bPqa/zAi+0e6ueb/6KJVIEr
         nGQrOkElYqlk4I6a78HmpGJgCPnLXMtG8Bf9F5CL+Gaks5Zzwd7M38iB6jJz9Hx13v77
         WWiw==
X-Forwarded-Encrypted: i=1; AJvYcCUjIO5SKdHP9zdYPpAmB1CQqQYQ/qWMo4bLvz3TsZ+Re1MBpkRw5DVmqQCvx5Wkr9oZ3cCt57QjJiYetzM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK6buMYVuWya4jpiDjaI6nsN9rQua+ALaUFCl4yMVIPxGwDpqV
	Qdx/PX1kVJRbC3gxNCh6egLDLSvS62N/ZtDuDZtnlliK1xGLvFkpShhwx+ahmiU9HFcihRJLCOf
	ndRrhApk=
X-Gm-Gg: ASbGnct+HZQOkTfPsVDVqxUO83ACWHs+rPv+dweAYblKEd+drKBNogcCProIj0i/2s9
	sRhM+ZzaLIftEWGnNdtiZD2RiHcGzADk2zfcbEPqAwIPzgHqMX6LXNjyN0AxyJ9hzEy1aeQg2dU
	LzfmAt0GjijDI+umIan2D90hbvvU6oHye6zIQiaHY/uSIXA0efC3kBMObmT0hOo5dHdS3QIAwUl
	B0hCzMH8r2wzg9X31di2yofjZf8m8Olrhb1wDTzL1dsQUiT0SUS3XfwmQsgD7GT4dpKBqgaENQt
	/VpN+jmTks2SNWbNOeQdEg2yAvT+gHlWmE8N5GHRcHPypfd/vx0hf+k9pg0mDU8MPzQ3iDtlcwO
	qK5x7VnoPCXb6rR9WGsLJtKxIzNBC+xoE8VCGv8tqMuKPlQVx6D1ZPCErZ3+4U+cc+lNyg/m9pD
	szi84ob48rah1IYoQ=
X-Google-Smtp-Source: AGHT+IHoWUmczKa7Zv0YxY0DUip7l0SWjSy5W1/2YHWA8QEDJxwuevwwz9pK9leWxz2wdDR0yw0wcA==
X-Received: by 2002:a05:6512:e81:b0:571:6281:35c4 with SMTP id 2adb3069b0e04-57896cf0c59mr1301178e87.27.1758210924063;
        Thu, 18 Sep 2025 08:55:24 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-363becf5350sm1165921fa.63.2025.09.18.08.55.23
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 08:55:23 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-57263febd12so2589865e87.1
        for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 08:55:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU64Hm3XxcMMGWXZE624pKeFFuJ4eBTN75UyVMiorvxIF9h9xO9IoB5xxfzEkKnjxyOLAvAnK48opqQbB0=@vger.kernel.org
X-Received: by 2002:a17:907:9612:b0:b10:ecc6:5d8d with SMTP id
 a640c23a62f3a-b1fac9c9b84mr417765966b.26.1758210601571; Thu, 18 Sep 2025
 08:50:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Sep 2025 08:49:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com>
X-Gm-Features: AS18NWBk4u9ObN57KesSGhJyt-aPlWZgKdxYhvzpAyoaxlNUF53WHe4dSKjzUBg
Message-ID: <CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com>
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

On Thu, 18 Sept 2025 at 07:05, Marco Elver <elver@google.com> wrote:
>
> Capability analysis is a C language extension, which enables statically
> checking that user-definable "capabilities" are acquired and released where
> required. An obvious application is lock-safety checking for the kernel's
> various synchronization primitives (each of which represents a "capability"),
> and checking that locking rules are not violated.
>
> Clang originally called the feature "Thread Safety Analysis" [1],

So this looks really interesting, but I absolutely *hate* the new
"capability" name.

We have existing and traditional - and very very different - meaning
of "capabilities" in the kernel, and having this thing called
"capability" is just wrong. Particularly as it then talks about
"acquiring capabilities" - which is *EXACTLY* what our lon-existing
capabilities are all about, but are something entirely and totally
different.

So please - call it something else. Even if clang then calls it
'capability analysis", within the context of a kernel, please ignore
that, and call it something that makes more sense (I don't think
"capabilities" make sense even in the context of clang, but hey,
that's _their_ choice - but we should not then take that bad choice
and run with it).

Sparse called it "context analysis", and while the "analysis" part is
debatable - sparse never did much anything clever enough to merit
calling it analysis - at least the "context" part of the name is I
think somewhat sane.

Because it's about making decisions based on the context the code runs in.

But I'm certainly not married to the "context" name either. I'd still
claim it makes more sense than "capability", but the real problem with
"capability" isn't that it doesn't make sense, it's that we already
*HAVE* that as a concept, and old and traditional use is important.

But we do use the word "context" in this context quite widely even
outside of the sparse usage, ie that's what we say when we talk about
things like locking and RCU (ie we talk about running in "process
context", or about "interrupt context" etc). That's obviously where
the sparse naming comes from - it's not like sparse made that up.

So I'm really happy to see compilers start exposing these kinds of
interfaces, and the patches look sane apart from the absolutely
horrible and unacceptable name. Really - there is no way in hell we
can call this "capability" in a kernel context.

I'd suggest just doing a search-and-replace of 's/capability/context/'
and it would already make things a ton better. But maybe there are
better names for this still?

I mean, even apart from the fact that we have an existing meaning for
"capability", just look at the documentation patch, and read the first
sentence:

  Capability analysis is a C language extension, which enables statically
  checking that user-definable "capabilities" are acquired and released where
  required.

and just from a plain English language standpoint, the word
"capability" makes zero sense. I think you even realized that, in that
you put that word in quotes, because it's _so_ nonsensical.

And if not "context", maybe some other word? But really, absolutely
*not* "capability". Because that's just crazy talk.

Please? Because other than this naming issue, I think this really is a
good idea.

           Linus
