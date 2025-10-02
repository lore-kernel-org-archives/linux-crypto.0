Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB3C23A989;
	Thu,  2 Oct 2025 17:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759425874; cv=none; b=K4/3Y+7g1tZiv7PJWQKGM5NAvst4w6TN1TFEpXb0+kGx7aqnFuXUOALQdHyVj0RmwsqZofXyuiwIavufO89sd0vJt4X+dyeZQcOPGOmv5p4LiRpF26DGog3+J2rN2KlztiJPBOP1c7LifCOdV4qTNSp0ZEZbnxi0h+0cdQzMzcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759425874; c=relaxed/simple;
	bh=OMRJNrpLvAxA249vBZ/bEhXZq23hs6Dl0++C6N1Jv28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lRjbBAff5zY55VWAje35h02jovnvlJD6yWatCy/IX1VPC2MNHA+IXNF4d7xcAJ1mxe96IZ6r4WRZy/WsdSmsdBrc2Vxy79cmTL0v0UAqzF4znXdQeNbAhttUrId/Wj8WZgSC4ZaWWY58P+D9/inDVq2o15w46LQB6LWwuZXvOlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJxUnZ/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJxUnZ/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0CBC4CEF4;
	Thu,  2 Oct 2025 17:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759425873;
	bh=OMRJNrpLvAxA249vBZ/bEhXZq23hs6Dl0++C6N1Jv28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PJxUnZ/hsGfSMdxSw4DluZMMdmgPLoB0yyEVgXWK+6xwqbjq8vykr7/3JUWLML/FE
	 8bCVgBTjZh6Sy8yuLHdKP9+Bn94wSc5ttQWSlwnBmnPXB3xxmKmWk4AC+n8gd7AYXz
	 6Jk2X7uO5PEbpgf0HX9JEytPfGKDnH1f05YJVyirsEOs94WDMRPgDMqlFhlghb29Lx
	 IpPG1aG2BPbqrXJLNrDomPbTCh4inzxdlbrGsukh1DYco9IDd+3Dw6rJvcXd+69dek
	 n4FgucUECGIQGo+0QyDlludX1PG6GXGJzryiNukhkCec6rlYvdpo25Qy/u44oOw3ci
	 4AHlJp8q1p5Ew==
Date: Thu, 2 Oct 2025 10:23:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Jiri Slaby <jirislaby@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: 6.17 crashes in ipv6 code when booted fips=1 [was: [GIT PULL]
 Crypto Update for 6.17]
Message-ID: <20251002172310.GC1697@sol>
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
 <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
 <aN5GO1YLO_yXbMNH@gondor.apana.org.au>
 <562363e8-ea90-4458-9f97-1b1cb433c863@kernel.org>
 <8bb5a196-7d55-4bdb-b890-709f918abad0@kernel.org>
 <1a71398e-637f-4aa5-b4c6-0d3502a62a0c@kernel.org>
 <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f31dbb22-0add-481c-aee0-e337a7731f8e@oracle.com>

