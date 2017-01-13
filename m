From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 12:30:15 +0100
Message-ID: <1704568.lHqrOxcchT@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <2328881.s8hPz576Kn@positron.chronox.de> <20170113112623.GB23928@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55542 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbdAMLaY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:30:24 -0500
In-Reply-To: <20170113112623.GB23928@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 19:26:23 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 13, 2017 at 12:19:48PM +0100, Stephan Müller wrote:
> > That is correct, but I thought that playing with pointers is always faster
> > than doing memcpy. Are you saying that this assumption is not true when we
> > somehow have the code to try to perform an in-place operation?
> 
> If you're doing crypto the overhead in copying the AAD is the
> last thing you need to worry about.

So, the patch set you want to see is:

- remove the AAD copy operation from authenc and not add it to any AEAD 
implementations

- add the AAD copy operation to algif_aead

Shall the null cipher context we need for that be anchored in the crypto_aead 
data structure as done in patch 01 of this series (this would allow an easy 
addition to the copy call to every AEAD implementation if deemed needed) or 
shall it be anchored within algif_aead?

Ciao
Stephan
