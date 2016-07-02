From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [v4 PATCH 0/8] crypto: rsa - Do not gratuitously drop leading zeroes
Date: Sat, 02 Jul 2016 20:02:00 +0200
Message-ID: <1547356.0S16DBeqkL@positron.chronox.de>
References: <20160622101432.GA30454@gondor.apana.org.au> <20160629113125.GA27643@gondor.apana.org.au> <1997039.xp5G17Zq2C@positron.chronox.de>
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
Received: from mail.eperm.de ([89.247.134.16]:38574 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbcGBSCE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Jul 2016 14:02:04 -0400
In-Reply-To: <1997039.xp5G17Zq2C@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 2. Juli 2016, 19:55:59 CEST schrieb Stephan Mueller:

Hi Herbert,

> Am Mittwoch, 29. Juni 2016, 19:31:25 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> I re-tested that patch set and I still see the same issues as before, namely
> that sigver does not work:
> 
> Kernel log:
> 
> PKCS#7 signature not signed with a trusted key
> 
> And my CAVS harness also fails.
> 
> Is there any prerequisite to that patch that I have to consider?

Note, I see that even with the patch set that went into your cryptodev-2.6 
tree.

Ciao
Stephan
