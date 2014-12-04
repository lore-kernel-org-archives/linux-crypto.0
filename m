From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 00/17] Multiple changes to crypto/ansi_cprng.c
Date: Thu, 04 Dec 2014 19:07:07 +0100
Message-ID: <14057596.DaUJBTjuAN@tachyon.chronox.de>
References: <20141203202753.7691.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: nhorman@tuxdriver.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54909 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932820AbaLDSHL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2014 13:07:11 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SAD4F> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Thu, 4 Dec 2014 19:07:07 +0100
In-Reply-To: <20141203202753.7691.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 3. Dezember 2014, 15:27:53 schrieb George Spelvin:

Hi George,

> > but before it goes anywhere, it really needs to pass the NIST and FIPS
> > test vectors.  Can you do that please and post the results?
> 
> It of course passes the ones in testmgr.h, and I can add the others from
> http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
> and
> http://csrc.nist.gov/groups/STM/cavp/documents/rng/rngtestvectors.zip
> 
> I didn't know there were separate FIPS test vectors for this PRNG;
> can you give me a clue where to find them?

I can send you such vectors that would be used in FIPS validations. I will 
send them off-list as they are large.

-- 
Ciao
Stephan
