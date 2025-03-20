Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F88224B1B
	for <linux-crypto@vger.kernel.org>; Thu, 20 Mar 2025 17:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742492092; cv=none; b=HSdUAYR7HmtP9vkjrAYK0RA1ER0HjJ9HfltFlKeNNqu82kwUH9m4EHXunFNLOtFsamSUbpuLhpvdEu5ipxrNK/Ez3x3+exQhK/yb8/M7luXtAhUjRu3xtkMUL3ek1w85m2G5B8+tOu1OTtTyhohHfMNMKADSnm4ZqYf9LEx7lEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742492092; c=relaxed/simple;
	bh=Yu5He2ygIik+idfAjHdNQOx+CbRP2Ueu+BM5nTiBt2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tDYgJxbkuPSF2EXkCj251Be636dX8DwZbBHGW2U5y50ET+1hF8wgrQ+UNA7n//lRrS+pq4fd3MvaOeZBzN0+8xTdbO7W2ZwQSOIOUAJiSTfZC0oZqi4+7fOjlUuUT4E+3wXeXdeBmkXVtqnLpcIHtbabwLze0w/H6c3clJxKZz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u1dPE6fO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u1dPE6fO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E23C4CEDD;
	Thu, 20 Mar 2025 17:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742492092;
	bh=Yu5He2ygIik+idfAjHdNQOx+CbRP2Ueu+BM5nTiBt2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u1dPE6fOAN6bn17U4CG0U66TvHGmkV3zp4Xp6HR2Y2cM8unF1Hw6eD3RJPQSfJE7r
	 y3vDKFNApA6yDE/RY8L8c9C3TpTgmu0o9nXZ4VIQ9kFOXuAJ9CUu6BHA4VouUAzVsA
	 1BzcWKnHFiCO4mjcWyq4BTxDfNxyMu20coxKqkkIpA3CtbDop59sTVx1zNQ8mwmfIN
	 dx0t+y4lGK+3XePatZinxzn9C1D+OLqbKjP1NL9/GhGjNEJL2ECcaMjoT62ug/omBW
	 3XgqCW+ZzsFgvWUvotTc9aAivRlOhC1zLONhUboIqWx38f8C2+yBGu9ZHO++hxzoyA
	 cloaG+eHZRtgQ==
Date: Thu, 20 Mar 2025 17:34:50 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	YOSHIFUJI =?utf-8?B?SGlkZWFraS/lkInol6Toi7HmmI4=?= <hideaki.yoshifuji@miraclelinux.com>
Subject: Re: [PATCH 0/3] crypto: Add SG support to deflate
Message-ID: <20250320173450.GA697647@google.com>
References: <cover.1742364215.git.herbert@gondor.apana.org.au>
 <CAMj1kXGAokDnf_spFU85qCh+quU4eewgWwCO6-UpCWDdf5Q0Og@mail.gmail.com>
 <Z9vOUut7CWJK0kVJ@gondor.apana.org.au>
 <CAMj1kXHXZoaf3H4brxm2O+mvw0iebEUkO2euNj4CeDVn4dz40w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHXZoaf3H4brxm2O+mvw0iebEUkO2euNj4CeDVn4dz40w@mail.gmail.com>

On Thu, Mar 20, 2025 at 09:55:42AM +0100, Ard Biesheuvel wrote:
> On Thu, 20 Mar 2025 at 09:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Thu, Mar 20, 2025 at 08:51:40AM +0100, Ard Biesheuvel wrote:
> > >
> > > IIRC Eric had some feedback at the time regarding the exact behavior
> > > of the zlib API, and I notice that the code no longer deals with
> > > Z_SYNC_FLUSH at all, which I did handle in my version of patch #3.
> >
> > I didn't see any feedback regarding this when looking at your patch:
> >
> > https://lore.kernel.org/linux-crypto/20230718125847.3869700-21-ardb@kernel.org/
> >
> > Do you have a link to that discussion?
> >
> 
> No. I did some digging but I could find anything. Eric might remember.

I'm not sure what this is referring to.

Then again this patchset doesn't apply, so it's unreviewable anyway.

Just a note, for compression and decompression it's often more efficient to
linearize in the caller.  Otherwise the algorithm ends up having to copy the
uncompressed data to an internal buffer anyway.  That's needed for the match
finding (compression) and match copying (decompression) to work.

As I mentioned before, the "stream" terminology that Herbert is choosing for
some reason also seems less than ideal.  "workspace" would be better.  Many of
the compression algorithms don't even support streaming.

> > I was going to add the original USAGI workaround but then I
> > thought perhaps it is no longer necessary as our zlib has
> > been updated since the workaround was added back in 2003.

The kernel's zlib was forked from upstream zlib in the 90s and hasn't been
re-synced since then.

- Eric
