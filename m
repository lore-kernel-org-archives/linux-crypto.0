From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Fri, 13 Jan 2017 12:12:39 +0100
Message-ID: <1593277.7QY5i6DVS0@positron.chronox.de>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <9279288.fr5DIlfFLr@positron.chronox.de> <20170113110417.GB23617@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55530 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751356AbdAMLMm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 06:12:42 -0500
In-Reply-To: <20170113110417.GB23617@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 19:04:17 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 13, 2017 at 11:58:24AM +0100, Stephan Müller wrote:
> > May I ask how the in-place code path can be invoked by algif_aead or
> > algif_skcipher? As far as I understand, this code path is only invoked
> > when
> > the cipher implementation sees that the src and dst SGLs are identical.
> 
> It's not right now but it isn't difficult to add the code to allow
> it by comparing SGLs.

Adding such code should IMHO not be impaired by pointing to the AAD held in 
the src SGL by the dst SGL as offered with the older patch mentioned before.

Ciao
Stephan
