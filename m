From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: AF_ALG - consolidation of duplicate code
Date: Thu, 10 Aug 2017 10:25:58 +0200
Message-ID: <2012469.Yss5hQnVpr@tauon.chronox.de>
References: <2922624.oQubu9mOmR@positron.chronox.de> <3124682.PWyg91A0St@tauon.chronox.de> <20170810082153.GA4110@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58460 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752168AbdHJI0A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 04:26:00 -0400
In-Reply-To: <20170810082153.GA4110@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 10. August 2017, 10:21:53 CEST schrieb Herbert Xu:

Hi Herbert,

> On Thu, Aug 10, 2017 at 10:16:48AM +0200, Stephan Mueller wrote:
> > As now the AIO code path is updated, the bug that I was reporting last
> > September allowing to crash the kernel via AF_ALG is fixed.
> > 
> > As the patch is very invasive, I am not sure that patch set should be sent
> > to stable. How do you propose we fix the crash bug in older kernels that
> > are due to memory management problems in the AIO code path?
> 
> Is it possible to create a minimal fix for the stable kernels?

I think there is such patch already, see [1].

Your comment to that patch triggered my rewrite of the memory managment code.

[1] https://www.spinics.net/lists/linux-crypto/msg21618.html

Ciao
Stephan
