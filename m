From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 12:19:48 +0100
Message-ID: <2328881.s8hPz576Kn@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <1593277.7QY5i6DVS0@positron.chronox.de> <20170113111406.GB23800@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55538 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751350AbdAMLTw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:19:52 -0500
In-Reply-To: <20170113111406.GB23800@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 19:14:06 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 13, 2017 at 12:12:39PM +0100, Stephan Müller wrote:
> > Adding such code should IMHO not be impaired by pointing to the AAD held
> > in
> > the src SGL by the dst SGL as offered with the older patch mentioned
> > before.
> The point is you're turning what could otherwise be a linear SGL
> into a non-linear one by forcing the same AAD on both sides.

That is correct, but I thought that playing with pointers is always faster 
than doing memcpy. Are you saying that this assumption is not true when we 
somehow have the code to try to perform an in-place operation?

Ciao
Stephan
