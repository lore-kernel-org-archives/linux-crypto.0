Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D0033F8DE
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 21:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766178602; cv=none; b=OLu1JKI4PX2pVjzkqsaKss2SupnJEOGaHsCQHTFVmVtSG+c32EuPCGHxEfG8lS0Q/8Y8yditl/o97d13Zbt7DkZrnJMalpDxLKPf3XC0r9BvSP8O/kBivviNn4vdMbyTh5h1qwXCCS0+haMerOZPhgJwuBUIsxWaKukfgBiI8do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766178602; c=relaxed/simple;
	bh=iqhEYrpWgm5Yfz8pxMwX3Z8XLhEcxpfARdS1KcSLhis=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YkiWWJM/GgwD7PgDh5+wLUC4lGInl8e8Uh+gTVVyjfLGADkr+QAS6V+RVjE2Fr70sF7batYt+kTUQ+iSp0tLPG0uguV+CcVqG6HP7u2mkDQhW3VF7FDYVK31mya+HH5oIAyfd8f7MAjg2f8rMYLSO6oPYf1zSY9Vz0IbzKtq0S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PwDuScq5; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PwDuScq5"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7b9387df58cso3623815b3a.3
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 13:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766178600; x=1766783400; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iqhEYrpWgm5Yfz8pxMwX3Z8XLhEcxpfARdS1KcSLhis=;
        b=PwDuScq5uKrCO6abf4MvGNoS2mKDzBjKYJ0bmhTBciEbsfEZPL8W1fZ5ueco+n190+
         qC1SNl5YEtS1IdQ/tG+2hrFXMcLWkoZNRGb7WSoFCc3nf3uyQ0oYiWaIk9rZT3MVChUE
         76yw3iWuODcst7Rk/h8qgT9xHw66X0aJxXevk9+1fAOZCe4xf+4eA/c8FafVYwoKBlU5
         KUvXkGaunNgrVUUi3o22zWzLA1Uke1H2puCSY69VY/PPYf9W/kL2ph8YcbNGmF8Nyw98
         uf17JPqE8ARf2s05s+jtQV6IPGBqoEcmOsvlG3wXi4bjlQhVclB4y6KQ7Zl/NZVJ+D+O
         cKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766178600; x=1766783400;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqhEYrpWgm5Yfz8pxMwX3Z8XLhEcxpfARdS1KcSLhis=;
        b=eCpPS0nD8PhmmYwBqoo0DgUnUJFJHzBH5D8D0GxHKmhZJSLoPNk5P5BYRYkwdThBI2
         XNSz2+Czk9pnbcensjmQ6vhH4HcF7nyZn1gdgvGKCUNayvcudHqnwt6PZW0IClQ5b+aj
         QTONYW1tv8WnXlCWk1kZCXGukyUNns2kH6ZmLJGRVJbwwbf8bv3X4C0OthZTFiG+XgaT
         tPqT9vw/YGT+TbrSOAZtFny3FugoEcaSuxutF65e7gY5nKwsqyN4vDfU5zi/hKiQo/AF
         CO1SQszDcTSlalgx9Zjno+yvdwCEJRwYMWn1nZb6O6CUHQHuMjBPvm8DYMKfVnv+mZA0
         nXhA==
X-Forwarded-Encrypted: i=1; AJvYcCVAyNYZO5WW0xgv0238HVQFxB8yLQYI9K3gDTr5Fz5sKvOb2il1P07pVqt6Y0dKqkSxwMlNAyoPHDZRpvc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzefCm3n7T9MCjxojneFsfK/x3Js28VYh94/G127nWUTSBPlDYl
	JX+OTWTl7zt2hyfVLMUrCzrwWxVYPf7FnG/hTnWyfq+OLV0xqAiedRTliGRuZ8ix+7qnJP10GJ3
	ysovCidH4b5p4LOmhuXwkR8VRzuOgGiOEpHlvrvJS
X-Gm-Gg: AY/fxX4HkWuelc4sDlrbdFYT9s2JI9Q45l1v9nMhUQiq8h8UoiS91mu9Fyj+8u4dRYr
	Dfc8ziZzr0SE1CaQP7IvhSx/ka0q0zalgjNCp/1kN/nqLOs6qfZc00FHIBkCyuVpQ6TAK6gceiY
	EEPmD0YxHORVVMTLe2Mr24QSNBgO6ywWrTuUcg1Rvb8lfwQgdfAa8zFrfeCUY7SddTEVuXz+aoC
	j4ISKOUApXITNbqIJXiXURa3MnC+HizHeVgqJlTNNAehVm/Wexcikiz9f3gTyU+x8PpmRjh0Q3Y
	MDrdxKR7UEPFANfMVVKMHxwlCPA=
X-Google-Smtp-Source: AGHT+IGdr0jH8cGEaDB7eA0QDwFP/5Ve8WscN7cZkV8XMcvDcmhs6BtuLqrVUM3kTfn7w87OZJ/+kODUMJAxXUcmHFc=
X-Received: by 2002:a05:7022:ef0b:b0:11b:9386:7ece with SMTP id
 a92af1059eb24-12172309509mr4284248c88.43.1766178599422; Fri, 19 Dec 2025
 13:09:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-14-elver@google.com>
 <3b070057-5fda-410e-a047-d9061d56a82f@acm.org>
In-Reply-To: <3b070057-5fda-410e-a047-d9061d56a82f@acm.org>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Dec 2025 22:09:23 +0100
X-Gm-Features: AQt7F2racRCVQBtX1XHCEqHFLvRozCqLgqx9fCp_0Wp28A2qceHYZ0Bj23R_eEk
Message-ID: <CANpmjNN6QrxwUUkpAopTfxLwUqGfB53J96dwOWHNcoYrOrEocQ@mail.gmail.com>
Subject: Re: [PATCH v5 13/36] bit_spinlock: Support Clang's context analysis
To: Bart Van Assche <bvanassche@acm.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
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

On Fri, 19 Dec 2025 at 21:48, 'Bart Van Assche' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> On 12/19/25 7:40 AM, Marco Elver wrote:
> > +/*
> > + * For static context analysis, we need a unique token for each possible bit
> > + * that can be used as a bit_spinlock. The easiest way to do that is to create a
> > + * fake context that we can cast to with the __bitlock(bitnum, addr) macro
> > + * below, which will give us unique instances for each (bit, addr) pair that the
> > + * static analysis can use.
> > + */
> > +context_lock_struct(__context_bitlock) { };
> > +#define __bitlock(bitnum, addr) (struct __context_bitlock *)(bitnum + (addr))
>
> Will this cause static analyzers to complain about out-of-bounds
> accesses for (bitnum + (addr)), which is equivalent to &(addr)[bitnum]?

Only if they decide to interpret never-executed code (i think the
kernel has various dead code that's optimized out that might trigger
static analyzers if they analyzed it).
But this could probably be improved by using a different idiom, and
using an empty inline function that takes bitnum, addr as args, and
Clang simply takes the call to that function as the context lock
identity.
