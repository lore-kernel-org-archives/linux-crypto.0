Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E542C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 04:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346075AbiA1EqZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 23:46:25 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60584 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237235AbiA1EqY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 23:46:24 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDJ9Q-00086J-Iy; Fri, 28 Jan 2022 15:46:21 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 15:46:20 +1100
Date:   Fri, 28 Jan 2022 15:46:20 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, Niolai Stange <nstange@suse.com>,
        Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH] crypto: HMAC - disallow keys < 112 bits in FIPS mode
Message-ID: <YfN1HKqL9GT9R25Z@gondor.apana.org.au>
References: <2075651.9o76ZdvQCi@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2075651.9o76ZdvQCi@positron.chronox.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 07, 2022 at 08:25:24PM +0100, Stephan Müller wrote:
>
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index a253d66ba1c1..1c39d294b9ba 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -5706,6 +5706,7 @@ static const struct hash_testvec hmac_sha1_tv_template[] = {
>  		.digest	= "\xb6\x17\x31\x86\x55\x05\x72\x64"
>  			  "\xe2\x8b\xc0\xb6\xfb\x37\x8c\x8e\xf1"
>  			  "\x46\xbe",
> +#ifndef CONFIG_CRYPTO_FIPS
>  	}, {
>  		.key	= "Jefe",
>  		.ksize	= 4,

Please don't use ifdefs, you can instead add a fips_skip setting
just like we do for cipher test vectors.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
