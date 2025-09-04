Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3962264B1
	for <linux-crypto@vger.kernel.org>; Thu,  4 Sep 2025 08:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756976053; cv=none; b=dH7I+Vz0U9u0cnPYeRuWL/yuh9V8Cr5DmzBf9A3TtUWUveFS1P4rpwOgz1D5PGxJBEzcS/9fUfRTUM2kEO5ZnHT3MfcglGwhefQGISrDQjyoGGfhHnTYUKEOPNH2JoGvbTPTDX0+JJ+2ed5lsvLZnnCeXDBzHI43tapRIHCxI7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756976053; c=relaxed/simple;
	bh=mqwfnzwdPC+2dqnEr2ojVooFfW44hUm7NW1fZIerdNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l3bCNeFEsMM0G+5S1Yx0QZdpm2uvK4xu+9pYh+s6FJXWhFt5hH7C3FiMvRStV9WlxCVTTMx7fqGou9NosEFsC1D8HBvK818yIcZIxBpJluh5H/pVvoHwhwEDF1H4BY3CIYkLg21tT/9Ucz+wSRazd0OfSeSvk/TVNjAWaUEx5tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bj9GJCC/; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bj9GJCC/"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-70ba7aa131fso8262496d6.2
        for <linux-crypto@vger.kernel.org>; Thu, 04 Sep 2025 01:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756976051; x=1757580851; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9VicjXT4pdNAgXdUSH6UsBDRLh+o/JYSTnI74S8PEYQ=;
        b=Bj9GJCC/CAdL5wyTDFY9eemfix8LX6IxXPKVm0pv9hGApoZzca9QcM4YpkMwV9xla9
         GjMnjGS95D2vIjMYmhxgRjsIVbWNEFFwL0pGO2wJ27myvV186qoVT8CJQp4D8snLmuVC
         8YAtQjPrNEe8c6CH8ZJNz+mLfvQhZOJKltF5p5qFtigv23oo3vgTGzxcWKx74dX8NRua
         G6QnEq9w3zpiziIz0ZDyz0CbuHmNGHiWjZFZemPOyY4RZbdJLKvMejJ5r1Atx6PqsXdj
         EnvGlwtzTEjnI8i7I97+m/W5eFKECJyMjJ49Bl+jquYZQcYalX9YcF0tzLcMa0gt6KHQ
         bWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756976051; x=1757580851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9VicjXT4pdNAgXdUSH6UsBDRLh+o/JYSTnI74S8PEYQ=;
        b=T4Zp9icZTrEcl6NVV0alACziYaC3tNTYcwCObNHTStF/JRYrvg643CfNPwcKNAiDYT
         CIrQorlJIrq2VMa1XJ4gy3SKX0NIlpM1jv68kPGXVhjafLctHRgJhhHJlV9AU4Q0YAHM
         4oWgsdqB0UVP9bc/Zgw1LPxng+AV0TDmvrAj+6JmovBs13nh29rPTsSFl7wKW/vRaLC5
         nlmWO4hBA1gQS9g3ihCEUJiEvAbjMkPiDLDtswJ8BcuDkfBzCxZO7D6HHDsVTjJRIykB
         whKygvPx717f/VD3lTVT2oLnVTyQoPmFZVCdhLTFSPDDkSnNHDVWas0hseOWrRDhKzrI
         fJLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMsyRe8vz/SIYTsfwPjXg9s58vOtNK9Hp1Cy+RGZBMsM8hkRjJxN3R8RiF09jzkb9BZHk+33h+TMJSRQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXnI62HYx6kE+w4DtwQopjMcBunxOz7sTriugdFgcyei+a18/z
	kOV93rVnaG1k2zTYVlFBNNa13lhu8JeHFr0WZeWbmnyJTIiYUEWnfNPRKbToisAbVc+nnvz6pL4
	jzaqvItO7WVQSQQ+Yzf4CS5QyCFTqgv2uMUxLGfys
