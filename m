Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C11B3C3A59D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 05:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EBB221848
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 05:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbfHVF5Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 01:57:24 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58426 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730851AbfHVF5Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 01:57:24 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1i0g66-0002zv-3O; Thu, 22 Aug 2019 15:57:22 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1i0g65-00013F-2p; Thu, 22 Aug 2019 15:57:21 +1000
Date:   Thu, 22 Aug 2019 15:57:21 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        linuxppc-dev@lists.ozlabs.org, leitao@debian.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com
Subject: Re: [PATCH] crypto: vmx/xts - use fallback for ciphertext stealing
Message-ID: <20190822055721.GH3860@gondor.apana.org.au>
References: <20190816140625.27053-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816140625.27053-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 16, 2019 at 05:06:24PM +0300, Ard Biesheuvel wrote:
> For correctness and compliance with the XTS-AES specification, we are
> adding support for ciphertext stealing to XTS implementations, even
> though no use cases are known that will be enabled by this.
> 
> Since the Power8 implementation already has a fallback skcipher standby
> for other purposes, let's use it for this purpose as well. If ciphertext
> stealing use cases ever become a bottleneck, we can always revisit this.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/crypto/vmx/aes_xts.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
