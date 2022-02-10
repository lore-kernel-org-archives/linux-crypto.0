Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 686FBC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 14:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243236AbiBJOz6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:55:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243253AbiBJOz6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 09:55:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C3EC4C
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:55:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0285061B00
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 14:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED0EC340E5;
        Thu, 10 Feb 2022 14:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644504957;
        bh=kxoJ046ef0SpJXEKas2Cscq7GCb7j9IlmtKPr3PSY8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eEpAQLgfPt6/0vzfGNOWEc/rxzAd+tqRvZQAku0cXBCm5KyYuhFYtyPc/nckwt8qD
         SIUVpzNoI3FT3IISAveR7ApwXL938/NbI3HX4JAIpc0SCFA7VZmErRJM1F2FrJOxv9
         /rVq6ge5ykjQIGeeziGI9zuAvzFU9rvCyfmTcn6M=
Date:   Thu, 10 Feb 2022 15:55:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ted Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] random: Add a pseudorandom generator based on the
 xtea cipher
Message-ID: <YgUnejnQyEHqn0+P@kroah.com>
References: <CACXcFmnkeFJ2e7A4HOfTJ90ps956xZnoQ=RiZd=7=cZTzxGwMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmnkeFJ2e7A4HOfTJ90ps956xZnoQ=RiZd=7=cZTzxGwMw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 10:38:28PM +0800, Sandy Harris wrote:
> Add a pseudorandom generator based on the xtea cipher
> 
> This will be used only within the kernel, mainly within the driver
> to rekey chacha or dump extra random data into the input pool.
> 
> It needs a 64-bit output to match arch_get_random_long(), and
> the obvious way to get that is a 64-bit block cipher.
> 
> xtea was chosen partly for speed but mainly because, unlike
> most other block ciphers, it does not use a lot of storage
> for round keys or S-boxes. This driver already has 4k bits
> in the input pool and 512 bits each for chacha and hash
> contexts; that is reasonable, but if anything we should
> be looking at ways to reduce storage use rather than
> increasing it.
> 
> ---
>  drivers/char/random.c | 294 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 294 insertions(+)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index c8618020b49f..9edf65ad4259 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -737,6 +737,300 @@ static int credit_entropy_bits_safe(int nbits)
>      return 0;
>  }
> 
> +/*************************************************************************
> + * Use xtea to create a pseudorandom 64-bit output
> + * This should not be used for output to user space,
> + * only for things within the kernel
> + *
> + * xtea is fast & uses little storage
> + * See https://en.wikipedia.org/wiki/XTEA and papers it links
> + *
> + * tea is the original block cipher, Tiny Encryption Algorithm
> + * xtea is an improved version preventing some published attacks
> + * both are in linux/crypto/tea.c
> + *************************************************************************/
> +
> +static spinlock_t xtea_lock;
> +
> +/*
> + * These initialisations are not strictly needed,
> + * but they are more-or-less free and can do no harm.
> + * Constants are from SHA-512
> + */
> +static unsigned long tea_mask = 0x7137449123ef65cd ;
> +static unsigned long tea_counter = 0xb5c0fbcfec4d3b2f ;
> +/*
> + * 128-bit key
> + * cipher itself uses 32-bit operations
> + * but rekeying uses 64-bit
> + */
> +#ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
> +static unsigned long tea_key64[2] __latent_entropy ;
> +#else
> +static unsigned long tea_key64[2] = {0x0fc19dc68b8cd5b5, 0xe9b5dba58189dbbc} ;
> +#endif
> +static u32 *tea_key = (u32 *) &tea_key64[0] ;
> +
> +static void xtea_rekey(void) ;
> +
> +/*
> + * simplified version of code fron crypto/tea.c
> + * xtea_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
> + *
> + * does not use struct
> + * does no endianess conversions
> + * no *src or *dst, encrypt a 64-bit block in place
> + */
> +#define XTEA_ROUNDS        32
> +#define XTEA_DELTA        0x9e3779b9
> +
> +static void xtea_block(unsigned long *x)
> +{
> +    u32 i, y, z, sum, *p ;
> +    p = (u32 *) x ;
> +
> +    y = p[0] ;
> +    z = p[1] ;
> +    for (i = 0, sum = 0 ; i < XTEA_ROUNDS ; i++) {
> +        y += ((z << 4 ^ z >> 5) + z) ^ (sum + tea_key[sum&3]);
> +        sum += XTEA_DELTA;
> +        z += ((y << 4 ^ y >> 5) + y) ^ (sum + tea_key[sum>>11 &3]);
> +    }
> +    p[0] = y ;
> +    p[1] = z ;
> +}
> +
> +/*
> + * For counter mode see RFC 4086 section 6.2.1
> + * Add a constant instead of just incrementing
> + * to change more bits
> + *
> + * Even and Mansour proved proved a lower bound
> + * for an XOR-permutation-XOR sequence.
> + * S. Even, Y. Mansour, Asiacrypt 1991
> + * A Construction of a Cipher From a Single Pseudorandom Permutation
> + *
> + * For an n-bit block and D known or chosen plaintexts,
> + * time T to break it is bounded by DT >= 2^n.
> + *
> + * This applies even if the enemy knows the permutation,
> + * for a block cipher even if he or she knows the key.
> + * All the proof requires is that the permutation be
> + * nonlinear, which any block cipher is.
> + *
> + * Neither this function nor xtea_block() takes any locks.
> + * Callers should take xtea_lock.
> + */
> +#define COUNTER_DELTA 0x240ca1cc77ac9c65
> +static int xtea_iterations = 0 ;
> +
> +static unsigned long xtea_counter(void)
> +{
> +    unsigned long x ;
> +    x = tea_counter ^ tea_mask ;
> +    xtea_block(&x) ;
> +    x ^= tea_mask ;
> +    tea_counter += COUNTER_DELTA ;
> +    xtea_iterations++ ;
> +    return x ;
> +}
> +
> +/*
> + * This does a full rekey (update key, mask and counter)
> + * when xtea_iterations >= 1021, the largest prime < 1024.
> + *
> + * Using the Even-Mansour bound DT >= 2^n we have n = 64
> + * and D < 2^10 so time T to break it is T > 2^54.
> + *
> + * That lets the attacker learn the mask value for one
> + * sequence of 1021 outputs between rekeyings. He or she
> + * must repeat the costly attack to get the next mask
> + * when the cipher is rekeyed.
> + *
> + * Also, the attack needs D known plaintext/ciphertext
> + * pairs which should be hard to get. The plaintext is
> + * only a counter but it is randomly initialised, and
> + * the ciphertext is not sent outside the kernel. Even
> + * within the kernel it is never just saved, but always
> + * mixed with other data.
> + *
> + * Assuming proper keying and that the enemy cannot
> + * peek into the running kernel, this can be considered
> + * effectively unbreakable, and would be so even if
> + * xtea itself were flawed.
> + */
> +#define TEA_REKEY       1021
> +
> +static void get_xtea_long(unsigned long *out)
> +{
> +    unsigned long flags ;
> +
> +    if (xtea_iterations >= TEA_REKEY)
> +        xtea_iterations = 0 ;
> +    if (xtea_iterations == 0)
> +        xtea_rekey() ;
> +
> +    spin_lock_irqsave(&xtea_lock, flags) ;
> +    *out = xtea_counter() ;
> +    spin_unlock_irqrestore(&xtea_lock, flags) ;
> +}
> +
> +/*
> + * Inject a bit of external entropy
> + * Use a cheap source, not particularly strong
> + *
> + * xtea has reasonable round avalanche and
> + * 32 rounds, so any change in the key will
> + * affect many output bits
> + *
> + * After two calls to this, every 32-bit word
> + * of the key has been changed. After four,
> + * each word has had two updates, one with
> + * ^= and one with +=
> + */
> +static u32 perturb_count = 0 ;
> +
> +static void xtea_perturb(void)
> +{
> +    u32 x ;
> +    unsigned long flags ;
> +    x = random_get_entropy() ;
> +
> +    spin_lock_irqsave(&xtea_lock, flags) ;
> +    tea_key[perturb_count] ^= x ;
> +    tea_key[3 - perturb_count] += x ;
> +    perturb_count++ ;
> +    perturb_count ^= 3 ;
> +    spin_unlock_irqrestore(&xtea_lock, flags) ;
> +}
> +
> +/*
> + * Despite the name, this is not used for standalone
> + * rekeying, only as a mixer when some part of the
> + * xtea data has been changed and we want to spread
> + * the effect to all parts.
> + *
> + * Uses xtea_counter() rather than get_xtea_long()
> + * to avoid complications with recursion and locking
> + */
> +static void xtea_self_rekey(void)
> +{
> +    unsigned long flags ;
> +    spin_lock_irqsave(&xtea_lock, flags) ;
> +    tea_key64[0] ^= xtea_counter() ;
> +    tea_key64[1] ^= xtea_counter() ;
> +    tea_counter  ^= xtea_counter() ;
> +    tea_mask += xtea_counter() ;
> +    spin_unlock_irqrestore(&xtea_lock, flags) ;
> +}
> +
> +static int xtea_initialised = 0 ;
> +
> +static void xtea_rekey(void)
> +{
> +    unsigned long u, v, x, y ;
> +    int a, b, c, d, i ;
> +    int flag = 0 ;
> +    unsigned long flags ;
> +
> +    if ((system_state == SYSTEM_BOOTING) && IS_ENABLED(CONFIG_ARCH_RANDOM)) {
> +        a = (arch_get_random_long_early(&u) ||
> arch_get_random_seed_long_early(&u));
> +        b = (arch_get_random_long_early(&v) ||
> arch_get_random_seed_long_early(&v));
> +        c = (arch_get_random_long_early(&x) ||
> arch_get_random_seed_long_early(&x));
> +        d = (arch_get_random_long_early(&y) ||
> arch_get_random_seed_long_early(&y));
> +        if (a && b && c && d)
> +            flag = 1 ;
> +        else
> +            pr_warn("arch_get_random_long_early() failed in xtea_rekey()") ;
> +    }
> +    if (!flag && IS_ENABLED(CONFIG_ARCH_RANDOM)) {
> +        a = arch_get_random_long(&u) || arch_get_random_seed_long(&u);
> +        b = arch_get_random_long(&v) || arch_get_random_seed_long(&v) ;
> +        c = arch_get_random_long(&x) || arch_get_random_seed_long(&x) ;
> +        d = arch_get_random_long(&y) || arch_get_random_seed_long(&y) ;
> +        if (a && b && c && d)
> +            flag = 1 ;
> +        else
> +            pr_warn("arch_get_random_long() failed in xtea_rekey()") ;
> +    }
> +    if (!flag && IS_ENABLED(CONFIG_HW_RANDOM))      {
> +        a = get_hw_long(&u) ;
> +        b = get_hw_long(&v) ;
> +        c = get_hw_long(&x) ;
> +        d = get_hw_long(&y) ;
> +        if (a && b && c && d)
> +            flag = 1 ;
> +        else
> +            pr_warn("hardware rng failed in xtea_rekey()") ;
> +    }
> +    if (flag)       {
> +        spin_lock_irqsave(&xtea_lock, flags) ;
> +        tea_mask += u ;
> +        tea_counter ^= v ;
> +        tea_key64[0] ^= x ;
> +        tea_key64[1] ^= y ;
> +        spin_unlock_irqrestore(&xtea_lock, flags) ;
> +        memzero_explicit(&u, 8) ;
> +        memzero_explicit(&v, 8) ;
> +        memzero_explicit(&x, 8) ;
> +        memzero_explicit(&y, 8) ;
> +        /*
> +         * any of the above should be good enough
> +         * but mix in a little extra entropy to avoid
> +         * trusting them completely
> +         */
> +        if (!xtea_initialised)    {
> +            xtea_initialised = 1 ;
> +        }
> +        xtea_perturb() ;
> +    }
> +    if (!flag && IS_ENABLED(CONFIG_GCC_PLUGIN_LATENT_ENTROPY))    {
> +        if (xtea_initialised)
> +            xtea_perturb() ;
> +
> +        spin_lock_irqsave(&xtea_lock, flags) ;
> +        // tea_counter ^= latent_entropy ;
> +        if (!xtea_initialised)    {
> +            /*
> +             * the plugin randomly initialises both tea-key[]
> +             * and the input pool at boot
> +             */
> +            xor128(tea_key, &input_pool_data[0]) ;
> +            add128(tea_key, &input_pool_data[4]) ;
> +            xtea_initialised = 1 ;
> +        }
> +        spin_unlock_irqrestore(&xtea_lock, flags) ;
> +        xtea_self_rekey() ;
> +        flag = 1 ;
> +    }
> +    /*
> +     * None of the above succeeded so the driver cannot be
> +     * fully secure until enough entropy is accumulated
> +     * in the input pool and chacha is reseeded.
> +     *
> +     * Do some extra mixing here, likely enough to stop
> +     * some attackers.
> +     *
> +     * This does not add enough entropy to stop a determined
> +     * attacker with major resources. If you need protection
> +     * against such opponents, then you must ensure that
> +     * some branch above succeeds.
> +     */
> +    if (!flag)    {
> +        if (xtea_initialised)
> +            a = 1 ;
> +        else    {
> +            a = 4 ;
> +            xtea_initialised = 1 ;
> +        }
> +        for( i = 0 ; i < a ; i++ )    {
> +            xtea_perturb() ;
> +            xtea_self_rekey() ;
> +        }
> +    }
> +    xtea_iterations = 0 ;
> +}
> +
>  /*********************************************************************
>   *
>   * CRNG using CHACHA20
> -- 
> 2.25.1

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch contains warnings and/or errors noticed by the
  scripts/checkpatch.pl tool.

- Your patch is malformed (tabs converted to spaces, linewrapped, etc.)
  and can not be applied.  Please read the file,
  Documentation/email-clients.txt in order to fix this.


If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
