Return-Path: <SRS0=LfhG=TD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06BD0C43219
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 01:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5C06206C3
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 01:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfECBmo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 May 2019 21:42:44 -0400
Received: from [5.180.42.13] ([5.180.42.13]:35788 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbfECBmo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 May 2019 21:42:44 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hMNDn-0003tx-71; Fri, 03 May 2019 09:42:43 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hMNDl-0007pO-J8; Fri, 03 May 2019 09:42:41 +0800
Date:   Fri, 3 May 2019 09:42:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] crypto: DRBG - add FIPS 140-2 CTRNG for noise source
Message-ID: <20190503014241.cy35pjinezhapga7@gondor.apana.org.au>
References: <1852500.fyBc0DU23F@positron.chronox.de>
 <20190502124811.l4yozv4llqtdvozx@gondor.apana.org.au>
 <10683686.8DmOGYbKhJ@positron.chronox.de>
 <5352150.0CmBXKFm2E@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5352150.0CmBXKFm2E@positron.chronox.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 02, 2019 at 06:38:12PM +0200, Stephan Müller wrote:
> +static int drbg_fips_continuous_test(struct drbg_state *drbg,
> +				     const unsigned char *entropy)
> +{
> +#if IS_ENABLED(CONFIG_CRYPTO_FIPS)

This should look like

	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
		...
	} else {
		...
	}

This way the compiler will see everything regardless of whether
FIPS is enabled or not.

> diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
> index 3fb581bf3b87..939051480c83 100644
> --- a/include/crypto/drbg.h
> +++ b/include/crypto/drbg.h
> @@ -129,6 +129,10 @@ struct drbg_state {
>  
>  	bool seeded;		/* DRBG fully seeded? */
>  	bool pr;		/* Prediction resistance enabled? */
> +#if IS_ENABLED(CONFIG_CRYPTO_FIPS)
> +	bool fips_primed;	/* Continuous test primed? */
> +	unsigned char *prev;	/* FIPS 140-2 continuous test value */
> +#endif

You can still use #ifdef here.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
