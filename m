Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AEC2FE57B
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 18:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763662920; cv=none; b=O2tqhJI918wAI3+VJykAE2ZYUTgDz5wWvZL0wdHIbX6MV8L9GNZMvmtrExAFFgLOE4YHtWSOMYMnvcLv+6BWwcZ9XH4LwQ6VeudtG2fLW843qMbrRB3dz2TyRiuaFQ42cKkNJGUEu4F88ajJBknRVurfHWfn30CHDhJGhr95Noo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763662920; c=relaxed/simple;
	bh=wecZEUleM2pVH/ldG6VyoxAP3Tx+t9JIJBh2fst1eeo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d3xgxRxigYXwpugILnf9NaShxtu1Ht3RMcytztmL1NsPcMyaTE66uBYuZPTYGPflr1rIwkzAq58hwsfT6q34u3XvRGHmrmY56YELmjHoBYDrAvFdk+C3YOFBHu6qbSUvVmW5mqaLDdvwfZbTLgdSD7pKZwHqJ5saRMtKdQZM3g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QHZUmRK5; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QHZUmRK5"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-37a33b06028so11413041fa.2
        for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 10:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1763662916; x=1764267716; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+BPfdnrOHpw/8tC+sL0oorkp9gKYtrunKdRWYzTn+GA=;
        b=QHZUmRK5/RdLNmdm99gtRcafG2F2E4ySFAErTof2jVn0d+laptat9VSOpWIB+UF4qd
         /hn3y/4EPti9rugLesTnUfjBOcuvdgxIDrMhe/OYg/lyEXNhcNFaf78Pwvjk0+av7/ND
         JjqRxQeSEkf6OctNlhKktG1Ck3z+08f7sscy8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763662916; x=1764267716;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+BPfdnrOHpw/8tC+sL0oorkp9gKYtrunKdRWYzTn+GA=;
        b=WR/haLwtcFNfQmmH/VbcHMJ9odOnNmGDD578XtGksWSUskTVF775M7iNlw/qcmquUr
         /bsclhh8PC+19iN2iw8zW7YBy2gXs31fuE2sm8+Il5wcBWyFNL305LpQTVVkEcPUV3Rs
         +aaX41la72nsALJ2MmO69EAigg7+CfXYnWznvdavS3wwsSro26MEBtTk2lrozN+3BxvT
         CpCYC2MWnyoTI3gLnsUdMr4GaVOSNRjieZMQY9m8YYCnIFsq+Kf5Rr1EvReEVa0CUoqa
         ydXMa/Ts9Jphla6xwYFP960tE1ZHqf9SC4+bJmuBb74PWNhvLo3A7aQBwS700iOlG4Kc
         uWuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgDDUs/kA45LGErQymHcZmKtUDBq8mk23viY/X17RQuUqaOMfFn+yd84EJzlAYpwv7Rlk6Xq7gLC9+DaM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHfIX75L9pRCSzJy8m/2Jgg4AviAZZl1f+meiQDED+Lt8kL2Ec
	mIqa6MAtbaBdtTGDNCVZcEpRk/MpZ6COa0A0RDEffVpffcyXTngNEP8mvSjJivu50wHQYIs0tWr
	A614qqCwVAw==
X-Gm-Gg: ASbGncvUgx7OnPDLPtUMvHV5bX1LOREy1FcNzEjXzbY7Mq8FM+VqRjhyk1o/OEWwkoq
	dBfrSxXg3nj70eX6ef5AabbAinNsHnJ6bWxsrozt9qYu/npTm8Vjxzl4ASi29BmhpcxVCjI26fy
	Jcy0HY5Lvhr5GhvM8xpqI+TJlpf0qqlNL9R7oe9oV/MexupGEN9eJRtTqvUw3z0aD06mJyv2/k1
	uEtiZLo4umWFXItGlVkttrkG8OBvOjfHNs3tUTc7WLnHaUJ5/cM9jkqop4sGq+DYMS8UGBA4d2V
	LnCD0C7P1SfjW26oUcjeHcQ5uAZ26lXpkPYusoOjOd6Xq4V9i7pm3XTim9wN5EEBesbxeBPybna
	jOwzIDM/4luOB5AaZ+1GtJvO3iG7rNdKFPQ6C/0Sx9l61dwDpUkyMz9bRyEze+8AQRtRexo8/9/
	8LTM4rTp/RZwXDDdAAyticaqwy7rprsIs4OhrZZ86m9NRWySifnFpYKk3AnL6qk6Lr
