Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F464376E0
	for <linux-crypto@vger.kernel.org>; Sun,  7 Jul 2024 18:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720376407; cv=none; b=dSdYxhtIckKOGVaj08fwJzdCVzADz6e4eNhZ5QomBu2Z3iLtExSxGhkJ7Q0aexFPEuwrWmSM87lVBHFaYuFR0nYy0k7NHEhmFLPCAx60UfxdcUm0d6SaXf56TUAnACXsGoVBM7LYj4OI3d8keUkR/6AviVd9S2N2ZjFvmxih1sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720376407; c=relaxed/simple;
	bh=IgVGCT2xxQj0d6AEWv1d2oISYtXfXK5QvKatWJYOnV0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hyP9F8C3iFvtqBhPGXUgy8y5Mg4+sCZ8UExQMBZCSeKhrVfu8taxphN2kQTGA6jKzKGUxl1jrB9nV+VLIhHJRuAz/2JwLFkxZmkDMlGrhfEDwdeHV75qwqYHIigjN902NXajMlbRLvqp4W4YgJt0ZYyLMyok6wXqDncghRFR5Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OtnvDFwN; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OtnvDFwN"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-58b447c511eso3976390a12.2
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jul 2024 11:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720376404; x=1720981204; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5v0Nkh0XR+jIko5z42PL5jDgcJnA00NhojDwz4yKzQ4=;
        b=OtnvDFwNsYv6zEsIeeKcxWS5u7WCwSKpU2ArUPjM55V0TKxMVYUNkLQQlueSlTCDMQ
         RCkd8L0yoW3hhyZpaulYwt1f1XmC5/m62F0EWirtaamOY1I5Hl1Eo0OTq6JDc2XvTXd6
         juIIdgXRZTCVeSFmbRiSnLrd3oxi/D0svkpq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720376404; x=1720981204;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5v0Nkh0XR+jIko5z42PL5jDgcJnA00NhojDwz4yKzQ4=;
        b=lGMSmWr2FgdjvlGyvaen1Pz9jCTDlo/Dc/UbG3BTKST5rU8Vi/nVNCqML1K/WlRVHh
         J8E4r5CQMxTaU/iChRJjfc69yA48WedKELdmr/2ksrlUYRtMYYOdrasO8GsAk2x5titw
         NtAA1Wca65dCS/lAO/3TX5qoZyyophsqe97RkvdufbqAeYWl/+EH2t8XTH1+of6wGb0b
         Ion8NIB+M1PF3n4THNR9Fnhvmk+djhgRYzrQYle/JI6CHABiJpwY/51IW8eoqxKJS0YO
         UGKNo4KD8jRS6kVYf4Ym6Buy7gU7b/rIUNTyvRKyzAtKfXechEr3k9HEefYhxx6CzvNF
         2RxA==
X-Forwarded-Encrypted: i=1; AJvYcCW3Pw+jYty9TCBw1phipIHUnOqbdlo5u179aaXq/ybih/LJj7+teGlmTSNqcuW6feu3OaLAFh8rp/VRZng6PI3bZ6QYBwm+SN5fONR1
X-Gm-Message-State: AOJu0Yxv4Ho43uANbPXNbb7olQoN+3qsKmBuCW4qhoH8v7vKEfnbUw6D
	vbTjvcxoC4V3XqNzCu6GRL3PKDsJ2MA/t7VVDoItU2twDMAWp1XCtQXfoJQWnwGWINlUPsQ1xNC
	tTWC4Cg==
