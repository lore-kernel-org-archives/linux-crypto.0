Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D05326292;
	Thu,  6 Jun 2024 08:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717662810; cv=none; b=GFt/mn28PDRK45pWgkGN4rxYvuhkQcvLESgyELr9za6vVJPeJTwANACn11pc7dIgXSIqMkNF15uyq+90+ZwqlDuy5zzs8sN4PZZk58DkPvi/G2PdCVwjAWEq78/5zt3WLKST24LEFxvnXD/kq60l610mKhFAMu587bc9M+M62oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717662810; c=relaxed/simple;
	bh=YU8DtIKwHmMDfcku625+Vpqv5ex7ZLivp9rvHDTWByE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PB/GpTxnWCvccAD+thzOgtogGcq0a4qE9C57uVR1op6+8gM8RW9rVU9coSAcE+QW42I3v4L5pCV+bZlDR9ItvWb//4DO0MguPyn9BVGaNyFUPt7rkQYrpD0w5cGrZbc1kLLQPWvRvGWZgZmLd44kF8RwcO/oen8XyGXBr5Cdpzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=po1DSTJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="po1DSTJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A330CC4AF0A;
	Thu,  6 Jun 2024 08:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717662809;
	bh=YU8DtIKwHmMDfcku625+Vpqv5ex7ZLivp9rvHDTWByE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=po1DSTJPR7pCkBP++C9n0OVIEUUHGYM4Clm7DsESYlFedwNWo0hXKL1ODuR+rsWoD
	 a8MsvY8lCHPE0FFF8K+KlgQ+/PODp9A2/HbhcUulz9ytIXMGL2GznC3GG/nsq/q8ow
	 Tle1vCwc96KAY4K7LOztRsxT8VRUrmZhe56jp2lEimu0gQd1OO9jJGPBoiSiXOdFmU
	 aPluFG5dT8IkyqRn86PA/srqXRDEn8ZHVXqtfsL4opkcvnoiBe7ezBT44xFvt20pFG
	 Kg81cK1Dmzo6SlWmcnn32f3lRgOMJ9zLVKz1bNAC0ja9Uje18dnEAuvGrLLHkju4o2
	 8b+vcGLtxVqYA==
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2e6f2534e41so6961811fa.0;
        Thu, 06 Jun 2024 01:33:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWeJg9MuGqxmmiV8mwi02uhIGutUR7xkeifRDRtgnpn/6laxV2mT75gGcEhWiGHdEahKyGKVNDOH1QkOwo3jL1BivqD9q9MqahC5hUjosEAp7U6xBo60lUy4aTZSoPI2Sp2lohL
X-Gm-Message-State: AOJu0YxngvwrMSpfmKZUlpbS1VfXp5Om1uHooxo1G6I5IQA8l2XdjCl+
	x+uzzpoEQBB01t+VAvwGSiUjRd1H2Bj+hZA5V5VoyTa2JoTkfmU7tURiqagFIB3jWeon1QKeO+B
	Sfljq7ZdKIasFbsslEk/CFtSEl8k=
X-Google-Smtp-Source: AGHT+IFrHl6y+9zDbUsyBzAkg+/OK1noLI5GhExckzXCAkObvxedgkVmF5FHs6vRCM1MElpokOpj+znX9hNmHP4O2WU=
X-Received: by 2002:a05:651c:a11:b0:2df:b0e3:b548 with SMTP id
 38308e7fff4ca-2eac7a52b32mr31799341fa.42.1717662808019; Thu, 06 Jun 2024
 01:33:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZmAthcxC8V3V3sm3@gondor.apana.org.au> <ZmAuTceqwZlRJqHx@gondor.apana.org.au>
 <ZmAz8-glRX2wl13D@gondor.apana.org.au> <20240605191410.GB1222@sol.localdomain>
 <ZmEYJQFHQRFKC5JM@gondor.apana.org.au> <20240606052801.GA324380@sol.localdomain>
 <ZmFL-AXZ8lphOCUC@gondor.apana.org.au> <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
 <ZmFmiWZAposV5N1O@gondor.apana.org.au> <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
 <ZmFucW37DI6P6iYL@gondor.apana.org.au>
In-Reply-To: <ZmFucW37DI6P6iYL@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 6 Jun 2024 10:33:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEpw5b3Rpfe+sRKbQQqVfgWjO_GsGd-EyFvB4_8Bk8T0Q@mail.gmail.com>
Message-ID: <CAMj1kXEpw5b3Rpfe+sRKbQQqVfgWjO_GsGd-EyFvB4_8Bk8T0Q@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using multibuffer hashing
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org, 
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>, 
	Bart Van Assche <bvanassche@acm.org>, Tim Chen <tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Jun 2024 at 10:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jun 06, 2024 at 09:55:56AM +0200, Ard Biesheuvel wrote:
> >
> > So again, how would that work for ahash falling back to shash. Are you
> > saying every existing shash implementation should be duplicated into
> > an ahash so that the multibuffer optimization can be added? shash is a
> > public interface so we cannot just remove the existing ones and we'll
> > end up carrying both forever.
>
> It should do the same thing for ahash algorithms that do not support
> multiple requests.  IOW it should process the requests one by one.
>

That is not what I am asking.

Are you suggesting that, e.g., the arm64 sha2 shash implementation
that is modified by this series should instead expose both an shash as
before, and an ahash built around the same asm code that exposes the
multibuffer capability?

> > Sure, but the block I/O world is very different. Forcing it to use an
> > API modeled after how IPsec might use it seems, again, unreasonable.
>
> It's not different at all.  You can see that by the proliferation
> of kmap calls in fs/verity.  It's a fundamental issue.  You can't
> consistently get a large contiguous allocation beyond one page due
> to fragmentation.  So large data is always going to be scattered.
>

I don't think this is true for many uses of the block layer.

> BTW, I'm all for elminating the overhead when you already have a
> linear address for scattered memory, e.g., through vmalloc.  We
> should definitely improve our interface for ahash/skcipher/aead so
> that vmalloc addresses (as well as kmalloc virtual addresses by
> extension) are supported as first class citizens, and we don't turn
> them into SG lists unless it's necessary for DMA.
>

Yes, this is something I've been pondering for a while. An
ahash/skcipher/aead with CRYPTO_ALG_ASYNC cleared (which would
guarantee that any provided VA would not be referenced after the algo
invocation returns) should be able to consume a request that carries
virtual addresses rather than SG lists. Given that it is up to the
caller to choose between sync and async, it would be in a good
position also to judge whether it wants to use stack/vmalloc
addresses.

I'll have a stab at this.
