Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2395328C2A9
	for <linux-crypto@vger.kernel.org>; Wed, 28 May 2025 17:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748452560; cv=none; b=K+7qDQm2sUSBtPjyg0pUyTzk7AQucd3bMLpcdiZsFH+4WQA9RvoeCEIH8v/AWxy/Fi7XxIvnW9CpB7mFBRO0uvAA69qyDRSeK5KCIduouEuPGGZwZa1AuprnMAdRZluD412z01qZ3sJEcRr926dR6JwXEnWeQdObBAW3qotqiKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748452560; c=relaxed/simple;
	bh=GFuirEaKGhl5vMyZboOmESj/mIt1D5zTTMZxltcKv0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gA0lJ4uuXcn8YezpbEJX8/743Mv6QFMLTtaSScDHk/Nw+aTjBDkKd00yNTMdWhOHpSla6OzT/7cEWrxN6YecU1gg0HtvCuJ60HUPR4ZiPge7Z6wAqAs/5BmK4asIH7sSq8UNAvKaPwhRnghHYIUVNSjOqsewFnNoUmXEgxv16mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qARwkqBv; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qARwkqBv"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6000791e832so419a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 28 May 2025 10:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748452556; x=1749057356; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUdwWMmdYpRWctOElE23L2fIeNE3afrw4G+RZhKXn0o=;
        b=qARwkqBvmySlm5KgkxKy9dYHiyFRAlaSZiND0UbLEvUeRLenuKGMG591lLl91Zxd//
         zMnKVGZCZaf8W8YwowvpQ/kQ+lwxqAhDfnDRrbl6RZ01JNt3xGlJfl3du/R+IuOMG19W
         dGsQs/QP7UA+V89sEHRyAuwx8Gu/dJyxU+8w1wCUQKrMNsNz+I0rfulSgSMdCzjkO+ax
         cZ4zbFvzJNF7Xq6N3Ic1UQdgYPMqgwnQNPFFM+aVSrOUrCeba7jIizXOXDIFsQzVs02M
         hhI0UbR2efSwkV5nLlY0AABQXAKp8VeFeehKEeDP1zt/F62bQYXQSoIOzXzzQiF4u+dv
         Ac0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748452556; x=1749057356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aUdwWMmdYpRWctOElE23L2fIeNE3afrw4G+RZhKXn0o=;
        b=LgMyfr9fVcx84wq7fxuGcfKepl4GBiZMLlh3cCmwqOp+xhkB2isyxkjIEROWlMnGQa
         GmN83OkCJSObog9qb+XZ6IFjBzYLclOfgsK1EctxnRI3ID5Qn/v8q5mSHNwHioJh0ewK
         VuHrlQBgZQYp3Hcr76DB9Id9TtwpRMkG8UYuFuS9Wscl81u+GcvqEC/wkAR62Xmv0vcx
         SN6tS1sXN/J3/kIjOAduA1SvvtIHJs7peMQfckh/7Zjt0v7kcOrXfM63EWXKdgTDfhfF
         m9TxQ+N9uNHG2Hb6I/rz3iHWUEULQe5ctaUuopXekSiC5R6HZ5wZQDXHvQKZxiE5s9x8
         d8eA==
X-Forwarded-Encrypted: i=1; AJvYcCWnVc00uj5kjLaTNF3bLIXSiaTTnkXmNhdBAn3iQXI9WEaOMe0IfmPCVHYJfRitSSumuMLL3PttWZ17MAU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9GavYKALgyF7tTXgf4inFabQMpT/jloyUSHHyDJO+lKIK1PyE
	pHGx/8Cya4cJ9poYQnxAoTfvC2LjFJysVN93d3CwMCO+tBE/+phJzG2la2YAdvWInqKi5dXcaX0
	TLFrYPLd3TmK1w1ZLrqXZKb+tsprliXl98F6O6hQj
