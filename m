Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C65C05027
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Feb 2023 17:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjBSR2E (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Feb 2023 12:28:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbjBSR2D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2023 12:28:03 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB59D509
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 09:28:02 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id c65so3479688edf.11
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2023 09:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uceSLfTcrpp2TxT0t+zM3u/1SNJQwihc1mRmxGjh/SY=;
        b=JNVWymAHxpqHkh7RLIUhXRV9m0Mz/kRVeTx2aURgVxnkF5gnikUKbhHziRVkde/M3O
         gIQZZuGjc9O8YDbGlriq0QBD/1uyAc/Fyqj41Tqi8pjaPIBWnfB4Ve+cXEC/3arzK3Dm
         01TUYmdN03WXyzqQ6gPdexuKg+OrBSuF8Tt2m8IQgkau+006R71G55Ursrv4/p8LgLkx
         Z1LKCwBDaSuY5IYhiVbV9V5MaLtznKVMGCgNCl9IPIyKS9zK5ma/Hg6+5HRXjmcmL0D/
         QqnjPlreXzTxNsckXwQ/K0q0arqwoiqIclZdKoOIV2lLljUjwjJK0qnkdm52fhrIuJ0m
         tXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uceSLfTcrpp2TxT0t+zM3u/1SNJQwihc1mRmxGjh/SY=;
        b=hSnB3dlBnGsGHuDs61gLGJ+trC5TJCQhYJlxt3LdIPuB9ZI6sZ+oG4CW5xnfxHXza4
         a2xuC2u0GfpXQOpC7rwqhcvO9gCyTmZAwPsNl/ISFSCv57eC9pbV2tdPGj6yJDSWwQ5C
         HaAXP4wVcTiJV3d/7s2y5pjd4FL7Tu64WQ9BAKZVtq2+AhDmSfyoJ1YNjoHhrKQ9GZaa
         vlCs0ec1u0G957ZcvayAITK+DWcWEC0X4sSpoVU3QG5KjKqWatGopYGcbAjB6MOaQdG+
         DGFXlWpSzP7kp/OECucKF0uzMIYrie/qVZ6VqA51cH8HONZ10do4KMszriFWeVdCjZwP
         9lhg==
X-Gm-Message-State: AO0yUKVRecob3eQAkyvnNeo95aQItl1pYq8Y48OEueqo2RYaJWKDAUUM
        vjMACiRkcL+Z60xCajvelk1LLJWyLM31VVGJ1PM=
X-Google-Smtp-Source: AK7set8zR7Cd9va+awR8PhxfSuqRAd8HKCi0xciYlAGKLxP71ZvO0916KwyJz2bydQ1QrP6ZyoF8peOQbYYBvGSGYpc=
X-Received: by 2002:a17:907:2be6:b0:8b1:3cdf:29cd with SMTP id
 gv38-20020a1709072be600b008b13cdf29cdmr2852937ejc.6.1676827680101; Sun, 19
 Feb 2023 09:28:00 -0800 (PST)
MIME-Version: 1.0
References: <26216f60-d9b9-f40c-2c2a-95b3fde6c3bc@gmail.com> <abd9a2ce-5b9b-c6bd-d3bf-8791d4005231@gmail.com>
In-Reply-To: <abd9a2ce-5b9b-c6bd-d3bf-8791d4005231@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 19 Feb 2023 18:27:49 +0100
Message-ID: <CAFBinCApc0-_BWaUmtiBuFEN+=BVDVoo9boaxnYPsjfktvC_Cg@mail.gmail.com>
Subject: Re: [PATCH 2/5] hwrng: meson: use devm_clk_get_optional_enabled
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 18, 2023 at 9:59 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Use devm_clk_get_optional_enabled() to simplify the code.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
