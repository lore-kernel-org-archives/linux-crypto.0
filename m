Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F47C433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 06:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2273235FF
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 06:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbhAVGVx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Jan 2021 01:21:53 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54114 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbhAVGVt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Jan 2021 01:21:49 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l2poK-00021P-Bn; Fri, 22 Jan 2021 17:20:45 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Jan 2021 17:20:44 +1100
Date:   Fri, 22 Jan 2021 17:20:44 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiggers@kernel.org, arnd@arndb.de
Subject: Re: [PATCH v3] crypto - shash: reduce minimum alignment of
 shash_desc structure
Message-ID: <20210122062044.GA1217@gondor.apana.org.au>
References: <20210113091135.32579-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113091135.32579-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 13, 2021 at 10:11:35AM +0100, Ard Biesheuvel wrote:
> Unlike many other structure types defined in the crypto API, the
> 'shash_desc' structure is permitted to live on the stack, which
> implies its contents may not be accessed by DMA masters. (This is
> due to the fact that the stack may be located in the vmalloc area,
> which requires a different virtual-to-physical translation than the
> one implemented by the DMA subsystem)
> 
> Our definition of CRYPTO_MINALIGN_ATTR is based on ARCH_KMALLOC_MINALIGN,
> which may take DMA constraints into account on architectures that support
> non-cache coherent DMA such as ARM and arm64. In this case, the value is
> chosen to reflect the largest cacheline size in the system, in order to
> ensure that explicit cache maintenance as required by non-coherent DMA
> masters does not affect adjacent, unrelated slab allocations. On arm64,
> this value is currently set at 128 bytes.
> 
> This means that applying CRYPTO_MINALIGN_ATTR to struct shash_desc is both
> unnecessary (as it is never used for DMA), and undesirable, given that it
> wastes stack space (on arm64, performing the alignment costs 112 bytes in
> the worst case, and the hole between the 'tfm' and '__ctx' members takes
> up another 120 bytes, resulting in an increased stack footprint of up to
> 232 bytes.) So instead, let's switch to the minimum SLAB alignment, which
> does not take DMA constraints into account.
> 
> Note that this is a no-op for x86.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> v3: - drop skcipher_request change again - this needs more careful thought
> 
> v2: - reduce alignment for SYNC_SKCIPHER_REQUEST_ON_STACK as well
>     - update CRYPTO_MINALIGN_ATTR comment with DMA requirements.
> 
>  include/crypto/hash.h  | 8 ++++----
>  include/linux/crypto.h | 9 ++++++---
>  2 files changed, 10 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
