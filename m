Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD941C433F5
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Dec 2021 03:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhLRD10 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Dec 2021 22:27:26 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58108 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhLRD1Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Dec 2021 22:27:25 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1myQNV-0002cU-8j; Sat, 18 Dec 2021 14:27:22 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 18 Dec 2021 14:27:21 +1100
Date:   Sat, 18 Dec 2021 14:27:21 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com, skozina@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH] crypto: jitter - add oversampling of noise source
Message-ID: <20211218032720.GA11637@gondor.apana.org.au>
References: <2573346.vuYhMxLoTh@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2573346.vuYhMxLoTh@positron.chronox.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 17, 2021 at 10:41:42AM +0100, Stephan Müller wrote:
>
> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> index 2d115bec15ae..b02f93805e83 100644
> --- a/crypto/jitterentropy-kcapi.c
> +++ b/crypto/jitterentropy-kcapi.c
> @@ -59,6 +60,11 @@ void jent_zfree(void *ptr)
>  	kfree_sensitive(ptr);
>  }
>  
> +int jent_fips_enabled(void)
> +{
> +	return fips_enabled;
> +}

Why do you need this function? And why can't it be inlined?

Normally fips_enabled is entirely optimised away if FIPS is
disabled in Kconfig.  This function breaks this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
