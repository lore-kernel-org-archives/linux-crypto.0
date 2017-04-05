From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 0/4] gf128mul refactoring
Date: Wed, 5 Apr 2017 22:11:05 +0800
Message-ID: <20170405141105.GH27150@gondor.apana.org.au>
References: <20170402191916.9309-1-omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Jeffrey Walton <noloader@gmail.com>,
        Milan Broz <gmazyland@gmail.com>
To: Ondrej Mosnacek <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37510 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754554AbdDEON0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 10:13:26 -0400
Content-Disposition: inline
In-Reply-To: <20170402191916.9309-1-omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 02, 2017 at 09:19:12PM +0200, Ondrej Mosnacek wrote:
> This patchset contains the following gf128mul-related changes:
>   1. The gf128mul_x_* functions are moved to gf128mul.h for performance reasons.
>   2. The gf128mul_x_ble function is fixed to use the correct block type.
>   3. The le128_gf128mul_x_ble function from glue_helper.h is removed and its
>      usages replaced with gf128mul_x_ble calls.
>   4. The now obsolete dependency of CRYPTO_XTS on CRYPTO_GF128MUL is removed.
> 
> v4 -> v5: added the other three patches
> v3 -> v4: a faster version of gf128mul_x_lle
> v2 -> v3: constant-time implementation
> v1 -> v2: move all _x_ functions to the header, not just gf128mul_x_ble

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
