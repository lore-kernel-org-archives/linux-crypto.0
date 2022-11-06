Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1326BC433FE
	for <linux-crypto@archiver.kernel.org>; Sun,  6 Nov 2022 07:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKFHHz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 6 Nov 2022 02:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiKFHHz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 6 Nov 2022 02:07:55 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B8CA45B
        for <linux-crypto@vger.kernel.org>; Sun,  6 Nov 2022 00:07:54 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so7820602pjk.1
        for <linux-crypto@vger.kernel.org>; Sun, 06 Nov 2022 00:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bVkLXQ1cCayBCnyAoyJS146/l6MYB41B6g+/2g6m45Y=;
        b=W1rex48tOXFJlDXelohwJ3CrgXZTwZKjXU93uTaMyLyQlgyDF1J7exvqLrl2tptKl6
         X+CH5T5OUEwCT7SWY2cY7Mp/bo/TkrO0utOkh92QbNYtqYa73yNgPnOohPjCZo8zP0xe
         5cnvGfo4XoXoRODl7QetWUM30EyvlPAaqniCo07RWUXQV3v1oVxENXFTZqHdRioXo0z+
         yokr6neZ5liNv2TzxR47OSupEpR/S0y60SwOhN+1tcQxiWI0mb/9DR0baSB+GbVN/q3z
         6yUVpb1cb8E3FgVtslMyNKd23fdWLwRyzcbPgN25S/+6C1Ia8OI43xw0gcF2S0N+HlMJ
         7uVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bVkLXQ1cCayBCnyAoyJS146/l6MYB41B6g+/2g6m45Y=;
        b=ZvXpo+vsD+kwUSDRcy2OnCpv5IUYBqu8s5x/PyzRfTRMWHxvAsIe+P03VnGqbtiuV2
         1rBl1xwT3dTYT7TBIEZEfI2SbVaTdawzL9H2Jn67iCJ+uJlrgg77rKugCiH+rCvzLLqh
         VfOp2qc3ZPwKFF8Iz3US+8rlOZdhdBMp34V3sDrTVmiaqoJIuXkHALvzffcunp4RQiMy
         duZUFsKca7glpwOB5xL7uEBaf9906Ppk/wbMrxNPDOAcyX6O4FpWFwUn/aLTihyjMz96
         UNYodC6pUp+eSXzG6v/uL2hDh3Z2V+ZMR46wF4rKcTUM9SalEqoXOl8zPvSdhbCY/0Wo
         8udA==
X-Gm-Message-State: ACrzQf1qpUbE7zGCwbeJ9HaTTdQIT0cDjqupzXi1tgJ6SmlETCdsUcTS
        DI9kUXiIrbQPrpnWl3/5dDs=
X-Google-Smtp-Source: AMsMyM6BfVE2vzoA3yGePEOJ4m5EPFFlgbWK2YN88DWF9Ua9MdA8TptZNq0zGMwmXEBrzFYV6wjRrw==
X-Received: by 2002:a17:902:dac5:b0:186:a687:e082 with SMTP id q5-20020a170902dac500b00186a687e082mr45126315plx.84.1667718473560;
        Sun, 06 Nov 2022 00:07:53 -0700 (PDT)
Received: from ?IPV6:2606:4700:110:8d19:ef92:9207:5a0d:60e7? ([2a09:bac1:3f60:98::16:12e])
        by smtp.gmail.com with ESMTPSA id q18-20020a17090311d200b00179f370dbe7sm2591563plh.287.2022.11.06.00.07.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Nov 2022 00:07:52 -0700 (PDT)
Message-ID: <1f78f88c-470e-6b1b-e441-907114f3271a@gmail.com>
Date:   Sun, 6 Nov 2022 16:07:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 3/3] crypto: aria: implement aria-avx512
To:     Dave Hansen <dave.hansen@intel.com>,
        "Elliott, Robert (Servers)" <elliott@hpe.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "jussi.kivilinna@iki.fi" <jussi.kivilinna@iki.fi>
References: <20221105082021.17997-1-ap420073@gmail.com>
 <20221105082021.17997-4-ap420073@gmail.com>
 <MW5PR84MB1842E11FD1CF7B44703A42B0AB3A9@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
 <d438e0d8-7469-7584-405b-76006372c2d4@intel.com>
Content-Language: en-US
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <d438e0d8-7469-7584-405b-76006372c2d4@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Elliott and Dave,
Thanks a lot for the reviews!

On 11/6/22 02:31, Dave Hansen wrote:
 > On 11/5/22 09:20, Elliott, Robert (Servers) wrote:
 >> --- a/arch/x86/crypto/aesni-intel_glue.c
 >> +++ b/arch/x86/crypto/aesni-intel_glue.c
 >> @@ -288,6 +288,10 @@ static int aes_set_key_common(struct crypto_tfm 
*tfm, void *raw_ctx,
 >>          struct crypto_aes_ctx *ctx = aes_ctx(raw_ctx);
 >>          int err;
 >>
 >> +       BUILD_BUG_ON(offsetof(struct crypto_aes_ctx, key_enc) != 0);
 >> +       BUILD_BUG_ON(offsetof(struct crypto_aes_ctx, key_dec) != 240);
 >> +       BUILD_BUG_ON(offsetof(struct crypto_aes_ctx, key_length) != 
480);
 >
 > We have a nice fancy way of doing these.  See things like
 > CPU_ENTRY_AREA_entry_stack or TSS_sp0.  It's all put together from
 > arch/x86/kernel/asm-offsets.c and gets plopped in
 > include/generated/asm-offsets.h.
 >
 > This is vastly preferred to hard-coded magic number offsets, even if
 > they do have a BUILD_BUG_ON() somewhere.

I will define ARIA_CTX_xxx with asm-offsets.c.
Then, the assembly code can use the correct offset of enc_key, dec_key, 
and the rounds in the struct aria_ctx.
Due to we can sure the offsets are correct, BUILD_BUG_ON() will become 
unnecessary.

I will send the v3 patch.

Thanks a lot!
Taehee Yoo
