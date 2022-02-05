Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AE2C433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 04:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379319AbiBEEaQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Feb 2022 23:30:16 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34018 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379317AbiBEEaM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Feb 2022 23:30:12 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nGCi2-0001xt-4e; Sat, 05 Feb 2022 15:30:03 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Feb 2022 15:30:02 +1100
Date:   Sat, 5 Feb 2022 15:30:02 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dominik Brodowski <linux@dominikbrodowski.net>
Cc:     Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 1/6] hw_random: explicit ordering of initcalls
Message-ID: <Yf39ShK5r7TXXdac@gondor.apana.org.au>
References: <20220124202951.28579-1-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124202951.28579-1-linux@dominikbrodowski.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 24, 2022 at 09:29:46PM +0100, Dominik Brodowski wrote:
> hw-random device drivers depend on the hw-random core being
> initialized. Make this ordering explicit, also for the case
> these drivers are built-in. As the core itself depends on
> misc_register() which is set up at subsys_initcall time,
> advance the initialization of the core (only) to the
> fs_initcall() level.
> 
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> ---
>  drivers/char/hw_random/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