X-Google-Smtp-Source: AGHT+IHDv2RF+g0WtLpuqVEu8A/y4gk/Ig/r1AOWgaX9fpvE4JaKMLfS7FVxyxu/G54gfBS6j2r5gQ==
X-Received: by 2002:a05:6402:2108:b0:58d:410a:32a9 with SMTP id 4fb4d7f45d1cf-58e5add2bfemr8486314a12.15.1720376403550;
        Sun, 07 Jul 2024 11:20:03 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58b43df9efdsm7258093a12.57.2024.07.07.11.20.03
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jul 2024 11:20:03 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77baa87743so344422566b.3
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jul 2024 11:20:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW/kyKAD91EMOOKQzsDqLIA2d5VCsbAuiYNgBb4uTikQ1VZVSNrPlDrvEoJE2c2rqCIJ8TCicq8+Abxpui2gUpndKnSXcSIA2aPv91p
X-Received: by 2002:a17:906:bc94:b0:a6f:58a6:fed8 with SMTP id
 a640c23a62f3a-a77ba46f8femr721323266b.28.1720376402830; Sun, 07 Jul 2024
 11:20:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240707002658.1917440-1-Jason@zx2c4.com> <20240707002658.1917440-2-Jason@zx2c4.com>
 <1583c837-a4d5-4a8a-9c1d-2c64548cd199@redhat.com>
In-Reply-To: <1583c837-a4d5-4a8a-9c1d-2c64548cd199@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Jul 2024 11:19:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjs-9DVeoc430BDOv+dkpDkdVvkEsSJxNVZ+sO51H1dJA@mail.gmail.com>
Message-ID: <CAHk-=wjs-9DVeoc430BDOv+dkpDkdVvkEsSJxNVZ+sO51H1dJA@mail.gmail.com>
Subject: Re: [PATCH v21 1/4] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: David Hildenbrand <david@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	tglx@linutronix.de, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 7 Jul 2024 at 00:42, David Hildenbrand <david@redhat.com> wrote:
>
> But I don't immediately see why MAP_WIPEONFORK and MAP_DONTDUMP have to
> be mmap() flags.

I don't think they have to be mmap() flags, but that said, I think
it's technically the better alternative than saying "you have to
madvise things later".

I very much understand the "we don't have a lot of MAP_xyz flags and
we don't want to waste them" argument, but at the same time

 (a) we _do_ have those flags

 (b) picking a worse interface seems bad

 (c) we could actually use the PROT_xyz bits, which we have a ton of

And yes, (c) is ugly, but is it uglier than "use two system calls to
do one thing"? I mean, "flags" and "prot" are just two sides of the
same coin in the end, the split is kind of arbitrary, and "prot" only
has four bits right now, and one of them is historical and useless,
and actually happens to be *exactly* this kind of MAP_xyz bit.

(In case it's not clear, I'm talking about PROT_SEM, which is very
much a behavioral bit for broken architectures that we've actually
never implemented).

We also have PROT_GROSDOWN and PROT_GROWSUP , which is basically a
"match MAP_GROWSxyz and change the mprotect() limits appropriately"

So I actually think we could use the PROT_xyz bits, and anybody who
says "those are for PROT_READ and PROT_WRITE is already very very
wrong.

Again - not pretty, but mappens to match reality.

> Interestingly, when looking into something comparable in the past I
> stumbled over "vrange" [1], which would have had a slightly different
> semantic (signal on reaccess).

We literally talked about exactly this with Jason, except unlike you I
couldn't find the historical archive (I tried in vain to find
something from lore).

  https://lore.kernel.org/lkml/CAHk-=whRpLyY+U9mkKo8O=2_BXNk=7sjYeObzFr3fGi0KLjLJw@mail.gmail.com/

I do think that a "explicit populate and get a signal on access" is a
very valid model, but I think the "zero on access" is a more
immediately real model.

And we actually have had the "get signal on access" before: that's
what VM_DONTCOPY is.

And it was the *less* useful model, which is why we added
VM_WIPEONCOPY, because that's the semantics people actually wanted.

So I think the "signal on thrown out data access" is interesting, but
not necessarily the *more* interesting case.

And I think if we do want that case, I think having MAP_DROPPABLE have
those semantics for MAP_SHARED would be the way to go. IOW, starting
off with the "zero on next access after drop" case doesn't make it any
harder to then later add a "fault on next access after drop" version.

> There needs to be better reasoning why we have to consume three mmap
> bits for something that can likely be achieved without any.

I think it goes the other way: why are MAP_xyz bits so precious to
make this harder to actually use?

Together with that whole "maybe use PROT_xyz bits instead" discussion?

               Linus
