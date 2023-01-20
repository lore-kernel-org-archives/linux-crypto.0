Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6C1C05027
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Jan 2023 10:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjATKcY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Jan 2023 05:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjATKcX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2023 05:32:23 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1BDB1EC1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Jan 2023 02:32:12 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pIogs-002BVY-6V; Fri, 20 Jan 2023 18:32:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jan 2023 18:32:10 +0800
Date:   Fri, 20 Jan 2023 18:32:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 0/4] crypto: Accelerated GCM for IPSec on ARM/arm64
Message-ID: <Y8ptqnTHRvy4mqB8@gondor.apana.org.au>
References: <20221214171957.2833419-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214171957.2833419-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 14, 2022 at 06:19:53PM +0100, Ard Biesheuvel wrote:
> This is a v2 as patch #1 was sent out in isolation a couple of days ago.
> 
> As it turns out, we can get ~10% speedup for RFC4106 on arm64
> (Cortex-A53) by giving it the same treatment as ARM, i.e., avoid the
> generic template and implement RFC4106 encapsulation directly in the
> driver
> 
> Patch #3 adds larger key sizes to the tcrypt benchmark for RFC4106
> 
> Patch #4 fixes some prose on AEAD that turned out to be inaccurate.
> 
> Changes since v1:
> - minor tweaks to the asm code in patch #1, one of which to fix a Clang
>   build error
> 
> Note: patch #1 depends on the softirq context patches for kernel mode
> NEON I sent out last week. More specifically, this implements a sync
> AEAD that does not implement a !simd fallback, as AEADs are not callable
> in hard IRQ context anyway.
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Ard Biesheuvel (4):
>   crypto: arm/ghash - implement fused AES/GHASH version of AES-GCM
>   crypto: arm64/gcm - add RFC4106 support
>   crypto: tcrypt - include larger key sizes in RFC4106 benchmark
>   crypto: aead - fix inaccurate documentation
> 
>  arch/arm/crypto/Kconfig           |   2 +
>  arch/arm/crypto/ghash-ce-core.S   | 382 +++++++++++++++++-
>  arch/arm/crypto/ghash-ce-glue.c   | 424 +++++++++++++++++++-
>  arch/arm64/crypto/ghash-ce-glue.c | 145 +++++--
>  crypto/tcrypt.c                   |   8 +-
>  crypto/tcrypt.h                   |   2 +-
>  include/crypto/aead.h             |  20 +-
>  7 files changed, 913 insertions(+), 70 deletions(-)
> 
> -- 
> 2.35.1

Patches 2-4 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
