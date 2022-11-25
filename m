Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 440EDC4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Nov 2022 12:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiKYMZE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Nov 2022 07:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiKYMYt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Nov 2022 07:24:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDF74C273;
        Fri, 25 Nov 2022 04:24:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2911C62371;
        Fri, 25 Nov 2022 12:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C99C433C1;
        Fri, 25 Nov 2022 12:24:34 +0000 (UTC)
Date:   Fri, 25 Nov 2022 12:24:31 +0000
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 3/9] crypto: aead - Add ctx helpers with DMA alignment
Message-ID: <Y4Cz/xJKYbdOyjiB@arm.com>
References: <Y4BGC2BPesy3qsEm@gondor.apana.org.au>
 <E1oyQS1-000djS-65@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1oyQS1-000djS-65@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 25, 2022 at 12:36:33PM +0800, Herbert Xu wrote:
> diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
> index d482017f3e20..cd8cb1e921b7 100644
> --- a/include/crypto/internal/aead.h
> +++ b/include/crypto/internal/aead.h
> @@ -39,6 +39,11 @@ static inline void *crypto_aead_ctx(struct crypto_aead *tfm)
>  	return crypto_tfm_ctx(&tfm->base);
>  }
>  
> +static inline void *crypto_aead_ctx_dma(struct crypto_aead *tfm)
> +{
> +	return crypto_tfm_ctx_dma(&tfm->base);
> +}

I wonder, if drivers end up calling this, isn't it easier to do the
alignment in crypto_aead_ctx() directly? There are over 300 callers (not
sure about the padding though, it may need still driver changes unless
we can add it to something like crypto_tfm_alg_alignmask()). Or is the
expectation that not all drivers need a DMA alignment?

-- 
Catalin
