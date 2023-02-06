Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D27C05027
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Feb 2023 06:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBFGMY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Feb 2023 01:12:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFGMY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Feb 2023 01:12:24 -0500
X-Greylist: delayed 477 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 05 Feb 2023 22:12:22 PST
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B42C31A9
        for <linux-crypto@vger.kernel.org>; Sun,  5 Feb 2023 22:12:22 -0800 (PST)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 9075172C8D0;
        Mon,  6 Feb 2023 09:04:23 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 8196336D015C;
        Mon,  6 Feb 2023 09:04:23 +0300 (MSK)
Date:   Mon, 6 Feb 2023 09:04:23 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: ecc - Silence sparse warning
Message-ID: <20230206060423.d4o24kcql2hux3j4@altlinux.org>
References: <Y+CH0i0AHpXrw0KX@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Y+CH0i0AHpXrw0KX@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 06, 2023 at 12:53:38PM +0800, Herbert Xu wrote:
> Rewrite the bitwise operations to silence the sparse warnings:
> 
>   CHECK   ../crypto/ecc.c
> ../crypto/ecc.c:1387:39: warning: dubious: !x | y
> ../crypto/ecc.c:1397:47: warning: dubious: !x | y
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 7315217c8f73..f53fb4d6af99 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -1384,7 +1384,8 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
>  
>  	num_bits = max(vli_num_bits(u1, ndigits), vli_num_bits(u2, ndigits));
>  	i = num_bits - 1;
> -	idx = (!!vli_test_bit(u1, i)) | ((!!vli_test_bit(u2, i)) << 1);
> +	idx = !!vli_test_bit(u1, i);
> +	idx |= (!!vli_test_bit(u2, i)) << 1;
>  	point = points[idx];
>  
>  	vli_set(rx, point->x, ndigits);
> @@ -1394,7 +1395,8 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
>  
>  	for (--i; i >= 0; i--) {
>  		ecc_point_double_jacobian(rx, ry, z, curve);
> -		idx = (!!vli_test_bit(u1, i)) | ((!!vli_test_bit(u2, i)) << 1);
> +		idx = !!vli_test_bit(u1, i);
> +		idx |= (!!vli_test_bit(u2, i)) << 1;

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

Thanks,

>  		point = points[idx];
>  		if (point) {
>  			u64 tx[ECC_MAX_DIGITS];
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
