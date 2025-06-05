Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B22127B50F;
	Thu,  5 Jun 2025 19:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151640; cv=none; b=grSLT74XqtQU3EjVotSRDR6PhVvD3W+DdXqVNmssRHy3LodhtpWVcKTMMjhazLIq+cZ9OHclbhKM9SUKGDYDwKXOZnwVHfROyp+rqylMdB1tVEJ0gGpsxHRyPw4cVvzJ+oz0F+UXv2Ube51BELUryIN7spgH6MU4BnthVDbsMz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151640; c=relaxed/simple;
	bh=3WLeMMjA+fh4IHJ7WaUMpxMaHvV88oJ6noWJB0AtLuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tzl4PWbzVcz2NACdvJ0F+xfWRkqSNGQChxaxbPabyTW7BBDwOzPmEh/S9kU4amNXVTK9CzX4Ur5tcSwSzVaw6EDlTS4ne8b9aIOpai7ODq0Rk4D/wThVNIH1/ftna8GHp2s9eHMeyBYobaISEpYU1CAO15xRC1UQ0/qY42u+R34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gW4S57n3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gW4S57n3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BBDC4CEE7;
	Thu,  5 Jun 2025 19:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749151637;
	bh=3WLeMMjA+fh4IHJ7WaUMpxMaHvV88oJ6noWJB0AtLuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gW4S57n3mhtK9MHfayjsnpSTZGK3FTatXC/GnUwAt9aBndZgnRpD2jx7i62EPiyiC
	 gX50B/IQOtdne8CqD2WJL0A0/em25RApjJONhUYAx052HbSb/3P5jJ1zreRPCsXTLj
	 tSkPGpEqmsUgxn+rQ/YnJaUPVDrL3iPgNpdEloSoXj24+KDVLffvTPdqeMVG6RD31N
	 /e7ZivjFEHtNmXhowOhdJxGcjkdRAl9tySz7eSaAB0UR6f4noawwKdu2RNaAxgCYgV
	 VC2iRn3YRv97LsJRPOghn5fSOOtw76Kyptz5MxVrh7+AwbXNL1nhfiG1DnW7kK+My3
	 3cYIFRdRWGX1Q==
Date: Thu, 5 Jun 2025 19:27:15 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Christoph Hellwig <hch@lst.de>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add entry for crypto library
Message-ID: <20250605192715.GB945328@google.com>
References: <20250605171156.2383-1-ebiggers@kernel.org>
 <CAHmME9ot0LdZ+SBYh9xLqFQLT0QL91mupwzUZRFyc=BV2QiJqw@mail.gmail.com>
 <CAMj1kXGEX_i-Gi3NAO+co6+4fKh5rQLhzwn=88wZbs+mVzGXPQ@mail.gmail.com>
 <CAHk-=wgd_4xrpXLUH1CGgGL=SXj0vq=XdJGGg388Exkti2Dg5Q@mail.gmail.com>
 <CAHmME9qE-gihY9XK0nNnRY+mHeTNNgn1qi1E7xCKJACFz-uqDg@mail.gmail.com>
 <CAMj1kXHthZYSrZzUEkMzjO+Jwy2LA4WUCCBosScX3P8FAPn1yQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMj1kXHthZYSrZzUEkMzjO+Jwy2LA4WUCCBosScX3P8FAPn1yQ@mail.gmail.com>

On Thu, Jun 05, 2025 at 09:01:49PM +0200, Ard Biesheuvel wrote:
> On Thu, 5 Jun 2025 at 20:46, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Thu, Jun 5, 2025 at 8:45 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > Should I just add you and Jason directly as 'M:' entries for this?
> >
> > Works for me.
> 
> Sure.

Listing Ard and Jason as M: is fine with me.  I expect that in practice I'll be
applying the patches and doing the pull requests for now, so (as is often the
case with subsystems with multiple M:) in practice it will really be a primary
maintainer and backup maintainer(s).  But I'm happy to have Ard and Jason listed
in case one of them needs to step in.

- Eric
