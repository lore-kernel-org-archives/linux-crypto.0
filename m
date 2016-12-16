From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG - fix memory management of aio with multiple iocbs
Date: Fri, 16 Dec 2016 14:58:26 +0100
Message-ID: <5879726.z9Z9HajJ59@tauon.atsec.com>
References: <4632372.rm33NXUfDp@positron.chronox.de> <2916745.RxhEJByb92@tauon.atsec.com> <20161216123127.GA20406@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39340 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754718AbcLPOIG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Dec 2016 09:08:06 -0500
In-Reply-To: <20161216123127.GA20406@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 16. Dezember 2016, 20:31:27 CET schrieb Herbert Xu:

Hi Herbert,
> > 
> > You are right, this will introduce a memleak. But with the immediate
> > freeing of sreq->tsg in the current code, the AIO interface cannot
> > support multiple IOCBs.
> > 
> > Thus, the entire memory handling in the AIO case seems broken.
> 
> Right, but can we please fix it properly? For example, you could
> save the original tsg in a new field and free that when you are
> done.

Absolutely, I concur. I will work on that.

Ciao
Stephan
