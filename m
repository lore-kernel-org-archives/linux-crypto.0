Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 371C0C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 04:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379368AbiBEEcR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Feb 2022 23:32:17 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34036 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235379AbiBEEcR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Feb 2022 23:32:17 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nGCkA-00026f-NF; Sat, 05 Feb 2022 15:32:15 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Feb 2022 15:32:14 +1100
Date:   Sat, 5 Feb 2022 15:32:14 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] crypto: arm - simplify bit sliced AES
Message-ID: <Yf39zlj8UjtOIFfc@gondor.apana.org.au>
References: <20220127113545.7821-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127113545.7821-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 27, 2022 at 12:35:42PM +0100, Ard Biesheuvel wrote:
> This contains a couple of improvements/simplifications for the bit
> sliced AES driver implemented on ARM and arm64.
> 
> Ard Biesheuvel (3):
>   crypto: arm/aes-neonbs-ctr - deal with non-multiples of AES block size
>   crypto: arm64/aes-neonbs-ctr - fallback to plain NEON for final chunk
>   crypto: arm64/aes-neonbs-xts - use plain NEON for non-power-of-2 input
>     sizes
> 
>  arch/arm/crypto/aes-neonbs-core.S   | 105 ++++----
>  arch/arm/crypto/aes-neonbs-glue.c   |  35 ++-
>  arch/arm64/crypto/aes-glue.c        |   1 +
>  arch/arm64/crypto/aes-neonbs-core.S | 264 +++++---------------
>  arch/arm64/crypto/aes-neonbs-glue.c |  97 ++++---
>  5 files changed, 189 insertions(+), 313 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
