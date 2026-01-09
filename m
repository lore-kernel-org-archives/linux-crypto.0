Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF01D3321B3
	for <linux-crypto@vger.kernel.org>; Fri,  9 Jan 2026 09:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767949694; cv=none; b=e2aKRVJKmAQxw+vbSFRIKIebFaLNqdRm6EL17J34uPyVmpqHBNzj6cO4q0ATX2jC+0WB6+rbBw5ynYfNFpD3Y/Kswwk9CeVgfpM0UCo/+k5ZaZohrh1W1NyvuqjrXPWmES5eFvaMg53oBy0+f4nPjqjR2G/OojqRZMqy08/Tats=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767949694; c=relaxed/simple;
	bh=goiI1ZxyIEI3mcfeHTSEAz7enxjoJAjvK6SpyVAMJNs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B6gUpQQQVuSIRSC3oLUX/SAp5svfI4c87cxlxmTp2GRnspq394DMd6mj/IPZdrKjX8WARLjM259+ukAaY9iJlvCqqFyd2ErifO1iNB5YqI4msPX9YXYWZmenpV4gCfT9EZV39Puqd29DyQvvisvs40J9awdyhrZkbx7/lYhnX8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIGhG3sg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIGhG3sg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FCBC2BC86
	for <linux-crypto@vger.kernel.org>; Fri,  9 Jan 2026 09:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767949694;
	bh=goiI1ZxyIEI3mcfeHTSEAz7enxjoJAjvK6SpyVAMJNs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WIGhG3sgki+KEoz1vXOR2kR3tB1EB73l3CF5edZGAclsEhVnW+MFWjTMXqfV7GEI6
	 zQgT4YjabyJ7LWa0lp7M6x6hfaA8DQNCTQN1NNYT+o3fm+w2JaH0NLp6PEIx3bf1q1
	 TzO5jLn7lUUx5vFHwxyMbeTKV0azO209foiogdr0ZA5CoY0r4o64woui0oxNWJLL20
	 HYsni/IYgPj253gmaaKlTFuIDAiebwcY1Cx6bE0IzDPaAr+W4Ihox47gg0cM/Npeev
	 rhL2V31+zMVTkjz233e1ZBCunhubLUJiaYIL2QcP5QJ56aXMlRzVsvhA666bTqMHu8
	 vvLYrbMRF3uYw==
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-34cf1e31f85so2630448a91.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Jan 2026 01:08:14 -0800 (PST)
X-Gm-Message-State: AOJu0YzTClkkXQjYyuQJWerWgBQErbEHP/ZjdOAHsAqcDs5av1AkgErR
	QznoVscmpxtADb0u1TyU+YbM9/jrrUhgxfX/RRA6a+eRjsqPkBrq+wMUj14ctDUOSG3vvMihLof
	zo1nd5ZKFx38ewm5RNU+KhAbY/2yKRZ4=
X-Google-Smtp-Source: AGHT+IFcD0rfNOJ4GvG+wPYTAWMVc/s2zy/BvRbkZK4bJO5tmt19sPbsMOldrWreI07DtS/l8EUtweFn+GaepdyG9dA=
X-Received: by 2002:a17:90b:3a8d:b0:34a:adf1:677d with SMTP id
 98e67ed59e1d1-34f68b64d7cmr8233808a91.9.1767949694052; Fri, 09 Jan 2026
 01:08:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105051311.1607207-1-ebiggers@kernel.org> <CAMj1kXGRTfyXPD3+Ravr7O5ZUMAUeabQw455sW5g7aRy3BU+2Q@mail.gmail.com>
 <20260108202618.GA2687@sol> <20260109012712.GA730896@google.com>
In-Reply-To: <20260109012712.GA730896@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 9 Jan 2026 10:08:02 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGQae+SWEgvZTHvoTJueScbqfei1ie_HSC9WyByOwvJUw@mail.gmail.com>
X-Gm-Features: AQt7F2ruRWMLxfzcb-WM7H3sakD6ZAGLYL1ZhftKy0m5nypWRiiegTKEJVDmsew
Message-ID: <CAMj1kXGQae+SWEgvZTHvoTJueScbqfei1ie_HSC9WyByOwvJUw@mail.gmail.com>
Subject: Re: [PATCH 00/36] AES library improvements
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, x86@kernel.org, 
	Holger Dengler <dengler@linux.ibm.com>, Harald Freudenberger <freude@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 9 Jan 2026 at 02:27, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jan 08, 2026 at 12:26:18PM -0800, Eric Biggers wrote:
