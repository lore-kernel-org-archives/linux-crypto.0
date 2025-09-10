Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFD931D39E
	for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 10:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757500886; cv=none; b=MYUfEcAPZfijWya2cMpGjxayfSner1L7LY5EUavTaD8Fo1DQQITYVeZ5gXphJ7qrGJU7k3lOE0O0zHxwj1hnUbH+4e049yP7rvZ3QRBoKiGcWYZ+PWMQOQDQkOvpIC0mhLlq7Oj5FIfHPapfXl7LjH8reYHXKZxVEvfOmOY9guA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757500886; c=relaxed/simple;
	bh=ep6DHmBHgd1kpbChAS+R+dvVahzWEZwGQlVUAbmwU28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UBwZbzZUbiXIsUWfoj8jjs2N1OGz/3yOHykDrWCwffeTTuSPrrcoBt9fXwvy1LYiuUXWYkZFjOd3wbNZBioccMJWp6EFRTmmKo8eeG12nZkYUWFPkxjEylHusCuIXYNCVIUADvGHuC+8jN84YBs34SO8qQeF0TgIFHeQnvsCbaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GqJMZItz; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GqJMZItz"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b548745253so93409011cf.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Sep 2025 03:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757500884; x=1758105684; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ep6DHmBHgd1kpbChAS+R+dvVahzWEZwGQlVUAbmwU28=;
        b=GqJMZItzXp3L41y4JaNKCcLVTJCPOzdq7bf9pvwuxu+IYvWtISgt8BKDi/lr2D090z
         6KQV41Q+XSaFLv+/FJN6O9RAVoO5jdhvxClRZhwzeCydodArjvq6+uRhauPaWt9N9bO6
         bW+waoq5TsinxiCeEO2rpxbBn5y2IEoW0Nc+n5hR5wodI297EmsFViS0VF9atcxO99jP
         Na4sP9LFmYMGV+t1hekT7LmfAaF70gvAafetaJemWDS5oxgkRg2AVgzq0qPIpXo/NkKG
         UR2pHzc9tpQf1SAcCMCsVvJDtOHMvg8c5050rt8nvIKP0vjwZFm+wFtGhwttgKTbli+n
         o4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757500884; x=1758105684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ep6DHmBHgd1kpbChAS+R+dvVahzWEZwGQlVUAbmwU28=;
        b=AeLGLVYMRobcqQPw1x5yWk4BKXYGcLil3rqpm4NMJw4kJGvBDbC9YMlwPCQSB246iG
         eyvWxhA2l1KVA/4S3a7vMVZG1ffirlPsuIbBYplGdqnh3qs6wK88OdOsb8mB9/zqGKmB
         tV4fwhZNqta+YW7YNFh1W/uh2tDWiri3XAvurDYNHP5Ic3r2+zwowUWWQLt2k2NAMUou
         Ht9HT5r7tp3U9jIOp7+oZwsYF3ASEypP/vu0ICZK7lKTC5CMmkgao/M61yqKfAxmpmzk
         ZGuW/rS4HDgUKtbqQf5XcAJ/3gsq05hFPgkKqrHj8WRHQNt5te/fhhNDDK3PzjG2RNFc
         n9/A==
X-Forwarded-Encrypted: i=1; AJvYcCUUR2gLEifm3rOVQGBIvKGDTaMrQJS5x29lJYo9z+YYI6F/5LsXIK3zFlij8rwCVSj5PTKh99ovVhTNuRM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwL08YifAF7LXgocOBqWvRCewb8jfxVHVBnNlTC91NlUnkVEby
	1xLz35WbTU+ZmM+xlc1X19i1a+Vrp2+tLeENLPEIdpkDgA0TlI5sBlCT5U2pWoGRQDx6BWn1Mpd
	3FhWWdI5cxTxzbfszcNa5UCqLheRz7oxC0jzzEnm3
X-Gm-Gg: ASbGnctIOyEYKxftZ1+SJ3bDyOcf8vE0OXdXZEGtSTt2xkzAlkwmwMAaWSqDDEWAd7c
	ySGZI5nyvbLtZ2hRCjc527d2i7fCWm5x0eFAq7VRiFMuXip7zT5qPY9eQWLKrf76X2Wizn7VTIM
	6rR5kdPXH6xYwSxgDdBfTTLQhpZcDbTNcYeTatdAPx/TKBGxrGzum0K1E42xiDxhp6Kbk2YlfcC
	SdEaw7Ur4Z1JXVgTW+ea4FObxC831E+e+Eh+VgyJUDB
X-Google-Smtp-Source: AGHT+IH+/cbUHy8aAQiP5y+HLOOkI7jZTVO1M0xIDiJAFbe2JLcrCl7FbgVqf5O3wrtsPiVVxFILCO1nutxZp4kGACw=
X-Received: by 2002:a05:622a:40e:b0:4b5:e49d:8076 with SMTP id
 d75a77b69052e-4b5f84676e8mr170436381cf.56.1757500883119; Wed, 10 Sep 2025
 03:41:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <513c854db04a727a20ad1fb01423497b3428eea6.camel@sipsolutions.net>
