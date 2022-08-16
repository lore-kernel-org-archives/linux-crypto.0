Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44EA4C2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 08:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiHPI1O (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 04:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbiHPI0K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 04:26:10 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4661D13EC87;
        Mon, 15 Aug 2022 22:56:34 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oNpZ0-00BVsf-F6; Tue, 16 Aug 2022 15:56:31 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 16 Aug 2022 13:56:30 +0800
Date:   Tue, 16 Aug 2022 13:56:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Robert Elliott <elliott@hpe.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ardb@kernel.org, toshi.kani@hpe.com
Subject: Re: [PATCH] crypto: tcrypt - remove mode=1000
Message-ID: <YvsxjuBlOw6g4I/c@gondor.apana.org.au>
References: <20220815042915.44547-1-elliott@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815042915.44547-1-elliott@hpe.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Aug 14, 2022 at 11:29:15PM -0500, Robert Elliott wrote:
> The lists of algothms checked for existence by
>     modprobe tcrypt mode=1000
> generates three bogus errors:
>     modprobe tcrypt mode=1000
> 
>     console log:
>     tcrypt: alg rot13 not found
>     tcrypt: alg cts not found
>     tcrypt: alg arc4 not found
> 
> rot13 is not an algorithm in the crypto API or tested.
> 
> cts is a wrapper, not a base algorithm.
> 
> arc4 is named ecb(arc4), not arc4.
> 
> Also, the list is missing numerous algorithms that are tested by
> other test modes:
>     blake2b-512
>     blake2s-256
>     crct10dif
>     xxhash64
>     ghash
>     cast5
>     sm4
>     ansi_prng
> 
> Several of the algorithms are only available if
> CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE is enabled:
>     arc4
>     khazad
>     seed
>     tea, xtea, xeta
> 
> Rather that fix that list, remove test mode=1000 entirely.
> It seems to have limited utility, and a web search shows no
> discussion of anybody using it.
> 
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Robert Elliott <elliott@hpe.com>
> ---
>  crypto/tcrypt.c | 28 ----------------------------
>  1 file changed, 28 deletions(-)

I think it would be better to use alg_test_descs as the source
list of get rid of check.  But I never use this so unless someone
else complains I'm fine with removing it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
