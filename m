Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9019135942;
	Sat, 29 Mar 2025 18:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743273502; cv=none; b=cCdVvlLrbysld4kkKvETJ3vv3qiFhhGtC6d4kOZ+8AKbZwDUxpyNED+lvWqq+H7fTl507/osjjMctItqo4ssIX3F2fHt/9pRBSyjcIbPkywsFFau5afCKJ2wQ0HDrMNlnD1aK7LDCaqJt1bkPQUiDU5m/oPpTMKEnF11kWyZ++o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743273502; c=relaxed/simple;
	bh=d1viuqJkDBo9A3Oay9+iVUwbi8rx0kLFMrTHwdEFHUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m8gYJg9X2I7IOPPF6/CcziI814jR08cXg5q/gduIiyjNK5y8L3OTgRGpMGTim2HWxUtsKykpa8YWved4SCbVHWm79/kyyLuLP/bHPevuX+0gMbzsj8/gXaqB/ci8iTn+fVmjCzJCPYrumUumRORHLj7jB6srce+cFuDaaGTKVBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GIbvEiiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GIbvEiiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC498C4CEE2;
	Sat, 29 Mar 2025 18:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743273502;
	bh=d1viuqJkDBo9A3Oay9+iVUwbi8rx0kLFMrTHwdEFHUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GIbvEiiqMVaCRJg3gpVZdKIq9p6MYTvCUYkt6Dpp7zHeqbLJpPXjxHgQQBLTn4EOg
	 YnfqLtGisPZ9O9LXvfHoRmjP9e8MZYZYUPuQY4oE82vtpJjOTQgT0GWlgxIQr828/w
	 fsnXbiTduhG8hYXrXZbx4uXOhy8QHugQaXkBwGVAYHbnSC2QzLlC2lQUmv8Zdwl+XJ
	 2oXqrv6VEsrHdozmv2tyBZmvvxGDhbySOTdEZbKpYMTTuGqqtYeqafpYKqCljoMMnz
	 kdaImdBQKvO06KZpfpF9ABqXQaUcYgK9zK6jb3oMDF3m+O+/n5f9U2tpZGBSkMusjl
	 +j5y6oh+HeQ0A==
Date: Sat, 29 Mar 2025 11:38:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.15
Message-ID: <20250329183820.GB4018@sol.localdomain>
References: <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <CAHk-=whoeJQqyn73_CQVVhMXjb7-C_atv2m6s_Ssw7Ln9KfpTg@mail.gmail.com>
 <20250329180631.GA4018@sol.localdomain>
 <CAHk-=wi5Ebhdt=au6ymV--B24Vt95Y3hhBUG941SAZ-bQB7-zA@mail.gmail.com>
 <CAHk-=wiA0ioL0fonntfEXtxZ7BQuodAUsxaJ_VKdxPrnKx+DAg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiA0ioL0fonntfEXtxZ7BQuodAUsxaJ_VKdxPrnKx+DAg@mail.gmail.com>

On Sat, Mar 29, 2025 at 11:19:19AM -0700, Linus Torvalds wrote:
> On Sat, 29 Mar 2025 at 11:17, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I happened to just merge the rdma updates a couple of minutes ago, and
> > they actually removed the example I was using (ie the whole "use
> > crypto layer for crc32c" insanity).
> 
> Heh. Looking closer, the "they" was actually you who did the patch and
> Leon who applied it.
> 
>             Linus

Yes.  Those cases were just a single algorithm, though, so of course the library
was simpler.  fs-verity supports two hash algorithms (SHA-256 and SHA-512), and
dm-verity unfortunately supports every hash algorithm the crypto API supports
since it accepts it as a string and passes it directly to the crypto API.  I
know for sure dm-verity is used with at least SHA-256, SHA-1, and BLAKE2b, but
there could be more.  The crypto API also supports various "national pride"
algorithms like SM3 and Streebog, for example, and some people might expect
those to work with dm-verity.  (Unfortunately SM3 keeps getting pushed into
various standards, libraries, CPU instruction sets, etc.)

So for fs-verity we'd basically need:

    if (using SHA-256)
        sha256()
    else
        sha512()

    (and the same for any other algorithms that may get added in the future)

And for dm-verity we'd basically need:

    if (using SHA-256)
        sha256()
    else
        Use crypto_ahash or crypto_shash to handle arbitrary algorithm

And that's okay -- we can do that.  Just crypto_shash ends up being
approximately what is needed already, so just using it seems slightly
preferable.  But using the libraries whenever possible would be fine with me
too.

- Eric
