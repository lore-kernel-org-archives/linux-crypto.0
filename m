From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [v4 PATCH 0/8] crypto: rsa - Do not gratuitously drop leading zeroes
Date: Sat, 02 Jul 2016 19:55:59 +0200
Message-ID: <1997039.xp5G17Zq2C@positron.chronox.de>
References: <20160622101432.GA30454@gondor.apana.org.au> <20160629102649.GA26987@gondor.apana.org.au> <20160629113125.GA27643@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Denis Kenzior <denkenz@gmail.com>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:38566 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbcGBR4J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Jul 2016 13:56:09 -0400
In-Reply-To: <20160629113125.GA27643@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 29. Juni 2016, 19:31:25 CEST schrieb Herbert Xu:

Hi Herbert,

I re-tested that patch set and I still see the same issues as before, namely 
that sigver does not work:

Kernel log:

PKCS#7 signature not signed with a trusted key

And my CAVS harness also fails.

Is there any prerequisite to that patch that I have to consider?

> Hi:
> 
> This was prompted by the caam RSA submission where a lot of work
> was done just to strip the RSA output of leading zeroes.  This is
> in fact completely pointless because the only user of RSA in the
> kernel then promptly puts them back.
> 
> This patch series resolves this madness by simply leaving any
> leading zeroes in place.  Note that we're not requiring authors
> to add leading zeroes, even though that is encouraged if it is
> easy to do.  In practice you'd only run into this every 2^32 or
> 2^64 operations so please don't overdo it.
> 
> I've also taken the opportunity to cleanup the pkcs1pad code.
> 
> v4 fixes the newly added dh to use the new MPI SG interface.
> 
> Cheers,


Ciao
Stephan
