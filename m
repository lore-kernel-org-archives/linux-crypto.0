Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6B71514F9
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 13:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717160469; cv=none; b=SRe1kucDYwd1cZjEciJcRiuAcFGynP6/j5hRwY/u2OxeVktETvzAMSdBhDSdTe1blAZXLSKjAVhl0dYg2vNZhBBwMf0pCZNDW6xVJuD7gZicSmT5NRlqazbUk67h4W+qpxOy3HzEbeefNZkDmzvu0qZjLJbuDa+6yM599W6Ywww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717160469; c=relaxed/simple;
	bh=nUsPB5Ony4aNAlYic6rvb9WueoAtsv5tUM/Q9JTEZ3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GDyem2nNtLrSkvFnEjcbpv/SGfigtIOt56Sxxy1dPnLy+ryg8gHa1CPB2InuVRprMKyhbOQ3ei61jKM+WRK2ZbAsaNeM+Of4lce2rhtvjzqI28uUQKjd0ZXgEJINVde0Cy04zKco0BAwCmCjqnGYV3uvBIVD5N0KR8+9vfQQOp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dNm8ZVaP; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dNm8ZVaP"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57a22af919cso10536a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 06:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717160466; x=1717765266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRchOj1ggC2TIQN8s7PjJT+YjUNxb7bVoZD51wfkss8=;
        b=dNm8ZVaPeE+hQILesHUvm1Lu5d0s1712zMfqH8+/mxIyN4b+Q3yKf4fZyXDBlPfybk
         63IvFz+uzFp1QCSoaDiXebFLDqAjnWiFuYytbPiw6MdVuoZngJ+uh4b/ORmuul6B2hVX
         6QjNAFGodZA1zOOsjAThp4IAPYpNroPOe/+DHlcdibI4C5ni9GoFxGHSNeqskvNPESYu
         JS4cuolKYEXevnJZrygPe769uY8kzdt3KzVa++CrnHwy0H7jGLjG9yle2rRIVfEMrlII
         V4m7T3jNxE29KId1gnW9EhpqCjHIZEkUPCL/RlYHglh7qo9sww7xxm3JycTbL0IQikj8
         MD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717160466; x=1717765266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vRchOj1ggC2TIQN8s7PjJT+YjUNxb7bVoZD51wfkss8=;
        b=TYjO3Y9mfh2DNyfwXsXyOzwwXajm2eEpR/ZdbO5XjQJN06sGmKoKiDnBBzpvw+V6+v
         3OGbNhu1nHobiup7MuxW7mN0fLl4TP2CBd0SblFTJYEmXwkrspgMQNHOvrHVXNAgpIko
         UMRMHbLdOIiLJ+X3J/d0AF3XavcPQH5otF9cWInK/XswXk+Y9VezJ7VcXrEi6I6l9HPD
         YsqntCxWS7qBvlpRjZ/MUaQqvRrUe1/dABMB7x9q7LquTBmyvm1ixabjzJ7Ipm52Ws41
         Lb1In8MedvMwrp6QaMrwEuNjRh0CAmDU6UENqS6/41meY9Lho/veyGJ5R0OAy1yFjWhy
         YUNw==
X-Forwarded-Encrypted: i=1; AJvYcCWzHNKnqdcvD1pxyuGzsBHZg/avoxl3LpIphEZjQIT3eziwPI1Y5HCQgnrt/E7dHf9Lra7Dou2HH7tU4+8f/JBzma1CHdobsLX36QXG
X-Gm-Message-State: AOJu0YzCEUMV1D0XqfGFG+qbj28oyaCa61DUVs3yjrbOln6SBr9fWz2q
	DQ+6zI55GjlT3TZpu+6tyKhDyZ+QRoytS1AUjPNs4elwIvJuSiMub5rdCW65FjbdAABRhTs+NhL
	tLC7MlKtfdH12/3ahMvgrkKBg7yO14vMfUy6n
X-Google-Smtp-Source: AGHT+IGyobXtF/ORS1N/GztNIrOHPwMv9FM8zg9fZE3Hz3rHQXNmWAty6aJ8lRd6Vdl/KOtZJApkG+sJ4f7FFcdpcvU=
X-Received: by 2002:a05:6402:2932:b0:57a:2eac:cd4d with SMTP id
 4fb4d7f45d1cf-57a378ff925mr106485a12.5.1717160465623; Fri, 31 May 2024
 06:01:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-2-Jason@zx2c4.com>
 <CAG48ez0P3EDXC0uLLPjSjx3i6qB3fcdZbL2kYyuK6fZ_nJeN5w@mail.gmail.com> <Zlm-26QuqOSpXQg7@zx2c4.com>
In-Reply-To: <Zlm-26QuqOSpXQg7@zx2c4.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 31 May 2024 15:00:26 +0200
Message-ID: <CAG48ez3VhWpJnzHHn4NAJdrsd1Ts9hs0zvHa6Pqwatu4wV63Kw@mail.gmail.com>
Subject: Re: [PATCH v16 1/5] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 2:13=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
> On Fri, May 31, 2024 at 12:48:58PM +0200, Jann Horn wrote:
> > On Tue, May 28, 2024 at 2:24=E2=80=AFPM Jason A. Donenfeld <Jason@zx2c4=
.com> wrote:
> > > c) If there's not enough memory to service a page fault, it's not fat=
al.
> > [...]
> > > @@ -5689,6 +5689,10 @@ vm_fault_t handle_mm_fault(struct vm_area_stru=
ct *vma, unsigned long address,
> > >
> > >         lru_gen_exit_fault();
> > >
> > > +       /* If the mapping is droppable, then errors due to OOM aren't=
 fatal. */
> > > +       if (vma->vm_flags & VM_DROPPABLE)
> > > +               ret &=3D ~VM_FAULT_OOM;
> >
> > Can you remind me how this is supposed to work? If we get an OOM
> > error, and the error is not fatal, does that mean we'll just keep
> > hitting the same fault handler over and over again (until we happen to
> > have memory available again I guess)?
>
> Right, it'll just keep retrying. I agree this isn't great, which is why
> in the 2023 patchset, I had additional code to simply skip the faulting
> instruction, and then the userspace code would notice the inconsistency
> and fallback to the syscall. This worked pretty well. But it meant
> decoding the instruction and in general skipping instructions is weird,
> and that made this patchset very very contentious. Since the skipping
> behavior isn't actually required by the /security goals/ of this, I
> figured I'd just drop that. And maybe we can all revisit it together
> sometime down the line. But for now I'm hoping for something a little
> easier to swallow.

In that case, since we need to be able to populate this memory to make
forward progress, would it make sense to remove the parts of the patch
that treat the allocation as if it was allowed to silently fail (the
"__GFP_NOWARN | __GFP_NORETRY" and the "ret &=3D ~VM_FAULT_OOM")? I
think that would also simplify this a bit by making this type of
memory a little less special.
