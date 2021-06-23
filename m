Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B09C4743C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 14:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A9ED6101D
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 14:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFWOZG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jun 2021 10:25:06 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:25943 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhFWOZF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jun 2021 10:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624458161;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=m9MV8HvhSCqMvv6F8n0sz1KdQ6t+3u6rWS/PJOlbfXw=;
    b=FkiXkylx/cX99LRhNbg6G5FTK2r7uWfMDoEsiyFRGxoUvb0uq1FFZS5BEdu0cMEAAO
    AUxITo9DzbUB4CGpsO2TUNhREFbhtaoETnD7LCWzQMvFBCgdk4XlUFb8XCIfIXIuZgdI
    Pxu7HwCGK+d1ImV64Q4mrvJLngkwVQfmOFfvj80xXc2XZ3VZ/NGlkXdXNyHSlBShLYZ/
    E6hkjaJlzJjdQ76aMxwQxoxvO2fG9o/7hfDx8e9BErMbv4t5A3peUpey6nujAuZwOE/S
    H0EtrpvCNRjHlhWEIsnRM5GN/isRnS8uIilAm0OW5RXpHt5F5IX84SqlVLxCywDvHf/s
    udOg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884PWF+FE3S4jfoUvpUyAZcnNYTu5QMc76bM28i6AVC6uGxAqWEQFA0="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.27.5 AUTH)
    with ESMTPSA id L04113x5NEMd1DZ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 23 Jun 2021 16:22:39 +0200 (CEST)
Message-ID: <9dbbf4e751cb4953fe63079cdc917a0bb3a91670.camel@chronox.de>
Subject: Re: [PATCH v1] crypto: Make the DRBG compliant with NIST SP800-90A
 rev1
From:   Stephan Mueller <smueller@chronox.de>
To:     =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     James Morris <jamorris@linux.microsoft.com>,
        John Haxby <john.haxby@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Simo Sorce <simo@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Date:   Wed, 23 Jun 2021 16:22:38 +0200
In-Reply-To: <20210623120751.3033390-1-mic@digikod.net>
References: <20210623120751.3033390-1-mic@digikod.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, dem 23.06.2021 um 14:07 +0200 schrieb Mickaël Salaün:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> Starting from November 2020, the first revision of NIST SP800-90A (June
> 2015) is required for FIPS 140-2.

Starting from November 7, 2020, SP800-90B is mandated. SP800-90A was always
required since 2015 which sunset the ANSI X9.31 DRNG.


>   One of the changes brought by this
> first revision is that nonces used for seeding (instantiation) and
> re-seeding must come from entropy sources compliant with NIST SP800-90B
> (cf. NIST SP800-90A rev1, section 8.6.7).

Nonces do not need to be derived from SP800-90B entropy sources. The
construction methods 2 through 4 clearly allow a nonce to be derived from a
deterministic source.

>   However, this seeding is
> currently done with the Linux RNG (i.e. in-kernel /dev/urandom) that
> uses ChaCha20, a non-approved algorithm.
> Cf.   
> https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-90Ar1.pdf
> 

I do not think this statement is correct.

With the patches that went into the DRBG in kernel version 5.8, the DRBG
seeding is performed as follows when the kernel is booted in FIPS mode
(fips=1):

- get a buffer of 384 bits from get_random_bytes

- get a buffer of 384 bits from the Jitter RNG

Both buffers are concatenated and used to seed the DRBG.

So, in total, the DRBG receives a buffer of 768 bits.

Assume for your FIPS work that /dev/urandom cannot be claimed to have entropy,
you can only look at the Jitter RNG. This entropy source alone provides 384
bits which *may* be interpreted as follows:

- 256 bits forming the entropy string as mandated by SP800-90A

- 128 bits forming the nonce as mandated by SP800-90A following 8.6.7 bullet 1
with the deviation that it uses a 90B entropy source instead of an approved
random bit generator (a deviation that is allowed according to 8.6.7).

You also may interpret the 384 bits as follows:

- 384 bits as mandated by the current draft from January this year of SP800-
90C mandating that the initial seed is s+128 bits


> These changes replace the use of the Linux RNG with the Jitter RNG,
> which is NIST SP800-90B compliant, to get a proper entropy input and a
> nonce as defined by FIPS.

