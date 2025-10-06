Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9232DA744;
	Mon,  6 Oct 2025 16:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759767229; cv=none; b=GeaENAT3YVBXZGjjnpi0mrEc6lrRnPEIE7FJVhlSUBvnxi9+cb/j98TxhFA4sjmCzFA1fe6LF6+otJUWex05h8qIn5xzUPRdFv8F8r0m7+ahOGwCXgXnapvlDkTdjHG1Q/ww5+aU99b1OdfHvrxI0RIVNb2alzDFdQxxagnpdfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759767229; c=relaxed/simple;
	bh=79Iw1IGb28pa+X0mtY+qGKGqGWEFqy8gLP5kuhDKQWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ohr3klKQ6Brwb04pN4uIs6tIli1OcxPs5mk0ovGwxFCVRuKp6AlPYoc03WWe7+YHI4jTupOBcAy0+kObrWtJKGlWUZkraKzaCaknRktwUX+e4zgdqkb6ypJqC8cUEKV792+zs6GyqirKPtLijMmjOgu8wextqGjXze/qKqK7pR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNmNtqIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNmNtqIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A71C4CEF5;
	Mon,  6 Oct 2025 16:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759767229;
	bh=79Iw1IGb28pa+X0mtY+qGKGqGWEFqy8gLP5kuhDKQWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZNmNtqIcbr13jMX27xh+dTJH1O0p+PMtFaYKdE1woKpKwUqH0i/L5WxNRPpHjhjFw
	 e3Fn5SIXVm5M/+vWdgDuaS16Bd+XajTG6rF1tCBMxSQ8VtIhHOKXlDFshYvEBfMr78
	 6nnzNn49KLAad9q717CtdO9FzxkwYmWi7e2n2u2qYEIxW8cM3fqsn1JItPuAT+vdFi
	 Zs1AlnjgcTVzZw7NxbiP/foLkClDCOiP0Y5rH5fbHSZV4iiUCnuAOYzi68OXOHFR3j
	 iP6mdAcSWsham3UIEXmb5A3pzkiOKUMJEIUwTLDNKizWgKvQ10KVnbuSdao+CKKcnb
	 bQ0UR5r59g4Pg==
Date: Mon, 6 Oct 2025 09:12:25 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Jiri Slaby <jirislaby@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, "nstange@suse.de" <nstange@suse.de>,
	"Wang, Jay" <wanjay@amazon.com>
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
Message-ID: <20251006161225.GC1637@sol>
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
 <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
 <aN5GO1YLO_yXbMNH@gondor.apana.org.au>
 <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
 <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
 <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com>
 <20251002172310.GC1697@sol>
 <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2981dc1d-287f-44fc-9f6f-a9357fb62dbf@oracle.com>

On Mon, Oct 06, 2025 at 01:53:21PM +0200, Vegard Nossum wrote:
> On 02/10/2025 19:23, Eric Biggers wrote:
> > On Thu, Oct 02, 2025 at 01:30:43PM +0200, Vegard Nossum wrote:
> > > I'd like to raise a general question about FIPS compliance here,
> > > especially to Eric and the crypto folks: If SHA-1/SHA-256/HMAC is being
> > > made available outside of the crypto API and code around the kernel is
> > > making direct use of it
> > 
> > lib/ has had SHA-1 support since 2005.  The recent changes just made the
> > SHA-1 API more comprehensive and more widely used in the kernel.
> 
> Sure, it was available under lib/ but what matters is that there were no
> users outside of the crypto API.

That's incorrect.  The SHA-1 library was already used by
kernel/bpf/core.c and net/ipv6/addrconf.c.  And also
drivers/char/random.c prior to 5.17.

> Adding direct users presumably breaks the meaning of fips=1 -- which
> is why I'd like us to work out (and explicitly document) what fips=1
> actually means.

Well, fips=1 has never had any documentation.  If anyone cares they
should document it.

