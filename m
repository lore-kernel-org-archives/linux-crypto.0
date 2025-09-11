Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82C52E7F13
	for <linux-crypto@vger.kernel.org>; Thu, 11 Sep 2025 09:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757581798; cv=none; b=o9/hMReCfCZIYyVsWfWjBIvxwM1z9XreTd5Bc1S/NaVWNrqjHF5OwcigOJCMRwRIazdKJ6eo6/i3c5FUrv9wlVs+Zu37gk9RBXP42snBdhLTRbnEHdN1Ty+WXr0Pg+nT35eA/zE0xU3HGY6ZQtZzKfyT1O4u0vEGxIdkjyhOp9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757581798; c=relaxed/simple;
	bh=dcE0SznU9PyCabtb+Z2XmvyG0XBdfDSeKArLLjJbTDc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bii0fuaT8WPBXILP09DAj0hhk861vYEhXCgyrP0BLbIX3SK3gHMKJEtxL29KhujeCJ+dFSVus6yjAzaiwhVokprY4yqNQLVDTvMu+znY5EZHRrzRe05OTdB1DGHM514Ar6to6zcMFqjB4DV2d1knsCooDEU/WhnGCTul16BxMCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3JHGqwgl; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3JHGqwgl"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-7211b09f649so4491056d6.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Sep 2025 02:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757581796; x=1758186596; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=110hIxZl/DIKAtkNXDUZdekwbiGKdHIJpSsuT6OGVlM=;
        b=3JHGqwglbARDdmktvjjOaElzPmFC9qrBnyeBo+y+X/182Cwg46n9lLm3t4hZcYYLnf
         ykSx6ABN2t5X8ze5j30wdg9VcrVzigYQ4+twy0FzWkK09gyfMpWYfebVFhtOGVOsCV6c
         JMW2v8j4o4NaPP1uyKSoixsOzVvjkPrZFcgKtKKHcNSA181PD0FYDXF5FKX9f01jFeLm
         efPXTaq66bimw33larVkEEXA6RqQMsPnZ1WMC0CvEIyAJsr5nJ43qeG/i7W5CzACP277
         janPKaBcqrEf42iveJJsu3mMMi0d6W7STqg+kxoXJfCkgjMcIfGC9R5+Nk/+i6PY5Frw
         D09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757581796; x=1758186596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=110hIxZl/DIKAtkNXDUZdekwbiGKdHIJpSsuT6OGVlM=;
        b=kVQkEhdsvCg4y8p5TpSWVCqjh8SLjOaaPflqNv5BKfrjVPNIiWYTMsBzr2icxPC3j6
         EPVDT+zD1ZF2G64PA7FCaYqftCBzWMuhm3qc9LGsVwjL67npjtFwYTR/Z11Vu93A8G6w
         JrjafDbIkJJcX2wMFGJ4e5nNsHhI/rPCjrdzlEo27GzxLLm/S4vH/AtSn0zosJ5oAJ72
         MjQk7Y1RxoRBIwJr4DCRO7aWaSddB6S7WyuXdWHWRq3HRhD767qs3727aHAIJSb1FPlM
         gjoM8smGno1dD1VKd3VypD9NX3EReBl8vJJQBrpPja9Mk3btPmpkTK7IUNeGckaQVjsS
         Cy7g==
X-Forwarded-Encrypted: i=1; AJvYcCW0UehkRggveqJj8cXAb9+M41IGKhBGsM5iT6v8grw7WwaxLKkp74/nCK1Uugw8Fzxk9Ac2MaoosQJFUD8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyE+lW7PgF3uysKRJJOszgHAAKRV8BJqFz7hDGMokK4hrykHDWp
	WmxRwfb17bCYO98NApfX/Ja+7XRk8qYoak2sHhpBLOhV6uPa9KIOtgtsW6d676eRfnNJfetk1co
	daq3QMvGYQ+YMQylVCHVV4QIyYGbC08xxqP8kKwgY
X-Gm-Gg: ASbGncvK4N+JcHzRDvJ8eCiA2Ybog5EDg0PWNzFZsIcXW/obAhGlxVQnxCU0P2vdDp4
	9owtCVflXR29NOjhpaI1bHaJVs6P8DmLlDYPg9MsnPrKGP6LYhWW/kZOWFzWrRWQQwCI57FjlXS
	4ApnV9QyHtfp8FablSqYpPgPBGKBlG4F2RLpXN2gRthpcdqynoV9NRQAGCU1Ojgfgr9rAtwGGOC
	fyUaCmm5zgdlBnWn9BpQj8LCF/149DpgnTh78ebX+oMbVDUa3MiqMI=
X-Google-Smtp-Source: AGHT+IHgGWXglu0DsqRQzQThUm92HQPN78KOj9YY4D2b+CMNT6C+6XgOPmNb4DnIeOzj1OW6pcFMvY1Iuj4xjLps2oM=
X-Received: by 2002:ad4:5ba3:0:b0:70d:eb6d:b7ea with SMTP id
 6a1803df08f44-73940411c14mr198047276d6.33.1757581795396; Thu, 11 Sep 2025
 02:09:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829164500.324329-1-ebiggers@kernel.org> <20250910194921.GA3153735@google.com>
In-Reply-To: <20250910194921.GA3153735@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 11 Sep 2025 11:09:17 +0200
X-Gm-Features: AS18NWCx4E3OdC7mBgPGgVUBUT-xLxLcqqp44Vqxj-OTHUNQdAnrn9pPMhbFdkc
Message-ID: <CAG_fn=W_7o6ANs94GwoYjyjvY5kSFYHB6DwfE+oXM7TP1eP5dw@mail.gmail.com>
Subject: Re: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
To: Eric Biggers <ebiggers@kernel.org>
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com, 
	Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 9:49=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Fri, Aug 29, 2025 at 09:45:00AM -0700, Eric Biggers wrote:
> > Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> > kmsan_internal_set_shadow_origin():
> >
> >     BUG: unable to handle page fault for address: ffffbc3840291000
> >     #PF: supervisor read access in kernel mode
> >     #PF: error_code(0x0000) - not-present page
> >     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
> >     Oops: 0000 [#1] SMP NOPTI
> >     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G             =
    N  6.17.0-rc3 #10 PREEMPT(voluntary)
> >     Tainted: [N]=3DTEST
> >     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.1=
7.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> >     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
> >     [...]
> >     Call Trace:
> >     <TASK>
> >     __msan_memset+0xee/0x1a0
> >     sha224_final+0x9e/0x350
> >     test_hash_buffer_overruns+0x46f/0x5f0
> >     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
> >     ? __pfx_test_hash_buffer_overruns+0x10/0x10
> >     kunit_try_run_case+0x198/0xa00
>
> Any thoughts on this patch from the KMSAN folks?  I'd love to add
> CONFIG_KMSAN=3Dy to my crypto subsystem testing, but unfortunately the
> kernel crashes due to this bug :-(
>
> - Eric

Sorry, I was out in August and missed this email when digging through my in=
box.

Curiously, I couldn't find any relevant crashes on the KMSAN syzbot
instance, but the issue is legit.
Thank you so much for fixing this!

Any chance you can add a test case for it to mm/kmsan/kmsan_test.c?


--
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
