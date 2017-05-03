From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: BUG: drbg: Added nodes from Stack Memory in link list
Date: Wed, 03 May 2017 15:11:05 +0200
Message-ID: <11088841.2SosuHvOD7@tauon.chronox.de>
References: <CAFXBA=kDqH_32bX8XpUes9bdPP-3Gq5KRGBxu_FXKD3jwgzVdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59430 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751703AbdECNLH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 May 2017 09:11:07 -0400
In-Reply-To: <CAFXBA=kDqH_32bX8XpUes9bdPP-3Gq5KRGBxu_FXKD3jwgzVdQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 3. Mai 2017, 14:47:24 CEST schrieb Harsh Jain:

Hi Harsh,

> Hi Stephen,
> 
> In drbg driver local variable of function are added as list nodes. one
> instance is given below.
> 
> 
> static inline int __init drbg_healthcheck_sanity(void)
> 
> 
> 
> ---
> ---
> 
> max_addtllen = drbg_max_addtl(drbg);
> max_request_bytes = drbg_max_request_bytes(drbg);
> drbg_string_fill(&addtl, buf, max_addtllen + 1);
> /* overflow addtllen with additonal info string */
> len = drbg_generate(drbg, buf, OUTBUFLEN, &addtl);
> 
> ===> Added "addtllist"  to the tail. which local variable.
> 
> 
> BUG_ON(0 < len);
> /* overflow max_bits */
> len = drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
> BUG_ON(0 < len);
> 
> /* overflow max addtllen with personalization string */
> ret = drbg_seed(drbg, &addtl, false);
> 
> ====> Added "seedlist" to the tail of same list. Previous
> node(addtllist) already invalid(Out of scope when function returns)
> 
> 
> BUG_ON(0 == ret);
> /* all tests passed */
> rc = 0;
> 
> 
> 
> Is't a BUG? or I missed something.

:-) You are right that in normal processing this is a bug. But this is a 
special function which shall perform a sanity checks for the maximum length 
enforcement. Thus, addtllist or seedlist should never be filled.

To be precise: The called code is expected to return an error before the 
variables are used due to the length checks. If these errors do not appear, 
something is wrong with the DRBG which causes the BUG_ON.

The following error conditions are triggered:

        /* 9.3.1 step 2 */
        len = -EINVAL;
        if (buflen > (drbg_max_request_bytes(drbg))) {
                pr_devel("DRBG: requested random numbers too large %u\n",
                         buflen);
                goto err;
        }

        /* 9.3.1 step 4 */
        if (addtl && addtl->len > (drbg_max_addtl(drbg))) {
                pr_devel("DRBG: additional information string too long %zu\n",
                         addtl->len);
                goto err;
        }


Ciao
Stephan
