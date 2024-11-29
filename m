Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFD8208CA;
	Fri, 29 Nov 2024 18:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732905246; cv=none; b=fOW6CjVjjI6StYIFjovI/qfoh26RKEsB7nMoCfgMzlBv4iNIauJ8AxWPYKu3lu7svsQgcg9fGyUxOpzn7o+XW6CxKrqMlu4kg2wVjuqkl+H1S/O5E45iEHNZ9OIt/WIvlODKiyk6DoguZqH4r5RsiRPVhQO65xJo9OYmnUZeYtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732905246; c=relaxed/simple;
	bh=zqS/POlZCeN58lk6+YcKlmNPvDT3/VJf8g5KXf0crzw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fS7tZJ3LWbpIGAhtvZbP+C7k9IQGvKfzr1K6YFrUuUBXjDu+t2zZtfW3On0i987EG49FXZJg7hT/dR3H8/H3ro4Ip24ttnIhzSAVW8MuuKiWFrunNDdUzXyCLWG64E6alsEGfWIkCcWUOgDHbGnaIAoH6Z7uxs+OHxHfoaV6phI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AX1F1j53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AX1F1j53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D527C4CED4;
	Fri, 29 Nov 2024 18:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732905246;
	bh=zqS/POlZCeN58lk6+YcKlmNPvDT3/VJf8g5KXf0crzw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AX1F1j53UZ+55OSzW9vACzc9t9SGMg6c3lc4+tskji6gYReJpvNKRLm7qXhFqW9+F
	 YXsukTPFNauMy5JB7idt+qDd5X/Feo0KrOHWV4dcWmlZMtlkZLA/UER0gjdV22cofa
	 tOn6MD73YSDFH5FAOwtC9D+PZTA3stGwW9lffrMIwck55h18gMLwxFyEBRXJxCnu7L
	 t8cf5J0ALYoyj0DJm6xPvMAUGz4+FZmCXMvzDUFva+wEjP9sHVM44FarNWq/crfFgk
	 mtwZqvLvojgdlqKsIGQXpAtet7qUGhRdGQVkCt1uwHlOi5+GDJw/jX1DogLlflOo9j
	 rXHcBsRAH3ePg==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-53ddb99e9dcso2266563e87.3;
        Fri, 29 Nov 2024 10:34:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVhqcHKHOHjHL0gnEMhIZjO8ExIzKBE7Z/QuxoE6aCddjkmKO0CrWd3LfMd0tUKrzsSXQVCdH2SlRXGm30=@vger.kernel.org
X-Gm-Message-State: AOJu0YzukRVeadV2yd9fENkVg/ksGjXtmJaOjCR4T47XwwN+iXa/EuVm
	s6Nbb2+r8dN9dBydSfKDCBxFrjiiMlAYFAhoxTyw690UPFcqj4h3LiLGav0+xOGjIUXt3nwgVRo
	+MKp9X03G6RRGYtyu4GgoxlqS7CU=
X-Google-Smtp-Source: AGHT+IGOmNrNHGm+gyvZVsdSZ7Yvg1NJ98vc0rEyqw8diT2Uhzku/O5M/vabrf6iVYyY535oUnzGF5v0RgZEl9ktCkw=
X-Received: by 2002:ac2:4850:0:b0:53d:f1cb:6258 with SMTP id
 2adb3069b0e04-53df1cb6388mr7127122e87.32.1732905244407; Fri, 29 Nov 2024
 10:34:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241125041129.192999-1-ebiggers@kernel.org> <20241125041129.192999-3-ebiggers@kernel.org>
 <CAMj1kXFGs8Ur0yt9GetVaub8LzbeWJ77jaZ4ZstvECb3JH9Pvg@mail.gmail.com> <20241129174730.GA1179@sol.localdomain>
In-Reply-To: <20241129174730.GA1179@sol.localdomain>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 29 Nov 2024 19:33:53 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGH77pHUOt1s2qatAz7sHAXzFTcbx5rbtwnRBPCgAnFyg@mail.gmail.com>
Message-ID: <CAMj1kXGH77pHUOt1s2qatAz7sHAXzFTcbx5rbtwnRBPCgAnFyg@mail.gmail.com>
Subject: Re: [PATCH 2/6] scripts/crc: add gen-crc-consts.py
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 29 Nov 2024 at 18:47, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, Nov 29, 2024 at 05:09:51PM +0100, Ard Biesheuvel wrote:
> > On Mon, 25 Nov 2024 at 05:12, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > Add a Python script that generates constants for computing the given CRC
> > > variant(s) using x86's pclmulqdq or vpclmulqdq instructions.
> > >
> >
> > There is nothing x86 specific about this, right? Except perhaps the
> > choice of fold distances?
>
> Yes, and maybe other architectures will want something different for bswap_mask
> and shuf_table depending on exactly what instructions they have.  But it should
> be straightforward to add an option to generate another arch's variant.
>
> > > +print('/* SPDX-License-Identifier: GPL-2.0-or-later */')
> >
> > Does it make sense to add a GPL header into a generated file?
>
> Since I'm checking in the generated file, I figured it would run up against the
> policy that every source file must have a license.
>
> We could generate the file during every build, but I don't really want to deal
> with complaints about Python not being installed or Python being too old, or to
> put the performance of the script on the critical path for almost everyone
> building a kernel for x86.  (Note that Documentation/process/changes.rst
> currently lists Python as "optional" for building the kernel, not required.)
>

Fair enough.
