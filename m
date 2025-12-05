Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0CC32FA24
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 13:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764943172; cv=none; b=NOwSzzKIR3OvLchqCforZNV3aMWq+91Nziv0eL5C7vAD5LT6aTRshh1TGRAHn82H+h13Py6Ch95GxIgZnJYY/MMX4Kj3eV5Uwt5IGwoxoO19UcyS5KFLijZpB7ScD6IseCkSwFnHDyva8Z1fzRjaONR4wOFt3XZXZQOMksmZ9K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764943172; c=relaxed/simple;
	bh=4IXfqyjXtHK9jCKM3TtYWBqAAZ/9LBL9OTlbhk3UYKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btDTZXUriC4SIcYzrtqpAqhSvPeClu21X0RcuHQxy51DsdGJ6XhkNFajN4/bYS5rHAqqt5WRLlWOIE16jNoI14FwrmExLOm5RZV5dCjjHBp195jhR3j9rl1onD3ywimWtk0xMtjyQHzCB4tApc8TOuR/S/nfGtoHoCHpvYJssR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFrlkz+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFrlkz+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA917C4CEF1;
	Fri,  5 Dec 2025 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764943171;
	bh=4IXfqyjXtHK9jCKM3TtYWBqAAZ/9LBL9OTlbhk3UYKs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dFrlkz+vPNLVd9tp/GICOAtq8DpktjY24MWU4BBdeQ4OyZ0OFkiu5GdFLZ7XdgdiI
	 mZN03eNgisHNmtfB0rp42GKZyzN3NlbUCW22EAaKsJlIA7Gb5r+jbBVOX4yzRg42si
	 f+8Ov9e5IWwO7l6boLys/mNUk1M9uic1AlTMhtOw9geh61gnbZF45SwYU9nf/xWBYD
	 cHQ86b1UvzcFbUhK1rrU05VP3VHMhKhMsrE0L69Nj9bvRvTJtYU+Gas5desrQnal5w
	 lyfA01pZvXLuwCr0J+p9zEqjITOCoTjtZp4/SDg72tfw3iFrLduzHS+afuWFvv1Adu
	 L6r2WV6EVwP3g==
Date: Fri, 5 Dec 2025 13:59:26 +0000
From: Daniel Thompson <danielt@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de,
	ebiggers@kernel.org, kees@kernel.org, linux-crypto@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <aTLlPhIAbQZqOVjb@aspen.lan>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <aTByNvAYRhZI07cJ@aspen.lan>
 <o3yq4m3ihmynvcrrp6u2xshngxtgso2cqrdhfazyxxm7udvs46@wzyl6qu4lmqt>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <o3yq4m3ihmynvcrrp6u2xshngxtgso2cqrdhfazyxxm7udvs46@wzyl6qu4lmqt>

On Wed, Dec 03, 2025 at 07:01:39PM +0100, Alejandro Colomar wrote:
> Hi Daniel,
>
> On Wed, Dec 03, 2025 at 05:24:06PM +0000, Daniel Thompson wrote:
> [...]
> > > Be careful about [static n].  It has implications that you're probably
> > > not aware of.  Also, it doesn't have some implications you might expect
> > > from it.
> > >
> > > -  [static n] on an argument implies __attribute__((nonnull())) on that
> > >    argument; it means that the argument can't be null.  You may want to
> > >    make sure you're using -fno-delete-null-pointer-checks if you use
> > >    [static n].
> > >
> > > -  [static n] implies that n>0.  You should make sure that n>0, or UB
> > >    would be triggered.
> > >
> > > -  [n] means two promises traditionally:
> > >    -  The caller will provide at least n elements.
> > >    -  The callee will use no more than n elements.
> > >    However, [static n] only carries the first promise.  According to
> > >    ISO C, the callee may access elements beyond that.
> >
> > This description implies that [n] carries promises that [static n] does
> > not. However you are comparing the "traditional" behaviour (that is
> > well beyond the scope of the standard) on one side with ISO C behaviour
> > on the other.
> >
> > It makes sense to compare ISO C behavior for [n] (where neither of the
> > above promises applies) with ISO C behaviour for [static n]...
>
> Clang seems to implement the ISO C behavior, so in retrospective, the
> comparison I did seems appropriate.  By moving from the GCC/traditional
> behavior to the Clang/ISO one, a project would be lowering quality.

I'm still rather dubious about confusing the optimization opportunities
afforded by the ISO C standard with the diagnostic messages that both
gcc and clang can produce (and are beyond the scope of the standard).

However, let's agree to disagree on that, since it doesn't change the
outcome: it *is* useful to compare the behaviour of the two compilers.


> Plus, there's still the issues about n>0 and nonnullness.
>
> The only reason why it makes some sense to use [static n] in the kernel
> is because it's moving from no-rules to some rules.  But the real
> problem here is that the kernel needs to turn GCC's -Wstringop-overflow
> off, and that's what the kernel do some effort to re-enable.
>
> If you show a minimal reproducer of what the problem is with
> -Wstringop-overflow, I may be able to help with that.

I'm not 100% caught up on the history but I think this was the issue
that prompted -Wstringop-overflow to be disabled by default (and
includes a minimal reproducer):
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113214


> In general, [static n] is bogus and never to be used, except temporarily
> while other issues get fixed, like in this case.
>
> > >    GCC, as a quality implementation, enforces the second promise too,
> > >    but this is not portable; you should make sure that all supported
> > >    compilers enforces that as an extension.
> >
> > ... and equally it makes sense to compare the gcc/clang warnings for
> > [n] versus [static n] as recommended here.
>
> Clang is really bad at both [n] and [static n].  If you need to rely on
> clang for array bounds, you're screwed.

What do you mean by clang is really bad at [static n]? Most of this
thread is based on the observation that clang gives *useful*
diagnostics for [static n] that are not issued for [n].


> > However it should not be motivated by [static n] carrying few promises
> > than [n], especially given gcc/clang's enforcement of the promises is
> > a best effort static check that won't cover all cases anyway.
>
> GCC is quite good at those diagnostics; it might not cover all cases,
> but that's better than what ISO or Clang will promise.

gcc certainly can generate warnings we don't get with clang, so it's
just a question of whether the false positives are enough to stop it
from being quite good!

I was curious is anything has changed in the last two years so I
compiled v6.18 allmodconfig with -Wstringop-overflow (without the
thread sanitizer which causes the known problem mentioned above
right the way up to gcc-15.2). I ran check across five architectures
(arm64, arm, riscv, s390 & x86) since we know there have been
architecture dependant differences. Not all the builds have gone
through but unless there are regressions in newer compilers then
I've only seen two -Wstringop-overflow warnings.

First is a clear false positive (of the "if something impossible
happens then something bad might happen" variety) which, happily, is
only triggered on gcc-12/aarch64 and appears to be fixed from gcc-13
onward.

Second isn't a kernel bug but it's arguably not a false positive
either. I think it could be reasonably fixed with source code changes.
See https://elixir.bootlin.com/linux/v6.18/source/net/sctp/auth.c#L645

Overall I'll look a little deeper to try and see if there are any
other ways to break -Werror builds with gcc-13 or later.


Daniel.
