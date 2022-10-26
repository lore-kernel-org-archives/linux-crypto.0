Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42675C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Oct 2022 07:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiJZHls (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Oct 2022 03:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbiJZHln (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2022 03:41:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF9EBEFB4
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2022 00:41:38 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j15so14384568wrq.3
        for <linux-crypto@vger.kernel.org>; Wed, 26 Oct 2022 00:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qX+c/eqfKIRmSzQ2TAxdY0LKUbRjF3m5mcG02oMGx8Q=;
        b=EGnZTiW4mN/u1L+KFftDWxXLRHrI00+AmvAaQQQ1bURMf22zv1OHtlPR/H7SUlo1xJ
         fTLksIEiBVk/vYtUiqhHH+WeQMz81sDDpni+g1os3iml+wBrTaKNtPzeQ2gi9kupiQXT
         iz7ggqhUEm8RugKYJkKqp+ZxE3PnQPjCAKtlF1m1brJaP3z5MqAuxVPc0vPN7sSxpbsg
         anaIGMEx4eOGC7OC8w5Jhy264e2k+OotLo1DqfjJEhvn5EhZWLsI3Kv3iik8lHFDUNrG
         il8K4Mejef+FYzG1mGYubXfdTuAIloBpBQv3eUuIaoVWb4faCOB6LwD+KrRuFx0eGNNO
         vyrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qX+c/eqfKIRmSzQ2TAxdY0LKUbRjF3m5mcG02oMGx8Q=;
        b=y97P907IOJUJhQ/aq9XGzMz4ehb3iwgy9aTSDk2MVNFCZd9E6Cfyf30uC6MEBxMy6Z
         eQhI3n0hwHdOQrLSYW8qnpIttZDj6kLvNZ1+jWtDrqe/7dVL3CcIIJzAY3tPfwLumwQN
         VRehxENjIHec/FYQrm5eoWLeWprvvl+vRhjh455pEv7k4Gz+dPMHHEbbZqWS2IogvHqO
         xr1Cnr9Nj4AkxM7+qNwKB8hIFybfNOvlT/FY03UWhYkR7LiCkEd2z6qwh8Id7q6SoZQD
         /0+x01nUnZ4Jzo8Q93fz0whs7NYf5ViFgAR4PzY6WO9kUq/nB5dpJt0H8SJHq3YvjqVq
         Y/3A==
X-Gm-Message-State: ACrzQf3pMzryejgt7qoW0JQqR/926VdSQ2IChpYvaV42c42d0rT7tqbH
        LG7iN1+P3d2rVTV87S3GOoQ21g==
X-Google-Smtp-Source: AMsMyM5S7b7nFZ2PlRcs8UPcZE5oWqjrYPqMzqX/eLf5/1gT4eLBzzOdYfUXPmu8eE/ZrDy9n/VKEg==
X-Received: by 2002:a5d:46c1:0:b0:236:6a2f:9e53 with SMTP id g1-20020a5d46c1000000b002366a2f9e53mr12098440wrs.256.1666770096085;
        Wed, 26 Oct 2022 00:41:36 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id bd14-20020a05600c1f0e00b003b492753826sm1054980wmb.43.2022.10.26.00.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 00:41:35 -0700 (PDT)
Date:   Wed, 26 Oct 2022 09:41:30 +0200
From:   Corentin LABBE <clabbe@baylibre.com>
To:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        herbert@gondor.apana.org.au
Cc:     ardb@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v10 00/33] crypto: rockchip: permit to pass self-tests
Message-ID: <Y1jkqiYjXT30/hk5@Red>
References: <20220927075511.3147847-1-clabbe@baylibre.com>
 <Y1KctXMZ1+c5uQqd@Red>
 <4780296.31r3eYUQgx@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4780296.31r3eYUQgx@diego>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Fri, Oct 21, 2022 at 07:09:53PM +0200, Heiko Stübner a écrit :
> Am Freitag, 21. Oktober 2022, 15:20:53 CEST schrieb Corentin LABBE:
> > Le Tue, Sep 27, 2022 at 07:54:38AM +0000, Corentin Labbe a écrit :
> > > Hello
> > > 
> > > The rockchip crypto driver is broken and do not pass self-tests.
> > > This serie's goal is to permit to become usable and pass self-tests.
> > > 
> > > This whole serie is tested on a rk3328-rock64, rk3288-miqi and
> > > rk3399-khadas-edge-v with selftests (with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y)
> > > 
> > > Regards
> > > 
> > 
> > Hello
> > 
> > Gentle ping since it is a month since this serie was sent and no comment was made (except some reviewed-by).
> > So I think it is ready to be merged, probably thought the crypto tree.
> 
> ideally everything _except_ patches
>  26 +27+28
> would go through the crypto tree.
> 
> So if possible I'd like to pick up those (clock + arm64-dts patches)
> after the crypto people are satisfied with the driver changes.
> 

Hello

I agree with this way.

Herbert any thought ?

Regards
