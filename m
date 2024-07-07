Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DBA487AE
	for <linux-crypto@vger.kernel.org>; Sun,  7 Jul 2024 19:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720380185; cv=none; b=rnq4R2fm6w5dMVjiZJ024CGvGXa9kOKHQeoOSY5CPy9Z9vNGMzPM11+Uad/ICHxfu1Pp3qszaS+OKFQIVYC1D+4sBvIAq1i6BgI24qPxAibizUdCSjyjAe2dc37eKaZ6rT3GBY94xOtxZ/jlGP02RpJH5WBaBouXYBL/DwK0dP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720380185; c=relaxed/simple;
	bh=EpPs/PieXAoJ9C1Niu2SR/rTGpSjbWX77CzmDxsNsCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J4SIhdJdioECrWfu242Dy2eWWCYSBMA0qWakHktM3tUpdhpd8D62tq2mLKYlLym0UScSZxh62gJyhIERSS+ecB4tlea3ITIdUYfjLpXK1mzVEn5dxJJaI0xRrk0sibOvh7jsaTYq40OH2ZrlXQbJgfWppqg6OGkPMzFCbxi7u4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O0gZTKHW; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O0gZTKHW"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a77c7d3e8bcso278345866b.1
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jul 2024 12:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720380182; x=1720984982; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=r0kqfSkBdmswPIG4hqXsZ+rgeH3ZVa2Soxi8UY2qccM=;
        b=O0gZTKHWqwDskabka0/dAI4tfr6cJLX8haT1skAujsKfM4W3QilrlqCBwDr44hKW17
         xtgglYIPxVAdWCI+RJsP1vrns2bj0cUvkT40pn5gDU0uFGfxLoUP7WHAqAdYUPNViAiy
         xvwJZ9+fbwptTWg8g8RSgavWJZrIA0TgP17Cg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720380182; x=1720984982;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r0kqfSkBdmswPIG4hqXsZ+rgeH3ZVa2Soxi8UY2qccM=;
        b=gO4VQk0ZOigOpsPSMMh/9lb/jrkhn4iLAuigTRLp1SjBHTHDr6HgIrFmUuBhXPOjMQ
         dCobaFCjGc+iFL7MHCfuMBxnapxICWVUkoa6DfUFbJpAlUmOxDsW6K8jzDVZSZI8XsE/
         Wz3FX/Tk4WWKtqTuN0hzGG+KDpY+a23e1gtBGMnh9RiNeDNA88Qtwl3ktR8PtPSw9yBk
         ZNabLYDT20LaACE+kmB16FtOyojcINMVKqZbOrNOopg3tS7kexBbdd3Q9UPdM1IiUFV6
         Gm6j0BJqTU808caULHyRj153DIeAw3psHZTCaxleYSYHx4/V2S/RMyCr4AApBC8/N5Jt
         6IvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdXKxBZBD9e+0u5Z6WfpfRZVaHAWvX2c01zKZr596IO4fMH2zyI61N/7wCeVsupZ4fOTPplX/AmW5H+1TR6S+7EGF5Hz9VbLzqLhb6
X-Gm-Message-State: AOJu0YyDNKRK3ZuWIHf4+kUB4jw9VWGyfsxMxxepa53BUrPevxfqkrWj
	GPE+ZcplF+Y0nwd/J7Ny+W6+sdvUqJuDP6IMV8A3pOQlxE0Rf78PLjCfoOYWcMfgUZ/MC6qG6XZ
	1UVnSQg==