Can you please help me understand what is missing in the current code which
seemingly already has achieved this goal?
> 
> However, only using the Jitter RNG may not provide adequate security as
> it could be possible for an attacker to know the state of the CPU and
> predict this RNG output.  To avoid this threat, we are making this both
> FIPS compliant and secure thanks to the use of Linux RNG as a random
> source (but not entropy per se) for the personalization string

Why do you need a personalization string beyond the 384 bits coming from
get_random_bytes as mentioned above?

> (instantiation) and the additional input (re-seeding).

Why do you need a personalization string beyond the 384 bits coming from
get_random_bytes as mentioned above?

But maybe this is only a terminology issue where the existing 384 bits drawn
from get_random_bytes are called personalization string / additional info
string.

>   These extra
> inputs have a length equal to the DRBG strength.  The original
> user-supplied personalization string and additional input are still used
> but potentially truncated to fit with the 2**35 limit (cf. NIST
> SP800-90A rev1, table 2 and 3).


> 
> This new DRBG uses the same random and entropy sources as the current
> version but in a way that makes is compliant with FIPS 140-2.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: James Morris <jamorris@linux.microsoft.com>
> Cc: John Haxby <john.haxby@oracle.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Simo Sorce <simo@redhat.com>
> Cc: Stephan Müller <smueller@chronox.de>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
> Link: https://lore.kernel.org/r/20210623120751.3033390-1-mic@digikod.net
> ---
> 
> Do you prefer to truncate the user-supplied personalization string and
> the additional input, or to return an error if they are greater than
> 2**27 (instead of 2**35)?
> 
> Another solution to avoid truncating the personalization string and the
> additional input would be to hash them with SHA-512 and concatenate the
> resulting fixed-size buffers.
> ---
>  crypto/drbg.c         | 77 ++++++++++++++++++++++++++++++++-----------
>  include/crypto/drbg.h |  2 +-
>  2 files changed, 58 insertions(+), 21 deletions(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 1b4587e0ddad..b817a831815e 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1119,9 +1119,10 @@ static int drbg_seed(struct drbg_state *drbg, struct
> drbg_string *pers,
>                      bool reseed)
>  {
>         int ret;
> -       unsigned char entropy[((32 + 16) * 2)];
> -       unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
> -       struct drbg_string data1;
> +       unsigned char entropy[((32 * 2) + 16)];
> +       const unsigned int strength = drbg_sec_strength(drbg->core->flags);
> +       unsigned int entropylen = strength;
> +       struct drbg_string data1, data2;
>         LIST_HEAD(seedlist);
>  
>         /* 9.1 / 9.2 / 9.3.1 step 3 */
> @@ -1147,21 +1148,32 @@ static int drbg_seed(struct drbg_state *drbg, struct
> drbg_string *pers,
>                 BUG_ON(!entropylen);
>                 if (!reseed)
>                         entropylen = ((entropylen + 1) / 2) * 3;
> -               BUG_ON((entropylen * 2) > sizeof(entropy));
> -
> -               /* Get seed from in-kernel /dev/urandom */
> -               ret = drbg_get_random_bytes(drbg, entropy, entropylen);
> -               if (ret)
> -                       goto out;
> +               /*
> +                * Check that a minimal automatic personalization string
> +                * (instantiation) or additional input (re-seeding) of
> strength
> +                * length fits in.
> +                */
> +               BUG_ON((entropylen + strength) > sizeof(entropy));
>  
>                 if (!drbg->jent) {
> -                       drbg_string_fill(&data1, entropy, entropylen);
> -                       pr_devel("DRBG: (re)seeding with %u bytes of
> entropy\n",
> -                                entropylen);
> +                       /*
> +                        * Get entropy, nonce, personalization string or
> +                        * additional input from in-kernel /dev/urandom
> +                        */

If we are in this branch, we will never be using an SP800-90B entropy source
and thus I am not sure changes are warranted.

> +                       ret = drbg_get_random_bytes(drbg, entropy,
> entropylen + strength);



> +                       if (ret)
> +                               goto out;
> +
> +                       drbg_string_fill(&data1, entropy, entropylen +
> strength);
> +                       pr_devel("DRBG: (re)seeding with %u bytes of
> random\n",
> +                                entropylen + strength);
>                 } else {
> -                       /* Get seed from Jitter RNG */
> -                       ret = crypto_rng_get_bytes(drbg->jent,
> -                                                  entropy + entropylen,
> +                       /*
> +                        * Get entropy (strength length), concatenated with
> a
> +                        * nonce (half strength length) when instantiating,
> +                        * both from the SP800-90B compliant Jitter RNG.
> +                        */
> +                       ret = crypto_rng_get_bytes(drbg->jent, entropy,
>                                                    entropylen);

So, here you would get 384 bits from the Jitter RNG.

>                         if (ret) {
>                                 pr_devel("DRBG: jent failed with %d\n",
> ret);
> @@ -1184,9 +1196,25 @@ static int drbg_seed(struct drbg_state *drbg, struct
> drbg_string *pers,
>                                         goto out;
>                         }
>  
> -                       drbg_string_fill(&data1, entropy, entropylen * 2);
> -                       pr_devel("DRBG: (re)seeding with %u bytes of
> entropy\n",
> -                                entropylen * 2);
> +                       /*
> +                        * To improve security while still be compliant with
> +                        * SP800-90A rev1, automatically append a minimal
> +                        * personalization string (instantiation) or
> additional
> +                        * input (re-seeding) of strength length from in-
> kernel
> +                        * /dev/urandom (random source).  This may then
> replace
> +                        * a (small) part of the supplied pers according to
> +                        * drbg_max_addtl().
> +                        */
> +                       ret = drbg_get_random_bytes(drbg, entropy +
> entropylen,
> +                                                   strength);

Here you would get 256 bits from get_random_bytes.

So, compared to the original code, you now just draw 256 bits of data instead
of 384 bits of data.

With these code changes, I fail to see what benefits these changes bring
compared to the existing code.

> +                       if (ret)
> +                               goto out;
> +
> +                       drbg_string_fill(&data1, entropy, entropylen +
> strength);
> +
> +                       pr_devel("DRBG: (re)seeding with %u bytes of entropy
> "
> +                                "and %u bytes of random\n", entropylen,
> +                                strength);
>                 }
>         }
>         list_add_tail(&data1.list, &seedlist);
> @@ -1197,7 +1225,16 @@ static int drbg_seed(struct drbg_state *drbg, struct
> drbg_string *pers,
>          * contents whether it is appropriate
>          */
>         if (pers && pers->buf && 0 < pers->len) {
> -               list_add_tail(&pers->list, &seedlist);
> +               const size_t available = drbg_max_addtl(drbg) - pers->len;

I am uneasy about subtractions without sanity checks and I am not sure what is
the purpose of this work here. Truncating the personalization string here is
wrong IMHO. If there is a need that the personalization string should be
checked for size, the code receiving the personalization string to begin with
should make the check, i.e. drbg_kcapi_seed and drbg_kcapi_random. But a
truncation here is not right as this changes the data provided by the caller.


Thanks
Stephan

> +
> +               data2 = *pers;
> +               /*
> +                * Make sure that the drbg_max_addtl() limit is still
> respected
> +                * according to the automatically appended random values.
> +                */
> +               if (available < strength)
> +                       data2.len -= strength - available;
> +               list_add_tail(&data2.list, &seedlist);
>                 pr_devel("DRBG: using personalization string\n");
>         }
>  
> @@ -1209,7 +1246,7 @@ static int drbg_seed(struct drbg_state *drbg, struct
> drbg_string *pers,
>         ret = __drbg_seed(drbg, &seedlist, reseed);
>  
>  out:
> -       memzero_explicit(entropy, entropylen * 2);
> +       memzero_explicit(entropy, sizeof(entropy));
>  
>         return ret;
>  }
> diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
> index c4165126937e..7fcff8d2289e 100644
> --- a/include/crypto/drbg.h
> +++ b/include/crypto/drbg.h
> @@ -168,7 +168,7 @@ static inline size_t drbg_max_request_bytes(struct
> drbg_state *drbg)
>  
>  static inline size_t drbg_max_addtl(struct drbg_state *drbg)
>  {
> -       /* SP800-90A requires 2**35 bytes additional info str / pers str */
> +       /* SP800-90A requires 2**35 bits of additional info str / pers str
> */
>  #if (__BITS_PER_LONG == 32)
>         /*
>          * SP800-90A allows smaller maximum numbers to be returned -- we
> 
> base-commit: 13311e74253fe64329390df80bed3f07314ddd61


