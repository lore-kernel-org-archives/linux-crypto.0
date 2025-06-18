Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C838C27D786;
	Wed, 18 Jun 2025 21:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283960; cv=none; b=dkNgMKK4oAx6RmIYqxkLlUS4ouV0URSg5yeFqIgBxsnw0YpSILZpjUx1kbd1k2uh2OOHpzFUiDMaF7l2lygQGK5JkV9pyDAv94OQPsUFAR+X6EMzbJmvhoCRcR8raKi8c21oan1i49NM6XPZrsqn2lZlPzHmE4sjNvIoA4nTRaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283960; c=relaxed/simple;
	bh=Je3kP6dBeDU3g3jDxX1HC5wz2qRrqXVZ4zX+5FveMU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTn7TqcbTdj3ySVc8l8LbbIdskTUqBPTAH5Fe61XQhFPxeNJFPOW+vW0E68svVtkuonvFm7nRKSse7kQToLNVc5Dv4e28CfkyaNBFPYvxp7DLyL4xgS5kRW8rtpOBwG4yJ4cZkCvob07Bfr5EKu1tTskOoc3yWtKQKgaTef23lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwIk4FD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwIk4FD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21762C4CEE7;
	Wed, 18 Jun 2025 21:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750283960;
	bh=Je3kP6dBeDU3g3jDxX1HC5wz2qRrqXVZ4zX+5FveMU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PwIk4FD9Iwxme1GAtF24hIfbKzss96UEAR0POpE22iKsklgrsw08yLfugqksd8VCo
	 4fJSNCQBZ9buCtof9GDUKXbr9Z4EU1B9pnwEUC0qcUEmI9Kz7f79/5vR6NF6jH7OH8
	 lK6wTdGEIv+xgITGSn8KDA9Cf6bVxoQgkM++2EQGMiWCFtCvPevb0sqBr1FeNq0TwO
	 xYOD4vg52ALxx6BsEOvN16l6SHj/MOEsYPQ2mUQCC5bliogC50IhdefMggAiesCqDZ
	 zYj6xFwUbZR1S7boyD7N0deENFCCmf+qJtMIYhreECiRa60aCaicO13awHeHmmUsgq
	 JjpZadEoU4wLg==
Date: Wed, 18 Jun 2025 21:59:18 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Kees Cook <kees@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [GIT PULL] Crypto library fixes for v6.16-rc3
Message-ID: <20250618215918.GB1639822@google.com>
References: <20250618194958.GA1312@sol>
 <w3t36hsxocm3uotbhnonsioomnvkqpmazctyogmx36ehlxezyz@h4vytlcacc7k>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w3t36hsxocm3uotbhnonsioomnvkqpmazctyogmx36ehlxezyz@h4vytlcacc7k>

On Wed, Jun 18, 2025 at 05:40:27PM -0400, Kent Overstreet wrote:
> On Wed, Jun 18, 2025 at 12:49:58PM -0700, Eric Biggers wrote:
> > The following changes since commit 19272b37aa4f83ca52bdf9c16d5d81bdd1354494:
> > 
> >   Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
> > 
> > for you to fetch changes up to 9d4204a8106fe7dc80e3f2e440c8f2ba1ba47319:
> > 
> >   lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch() (2025-06-16 12:51:34 -0700)
> > 
> > ----------------------------------------------------------------
> > 
> > - Fix a regression in the arm64 Poly1305 code
> 
> Some more tests too, perhaps? :)
> 
> This was a bit of a scary one, since poly1305 was returning an
> inconsistent result, not total garbage. Meaning most of the tests
> passed, but fortunately the migrate tests read data written by userspace
> with a different library.

Yep, I have a KUnit test for Poly1305 planned.  Actually, I already wrote a
preliminary one and used it to test this patch.  I just haven't sent it out for
review quite yet, since so far it's just a one-off test that isn't too complete,
and I'm not satisfied with it quite yet.  I'd like to reuse the
hash-test-template.h I'm adding for SHA-2
(https://lore.kernel.org/linux-crypto/20250616014019.415791-5-ebiggers@kernel.org/)
which would result in a more complete test.  I'd also like to include tests for
some of the overflow cases that are specific to Poly1305.

So we're kind of still in an early stage where we're defining what the KUnit
testing for lib/crypto/ is going to look like.  I am working on it, though!

- Eric
