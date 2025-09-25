Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A135242D9F
	for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 08:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758789349; cv=none; b=nUN5+DbSVvLIPny+1W+17A70KhupPpdKw7Su/UUfOrnQpy0bTpfGjUEemlin4YCkWh1bfQl7uYPSJAwxv1hBwsfnOUQj8lT0lg7p30e0yJHLdyN0KsGtPRJQYlXuSOiRR34mQyMXDIkdg9h2wfJ6nALbcBznBQGUGazG37mwEQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758789349; c=relaxed/simple;
	bh=eDfizLwqAX3ps1KqSy9owcGN8dHDTaaVHlBJT/0x+IU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a8tJc3dDDcmRGGnuKMRPgiVAZLUfZ3XZUn2NbtBUTFKiC/pg1qCt1JtlHcAqNXqirGcRkR41zZh1CMV352bHqZr6r9ZvJbPAFjhdcmGrszFuxGOJTeg4CcG/a3KyTps47ceaFTD2yOIQ3e+j6cdTMfz1JIEYbaIaEIb2yOQh/qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FYB0376T; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FYB0376T"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7761b83fd01so779298b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 01:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758789347; x=1759394147; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDyXKD1mpeXok68wul2g//tY5b9PgvJaaF56RchZKHQ=;
        b=FYB0376TawJjOLYbp2TKehqZRGA0YuKM0v/mkYoPhaoC/QPbShSiNNBuV33FwIAOH9
         29BGLddN/71Slg0pbcaKD5UaPfMNWnd6HkHUJwrnuY7En33QlekBA5ZypAxwaS/jBVF2
         lIunlpciu+m6/8ZuYwXhPRLezbpNX7dzNEJ80U07X5pbWBqss4e7l3G0SCqyMPg8caMu
         SJCLWS79x3OYLE7gjABXBgnGptNzPgZ8iPOi08OP8fJKIGjI2VNp6qhdcz9j5Uh9iVvQ
         tKDtwgJZqGL9sEoCPnhu5SOC5FV2YLSHIGcSI9K8Kzu/ZiMl3uT3T4XJ6Bfhflm+RQ65
         UpEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758789347; x=1759394147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MDyXKD1mpeXok68wul2g//tY5b9PgvJaaF56RchZKHQ=;
        b=a3HzpxM+7tR8CklVokVfQhwiLS+xnUz9R7Maq7euIHam567U+AW4cimu5Ywl92cREp
         RCz8iai7Pz3IO5/BdNikk1WjpzJQ3xrkL5qLg6ZLo+6dR0RxPvkHk+939ZeA5y8zmycM
         ew3E8KgjdMw8faKp3L23O2TWKKZVjqomA6VqOtyDvggxInLo6sMJ1MmG9ocFo01bbds9
         1fILV7RYIqgUOmiYT9U3+Nr3hbJ4mRBvt/bfQtE7dJu0tP14MEEzCVadPWjm5n5fLt5n
         7gAODrfXQaGfeg4D0yUU934sQ1aIAIzgs64O3XQo/ilSzD9GtQ16Wb6PpkjaJ5jIPX6J
         Mqag==
X-Forwarded-Encrypted: i=1; AJvYcCXDQpr5FFlz7okc3cN9TTpa1GIjifRdhiQ3MP043Bz2c5sW0VUJi38OaJ3JEvXwXLU4l73EQ4t9Arn1Wl4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxI0GC3X83Nab1F92rXGdi5mVrWkNV0JladkiUT1lb6RVkXYjhs
	srNaKG/k2mAi5mIVVg29rEgaBtrwEEO3wUtTZICASxWkKj6ELxQ6RsFexk166tBdluR+7k/NVQ+
	mDrLrLcZR1RHpRvDRp1sz46NTIPIh9IY=
X-Gm-Gg: ASbGncsdUcvkWtNjtcMldAOdIBnwdZ3p22YsqJ8C/3ICFxueB570Kat7Qa5acfJsdST
	RdoCYP4r0BksaBl+V6CQo+z/ifAIjirSDnTt8ewC1f7R3YanLqhD50H6hKl0hk37+csuycSvt5Y
	ZTssijzrtYHh9+TOGyNgJZvAKjpDtHqe4SlsJGvxN5NHbZr82KXoStqBln6KLNU5sQR2K0NCchj
	pmXT4Caw/+C3nSwrm/VBr7DI3UsBfBVQiLmBA==
X-Google-Smtp-Source: AGHT+IFiKBS4LhKCc+e3TZ8akuJUR4dSaETLbnVbbjovQRnE+6jXoJciIAqdsOUJ/nrSn5d9rrftqE7Kz3oPsvH4jUY=
X-Received: by 2002:a17:903:3201:b0:26e:146e:769c with SMTP id
 d9443c01a7336-27ed4ad75c2mr30527635ad.52.1758789347230; Thu, 25 Sep 2025
 01:35:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <3562eeeb276dc9cc5f3b238a3f597baebfa56bad.camel@sipsolutions.net>
In-Reply-To: <3562eeeb276dc9cc5f3b238a3f597baebfa56bad.camel@sipsolutions.net>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Thu, 25 Sep 2025 10:35:36 +0200
X-Gm-Features: AS18NWBFmYuT702hOj_C5JBwnZByzVghQRTr5ikBT0AN32tqz1vkZcQ1S7Omg5I
Message-ID: <CANgxf6xOJgP6254S8EgSdiivrfE-aJDEQbDdXzWi7K4BCTdrXg@mail.gmail.com>
Subject: Re: [PATCH v2 0/10] KFuzzTest: a new kernel fuzzing framework
To: Johannes Berg <johannes@sipsolutions.net>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, elver@google.com, herbert@gondor.apana.org.au, 
	ignat@cloudflare.com, jack@suse.cz, jannh@google.com, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 2:52=E2=80=AFPM Johannes Berg <johannes@sipsolution=
