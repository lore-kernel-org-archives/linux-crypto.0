Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88673C4167B
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Dec 2022 15:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiL3PDr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Dec 2022 10:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiL3PDq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2022 10:03:46 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23D8140DF
        for <linux-crypto@vger.kernel.org>; Fri, 30 Dec 2022 07:03:45 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pBGv9-00COfN-2i; Fri, 30 Dec 2022 23:03:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Dec 2022 23:03:43 +0800
Date:   Fri, 30 Dec 2022 23:03:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH] crypto: arm/ghash - implement fused AES/GHASH
 implementation of GCM
Message-ID: <Y679z3SPiHn+y7Zt@gondor.apana.org.au>
References: <20221212183758.1079283-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212183758.1079283-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 12, 2022 at 07:37:58PM +0100, Ard Biesheuvel wrote:
> On 32-bit ARM, AES in GCM mode takes full advantage of the ARMv8 Crypto
> Extensions when available, resulting in a performance of 6-7 cycles per
> byte for typical IPsec frames on cores such as Cortex-A53, using the
> generic GCM template encapsulating the accelerated AES-CTR and GHASH
> implementations.
> 
> At such high rates, any time spent copying data or doing other poorly
> optimized work in the generic layer hurts disproportionately, and we can
> get a significant performance improvement by combining the optimized
> AES-CTR and GHASH implementations into a single one.
> 
> On Cortex-A53, this results in a performance improvement of around 70%,
> or 4.2 cycles per byte for AES-256-GCM-128 with RFC4106 encapsulation.
> The fastest mode on this core is bare AES-128-GCM using 8k blocks, which
> manages 2.66 cycles per byte.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> Note: this patch depends on the softirq context patches for kernel mode
> NEON I sent last week. More specifically, this implements a sync AEAD
> that does not implement a !simd fallback, as AEADs are not callable in
> IRQ context anyway.
> 
>  arch/arm/crypto/Kconfig         |   2 +
>  arch/arm/crypto/ghash-ce-core.S | 381 +++++++++++++++++++-
>  arch/arm/crypto/ghash-ce-glue.c | 350 +++++++++++++++++-
>  3 files changed, 718 insertions(+), 15 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
