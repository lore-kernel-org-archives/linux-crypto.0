Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16250ECAAD2
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Aug 2022 06:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbiH0Gup (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Aug 2022 02:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiH0Gun (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Aug 2022 02:50:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E969632BB0
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 23:50:41 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u22so3369267plq.12
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 23:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=pJ3MkJDirGLKyAjVQqnIcpvSVm/FXNWr/fI4wDNszbA=;
        b=J+DxSOzrTFBv/v94eSEYLXyWq6LvzuU93/zXNxsHHELvwA2fcmJZnT7gx1xqSKT02J
         2sSq6tHPEjIIVQBZh+F+JVVOLyF6P+/dd4aNgwxaXqe9isf0iRyGDLbBWPlKUPruIZNZ
         Glqp1YA3hkvPNkKDEnqH5Qgpj270cPLxmhZcuF4EqmmAP1n9nbSAxUZqAuYXDP3duBNB
         v+68z5Psp705J159s/pX9XFWitCRXXlBJDhlvAGfbvy1ucJu6n6jy456sJ+yTUMjQivr
         UEjIJitXii2jQi48EAWsCb4nypDtj97rh71rXJN1tFeDBvYZ81WbRfryAHpGR3XJLnOY
         pMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=pJ3MkJDirGLKyAjVQqnIcpvSVm/FXNWr/fI4wDNszbA=;
        b=1WKZSmcS3Hg3p0YAufH0fXfi/0apA/DknuCUsfTqJraUE0UQBlGtbbfDEtdvmwc8p8
         v5AjyyAoE8WqJHJfclwtjWyfDhdos+zrMErGgzIk+Zgvpg7iVZVTtmavu2VBUJF6Y7NQ
         JOh0scC9kj5teoABJEUor2upk7z7N7SoATkeXEIVI7dOZW3L/dyGaxhi5+voj9sILz6Z
         qKvc4EYbPPmo30wroLeuoUQu/V7AYCNMf5t/1kIYdymLy18Ld+BWTCMKUyKyCJKbtXZg
         DhoIj/SlCTqeAA6kr5eUZZojrcVVAjd4eitqoS6yZ2DuvLFrWksjF+Fq0gNTA5007pq8
         BWZQ==
X-Gm-Message-State: ACgBeo17uWBaqt+YKSroj5nofL/UGUeUy7Otcy+M6N8TCU61NhXXRAt3
        byR2yeSV7LtvI1AYtMjUyHc=
X-Google-Smtp-Source: AA6agR7Tc6kLQiRHU3o+AjdEfDO2Rs0p4d0HeRVCJL3NSwibwciV5CQl7uxL3Qvo18YxqMZT4/UHOw==
X-Received: by 2002:a17:90a:7c08:b0:1fd:7118:aa88 with SMTP id v8-20020a17090a7c0800b001fd7118aa88mr5272252pjf.193.1661583041380;
        Fri, 26 Aug 2022 23:50:41 -0700 (PDT)
Received: from ?IPV6:2001:2d8:6bae:5d50:8427:a6d:6d99:9e14? ([2001:2d8:6bae:5d50:8427:a6d:6d99:9e14])
        by smtp.gmail.com with ESMTPSA id w13-20020a170902e88d00b0016f8e8032c4sm2785891plg.129.2022.08.26.23.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 23:50:40 -0700 (PDT)
Message-ID: <3f229343-4c06-4e78-a590-70c3858919b8@gmail.com>
Date:   Sat, 27 Aug 2022 15:50:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, elliott@hpe.com
References: <20220826053131.24792-1-ap420073@gmail.com>
 <20220826053131.24792-3-ap420073@gmail.com>
 <YwmFouIyIlOMqKb4@sol.localdomain>
 <d19470f9-7aa7-e4e2-5a45-bd8e2839e109@gmail.com>
 <Ywm7QrJqsil3XoKY@sol.localdomain>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Ywm7QrJqsil3XoKY@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



2022. 8. 27. 오후 3:35에 Eric Biggers 이(가) 쓴 글:
 > On Sat, Aug 27, 2022 at 03:30:55PM +0900, Taehee Yoo wrote:
 >> Hi Eric,
 >> Thanks for your review!
 >>
 >> 2022. 8. 27. 오전 11:46에 Eric Biggers 이(가) 쓴 글:
 >>> On Fri, Aug 26, 2022 at 05:31:30AM +0000, Taehee Yoo wrote:
 >>>> +static struct skcipher_alg aria_algs[] = {
 >>>> +	{
 >>>> +		.base.cra_name		= "__ecb(aria)",
 >>>> +		.base.cra_driver_name	= "__ecb-aria-avx",
 >>>> +		.base.cra_priority	= 400,
 >>>> +		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 >>>> +		.base.cra_blocksize	= ARIA_BLOCK_SIZE,
 >>>> +		.base.cra_ctxsize	= sizeof(struct aria_ctx),
 >>>> +		.base.cra_module	= THIS_MODULE,
 >>>> +		.min_keysize		= ARIA_MIN_KEY_SIZE,
 >>>> +		.max_keysize		= ARIA_MAX_KEY_SIZE,
 >>>> +		.setkey			= aria_avx_set_key,
 >>>> +		.encrypt		= aria_avx_ecb_encrypt,
 >>>> +		.decrypt		= aria_avx_ecb_decrypt,
 >>>> +	}
 >>>> +};
 >>>
 >>> Why do you want ECB mode and nothing else?  At
 >>> 
https://lore.kernel.org/r/51ce6519-9f03-81b6-78b0-43c313705e74@gmail.com
 >>> you claimed that the use case for ARIA support in the kernel is kTLS.
 >>>
 >>> So you are using ECB mode in TLS?
 >>>
 >>
 >> aria-ktls only uses GCM mode.
 >> So, ECB will not be used by ktls.
 >>
 >> My plan is to implement the GCM aria-avx eventually.
 >> ECB implementation will be a basic block of aria-avx.
 >> I think it can be used by gcm(aria).
 >> So, I will implement gcm mode of aria with this implementation.
 >>
 >> If this plan is not good, please let me know.
 >> If so, I will change my plan :)
 >
 > GCM uses CTR mode, not ECB mode.
 >

Thanks for it,
I will implement CTR and includes it in the v3 patch.

Thanks a lot!
Taehee Yoo
