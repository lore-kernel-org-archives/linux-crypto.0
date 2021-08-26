Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A903AC432BE
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Aug 2021 06:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B60A60F14
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Aug 2021 06:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbhHZG0f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Aug 2021 02:26:35 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:19295 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238082AbhHZG0f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Aug 2021 02:26:35 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Um2LScI_1629959145;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Um2LScI_1629959145)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 26 Aug 2021 14:25:46 +0800
Subject: Re: [PATCH] crypto: sm4 - Do not change section of ck and sbox
To:     Nathan Chancellor <nathan@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, llvm@lists.linux.dev
References: <20210825203859.416449-1-nathan@kernel.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <fc2a8a94-eb2f-31ee-411b-527ef0d25d31@linux.alibaba.com>
Date:   Thu, 26 Aug 2021 14:25:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210825203859.416449-1-nathan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Nathan,

Thanks for pointing it out.

On 8/26/21 4:38 AM, Nathan Chancellor wrote:
> When building with clang and GNU as, there is a warning about ignored
> changed section attributes:
> 
> /tmp/sm4-c916c8.s: Assembler messages:
> /tmp/sm4-c916c8.s:677: Warning: ignoring changed section attributes for
> .data..cacheline_aligned
> 
> "static const" places the data in .rodata but __cacheline_aligned has
> the section attribute to place it in .data..cacheline_aligned, in
> addition to the aligned attribute.
> 
> To keep the alignment but avoid attempting to change sections, use the
> ____cacheline_aligned attribute, which is just the aligned attribute.
> 
> Fixes: 2b31277af577 ("crypto: sm4 - create SM4 library based on sm4 generic code")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1441
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>


Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Best regards,
Tianjia

> ---
>   lib/crypto/sm4.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/crypto/sm4.c b/lib/crypto/sm4.c
> index 633b59fed9db..284e62576d0c 100644
> --- a/lib/crypto/sm4.c
> +++ b/lib/crypto/sm4.c
> @@ -15,7 +15,7 @@ static const u32 fk[4] = {
>   	0xa3b1bac6, 0x56aa3350, 0x677d9197, 0xb27022dc
>   };
>   
> -static const u32 __cacheline_aligned ck[32] = {
> +static const u32 ____cacheline_aligned ck[32] = {
>   	0x00070e15, 0x1c232a31, 0x383f464d, 0x545b6269,
>   	0x70777e85, 0x8c939aa1, 0xa8afb6bd, 0xc4cbd2d9,
>   	0xe0e7eef5, 0xfc030a11, 0x181f262d, 0x343b4249,
> @@ -26,7 +26,7 @@ static const u32 __cacheline_aligned ck[32] = {
>   	0x10171e25, 0x2c333a41, 0x484f565d, 0x646b7279
>   };
>   
> -static const u8 __cacheline_aligned sbox[256] = {
> +static const u8 ____cacheline_aligned sbox[256] = {
>   	0xd6, 0x90, 0xe9, 0xfe, 0xcc, 0xe1, 0x3d, 0xb7,
>   	0x16, 0xb6, 0x14, 0xc2, 0x28, 0xfb, 0x2c, 0x05,
>   	0x2b, 0x67, 0x9a, 0x76, 0x2a, 0xbe, 0x04, 0xc3,
> 
> base-commit: abfc7fad63940b8dfdfd25da6f0fa813d9561645
> 
