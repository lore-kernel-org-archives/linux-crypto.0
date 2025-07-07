Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3F6205E3E;
	Mon,  7 Jul 2025 21:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751923445; cv=none; b=VmHCpJsxe+DPLzfr7CWyaPmdCwE5Ng6u7ecHeHZN5w0jUC0BKwm3RmDSvsp1iWgCOnPKt8SH5GdGCuECwy6zSKkh8P8fpvoavd/tQRKIcCtw0xhCgPw6ctk3n+Rr30KHWkW8OumRrIT2H665rm/qMVVT89l5X37/tsaQp7qLpvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751923445; c=relaxed/simple;
	bh=xpNTHbG6q2iPP7sWxxXBNL2204WEr54He9gRQyMKZ4U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kizHzuJhaLyfIi4gNfR/ArHz8eo+JpTJntbj/7+zQkn6MeSKAlPqj+N7yQBqfxb39OI++/iQ4/PD9UaEB37zUzV6I53GuQCxzEy1Fq+zAnd14AKpYPfsBVvLiz4yItMv3Tjm+CCCF2FdKyjne3HIvmHMarPgOoa90PNJCUg1aeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2fXTJlz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2fXTJlz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9849C4CEF1;
	Mon,  7 Jul 2025 21:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751923445;
	bh=xpNTHbG6q2iPP7sWxxXBNL2204WEr54He9gRQyMKZ4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S2fXTJlzw99cBuJOYDo24Vt5PIM8unsXx4/tnmikq7Z3jvbvXIBEXANUxtB2WLJ5x
	 WjnMj1pvZefaCLc2+9jgjXXfl1gk7OQnEl5Je5/3lAElWgQaS6DUxnK3Qhsrmv0b8c
	 a48pDPW8nq42DjKinxtuLdwSTSuw6EJrAxuohZX0O+DSk3r9gE+0+LiYJYMlXQpm7F
	 VF/6lKFYMSTPyMVAZrMHAdTyOsD1gtzUT3qDwfK3dT7rjMl8h1oHHNXyoezwycEPQH
	 i2CU0TESl3pXDZ6opSbQnMXtuAVOXn5qr6b/aZ1+qenUMAiRUAkpOOIs2I305xSuLl
	 uo1+VliqNWV6A==
Date: Mon, 7 Jul 2025 21:24:03 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>, Kees Cook <kees@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [GIT PULL] Crypto library fixes for v6.16-rc3
Message-ID: <20250707212403.GA3178810@google.com>
References: <20250618194958.GA1312@sol>
 <w3t36hsxocm3uotbhnonsioomnvkqpmazctyogmx36ehlxezyz@h4vytlcacc7k>
 <20250618215918.GB1639822@google.com>
 <dmkpj6q5mjw3bet6orkhcxtxwof4gufxknbroyfuwzrzcmdru6@4dmuaznfvkvz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dmkpj6q5mjw3bet6orkhcxtxwof4gufxknbroyfuwzrzcmdru6@4dmuaznfvkvz>

On Wed, Jun 18, 2025 at 06:05:37PM -0400, Kent Overstreet wrote:
> On Wed, Jun 18, 2025 at 09:59:18PM +0000, Eric Biggers wrote:
> > On Wed, Jun 18, 2025 at 05:40:27PM -0400, Kent Overstreet wrote:
> > > On Wed, Jun 18, 2025 at 12:49:58PM -0700, Eric Biggers wrote:
> > > > The following changes since commit 19272b37aa4f83ca52bdf9c16d5d81bdd1354494:
> > > > 
> > > >   Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)
> > > > 
> > > > are available in the Git repository at:
> > > > 
> > > >   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus
> > > > 
> > > > for you to fetch changes up to 9d4204a8106fe7dc80e3f2e440c8f2ba1ba47319:
> > > > 
> > > >   lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch() (2025-06-16 12:51:34 -0700)
> > > > 
> > > > ----------------------------------------------------------------
> > > > 
> > > > - Fix a regression in the arm64 Poly1305 code
> > > 
> > > Some more tests too, perhaps? :)
> > > 
> > > This was a bit of a scary one, since poly1305 was returning an
> > > inconsistent result, not total garbage. Meaning most of the tests
> > > passed, but fortunately the migrate tests read data written by userspace
> > > with a different library.
> > 
> > Yep, I have a KUnit test for Poly1305 planned.  Actually, I already wrote a
> > preliminary one and used it to test this patch.  I just haven't sent it out for
> > review quite yet, since so far it's just a one-off test that isn't too complete,
> > and I'm not satisfied with it quite yet.  I'd like to reuse the
> > hash-test-template.h I'm adding for SHA-2
> > (https://lore.kernel.org/linux-crypto/20250616014019.415791-5-ebiggers@kernel.org/)
> > which would result in a more complete test.  I'd also like to include tests for
> > some of the overflow cases that are specific to Poly1305.
> > 
> > So we're kind of still in an early stage where we're defining what the KUnit
> > testing for lib/crypto/ is going to look like.  I am working on it, though!
> 
> I do a little dance any time someeone says something like that about
> testing. Bravo :)
> 
> (And now, back to sifting through the rest of the rc1 breakage.)

FYI, the following patch adds a KUnit test suite for Poly1305:
https://lore.kernel.org/linux-crypto/20250706232817.179500-5-ebiggers@kernel.org/

- Eric
