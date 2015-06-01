From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [v3 PATCH] crypto: aesni - Convert rfc4106 to new AEAD interface
Date: Mon, 01 Jun 2015 12:08:54 +0200
Message-ID: <5232495.Et3QW0maLF@tachyon.chronox.de>
References: <20150528140311.GA8423@gondor.apana.org.au> <5138754.L8j0JzbJL1@tachyon.chronox.de> <20150601095245.GA12754@gondor.apana.org.au>
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
Received: from mail.eperm.de ([89.247.134.16]:58407 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbbFAKI5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 06:08:57 -0400
In-Reply-To: <20150601095245.GA12754@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 1. Juni 2015, 17:52:45 schrieb Herbert Xu:

Hi Herbert,

> On Mon, Jun 01, 2015 at 11:44:22AM +0200, Stephan Mueller wrote:
> > That code crashes with the following stacktrace:
> > 
> > [ 2000.433502] BUG: unable to handle kernel NULL pointer dereference at
> > (null)
> 
> This crash is totally different from the previous crash you sent.
> This one is expected because you're calling givencrypt on an
> algorithm that has already been converted.
> 
> Once converted they no longer have a givencrypt function and
> calling crypto_aead_givencrypt on them will crash.

Thank you, that was the clarification I am looking for. Please disregard all 
communication on the givcrypt API then.
> 
> Cheers,


-- 
Ciao
Stephan
