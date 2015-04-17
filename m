From: Stephan Mueller <smueller@chronox.de>
Subject: Re: DRBG seeding
Date: Fri, 17 Apr 2015 03:19:17 +0200
Message-ID: <3303782.1Fl4anZ2PL@myon.chronox.de>
References: <20150416143617.GA17178@gondor.apana.org.au> <2037814.HNld8WWmfI@tauon> <552FED36.6080904@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Andreas Steffen <andreas.steffen@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34147 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbbDQBTY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 16 Apr 2015 21:19:24 -0400
In-Reply-To: <552FED36.6080904@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 16. April 2015, 19:11:18 schrieb Andreas Steffen:

Hi Andreas,

> Hi Stephan,
> 
> in my opinion you definitively have to seed the DRBG with true
> entropy from /dev/random. This is what we are currently doing
> in userland with the strongSwan DRBG needed for the post-quantum
> NTRU-based key exchange algorithm. The NIST SP800-90A spec defines
> a parameter which estimates the entropy contained in the seed,
> but I think it is extremely difficult to derive an estimate
> if /dev/urandom is used.
> 
> Our plans within the strongSwan project is to make the Linux
> kernel DRBG available via the af-alg interface.

I am working on that. My current idea is the following:

1. during initialization of a DRBG instance, seed from get_random_bytes to 
have a DRBG state that is seeded and usable.

2. at the same time, initiate an async request to the yet to be developed (or 
rather forward-ported and accepted) in-kernel /dev/random interface

3. when the async request returns, re-seed the DRBG with that data

I am playing with the idea that steps 2 and 3 are repeated 2 or 3 times where 
the first invocation only requests a few bytes from the in-kernel /dev/random 
-- this again should seed the DRBG with entropy as it becomes available.

But thank you for your support. It is surely helpful to show also to Ted Tso 
that an update to /dev/random is of interest to various users.

Ciao
Stephan
> 
> Best regards
> 
> Andreas
> 
> On 16.04.2015 17:32, Stephan Mueller wrote:
> > Am Donnerstag, 16. April 2015, 23:26:18 schrieb Herbert Xu:
> > 
> > Hi Herbert,
> > 
> >> On Thu, Apr 16, 2015 at 05:07:20PM +0200, Stephan Mueller wrote:
> >>> I do not see a specific requirement in SP800-90A about the quality of
> >>> the
> >>> noise source.
> >> 
> >> Well it explicitly says that you cannot use a DRBG.  In the worst
> >> case get_random_bytes is completely deterministic.
> >> 
> >>> That said, I already developed an in-kernel version of /dev/random. I
> >>> sent
> >>> the patch to LKML some half year ago. If I understood Ted Tso right,
> >>> there
> >>> is no general objection against adding that in-kernel interface. See [1]
> >>> for the thread.
> >>> 
> >>> Furthermore, I already started working on updating the DRBG to use that
> >>> in-
> >>> kernel /dev/random interface.
> >>> 
> >>> Shall I pursue that work in earnest now?
> >>> 
> >>> [1] https://lkml.org/lkml/2014/5/11/276
> >> 
> >> Yes I think we should do this.
> > 
> > Ok, I will work on that after I added the global lock to the DRBG.
> > 
> >> Thanks,
> > 
> > Ciao
> > Stephan
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ciao
Stephan
