From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v8 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Sat, 10 Jun 2017 13:21:27 +0200
Message-ID: <3619486.phcmIEiBsZ@positron.chronox.de>
References: <1534260.eLzG41Ydnz@positron.chronox.de> <25395002.4o58NXqqVS@positron.chronox.de> <20170610085940.GA15537@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60146 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751890AbdFJLVa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 07:21:30 -0400
In-Reply-To: <20170610085940.GA15537@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 10. Juni 2017, 10:59:40 CEST schrieb Herbert Xu:

Hi Herbert,

> 
> Indeed, we should just kill the wait or perhaps convert it to
> a WARN_ON.

As the inflight variable is only used for refcounting and the related wait, I 
would propose to remove that variable entirely.

Ciao
Stephan
