Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99944FA372B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 06:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B78E20854
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 06:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392543AbfJQGNF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 02:13:05 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53390 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390377AbfJQGNF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 02:13:05 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8F22C6C241B7173D4BA4;
        Thu, 17 Oct 2019 14:13:03 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 17 Oct 2019
 14:12:55 +0800
Subject: Re: [PATCH] crypto: zlib-deflate - add zlib-deflate test case in
 tcrypt
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
References: <1570695707-46528-1-git-send-email-wangzhou1@hisilicon.com>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5DA80666.5020504@hisilicon.com>
Date:   Thu, 17 Oct 2019 14:12:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <1570695707-46528-1-git-send-email-wangzhou1@hisilicon.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/10/10 16:21, Zhou Wang wrote:
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
>  	case 100:
>  		ret += tcrypt_test("hmac(md5)");
>  		break;
> 

Any feedback about this patch?

Best,
Zhou

