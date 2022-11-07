Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBCBC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Nov 2022 02:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiKGCR3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Nov 2022 21:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiKGCR3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Nov 2022 21:17:29 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3569657D
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 18:17:26 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1orrgs-00At6R-Sw; Mon, 07 Nov 2022 10:17:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Nov 2022 10:17:23 +0800
Date:   Mon, 7 Nov 2022 10:17:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH v3] hw_random: use add_hwgenerator_randomness() for early
 entropy
Message-ID: <Y2hqsz8kjJgwNm0E@gondor.apana.org.au>
References: <Y2fJy1akGIdQdH95@zx2c4.com>
 <20221106150243.150437-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221106150243.150437-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Nov 06, 2022 at 04:02:43PM +0100, Jason A. Donenfeld wrote:
> Rather than calling add_device_randomness(), the add_early_randomness()
> function should use add_hwgenerator_randomness(), so that the early
> entropy can be potentially credited, which allows for the RNG to
> initialize earlier without having to wait for the kthread to come up.
> 
> This requires some minor API refactoring, by adding a `sleep_after`
> parameter to add_hwgenerator_randomness(), so that we don't hit a
> blocking sleep from add_early_randomness().
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Herbert - it might be easiest for me to take this patch if you want? Or
> if this will interfere with what you have going on, you can take it. Let
> me know what you feel like. -Jason

I don't have anything that touches this file so feel free to push
it through your tree:

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
