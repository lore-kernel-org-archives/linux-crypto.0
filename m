From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [v4 PATCH 0/8] crypto: rsa - Do not gratuitously drop leading zeroes
Date: Sun, 03 Jul 2016 07:57:23 +0200
Message-ID: <22585426.Z0tGqdKB0k@positron.chronox.de>
References: <20160622101432.GA30454@gondor.apana.org.au> <1997039.xp5G17Zq2C@positron.chronox.de> <20160703024611.GA24340@gondor.apana.org.au>
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
Received: from mail.eperm.de ([89.247.134.16]:38634 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbcGCF5d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Jul 2016 01:57:33 -0400
In-Reply-To: <20160703024611.GA24340@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 3. Juli 2016, 10:46:11 CEST schrieb Herbert Xu:

Hi Herbert,

> On Sat, Jul 02, 2016 at 07:55:59PM +0200, Stephan Mueller wrote:
> > I re-tested that patch set and I still see the same issues as before,
> > namely
> > that sigver does not work:
> Oops, somehow I conflated this problem with KPP.  Does this patch
> fix it for you?

Yes, that patch fixes the module signature check issue and the CAVS test shows 
a pass as well.

Ciao
Stephan