X-Google-Smtp-Source: AGHT+IFSGU1GtncXgtqZw4JtH0kJ/BQYyXs8IWpgFlOY+kFXaRbaZJ5Dh34XKQHvsdjRKOQbaC8OHQ==
X-Received: by 2002:a2e:88d1:0:b0:37a:4611:9fe5 with SMTP id 38308e7fff4ca-37cc67563d1mr9914271fa.18.1763662916231;
        Thu, 20 Nov 2025 10:21:56 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37cc6bcb262sm6489731fa.43.2025.11.20.10.21.55
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 10:21:55 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-37a3d86b773so10728981fa.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 10:21:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWHhwukXX7Ny8dZn5xtwSJivtKwdMJf+S1kWG6QDAuAtvdVton8vbViHSQ7fCA6SEycPzt3gls/ezPGE6M=@vger.kernel.org
X-Received: by 2002:a17:907:7f0a:b0:b70:b71a:a5ae with SMTP id
 a640c23a62f3a-b7654fe9b97mr482177966b.44.1763662490181; Thu, 20 Nov 2025
 10:14:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120145835.3833031-4-elver@google.com>
In-Reply-To: <20251120145835.3833031-4-elver@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Nov 2025 10:14:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=whyKteNtcLON-gScv6tu8ssvKWdNw-k371ufDrjOv374g@mail.gmail.com>
X-Gm-Features: AWmQ_bk-my8wSL6P8yRhTUREdDraem8VrQQmjD7uS2S9oN6T2mRX46ftlS1ytQU
Message-ID: <CAHk-=whyKteNtcLON-gScv6tu8ssvKWdNw-k371ufDrjOv374g@mail.gmail.com>
Subject: Re: [PATCH v4 02/35] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 20 Nov 2025 at 07:13, Marco Elver <elver@google.com> wrote:
>
> --- a/include/linux/compiler-context-analysis.h
> +++ b/include/linux/compiler-context-analysis.h
> @@ -6,27 +6,465 @@
>  #ifndef _LINUX_COMPILER_CONTEXT_ANALYSIS_H
>  #define _LINUX_COMPILER_CONTEXT_ANALYSIS_H
>
> +#if defined(WARN_CONTEXT_ANALYSIS)

Note the 400+ added lines to this header...

And then note how the header gets used:

> +++ b/scripts/Makefile.context-analysis
> @@ -0,0 +1,7 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +context-analysis-cflags := -DWARN_CONTEXT_ANALYSIS             \
> +       -fexperimental-late-parse-attributes -Wthread-safety    \
> +       -Wthread-safety-pointer -Wthread-safety-beta
> +
> +export CFLAGS_CONTEXT_ANALYSIS := $(context-analysis-cflags)

Please let's *not* do it this way, where the header contents basically
get enabled or not based on a compiler flag, but then everybody
includes this 400+ line file whether they need it or not.

Can we please just make the header file *itself* not have any
conditionals, and what happens is that the header file is included (or
not) using a pattern something like

   -include $(srctree)/include/linux/$(context-analysis-header)

instead.

IOW, we'd have three different header files entirely: the "no context
analysis", the "sparse" and the "clang context analysis" header, and
instead of having a "-DWARN_CONTEXT_ANALYSIS" define, we'd just
include the appropriate header automatically.

We already use that "-include" pattern for <linux/kconfig.h> and
<linux/compiler-version.h>. It's probably what we should have done for
<linux/compiler.h> and friends too.

The reason I react to things like this is that I've actually seen just
the parsing of header files being a surprisingly big cost in build
times. People think that optimizations are expensive, and yes, some of
them really are, but when a lot of the code we parse is never actually
*used*, but just hangs out in header files that gets included by
everybody, the parsing overhead tends to be noticeable. There's a
reason why most C compilers end up integrating the C pre-processor: it
avoids parsing and tokenizing things multiple times.

The other reason is that I often use "git grep" for looking up
definitions of things, and when there are multiple definitions of the
same thing, I actually find it much more informative when they are in
two different files than when I see two different definitions (or
declarations) in the same file and then I have to go look at what the
#ifdef condition is. In contrast, when it's something where there are
per-architecture definitions, you *see* that, because the grep results
come from different header files.

I dunno. This is not a huge deal, but I do think that it would seem to
be much simpler and more straightforward to treat this as a kind of "N
different baseline header files" than as "include this one header file
in everything, and then we'll have #ifdef's for the configuration".

Particularly when that config is not even a global config, but a per-file one.

Hmm? Maybe there's some reason why this suggestion is very
inconvenient, but please at least consider it.

              Linus
