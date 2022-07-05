Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE53C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 02:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiGECjk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jul 2022 22:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbiGECjk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jul 2022 22:39:40 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C58AF588
        for <linux-crypto@vger.kernel.org>; Mon,  4 Jul 2022 19:39:39 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o8YTO-00EUEa-NN; Tue, 05 Jul 2022 12:39:36 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 Jul 2022 10:39:35 +0800
Date:   Tue, 5 Jul 2022 10:39:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: Re: [PATCH crypto 5.19] crypto: s390 - do not depend on CRYPTO_HW
 for SIMD implementations
Message-ID: <YsOkZ1EdIkodYVBG@gondor.apana.org.au>
References: <20220705014653.111335-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220705014653.111335-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 05, 2022 at 03:46:53AM +0200, Jason A. Donenfeld wrote:
> Various accelerated software implementation Kconfig values for S390 were
> mistakenly placed into drivers/crypto/Kconfig, even though they're
> mainly just SIMD code and live in arch/s390/crypto/ like usual. This
> gives them the very unusual dependency on CRYPTO_HW, which leads to
> problems elsewhere.
> 
> This patch fixes the issue by moving the Kconfig values for non-hardware
> drivers into the usual place in crypto/Kconfig.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  crypto/Kconfig         | 114 ++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/Kconfig | 115 -----------------------------------------
>  2 files changed, 114 insertions(+), 115 deletions(-)

This is caused by the s390 patch for wireguard, right?

As such it's a new feature and I don't see why it needs to go
in right away.  Having said that, if you insist I'm happy for
you take this into your tree along with the wireguard patch
where it would make more sense.

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

I've also added CCs to the s390 maintainers.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
