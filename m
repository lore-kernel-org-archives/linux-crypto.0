Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BF8242D79;
	Thu,  4 Sep 2025 20:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757016522; cv=none; b=t4qUFUsrI1BMwQ0caU/XRB9xyd4ieX6HpvzA2tiEbpg4u11cw9Il0MDLuaZF3SlixzLD+d9PsZ+NVrhGO6qnaBp3e/MJldaW9qFXx0rdXYkiN3q2A3zOEw5HQ/5ZhtSEYNBqb0TNVzfFg7vgU6qb0kIDtq20S/FFwa8t+QJlZu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757016522; c=relaxed/simple;
	bh=bljqivuSvx90CPp2puOAtExz+IM01VoIcutOkAC0T58=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P5j7U9HC9tjJbnlEmI37km67RNDQkjdWewF/h8EiyVExAohzXO5OQQq2dtdt6JPbxw68zPOn5s5jU+FlAQh+QHB3kFJjTqvHhVJBmsivcS4KzFySS8zFCq55YP6nEkfEPLjyf6gHN38iSBhBxkhWX7dDftJDo95FlBD6kvnQbLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GxT3UCto; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GxT3UCto"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b47173749dbso934717a12.1;
        Thu, 04 Sep 2025 13:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757016520; x=1757621320; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gv63X/vQm384UIbEqWmqDeqv2bYENAIp/s5gNmTAzz0=;
        b=GxT3UCtov45Vsd/k0QsmdUwJCoYi9s//J7bseLyoMpKIrR0aozfaU4UkBY+wvQfjEr
         PMGdUiF86HPGaSLoQQEZ7tRKhYQb5/D4zS125ti4Fzfu3Q3m06hmmQWsjLTPzrhZqZtQ
         lknro+6lso07eZ/+Egqr6yQagYE2K1/33OPXYj6oSvpH91FfupGiI52N67dgW0VRluq6
         naIVaohLdOdoka6Y2expWh2J/OkY3g+Y6UWd3QxX1UN17gxO2YOmoYgdMnKeDaU3v2YN
         q+JEiC3aIKjSdhRO+F1J8ozZP3HdR7I8jeM5m6v10KKyaIeGQkwwZTMkonC64M1STH6v
         Ejgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757016520; x=1757621320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gv63X/vQm384UIbEqWmqDeqv2bYENAIp/s5gNmTAzz0=;
        b=v9qDj8IH3a8F9C9TRtIWc8zDIvWa0EQsE2SyAHNZEimeV5QrgQg+Py1O2cb95RQ7yP
         Do/QxYroaSP7jquYwenBhYlctPcG/XWMyknUrzFgr+RP495rXiXCm4HR5F4zWn8MAHra
         ip1cLRNBri/eLQ4mDOAUm7TOBVLUQEpDmH3F1QllrKR8MnUqnQ2EpNUA/5KM021299+E
         +1aoeRcbkIFhGwBc1bFIGOoKhEdqzvRi84/f1xtdo4DjADFQd0dvBI+PbTXYleTxQQeI
         dwQiEmb9RUD1ANsQdrPHboTMp8S4OnwSCz4N8RxJQVMeP/Xv15ZqLG4RDQbZgylpv9Si
         limg==
X-Forwarded-Encrypted: i=1; AJvYcCV90JH6Y/P6x/Q8Rsks4dNp3MFHDMNTH3Y4xSxu8/zu5W2bb8P3ZxJkWytRS/OaQd8Qz7EKW8+Fp7cZ5O8=@vger.kernel.org, AJvYcCWEDh5+McBu+5jSlKxj5Ot5i2YSDbHpPwUa6olrX3FGnePNWYGcjDIXK5iBn3RRBB9+l6bTqgrEuMv4FI2V@vger.kernel.org
X-Gm-Message-State: AOJu0YxdnzDqbUQzWhKZp3iiyiYBs1IYWvYJphO2S9TxFLKJfTIu1ROC
	jXHGXVRL6yqXV/4opciGaOSgO9ZsCK7c20HulXOSrmTqQYIij/nPprp/RdvwnhERW33roQUa98U
	1cI+tA/Y5CyCvTwMNgGbW5MA7GNUJVuc=
