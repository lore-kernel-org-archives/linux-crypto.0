Return-Path: <SRS0=Hyrp=2W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946C9C2D0DC
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 16:11:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BFF1206E0
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 16:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgAAQLU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jan 2020 11:11:20 -0500
Received: from smtp1.axis.com ([195.60.68.17]:45671 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgAAQLU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jan 2020 11:11:20 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jan 2020 11:11:19 EST
IronPort-SDR: YEEhK42/YbuluWs+Jjepz5/MEJ0+enUOx0WS7HmCDZiTeUPqq3w2nyleqItQH0pigLpaOyEoPQ
 qteIZ4e4K+CewF1MwTKi3/6PKuOD7Pe7oOHhAnc9ESa5dJo3NLrT/AzKdlnl8O44O0vxgiakoL
 JH5ydXVc+4X32vh+zFWngxU848CwvrC3C2O7l2+VFZMrR8KeabiDlViOjYNn6mVQ55c9h4exYK
 IAFY9CHVCcLQ8cGsFBM8rdiHfYfiSxDKqH6H1DcHOQyJJn6UFLkb43RB0uLmGxd3lw6SyCuje5
 w/0=
X-IronPort-AV: E=Sophos;i="5.69,382,1571695200"; 
   d="scan'208";a="4003356"
Subject: Re: [PATCH 2/8] crypto: artpec6 - return correct error code for
 failed setkey()
To:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC:     Jesper Nilsson <Jesper.Nilsson@axis.com>
References: <20191231031938.241705-1-ebiggers@kernel.org>
 <20191231031938.241705-3-ebiggers@kernel.org>
 <20191231044352.GB180988@zzz.localdomain>
From:   Lars Persson <lars.persson@axis.com>
Message-ID: <28732831-36b0-659c-b65a-042232a9ff7f@axis.com>
Date:   Wed, 1 Jan 2020 17:04:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191231044352.GB180988@zzz.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.0.5.60]
X-ClientProxiedBy: XBOX02.axis.com (10.0.5.16) To xbox06.axis.com
 (10.0.15.176)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/31/19 5:43 AM, Eric Biggers wrote:
> [+Cc the people with Cc tags in the patch, who I accidentally didn't Cc...
>   Original message was
> https://lkml.kernel.org/linux-crypto/20191231031938.241705-3-ebiggers@kernel.org/]
> 
> On Mon, Dec 30, 2019 at 09:19:32PM -0600, Eric Biggers wrote:
>> From: Eric Biggers <ebiggers@google.com>
>> 
>> ->setkey() is supposed to retun -EINVAL for invalid key lengths, not -1.
>> 
>> Fixes: a21eb94fc4d3 ("crypto: axis - add ARTPEC-6/7 crypto accelerator driver")
>> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
>> Cc: Lars Persson <lars.persson@axis.com>
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
>> ---
>>  drivers/crypto/axis/artpec6_crypto.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
>> index 4b20606983a4..22ebe40f09f5 100644
>> --- a/drivers/crypto/axis/artpec6_crypto.c
>> +++ b/drivers/crypto/axis/artpec6_crypto.c
>> @@ -1251,7 +1251,7 @@ static int artpec6_crypto_aead_set_key(struct crypto_aead *tfm, const u8 *key,
>>  
>>        if (len != 16 && len != 24 && len != 32) {
>>                crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
>> -             return -1;
>> +             return -EINVAL;
>>        }
>>  
>>        ctx->key_length = len;
>> -- 
>> 2.24.1
>> 

Acked-by: Lars Persson <lars.persson@axis.com>

Thanks,
  Lars
