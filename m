From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] md5: remove from lib and only live in crypto
Date: Fri, 24 Mar 2017 22:13:13 +0800
Message-ID: <20170324141313.GC14780@gondor.apana.org.au>
References: <20170316141857.20910-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42628 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935803AbdCXONX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:13:23 -0400
Content-Disposition: inline
In-Reply-To: <20170316141857.20910-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 16, 2017 at 03:18:57PM +0100, Jason A. Donenfeld wrote:
> The md5_transform function is no longer used any where in the tree,
> except for the crypto api's actual implementation of md5, so we can drop
> the function from lib and put it as a static function of the crypto
> file, where it belongs. There should be no new users of md5_transform,
> anyway, since there are more modern ways of doing what it once achieved.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
