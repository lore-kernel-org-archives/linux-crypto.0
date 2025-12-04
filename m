Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932F429E114
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 15:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764862301; cv=none; b=jHtYQk8inxYcQ7FySH8k/NdCZPhNKFGUZkDgC0xP+4ICAx+HGbxYO3AXOsRKW0zb18ztaAANFhiNs0cD/aT55b+2EoQsmvV/iHyYpthN0q1jvb3W4J+ZJRV9lG1GXlvJqxbw45DkPJ2loAUKZv8RTWWLrXr/VjVlggSPHfPk/q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764862301; c=relaxed/simple;
	bh=POTlX6ISPXXEWpjlfGwt41tj3VGCl5g++BEcuBlKXmw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lZLjnuL/nicoBUR/F4ZGnZKvwkHxzKPU1Lyqi+kZoK7tgMj/VWVBV/c7onAfv7P2UBs6LLy4q0OgDL0p5G8BBAC4Tk0qPUx1v2dlcHh8LlAm/T04x0U2azbHcG/xwzCcx1Lhyzx0B/Ql4S4il7BXOUrx7QG1H5qcCwaUVxMRte0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hNwvpyYC; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hNwvpyYC"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b735487129fso152286866b.0
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 07:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764862298; x=1765467098; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=POTlX6ISPXXEWpjlfGwt41tj3VGCl5g++BEcuBlKXmw=;
        b=hNwvpyYCP6NWJkX6DaDCbbTTj8YfQBxiD3vZyJsJfLDgr0+dkupuPRbBQ3hjkojDvI
         FxW/Dn6iRrK0pFgfAxIGybbuFe7M4+aT5T6Po1NphYs5RJ0NQGr6a1dksXur1P2Jr8ST
         3iCb3uHPGaPeVNYL7woaOlgq1OZ1SIZYC3wZ5B4i4sgHYdO3/JRqumqjWhflG19a321F
         GV6hlEUi4pxJrnGR7QyW1sQWE9r/bwbfXIUWtBBpgUDSHPqR7c2i6urwKfRfsrtSJnPS
         yRFgZwtfmiYyN3dUoJybDm16mO4Ds6IIaxKNIHYVFnniVTq7FlyW4PjSN5QlKloYwnOG
         /c3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862298; x=1765467098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=POTlX6ISPXXEWpjlfGwt41tj3VGCl5g++BEcuBlKXmw=;
        b=cKiFpGEwAZHOS8AG3zCm944eph4JSRNGOFQ+dmM2XTLkj33dTDS5p4tUWiqeWmzxzn
         3PCdlkGsk0VyZ89ZcpAMdOPla/5D1kZ5KGehblbG0+FQBzbfenEv8rWQHR14KPWosiTH
         66KxAGpYbHAxImm8d5lUO4Z/BBEI/PGtwcYi0WCSx0AGIMNQoQCBUboFzhlZjgpFAjvk
         I5IRd7Bh9ELQNIsFxyWa7V7E1S8EGxqZ8FwOtuvVKf028FFMRwng0JBEsO7U7cJwQZxG
         EuSmtN8ZxbQuk5b8aGMpG91rQR/QyyNDCdSUpWCKwcPVpYlCeYI2lGqvD1a1pHmJw/Ld
         7FsA==
X-Forwarded-Encrypted: i=1; AJvYcCXjuKS9i8SMR58IJKwDa3nAJfJWXv4H3VvBJNARPC31AaUX4XY3+XNchs2VEuMwkJfM/IqVXxWk5KjuFSg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4nprjqF+Qu3bkm0JWeBz4PPiF4tum3wOGMb3BfTnFR0Iz0IUM
	kumTq4Nn3zWdKagEefIX0ajP35AM3c6BbnA32jSFSA5K8m2lhPP2iIz9OJCkjxI0wGgC/uaev/4
	PUFg5QA/IiEDnePlNY8WMprlRP+RKMOg=
X-Gm-Gg: ASbGnctuRQy4aaUD3uq7M71cihaWwk3QbZw8lMRIk0dkwoEqlUDBpYWgIZ2Xcayd72D
	d0dZRnySo2Ud58j0hL/P7mi323bbPaayQ/K0hxEnuEjz/SlTwyCwfhQcwU0Qxyn2xNZkebcOiUi
	c00sy60neEv3Ow2c1N4stYtXH0Z9XehKVoppq81zKTQklGr5ryutmoXmacOKBI/XgvdTcJty9P3
	0SU6Eivyymd7PxYh7vx/OFaSEK9p5gfbp8QRU0xHp4G4rqrH+v8WCctlnMYbLrD7JAx/1C2CY+0
	INtduaxeelcBwaXs4KXCpxDO+FKuhYP5MjvkoBnrO0Tk0910temRi+jv72Wm1k7rJDSl78w=
X-Google-Smtp-Source: AGHT+IENRfMe6T9wqDS/PoUZtjNDj8ACh6Vacb1wpcUt4B4CeOHB7XDWM2IT6MHbrsb7tHai7cfQga2AdduHQ3E5aFo=
X-Received: by 2002:a17:906:d54d:b0:b74:9833:306c with SMTP id
 a640c23a62f3a-b79dc777cb2mr731791366b.47.1764862297473; Thu, 04 Dec 2025
 07:31:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-2-ethan.w.s.graham@gmail.com> <CA+fCnZcvuXR3R-mG1EfztGx5Qvs1U92kuyYEypRJ4tnF=oG04A@mail.gmail.com>
In-Reply-To: <CA+fCnZcvuXR3R-mG1EfztGx5Qvs1U92kuyYEypRJ4tnF=oG04A@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 4 Dec 2025 17:31:01 +0200
X-Gm-Features: AWmQ_bkuYb6owVWFxIAiek-YuFB5R-dRF0smhrRgpbJbH_xsE9jvhcY-L55PbKY
Message-ID: <CAHp75VeARk=pm_R10K1bEoCuV+32HgV3ZvQCNVs4D2_2W3B_Tw@mail.gmail.com>
Subject: Re: [PATCH 01/10] mm/kasan: implement kasan_poison_range
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 5:17=E2=80=AFPM Andrey Konovalov <andreyknvl@gmail.c=
om> wrote:
> On Thu, Dec 4, 2025 at 3:13=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gma=
il.com> wrote:

> > Introduce a new helper function, kasan_poison_range(), to encapsulate
> > the logic for poisoning an arbitrary memory range of a given size, and
> > expose it publically in <include/linux/kasan.h>.

publicly

> > This is a preparatory change for the upcoming KFuzzTest patches, which
> > requires the ability to poison the inter-region padding in its input
> > buffers.
> >
> > No functional change to any other subsystem is intended by this commit.

...

> > +/**
> > + * kasan_poison_range - poison the memory range [@addr, @addr + @size)
> > + *
> > + * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE,=
 defined
> > + * in <mm/kasan/kasan.h>: if @start is unaligned, the initial partial =
granule
> > + * at the beginning of the range is only poisoned if CONFIG_KASAN_GENE=
RIC=3Dy.
>
> You can also mention that @addr + @size must be aligned.
>
> > + */
> > +int kasan_poison_range(const void *addr, size_t size);

And also run a kernel-doc with all warnings enabled and fix the
descriptions respectively.

--=20
With Best Regards,
Andy Shevchenko
