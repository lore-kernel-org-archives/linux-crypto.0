From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [v3 PATCH] crypto: aesni - Convert rfc4106 to new AEAD interface
Date: Mon, 01 Jun 2015 11:04:39 +0200
Message-ID: <2306645.epOL7FXtYn@tauon>
References: <20150528140311.GA8423@gondor.apana.org.au> <20150601075022.GA11611@gondor.apana.org.au> <20150601075306.GA11725@gondor.apana.org.au>
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
Received: from mail.eperm.de ([89.247.134.16]:58387 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbbFAJEr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 05:04:47 -0400
In-Reply-To: <20150601075306.GA11725@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 1. Juni 2015, 15:53:06 schrieb Herbert Xu:

Hi Herbert,

>On Mon, Jun 01, 2015 at 03:50:22PM +0800, Herbert Xu wrote:
>> This patch converts the low-level __gcm-aes-aesni algorithm to
>> the new AEAD interface.
>
>Oops, I missed two more spots.

That patch fixes the crash. Thanks

Just FYI: when testing rfc4106(gcm(aes-aesni)) with the old givcipher API, I 
got a crash in my code invoking the cipher which used to work in older kernels 
and which works with the C implementations. So, there must be some change in 
how givcipher is treated by the AESNI implementation.

As this API is sunset now, shall I dig deeper or shall we simply deactivate 
the API entirely?

--
Ciao
Stephan
