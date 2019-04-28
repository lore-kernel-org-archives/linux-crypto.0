Return-Path: <SRS0=IEBh=S6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B589C43218
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 08:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C87742075D
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Apr 2019 08:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfD1IQU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Apr 2019 04:16:20 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44898 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726369AbfD1IQU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Apr 2019 04:16:20 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 26C2E8F0C0F182CB1608;
        Sun, 28 Apr 2019 16:16:17 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Sun, 28 Apr 2019
 16:16:02 +0800
Subject: Re: [PATCH -next] crypto: ccree - remove set but not used variable
 'du_size'
To:     Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190426151821.36944-1-yuehaibing@huawei.com>
 <CAOtvUMesBDrnMd=d5S50xj0W2PyYbb9E9SeYvaev4Dw7Uu_tHg@mail.gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <7ecc05f9-952f-e036-7d85-6c651bf2a888@huawei.com>
Date:   Sun, 28 Apr 2019 16:16:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CAOtvUMesBDrnMd=d5S50xj0W2PyYbb9E9SeYvaev4Dw7Uu_tHg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/4/28 15:58, Gilad Ben-Yossef wrote:
> On Fri, Apr 26, 2019 at 7:38 PM Yue Haibing <yuehaibing@huawei.com> wrote:
>>
>> From: YueHaibing <yuehaibing@huawei.com>
>>
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> drivers/crypto/ccree/cc_cipher.c: In function cc_setup_key_desc:
>> drivers/crypto/ccree/cc_cipher.c:645:15: warning: variable du_size set but not used [-Wunused-but-set-variable]
>>
>> It is never used since introduction in
>> commit dd8486c75085 ("crypto: ccree - move key load desc. before flow desc.")
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/crypto/ccree/cc_cipher.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
>> index d9f8cd5..6bd3791 100644
>> --- a/drivers/crypto/ccree/cc_cipher.c
>> +++ b/drivers/crypto/ccree/cc_cipher.c
>> @@ -642,16 +642,12 @@ static void cc_setup_key_desc(struct crypto_tfm *tfm,
>>         int direction = req_ctx->gen_ctx.op_type;
>>         dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
>>         unsigned int key_len = ctx_p->keylen;
>> -       unsigned int du_size = nbytes;
>>         unsigned int din_size;
>>
>>         struct cc_crypto_alg *cc_alg =
>>                 container_of(tfm->__crt_alg, struct cc_crypto_alg,
>>                              skcipher_alg.base);
>>
>> -       if (cc_alg->data_unit)
>> -               du_size = cc_alg->data_unit;
> 
> Thanks!
> This is a good catch. It seems we can also drop the whole cc_alg var
> as well in this case,
> since it is only used by the code setting du_size....
> 
> Do you want to send a patch doing both or shall I ?

Yes, will send v2, thanks!
> 
> Cheers,
> Gilad
> 