On Thu, Oct 02, 2025 at 01:30:43PM +0200, Vegard Nossum wrote:
> 
> On 02/10/2025 12:57, Jiri Slaby wrote:
> > On 02. 10. 25, 12:13, Jiri Slaby wrote:
> > > On 02. 10. 25, 12:05, Jiri Slaby wrote:
> > > > On 02. 10. 25, 11:30, Herbert Xu wrote:
> > > > > On Thu, Oct 02, 2025 at 10:10:41AM +0200, Jiri Slaby wrote:
> > > > > > On 29. 07. 25, 13:07, Herbert Xu wrote:
> > > > > > > Vegard Nossum (1):
> > > > > > >         crypto: testmgr - desupport SHA-1 for FIPS 140
> > > > > > 
> > > > > > Booting 6.17 with fips=1 crashes with this commit -- see below.
> > > > > > 
> > > > > > The crash is different being on 6.17 (below) and on the commit --
> > > > > > 9d50a25eeb05c45fef46120f4527885a14c84fb2.
> > > > > > 
> > > > > > 6.17 minus that one makes it work again.
> > > > > > 
> > > > > > Any ideas?
> > > > > 
> > > > > The purpose of the above commit is to remove the SHA1 algorithm
> > > > > if you boot with fips=1.  As net/ipv6/seg6_hmac.c depends on the
> > > > > sha1 algorithm, it will obviously fail if SHA1 isn't there.
> > > > 
> > > > Ok, but I don't immediately see what is one supposed to do to
> > > > boot 6.17 distro (openSUSE) kernel with fips=1 then?
> 
> First off, I just want to acknowledge that my commit to disable SHA-1
> when booting with fips=1 is technically regressing userspace as well as
> this specific ipv6 code.
> 
> However, fips=1 has a very specific use case, which is FIPS compliance.
> Now, SHA-1 has been deprecated since 2011 but not yet fully retired
> until 2030.
> 
> The purpose of the commit is to actually begin the transition as is
> encouraged by NIST and prevent any new FIPS certifications from expiring
> early, which would be the outcome for any FIPS certifications initiated
> after December 31 this year. I think this is in line with the spirit of
> using and supporting fips=1 to begin with, in the sense that if you
> don't care about using SHA-1 then you probably don't care about fips=1
> to start with either.
> 
> If you really want to continue using SHA-1 in FIPS mode with 6.17 then I
> would suggest reverting my patch downstream as the straightforward fix.
> 
> > > Now I do, in the context you write, I see inet6_init()'s fail path
> > > is broken. The two backtraces show:
> > > [    2.381371][    T1]  ip6_mr_cleanup+0x43/0x50
> > > [    2.382321][    T1]  inet6_init+0x365/0x3d0
> > > 
> > > and
> > > 
> > > [    2.420857][    T1]  proto_unregister+0x93/0x100
> > > [    2.420857][    T1]  inet6_init+0x3a2/0x3d0
> > > 
> > > I am looking what exactly, but this is rather for netdev@
> > 
> > More functions from the fail path are not ready to unroll and resurrect
> > from the failure.
> > 
> > Anyway, cherry-picking this -next commit onto 6.17 works as well (the
> > code uses now crypto_lib's sha1, not crypto's):
> > commit 095928e7d80186c524013a5b5d54889fa2ec1eaa
> > Author: Eric Biggers <ebiggers@kernel.org>
> > Date:   Sat Aug 23 21:36:43 2025 -0400
> > 
> >      ipv6: sr: Use HMAC-SHA1 and HMAC-SHA256 library functions
> > 
> > 
> > I don't know what to do next -- should it be put into 6.17 stable later
> > and we are done?
> 
> I'd like to raise a general question about FIPS compliance here,
> especially to Eric and the crypto folks: If SHA-1/SHA-256/HMAC is being
> made available outside of the crypto API and code around the kernel is
> making direct use of it

lib/ has had SHA-1 support since 2005.  The recent changes just made the
SHA-1 API more comprehensive and more widely used in the kernel.

> then this seems to completely subvert the
> purpose of CONFIG_CRYPTO_FIPS/fips=1 since it essentially makes the
> kernel non-compliant even when booting with fips=1.
> 
> Is this expected? Should it be documented?

If calling code would like to choose not to use or allow a particular
crypto algorithm when fips_enabled=1, it's free to do so.  

That's far more flexible than the crypto/ approach, which has
historically been problematic since it breaks things unnecessarily.  The
caller can actually do something that makes sense for it, including:

- Deciding whether FIPS requirements even apply to it in the first
  place.  (Considering that it may or may not be implementing something
  that would be considered a "security function" by FIPS.)

- Targeting the disablement to the correct, narrow area.  (Not something
  overly-broad like the entire IPv6 stack, or entire TPM support.)

So: if the people doing FIPS certifications of the whole kernel make a
determination that fips_enabled=1 kernels must not support IPv6 Segment
Routing with HMAC-SHA1 authentication, then they're welcome to send a
patch that makes seg6_genl_sethmac() reject SEG6_HMAC_ALGO_SHA1 if
fips_enabled.  And that would actually correctly disable the SHA-1
support only, rather than disabling the entire IPv6 stack...

Still, for many years lib/ has had APIs for SHA-1 and various
non-FIPS-approved crypto algorithms.  These are used even when
fips_enabled=1.  So, if this was actually important, one would think
these cases would have addressed already.  This is one of the reasons
why I haven't been worrying about adding these checks myself.

It's really up to someone who cares (if anyone does) to send patches.

> FIPS also has a bunch of requirements around algorithm testing, for
> example that every algorithm shall pass tests before it can be used.
> lib/crypto/ has kunit tests, but there is no interaction with
> CONFIG_CRYPTO_FIPS or fips=1 as far as I can tell, and no enforcement
> mechanism. This seems like a bad thing for all the distros that are
> currently certifying their kernels for FIPS.

As I've said in another thread
(https://lore.kernel.org/linux-crypto/20250917184856.GA2560@quark/,
https://lore.kernel.org/linux-crypto/20250918155327.GA1422@quark/),
small patches that add FIPS pre-operational self-tests would generally
be fine, if they are shown to actually be needed and are narrowly scoped
to what is actually needed.  These would be different from and much
simpler than the KUnit tests, which are the real tests.

But again, it's up to someone who cares to send patches.  And again,
lib/ has had SHA-1 since 2005, so this isn't actually new.

- Eric
