Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEE5C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Dec 2021 12:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhLQMGM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Dec 2021 07:06:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235463AbhLQMGM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Dec 2021 07:06:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639742771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MVxgmMsRz4NmU/EAVpnzYTt5n2ZMJnwo1hWCgzIukDg=;
        b=GP+yjaFgdhln0zQ3ffTvBs+34YVy8J5hJGU4jWcFMMNjX8ojtfhg4vyE4j/rC6wlTFMcAQ
        7VYSnfB75K8DqWUyh11pbUFE0+3GPPHFiw2CRhwEOrZhiTmy/+a5+9mus7qMUTaZkFtxbE
        tknh+oPFq9eJsUAynnmr4p1W28RlyKA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-oWiANUXZOKGmsMDiQ_l3PQ-1; Fri, 17 Dec 2021 07:06:10 -0500
X-MC-Unique: oWiANUXZOKGmsMDiQ_l3PQ-1
Received: by mail-ed1-f71.google.com with SMTP id b15-20020aa7c6cf000000b003e7cf0f73daso1706619eds.22
        for <linux-crypto@vger.kernel.org>; Fri, 17 Dec 2021 04:06:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=MVxgmMsRz4NmU/EAVpnzYTt5n2ZMJnwo1hWCgzIukDg=;
        b=cdv6sfk5uke0Pi+RQQyyvWOaTYqMwYLubOeZf+gwCeDerZlii694dacigbA/Pu/SbE
         dCVym0R7t3QxMtWY/oCjYQxrmNIcTnPDyiEIdt3pm0nVSkWR29jMj7ArxgKPfReQvSbR
         O6yyC2L/zprYQ9Q1omF5+XXYyjOIHk56VpX9CCxZ503polsZZWWmyOtt1RBF7Ec3Q4gi
         9CuTsqXZ0DsC2Vh39bEUuX0Qql6ouijt14IL6c9vIVQDGgj1gIuTnfJurDHfjekH3DrA
         wjrm8NLBS1JdEgwuFXFh4urWalauITlUS9MVReBM5P988FmGm3U9bI6TmRaFEGLMEAgU
         2cSw==
X-Gm-Message-State: AOAM530ZpmdNGhlojr5zQxECjh+VAKHfCEPLuPmtUnrffrzn+ibwveAm
        4iwxRtyjGSRfLZEMwac1+Z3g+pw1BHVOeo7b9gJpZ3xGVg7ypS/+b+eBuES+lTpuRXz57QqCqOJ
        TvIuy7fw1KJTyqV2ht8yVA84Z
X-Received: by 2002:a50:ab41:: with SMTP id t1mr2602738edc.389.1639742769093;
        Fri, 17 Dec 2021 04:06:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxLleIFBHRA3eJcXNMU1GMhzoVadOTVqSNq/I0CUmowzvul1NrmgktuANyy8Yds49ZI8o+zA==
X-Received: by 2002:a50:ab41:: with SMTP id t1mr2602716edc.389.1639742768785;
        Fri, 17 Dec 2021 04:06:08 -0800 (PST)
Received: from m8.users.ipa.redhat.com ([93.56.162.162])
        by smtp.gmail.com with ESMTPSA id sc3sm207713ejc.93.2021.12.17.04.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 04:06:08 -0800 (PST)
Message-ID: <ee13fe8c757a419f0f4c6b60419afb1b63003f2f.camel@redhat.com>
Subject: Re: [PATCH] crypto: jitter - add oversampling of noise source
From:   Simo Sorce <simo@redhat.com>
To:     Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, skozina@redhat.com,
        Nicolai Stange <nstange@suse.de>
Date:   Fri, 17 Dec 2021 07:06:07 -0500
In-Reply-To: <2573346.vuYhMxLoTh@positron.chronox.de>
References: <2573346.vuYhMxLoTh@positron.chronox.de>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Stephan,
one comment inline.

