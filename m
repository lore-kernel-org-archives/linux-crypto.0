Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7578DC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EFCF64E4E
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhBDVpx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhBDVpt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:45:49 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1686C0613D6
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:45 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id r77so4889265qka.12
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hs1H1h3qwQTmNV+DMbywUe+Hs8J4rElNnCQHQMW80AE=;
        b=tRQBCZJ+RkNH/wRu3kjQwVVRM3EjAps7GUkbn1aLAE25EO4DOxWSbQrCLKrxu7FtuK
         dsqsMuv2UIvi2c7nvj91dqErnVdtW0+RDDTyXvqU92eFFAZRfhA1FY/FaRS6eR1/B6Pg
         IKgj8VJkM3O1gB/0mluF2wrOqMAMYPLjyzWC1V1U6AF+vyZeTYY/8YIIjMrt1YSWVBk6
         ijSsy5dXOMWi36V1eo7m01Yhq3K8qvU1DMqq3yfX4if8qr34BGPUNmHnQ50Zu62WOcF0
         4tI+9SjRCz6WdNwr6mNJXkZSjHnkLEN2gNwCY4g/L72rgTge45ik1Y0eQh95TNeE0Gnf
         1YQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hs1H1h3qwQTmNV+DMbywUe+Hs8J4rElNnCQHQMW80AE=;
        b=j1//8aw5nY9nPzH4xVskd1c5/9HKMCqjIix+z55ydmDySvP7cMRt0jirMXoz24GBpi
         sgRMN6cwPl+0E1GF/21wfSGiJY2cQpqelVoPS575TvOYktXUB5hnVXUoh/yc19pvT9cH
         rtRHoxA5mFfDZK7x0E+6iplMzpnLPBezuVCat5XK8/LbyriQ/5d95b0O+sdiLnqV/u65
         /QjXPL42isIrjQJm6L2iZjylMRPHmQTqB0+E/iVF5nJEPFylC2ooC6sXWG7t/OgXRRwx
         Qkv+k6vKlWI/LRH0w7bv4A0Ir/fJy8S9eGcELRCFcf2TpIzjbOtiW6cZaiASh0psm3G5
         /V8Q==
X-Gm-Message-State: AOAM530GHl264RkFSa1GbhWyOg80zVYIbs2Qoomd1ue9NE1yeB6MO8/G
        jDfMK4bi6VKNCe4qVZbNUp1w6Q==
X-Google-Smtp-Source: ABdhPJzEW8TZNA5pK2vWSA2qCo2LuMNHPTC69O6yViuae5CzKGqus/Hxf51EXpaHo+yCx3A64RXmzw==
X-Received: by 2002:a37:e17:: with SMTP id 23mr1284287qko.185.1612475085182;
        Thu, 04 Feb 2021 13:44:45 -0800 (PST)
Received: from [192.168.1.93] (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.gmail.com with ESMTPSA id b16sm6133086qkh.21.2021.02.04.13.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 13:44:44 -0800 (PST)
Subject: Re: [PATCH v4 01/11] crypto: qce: sha: Restore/save ahash state with
 custom struct in export/import
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210203143307.1351563-2-thara.gopinath@linaro.org>
 <202102040442.I3XzFSaf-lkp@intel.com>
 <20210204024250.GA5482@gondor.apana.org.au>
From:   Thara Gopinath <thara.gopinath@linaro.org>
Message-ID: <64321827-068f-bb32-ea83-176c8fe88811@linaro.org>
Date:   Thu, 4 Feb 2021 16:44:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210204024250.GA5482@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2/3/21 9:42 PM, Herbert Xu wrote:
> On Thu, Feb 04, 2021 at 04:56:17AM +0800, kernel test robot wrote:
>>
>> Thank you for the patch! Yet something to improve:
> 
> Please fix this before you resubmit again.

Hi Herbert.

Sorry about that. I have send the fix.

> 
> Thanks,
> 

-- 
Warm Regards
Thara
