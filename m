From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH resend 4.9] hw_random: Don't use a stack buffer in
 add_early_randomness()
Date: Wed, 19 Oct 2016 11:50:12 +0800
Message-ID: <20161019035012.GA2192@gondor.apana.org.au>
References: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jens Axboe <axboe@fb.com>, Matt Mullins <mmullins@mmlx.us>
To: Andy Lutomirski <luto@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38516 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753547AbcJSDuU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2016 23:50:20 -0400
Content-Disposition: inline
In-Reply-To: <4169224b6858d1cf149f1a73f8a03603fa19076d.1476638125.git.luto@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 17, 2016 at 10:06:27AM -0700, Andy Lutomirski wrote:
> hw_random carefully avoids using a stack buffer except in
> add_early_randomness().  This causes a crash in virtio_rng if
> CONFIG_VMAP_STACK=y.
> 
> Reported-by: Matt Mullins <mmullins@mmlx.us>
> Tested-by: Matt Mullins <mmullins@mmlx.us>
> Fixes: d3cc7996473a ("hwrng: fetch randomness only after device init")
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
