Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0DAC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 18:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0820D6140D
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 18:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhKRSWy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Nov 2021 13:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbhKRSWy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Nov 2021 13:22:54 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84694C061574;
        Thu, 18 Nov 2021 10:19:53 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 137so2659010wma.1;
        Thu, 18 Nov 2021 10:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=00Dxvbq1Fs3MMMpYVcBCoVgT8ZGNOOp9XPEQ3Wpw9v4=;
        b=KORdkzGuQ4IGREFApHAper+Vh5XPk7rpVwouPUAUB4MVXqFc7pAxzZz+W3385+/EDA
         jzayUSZfmsAl3OkuMHAQGtvGRA/xn3grbUUF6Vu8EGoTSHAlsI6Nm5gbxRi36IebRW5o
         pqm+QAi5P5khGWxFstDeBneAaS4KxzdhkKyLqdcg8ns6MJIIC4RUgmMmvz6yIaX0baW+
         WfaQsh+oQxwtp+UwYTyYfuVlCDvl3aXz+fksu0b3D8G+WW+zhDfk6suV/2utSLDUpYO/
         WqgCcIKzodNhfgBUURtyW1E56UyYk94s7MSKreENza6l0w61Xy177Z2nc8bAljfLvM5d
         /X6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=00Dxvbq1Fs3MMMpYVcBCoVgT8ZGNOOp9XPEQ3Wpw9v4=;
        b=QA+u/gs1eIcrJLbdwLG7IjmU2wnmVrIGutfaGTYltq5qhe48l5FCN8Lir12BpWfydD
         y8cwr9FFfkxHq2iHAD+FzHJEmlpu+HwDYhNxWHCut3D+tNpAfb3a8q4j6HxczPuDuDdd
         yPdAgX2ht6xd8KGzctK0u4KiqtBiBhLXLNWsS3Ff1PVS/VhIrwMuVzMYablcbAPbj8mz
         BzntAlt8Zl1BQGktg1KuNRTMlYbAFAlJ0BvPVst+5seF/qiiBW0we7NeK0AHYHlHvK7A
         KZSdhLrFaQ/7noq+OIgXUrpMVI9LtncmMkE3TEHyfHw/1cVzESEwv/IJB8ARPLodJ9La
         l5rA==
X-Gm-Message-State: AOAM530wOlyEMQAA6foo0p1Cp4C6QxYD5WgQ9gnyI5TY2bPySahiD00C
        jYd1x9MpL3h0U1F60Kb/57wZijSBkmo=
X-Google-Smtp-Source: ABdhPJzLu0BYPHkuLanReInwXaHXHJCkti9VUlyrNj1um+J2BTGYu6Gl5aTVxGvRpm3vQ8WBoywlGw==
X-Received: by 2002:a7b:cd93:: with SMTP id y19mr11986192wmj.190.1637259592199;
        Thu, 18 Nov 2021 10:19:52 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id az4sm9863463wmb.20.2021.11.18.10.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:19:51 -0800 (PST)
Date:   Thu, 18 Nov 2021 19:19:49 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        devicetree@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-sunxi@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: crypto: Add optional dma properties
Message-ID: <YZaZRdAX1EA0kMP1@Red>
References: <20211116143255.385480-1-maxime@cerno.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211116143255.385480-1-maxime@cerno.tech>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Nov 16, 2021 at 03:32:55PM +0100, Maxime Ripard a écrit :
> Some platforms, like the v3s, have DMA channels assigned to the crypto
> engine, which were in the DTSI but were never documented.
> 
> Let's make sure they are.
> 
> Signed-off-by: Maxime Ripard <maxime@cerno.tech>

Good timing, I started to work on adding DMA to sun4i-ss.

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
Regards
