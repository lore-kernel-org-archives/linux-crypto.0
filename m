From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a Chacha20-based CRNG
Date: Mon, 13 Jun 2016 20:00:33 +0200
Message-ID: <5058147.V85lyiaTYe@positron.chronox.de>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu> <1465832919-11316-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com, jsd@av8n.com,
	hpa@zytor.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36372 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161026AbcFMSAg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 14:00:36 -0400
In-Reply-To: <1465832919-11316-6-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 13. Juni 2016, 11:48:37 schrieb Theodore Ts'o:

Hi Theodore,

>  /*
> @@ -1254,15 +1423,26 @@ static ssize_t extract_entropy_user(struct
> entropy_store *r, void __user *buf, */
>  void get_random_bytes(void *buf, int nbytes)
>  {
> +	__u8 tmp[CHACHA20_BLOCK_SIZE];
> +
>  #if DEBUG_RANDOM_BOOT > 0
> -	if (unlikely(nonblocking_pool.initialized == 0))
> +	if (!crng_ready())
>  		printk(KERN_NOTICE "random: %pF get_random_bytes called "
> -		       "with %d bits of entropy available\n",
> -		       (void *) _RET_IP_,
> -		       nonblocking_pool.entropy_total);
> +		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
>  #endif
>  	trace_get_random_bytes(nbytes, _RET_IP_);
> -	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
> +
> +	while (nbytes >= CHACHA20_BLOCK_SIZE) {
> +		extract_crng(buf);
> +		buf += CHACHA20_BLOCK_SIZE;
> +		nbytes -= CHACHA20_BLOCK_SIZE;
> +	}
> +
> +	if (nbytes > 0) {
> +		extract_crng(tmp);
> +		memcpy(buf, tmp, nbytes);
> +		memzero_explicit(tmp, nbytes);
> +	}

What is your take on the following issue:

1. The ChaCha20 is seeded with 256 bits (let us assume it is full entropy)

2. The ChaCha20 block operation shuffles the 256 bits of entropy over the 512 
bit state -- already here we see that after shuffling, the entropy to bit 
ratio fell from (256 bits of entropy / 256 data bits) to (256 bits of entropy 
/ 512 data bits).

3. The code above directly returns the output of the ChaCha20 round to the 
caller. Considering the discussion in step 2, I would assume that the entropy 
content of the output size is cut in half.

Ciao
Stephan
