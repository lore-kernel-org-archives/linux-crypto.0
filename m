From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/2] crypto/drbg: account for no longer returning -EALREADY
Date: Sat, 21 Oct 2017 21:22:52 +0200
Message-ID: <1850213.PsBaiHKxjm@tauon.chronox.de>
References: <CAHmME9qwoSwFi7fsg1Z+gcEh1fBY+KY2rJ81UTHYn2ZMcjjwFA@mail.gmail.com> <20171019204506.25090-1-Jason@zx2c4.com> <20171019204506.25090-2-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        tytso@mit.edu, gregkh@linuxfoundation.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34968 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932159AbdJUTW6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Oct 2017 15:22:58 -0400
In-Reply-To: <20171019204506.25090-2-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 19. Oktober 2017, 22:45:06 CEST schrieb Jason A. Donenfeld:

Hi Jason,

> We now structure things in a way that assumes the seeding function is
> always eventually called.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  crypto/drbg.c | 20 +++++---------------
>  1 file changed, 5 insertions(+), 15 deletions(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 70018397e59a..501e013cb96c 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1411,18 +1411,8 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
> 
>  	err = add_random_ready_callback(&drbg->random_ready);
> 
> -	switch (err) {
> -	case 0:
> -		break;
> -
> -	case -EALREADY:
> -		err = 0;
> -		/* fall through */
> -
> -	default:
> -		drbg->random_ready.func = NULL;
> +	if (err)
>  		return err;

Don't you change the logic flow here? In case the add_random_ready_callback 
returns 0 because the ready function is already called due to crng_ready(), 
the new code above in the patch set continues. But with the current code, it 
will return at this point and do not perform the allocation below.



Ciao
Stephan