> > On Thu, Jan 08, 2026 at 12:32:00PM +0100, Ard Biesheuvel wrote:
> > > On Mon, 5 Jan 2026 at 06:14, Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > This series applies to libcrypto-next.  It can also be retrieved from:
> > > >
> > > >     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git aes-lib-v1
> > > >
> > > > This series makes three main improvements to the kernel's AES library:
> > > >
> > > >   1. Make it use the kernel's existing architecture-optimized AES code,
> > > >      including AES instructions, when available.  Previously, only the
> > > >      traditional crypto API gave access to the optimized AES code.
> > > >      (As a reminder, AES instructions typically make AES over 10 times
> > > >      as fast as the generic code.  They also make it constant-time.)
> > > >
> > > >   2. Support preparing an AES key for only the forward direction of the
> > > >      block cipher, using about half as much memory.  This is a helpful
> > > >      optimization for many common AES modes of operation.  It also helps
> > > >      keep structs small enough to be allocated on the stack, especially
> > > >      considering potential future library APIs for AES modes.
> > > >
> > > >   3. Replace the library's generic AES implementation with a much faster
> > > >      one that is almost as fast as "aes-generic", while still keeping
> > > >      the table size reasonably small and maintaining some constant-time
> > > >      hardening.  This allows removing "aes-generic", unifying the
> > > >      current two generic AES implementations in the kernel tree.
> > > >
> > >
> > > Architectures that support memory operands will be impacted by
> > > dropping the pre-rotated lookup tables, especially if they have few
> > > GPRs.
> > >
> > > I suspect that doesn't really matter in practice: if your pre-AESNI
> > > IA-32 workload has a bottleneck on "aes-generic", you would have
> > > probably moved it to a different machine by now. But the performance
> > > delta will likely be noticeable so it is something that deserves a
> > > mention.
> >
> > Sure.  I only claimed that the new implementation is "almost as fast" as
> > aes-generic, not "as fast".
> >
> > By the way, these are the results I get for crypto_cipher_encrypt_one()
> > and crypto_cipher_decrypt_one() (averaged together) in a loop on an i386
> > kernel patched to not use AES-NI:
> >
> >     aes-fixed-time: 77 MB/s
> >     aes-generic: 192 MB/s
> >     aes-lib: 185 MB/s
> >
> > I'm not sure how relevant these are, considering that this was collected
> > on a modern CPU, not one of the (very) old ones that would actually be
> > running i386 non-AESNI code.  But if they are even vaguely
> > representative, this suggests the new code does quite well: little
> > slowdown over aes-generic, while adding some constant-time hardening
> > (which arguably was an undeserved shortcut to not include before) and
> > also using a lot less dcache.
> >
> > At the same time, there's clearly a large speedup vs. aes-fixed-time.
> > So this will actually be a significant performance improvement on
> > systems that were using aes-fixed-time.  Many people may have been doing
> > that unintentionally, due to it being set to a higher priority than
> > aes-generic in the crypto_cipher API.
> >
> > I'll also note that the state of the art for parallelizable AES modes on
> > CPUs without AES instructions is bit-slicing with vector registers.  The
> > kernel has such code for arm and arm64, but not for x86.  If x86 without
> > AES-NI was actually important, we should be adding that.  But it seems
> > clear that x86 CPUs have moved on, and hardly anyone cares anymore.  If
> > for now we can just provide something that's almost as fast as before
> > (and maybe even a lot faster in some cases!), that seems fine.
>
> It's also worth emphasizing that there are likely to be systems that
> support AES instructions but are not using them due to the corresponding
> kconfig options (e.g. CONFIG_CRYPTO_AES_NI_INTEL) not being set to 'y'.
> As we know, missing the crypto optimization kconfig options is a common
> mistake.  This series fixes that for single-block AES.
>
> So (in addition to the aes-fixed-time case) that's another case that
> just gets faster, and where the difference between aes-generic and the
> new generic code isn't actually relevant.
>

Fair enough. Thanks for the elaboration.
