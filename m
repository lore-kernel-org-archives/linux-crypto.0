Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8FAC28D13
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 13:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240310AbiHYNe5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 09:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241810AbiHYNem (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 09:34:42 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC989B56FE
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 06:34:27 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id l3so507739plb.10
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 06:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=cns6D+1+0Oxv9NsxBPCKZszyvBVw2C11vkAo53MfQtA=;
        b=g/fyQy9LTe9V6aL9M4Dnnqv6BSBRIHrZBxodhJyT5urGTpyB9zs+9yI8XKplyNUbEY
         EZk4mE9yljaemhn4M9INqU4A5WqNr9qKJqX/J75nnXwiZxvzcK2tXR52dzMndXOVdu7t
         0wHSrFU5McO/RUqyh3bR0RcjLgVqjOXXVDsrVzXwwz+FqQumrC+txivZiQxwH4Q4uw5F
         JVYAClXavBAgHxrtJipqyM5wPZqtxztr1Ckea6iNK99k4ECkwzBdEQaOE1OVo0W4egbb
         ciNTXmu3m3VX1x3dN9aF8AulNRT0GT4Xf6JckF9nYku8dQdQvoefLdf2X0n4wl0SkbKE
         +ohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=cns6D+1+0Oxv9NsxBPCKZszyvBVw2C11vkAo53MfQtA=;
        b=jxo+McTKHYsvwwZOp/KiGw6FvV1IXjH97un8/YRKabEc5EM7k7MoZd6mKd+lfuoe9I
         NKCFvQdUjdBiRr8AlZBvvQqp3nOHDVgMNvGi3Kz3f2CQ+8xKY3WnQfW2tW6Tu2K0qkUh
         r0fBWkwPa6F7Y9EnOaSah+n7D763Uzg0sAAzqF1Xt0iJ6EiBZi6lnTxMzYLhAsOMlAvj
         3lUfFYWlz4x7jbe50VsdduEyzqngBEfL/ZmuAGDaFCTFsLgW2lvuy5XNNCan4oMPoBzM
         wDgUFnABiAlaPdJAm2C+CY7dSnrdg3h2U3tm4CeBxF0j5cCZEnkZtMpEtLeHsso4yuUy
         +cng==
X-Gm-Message-State: ACgBeo2BXvW7LMlBiBZGXOwRUBQCzCV7A3orBtPJOyou10wlDKdklCxN
        OKQjeDLAPKkwct1bA78E6Gc=
X-Google-Smtp-Source: AA6agR5Wxw/GJCD5LVlZyUafWMfvz6eNiDdYeSE1QAuimsvKmx86tcwyq6i07QnfyO8c/M/fCfWjZg==
X-Received: by 2002:a17:902:ced0:b0:172:e189:f709 with SMTP id d16-20020a170902ced000b00172e189f709mr3839058plg.63.1661434467478;
        Thu, 25 Aug 2022 06:34:27 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id oo16-20020a17090b1c9000b001fa867105a3sm1666135pjb.4.2022.08.25.06.34.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 06:34:26 -0700 (PDT)
Message-ID: <0e87ff7a-463f-c14e-8deb-6f27feccd3ee@gmail.com>
Date:   Thu, 25 Aug 2022 22:34:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 implementation of aria cipher
Content-Language: en-US
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>
References: <20220824155852.12671-1-ap420073@gmail.com>
 <20220824155852.12671-3-ap420073@gmail.com>
 <MW5PR84MB1842D91195D8B5F438230C18AB739@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <MW5PR84MB1842D91195D8B5F438230C18AB739@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Elliott, Robert
Thank you so much for your review!

On 8/25/22 04:35, Elliott, Robert (Servers) wrote:
 >> -----Original Message-----
 >> From: Taehee Yoo <ap420073@gmail.com>
 >> Sent: Wednesday, August 24, 2022 10:59 AM
 >> Subject: [PATCH 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64 assembler
 >> implementation of aria cipher
 >>
 > ...
 >
 >> +#include "ecb_cbc_helpers.h"
 >> +
 >> +asmlinkage void aria_aesni_avx_crypt_16way(const u32 *rk, u8 *dst,
 >> +					  const u8 *src, int rounds);
 >> +
 >> +static int ecb_do_encrypt(struct skcipher_request *req, const u32 
*rkey)
 >> +{
 >> +	struct aria_ctx *ctx =
 >> crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
 >> +	struct skcipher_walk walk;
 >> +	unsigned int nbytes;
 >> +	int err;
 >> +
 >> +	err = skcipher_walk_virt(&walk, req, false);
 >> +
 >> +	while ((nbytes = walk.nbytes) > 0) {
 >> +		const u8 *src = walk.src.virt.addr;
 >> +		u8 *dst = walk.dst.virt.addr;
 >> +
 >> +		kernel_fpu_begin();
 >> +		while (nbytes >= ARIA_AVX_BLOCK_SIZE) {
 >> +			aria_aesni_avx_crypt_16way(rkey, dst, src, ctx->rounds);
 >> +			dst += ARIA_AVX_BLOCK_SIZE;
 >> +			src += ARIA_AVX_BLOCK_SIZE;
 >> +			nbytes -= ARIA_AVX_BLOCK_SIZE;
 >> +		}
 >> +		while (nbytes >= ARIA_BLOCK_SIZE) {
 >> +			aria_encrypt(ctx, dst, src);
 >> +			dst += ARIA_BLOCK_SIZE;
 >> +			src += ARIA_BLOCK_SIZE;
 >> +			nbytes -= ARIA_BLOCK_SIZE;
 >> +		}
 >> +		kernel_fpu_end();
 >
 > Is aria_encrypt() an FPU function that belongs between kernel_fpu_begin()
 > and kernel_fpu_end()?
 >
 > Several drivers (camellia, serpent, twofish, cast5, cast6) use 
ECB_WALK_START,
 > ECB_BLOCK, and ECB_WALK_END macros for these loops. Those macros do 
only call
 > kernel_fpu_end() at the very end. That requires the functions to be 
structured
 > with (ctx, dst, src) arguments, not (rkey, dst, src, rounds).
 >

aria_{encrypt | decrypt}() are not FPU functions.
I think if it uses the ECB macro, aria_{encrypt | decrypt}() will be 
still in the FPU context.
So, I will get them out of the kernel FPU context.

Thank you so much!
Taehee Yoo
