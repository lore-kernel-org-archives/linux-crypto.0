From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 8/10] crypto: aesni - Convert top-level rfc4106 algorithm to new interface
Date: Fri, 29 May 2015 23:50:31 +0200
Message-ID: <1685010.9M0tXqy65m@tachyon.chronox.de>
References: <20150528140311.GA8423@gondor.apana.org.au> <E1YxyTb-0002L9-6g@gondolin.me.apana.org.au> <3237777.1pZ3XZ1aYV@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58365 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbbE2Vui (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 17:50:38 -0400
In-Reply-To: <3237777.1pZ3XZ1aYV@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 29. Mai 2015, 23:39:03 schrieb Stephan Mueller:

Hi Herbert,

> Am Donnerstag, 28. Mai 2015, 22:08:03 schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > This patch converts rfc4106-gcm-aesni to the new AEAD interface.
> > The low-level interface remains as is for now because we can't
> > touch it until cryptd itself is upgraded.
> 
> Not sure what goes wrong, but when using algif_aead with the new code, I
> get:

Maybe the following observation can help pinpoint the issue: using the src/dst 
buffer allocated as follows, the kernel code works flawless:

	outbuf = calloc(1, outbuflen);

Using aligned src/dst buffers created with the following code causes the bug:

	if (posix_memalign((void *)&outbuf, PAGE_SIZE, outbuflen))

-- 
Ciao
Stephan
