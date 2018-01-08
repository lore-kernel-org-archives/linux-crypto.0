From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] checkpatch: add *_ON_STACK to $declaration_macros
Date: Mon, 8 Jan 2018 10:22:43 +0200
Message-ID: <CAOtvUMfeqY2Y0=g0V_mbUjf6s6_e0TD9RfYyZeFtDVX83RG-_g@mail.gmail.com>
References: <1498550116-12475-1-git-send-email-gilad@benyossef.com> <1513762915.1234.91.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Andy Whitcroft <apw@canonical.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:41136 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755009AbeAHIWo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jan 2018 03:22:44 -0500
Received: by mail-oi0-f50.google.com with SMTP id n81so3071382oig.8
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jan 2018 00:22:44 -0800 (PST)
In-Reply-To: <1513762915.1234.91.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 11:41 AM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2017-06-27 at 10:55 +0300, Gilad Ben-Yossef wrote:
>> Add the crypto API *_ON_STACK to $declaration_macros.
>>
>> Resolves the following false warning:
>>
>> WARNING: Missing a blank line after declarations
>> +                     int err;
>> +                     SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
> []
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
>> @@ -733,6 +733,7 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant|$String)};
>>  our $declaration_macros = qr{(?x:
>>       (?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,6}\s*\(|
>>       (?:$Storage\s+)?LIST_HEAD\s*\(|
>> +     (?:$Storage\s+)?[A-Z_]*_ON_STACK\(|
>
> A few things:
>
> The crypto _ON_STACK declarations cannot have a $Storage type.
>
> There should be a \s* between the ON_STACK and the open parenthesis
>
> There are other _ON_STACK types than the crypto uses
>
> $ grep -rP --include=*.[ch] -oh "\b[A-Z_]+_ON_STACK\b" * | \
>   sort | uniq -c | sort -rn
>      68 SKCIPHER_REQUEST_ON_STACK
>      45 SHASH_DESC_ON_STACK
>      10 AHASH_REQUEST_ON_STACK
>       4 PC_LOC_ON_STACK
>       4 DECLARE_DPM_WATCHDOG_ON_STACK
>       3 HISI_SAS_DECLARE_RST_WORK_ON_STACK
>       3 CONFIG_ARCH_TASK_STRUCT_ON_STACK
>       1 PT_SIZE_ON_STACK
>       1 ALLOC_PT_GPREGS_ON_STACK
>
> So perhaps:
>
>         (?:SKCIPHER_REQUEST|SHASH_DESC|AHASH_REQUEST)_ON_STACK\s*\(
>


Yes, it's better.

I'll send a v2.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
