From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: sun4i-ss: support the Security System PRNG
Date: Thu, 17 Nov 2016 09:18:46 +0100
Message-ID: <2474504.KOMlLBWsmD@tauon.atsec.com>
References: <1476794067-28563-1-git-send-email-clabbe.montjoie@gmail.com> <1722218.eZlGktOxfL@tauon.atsec.com> <20161117080748.GB25394@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50968 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751127AbcKQISu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Nov 2016 03:18:50 -0500
In-Reply-To: <20161117080748.GB25394@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 17. November 2016, 09:07:48 CET schrieb Corentin Labbe:

Hi Corentin,
> 
> Seed again, or just do not seed (and so return -EAGAIN for read() function)
> until ready_callback ?

This is your choice. But for the start sequence, you should not simply rely on 
get_random_bytes.

For the DRBG in crypto/drbg.c we seed with get_random_bytes and the Jitter RNG 
in case the input_pool is not fully seeded. The reseed trigger is reduced to 
50 DRBG requests, i.e. after 50 requests, the DRBG again reseeds from 
get_random_bytes / Jitter RNG. This is continued until the input_pool has been 
sufficiently seeded (i.e. the registered callback is triggered). At that 
point, another get_random_bytes call is made, the Jitter RNG is deactivated 
and the reseed threshold is set to the common value.

Ciao
Stephan
