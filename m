Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87680C636CC
	for <linux-crypto@archiver.kernel.org>; Sat, 18 Feb 2023 20:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBRUyn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 18 Feb 2023 15:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBRUyn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 18 Feb 2023 15:54:43 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BBCEFA7
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:54:42 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id k5so6362819edo.3
        for <linux-crypto@vger.kernel.org>; Sat, 18 Feb 2023 12:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:cc:to:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DK5XEETTVTrrZxEXTasy9N6PvKUYlU5HJFHeLYnilDY=;
        b=bgN1ZBgDxVMQ74YqYyLeejoJGAfXJWiG6E1QljPwIK37cc6Ks0jInr/6GMjvsz/vRN
         fuiDPSLEQ0KEZVhZDv8Yy3YUOgOQrFplESDSa9rO3B4LYrk1FTFmJvy+q2RJ9cJZHrD/
         x3K3BC8QXwK638msOAT05CKBcwMrBiTbAtuBrkXDmBon9PihpI3JKGLlRRPay/KZk6ua
         ZxphAjzcG+9r6de0njRaecCez4K4Kb/1aX5KG55oQUlpwkQr5erurZLKHJyK33LTYyjC
         dMolSFSf6AqlRrMiJWTnUlV+U3lH597tZZE77P5XmH7J/nglxU7ppdQnJWMZyZgoO7eZ
         QG3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:cc:to:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DK5XEETTVTrrZxEXTasy9N6PvKUYlU5HJFHeLYnilDY=;
        b=FLZXDz6zbp5Z3dLwSaKaanEk8RgGKRbxkqH+Hn4iO/XCTpL4gXxsNFHF7BKPunmbtm
         xrKJBuamt8RCftM9B8hTjZ2qkbez+2ULCjeVBeDtA2QomeSI/2kswCvGVt571Bs9ov89
         WaCAcrvV0ZMqruEpVjMLe72/MTQ7kbylrVZOXzfC/eII86rWdzMZue5N/BKfDxHC8jxP
         2CYSNKMFj6JY1R8zYqfnobyh74bAvgMKeDvELs5c4zaYZDhmmSeIVJ8fOm+wFSZYbKf6
         OX0EUP/tcg9lyfdAtuew1VQpKzVRwzg/J9VQu+eu4RxL6wIubYRAFB4XfIxUm08Tyiwf
         XwPQ==
X-Gm-Message-State: AO0yUKUSwZAHk4VQFU48Avm9H8GcCYUtHchCFURutZE8q4fIpHANu6B1
        XeKKhxS8pNAbSreo8+S8LP8=
X-Google-Smtp-Source: AK7set9TVw3NKqj7ql+AjA4l5ud4fcePLJrEyibhkJI49/wU6gke2X2p9ZpVBXzPNT8A8c93MhkoDQ==
X-Received: by 2002:a17:907:d305:b0:8ad:d366:54ca with SMTP id vg5-20020a170907d30500b008add36654camr9917600ejc.23.1676753680736;
        Sat, 18 Feb 2023 12:54:40 -0800 (PST)
Received: from ?IPV6:2a01:c22:7b82:af00:2955:cfd1:cf55:9ea? (dynamic-2a01-0c22-7b82-af00-2955-cfd1-cf55-09ea.c22.pool.telefonica.de. [2a01:c22:7b82:af00:2955:cfd1:cf55:9ea])
        by smtp.googlemail.com with ESMTPSA id 23-20020a508e57000000b004ad7abf007asm584765edx.74.2023.02.18.12.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Feb 2023 12:54:40 -0800 (PST)
Message-ID: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com>
Date:   Sat, 18 Feb 2023 21:54:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Subject: [PATCH 0/5] hwrng: meson: simplify driver
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series simplifies the driver. No functional change intended.

Heiner Kallweit (5):
  hwrng: meson: remove unused member of struct meson_rng_data
  hwrng: meson: use devm_clk_get_optional_enabled
  hwrng: meson: remove not needed call to platform_set_drvdata
  hwrng: meson: use struct hw_random priv data
  hwrng: meson: remove struct meson_rng_data

 drivers/char/hw_random/meson-rng.c | 59 +++++++++---------------------
 1 file changed, 17 insertions(+), 42 deletions(-)

-- 
2.39.2

