Return-Path: <SRS0=C5lZ=DN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3872DC4363D
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 13:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB98A207EA
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 13:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgJFNqc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Oct 2020 09:46:32 -0400
Received: from foss.arm.com ([217.140.110.172]:47872 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgJFNqc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Oct 2020 09:46:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B85C6143D;
        Tue,  6 Oct 2020 06:46:31 -0700 (PDT)
Received: from [192.168.122.166] (unknown [10.119.48.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 38BF03F71F;
        Tue,  6 Oct 2020 06:46:31 -0700 (PDT)
Subject: Re: [BUG][PATCH] crypto: arm64: Avoid indirect branch to bti_c
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
Cc:     herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        davem@davemloft.net, broonie@kernel.org,
        linux-crypto@vger.kernel.org, Will Deacon <will@kernel.org>,
        ardb@kernel.org, linux-arm-kernel@lists.infradead.org
References: <20201006034854.2277538-1-jeremy.linton@arm.com>
 <20201006082748.GB25305@willie-the-truck> <20201006100121.GW6642@arm.com>
 <20201006102507.GA19213@gaia> <20201006104313.GX6642@arm.com>
 <20201006123350.GB19213@gaia>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <877e948c-2903-5537-05a6-654f4753407c@arm.com>
Date:   Tue, 6 Oct 2020 08:45:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201006123350.GB19213@gaia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 10/6/20 7:33 AM, Catalin Marinas wrote:
> On Tue, Oct 06, 2020 at 11:43:14AM +0100, Dave P Martin wrote:
>> On Tue, Oct 06, 2020 at 11:25:11AM +0100, Catalin Marinas wrote:
>>> On Tue, Oct 06, 2020 at 11:01:21AM +0100, Dave P Martin wrote:
>>>> On Tue, Oct 06, 2020 at 09:27:48AM +0100, Will Deacon wrote:
>>>>> On Mon, Oct 05, 2020 at 10:48:54PM -0500, Jeremy Linton wrote:
>>>>>> The AES code uses a 'br x7' as part of a function called by
>>>>>> a macro. That branch needs a bti_j as a target. This results
>>>>>> in a panic as seen below. Instead of trying to replace the branch
>>>>>> target with a bti_jc, lets replace the indirect branch with a
>>>>>> bl/ret, bl sequence that can target the existing bti_c.
>>>>>>
>>>>>>    Bad mode in Synchronous Abort handler detected on CPU1, code 0x34000003 -- BTI
>>>>>>    CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
>>>>>>    pstate: 20400c05 (nzCv daif +PAN -UAO BTYPE=j-)
>>>>>>    pc : aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
>>>>>>    lr : aesbs_xts_encrypt+0x48/0xe0 [aes_neon_bs]
>>>>>>    sp : ffff80001052b730
>>>>>>
>>>>>>    aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
>>>>>>     __xts_crypt+0xb0/0x2dc [aes_neon_bs]
>>>>>>     xts_encrypt+0x28/0x3c [aes_neon_bs]
>>>>>>    crypto_skcipher_encrypt+0x50/0x84
>>>>>>    simd_skcipher_encrypt+0xc8/0xe0
>>>>>>    crypto_skcipher_encrypt+0x50/0x84
>>>>>>    test_skcipher_vec_cfg+0x224/0x5f0
>>>>>>    test_skcipher+0xbc/0x120
>>>>>>    alg_test_skcipher+0xa0/0x1b0
>>>>>>    alg_test+0x3dc/0x47c
>>>>>>    cryptomgr_test+0x38/0x60
>>>>>>
>>>>>> Fixes: commit 0e89640b640d ("crypto: arm64 - Use modern annotations for assembly functions")
>>>>>
>>>>> nit: the "commit" string shouldn't be here, and I think the linux-next
>>>>> scripts will yell at us if we don't remove it.
>>>>>
>>>>>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>>>>>> ---
>>>>>>   arch/arm64/crypto/aes-neonbs-core.S | 6 +++---
>>>>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
>>>>>> index b357164379f6..32f53ebe5e2c 100644
>>>>>> --- a/arch/arm64/crypto/aes-neonbs-core.S
>>>>>> +++ b/arch/arm64/crypto/aes-neonbs-core.S
>>>>>> @@ -788,7 +788,7 @@ SYM_FUNC_START_LOCAL(__xts_crypt8)
>>>>>>   
>>>>>>   0:	mov		bskey, x21
>>>>>>   	mov		rounds, x22
>>>>>> -	br		x7
>>>>>> +	ret
>>>>
>>>> Dang, replied on an old version.
>>>
>>> Which I ignored (by default, when the kbuild test robot complains ;)).
>>>
>>>> Since this is logically a tail call, could we simply be using br x16 or
>>>> br x17 for this?
>>>>
>>>> The architecture makes special provision for that so that the compiler
>>>> can generate tail-calls.
>>>
>>> So a "br x16" is compatible with a bti_c landing pad. I think it makes
>>> more sense to keep it as a tail call.
>>
>> Just to be clear, I'm happy either way, but I thought it would make
>> sense to point this out.
> 
> I'd prefer the replacement with a br x16/17, it keeps the code pretty
> much unchanged.
> 
> Jeremy, could you please respin this patch and give it a try?

Sounds like a plan.

I'm probably going to change the subject again, guess I will put a v3 on 
it too. :)



