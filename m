Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691881547C3;
	Tue, 25 Mar 2025 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742921992; cv=none; b=GHkESm8EBuFD7QZe9ErBKuafS3XOsjayCRlItog4KmwE44ITkhEjvPD0r5wVvDkuITuv+udb1Vw7Uy+Gkk/uDjxOL2JikLfAs32th4PJeOLiSVEgyl8DfFUXIDbTJmuh0g7X4lJyyIMteADJZ4qkqvnWbkUyyE/1ZUEuY3PfETc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742921992; c=relaxed/simple;
	bh=TvuNV6wKnM0OfxGqgTXqnI3weghrkbXm3vheYinYnSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g9h5FjpcXtrkoyLJICC5l2NhDXz4x2RnFAswk6bVca0rTChMbDtFm8J2+8Z4pG1NIv+EZfD4wlP56vGoHif+yA1xanvXucznUuC6NUQ9XqX+L8bezKtyzp5qhi35QBWoy8w9Z4+J9OMfsQSEamdm6nOSUg2Grw9CbXDgbsLKcXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YFVVbQyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YFVVbQyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3D7C4CEEE;
	Tue, 25 Mar 2025 16:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742921991;
	bh=TvuNV6wKnM0OfxGqgTXqnI3weghrkbXm3vheYinYnSo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=YFVVbQywsW5HNlyalHgO9qClrVkGoea6T0cK2kb5qUUVpe4UtcD9OyNQn6GwOgc5w
	 KZ8BMeg0b7/tvTrwSDzjfI1Ed032SMtEnzc9fOLAPFdop7qmCP8sSyNwaKMGOc4vLo
	 oSkxiOYuOWTWfokEJSKFO8iwmMySncVMfoAelcg0P2dwbDfGY4KiXxl5iHBFc6s4s2
	 Y7EDJ2VQCiOLAqsTOB/o8OZDXetwGLr81fylaTLzkmS00VnhDSUVmDYEfAQO5MmCBG
	 5EPXANUu1uwCWXhtjtqO0kvPsAz79cXMlwIl5/DkF90xU+fPzau807rfYYw9AUqj8m
	 tdMTQsVpdgHgQ==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-30beedb99c9so56167421fa.3;
        Tue, 25 Mar 2025 09:59:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVK41/zb3BtwsltTb13N6+RBpi2+3vv6ru4Em3O3/o04+6E9H3IjlQiNP+OE8EtC6Q3fYLvON41BVAEkGdf@vger.kernel.org, AJvYcCWgNsrgeKWiFyyWZE1Z8YFBtP+X7vKOHuMVTJP6cId1Ybhjv2ZGrJoN/TaZulqsBlcu2b3cGQZN82N0Vv0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcWUTjdnPY2HVQ1jz2uvtkZ7YH8gffaQUF6Q98tMV0HPs0OoG6
	qk16bblvmQ2Umd3p2JSSHS4mDVtvPpm2biwmjeMHJSzpNH4Gzqn0EPweqc81p7pVrDu/pSPCG7Q
	/Zf2yPchrL8uMm4GkiJ7tuqGL5LA=
X-Google-Smtp-Source: AGHT+IF0mLfYg906NjEtDJUBzhsSCFQvlfBVJeusa824a/YnxCdYXhYU64I5Kq9m2fk2SN5sjC3u2ZaN/0XMxdCr5QM=
X-Received: by 2002:a05:651c:19a7:b0:30b:b00f:9507 with SMTP id
 38308e7fff4ca-30d7e2aaca1mr70115571fa.24.1742921990190; Tue, 25 Mar 2025
 09:59:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZOxnTFhchkTvKpZV@gondor.apana.org.au> <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au> <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au> <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au> <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au> <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au> <20250325152541.GA1661@sol.localdomain>
In-Reply-To: <20250325152541.GA1661@sol.localdomain>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 25 Mar 2025 17:59:39 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFM29ZM5ncyZLrAbX35V7y8=C-n8KT0y1SZhafK_+5aHg@mail.gmail.com>
X-Gm-Features: AQ5f1JqtBqIc34Ji6-nObeR0Ug-BwTZ3CpgACCZqe_azCWAm-c_PGc92djp7YpQ
Message-ID: <CAMj1kXFM29ZM5ncyZLrAbX35V7y8=C-n8KT0y1SZhafK_+5aHg@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Update for 6.15
To: Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 25 Mar 2025 at 16:25, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Mar 25, 2025 at 01:53:28PM +0800, Herbert Xu wrote:
> >
> >       crypto: hash - Add request chaining API
>
> Herbert didn't mention that I have nacked this patch, which he is insisting on
> pushing for some reason instead of my original version that is much better.
>
> Let me reiterate why "request chaining" is a bad idea and is going to cause
> problems.
>
> It makes it so that now a single hash request can now actually be a list of hash
> requests.  It makes some of the crypto code operate on the whole list.  However,
> most code still operates only on the first request in the list.  It's
> undocumented and inconsistent which code is doing which, which is going to cause
> bugs.  The first request in the list is also being treated specially in
> undocumented ways, so submitting a list of requests is not necessarily
> equivalent to submitting them all individually.  Another recipe for bugs.
>
> Each hash request can also contain an entire scatterlist.  It's overkill for
> what is actually needed for multibuffer hashing, which is a simple API that
> hashes two buffers specified by virtual address.  Herbert's API creates lots of
> unnecessary edge cases, most of which lack any testing.  It continues many of
> the worst practices of the crypto API that we *know* are not working, like
> requiring per-request memory allocations and optimizing for legacy hardware
> offload rather than the CPU-based crypto that almost everyone actually uses.
>
> In contrast, my patchset
> https://lore.kernel.org/r/20250212154718.44255-1-ebiggers@kernel.org/ supports
> multibuffer hashing in a much better way and has been ready for a year already.
> It actually works; it has a smaller diffstat; it is faster; it has a much
> simpler API; and it actually includes all needed pieces including x86 and arm64
> support, dm-verity and fs-verity support, and full documentation and tests.
>
> I've been spending a lot of time fixing the kernel's crypto code over the years.
> I'm not looking forward to having another set of major issues to fix.
>
> And this latest set of issues will be totally unnecessary.
>
> We can do better than this, especially for cryptography code.
>
> Nacked-by: Eric Biggers <ebiggers@kernel.org>
>

It's sad that it is coming to this, but I have to second Eric here:
for CPU based crypto, the flexibility of Herbert's approach has no
added value. SHA CPU instructions can be interleaved at the
instruction level to get almost 2x speedup in some cases, and this
works very well when operating on equal sized inputs. However,
generalizing this to arbitrary request chains to accommodate async h/w
offload introduces a lot of complexity for use cases that are only
imaginary.

Given Eric's track record as a contributor to the crypto subsystem and
as a maintainer of subsystems that are closely tied to it, I would
expect Herbert to take his opinion more seriously, but it is just
being ignored. Instead, a lightly tested alternative with no
integration into existing users has been merged in its place, with
very little input from the community.

So Herbert, please withdraw this pull request, and work with Eric and
the rest of us to converge on something that we can all get behind.
