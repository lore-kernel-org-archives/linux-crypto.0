Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C180C05027
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Feb 2023 23:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBSXvc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Feb 2023 18:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBSXvb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2023 18:51:31 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DCBB471
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 15:51:29 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s24so5669415edw.2
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 15:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9T+0vvMQ6CofO7MltcV+aLQpaHncpd8YadXXjDGJ0Ys=;
        b=RS0jSFVmyl8FM9upJM/LN7mJc0sXImOBQaR7lysK5rybgPsgc1Hjfl7T1hcC4Z7q68
         mY10fYNFuJMfHbWunGoSqtdxsooWqoo4MWe7wE1CQQyl6cJvElZcuY9fliiYgMpSi7jA
         W8Sja08TQOF9lfb5mBJVJi/3eAmvejP2KE6VoWQXFY/uiylgjENoJCKMWuHIGY/HcEBD
         2N7m1a6xU0K+AlbTJpkuhFXQexUYmji4WWMYQ+Og2A4cPMYYxVRBhhSTdFu40zrtj5ix
         GQdkg3dFDPhMeCOq23PfhH7kX7jORIqJkYqq0vj1dXlCJR5+KrrYJIq/0a72gfvdmbfo
         R9aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9T+0vvMQ6CofO7MltcV+aLQpaHncpd8YadXXjDGJ0Ys=;
        b=r0cyX+8F/PYKFmi5Q//Q6/a3md2foQ8v1bO1ZkfRbcqjxDC8rfeo++a4PJ8zK2QDrB
         g20gYIDyurs38FeifFFSxCw1mO+wrs1FLKeifbEVgha8R91575OK57xnGMWtmnZ13E6T
         8JqHrXQkk6HzaEZv0WJPn7eVhnHdidxUIagHEbMqV8wX1IVY2Os+TfiexYso3XgkMI1s
         6UreREHYMsTtjrlEWU8F5FRP+czRBB/7e7yaMTBSaKIJb7+XB8Xh76vTQEE8BY7HNWUX
         Dmy4KetrLkynU2xdqfWe3711WGJCw2lqGAn9c+Y8SExXzz00gto2PDEapzUvqFG69dRj
         8/QA==
X-Gm-Message-State: AO0yUKUDS0jflh9U43Ct4rjTSAgyTiJosO5PsmSEiSJyHCvggU6VZ5Jm
        ZeQ1G0OdNNgaqcGQOeJ2BKEwXfQfZWU=
X-Google-Smtp-Source: AK7set9u5efodNJWNvffh5MiNeqzWyb+JBasY+z77Grapus8VOBqIkZ5RGU51QY8IQKgyhYG2vVwGw==
X-Received: by 2002:a17:906:3683:b0:7c0:e30a:d3e5 with SMTP id a3-20020a170906368300b007c0e30ad3e5mr6657193ejc.18.1676850687619;
        Sun, 19 Feb 2023 15:51:27 -0800 (PST)
Received: from ?IPV6:2a01:c22:7bef:c400:446:9acc:56be:b07b? (dynamic-2a01-0c22-7bef-c400-0446-9acc-56be-b07b.c22.pool.telefonica.de. [2a01:c22:7bef:c400:446:9acc:56be:b07b])
        by smtp.googlemail.com with ESMTPSA id kd18-20020a17090798d200b008b2aba5fb22sm3627454ejc.206.2023.02.19.15.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Feb 2023 15:51:27 -0800 (PST)
Message-ID: <61ec44bf-227b-3496-4452-d0c686e8a180@gmail.com>
Date:   Mon, 20 Feb 2023 00:51:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4/5] hwrng: meson: use struct hw_random priv data
Content-Language: en-US
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com>
 <4dafc70f-be7f-bfdc-8845-bd97b27d1c4c@gmail.com>
 <CAFBinCAL+UdDm6P-AhEkS-M7nR=HkFJQ-nijZU8qgp7ZCJ2aww@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <CAFBinCAL+UdDm6P-AhEkS-M7nR=HkFJQ-nijZU8qgp7ZCJ2aww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 19.02.2023 19:26, Martin Blumenstingl wrote:
> Hi Heiner,
> 
> On Sat, Feb 18, 2023 at 9:59 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>> +       void __iomem *base = (__force void __iomem *)rng->priv;
> I find that "(void __force __iomem *)" is the more common order in
> other drivers. Which of these is correct is something I cannot tell
> though.
> 
I just looked at this one:
#define IOMEM_ERR_PTR(err) (__force void __iomem *)ERR_PTR(err)
But right, both orders exist.

> Also I would like to hear some other opinions because to me the code
> was easier to read before.
Right, if possible I'd like to avoid it too.
However it's the prerequisite for getting rid of struct meson_rng_data.
And this simplification outweighs this small drawback IMO.

> Your way is shorter and may save a few bytes (including alignment etc.) though.
> 
> 
> Best regards,
> Martin

Heiner

