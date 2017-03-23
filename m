From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] md5: remove from lib and only live in crypto
Date: Thu, 23 Mar 2017 12:43:09 -0700
Message-ID: <20170323194309.GA92809@gmail.com>
References: <20170316141857.20910-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36496 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbdCWTnN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 15:43:13 -0400
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
> ---
> In the last patch like this, we managed to get rid of halfmd4 from this
> file. In this series we get rid of md5, now that the patches have landed
> that remove such improper md5 usage from the kernel. When a final
> dependency on the (dead) sha1 is removed, then cryptohash.h will be removed
> all together. This patch is for the md5 removal.
> 

The patch itself looks good to me, and you can add
Reviewed-by: Eric Biggers <ebiggers@google.com>

There is a small issue, though, which is that currently cryptodev/master (where
this patch would be applied to) still has md5_transform() in
drivers/char/random.c, because cryptodev/master is based on v4.11-rc1 instead of
v4.11-rc2.  It's up to Herbert how he wants to deal with this, but maybe he
could merge in a later -rc.

- Eric
