Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20566C6FA86
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Sep 2022 06:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiIQGyZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Sep 2022 02:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiIQGyW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Sep 2022 02:54:22 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3A45A88A
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 23:54:19 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d2so3699255wrq.2
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 23:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=1Nafsqgi+ey0lvESaq3P7Ed7c4PrgjcfWmeY/VtoS1k=;
        b=hbkqdT6B0JIb5xRyjQ9vZaFUiaE2784NvVaLLdQGt0tGmAIHQd+hEL9UVXJH1zpQ4R
         COcXfoxwhqnGAGGBffs3stiK0ijUBpxN7VoS8CaS2+4RWy9GzMo451qN69Ds1g2SByw/
         QpH3scY0uUqXaUnKvc6rMjkHEIVNokwIi/buUXRd1CpTmHX+n5q8pavaxJPWENFfe4wA
         k02b2clrS17Vx0PnbZfgusllPmk3xuFShima1mei6+iYOVPgoR7YE38bHbFqVrFZCFfj
         VKS8VY0zKBgj1XZz9++/pZgyEMWkv/UpPog52PskeqVS2dxzNHCcVwS6RfnHh4b3MMzh
         Wyxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=1Nafsqgi+ey0lvESaq3P7Ed7c4PrgjcfWmeY/VtoS1k=;
        b=yU32EHw173+c3FSvcEFsO0EtYYJ2o92RxBU4eYg3so7n/eQ2PRh7ZeSxDkXtwX+c9r
         F6oO+x1yArl2WA8w3ELib7PYxMUirlyb2caxEdgTBFHWqa2elMjVE+Xha1rqA9G5IpE4
         UhiKSzXZHyErQ1yGEhqOHNPqpbYBeNEhQsK16scVpZkZI93tyuFPYcEpbjuu9rZf44Hm
         rPzjvGNqRyKHjvhlFLTl2X3FAZuOyg9qk0AQMOUxBMYIiDtHDKykwP22B3A46UPIvnBn
         TjpCHDrGcbBZ3cd7ZoOtbrw6I86ivr7eZT5+q7JAGOR96LYdcR5YURsEAhOtE9T6lJMc
         /sTA==
X-Gm-Message-State: ACrzQf2wK6IML95KA+M727kQr3JS5h5RUNMGB+SUR/vUN3zEnxfW0dHe
        yHPiFLb6VXbhvkGeCEOmjuo=
X-Google-Smtp-Source: AMsMyM5SsjWaQCzqj9tgf7b/iw1sUIKuj+Zy1CSKV2OTWTOy+/oMLHzvkEOg7w1SPFKKUgSNUsyKgA==
X-Received: by 2002:adf:d088:0:b0:228:a789:ce1f with SMTP id y8-20020adfd088000000b00228a789ce1fmr4683212wrh.461.1663397658016;
        Fri, 16 Sep 2022 23:54:18 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id d18-20020a05600c34d200b003b2878b9e0dsm5051092wmq.20.2022.09.16.23.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 23:54:17 -0700 (PDT)
Date:   Sat, 17 Sep 2022 08:54:14 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH] crypto: sun4i-ss - use DEFINE_SHOW_ATTRIBUTE to simplify
 sun4i_ss_debugfs
Message-ID: <YyVvFgHri4UmFOAU@Red>
References: <20220916141340.2174495-1-liushixin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220916141340.2174495-1-liushixin2@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Sep 16, 2022 at 10:13:40PM +0800, Liu Shixin a écrit :
> Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.
> 
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> ---

Hello

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
