From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Is the asynchronous hash crypto API asynchronous?
Date: Mon, 09 Jan 2017 11:23:12 +0100
Message-ID: <3639236.s9QSuQoh7d@positron.chronox.de>
References: <CAOtvUMd=EHaFq=AtMePzN9fsoMLszZ0ruAu8KaaP=W=8J7nGUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55334 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758513AbdAIKXX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2017 05:23:23 -0500
In-Reply-To: <CAOtvUMd=EHaFq=AtMePzN9fsoMLszZ0ruAu8KaaP=W=8J7nGUg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 8. Januar 2017, 15:45:37 CET schrieb Gilad Ben-Yossef:

Hi Gilad,

>         ahash_request_set_callback(req, 0, NULL, NULL);

> 
> Would anyone be kind enough to enlighten me?

The documentation got out of sync with the real world. I will file a patch for 
that shortly.

The ahash API works identically to the async skcipher API for which you find 
an example in the api-samples.rst. There you see that with the set_callback, a 
function is registered that is triggered upon completion of the operation.

Thus, use the callback example you find for skcipher for your ahash operation 
and you get an async operation.

Ciao
Stephan