s.net> wrote:
>
> On Fri, 2025-09-19 at 14:57 +0000, Ethan Graham wrote:
> >
> > This patch series introduces KFuzzTest, a lightweight framework for
> > creating in-kernel fuzz targets for internal kernel functions.
> >
> > The primary motivation for KFuzzTest is to simplify the fuzzing of
> > low-level, relatively stateless functions (e.g., data parsers, format
> > converters) that are difficult to exercise effectively from the syscall
> > boundary. It is intended for in-situ fuzzing of kernel code without
> > requiring that it be built as a separate userspace library or that its
> > dependencies be stubbed out. Using a simple macro-based API, developers
> > can add a new fuzz target with minimal boilerplate code.
>
> So ... I guess I understand the motivation to make this easy for
> developers, but I'm not sure I'm happy to have all of this effectively
> depend on syzkaller.

I would argue that it only depends on syzkaller because it is currently
the only fuzzer that implements support for KFuzzTest. The communication
interface itself is agnostic.

> You spelled out the process to actually declare a fuzz test, but you
> never spelled out the process to actually run fuzzing against it. For

Running the fuzzing is more of a tooling concern, and so instructions
were left out here. For the interested, the syzkaller flow is described
on GitHub: https://github.com/google/syzkaller/blob/master/docs/kfuzztest.m=
d

> the record, and everyone else who might be reading, here's my
> understanding:
>
>  - the FUZZ_TEST() macro declares some magic in the Linux binary,
>    including the name of the struct that describes the necessary input
>
>  - there's a parser in syzkaller (and not really usable standalone) that
>    can parse the vmlinux binary (and doesn't handle modules) and
>    generates descriptions for the input from it
>
>  - I _think_ that the bridge tool uses these descriptions, though the
>    example you have in the documentation just says "use this command for
>    this test" and makes no representation as to how the first argument
>    to the bridge tool is created, it just appears out of thin air

syzkaller doesn't use the bridge tool at all. Since a KFuzzTest target is
invoked when you write encoded data into its debugfs input file, any
fuzzer that is able to do this is able to fuzz it - this is what syzkaller
does. The bridge tool was added to provide an out-of-the-box tool
for fuzzing KFuzzTest targets with arbitrary data that doesn't depend
on syzkaller at all.

In the provided examples, the kfuzztest-bridge descriptions were
hand-written, but it's also feasible to generate them with the ELF
metadata in vmlinux. It would be easy to implement support for
this in syzkaller, but then we would depend on an external tool
for autogenerating these descriptions which we wanted to avoid.

>
>  - the bridge tool will then parse the description and use some random
>    data to create the serialised data that's deserialized in the kernel
>    and then passed to the test

This is exactly right. It's not used by syzkaller, but this is how it's
intended to work when it's used as a standalone tool, or for bridging
between KFuzzTest targets and an arbitrary fuzzer that doesn't
implement the required encoding logic.

>    - side note: did that really have to be a custom serialization
>      format? I don't see any discussion on that, there are different
>      formats that exist already, I'd think?
>
>  - the test runs now, and may or may not crash, as you'd expect

>
> I was really hoping to integrate this with ARCH=3Dum and other fuzzers[1]=
,
> but ... I don't really think it's entirely feasible. I can basically
> only require hard-coding the input description like the bridge tool
> does, but that doesn't scale, or attempt to extract a few thousand lines
> of code from syzkaller to extract the data...

I would argue that integrating with other fuzzers is feasible, but it does
require some if not a lot of work depending on the level of support. syzkal=
ler
already did most of the heavy lifting with smart input generation and mutat=
ion
for kernel functions, so the changes needed for KFuzzTest were mainly:

- Dynamically discovering targets, but you could just as easily write a
  syzkaller description for them.
- Encoding logic for the input format.

Assuming a fuzzer is able to generate C-struct inputs for a kernel function=
,
the only further requirement is being able to encode the input and write
it into the debugfs input file. The ELF data extraction is a nice-to-have
for sure, but it's not a strict requirement.

>
> [1] in particular honggfuzz as I wrote earlier, due to the coverage
>     feedback format issues with afl++, but if I were able to use clang
>     right now I could probably also make afl++ work in a similar way
>     by adding support for --fsanitize-coverage=3Dtrace-pc-guard first.
>
>
> I'm not even saying that you had many choices here, but it's definitely
> annoying, at least to me, that all this infrastructure is effectively
> dependent on syzkaller due to all of this. At the same time, yes, I get
> that parsing dwarf and getting a description out is not an easy feat,
> and without the infrastructure already in syzkaller it'd take more than
> the ~1.1kLOC (and even that is not small) it has now.
>
>
> I guess the biggest question to me is ultimately why all that is
> necessary? Right now, there's only the single example kfuzztest that
> even uses this infrastructure beyond a single linear buffer [2]. Where
> is all that complexity even worth it? It's expressly intended for
> simpler pieces of code that parse something ("data parsers, format
> converters").

You're right that the provided examples don't leverage the feature of
being able to pass more complex nested data into the kernel. Perhaps
for a future iteration, it might be worth adding a target for a function
that takes more complex input. What do you think?

I'm not sure how much of the kernel complexity really could be reduced
if we decided to support only simpler inputs (e.g., linear buffers).
It would certainly simplify the fuzzer implementation, but the kernel
code would likely be similar if not the same.