X-Gm-Gg: ASbGncv5Hr1zn9iiJxNSDOW+h1SC3gapQjmesSWZNSJg61KsJrMqE6dTYkVttF19X/S
	bSVQW96qPM/Dvo0MmY/xSTbfe2TZZJRQWoil34IuU5HP7zr6mwy1lXSbEX0AfUTlJeT+F8+fQW8
	CZcMeE/3XQymLffZ2Q9HqvzMPPAGs5W+SW8Et/2ncWWwsHEyrWjvBUbbvZKVDUReo77o/hDAuf7
	Mz8wcRMVVxVvZLeK5qMtH7UgA7MJNIoDFyN4u7oTrQ=
X-Google-Smtp-Source: AGHT+IGe+3QGfd9IKV2sPPBcSKIkB+warv0bCWnhX474CyKZjMxan/mTdhVbYwwEQVkV0lnKX5ceY3UjV6CSO+x3hLI=
X-Received: by 2002:a05:6214:19eb:b0:723:255a:9168 with SMTP id
 6a1803df08f44-7232569d525mr82498246d6.4.1756976050489; Thu, 04 Sep 2025
 01:54:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-6-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-6-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 4 Sep 2025 10:53:32 +0200
X-Gm-Features: Ac12FXzGXGcfd1LWU7AL2P0uHHVI9Cjfbatglasugt3XjpaIrqiLrO1UVJEntQs
Message-ID: <CAG_fn=VBbSqb07-pbbEw7F=SP5_t74Re7ki0+ZS=mBm2S9BehA@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 5/7] kfuzztest: add ReST documentation
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 1, 2025 at 6:43=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add Documentation/dev-tools/kfuzztest.rst and reference it in the
> dev-tools index.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Acked-by: Alexander Potapenko <glider@google.com>

Some nits below.

> +Macros ``FUZZ_TEST``, `KFUZZTEST_EXPECT_*`` and ``KFUZZTEST_ANNOTATE_*``=
 embed

Nit: missing second backtick before KFUZZTEST_EXPECT_


> +Input Format
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +KFuzzTest targets receive their inputs from userspace via a write to a d=
edicated
> +debugfs ``/sys/kernel/debug/kfuzztest/<test-name>/input``.

Nit: "debugfs file"?

> +- Padding and Poisoning: The space between the end of one region's data =
and the
> +  beginning of the next must be sufficient for padding. In KASAN builds,
> +  KFuzzTest poisons this unused padding, allowing for precise detection =
of
> +  out-of-bounds memory accesses between adjacent buffers. This padding s=
hould
> +  be at least ``KFUZZTEST_POISON_SIZE`` bytes as defined in
> +  `include/linux/kfuzztest.h``.

Nit: missing leading backtick.

> +
> +KFuzzTest Bridge Tool
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The kfuzztest-bridge program is a userspace utility that encodes a rando=
m byte

Nit: do we need backticks around kfuzztest-bridge?

> +This tool is intended to be simple, both in usage and implementation. It=
s
> +structure and DSL are sufficient for simpler use-cases. For more advance=
d
> +coverage-guided fuzzing it is recommended to use syzkaller which impleme=
nts
> +deeper support for KFuzzTest targets.

Nit: please add a link to syzkaller.

> +
> +The textual format is a human-readable representation of the region-base=
d binary
> +format used by KFuzzTest. It is described by the following grammar:
> +
> +.. code-block:: text
> +
> +       schema     ::=3D region ( ";" region )* [";"]
> +       region     ::=3D identifier "{" type+ "}"

Don't types need to be separated with spaces?

> +       type       ::=3D primitive | pointer | array | length | string
> +       primitive  ::=3D "u8" | "u16" | "u32" | "u64"
> +       pointer    ::=3D "ptr" "[" identifier "]"
> +       array      ::=3D "arr" "[" primitive "," integer "]"
> +       length     ::=3D "len" "[" identifier "," primitive "]"
> +       string     ::=3D "str" "[" integer "]"
> +       identifier ::=3D [a-zA-Z_][a-zA-Z1-9_]*
> +       integer    ::=3D [0-9]+
> +
> +Pointers must reference a named region. To fuzz a raw buffer, the buffer=
 must be

Maybe insert a paragraph break between these two sentences?

> +.. code-block:: text
> +
> +       my_struct { ptr[buf] len[buf, u64] }; buf { arr[u8, n] };
> +
> +Where ``n`` is some integer value defining the size of the byte array in=
side of

s/Where/, where/ ?
