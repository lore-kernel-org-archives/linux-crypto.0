Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB63CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 07:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F02B921D80
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 07:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504559AbfJRHOi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 03:14:38 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37140 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728008AbfJRHOh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 03:14:37 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iLMSz-00038S-Ny; Fri, 18 Oct 2019 18:14:30 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Oct 2019 18:14:24 +1100
Date:   Fri, 18 Oct 2019 18:14:24 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH] crypto: zlib-deflate - add zlib-deflate test case in
 tcrypt
Message-ID: <20191018071424.GA16131@gondor.apana.org.au>
References: <1570695707-46528-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570695707-46528-1-git-send-email-wangzhou1@hisilicon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 10, 2019 at 04:21:47PM +0800, Zhou Wang wrote:
> As a type CRYPTO_ALG_TYPE_ACOMPRESS is needed to trigger crypto acomp test,
> we introduce a new help function tcrypto_test_extend to pass type and mask
> to alg_test.
> 
> Then tcrypto module can be used to do basic acomp test by:
> insmod tcrypto.ko alg="zlib-deflate" mode=55 type=10
> 
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> ---
>  crypto/tcrypt.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 83ad0b1..6ad821c 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -72,7 +72,7 @@ static char *check[] = {
>  	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
>  	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320",
>  	"lzo", "lzo-rle", "cts", "sha3-224", "sha3-256", "sha3-384",
> -	"sha3-512", "streebog256", "streebog512",
> +	"sha3-512", "streebog256", "streebog512", "zlib-deflate",
>  	NULL
>  };
>  
> @@ -1657,6 +1657,19 @@ static inline int tcrypt_test(const char *alg)
>  	return ret;
>  }
>  
> +static inline int tcrypt_test_extend(const char *alg, u32 type, u32 mask)
> +{
> +	int ret;
> +
> +	pr_debug("testing %s\n", alg);
> +
> +	ret = alg_test(alg, alg, type, mask);
> +	/* non-fips algs return -EINVAL in fips mode */
> +	if (fips_enabled && ret == -EINVAL)
> +		ret = 0;
> +	return ret;
> +}
> +
>  static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>  {
>  	int i;
> @@ -1919,6 +1932,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>  		ret += tcrypt_test("streebog512");
>  		break;
>  
> +	case 55:
> +		ret += tcrypt_test_extend("zlib-deflate", type, mask);
> +		break;
> +

Is this really needed? When you do

	modprobe tcrypt alg="zlib-deflate" type=10 mask=15

It should cause zlib-defalte to be registered as acomp and therefore
tested automatically.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