On Fri, 2021-12-17 at 10:41 +0100, Stephan Müller wrote:
> The output n bits can receive more than n bits of min entropy, of course,
> but the fixed output of the conditioning function can only asymptotically
> approach the output size bits of min entropy, not attain that bound.
> Random maps will tend to have output collisions, which reduces the
> creditable output entropy (that is what SP 800-90B Section 3.1.5.1.2
> attempts to bound).
> 
> The value "64" is justified in Appendix A.4 of the current 90C draft,
> and aligns with NIST's in "epsilon" definition in this document, which is
> that a string can be considered "full entropy" if you can bound the min
> entropy in each bit of output to at least 1-epsilon, where epsilon is
> required to be <= 2^(-32).
> 
> Note, this patch causes the Jitter RNG to cut its performance in half in
> FIPS mode because the conditioning function of the LFSR produces 64 bits
> of entropy in one block. The oversampling requires that additionally 64
> bits of entropy are sampled from the noise source. If the conditioner is
> changed, such as using SHA-256, the impact of the oversampling is only
> one fourth, because for the 256 bit block of the conditioner, only 64
> additional bits from the noise source must be sampled.
> 
> This patch resurrects the function jent_fips_enabled as the oversampling
> support is only enabled in FIPS mode.
> 
> This patch is derived from the user space jitterentropy-library.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/jitterentropy-kcapi.c |  6 ++++++
>  crypto/jitterentropy.c       | 22 ++++++++++++++++++++--
>  crypto/jitterentropy.h       |  1 +
>  3 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> index 2d115bec15ae..b02f93805e83 100644
> --- a/crypto/jitterentropy-kcapi.c
> +++ b/crypto/jitterentropy-kcapi.c
> @@ -37,6 +37,7 @@
>   * DAMAGE.
>   */
>  
> +#include <linux/fips.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> @@ -59,6 +60,11 @@ void jent_zfree(void *ptr)
>  	kfree_sensitive(ptr);
>  }
>  
> +int jent_fips_enabled(void)
> +{
> +	return fips_enabled;
> +}
> +
>  void jent_panic(char *s)
>  {
>  	panic("%s", s);
> diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
> index 8f5283f28ed3..9996120ad23c 100644
> --- a/crypto/jitterentropy.c
> +++ b/crypto/jitterentropy.c
> @@ -117,6 +117,21 @@ struct rand_data {
>  #define JENT_EHEALTH		9 /* Health test failed during initialization */
>  #define JENT_ERCT		10 /* RCT failed during initialization */
>  
> +/*
> + * The output n bits can receive more than n bits of min entropy, of course,
> + * but the fixed output of the conditioning function can only asymptotically
> + * approach the output size bits of min entropy, not attain that bound. Random
> + * maps will tend to have output collisions, which reduces the creditable
> + * output entropy (that is what SP 800-90B Section 3.1.5.1.2 attempts to bound).
> + *
> + * The value "64" is justified in Appendix A.4 of the current 90C draft,
> + * and aligns with NIST's in "epsilon" definition in this document, which is
> + * that a string can be considered "full entropy" if you can bound the min
> + * entropy in each bit of output to at least 1-epsilon, where epsilon is
> + * required to be <= 2^(-32).
> + */
> +#define JENT_ENTROPY_SAFETY_FACTOR	64
> +
>  #include "jitterentropy.h"
>  
>  /***************************************************************************
> @@ -542,7 +557,10 @@ static int jent_measure_jitter(struct rand_data *ec)
>   */
>  static void jent_gen_entropy(struct rand_data *ec)
>  {
> -	unsigned int k = 0;
> +	unsigned int k = 0, safety_factor = JENT_ENTROPY_SAFETY_FACTOR;
> +
> +	if (!jent_fips_enabled())
> +		safety_factor = 0;

I would find this more readable if safety_factor is initialized to 0,
and then in the code:
	if (jent_fips_enabled())
		safety_factor = JENT_ENTROPY_SAFETY_FACTOR;

However this is just readability for me, either option is perfectly
identicaly IMO, so

Reviewed-by: Simo Sorce <simo@redhat.com>


>  	/* priming of the ->prev_time value */
>  	jent_measure_jitter(ec);
> @@ -556,7 +574,7 @@ static void jent_gen_entropy(struct rand_data *ec)
>  		 * We multiply the loop value with ->osr to obtain the
>  		 * oversampling rate requested by the caller
>  		 */
> -		if (++k >= (DATA_SIZE_BITS * ec->osr))
> +		if (++k >= ((DATA_SIZE_BITS + safety_factor) * ec->osr))
>  			break;
>  	}
>  }
> diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
> index b7397b617ef0..c83fff32d130 100644
> --- a/crypto/jitterentropy.h
> +++ b/crypto/jitterentropy.h
> @@ -2,6 +2,7 @@
>  
>  extern void *jent_zalloc(unsigned int len);
>  extern void jent_zfree(void *ptr);
> +extern int jent_fips_enabled(void);
>  extern void jent_panic(char *s);
>  extern void jent_memcpy(void *dest, const void *src, unsigned int n);
>  extern void jent_get_nstime(__u64 *out);

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




