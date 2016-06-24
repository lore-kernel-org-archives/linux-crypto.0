From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: rsa - Do not gratuitously drop leading zeroes
Date: Fri, 24 Jun 2016 11:23:06 +0200
Message-ID: <1513733.zSFupaElV5@tauon.atsec.com>
References: <20160622101432.GA30454@gondor.apana.org.au> <733379976.TmXhNiYQ9x@positron.chronox.de> <20160624084147.GB18603@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:38150 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbcFXJXJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 05:23:09 -0400
In-Reply-To: <20160624084147.GB18603@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. Juni 2016, 16:41:47 schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jun 24, 2016 at 09:27:12AM +0200, Stephan Mueller wrote:
> > Am Mittwoch, 22. Juni 2016, 18:14:32 schrieb Herbert Xu:
> > 
> > Hi Herbert,
> > 
> > Something breaks with this patch set in public_key_verify_signature
> > 
> > I get tons of these:
> > 
> > [    1.838720] PKCS#7 signature not signed with a trusted key
> > 
> > 
> > Furthermore, my CAVS testing with public_key_verify_signature always
> > EINVAL.
> > 
> > SigGen using the kernel crypto API interfaces work though.
> 
> Hi Stephan:
> 
> Can you bisect this down to a specific patch please?

Patch 2 introduces the bug.

Note, with patch 2, there is also a compile warning with crypto/dh.c.
> 
> Thanks!


Ciao
Stephan
