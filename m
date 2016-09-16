From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC] revamp fips_allowed flag
Date: Fri, 16 Sep 2016 07:42:13 +0200
Message-ID: <9465267.bxih8SxCui@tauon.atsec.com>
References: <1818375.56xtGUSNII@tauon.atsec.com> <2606890.Z1PDhBGeZR@tauon.atsec.com> <20160915062629.GA14950@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47976 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752504AbcIPFmR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 01:42:17 -0400
In-Reply-To: <20160915062629.GA14950@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 15. September 2016, 14:26:29 CEST schrieb Herbert Xu:

Hi Herbert,

> On Thu, Sep 15, 2016 at 08:23:05AM +0200, Stephan Mueller wrote:
> > Where shall we draw the line here? Shall that be only for authenc, or
> > seqiv? Or shall we also consider rfc4106 too, knowing that there are
> > implementations which provide a full rfc4106 GCM combo (x86 for example).
> > What about the current pkcspad1 template where we could expect that there
> > may be entire HW implementations with that?
> 
> That's something that only you can tell us :)

Well, as a baseline we can say  that:

- with the exception of a few block chaining modes (e.g. xcbc, pcbc, lrw) all 
templates are allowed in FIPS mode

- almost all "non-approved" ciphers (i.e those that should not have a 
fips_allowed flag) are due to the raw base cipher (i.e. only SHA1/2, AES and 
TDES is allowed)

- all compression algos are allowed
> 
> For such templates we could move that info into the generic
> template implementation code and have them declare themselves
> as such that for any X if X is FIPS allowed then so is T(X).
> 
> This info can then be used in testmgr.

I can see that, but I do not believe it makes our life in the testmgr easier. 
The reason is that in a lot of cases, the template parts (read: block chaining 
modes) are moved into implementations. The most notable examples are the x86 
Intel and the S390 CPACF implementations. For those, the template handling 
code is not triggered and thus we still would need testmgr entries with the 
block chaining modes.

Considering that we now have RSA in the kernel and that we could expect RSA 
implementations in hardware (in fact, we already have them), there is another 
complication: FIPS only allows RSA according to FIPS 186-4 and not according 
to FIPS 186-2 (ok, the main difference is in key gen, which we do not have). 
What I want to say here is that with the more complex style ciphers, it may 
very well be possible that only the respective implementation knows whether it 
is FIPS compliant.

Thus, I am still thinking that moving the fips_allowed flag into the structs 
that are evaluated during register time is more helpful. I definitely see that 
this would imply that all, say, AES implementations need that flag. But IMHO 
it is a much cleaner solution, because if the register is rejected, the cipher 
does not show up in /proc/crypto and everybody knows that a particular cipher 
is not in use.

My particular example is that in one test with FIPS mode enabled, 
seqiv(rfc4106(gcm-base(...))) was successfully loaded and marked as selftest 
passed in /proc/crypto. Yet, an allocation of the test failed with ENOENT. 
Rebooting the system without FIPS mode allowed me to allocate the cipher. As 
there is no test for this particular cipher name in testmgr, I highly suspect 
that the allocation code did not find it because somehow there was no test. In 
any case, it is definitely not clear why that particular cipher name cannot be 
allocated in FIPS mode given the entries in /proc/crypto.

Ciao
Stephan
