Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB119C352A1
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Dec 2022 05:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiLCFCE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Dec 2022 00:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiLCFCD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Dec 2022 00:02:03 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08D7C6E64
        for <linux-crypto@vger.kernel.org>; Fri,  2 Dec 2022 21:02:01 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id g10so6406240plo.11
        for <linux-crypto@vger.kernel.org>; Fri, 02 Dec 2022 21:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fsMt6TH30q3TTUgESUrPDGgSHVBC3Ps2oKwCQ/HpVIc=;
        b=H0Y+G+vYQYiGzpJPy/agslFt/YnmMfYu8Z2r2Iwdg8gPvAmYdQpgdRb4qG1nXCmXf/
         5Eom5iu6Ly72znl+JlGDGKRXv4p+j0vVwMSmVlB7cK+DdRQP4T9MOodL1re3YqOTPA4v
         WWrXwXrou8BVmYReFPGE3MMjKn4Exn86rackkGVMyQZggTDaAxS6e8bF31xyZxkgeKnD
         HYKXwCD8W9fs4L+vp1ZnZyQNBm7RUXZaFWShPmK4ywFJ5nyxAOK7bo5rDNvz0+0rXc52
         OhcZeTOMUfI3DqyKWqwAehtGBGn/V4rRfaxLo5/bt95NazR0ANKOr+qrAyfwf2RCmfPm
         zTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fsMt6TH30q3TTUgESUrPDGgSHVBC3Ps2oKwCQ/HpVIc=;
        b=kV3E9tLWbLV7Hh31rMNKGZJIInRV7ZKs6YOGlHmb+Qcu3lf0HeyljtuWZfEXWJRkYv
         Hh2CdjrIOD4jEifW7E2agBzcPBCEtl1GkSLbvw2RAr4XGYqN5Cyx21RlRfSglVY3FTju
         qOVb0ivqeqbo9HLvNiBTCam3xBjUJBh9n+kLqtoD15n2FnV8wgtFEWwHlwHrXVd0rCLz
         vZ+wjFa21oxGQTVGMU2dHkiZnz+smpJjAHwZB8QNEjbz1YLB6RiG+P+41yPj0+74Asve
         2yesBeZLQZKvqWS/2PUfBnLJGobVeAAFxEwfF0tT39kHNaUVzLbwlEQ8e7/EAwCrpq++
         vmVA==
X-Gm-Message-State: ANoB5pl4jH53+9maeycxq/ZbLeYBy0tNey2dpa/ejieUbYxJ2oZXFlv1
        mMwyvwrRrbdvsRFnz8oCQGI=
X-Google-Smtp-Source: AA0mqf7WvaYHCUyDkTXyjmyhiyRec+KLbwWtmLFvZyg+HvCnZV2fxFAqNlioEfLNeuQ10LOQJMBGTQ==
X-Received: by 2002:a17:902:74c6:b0:189:73df:aca2 with SMTP id f6-20020a17090274c600b0018973dfaca2mr35777418plt.58.1670043721325;
        Fri, 02 Dec 2022 21:02:01 -0800 (PST)
Received: from ?IPV6:2606:4700:110:8d19:ef92:9207:5a0d:60e7? ([2a09:bac1:3f40:98::16:1aa])
        by smtp.gmail.com with ESMTPSA id 188-20020a6218c5000000b00574c54423d3sm6068787pfy.145.2022.12.02.21.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 21:02:00 -0800 (PST)
Message-ID: <e0c38961-44cc-943b-8739-420867fdc5ce@gmail.com>
Date:   Sat, 3 Dec 2022 14:01:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v6 2/4] crypto: aria: do not use magic number offsets of
 aria_ctx
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi,
        ebiggers@kernel.org
References: <20221121003955.2214462-1-ap420073@gmail.com>
 <20221121003955.2214462-3-ap420073@gmail.com>
 <Y4nPbMHNQl++bItU@gondor.apana.org.au>
Content-Language: en-US
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Y4nPbMHNQl++bItU@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,
Thank you so much for your review!

On 12/2/22 19:11, Herbert Xu wrote:
 > On Mon, Nov 21, 2022 at 12:39:53AM +0000, Taehee Yoo wrote:
 >>
 >> +#if defined(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64) ||  \
 >> +	defined(CONFIG_CRYPTO_ARIA_AESNI_AVX_X86_64_MODULE)
 >
 > Why isn't this IS_ENABLED like the hunk below?
 >
 >> +
 >> +	/* Offset for fields in aria_ctx */
 >> +	BLANK();
 >> +	OFFSET(ARIA_CTX_enc_key, aria_ctx, enc_key);
 >> +	OFFSET(ARIA_CTX_dec_key, aria_ctx, dec_key);
 >> +	OFFSET(ARIA_CTX_rounds, aria_ctx, rounds);
 >> +#endif
 >> +
 >>   	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
 >>   		BLANK();
 >>   		OFFSET(VMX_spec_ctrl, vcpu_vmx, spec_ctrl);
 >
 > Thanks,

I missed cleaning it up.
I will use IS_ENABLED() instead of defined() in the v7.

Thanks a lot!
Taehee Yoo
