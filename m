Return-Path: <SRS0=kAoH=D5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE245C388F2
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 05:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70462223FB
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 05:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603342943;
	bh=7ATTgNPDh9Ptbo03WyezrsUJTXjkyp4mMMR+nJAv/68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=PZbwgvR2rWPE2ZdliHdJSToYpXmf0HPCbqzwTFxx17x7IUzATkUVVOZ2PybwJvUSQ
	 MLWZeGDeLxnSguP0/1v1yWEH8dNaDNhfqi53wfnPGHkYME23YatkJdj86qAJtyMUFs
	 Eea5kv1FjK78WKLbX6FagOufjK5XeGqXH2tFhP5g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507684AbgJVFCW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Oct 2020 01:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2507683AbgJVFCW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Oct 2020 01:02:22 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 301F620657;
        Thu, 22 Oct 2020 05:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603342941;
        bh=7ATTgNPDh9Ptbo03WyezrsUJTXjkyp4mMMR+nJAv/68=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DEUiwIWKYt7R5AIXYNcREzNU176XhwmolA7Qq8LoFn236ie+J8Rr1zoFt/kteZCXp
         PGOkPl4b0ehKA2lgnXZl8yGyN6ICJOFex+3CQ+Mp6hasziWqyxoSkuboNJ7X14dFso
         Mfgs38IO4UtFOGLkSLfCjyZqsenR9E5iQuN87vY8=
Date:   Wed, 21 Oct 2020 22:02:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] crypto: lib/sha256 - Unroll SHA256 loop 8 times
 intead of 64
Message-ID: <20201022050219.GG857@sol.localdomain>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
 <20201020203957.3512851-5-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020203957.3512851-5-nivedita@alum.mit.edu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 20, 2020 at 04:39:55PM -0400, Arvind Sankar wrote:
> This reduces code size substantially (on x86_64 with gcc-10 the size of
> sha256_update() goes from 7593 bytes to 1952 bytes including the new
> SHA256_K array), and on x86 is slightly faster than the full unroll
> (tesed on Broadwell Xeon).

tesed => tested

> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> ---
>  lib/crypto/sha256.c | 166 ++++++++------------------------------------
>  1 file changed, 30 insertions(+), 136 deletions(-)
> 
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index c6bfeacc5b81..5efd390706c6 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -18,6 +18,17 @@
>  #include <crypto/sha.h>
>  #include <asm/unaligned.h>
>  
> +static const u32 SHA256_K[] = {
> +	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
> +	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
> +	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
> +	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
> +	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
> +	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
> +	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
> +	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
> +};

Limit this to 80 columns?

Otherwise this looks good.

- Eric
