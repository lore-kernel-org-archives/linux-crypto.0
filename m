Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83732C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 09:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5205121882
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 09:04:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZiFf4iCG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfKIJEf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 04:04:35 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50314 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfKIJEf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 04:04:35 -0500
Received: by mail-wm1-f65.google.com with SMTP id l17so7663393wmh.0
        for <linux-crypto@vger.kernel.org>; Sat, 09 Nov 2019 01:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IUwwnDiaaJDiVabFkds3RA0M47VCvfNJ38YPN4U2oag=;
        b=ZiFf4iCGe7+Zx3ZhX8GUMNrmiwpIX9M28VNS2o1RohKIcKz60MsFU7Ogmhxjd7zHR/
         ySD3J8Ynm9GVmr9d6SBrxn3teHrSFFjtp00EL0LIzGwmRAdPrP2M3pw4DN9OnTEHrpZf
         7JSkUFBIyxO4UyWhWArilZrTC3zoW9vQeKw0y5LhgLLSQUxpkbnCuujcF4mDp8NSZhgB
         bfheoV61K2qSunKhPHtKxg+GaXoOfKXcGUOI7jW7dBKmzzv4uYbBpIuRjFNjMA7etwYR
         1/CXdi1ivD05pR8NBr76ieksqvH3ziPGtjH+TozbPDqloyYEQUbQD8j+WsnHiRrCE80C
         x7wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IUwwnDiaaJDiVabFkds3RA0M47VCvfNJ38YPN4U2oag=;
        b=IiE9s3qThZvAu75LDuWNFIAkwUHRzXP3KBQPo6TOQG/DcjEatroR2+GBcJSeV00NXe
         5M7oK44YTdwwvnA0jGX9c9cqpEH5DNY/QTZ7xR7h3TSHsZnSeHM6a3OYDxxRr82L0C+X
         0UykvN1qyo4STJCjPv2CFPYTPm4ZXgxbWGMvvzV3SG6rtXzqvCQff2NLBf0KtCic2frd
         rb1dXvrMH2AE+UlUrdkBB2UmGzTwarifY7UFz6PK9qkSNjKACA8FQKUMx3CsmdVH7vsj
         P7R8ijEBJw8DdsAQiMR1Z49rR4tzxh5vdZSLmHYe3M70xn7WRPKTK2rSw/edfAOOV0qr
         V5TQ==
X-Gm-Message-State: APjAAAUyfolQKzfdgj2dpJ4RXvWnxHzJOox6EHJZzWexJiPI+EfNRm9F
        6R3FNrjXWd/ix+HMm8y8mCLDFg==
X-Google-Smtp-Source: APXvYqySK+LLx+mFsjhA8c2T6jEnk3qq+T2A5FLess9l9dO4jbTB00ewWcCSK7AYN77z3jdYjcifDQ==
X-Received: by 2002:a1c:984b:: with SMTP id a72mr12413619wme.78.1573290272628;
        Sat, 09 Nov 2019 01:04:32 -0800 (PST)
Received: from [192.168.8.102] (108.red-213-99-169.dynamicip.rima-tde.net. [213.99.169.108])
        by smtp.gmail.com with ESMTPSA id n1sm9938802wrr.24.2019.11.09.01.04.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 01:04:31 -0800 (PST)
Subject: Re: [PATCH v5] arm64: Implement archrandom.h for ARMv8.5-RNG
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        ard.biesheuvel@linaro.org
References: <20191108135751.3218-1-rth@twiddle.net>
 <20191108143025.GD11465@lakrids.cambridge.arm.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Openpgp: preference=signencrypt
Message-ID: <846ba15f-b777-c0c9-6720-32b96d6c45ed@linaro.org>
Date:   Sat, 9 Nov 2019 10:04:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191108143025.GD11465@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/8/19 3:30 PM, Mark Rutland wrote:
> On Fri, Nov 08, 2019 at 02:57:51PM +0100, Richard Henderson wrote:
>> From: Richard Henderson <richard.henderson@linaro.org>
>>
>> Expose the ID_AA64ISAR0.RNDR field to userspace, as the
>> RNG system registers are always available at EL0.
>>
>> Signed-off-by: Richard Henderson <richard.henderson@linaro.org>
>> ---
>> v2: Use __mrs_s and fix missing cc clobber (Mark),
>>     Log rng failures with pr_warn (Mark),
> 
> When I suggested this, I meant in the probe path.
> 
> Since it can legitimately fail at runtime, I don't think it's worth
> logging there. Maybe it's worth recording stats, but the generic wrapper
> could do that.

Ah, ok, dropped.

>> +#ifdef CONFIG_ARCH_RANDOM
>> +	{
>> +		.desc = "Random Number Generator",
>> +		.capability = ARM64_HAS_RNG,
>> +		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
> 
> As above, if we're advertisting this to userspace and/or VMs, this must
> be a system-wide feature, and cannot be a weak local feature.

Could you draw me the link between struct arm64_cpu_capabilities, as seen here,
and struct arm64_ftr_bits, which exposes the system registers to userspace/vms?

AFAICS, ARM64_HAS_RNG is private to the kernel; there is no ELF HWCAP value
exposed to userspace by this.

The adjustment of ID_AA64ISAR0.RNDR is FTR_LOWER_SAFE, which means the minimum
value of all online cpus.  (Which seems to generate a pr_warn in
check_update_ftr_reg for hot-plug secondaries that do not match.)


> We don't bother with special-casing local handling mismatch like this
> for other features. I'd ratehr that:
> 
> * On the boot CPU, prior to detecting secondaries, we can seed the usual
>   pool with the RNG if the boot CPU has it.
> 
> * Once secondaries are up, if the feature is present system-wide, we can
>   make use of the feature as a system-wide feature. If not, we don't use
>   the RNG.

Unless I'm mis-reading things, there is not a setting for ARM64_CPUCAP_* that
allows exactly this.  If I use ARM64_CPUCAP_SYSTEM_FEATURE, then the feature is
not detected early enough for the boot cpu.

I can change this to ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE.  That way it is
system-wide, and also detected early enough to be used for rand_initialize().
However, it has the side effect that secondaries are not allowed to omit RNG if
the boot cpu has RNG.

Is there some setting that I've missed?  Is it ok to kick the problem down the
road until someone actually builds mis-matched hardware?


> ... so this can be:
> 
> bool arch_get_random_long(unsigned long *v)
> {
> 	bool ok;
> 
> 	if (!cpus_have_const_cap(ARM64_HAS_RNG))
> 		return false;
> 
> 	/*
> 	 * Reads of RNDR set PSTATE.NZCV to 0b0000 on success,
> 	 * and set PSTATE.NZCV to 0b0100 otherwise.
> 	 */
> 	asm volatile(
> 		__mrs_s("%0", SYS_RNDR_EL0) "\n"
> 	"	cset %w1, ne\n"
> 	: "=r" (*v), "=r" (ok)
> 	:
> 	: "cc");
> 
> 	return ok;
> }
> 
> ...with similar for arch_get_random_seed_long().

Done.

>>  config RANDOM_TRUST_CPU
>>  	bool "Trust the CPU manufacturer to initialize Linux's CRNG"
>> -	depends on X86 || S390 || PPC
>> +	depends on X86 || S390 || PPC || ARM64
> 
> Can't that depend on ARCH_RANDOM instead?

Yes, it can.


r~