In-Reply-To: <513c854db04a727a20ad1fb01423497b3428eea6.camel@sipsolutions.net>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 10 Sep 2025 12:40:46 +0200
X-Gm-Features: AS18NWD9OOMFghsEyUOQIKKsq3tKxaVXVh2dSpezbvyYolCB64CRn-65yckShSU
Message-ID: <CAG_fn=Vco04b9mUPgA1Du28+P4q4wgKNk6huCzU34XWitCL8iQ@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	andreyknvl@gmail.com, brendan.higgins@linux.dev, davidgow@google.com, 
	dvyukov@google.com, jannh@google.com, elver@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	dhowells@redhat.com, lukas@wunner.de, ignat@cloudflare.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 8, 2025 at 3:11=E2=80=AFPM Johannes Berg <johannes@sipsolutions=
.net> wrote:
>
> Hi Ethan,

Hi Johannes,

> Since I'm looking at some WiFi fuzzing just now ...
>
> > The primary motivation for KFuzzTest is to simplify the fuzzing of
> > low-level, relatively stateless functions (e.g., data parsers, format
> > converters)
>
> Could you clarify what you mean by "relatively" here? It seems to me
> that if you let this fuzz say something like
> cfg80211_inform_bss_frame_data(), which parses a frame and registers it
> in the global scan list, you might quickly run into the 1000 limit of
> the list, etc. since these functions are not stateless. OTOH, it's
> obviously possible to just receive a lot of such frames over the air
> even, or over simulated air like in syzbot today already.

While it would be very useful to be able to test every single function
in the kernel, there are limitations imposed by our approach.
To work around these limitations, some code may need to be refactored
for better testability, so that global state can be mocked out or
easily reset between runs.

I am not very familiar with the code in
cfg80211_inform_bss_frame_data(), but I can imagine that the code
doing the actual frame parsing could be untangled from the code that
registers it in the global list.
The upside of doing so would be the ability to test that parsing logic
in modes that real-world syscall invocations may never exercise.

>
> As far as the architecture is concerned, I'm reading this is built
> around syzkaller (like) architecture, in that the fuzzer lives in the
> fuzzed kernel's userspace, right?
>

This is correct.

> > We would like to thank David Gow for his detailed feedback regarding th=
e
> > potential integration with KUnit. The v1 discussion highlighted three
> > potential paths: making KFuzzTests a special case of KUnit tests, shari=
ng
> > implementation details in a common library, or keeping the frameworks
> > separate while ensuring API familiarity.
> >
> > Following a productive conversation with David, we are moving forward
> > with the third option for now. While tighter integration is an
> > attractive long-term goal, we believe the most practical first step is
> > to establish KFuzzTest as a valuable, standalone framework.
>
> I have been wondering about this from another perspective - with kunit
> often running in ARCH=3Dum, and there the kernel being "just" a userspace
> process, we should be able to do a "classic" afl-style fork approach to
> fuzzing.

This approach is quite popular among security researchers, but if I'm
understanding correctly, we are yet to see continuous integration of
UML-based fuzzers with the kernel development process.

> That way, state doesn't really (have to) matter at all. This is
> of course both an advantage (reproducing any issue found is just the
> right test with a single input) and disadvantage (the fuzzer won't
> modify state first and then find an issue on a later round.)

From our experience, accumulated state is more of a disadvantage that
we'd rather eliminate altogether.
syzkaller can chain syscalls and could in theory generate a single
program that is elaborate enough to prepare the state and then find an
issue.
However, because resetting the kernel (rebooting machines or restoring
VM snapshots) is costly, we have to run multiple programs on the same
kernel instance, which interfere with each other.
As a result, some bugs that are tricky to trigger become even trickier
to reproduce, because one can't possibly replay all the interleavings
of those programs.

So, yes, assuming we can build the kernel with ARCH=3Dum and run the
function under test in a fork-per-run model, that would speed things
up significantly.

>
> I was just looking at what external state (such as the physical memory
> mapped) UML has and that would need to be disentangled, and it's not
> _that_ much if we can have specific configurations, and maybe mostly
> shut down the userspace that's running inside UML (and/or have kunit
> execute before init/pid 1 when builtin.)

I looked at UML myself around 2023, and back then my impression was
that it didn't quite work with KASAN and KCOV, and adding an AFL
dependency on top of that made every fuzzer a one-of-a-kind setup.

> Did you consider such a model at all, and have specific reasons for not
> going in this direction, or simply didn't consider because you're coming
> from the syzkaller side anyway?

We did consider such a model, but decided against it, with the
maintainability of the fuzzers being the main reason.
We want to be sure that every fuzz target written for the kernel is
still buildable when the code author turns back on it.
We also want every target to be tested continuously and for the bugs
to be reported automatically.
Coming from the syzkaller side, it was natural to use the existing
infrastructure for that instead of reinventing the wheel :)

That being said, our current approach doesn't rule out UML.
In the future, we could adapt the FUZZ_TEST macro to generate stubs
that link against AFL, libFuzzer, or Centipede in UML builds.
The question of how to run those targets continuously would still be
on the table, though.
