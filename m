Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE66CA9EA5
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 04:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71E962089C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 04:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbfJUEAK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 00:00:10 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58718 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725290AbfJUEAK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 00:00:10 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DBD4A99854E7AD08D5C5;
        Mon, 21 Oct 2019 12:00:08 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Mon, 21 Oct 2019
 12:00:01 +0800
Subject: Re: [PATCH] crypto: zlib-deflate - add zlib-deflate test case in
 tcrypt
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1570695707-46528-1-git-send-email-wangzhou1@hisilicon.com>
 <20191018071424.GA16131@gondor.apana.org.au>
CC:     "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5DAD2D40.6000901@hisilicon.com>
Date:   Mon, 21 Oct 2019 12:00:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20191018071424.GA16131@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/10/18 15:14, Herbert Xu wrote:
> On Thu, Oct 10, 2019 at 04:21:47PM +0800, Zhou Wang wrote:
>> As a type CRYPTO_ALG_TYPE_ACOMPRESS is needed to trigger crypto acomp test,
>> we introduce a new help function tcrypto_test_extend to pass type and mask
>> to alg_test.
>>
>> Then tcrypto module can be used to do basic acomp test by:
>> insmod tcrypto.ko alg="zlib-deflate" mode=55 type=10
>>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
>> ---
>>  crypto/tcrypt.c | 19 ++++++++++++++++++-
>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
>> index 83ad0b1..6ad821c 100644
>> --- a/crypto/tcrypt.c
>> +++ b/crypto/tcrypt.c
>> @@ -72,7 +72,7 @@ static char *check[] = {
>>  	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
>>  	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320",
>>  	"lzo", "lzo-rle", "cts", "sha3-224", "sha3-256", "sha3-384",
>> -	"sha3-512", "streebog256", "streebog512",
>> +	"sha3-512", "streebog256", "streebog512", "zlib-deflate",
>>  	NULL
>>  };
>>  
>> @@ -1657,6 +1657,19 @@ static inline int tcrypt_test(const char *alg)
>>  	return ret;
>>  }
>>  
>> +static inline int tcrypt_test_extend(const char *alg, u32 type, u32 mask)
>> +{
>> +	int ret;
>> +
>> +	pr_debug("testing %s\n", alg);
>> +
>> +	ret = alg_test(alg, alg, type, mask);
>> +	/* non-fips algs return -EINVAL in fips mode */
>> +	if (fips_enabled && ret == -EINVAL)
>> +		ret = 0;
>> +	return ret;
>> +}
>> +
>>  static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>>  {
>>  	int i;
>> @@ -1919,6 +1932,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
>>  		ret += tcrypt_test("streebog512");
>>  		break;
>>  
>> +	case 55:
>> +		ret += tcrypt_test_extend("zlib-deflate", type, mask);
>> +		break;
>> +
> 
> Is this really needed? When you do
> 
> 	modprobe tcrypt alg="zlib-deflate" type=10 mask=15
> 
> It should cause zlib-defalte to be registered as acomp and therefore
> tested automatically.

seems it can not work, when I run insmod tcrypt.ko alg="zlib-deflate" type=10 mask=15
I got: insmod: can't insert 'tcrypt.ko': Resource temporarily unavailable

crypto_has_alg in case 0 in do_test does find "zlib-deflate", however, it breaks and
do nothing about test.

Best,
Zhou

> 
> Cheers,
> 

