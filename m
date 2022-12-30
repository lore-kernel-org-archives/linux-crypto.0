Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DF5C46467
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Dec 2022 15:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbiL3PP4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Dec 2022 10:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbiL3PPz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2022 10:15:55 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5C7140C3;
        Fri, 30 Dec 2022 07:15:54 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pBH6k-00COx8-JD; Fri, 30 Dec 2022 23:15:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Dec 2022 23:15:42 +0800
Date:   Fri, 30 Dec 2022 23:15:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64/sm4 - fix possible crash with CFI enabled
Message-ID: <Y68Anj0R2H5Wwca8@gondor.apana.org.au>
References: <20221221073232.15110-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221073232.15110-1-tianjia.zhang@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 21, 2022 at 03:32:32PM +0800, Tianjia Zhang wrote:
> The SM4 CCM/GCM assembly functions for encryption and decryption is
> called via indirect function calls.  Therefore they need to use
> SYM_TYPED_FUNC_START instead of SYM_FUNC_START to cause its type hash
> to be emitted when the kernel is built with CONFIG_CFI_CLANG=y.
> Otherwise, the code crashes with a CFI failure (if the compiler didn't
> happen to optimize out the indirect call).
> 
> Fixes: 67fa3a7fdf80 ("crypto: arm64/sm4 - add CE implementation for CCM mode")
> Fixes: ae1b83c7d572 ("crypto: arm64/sm4 - add CE implementation for GCM mode")
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  arch/arm64/crypto/sm4-ce-ccm-core.S | 5 +++--
>  arch/arm64/crypto/sm4-ce-gcm-core.S | 5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
