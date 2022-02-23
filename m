Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2E7C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Feb 2022 02:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiBWCr0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Feb 2022 21:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237669AbiBWCrS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Feb 2022 21:47:18 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E323E0CD;
        Tue, 22 Feb 2022 18:45:25 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nMheb-00060J-6d; Wed, 23 Feb 2022 13:45:22 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Feb 2022 14:45:21 +1200
Date:   Wed, 23 Feb 2022 14:45:21 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 0/4] hw_random: introduce rng_quality sysfs attribute
Message-ID: <YhWfwQNoP+joN7Qh@gondor.apana.org.au>
References: <20220213204631.354247-1-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220213204631.354247-1-linux@dominikbrodowski.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 13, 2022 at 09:46:27PM +0100, Dominik Brodowski wrote:
> Currently, the hw_random core exposes a module parameter "current_quality".
> However, that is fundamentally broken: If it is set at boot time, it is
> overwritten once the first hw rng device is loaded. If it is set at
> runtime, it is without effect if the hw rng device had its quality value
> set to 0 (and no default_quality was set). If a new rng is selected, it
> gets overwritten.
> 
> Therefore, let's mark it as obsolete, and replace it with a new sysfs
> attribute named "rng_quality". This sets the quality setting of the
> hw rng device currently loaded and active, and starts/stops the hwrng
> kernel thread as required.
> 
> Dominik Brodowski (4):
>   hw_random: do not bother to order list of devices by quality
>   hw_random: start and stop in-kernel rngd in separate function
>   hw_random: use per-rng quality value instead of global setting
>   hw_random: introduce rng_quality sysfs attribute
> 
>  drivers/char/hw_random/core.c | 145 +++++++++++++++++++++++++---------
>  1 file changed, 107 insertions(+), 38 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