But also, as I said, if certain kernel subsystem(s) mustn't use certain
algorithms when fips=1, then the people who care about FIPS are welcome
to add that logic to those subsystems.  It's trivial:

    #include <linux/fips.h>

    if (fips_enabled)
            return -EOPNOTSUPP;

Sure, it's 3 lines per subsystem, but compare that to the 50-200 that
typically gets saved by switching to the library.  And the library
solves a number of other problems too.  So it's still well worth it.

I'll plan to add these checks to MD5 uses when doing MD5 conversions in
6.19.  Yes, I didn't add them to SHA-1 uses when doing SHA-1 conversions
in 6.18, but it's clear that disallowing SHA-1 is still a
work-in-progress anyway.  I'll assume that you or someone else are going
to finish the work for SHA-1 at some point.

> > Still, for many years lib/ has had APIs for SHA-1 and various
> > non-FIPS-approved crypto algorithms.  These are used even when
> > fips_enabled=1.  So, if this was actually important, one would think
> > these cases would have addressed already.  This is one of the reasons
> > why I haven't been worrying about adding these checks myself.
> 
> I see some direct uses of lib/ algorithms outside the crypto API on
> older kernels but at a glance they look mostly like specific drivers
> that most distros probably don't even build, which might explain why it
> hasn't been a problem in practice.

Again, incorrect.  Core kernel functionality uses, and continues to use,
non-FIPS-approved crypto algorithms.

Maybe the FIPS people assessed each of those use cases and determined
that they are not "security functions".  But I and other upstream kernel
developers have no visibility into that.

More likely IMO is that the FIPS people are just ignoring reality.

> I'd assume most distributions that provide FIPS-certified kernels care.
> As far as I can tell, they are all going to run into problems when they
> start providing products based on v6.17. Maybe I'm wrong and it comes
> down to an interpretation of FIPS requirements and what fips=1 is
> intended to do -- again, why I'd like us to work this out and document
> it so we have a clear and shared understanding and don't break mainline
> FIPS support.
> 
> In the meantime, I think it would be good to stop converting more crypto
> API users to lib/crypto/ users if it's not crystal clear that it's not a
> "security function".

You're welcome to be constructive instead of obstructive.

> > > FIPS also has a bunch of requirements around algorithm testing, for
> > > example that every algorithm shall pass tests before it can be used.
> > > lib/crypto/ has kunit tests, but there is no interaction with
> > > CONFIG_CRYPTO_FIPS or fips=1 as far as I can tell, and no enforcement
> > > mechanism. This seems like a bad thing for all the distros that are
> > > currently certifying their kernels for FIPS.
> > 
> > As I've said in another thread
> > (https://lore.kernel.org/linux-crypto/20250917184856.GA2560@quark/,
> > https://lore.kernel.org/linux-crypto/20250918155327.GA1422@quark/),
> > small patches that add FIPS pre-operational self-tests would generally
> > be fine, if they are shown to actually be needed and are narrowly scoped
> > to what is actually needed.  These would be different from and much
> > simpler than the KUnit tests, which are the real tests.
> > 
> > But again, it's up to someone who cares to send patches.  And again,
> > lib/ has had SHA-1 since 2005, so this isn't actually new.
> 
> What's new is the direct user of lib/crypto/sha1.c outside the crypto
> API since commit 095928e7d8018, which is very recent.

Again: while that particular user is new, the SHA-1 library was already
used by kernel/bpf/core.c and net/ipv6/addrconf.c.

> I don't think it's a good idea to duplicate all the logic around
> FIPS and algorithm testing that already exists in the crypto API for
> this exact purpose.

As I've said: if the pre-operational self-tests are actually needed in
lib/ after all, then lib/ can just implement the minimum that FIPS
requires, which is actually quite straightforward (typically just a
single check for algorithm).

I don't see it as duplicating the actual tests.  The way that
crypto/testmgr.c conflates the FIPS pre-operational self-tests and the
actual tests has always been really problematic.

- Eric
