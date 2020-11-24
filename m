Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C2DC6379F
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Nov 2020 02:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF6D320720
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Nov 2020 02:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s4JDUqbr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgKXCnE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Nov 2020 21:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbgKXCnD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Nov 2020 21:43:03 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BDEC061A4D
        for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2020 18:43:02 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id q5so19177846qkc.12
        for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2020 18:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tNsYBLHLT9rrNvfsGBebo2tQKLhppSv7kANHpJdP/lI=;
        b=s4JDUqbrpI3rYJL0OWcii5UkUUD8CaKQ66QI8UxdC5zm5henEoV2h3SKIcT4USD8Is
         BxPdNoWkR8tYRTfFXFBrnAi9psiWgUpOSQtB5jKqoJ1ccx56LTdolESBS+vmRsjSWx4G
         i4BbhFoZcKXAwPiSThUFIHzJh1QRHIRUxL+p1EHCXYhWJQSP6TdJ6A4ZqOAky7qrcpZ9
         8DZgMnuEVlHYJO6X+foxpndqNcWTx+q0Eb0UgEyJH3PmA+VGF83fQsQn6QOnCW68PI+P
         S+WqPKCnOUae2/UAyZEw6u3s+avVSwxCtkDbvuQWnID2rVyk35nz4hP5h/dTsPPMB00O
         6I6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tNsYBLHLT9rrNvfsGBebo2tQKLhppSv7kANHpJdP/lI=;
        b=tcDH1ZFK5YwGq0Qfn9ho1Zist2JZwp8K+WeR4RpGKuVAVLpmH1PKjZ9E0NJkOLZN5Y
         Op7VWBCtadiZlJ1aOtuacv+AsfybYsB432hGcecQVPw8dCPADvam0z4RZo7HrDBseNqf
         qpMZx75tPiZALZlmp3nkGwfHsaVJ1AnO14YLNLYcx26uS4YHV1iuBWLlp1ZCS3secUdh
         xHgujwBoiCif3Bx9SIaWyQ4baSBmWhujlaJLorfht7FzDX0El5tfFxP1lCJ22zzXY2M1
         cMMMv5lZq1v4S/9JRQrNWt8l2LAYKXAj0p1jM6yYj/owzI/irGH5r99cVqib3+juqBfx
         gUbA==
X-Gm-Message-State: AOAM532nMoGccIh0gvdh+pdcSsxKMMofHNKMIjE7H+x966AeGVzIs8rQ
        o6gDT1en68sPIYYNpQbKm0lX+Q==
X-Google-Smtp-Source: ABdhPJw/2B3Xvuv7XA3fOYRpcJIpddnZFsIHjVXs8JpTBEDrceEvtKqoaAZU37k5M9FR5+uSqtg6wA==
X-Received: by 2002:a37:a249:: with SMTP id l70mr2545611qke.79.1606185781595;
        Mon, 23 Nov 2020 18:43:01 -0800 (PST)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id 68sm5412251qkf.97.2020.11.23.18.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 18:43:00 -0800 (PST)
Subject: Re: [Patch v2 0/6] Enable Qualcomm Crypto Engine on sdm845
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     agross@kernel.org, bjorn.andersson@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, sboyd@kernel.org, mturquette@baylibre.com,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
References: <20201119155233.3974286-1-thara.gopinath@linaro.org>
 <X7b1ZX5SEMq1PbVN@sol.localdomain>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <48ea0a56-397e-5345-d693-cdc73b20875d@linaro.org>
Date:   Mon, 23 Nov 2020 21:42:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <X7b1ZX5SEMq1PbVN@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 11/19/20 5:44 PM, Eric Biggers wrote:
> On Thu, Nov 19, 2020 at 10:52:27AM -0500, Thara Gopinath wrote:
>> Qualcomm crypto engine supports hardware accelerated algorithms for
>> encryption and authentication. Enable support for aes,des,3des encryption
>> algorithms and sha1,sha256, hmac(sha1),hmac(sha256) authentication
>> algorithms on sdm845.The patch series has been tested using the kernel
>> crypto testing module tcrypto.ko.
> 
> Can you please test CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y too?  Implementations of
> crypto algorithms shouldn't be enabled unless they are passing all tests.

Hi Eric,
Yes. I will get around to this probably next week.

> 
> Also, did you compare the performance of this hardware to ARMv8 CE?  I thought
> that QCE (at least on other SoCs) isn't very useful because ARMv8 CE is faster.

That is surprising. No I did not compare performance. But I see the 
Qualcomm crypto engine driver enabled and used in the downstream tree 
for this platform. I see no reason for it not to be in mainline and to 
be maintained as an out of tree solution. I will try to run some 
performance benchmarks soon.

> 
> - Eric
> 

-- 
Warm Regards
Thara