X-Gm-Gg: ASbGncugEoqgskK/g8URHRHbxiTJbWo9vhCbZuoNdzBqUQKq9d4BXNkegh70K2Bxmfx
	nI+y2fgBxtaWuL0nhMOd3E6ya+q/lkr5eA6e76m98AIFcYOMud3pyFdApE/pd5I28n6oD2udQpa
	BjqJf8Q1zq/9pA33T1GVe9BmUqj5/YKjEwvg1ux+fpuGNGGa7RPwSyZ7OD8+GE/V9n4klE5Tc=
X-Google-Smtp-Source: AGHT+IEt7PzAIkfFsXWZlxFmSgQSVYAlHTzvWz749ZmQ/S1uJVlMVoEN7SLnaEY1BBFoG5gmWjLgKZ2VITWWPkBMzQE=
X-Received: by 2002:a05:6402:14e:b0:5e6:15d3:ffe7 with SMTP id
 4fb4d7f45d1cf-60518dd2ce6mr131981a12.7.1748452556188; Wed, 28 May 2025
 10:15:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202505281024.f42beaa7-lkp@intel.com> <20250528061427.GA42911@sol> <202505280937.6802F0F210@keescook>
In-Reply-To: <202505280937.6802F0F210@keescook>
From: Jann Horn <jannh@google.com>
Date: Wed, 28 May 2025 19:15:18 +0200
X-Gm-Features: AX0GCFtG0eJUnIASULD2nwd-Zdd6sAxsHjSny6-oy6ySySzZaKEp0fZyIUqXpLw
Message-ID: <CAG48ez3i37DYjM+SjBjC-VKQOiJs7-YVdLEQ7aqXQwxWs-rS9Q@mail.gmail.com>
Subject: Re: [linus:master] [crypto] 40b9969796: UBSAN:unsigned-integer-overflow_in_lib/crypto/chacha20poly1305-selftest.c
To: Kees Cook <kees@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Justin Stitt <justinstitt@google.com>, 
	linux-hardening@vger.kernel.org, oe-lkp@lists.linux.dev, lkp@intel.com, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, 
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>, Arnd Bergmann <arnd@arndb.de>, llvm@lists.linux.dev, 
	Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 6:46=E2=80=AFPM Kees Cook <kees@kernel.org> wrote:
> On Tue, May 27, 2025 at 11:14:27PM -0700, Eric Biggers wrote:
> > If this new sanitizer is going to move forward, is there any sort of pl=
an or
> > guide for how to update code to be compatible with it?  Specifically co=
nsidering
> > common situations where unsigned wraparound (which is defined behavior =
in C) can
> > be intentionally relied on, like calculating the distance from the next=
 N-byte
> > boundary.  What are the best practices now?
>
> Hi, yes, this is still under development. I tried to make it hard to
> enable accidentally (not via COMPILE_TEST, not UBSAN-default, etc), but
> we (still) don't have a way to disable configs for randconfigs. :(
>
> We're hoping to see Clang 21 with the more versatile Overflow Behavior Ty=
pes:
> https://discourse.llvm.org/t/rfc-v2-clang-introduce-overflowbehaviortypes=
-for-wrapping-and-non-wrapping-arithmetic/86507
>
> and our current testing is showing many fewer false positives. (Having
> run syzkaller for weeks now.)
>
> > Documentation/dev-tools/ubsan.rst says nothing about this and only ment=
ions
> > "undefined behavior", which this is not.
>
> Right -- this will get extensive documentation before we move it out of
> its development phase.
>
> I'm not sure how to enforce "don't enable this unless you're developing
> the Overflow Behavior Types" with current Kconfig, given the randconfig
> gap... I have some memory of Arnd doing something special with his
> randconfigs to avoid these kinds of things, but I can't find it now.

You could depend on CONFIG_BROKEN, the canonical "if you enable this
and stuff breaks, it's your fault" flag?

Or if you want something even more explicit, maybe something like this
would do the job, so that you have to set an environment variable for
the kernel build to unlock the feature? (To be clear, I'm not fluent
in kconfig, and this is almost certainly a terribly convoluted way of
writing this - if you like the idea you should figure out the proper
syntax.)

config VERY_BROKEN
  def_bool $(success,sh -c 'echo $ENABLE_VERY_BROKEN_STUFF | grep "^y$"')

config FOO
  depends on VERY_BROKEN
