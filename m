Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D221BC433ED
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 23:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A87E7613C9
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 23:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhEEXBd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 19:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbhEEXBd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 19:01:33 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0508EC061574
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 16:00:36 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id jm10so2167420qvb.5
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 16:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/l1NHZWpnnb1oM5FmH4ACLg0nnosxzW/bCk3+E+1Wsk=;
        b=KjEaX8UjqtoV4BWI2sW0jFGAlY8VfgEMfivVB/hTpMwg7i/uY3N+QYeIcNKVussk0M
         aZ5AxpLWfJ+edPvjdbYRL4ovUN8XTKc+vrzo3s2DC0Km4h3fKWCLzq/3OHDx3nQqqauj
         rzSTXzLDj1LE0YxibqZZ4rIkbvk4bqWXU/fkzh2GltlNMZCKDCTOwAXRHV5Vuz/zlF0X
         FLmJC1q1hnu6205vTRxwRbvCjBZq0lpNuAYptWm0Ix4LWKJh+hlGrUsV9gigxrdD7U0M
         bddav17MI2IrrBEJK/am6eSIyE1DNV/Ie3FR5dGsXoD7kN+MpczUMNz8aEXIUH70mmUG
         CcAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/l1NHZWpnnb1oM5FmH4ACLg0nnosxzW/bCk3+E+1Wsk=;
        b=m+/YdPHSgCRR//HqTCbtRa969Wm8pH7PrwDaNBlhmkEJ6N4yP3+8OQz9a2EVZu/65/
         /xTbni9akt9Tg5sf5ns1/S7JolaJ9ZZk1pY38XD7ie8wATyi59or5AcPmZl2Zu3V1sQS
         atMHQBSOBc6ZX4k76SF0DXmrFsYK6asFq7dQ248hS4RrdAAOQsPbepG5I5/bfzp+0TW+
         EpU3FjD63aZNBPG6X4xHt7KP+D790+6HSPdfzLmVg4Vo2DVus7ll1/2C3rqvZLEVmfXX
         zwHYfRbJVemOXgrynX8FCQzjHGCTPcsm5lPQj/Pa9dotHFo2wSJoVnZUznS7K/MhpW8e
         lJxg==
X-Gm-Message-State: AOAM533rVLPGeIDvqORZKE7lW4OMNd1hepXOoARgoRua2Op7tgC4E3kL
        RXwDnuCB+g0QZW0iQEOAdFleBw==
X-Google-Smtp-Source: ABdhPJxns5jy4Vyfex+ZvHz8ZMr24XdAaVLeobaxhMJY4w6woowacxdPvACRk2aCmn3VILSQU48anw==
X-Received: by 2002:ad4:5c63:: with SMTP id i3mr1134865qvh.36.1620255635179;
        Wed, 05 May 2021 16:00:35 -0700 (PDT)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id d84sm661783qke.131.2021.05.05.16.00.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 16:00:34 -0700 (PDT)
Subject: Re: [Patch v4 0/7] Add support for AEAD algorithms in Qualcomm Crypto
 Engine driver
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20210429150707.3168383-1-thara.gopinath@linaro.org>
 <48d51bb5-a107-4756-4767-f62131d28505@linaro.org>
 <20210505225839.uy6zlj3gtp77uuqk@gondor.apana.org.au>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <b56e7025-eb83-0512-d5d5-5086eb8f3f6f@linaro.org>
Date:   Wed, 5 May 2021 19:00:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210505225839.uy6zlj3gtp77uuqk@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 5/5/21 6:58 PM, Herbert Xu wrote:
> On Wed, May 05, 2021 at 06:54:18PM -0400, Thara Gopinath wrote:
>>
>>
>> On 4/29/21 11:07 AM, Thara Gopinath wrote:
>>> Enable support for AEAD algorithms in Qualcomm CE driver.  The first three
>>> patches in this series are cleanups and add a few missing pieces required
>>> to add support for AEAD algorithms.  Patch 4 introduces supported AEAD
>>> transformations on Qualcomm CE.  Patches 5 and 6 implements the h/w
>>> infrastructure needed to enable and run the AEAD transformations on
>>> Qualcomm CE.  Patch 7 adds support to queue fallback algorithms in case of
>>> unsupported special inputs.
>>>
>>> This patch series has been tested with in kernel crypto testing module
>>> tcrypt.ko with fuzz tests enabled as well.
>>
>> Hi Herbert,
>>
>> I have fixed all the review comments on this series and fuzz tests pass as
>> well. Do you think this can be merged ?
> 
> We're still in the merge window, no new features are accepted
> at this point.  Please be patient.

Ok, thanks!

> 
> Thanks,
> 

-- 
Warm Regards
Thara
