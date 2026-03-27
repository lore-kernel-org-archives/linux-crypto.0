Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8629395249;
	Fri, 27 Mar 2026 20:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774642499; cv=none; b=E8B+HLCn/P1kSV05/p6STgp15TBdnteDqcqBcHfmQkpTY/G/WvkrB2TxMQ7nrNq9oqUgmK/VdDxHw+I6zOJlOdLqywmvrQAgbYSBEyD2Feh2VN0ZKl3XdkChglttGOB7tckA8/w6+3q9ryKC5tW6WFAD1W3RE1xhCqxS3HNJUAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774642499; c=relaxed/simple;
	bh=PnC1orF1BcpDcHQCyAGp11l4TWiGkuasZIyUwy6Alow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pY0f6EFT7Jbqcw24TQwQFTnEKOejrHa8Bn8UJ2OlX/w+n2TMEJ8pMThR+WGbvNv1Q+bftzetg1e8S3pRGp11g1fIJMAKLFHXxo0p6t/9t63NSnxICdF2fjeoAoSegLmsblt/WQjL3468JyIyic5q1LC/Eu0VKzbDWj9+un8vAPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gnux8i6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gnux8i6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3571DC2BC86;
	Fri, 27 Mar 2026 20:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774642498;
	bh=PnC1orF1BcpDcHQCyAGp11l4TWiGkuasZIyUwy6Alow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gnux8i6hhx5uxYa27SzezYKXcWErdV4JrawqD5wK343/mH88msF5WVcN/rvKJcYpd
	 2TNUcnQFwYudcIj0NTZ0LUAUOtjKWNWI08e9durUMJEx+G8+J29Gkx6XI2xCS0ZMIJ
	 abqIzfzb2zpzC3GI5vGexZLBOC5QOpf/cPgUa/LtgRGem3f4/9abLA0b/pl9Ask4FX
	 w9O38eziXvgtoSrMnT1nTA7RrmrBk1gDEx9GnzCqE0sF0a0q4G/Jiz5mbfiWvSnuBQ
	 eq+RmHWMo7D4jGCA37qu0l8VLMgIxqOWYPkEuMEoQg++CB/hGpP9ZqM77nMz9nMJwR
	 rWuXB5kTg2/qw==
Date: Fri, 27 Mar 2026 13:14:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	sparclinux@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: sparc: Drop optimized MD5 code
Message-ID: <20260327201456.GB25969@quark>
References: <20260326203341.60393-1-ebiggers@kernel.org>
 <fc5a80f3579d642a9f792a33b0f7ef6101838f83.camel@physik.fu-berlin.de>
 <20260326230232.GA67831@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326230232.GA67831@quark>

On Thu, Mar 26, 2026 at 04:02:32PM -0700, Eric Biggers wrote:
> On Thu, Mar 26, 2026 at 10:51:01PM +0100, John Paul Adrian Glaubitz wrote:
> > On Thu, 2026-03-26 at 13:33 -0700, Eric Biggers wrote:
> > > MD5 is obsolete.  Continuing to maintain architecture-optimized
> > > implementations of MD5 is unnecessary and risky.  It diverts resources
> > > from the modern algorithms that are actually important.
> > 
> > Why is it risky? That makes no sense.
> 
> Because there can be issues in architecture-optimized algorithm
> implementations that don't exist in the generic implementations.  That's
> a very common class of issue that has repeated over time.
> 
> > I also don't see how it diverts resources as no one is forced to work
> > on the code.
> > 
> > SPARC is an architecture used by hobbyists and in space these days (in
> > the form of Leon). I don't think any other kernel developer will have
> > to take a look at it.
> 
> Huh?  We've been refactoring how the various crypto and CRC algorithms
> are integrated, for all architectures.
> 
> So people outside the SPARC community, especially myself, been having to
> spend quite a bit of time updating the SPARC code so that it can still
> be used.
> 
> And this isn't new.  I've had to patch arch/sparc/crypto/ many times
> over the years as things change in the crypto subsystem.  Many other
> people, again outside the SPARC community, have as well.
> 
> The fact that you're denying that we've had to do this is really
> frustrating.  There is a significant maintenance cost to keeping this
> code working, which is being paid by people outside the SPARC community.
> 
> It seems best to at least focus that effort on modern algorithms like
> AES and SHA-256, and not obsolete ones like MD5 and DES.  Note that
> dropping those eliminates the need to add them to QEMU, as well.
> 
> I think that makes things easier for everyone.

Let me know if you're aware of a real user that needs the obsolete MD5
algorithm to be accelerated for SPARC in the kernel.

Otherwise, I suggest we proceed with this patch, as this objection seems
to based only on principles and misunderstandings.

I think our interests are aligned, actually: we both want Linux to work
reliably on SPARC.

- Eric
