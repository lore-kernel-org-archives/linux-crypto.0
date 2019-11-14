Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42E3C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 18:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 960B420709
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 18:11:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CyyKj65d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfKNSLg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 13:11:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42587 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfKNSLg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 13:11:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id a15so7558255wrf.9
        for <linux-crypto@vger.kernel.org>; Thu, 14 Nov 2019 10:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W9hUaXgEGH0+McOgDXrLDEjLrUK2r0StMQnMwauTTsQ=;
        b=CyyKj65d3q76Cyufn/oxPwKRA8/5C0/cfs8gPXJCpdGSCVXQTllUNi9wo5/sid0JOQ
         owxhP7W/YmcYeMuUG/r+kNiTpUWsBu7t8MSvcmrmqC0orlLqMsaC2fx9nUcyb7LuirBC
         k9czaYldxpybdZLxmjNKsBYOXwO5KJxfQRPUq+46dOAx0R0S8KZOuEBbWi1TGwsGNLVt
         /INEEg1hT1CHosXtYNPQZsdmFzOF4j70Wt8mNbgcSPIvQuJIauqDwpdzBuKvGTUX0v96
         DgJ0A0CZTfl1TW8/6FQr/uoWdpB5EW5DpG05WLTnQCmLVK7LJwD3DXUXeb+3HdX98xgd
         v0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W9hUaXgEGH0+McOgDXrLDEjLrUK2r0StMQnMwauTTsQ=;
        b=VqVy/BC0mwXEQAbnoXyu3KCBN2ifPrAIZXNw5VqPlk/NpjjDphIpsBFoFasZTmFsqF
         XjF+fy5X7yiZNYOUrTOblIrFduJqUvwZE80CSYDPsParuTCDjll2QZnPJ/1FRhMVcCtA
         IK2OyF8zZSWduQKMvsDgyODdwf2K9KawAJkI8p93ZgPYaeQLnXqJ2RlH+MWUyn+f06O7
         EAkOqKtLQx0g3gjz6e7RhyttMlIV78uwKzfZqCHX5mPvlhZoMhvQ9H8RoNGyfHkL5O9V
         jIaik1bpPdUxgn9zval6rirJyX5jTrNKrkgOijmBa2ivr5G/FSFSW9DCMl5DBGhSQ60+
         L7xQ==
X-Gm-Message-State: APjAAAUcQk8nBJoqa1qi5ZhvrWltUEALTXc92WfjSdVK5+8J9j04Fh+A
        OA7DoclRxJsG+joqcWk8AXHnv7MtkSNnkQ==
X-Google-Smtp-Source: APXvYqyI2DoHw0eYUJOx5qaYUiXc1+Eu5UTWtu40d2zYY1WLbbcQhe4FbzwZBzOKL4r2eLRZ7cIQXw==
X-Received: by 2002:adf:f744:: with SMTP id z4mr9688382wrp.205.1573755092513;
        Thu, 14 Nov 2019 10:11:32 -0800 (PST)
Received: from [192.168.8.102] (184.red-37-158-56.dynamicip.rima-tde.net. [37.158.56.184])
        by smtp.gmail.com with ESMTPSA id j14sm7792698wrp.16.2019.11.14.10.11.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 10:11:31 -0800 (PST)
Subject: Re: [PATCH v7] arm64: Implement archrandom.h for ARMv8.5-RNG
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org,
        linux-crypto@vger.kernel.org
References: <20191114113932.26186-1-richard.henderson@linaro.org>
 <20191114142512.GC37865@lakrids.cambridge.arm.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Openpgp: preference=signencrypt
Message-ID: <3b1d5f2a-5a8d-0c33-176a-f1c35b8356de@linaro.org>
Date:   Thu, 14 Nov 2019 19:11:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191114142512.GC37865@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 11/14/19 3:25 PM, Mark Rutland wrote:
> On Thu, Nov 14, 2019 at 12:39:32PM +0100, richard.henderson@linaro.org wrote:
>> +bool arch_get_random_seed_long(unsigned long *v)
>> +{
>> +	bool ok;
>> +
>> +	if (static_branch_likely(&arm64_const_caps_ready)) {
>> +		if (__cpus_have_const_cap(ARM64_HAS_RNG))
>> +			return arm64_rndr(v);
>> +		return false;
>> +	}
>> +
>> +	/*
>> +	 * Before const_caps_ready, check the current cpu.
>> +	 * This will generally be the boot cpu for rand_initialize().
>> +	 */
>> +	preempt_disable_notrace();
>> +	ok = this_cpu_has_cap(ARM64_HAS_RNG) && arm64_rndr(v);
>> +	preempt_enable_notrace();
>> +
>> +	return ok;
>> +}
> 
> As I asked previously, please separate the common case and the boot-cpu
> init-time case into separate functions.

Ok, beyond just making arch_get_random_seed_long be a function pointer, how?

I honestly don't understand how what you want is different from what's here.


> The runtime function should just check the RNG cap before using the
> instruction, without any preemption check or explicit check of
> arm64_const_caps_ready. i.e.
> 
> static bool arm64_rndr(unsigned long *v)
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
> 	"       cset %w1, ne\n"
> 	: "=r" (*v), "=r" (ok)
> 	:
> 	: "cc");
> 
> 	return ok;

This is exactly what I have above, in arch_get_random_seed_long(), in the
arm64_const_caps_ready case.

BTW, you can't stick the cpus_have_const_cap check in arm64_rndr(), or it isn't
usable before setup_cpu_features().  The embedded cpus_have_cap() check will
not pass for the boot cpu alone, unless we use
ARM64_CPUCAP_STRICT_BOOT_CPU_FEATURE, which does not have the semantics that
you have requested in previous review rounds.

Which is *why* I wrote the test exactly as I did, so that when
!arm64_const_caps_ready, I can use a different test than cpus_have_cap().

> Any boot-time seeding should be in a separate function that external
> callers cannot invoke at runtime. Either have an arch function that the
> common random code calls at init time on the boot CPU, or have some
> arch_add_foo_entropy() function that the arm64 code can call somewhere
> around setup_arch().

What "external callers" are you talking about?

My boot-time code above can only be reached until arm64_const_caps_ready, at
which point the branch is patched out.  So after boot-time, "external callers"
only get

	if (__cpus_have_const_cap(ARM64_HAS_RNG))
		return arm64_rndr(v);
	return false;

Which to my mind satisfies your "cannot invoke" clause.

Anyway, the preempt_disable is present on my boot path because preempt *is*
enabled during rand_initialize().  If I do not disable it, I do trigger the
warning within this_cpu_has_cap()

As for arch_add_boot_entropy() or whatnot... you're now you're asking for
non-trivial changes to the common drivers/char/random.c code.  I'm not keen on
designing such a thing when I really don't know what the requirements are.  In
particular, how it would differ from what I have.

Color me confused.


r~
