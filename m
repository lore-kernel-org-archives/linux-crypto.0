From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] revamp fips_allowed flag
Date: Fri, 16 Sep 2016 13:56:32 +0800
Message-ID: <20160916055632.GA23956@gondor.apana.org.au>
References: <1818375.56xtGUSNII@tauon.atsec.com>
 <2606890.Z1PDhBGeZR@tauon.atsec.com>
 <20160915062629.GA14950@gondor.apana.org.au>
 <9465267.bxih8SxCui@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50201 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754064AbcIPF4g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2016 01:56:36 -0400
Content-Disposition: inline
In-Reply-To: <9465267.bxih8SxCui@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 16, 2016 at 07:42:13AM +0200, Stephan Mueller wrote:
>
> > For such templates we could move that info into the generic
> > template implementation code and have them declare themselves
> > as such that for any X if X is FIPS allowed then so is T(X).
> > 
> > This info can then be used in testmgr.
> 
> I can see that, but I do not believe it makes our life in the testmgr easier. 
> The reason is that in a lot of cases, the template parts (read: block chaining 
> modes) are moved into implementations. The most notable examples are the x86 
> Intel and the S390 CPACF implementations. For those, the template handling 
> code is not triggered and thus we still would need testmgr entries with the 
> block chaining modes.

That's not what I meant.  The template is only responsible for
providing that info to testmgr.  The actual rule will then apply
to any cra_name which matches it.  That is, if template T says
that it is OK under FIPS, then every algorithm of type T(X) will
be allowed if X is allowed.

> Considering that we now have RSA in the kernel and that we could expect RSA 
> implementations in hardware (in fact, we already have them), there is another 
> complication: FIPS only allows RSA according to FIPS 186-4 and not according 
> to FIPS 186-2 (ok, the main difference is in key gen, which we do not have). 
> What I want to say here is that with the more complex style ciphers, it may 
> very well be possible that only the respective implementation knows whether it 
> is FIPS compliant.

Please give a concrete example.

> Thus, I am still thinking that moving the fips_allowed flag into the structs 
> that are evaluated during register time is more helpful. I definitely see that 
> this would imply that all, say, AES implementations need that flag. But IMHO 
> it is a much cleaner solution, because if the register is rejected, the cipher 
> does not show up in /proc/crypto and everybody knows that a particular cipher 
> is not in use.

That's crazy.  For AES we already have dozens of implementations,
think about the amount of churn that will occur when one AES
implementation is obsoleted by FIPS.

> My particular example is that in one test with FIPS mode enabled, 
> seqiv(rfc4106(gcm-base(...))) was successfully loaded and marked as selftest 
> passed in /proc/crypto. Yet, an allocation of the test failed with ENOENT. 
> Rebooting the system without FIPS mode allowed me to allocate the cipher. As 
> there is no test for this particular cipher name in testmgr, I highly suspect 
> that the allocation code did not find it because somehow there was no test. In 
> any case, it is definitely not clear why that particular cipher name cannot be 
> allocated in FIPS mode given the entries in /proc/crypto.

Sounds like our testmgr dealing with FIPS is buggy.  It probably
shouldn't mark it as passed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
