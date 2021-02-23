Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBAA8C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 16:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 879A364E68
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Feb 2021 16:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhBWQh3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Feb 2021 11:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbhBWQhZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Feb 2021 11:37:25 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB79C061574;
        Tue, 23 Feb 2021 08:36:44 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id kr16so2181879pjb.2;
        Tue, 23 Feb 2021 08:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jCm2d3L5ztm5gNWKp8iMLVnKNDCN56Zh/hTZRK0Phyc=;
        b=l2nVT8bm3BGfG8Ch7gFLdDuL9NxQKaHyXV2x9Et5MwOSmcpiCW7bGRdkmbbfEP41u5
         oI7Z6alDO9dABx/qtmVe/OwTuYJawOszEXeMUQSUBYIbZLL3sPCeoo8Li12QHZKhve+8
         /vZUkbcD3KTLQoVHEFeS0YQIp0bl/+dN44A0mv68dts/q/Ct+xueRrAmxO7tm98AB1Wh
         R4p59h1ElTaqdC2y1kTU50NToiYxOvMyAMPT3DMSfUdI6vgiDsybj1fhxmfuUna7xg/Q
         xc+K+ir4ufho8nRkSpcmbL9bhgQBoBVeDn3XfizOyfpMa7xD7us6KM66foVN6RsDMimu
         pK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jCm2d3L5ztm5gNWKp8iMLVnKNDCN56Zh/hTZRK0Phyc=;
        b=FU4UZJCL9xSWCxzMhOEQeFCqb0KslxhxchJRFieQcbhn14ABs7kAFj3xkAM10DWn0x
         a20warbDbpNz5TITFIwk39h4QhILba8SJjdQFjYK79/feQrUtM7ttPBTDAdxqOBgJv6L
         1WziUyb1C95Ob2s1c05/b6zpKyPjA++Zd8cwddHfLIVcCId1KxmOYHy2k6/mAxBWSEen
         RUW3jPevkc0/myPwM3947Oj1zKnI9LZthhoHFNGQ4qSCiO0+PbmjcZynHBg/ICly+Qua
         JyXHtBkZ7N6PLIW1HPFjoQOkHvR1ikjphpy3r/55PHj3UudzFkmYX7Kk98sd+gBVBncX
         ARUA==
X-Gm-Message-State: AOAM533RL+I7iUyShgALTLavxzcl/cbRu5yzvWVhNOu6A9JY3bXHWvkO
        cEItmgnfoEDOIZ00BTzvrXx7hRPaJfA=
X-Google-Smtp-Source: ABdhPJzoisW/SI8uGhoOap1b4A1t7Rqs8Z0p7ao0J30ZnnzN8py2Zu4XLLOhuUOXMuMLo4ocWc+jrw==
X-Received: by 2002:a17:90a:df12:: with SMTP id gp18mr27390877pjb.25.1614098203460;
        Tue, 23 Feb 2021 08:36:43 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x184sm15689761pfx.2.2021.02.23.08.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 08:36:42 -0800 (PST)
Subject: Re: [PATCH 1/2] dt-bindings: rng: bcm2835: document reset support
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?B?TsOtY29sYXMgRi4gUi4gQS4gUHJhZG8=?= 
        <nfraprado@protonmail.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210222194510.14004-1-noltari@gmail.com>
 <20210223160131.29053-1-noltari@gmail.com>
 <20210223160131.29053-2-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1b854f38-9322-71ee-5745-ee650ae92c9b@gmail.com>
Date:   Tue, 23 Feb 2021 08:36:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210223160131.29053-2-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2/23/2021 8:01 AM, Álvaro Fernández Rojas wrote:
> Some devices may need to perform a reset before using the RNG, such as the
> BCM6368.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Since the reset is unique to the 6368, you may want to make the property
mandatory for the 6368 compatible string and optional otherwise.
-- 
Florian
