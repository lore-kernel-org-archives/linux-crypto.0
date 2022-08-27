Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9AFECAAD2
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Aug 2022 06:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiH0GbE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Aug 2022 02:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiH0GbD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Aug 2022 02:31:03 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6833122A
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 23:31:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 145so3146790pfw.4
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 23:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=SVVZCqbsBBYQk9z46fpbdEcguIKZGvh6vf2MHPAKGt8=;
        b=HCYOmmfLbA8Zn2HSfX5B4QWczUaye0nPGtmtJWHVJMcPYDlvnNAtIL+99AVQvbsup0
         ulMnF/Q+dlAmb50gY53rLJQkQerUGOz+WY4upqz/5a+0E1GN4RAt7lzxVY3w4viVZahI
         N8XKDDRCbSvwj23MN5eKd8PhRp8ExcFSX91kUqFtX4SK11YFcL0WipzyryEo4JlDwSZJ
         g/GvLXm8wJRgrV5vFQ2jfPTAS+zn+huSZmobP9S5HWzonHZHSmH+ZGqyj/dAOnJVN4uU
         aN4OEGJeFwOgktYTnLN0l1yRpMUTpJHO2qTE0m2vnUlfZtSYzTW4xjRplGcyo4j40m6v
         6YLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=SVVZCqbsBBYQk9z46fpbdEcguIKZGvh6vf2MHPAKGt8=;
        b=SZkWW5cAXWPjHwro7jdGC3JaUL3QcHin0G3TQXiOFJ8Dw7+yvz8ngPo72B795TwnMo
         HEXB60t4BlgZWOVPZb3MInl5GbWya18kpmLi+tBlyADyncMNbFID7wW5S+pnd32bB2XI
         aBlDkfxJnFy9w+fOofORvfuXLC+uND6+GUDWy4rPwAhZKbrQKIgtwuW4Y9abNhgA4Gv5
         L1uDTFsqwqdByxtU4jS6XaQPAHTXAYZd6LdDmy8M1xGGLnfrBCDcQF8q4fYSADbEMoIz
         RkcvfrwmehLQo+c1BEpBPDIIzxEttGTf8ar8F7aflzBPzYCUmVtsPHP5SaN4yRpqJP2h
         VXgg==
X-Gm-Message-State: ACgBeo0GeNreNaZcFFS5HvCYhRl4ymteWDEaFC56usi/AaoAc2opv5lc
        NAinvhBazUXrJxHfx4tywN4=
X-Google-Smtp-Source: AA6agR6HixSRHaIgYWynf1tZsOw62n56cKCB7RQ57vkBuD0e+2gYJHM44m/NGMrtG9D8dH2oJ1Z9eA==
X-Received: by 2002:a05:6a00:188a:b0:536:1401:7f65 with SMTP id x10-20020a056a00188a00b0053614017f65mr7204485pfh.1.1661581860881;
        Fri, 26 Aug 2022 23:31:00 -0700 (PDT)
Received: from ?IPV6:2001:2d8:ee33:425e:2c9c:e338:d99e:acdc? ([2001:2d8:ee33:425e:2c9c:e338:d99e:acdc])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b00172a1f6027asm2724279plx.235.2022.08.26.23.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 23:31:00 -0700 (PDT)
Message-ID: <d19470f9-7aa7-e4e2-5a45-bd8e2839e109@gmail.com>
Date:   Sat, 27 Aug 2022 15:30:55 +0900
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
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <YwmFouIyIlOMqKb4@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,
Thanks for your review!

2022. 8. 27. 오전 11:46에 Eric Biggers 이(가) 쓴 글:
 > On Fri, Aug 26, 2022 at 05:31:30AM +0000, Taehee Yoo wrote:
 >> +static struct skcipher_alg aria_algs[] = {
 >> +	{
 >> +		.base.cra_name		= "__ecb(aria)",
 >> +		.base.cra_driver_name	= "__ecb-aria-avx",
 >> +		.base.cra_priority	= 400,
 >> +		.base.cra_flags		= CRYPTO_ALG_INTERNAL,
 >> +		.base.cra_blocksize	= ARIA_BLOCK_SIZE,
 >> +		.base.cra_ctxsize	= sizeof(struct aria_ctx),
 >> +		.base.cra_module	= THIS_MODULE,
 >> +		.min_keysize		= ARIA_MIN_KEY_SIZE,
 >> +		.max_keysize		= ARIA_MAX_KEY_SIZE,
 >> +		.setkey			= aria_avx_set_key,
 >> +		.encrypt		= aria_avx_ecb_encrypt,
 >> +		.decrypt		= aria_avx_ecb_decrypt,
 >> +	}
 >> +};
 >
 > Why do you want ECB mode and nothing else?  At
 > https://lore.kernel.org/r/51ce6519-9f03-81b6-78b0-43c313705e74@gmail.com
 > you claimed that the use case for ARIA support in the kernel is kTLS.
 >
 > So you are using ECB mode in TLS?
 >

aria-ktls only uses GCM mode.
So, ECB will not be used by ktls.

My plan is to implement the GCM aria-avx eventually.
ECB implementation will be a basic block of aria-avx.
I think it can be used by gcm(aria).
So, I will implement gcm mode of aria with this implementation.

If this plan is not good, please let me know.
If so, I will change my plan :)

Thanks a lot!
Taehee Yoo

 > - Eric
