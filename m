From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Sat, 07 Oct 2017 04:53:46 +0200
Message-ID: <2010633.8rTN3NahbQ@positron.chronox.de>
References: <3874163.dZU00zCVt8@positron.chronox.de> <3683903.fccHZfxTmM@positron.chronox.de> <20171007025117.GA29361@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34724 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751491AbdJGCxx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 22:53:53 -0400
In-Reply-To: <20171007025117.GA29361@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 7. Oktober 2017, 04:51:17 CEST schrieb Herbert Xu:

Hi Herbert,

> 
> No I'm talking about the underlysing skcipher.  authenc is an
> aead, and it is legal to make a zero skcipher call.  The underlying
> skcipher should make sure that it works.
> 
> So which underlying skcipher is barfing over a zero input?

I use authenc(hmac(sha256),cbc(aes)) which in turn uses cbc-aes-aesni on my 
system.

Ciao
Stephan
