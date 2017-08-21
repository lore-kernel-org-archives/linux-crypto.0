From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v8 3/4] crypto: AF_ALG -- add asymmetric cipher
Date: Mon, 21 Aug 2017 11:39:00 +0200
Message-ID: <4583599.LkPvL0jah8@tauon.chronox.de>
References: <26359147.tCiuJ5s8mz@positron.chronox.de> <fbc8c754-e519-e98b-a8f8-5a975cba013a@microchip.com> <3b25c721-bde7-8427-be2f-2d5ca9fdbd22@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59182 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752533AbdHUJjG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Aug 2017 05:39:06 -0400
In-Reply-To: <3b25c721-bde7-8427-be2f-2d5ca9fdbd22@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 21. August 2017, 11:23:55 CEST schrieb Tudor Ambarus:

Hi Tudor,

> 
> Oops, I missed the negation. When crypto_akcipher_set_priv_key succeeds
> you return the akcipher_maxsize. Not a bad idea, you save few cpu
> cycles.

I was hoping to save some context switches.
> 
> > crypto akcipher uses a dedicated function for determining the length of
> > the output buffer, crypto_akcipher_maxsize. Should we add a new function
> > pointer in struct af_alg_type that returns the maxsize?
> 
> Your API is different from crypto's akcipher. Should we make them
> identical?

In the early days of the akcipher API it used to be the way algif_akcipher 
implements it today.

Do you see a case where user space wants to deliberately ask for this value? 
As this value never changes after setting a key, I thought we can skip it for 
the user space interface.

Ciao
Stephan
