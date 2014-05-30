From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v7 0/6] SP800-90A Deterministic Random Bit Generator
Date: Fri, 30 May 2014 12:08:08 +0200
Message-ID: <1743692.XvreuYbNlX@myon.chronox.de>
References: <20140523211459.GA21019@gondor.apana.org.au> <1449817.RiX7azh5Ri@myon.chronox.de> <20140530090548.GA12603@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com, joe@perches.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53199 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbaE3KIc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 06:08:32 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S133> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Fri, 30 May 2014 12:08:10 +0200
In-Reply-To: <20140530090548.GA12603@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 30. Mai 2014, 17:05:48 schrieb Herbert Xu:

Hi Herbert,

> On Mon, May 26, 2014 at 07:42:57AM +0200, Stephan Mueller wrote:
> > A second aspect is the implementation of the stdrng. Currently, the
> > offered
> > patch does not include the stdrng selection. I am currently working on the
> > completion of the addition of the stdrng selection to the offered patch.
> > My
> > idea is the following: currently, all DRBG types are registered with their
> > own cra_name. However, there shall be one particular DRBG registered
> > twice. When registering the instance again, the cra_name shall be
> > "stdrng". In addition, if the kernel command line contains fips=1, the
> > cra_priority of that stdrng should be set to 300. That implies that when
> > the kernel resolves the stdrng, it resolves to get_random_bytes in normal
> > mode, but to the stdrng DRBG in FIPS mode.
> 
> Just have all of them register as stdrng with differing priorities.

Will do. Just to clarify: I would use priorities below 200 if (!fips_enabled) 
and above 200 for fips_enabled. This would mean that per default, the 
get_random_bytes/krng has the highest priority in non-fips mode. In FIPS mode, 
the DRBGs would have the higher priority per default.

> We already have a user-space interface to change priorities.

Great -- if I may ask, which interface is that?
> 
> Cheers,


Ciao
Stephan
-- 
| Cui bono? |
