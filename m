From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: AF_ALG - consolidation of duplicate code
Date: Wed, 16 Aug 2017 10:39:43 +0200
Message-ID: <3178607.Y0F1IYYMXo@tauon.chronox.de>
References: <2922624.oQubu9mOmR@positron.chronox.de> <2012469.Yss5hQnVpr@tauon.chronox.de> <20170816082917.GA21246@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58896 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751454AbdHPIjq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2017 04:39:46 -0400
In-Reply-To: <20170816082917.GA21246@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 16. August 2017, 10:29:18 CEST schrieb Herbert Xu:

Hi Herbert,

> On Thu, Aug 10, 2017 at 10:25:58AM +0200, Stephan Mueller wrote:
> > I think there is such patch already, see [1].
> > 
> > Your comment to that patch triggered my rewrite of the memory managment
> > code.
> > 
> > [1] https://www.spinics.net/lists/linux-crypto/msg21618.html
> 
> Could you please post that patch to stable@vger.kernel.org with
> the appropriate tags?

Sure, will do.

Are you feeding that patch to the Linus 4.13-rc tree via your crypto-2.6 tree?

Ciao
Stephan
