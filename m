From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Problem with key sizes
Date: Mon, 19 Mar 2007 20:07:10 +0100
Message-ID: <20070319190710.GA5148@Chamillionaire.breakpoint.cc>
References: <20070316152347.GE13744@Chamillionaire.breakpoint.cc> <E1HSQHB-0000Sn-00@gondolin.me.apana.org.au> <20070317202853.GA7454@Chamillionaire.breakpoint.cc> <1174314339.7212.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Jan Glauber <jan.glauber@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:46730 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbXCSTHM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Mar 2007 15:07:12 -0400
Content-Disposition: inline
In-Reply-To: <1174314339.7212.20.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Jan Glauber | 2007-03-19 15:25:39 [+0100]:

>Having fall back support for unsupported parts of an algorithm sounds like 
>the right thing to me. In include/linux/crypto.h I found:
>
>/*
> * Set this bit if and only if the algorithm requires another algorithm of
> * the same type to handle corner cases.
> */
>#define CRYPTO_ALG_NEED_FALLBACK        0x00000100
>
>which is currently not used but looks like someone has thought of implementing
>that kind of fallback method?
This is not totally true. padlock-sha makes uses of that flag and
something forbids that padlock-sha gets itself back as fall back. I did
not find out where and how does it check for hat flag, but it does.

>OTOH, if aes and padlock are the only two cornercases it may be easier to
>implement the fallback manually. Are there other algorithms / hardware accelerators
>that would benefit from a generic fallback method?

I wouldn't consider s390'aes and Geode'aes as corner cases because they
never claimed to supported those key sizes. A good example of a corner
case is padlock-sha.c I guess. They support sha1 & sha256 on hardware as
long as the data is not larger than one page. 
On the other hand they maybe different interpretation of a corner case
and whether an algorithm like aes, that is standardized for 128, 192 and
256 bits, has to support all of them or may support just a subset.
We need definitely some sort of fall back method, the question is just if
the driver should implement it or the API if the driver already knows
that it can't be handled at all.
And I would like to find out how the flag gets actually checked :)

>Cheers,
>Jan
-- 
Regards
Sebastian Siewior
