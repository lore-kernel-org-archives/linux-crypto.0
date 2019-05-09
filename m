Return-Path: <SRS0=8ziv=TJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859A9C004C9
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 03:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5287F216C4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 May 2019 03:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfEIDNG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 May 2019 23:13:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:58298 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbfEIDNF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 May 2019 23:13:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9430EAD70;
        Thu,  9 May 2019 03:13:03 +0000 (UTC)
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
To:     Eric Biggers <ebiggers@kernel.org>,
        Kees Cook <keescook@chromium.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
 <20190509020439.GB693@sol.localdomain>
From:   Joao Moreira <jmoreira@suse.de>
Message-ID: <8c9a53b9-12e6-3380-21c8-4fe85342f0ac@suse.de>
Date:   Thu, 9 May 2019 00:12:54 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190509020439.GB693@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 5/8/19 11:04 PM, Eric Biggers wrote:
> On Wed, May 08, 2019 at 02:08:25PM -0700, Kees Cook wrote:
>> On Wed, May 8, 2019 at 6:36 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>> On Tue, May 07, 2019 at 02:50:46PM -0700, Eric Biggers wrote:
>>>>
>>>> I don't know yet.  It's difficult to read the code with 2 layers of macros.
>>>>
>>>> Hence why I asked why you didn't just change the prototypes to be compatible.
>>>
>>> I agree.  Kees, since you're changing this anyway please make it
>>> look better not worse.
>>
>> Do you mean I should use the typedefs in the new macros? I'm not aware
>> of a way to use a typedef to declare a function body, so I had to
>> repeat them. I'm open to suggestions!
>>
>> As far as "fixing the prototypes", the API is agnostic of the context
>> type, and uses void *. And also it provides a way to call the same
>> function with different pointer types on the other arguments:
>>
>> For example, quoting the existing code:
>>
>> asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
>>                                  const u8 *src);
>>
>> Which is used for ecb and cbc:
>>
>> #define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
>> #define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
>> ...
>> static const struct common_glue_ctx twofish_dec = {
>> ...
>>                  .fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
>>
>> static const struct common_glue_ctx twofish_dec_cbc = {
>> ...
>>                  .fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
>>
>> which have different prototypes:
>>
>> typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
>> typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
>> ...
>> struct common_glue_func_entry {
>>          unsigned int num_blocks; /* number of blocks that @fn will process */
>>          union {
>>                  common_glue_func_t ecb;
>>                  common_glue_cbc_func_t cbc;
>>                  common_glue_ctr_func_t ctr;
>>                  common_glue_xts_func_t xts;
>>          } fn_u;
>> };
>>
> 
> As Herbert said, the ctx parameters could be made 'void *'.
> 

This is how things were done in the original patch set, but some 
concerns were raised about this approach:

https://lkml.org/lkml/2018/4/16/74

Tks,
Joao.

> And I also asked whether indirect calls to asm code are even allowed with CFI.
> IIRC, the AOSP kernels have been patched to remove them from arm64.  It would be
> helpful if you would answer that question, since it would inform the best
> approach here.
> 
> As for the "ecb" functions taking 'u8 *' but the "cbc" ones taking 'u128 *' and
> the same function being used in the blocks==1 case, you could just pick one of
> the types to use for both.  'u8 *' probably makes more sense since both ecb and
> cbc operate on blocks of 16 bytes but don't interpret them as 128-bit integers.
> 
> - Eric
> 
