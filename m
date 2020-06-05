Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13F1C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 15:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A5192075B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 15:26:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hb1FEGJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbgFEP0l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 11:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgFEP0k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 11:26:40 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4058C08C5C2
        for <linux-crypto@vger.kernel.org>; Fri,  5 Jun 2020 08:26:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id u5so5278742pgn.5
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jun 2020 08:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AqjUdAV0eSeVgzmdoBhAtl0I2tJh0EYeJ8Lxk1njxlE=;
        b=Hb1FEGJcGKGXT6cLEc5+mKoFByGI75v/JS3V5JnikKJzHQfGRL5LNFK/kRVwPeymzn
         KLM6YgOaeQE1m6PhzzmrTyyrAyS6WLwbbfCVeFHF+ZmJIsx/7IaWhORJ+fGcarvE+Pwz
         FC64vYpIXt58BXX+h27dWOxjbSiAPbfJBW4OQEAxOB8Tbx7oJY40zWDwQpsA0bBYk1nn
         rT8VvP9eaV83x6AYoNPwr7pom9jUbFBi7yFKiTZPvCQmawfR1rSd/JLpKQwCf3fy3ElS
         wwHMz/JFa1OGLr53eTVb1c6QyBtqfw9NSI79OqnQqtR0VdkZlH/gKUGVXJyVrjn9SqDY
         qdRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AqjUdAV0eSeVgzmdoBhAtl0I2tJh0EYeJ8Lxk1njxlE=;
        b=QcYKVne5u4N4r0B6HC52MD5nesXZlt+dtyDchSiePtMMHF3lM/GWWznHxGY8zmhzmC
         WXlfJeNE/KnsLY1af7hHv39x1/iDmtjTl+GoZZhOHJ1lfAXtGBhCWTcUC0BopCkQz3jp
         JyBjRfoVhINL89xBCdYHvv34wjnuq0RszEyCqvhMiI42GQ4iEmqo4wRU7SLlPK1Vvg/p
         Wmmh0pgP2+7XlOlq88At3JsYCfSgfE1OsKObsgi80yp3B46p743I6A2MAaCuBY5OCHvX
         56TBwtXgAjkfrDASrX6XJLQ3MlKEfleDY1tGk0dqw7rQ029l5lXxA+N/EW/rMfTPTfKh
         Yp9A==
X-Gm-Message-State: AOAM530Pe7nLjLzABskB5Erpt8apHmq5ksnzdh2OBCidll91CjSR7PmK
        Z95+l/N42CSN1dyW2p3XlLEZNw==
X-Google-Smtp-Source: ABdhPJyobG69F9I2fWtiHr9xUh0TsIYXcAcsxJ2A10JAWpRfQlUUMqaD6EgpE9W1LELyCy7x6htK7Q==
X-Received: by 2002:a65:6810:: with SMTP id l16mr9525777pgt.390.1591370800353;
        Fri, 05 Jun 2020 08:26:40 -0700 (PDT)
Received: from [10.110.1.78] ([45.135.186.59])
        by smtp.gmail.com with ESMTPSA id s197sm8002426pfc.188.2020.06.05.08.26.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 08:26:39 -0700 (PDT)
Subject: Re: [PATCH] crypto: hisilicon - fix strncpy warning with strlcpy
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        wangzhou1 <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        kbuild-all@lists.01.org
References: <202006032110.BEbKqovX%lkp@intel.com>
 <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
 <20200604033918.GA2286@gondor.apana.org.au>
 <b6ad8af2-1cb7-faac-0446-5e09e97f3616@linaro.org>
 <20200604061811.GA28759@gondor.apana.org.au>
 <b23433f8-d95d-8142-c830-fb92e5ccd4a1@linaro.org>
 <20200604065009.GA29822@gondor.apana.org.au>
 <f8dceec5-6835-c064-bb43-fd12668c2dbb@linaro.org>
 <20200605121703.GA3792@gondor.apana.org.au>
From:   Zhangfei Gao <zhangfei.gao@linaro.org>
Message-ID: <47b747d2-3b27-4f39-85c9-204c2b8a92e1@linaro.org>
Date:   Fri, 5 Jun 2020 23:26:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200605121703.GA3792@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/6/5 下午8:17, Herbert Xu wrote:
> On Fri, Jun 05, 2020 at 05:34:32PM +0800, Zhangfei Gao wrote:
>> Will add a check after the copy.
>>
>>          strlcpy(interface.name, pdev->driver->name, sizeof(interface.name));
>>          if (strlen(pdev->driver->name) != strlen(interface.name))
>>                  return -EINVAL;
> You don't need to do strlen.  The function strlcpy returns the
> length of the source string.
>
> Better yet use strscpy which will even return an error for you.
>
>
Yes, good idea, we can use strscpy.

+       int ret;

-       strncpy(interface.name, pdev->driver->name, sizeof(interface.name));
+       ret = strscpy(interface.name, pdev->driver->name, 
sizeof(interface.name));
+       if (ret < 0)
+               return ret;

Will resend later, thanks Herbert.


