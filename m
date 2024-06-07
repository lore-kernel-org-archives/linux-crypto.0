Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27EC14036D
	for <linux-crypto@vger.kernel.org>; Fri,  7 Jun 2024 18:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717785566; cv=none; b=oACnNFsF1bWu3FmLypKXKbp7dWg+R3TPvFZbBhgsvGkk8GnqpeaSwSqhR8GIlIP+jSOI5+3QN49OrZ/BExme/YI6/cB+pYLsUpYZAL+kWL2qNb88gFSAWFu5JlsrCYn/YpVh+HEhj/s9vvPjgaV/V8olHQ/rvzRHaEn2cvK8UxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717785566; c=relaxed/simple;
	bh=9NPTMvfJ2xTxqNKl+Rg7n1Jvn4W/OrCHXBqrahwbaiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pwHzpDqg98B1sAMPu4PPfPmxBcp/AwjzM+CdVLj5JA85kT26EGq05mEPAdcqKJLOyvEv0IgdfbqbW1egHCEgAPyllNXe/wiPMf+89rovXB39wZapSWO6aaV8pcrcRyjuhSXOKL5w8EhyXyJ+aMg2YN0mAqPVNUNgoQ86Dp8e4cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=PmX41GPh; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="PmX41GPh"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-35ef92111afso1634173f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 07 Jun 2024 11:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1717785563; x=1718390363; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80khoRU9VqZN6aPpM37FfANzK9Z/6h4/Oarr/uMp8CI=;
        b=PmX41GPhdKf/JKrSkDx0MmDU4lXErst2Od/nCsoW8diH4BpUmrppbsLKFKqMDKS/BT
         T1McZTN53OweOFGb+0PTU66+j4Ix2JiDWpSl5cG97GU4+kcIrh7NFpaPKrz0udv7D/p/
         pFsedE2IvyUuXtBQMLSSXNKnyDU5WThB+4GlYTSa4X58vxkZ3rWNMIyaIptQJO0xvI7j
         dKXXsl/krnpOTNcDI0qDp1jIjf9KuCvnxBRoEAClw0iR7DK0uDVyeMSkzKqpWOMDYro2
         VM8OdKFKhS/E/v81YzZe1lpXGB+06AaRnUaHXKwCntZpGaP/cJhmaAGagP+v4UAbEFvY
         fVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717785563; x=1718390363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=80khoRU9VqZN6aPpM37FfANzK9Z/6h4/Oarr/uMp8CI=;
        b=fZbVHB7ZH6jf1k9DyFxglEOba9zt8HOUlbKDFD6uJUE4TSXn4b9WNpzLvuukUn1Lny
         VK4GdJuQkCHC/IDt4qxE9WqVm/2iyeZyGC9muLwosm/jgXNHB0yy2wogW8YgLVi4z7sG
         Gu7XtbJNdrlVyywErPhg10pY4e8O05jdbR+/bojjNh/+0UTwsZhIHt6zhR3FSaU4FHmJ
         5qegs7TCHH4dYk5Ac8SsilIPEkGs/YhZWRVGRW5DZTvi3ztrqNN29vB6wpJ6XZFAWJA7
         Nw5MuthIR9rDGgutnTS+NaIAbULsFDPANmEg0zeLn0adfMV4BQet3DwbKonILvosMkDY
         y0Kw==
X-Forwarded-Encrypted: i=1; AJvYcCVqflI7PfRzQTxw/6dXVwgCHk/LhGS4ocBskP+XIO9jwevMaus65cRYDxBOi560LTkqWlNDK7H5y/kCZdgiLsFgqobfBDwWmHLItIXZ
X-Gm-Message-State: AOJu0Ywhe4WU418ozGvDgkQnmh55gI/e0xIx87BHW4XFV05Z2M4QI1Y5
	DKqykPq0q1Z2A/M5hWBtuB9TIgJgkPcIVVyJ8ApP7wgWNJeI3Wp8vQZ6UIx0jhyzLv9sv0Zs4NH
	/Hh9h9OWOs+iMu+nu+jvSxIiV0/Ck0fnhlxHN