X-Google-Smtp-Source: AGHT+IHNFL+HvWa5NXZwbQetz6Fad6xW+mz4NQ2QcXratMzoz/it6kanjo03J4WgsBOyi73FYPpbXg==
X-Received: by 2002:a17:906:6a81:b0:a77:e55a:9e77 with SMTP id a640c23a62f3a-a77e55aa129mr243255766b.7.1720380181890;
        Sun, 07 Jul 2024 12:23:01 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a77df1015e2sm178398066b.51.2024.07.07.12.23.01
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jul 2024 12:23:01 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-57ccd1111aeso4092727a12.0
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jul 2024 12:23:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX3Yu3efF7l2ZUhXD9Q+VL5vAP/Zc0MGfceyxUFA4TmdEtu5j1pMXH1XSLJtJf67vI7GyzufO5FYwpNIJex6FShNpmBuT5h1VhZ7QGY
X-Received: by 2002:a17:906:7708:b0:a75:3c31:4f58 with SMTP id
 a640c23a62f3a-a77ba46fa2bmr620405066b.32.1720380181227; Sun, 07 Jul 2024
 12:23:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240707002658.1917440-1-Jason@zx2c4.com> <20240707002658.1917440-2-Jason@zx2c4.com>
 <1583c837-a4d5-4a8a-9c1d-2c64548cd199@redhat.com> <CAHk-=wjs-9DVeoc430BDOv+dkpDkdVvkEsSJxNVZ+sO51H1dJA@mail.gmail.com>
 <e2f104ac-b6d9-4583-b999-8f975c60d469@redhat.com>
In-Reply-To: <e2f104ac-b6d9-4583-b999-8f975c60d469@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 7 Jul 2024 12:22:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wibRRHVH5D4XvX1maQDCT-o4JLkANXHMoZoWdn=tN0TLA@mail.gmail.com>
Message-ID: <CAHk-=wibRRHVH5D4XvX1maQDCT-o4JLkANXHMoZoWdn=tN0TLA@mail.gmail.com>
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

On Sun, 7 Jul 2024 at 11:52, David Hildenbrand <david@redhat.com> wrote:
>
> I recall that introducing things like MAP_SHARED_VALIDATE received a lot
> of pushback in the past. But that was before my MM days, and I only had
> people tell me stories about it.

I think MAP_SHARED_VALIDATE was mostly about worrying about the API impact.

And I think it worked out so well that this is probably the first time
it has been brought up ever since ;)

That said, the *reason* for MAP_SHARED_VALIDATE is actually very
valid: we have historically just ignored any random flags in the
mmap() interfaces, and with shared mappings, that can be dangerous.

IOW, the real issue wasn't MAP_SHARED_VALIDATE itself, but introducing
*other* flags that affected maps that old kernels would ignore, and
then the worry was "now old kernels and new kernels work very
differently for this binary".

That's technically obviously true of any MAP_DROPPABLE thing too - old
kernels would happily just ignore it. I suspect that's more of a
feature than a mis-feature, but..

> My understanding so far was that we should have madvise() ways to toggle
> stuff and add mmap bits if not avoidable; at least that's what I learned
> from the community.

It doesn't sound like a bad model in general. I'm not entirely sure it
makes sense for something like "droppable", since that is a fairly
fundamental behavioral thing. Does it make sense to make something
undroppable when it can drop pages concurrently with that operation?

I mean, you can't switch MAP_SHARED around either.

The other bits already _do_ have madvise() things, and Jason added a
way to just do it all in one go.

> Good to hear that this is changing. (or it's just been an urban myth)

I don't know if that's an urban myth.  Some people are a *lot* more
risk-averse than I personally am. I want things to make sense, but I
also consider "this is fixable if it causes issues" to be a valid
argument.

So for example, who knows *what* garbage people pass off to mmap() as
an argument. That worry was why MAP_SHARED_VALIDATE happened.

But at the same time, does it make sense to complicate things because
of some theoretical worry? Giving random bits to mmap() sounds
unlikely to be a real issue to me, but maybe I'm being naive.

I do generally think that user mode programs can pretty much be
expected to do random things, but how do you even *create* a mmap
MAP_xyz flags field that has random high bits set?

> > We also have PROT_GROSDOWN and PROT_GROWSUP , which is basically a
> > "match MAP_GROWSxyz and change the mprotect() limits appropriately"
>
> It's the first time I hear about these two mprotect() options, thanks
> for mentioning that :)

Don't thank me.

They actually do make sense in a "what if I want to mprotect() the
stack, but I don't know what the stack range is since it's dynamic"
kind of sense, so I certainly don't hate them.

So they are not bad bits, but at the same time they are examples of
how there is a fuzzy line between MAP_xyz and PROT_xyz.

And sometimes the line is literally just "mprotect() only gets one of
them, but we want to pass in the other one, so we duplicate them as a
very very special case".

                     Linus
