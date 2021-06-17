Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1762C2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 13:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA6661351
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 13:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhFQNCt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 09:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbhFQNCs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 09:02:48 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15516C06175F
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 06:00:40 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id a11so6687015wrt.13
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 06:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=q6sEldOshJn0d8J/CoZlCtjXPMRrbnfqOQaf1QjIP4o=;
        b=u7WuXhGP3XfHgRBI9wOyYE6oh5SjfGbupOvlA6B8PawY7jcrsOCHkod2QqJj6DP+vY
         Mi7p1t4vmOAZVX3Qst7B3dBlDOd6L2j64ak+7EDVKnfyvlD7fZnxRi+H1iqdp2AEh7UV
         lu7WJcYQWVjAXny2ZKZqiX9XRWc9MqwPyiUOV6XJng7lSQGfHmZmkjefOaqt+bYxjejY
         it3nZklRrdZ7rIwFsCMGjDoS4/gp1fZOODk41OusP/DM83TaE78hmg7GhT/Jj25pgMMc
         YahR9dcMGe10X7z76xX0x2s3umGI3LQXkjHGhwGR5exb5UmyvkaNLDOTpX6vJKyJ+jeX
         n1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=q6sEldOshJn0d8J/CoZlCtjXPMRrbnfqOQaf1QjIP4o=;
        b=iWbIPkox9DZTACXnVjKJCfHqXYuRJs8ndVWGQDDITqt+KO5C+dFabOpAS1tn7/J6Sl
         +BtsKQrYhqPWkUALSZJ1IckCrzbikpHnk4nYNpm82OxCizYaTDaxigQY1IJThKQqImcy
         LJx8oSa+u7xVQiG3lTsv7NmczTtIUod2EM+fcLifI4xeHFB5wQc2PA4t20Sy7RRqpUIC
         cRlr4sf7BqRen/j52uTvmw9WjAjQlxEgO+wM8F/tyIRFUTKcQq/XRqOrRt2UnzpQ7F5w
         KvxoZqqMl+UW/axhVasgFKkTh8kCnrqFzHkTuCOkfDPgz23KixfIourgoKjDLQWLOeRQ
         ycYw==
X-Gm-Message-State: AOAM531EUvZ70BjLPgLPE5a7KVJIPM4VDwWsu2KKdMjQWlFfFDEInrTJ
        aTMGk1X2cBV5EKpyyhbf1UdSkw==
X-Google-Smtp-Source: ABdhPJyJM8Z6uwWVeoMPriMzHYvSdXrYItDTn/79jdUDu1m/exBSih1FGpZObVVKSjX2lWkkCYnwdA==
X-Received: by 2002:a05:6000:2ce:: with SMTP id o14mr5711931wry.145.1623934838323;
        Thu, 17 Jun 2021 06:00:38 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id l3sm4504674wmh.2.2021.06.17.06.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 06:00:37 -0700 (PDT)
Date:   Thu, 17 Jun 2021 15:00:34 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] crypto: sl3516 - Fix build warning without
 CONFIG_PM
Message-ID: <YMtHcruTqo3WE+g6@Red>
References: <20210617035129.4948-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210617035129.4948-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Thu, Jun 17, 2021 at 11:51:29AM +0800, YueHaibing a écrit :
> drivers/crypto/gemini/sl3516-ce-core.c:345:12:
>  warning: ‘sl3516_ce_pm_resume’ defined but not used [-Wunused-function]
>  static int sl3516_ce_pm_resume(struct device *dev)
>             ^~~~~~~~~~~~~~~~~~~
> 
> Use #ifdef macro to guard this.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/gemini/sl3516-ce-core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Hello

Thanks for the report, but I am sorry and need to NAK this patch.

The driver needs PM, without it, clock and resets are never set.
The correct fix is to add "depends on PM".

Regards
