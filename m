From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 7/7] random: add backtracking protection to the CRNG
Date: Sun, 26 Jun 2016 20:47:53 +0200
Message-ID: <20160626184753.GB11162@amd>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <1465832919-11316-8-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, smueller@chronox.de,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42406 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbcFZSr5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 26 Jun 2016 14:47:57 -0400
Content-Disposition: inline
In-Reply-To: <1465832919-11316-8-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon 2016-06-13 11:48:39, Theodore Ts'o wrote:
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  drivers/char/random.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 49 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index d640865..963a6a9 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -436,7 +436,8 @@ static int crng_init = 0;
>  #define crng_ready() (likely(crng_init > 0))
>  static void _extract_crng(struct crng_state *crng,
>  			  __u8 out[CHACHA20_BLOCK_SIZE]);
> -static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE]);
> +static void _crng_backtrack_protect(struct crng_state *crng,
> +				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used);
>  static void process_random_ready_list(void);

You can do u8 and u32 in the code, we know we are in kernel.

> +/*
> + * Use the leftover bytes from the CRNG block output (if there is
> + * enough) to mutate the CRNG key to provide backtracking protection.
> + */
> +static void _crng_backtrack_protect(struct crng_state *crng,
> +				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used)
> +{
> +	unsigned long	flags;
> +	__u32		*s, *d;
> +	int		i;
> +
> +	used = round_up(used, sizeof(__u32));
> +	if (used + CHACHA20_KEY_SIZE > CHACHA20_BLOCK_SIZE) {
> +		extract_crng(tmp);
> +		used = 0;
> +	}
> +	spin_lock_irqsave(&crng->lock, flags);
> +	s = (__u32 *) &tmp[used];
> +	d = &crng->state[4];
> +	for (i=0; i < 8; i++)
> +		*d++ ^= *s++;
> +	spin_unlock_irqrestore(&crng->lock, flags);
> +}

You are basically trying to turn CRNG into one way hash function here,
right? Do you have any explanation that it has the required
properties?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
