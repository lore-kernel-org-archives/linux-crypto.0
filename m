Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E48DC48BCF
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 10:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1ADA610C8
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 10:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhFMKQw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:16:52 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:36401 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231236AbhFMKQw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 06:16:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UcDiZh1_1623579286;
Received: from 30.25.254.38(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UcDiZh1_1623579286)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 13 Jun 2021 18:14:48 +0800
Subject: Re: [PATCH 1/3] crypto: sm4 - create SM4 library based on sm4 generic
 code
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20210610134459.28541-1-tianjia.zhang@linux.alibaba.com>
 <20210610134459.28541-2-tianjia.zhang@linux.alibaba.com>
 <YMKeCIfSWZCVX+BT@gmail.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <c8a92826-280c-c79b-c831-485e1da9d0f4@linux.alibaba.com>
Date:   Sun, 13 Jun 2021 18:14:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YMKeCIfSWZCVX+BT@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On 6/11/21 7:19 AM, Eric Biggers wrote:
> On Thu, Jun 10, 2021 at 09:44:57PM +0800, Tianjia Zhang wrote:
>> Take the existing small footprint and mostly time invariant C code
> 
> It is using an S-box without any prefetching.  That doesn't look very
> "time invariant" to me.
> 

Thanks for your suggestion, will do in the next version patch.

>> diff --git a/lib/crypto/sm4.c b/lib/crypto/sm4.c
>> new file mode 100644
>> index 000000000000..cbdd14a254d0
> [..]
>> +/**
>> + * crypto_sm4_expand_key - Expands the SM4 key as described in GB/T 32907-2016
>> + * @ctx:	The location where the computed key will be stored.
>> + * @in_key:	The supplied key.
>> + * @key_len:	The length of the supplied key.
>> + *
>> + * Returns 0 on success. The function fails only if an invalid key size (or
>> + * pointer) is supplied.
>> + */
>> +int crypto_sm4_expand_key(struct crypto_sm4_ctx *ctx, const u8 *in_key,
>> +			  unsigned int key_len)
> [...]
>> +/**
>> + * crypto_sm4_do_crypt - Encrypt or decrypt a single SM4 block
>> + * @rk:		The rkey_enc for encrypt or rkey_dec for decrypt
>> + * @out:	Buffer to store output data
>> + * @in: 	Buffer containing the input data
>> + */
>> +void crypto_sm4_do_crypt(const u32 *rk, u8 *out, const u8 *in)
> 
> Calling these "sm4_expandkey()" and "sm4_crypt_block()" would be more consistent
> with the other lib/crypto/ functions such as the AES ones.  The other
> lib/crypto/ functions don't have a "crypto_" prefix, as that is used for
> functions related to the traditional crypto API rather than the library API.

Ditto. thanks for pointing it out.

> 
> - Eric
> 

Best regards,
Tianjia
