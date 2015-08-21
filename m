From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: skcipher - Add top-level skcipher interface
Date: Fri, 21 Aug 2015 11:24:08 +0200
Message-ID: <3197252.zpooAnFuUp@tauon.atsec.com>
References: <20150820072055.GA27176@gondor.apana.org.au> <E1ZSKAT-00075n-MI@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48139 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbbHUJYS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 05:24:18 -0400
In-Reply-To: <E1ZSKAT-00075n-MI@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 20. August 2015, 15:21:45 schrieb Herbert Xu:

Hi Herbert,

>This patch introduces the crypto skcipher interface which aims
>to replace both blkcipher and ablkcipher.
>
>It's very similar to the existing ablkcipher interface.  The
>main difference is the removal of the givcrypt interface.  In
>order to make the transition easier for blkcipher users, there
>is a helper SKCIPHER_REQUEST_ON_STACK which can be used to place
>a request on the stack for synchronous transforms.

If I understand the patch set correctly, a caller uses the skcipher API and 
the API sets up the synchronous or asynchronous callbacks depending on the 
chosen cipher implementation.

Now, does a caller always need to create an skcipher_request and always need 
the async logic of providing a callback function and the like, even though a 
synchronous cipher is chosen? I.e. the caller has no means to use a 
synchronous cipher operation any more.

It looks to me like that, but I would like to confirm.

Thank you.

Ciao
Stephan
