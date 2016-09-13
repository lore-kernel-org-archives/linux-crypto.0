From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] hwrng: core - Allocate memory during module init
Date: Tue, 13 Sep 2016 20:40:36 +0800
Message-ID: <20160913124036.GC31835@gondor.apana.org.au>
References: <1473259682-11655-1-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, lee.jones@linaro.org, jslaby@suse.cz,
        peter@korsgaard.com, linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55941 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755289AbcIMMlA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 08:41:00 -0400
Content-Disposition: inline
In-Reply-To: <1473259682-11655-1-git-send-email-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 07, 2016 at 08:18:02PM +0530, PrasannaKumar Muralidharan wrote:
> In core rng_buffer and rng_fillbuf is allocated in hwrng_register only
> once and it is freed during module exit. This patch moves allocating
> rng_buffer and rng_fillbuf from hwrng_register to rng core's init. This
> avoids checking whether rng_buffer and rng_fillbuf was allocated from
> every hwrng_register call. Also moving them to module init makes it
> explicit that it is freed in module exit.
> 
> Change in v2:
> Fix memory leak when register_miscdev fails.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
