From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: algif for compression?
Date: Mon, 03 Apr 2017 09:26:38 +0200
Message-ID: <12030384.uXSX3S3VSk@tauon.chronox.de>
References: <CACVarETuTx40WFD5TRUCwiYv5r3SEvhuJHpGjqPsz90qVZsYKA@mail.gmail.com> <20161210081014.GA32746@gondor.apana.org.au> <CACVarEQ14ZF9LGDkaNYtX3GRD5GOH62NBiPtC4z=i6RY4MtFDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: abed mohammad kamaluddin <abedamu@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58762 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751431AbdDCH0n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2017 03:26:43 -0400
In-Reply-To: <CACVarEQ14ZF9LGDkaNYtX3GRD5GOH62NBiPtC4z=i6RY4MtFDA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 3. April 2017, 08:10:19 CEST schrieb abed mohammad kamaluddin:

Hi abed,

> Hi Herbert,
> 
> We have implemented algif acomp interface for user space applications
> to utilize the kernel compression framework and the hardware drivers
> using it and have been testing it using userspace zlib library.
> 
> However, what we find lacking in the existing acomp implementation is
> the ability to pass context data between the applications and the
> drivers using the acomp interface. Currently the interface only allows
> src/dest data  and a flag argument with each request. There are two
> context pointers, one in acomp_req and another in crypto_tfm but they
> are for internal use and not available to applications through the
> api's. Would it be acceptable to add fields that need to be
> communicated b/w the driver and applications like history,
> csum/adler32, EOF, stream ctx  to acomp_req.
> 
> Or is there any other way, which I may have missed, through which we
> can pass ctx data between applications and drivers while using the
> kernel compression framework?

If you follow the AF_ALG implementations that are currently in the kernel, a 
calling application receives two file descriptors. The first file descriptor 
is the reference to a tfm, the second is the reference to a particular 
request.

Wouldn't those file descriptors be the reference you are looking for?

Ciao
Stephan
