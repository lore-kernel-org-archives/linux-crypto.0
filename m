Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFABC433E0
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3BAD20799
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 22:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbhABWHY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 17:07:24 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37308 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbhABWHY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 17:07:24 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvp2i-0000b6-JQ; Sun, 03 Jan 2021 09:06:37 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 09:06:36 +1100
Date:   Sun, 3 Jan 2021 09:06:36 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH v2] crypto: arm/chacha-neon - add missing counter
 increment
Message-ID: <20210102220636.GI12767@gondor.apana.org.au>
References: <20201213143929.7088-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201213143929.7088-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 13, 2020 at 03:39:29PM +0100, Ard Biesheuvel wrote:
> Commit 86cd97ec4b943af3 ("crypto: arm/chacha-neon - optimize for non-block
> size multiples") refactored the chacha block handling in the glue code in
> a way that may result in the counter increment to be omitted when calling
> chacha_block_xor_neon() to process a full block. This violates the skcipher
> API, which requires that the output IV is suitable for handling more input
> as long as the preceding input has been presented in round multiples of the
> block size. Also, the same code is exposed via the chacha library interface
> whose callers may actually rely on this increment to occur even for final
> blocks that are smaller than the chacha block size.
> 
> So increment the counter after calling chacha_block_xor_neon().
> 
> Fixes: 86cd97ec4b943af3 ("crypto: arm/chacha-neon - optimize for non-block size multiples")
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> v2: - use ++ instead of += 1
>     - make note in the commit log of the fact that the library API needs the
>       increment to occur in all cases, not only for final blocks whose size
>       is exactly the block size
> 
>  arch/arm/crypto/chacha-glue.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
