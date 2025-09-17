Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B13A222568
	for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 16:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758126786; cv=none; b=GbM0r4LEGGE7kkvigask63CyA6exete75wrkWX89jTpajrgOhuZeantYeFhZqSmuX/fx2ApgpUlSLN8fxncOIYSt52tOcDWyGFfixFiliKD1GUDfmAPs+dY7KMWHVzME/HtQxovkRZzLiuh1cJZt+a/CQnVbSL+itml6imRlLS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758126786; c=relaxed/simple;
	bh=kKL/L+I3zsHPh3CySBs0NwNoG6xv18j00aP3GrBEXns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lMfyET+kqgFRBbuob53LLHxEP82kYxobef+YPOtplXQR/PK7nv9zbOJgmcUMfLMTBNOJIZ/d04kr1csOH+9KHtTtMp+n3xWFL0oQjA0UozIILndv0SlO7aJB3WBkjZyNoh2lRgU7P6RojsV3ndgDHFYrkglN3xD26GSAmN4iFIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byficK7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byficK7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABB0C4CEFD
	for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758126786;
	bh=kKL/L+I3zsHPh3CySBs0NwNoG6xv18j00aP3GrBEXns=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=byficK7SMdbNqCt8qDue6jkVGfFA0zVMGLz2oN3p5iX8uF2YDd0q1otjKJ3U6DuUF
	 Q1EqSfdTH4wxw/rize5/jH+qnxrqDt/2s0uFKKbeMo+P1qdN779Dk65VMBLwpDWU1y
	 8nl7Fr5JUF16RyRALwfBhoXD7ZVQDLUpkXSzPn7T672mmBwbhpyXIV/phkiiVdCR5m
	 NVg2liqXJqIButavkSTYgzr1iKgQKMvoGjnIhQ2NFo0yFidl6Sw7spTXQLGTSyVDAM
	 qCBBVv0k0dAu33msshV4jLPy87V7RDYFc/vXZ2z9636k4fU9ojG392koy51HWdxk+D
	 mVxqp5LbWSEog==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5679dbcf9d8so32708e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 17 Sep 2025 09:33:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YzNLVlAkONPisIoWXNdsfFuP8ymuV9Tq1ZUjxzrKeTOFgowiiFg
	mgTJtkZ29Lk6VfO/Gwu8gJw3Rm0ant0ATegskFVxkAJpXnBrlzphEdAg/T/LIxxJ6NQqlaAmFM5
	2GH5Uxa6u3lrJ+Gzbn8jRNexX/UY7rlg=
X-Google-Smtp-Source: AGHT+IGkxd8CfmvOgxOlzUd2WBWMRN3KAVklJLyRUEqXRjAdq6Oylda7wBiSlm11ND9H/fuMGe8uQFz5PDqzdmmiqH8=
X-Received: by 2002:a05:6512:4601:b0:569:a257:acca with SMTP id
 2adb3069b0e04-5779b9bec2emr837666e87.32.1758126784374; Wed, 17 Sep 2025
 09:33:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250915160819.140019-1-ebiggers@kernel.org> <20250917153529.GA45754@quark>
In-Reply-To: <20250917153529.GA45754@quark>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 17 Sep 2025 18:32:53 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGWZ5iVjOq_wPihCvSrPzg84up2uc85b04-kogr06zr-g@mail.gmail.com>
X-Gm-Features: AS18NWDKkMpHMPVrfCSxPSR1GAt9QZdsUGm2zA3q8XBTy6lhROgcqYD7BkYXAg4
Message-ID: <CAMj1kXGWZ5iVjOq_wPihCvSrPzg84up2uc85b04-kogr06zr-g@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Optimize fsverity using 2-way interleaved SHA-256 hashing
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>, Mikulas Patocka <mpatocka@redhat.com>, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 Sept 2025 at 17:35, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Sep 15, 2025 at 11:08:13AM -0500, Eric Biggers wrote:
> > This series is targeting libcrypto-next.  It can also be retrieved from:
> >
> >     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git sha256_finup_2x-v2
> >
> > This series adds support for 2-way interleaved SHA-256 hashing to
> > lib/crypto/, implements it for arm64 and x86_64, and makes fsverity use
> > it.  This significantly improves fsverity performance on many CPUs.
> >
> > Later patches will make dm-verity use this optimization as well.
> >
> > Changed in v2:
> > - Made the new arm64 assembly compatible with CONFIG_CPU_BIG_ENDIAN=y.
> > - Omitted sha256_finup_2x() from pre-boot environments.
> > - Made alloc_guarded_buf() assert that the allocation succeeded.
> > - Minor tweaks to comments and whitespace.
> >
> > Eric Biggers (6):
> >   lib/crypto: sha256: Add support for 2-way interleaved hashing
> >   lib/crypto: arm64/sha256: Add support for 2-way interleaved hashing
> >   lib/crypto: x86/sha256: Add support for 2-way interleaved hashing
> >   lib/crypto: tests: Add tests and benchmark for sha256_finup_2x()
> >   fsverity: Remove inode parameter from fsverity_hash_block()
> >   fsverity: Use 2-way interleaved SHA-256 hashing when supported
> >
> >  fs/verity/enable.c              |  12 +-
> >  fs/verity/fsverity_private.h    |   2 +-
> >  fs/verity/hash_algs.c           |   3 +-
> >  fs/verity/verify.c              | 175 ++++++++++++---
> >  include/crypto/sha2.h           |  28 +++
> >  lib/crypto/arm64/sha256-ce.S    | 284 +++++++++++++++++++++++-
> >  lib/crypto/arm64/sha256.h       |  37 ++++
> >  lib/crypto/sha256.c             |  71 +++++-
> >  lib/crypto/tests/sha256_kunit.c | 184 ++++++++++++++++
> >  lib/crypto/x86/sha256-ni-asm.S  | 368 ++++++++++++++++++++++++++++++++
> >  lib/crypto/x86/sha256.h         |  39 ++++
> >  11 files changed, 1147 insertions(+), 56 deletions(-)
>
> FYI, applied to https://git.kernel.org/pub/scm/fs/fsverity/linux.git/log/?h=for-next
>
> I decided to use the fsverity tree instead of the libcrypto one.  There
> are no dependencies on other libcrypto changes for 6.18, and this makes
> it easier to do a separate pull request.
>
> Also, as always, reviews and acks would be appreciated!  Note that I
> dropped the reviews and acks that were on the original crypto_shash
> version from earlier this year, due to changes in the patches.  The
> high-level idea is still the same, though.  If people could
> re-review/ack this latest version, that would be great.  Thanks,
>

I looked at this the other day but forgot to reply.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

Happy to see that this finally landed!