X-Gm-Gg: ASbGncur7VaL9g79TDzUqU5VNCCwLlkpPdP21JCwh5+XtrNJXe3vkLCCNYkR5BHH3ZN
	FiSz3hKwi4xftjQ9fr/ZBtyMG+0FKzF/JZxwKUgQns+ZvofKairxrALp7V8Eg4wVI9p7wG8MsMn
	orAGQBBKxwOEmlVlnxfRhj9gVU4gHjtoGnMZAv6wlJoFTyiE0Hv+kb1wvklQ68oJshj496agNOI
	/4408fylshZ36v3WLKT2PRFdW0a7AdQh3GmOA==
X-Google-Smtp-Source: AGHT+IEjqpitfY8TXIZND29ig5PdIMIT2psIfhUSF8teXLvL/cYNO29iq6xPwr5aBLoyY+oSK5RDMQ71M/Oej/pf6xs=
X-Received: by 2002:a17:90b:3811:b0:32b:6145:fa63 with SMTP id
 98e67ed59e1d1-32b614601acmr8171223a91.4.1757016519877; Thu, 04 Sep 2025
 13:08:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <CABVgOSmZffGSX3f3-+hvberF9VK6_FZYQE_g2jOB7zSMvVuDQw@mail.gmail.com>
In-Reply-To: <CABVgOSmZffGSX3f3-+hvberF9VK6_FZYQE_g2jOB7zSMvVuDQw@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Thu, 4 Sep 2025 22:08:28 +0200
X-Gm-Features: Ac12FXydPL4VUvPU0jz05GoorbNVB63dfkWSac6PClpHYbvI5-ih43lt8hTBuT0
Message-ID: <CANgxf6x2aPfeP8gz6wkKdTZ5q7PDiOYgQDfEYW5Mh37YYTZJ-A@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
To: David Gow <davidgow@google.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	brendan.higgins@linux.dev, dvyukov@google.com, jannh@google.com, 
	elver@google.com, rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 11:11=E2=80=AFAM David Gow <davidgow@google.com> wro=
te:
> Thanks, Ethan. I've had a bit of a play around with the
> kfuzztest-bridge tool, and it seems to work pretty well here. I'm
> definitely looking forward to trying out
>
> The only real feature I'd find useful would be to have a
> human-readable way of describing the data (as well as the structure),
> which could be useful when passing around reproducers, and could make
> it possible to hand-craft or adapt cases to work cross-architecture,
> if that's a future goal. But I don't think that it's worth holding up
> an initial version for.

That's a great idea for a future iteration.

> On the subject of architecture support, I don't see anything
> particularly x86_64-specific in here (or at least, nothing that
> couldn't be relatively easily fixed). While I don't think you need to
> support lots of architectures immediately, it'd be nice to use
> architecture-independant things (like the shared
> include/asm-generic/vmlinux.lds.h) where possible. And even if you're

You're absolutely right. I made some modifications locally, and there
seems to be no reason not to add all of the required section
definitions into the /include/asm-generic/vmlinux.lds.h.

> focusing on x86_64, supporting UML -- which is still x86
> under-the-hood, but has its own linker scripts -- would be a nice
> bonus if it's easy. Other things, like supporting 32-bit or big-endian
> setups are nice-to-have, but definitely not worth spending too much
> time on immediately (though if we start using some of the
> formats/features here for KUnit, we'll want to support them).
>
> Finally, while I like the samples and documentation, I think it'd be
> nice to include a working example of using kfuzztest-bridge alongside
> the samples, even if it's something as simple as including a line
> like:
> ./kfuzztest-bridge "some_buffer { ptr[buf] len[buf, u64]}; buf {
> arr[u8, 128] };"  "test_underflow_on_buffer" /dev/urandom

Definitely. I'll be sure to add that into the docs.
