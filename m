Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E11CC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Feb 2022 04:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiBRE1u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Feb 2022 23:27:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbiBRE1t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Feb 2022 23:27:49 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D8B3F31A;
        Thu, 17 Feb 2022 20:27:32 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nKurY-0004Gf-K1; Fri, 18 Feb 2022 15:27:21 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Feb 2022 15:27:20 +1100
Date:   Fri, 18 Feb 2022 15:27:20 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux@dominikbrodowski.net,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Kalle Valo <kvalo@kernel.org>, ath9k-devel@qca.qualcomm.com,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: pull add_hwgenerator_randomness() declaration
 into random.h
Message-ID: <Yg8gKLVZpLs2mZYF@gondor.apana.org.au>
References: <20220213152522.816777-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220213152522.816777-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 13, 2022 at 04:25:22PM +0100, Jason A. Donenfeld wrote:
> add_hwgenerator_randomness() is a function implemented and documented
> inside of random.c. It is the way that hardware RNGs push data into it.
> Therefore, it should be declared in random.h. Otherwise sparse complains
> with:
> 
> random.c:1137:6: warning: symbol 'add_hwgenerator_randomness' was not declared. Should it be static?
> 
> The alternative would be to include hw_random.h into random.c, but that
> wouldn't really be good for anything except slowing down compile time.
> 
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: ath9k-devel@qca.qualcomm.com
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/char/hw_random/core.c        | 1 +
>  drivers/net/wireless/ath/ath9k/rng.c | 1 +
>  include/linux/hw_random.h            | 2 --
>  include/linux/random.h               | 2 ++
>  4 files changed, 4 insertions(+), 2 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
