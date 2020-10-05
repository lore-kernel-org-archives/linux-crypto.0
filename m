Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D71C4363A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 20:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBCE921481
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 20:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbgJEUKo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 16:10:44 -0400
Received: from foss.arm.com ([217.140.110.172]:57274 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729424AbgJEUKo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 16:10:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56E6E1435;
        Mon,  5 Oct 2020 13:10:43 -0700 (PDT)
Received: from [192.168.122.166] (unknown [10.119.48.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4FD03F70D;
        Mon,  5 Oct 2020 13:10:42 -0700 (PDT)
Subject: Re: [BUG][PATCH] arm64: bti: fix BTI to handle local indirect
 branches
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        ardb@kernel.org, will@kernel.org, catalin.marinas@arm.com,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org
References: <20201005181804.1331237-1-jeremy.linton@arm.com>
 <20201005195957.GF5139@sirena.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <c554e7cb-2773-a49f-a126-fdc56be029ca@arm.com>
Date:   Mon, 5 Oct 2020 15:10:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201005195957.GF5139@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,


On 10/5/20 2:59 PM, Mark Brown wrote:
> On Mon, Oct 05, 2020 at 01:18:04PM -0500, Jeremy Linton wrote:
> 
>> The AES code uses a 'br x7' as part of a function called by
>> a macro, that ends up needing a BTI_J as a target. Lets
>> define SYN_CODE_START_LOCAL() for this and replace the
>> SYM_FUNC_START_LOCAL with a SYM_FUNC_CODE_LOCAL in the AES block.
> 
> Really what the subject here should say is that this code is not a
> standard function and therefore should not be annotated as such - it's
> wrong with or without BTI, BTI just makes it very apparent.  It'd also
> be better to split the change in linkage.h out into a separate patch,
> that'd make things clearer for review.
> 
>>    CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
>>    pstate: 20400c05 (nzCv daif +PAN -UAO BTYPE=j-)
>>    pc : aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
>>    lr : aesbs_xts_encrypt+0x48/0xe0 [aes_neon_bs]
>>    sp : ffff80001052b730
>>    x29: ffff80001052b730 x28: 0000000000000001
>>    x27: ffff0001ec8f4000 x26: ffff0001ec5d27b0
> 
> Please think hard before including complete backtraces in upstream
> reports, they are very large and contain almost no useful information
> relative to their size so often obscure the relevant content in your
> message. If part of the backtrace is usefully illustrative (it often is
> for search engines if nothing else) then it's usually better to pull out
> the relevant sections.
> 
>> -SYM_FUNC_START_LOCAL(aesbs_encrypt8)
>> +SYM_CODE_START_LOCAL(aesbs_encrypt8)
>>   	ldr		q9, [bskey], #16		// round 0 key
>>   	ldr		q8, M0SR
>>   	ldr		q24, SR
>> @@ -488,10 +488,10 @@ SYM_FUNC_START_LOCAL(aesbs_encrypt8)
>>   	eor		v2.16b, v2.16b, v12.16b
>>   	eor		v5.16b, v5.16b, v12.16b
>>   	ret
>> -SYM_FUNC_END(aesbs_encrypt8)
>> +SYM_END(aesbs_encrypt8)
> 
> This should be SYM_CODE_END() to match the opening.  However...
> 
>>    * When using in-kernel BTI we need to ensure that PCS-conformant assembly
>> @@ -42,6 +43,9 @@
>>   	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
>>   	BTI_C
>>   
>> +#define SYM_CODE_START_LOCAL(name)			\
>> +	SYM_START(name, SYM_L_LOCAL, SYM_A_ALIGN)       \
>> +	BTI_JC
> 
> ...this is going to cause problems, SYM_CODE means that we should
> assemble *exactly* what was written since it's some non-standard thing -
> we use it for the vectors table for example.  Looking at the code it's
> not 100% clear that the best approach here isn't just to change the call
> to a regular function call, this isn't a fast path or anything as far as
> I can see so it's unclear to me why we need to tail call.

Well for some workloads its could be AFAIK. OTOH, Ard mentioned dumping 
the tail call too, and I think that is pretty reasonable. So it looks 
like that is a better plan since it also avoids all this SYM_ flailing.


> 
> Failing that I think we need an annotation for tail called functions,
> that'd need to be a new thing as I am not seeing anything appropriate in
> the current generic annotations.
> 