X-Google-Smtp-Source: AGHT+IGwctdoLBTARLYq3NMn93r70A5BCSf8URz3K1Dy/cmfTRtIo6qWt6xdrYfzPiAHvg3JZQpLYNEXBVn3QXYRpSU=
X-Received: by 2002:a5d:6902:0:b0:354:fb6c:2198 with SMTP id
 ffacd0b85a97d-35efed0a1aamr2243893f8f.8.1717785563004; Fri, 07 Jun 2024
 11:39:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-5-Jason@zx2c4.com>
In-Reply-To: <20240528122352.2485958-5-Jason@zx2c4.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 7 Jun 2024 11:39:10 -0700
Message-ID: <CALCETrUjcmBBE+jtek9RumHkKe0VGNUJg6qXe=VY9ve1E6j4Tg@mail.gmail.com>
Subject: Re: [PATCH v16 4/5] random: introduce generic vDSO getrandom() implementation
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

More comments...

On Tue, May 28, 2024 at 5:25=E2=80=AFAM Jason A. Donenfeld <Jason@zx2c4.com=
> wrote:
>
> Provide a generic C vDSO getrandom() implementation, which operates on
> an opaque state returned by vgetrandom_alloc() and produces random bytes
> the same way as getrandom(). This has a the API signature:
>
>   ssize_t vgetrandom(void *buffer, size_t len, unsigned int flags, void *=
opaque_state);
>
> The return value and the first 3 arguments are the same as ordinary
> getrandom(), while the last argument is a pointer to the opaque
> allocated state. Were all four arguments passed to the getrandom()
> syscall, nothing different would happen, and the functions would have
> the exact same behavior.
>
> The actual vDSO RNG algorithm implemented is the same one implemented by
> drivers/char/random.c, using the same fast-erasure techniques as that.
> Should the in-kernel implementation change, so too will the vDSO one.
>
> It requires an implementation of ChaCha20 that does not use any stack,
> in order to maintain forward secrecy if a multi-threaded program forks
> (though this does not account for a similar issue with SA_SIGINFO
> copying registers to the stack), so this is left as an
> architecture-specific fill-in. Stack-less ChaCha20 is an easy algorithm
> to implement on a variety of architectures, so this shouldn't be too
> onerous.

Can you clarify this, because I'm a bit confused.  First, if a
multi-threaded program forks, bascially all bets are off -- fork() is
extremely poorly behaved in multithreaded programs, and the child
should take care to execve() or exit() in short order.  But more to
the point: If I do:

some_bytes =3D get_awesome_random_bytes();
<-- other thread forks here!

The bytes get copied.  Is the concern that the fork might happen *in
the middle* of the vDSO code, causing the child to end up
inadvertently possessing a copy of the parent's random state and thus
being able to predict future outputs?  If so, I think this could be
much more cleanly fixed by making sure that the vDSO state gets wiped
*for the parent and the child* on a fork.


> +       /*
> +        * If @state->generation doesn't match the kernel RNG's generatio=
n, then it means the
> +        * kernel's RNG has reseeded, and so @state->key is reseeded as w=
ell.
> +        */
> +       if (unlikely(state->generation !=3D current_generation)) {
> +               /*
> +                * Write the generation before filling the key, in case o=
f fork. If there is a fork
> +                * just after this line, the two forks will get different=
 random bytes from the
> +                * syscall, which is good. However, were this line to occ=
ur after the getrandom
> +                * syscall, then both child and parent could have the sam=
e bytes and the same
> +                * generation counter, so the fork would not be detected.=
 Therefore, write
> +                * @state->generation before the call to the getrandom sy=
scall.
> +                */
> +               WRITE_ONCE(state->generation, current_generation);

Farther down the thread I think you were saying this had something to
do with signals, not fork.  As for fork, if you make sure that
rng_info->generation can never be 0, then, after a fork, the vDSO will
always retry or fall back, and I think there will be no complexity in
the middle related to forking, which could end up simplifying a few
things.
