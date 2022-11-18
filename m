Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D367C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 06:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbiKRGIX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 01:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKRGIU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 01:08:20 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5279D9825A
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 22:08:20 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id z26so3983345pff.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 22:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bb1Jn0C1Giq64KYlETePlU0uwaMBAKfQCTru1bkGL1w=;
        b=TrPBjVMKDkES+KedmCstBn/wZoNP86ei61ZUbPSRe/mt4EklpXBkc2hit/QbUT15Ja
         cDr981gqCd5aP3wY0InW/7sXfd0UDgHCuSauDTyrKo60BMjAJVM+6VlGuNiV2LYiqmI2
         mwnwCPbPk+r6RKQVmSlS4GJZ5i1sW8PkFym585nqaICeQlrZeVAjXfeQ4ZKOeCZ0+RTn
         we50ghS7PJdSK7Fs9NVLT5FZczXG4W52Hq24EZ4MyE+ZAm2tq1WgCM7D+G/muRQrtcjW
         aTX09mNnXmX2mTCHFcPmZEC3PqCgbJfONGHK/U5h2v5TVmBsrkEWL+U9s4dlBSFttxg5
         0Z8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bb1Jn0C1Giq64KYlETePlU0uwaMBAKfQCTru1bkGL1w=;
        b=PyvJzPdL9rvGof1U5R0EwcC9DvGpEbbj3Sl7CsLA5BZ5xHQV9oztUj9B5ZtdQ7A4Kp
         cd+JoSF+JNVSv13cRFt5lXYdX/0j7NprSs8MXeo13u+7wqrRlKTOtY3q4jXRem/4Wb7s
         QpavED79kWP20ns4GPpb1psx+JkCFOhV32e/q7iYhKcGw8BTBulrPiByyPhuR6l7abFL
         MewEm8ULDJsc+4vLHSlk2N5A+Oy58OicHmDJ7R56agY9bMbKaaFzD3gpH936K5+oHDgt
         reohYstPswOpDFVwB0eB32gyotRzUzL6/lwoa6rsRy4QPo+OcOR5raMZJTMTNu5+slzn
         BZ/Q==
X-Gm-Message-State: ANoB5pmvdKGzBHTPW2+U6pdsLLqbXjcJ+gPBi1jO9gzzwNulCYONdYCr
        xVI1qdBiFnu7fTe1MVffaIo=
X-Google-Smtp-Source: AA0mqf6iN6e9Bg3mf/PHLsFa64GhH1Z0P8AusOvuMoSIcQVKIZDN9WRnLHgVYD2LEjQT3GsSMcV6Lw==
X-Received: by 2002:a05:6a00:1d25:b0:562:5f71:d188 with SMTP id a37-20020a056a001d2500b005625f71d188mr6396254pfx.57.1668751699749;
        Thu, 17 Nov 2022 22:08:19 -0800 (PST)
Received: from ?IPV6:2606:4700:110:8d19:ef92:9207:5a0d:60e7? ([2a09:bac1:3f40:98::16:12e])
        by smtp.gmail.com with ESMTPSA id f5-20020a63f745000000b0046fe244ed6esm2055815pgk.23.2022.11.17.22.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 22:08:18 -0800 (PST)
Message-ID: <4c7c3b8f-f6f3-cd74-239c-af93bb2642a6@gmail.com>
Date:   Fri, 18 Nov 2022 15:08:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v4 1/4] crypto: aria: add keystream array into request ctx
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
References: <20221113165645.4652-1-ap420073@gmail.com>
 <20221113165645.4652-2-ap420073@gmail.com>
 <Y3cRNuYd92QUthDC@gondor.apana.org.au>
Content-Language: en-US
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <Y3cRNuYd92QUthDC@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Herbert,
Thank you so much for your review!

On 11/18/22 13:59, Herbert Xu wrote:
 > On Sun, Nov 13, 2022 at 04:56:42PM +0000, Taehee Yoo wrote:
 >>
 >> @@ -130,6 +135,13 @@ static int aria_avx_ctr_encrypt(struct 
skcipher_request *req)
 >>   	return err;
 >>   }
 >>
 >> +static int aria_avx_init_tfm(struct crypto_skcipher *tfm)
 >> +{
 >> +	crypto_skcipher_set_reqsize(tfm, sizeof(struct aria_avx_request_ctx));
 >> +
 >> +	return 0;
 >> +}
 >> +
 >>   static struct skcipher_alg aria_algs[] = {
 >>   	{
 >>   		.base.cra_name		= "__ecb(aria)",
 >> @@ -160,6 +172,7 @@ static struct skcipher_alg aria_algs[] = {
 >>   		.setkey			= aria_avx_set_key,
 >>   		.encrypt		= aria_avx_ctr_encrypt,
 >>   		.decrypt		= aria_avx_ctr_encrypt,
 >> +		.init			= aria_avx_init_tfm,
 >>   	}
 >>   };
 >
 > You need to set the new flag CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE
 > or else users of sync_skcipher may pick up this algorithm and
 > barf.
 >

Okay, I will set CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE flag in the v5 patch.

Thanks a lot!
Taehee Yoo

 > Cheers,
