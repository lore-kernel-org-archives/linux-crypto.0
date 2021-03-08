Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02603C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 22:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C70BD6516F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 22:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCHWBJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhCHWAu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 17:00:50 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C550BC06174A;
        Mon,  8 Mar 2021 14:00:50 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id w18so8002065pfu.9;
        Mon, 08 Mar 2021 14:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6z4njqmMZ+DwPOGmWJZIpqGepW0eHMQJ/pIsjwxEZLk=;
        b=holCDmIXdIHZxMwwDTqjo4oLDs+wJi7GiE4T/V4gofktpeVHUS9zljHZCp6RHTJ4HX
         zJSwAgdxk4sZDIU1oOG6QaC0wn8w+vHUgn8/A2bRCHL6ALeDivZwOJaRo431fX3yfhY9
         pepBDk7Tb4VmgSVi1sxcPQqpQAIuUd1bU/HGt/edej2xZl9ne1kDVuu4QaFIoI3CC7QQ
         M5Fxachme2Mai22nDOThNgZyvxnhnIleExyZPYpDri0kwOdpK5JulwoEyYzHoKQpHwJm
         JELbctlGlwKd3nfiaXdJGRyAE4JtsG84loXQ7yiEQ7O6HEVI4pLDMJr4GZOTUejMznF2
         Q4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6z4njqmMZ+DwPOGmWJZIpqGepW0eHMQJ/pIsjwxEZLk=;
        b=DyqTZ+clg10ddqdzA4x27aZMVZqSNuwkC8rNjv+h4WpW5YddBwEaRv7jsElIQleJzw
         Q14xQe6TLGgo9NaiDFNlTO1RUFARkiac+zmE7XK6WitHtk7lXcmjj8AXUcdrVTHMeh0j
         30V82MGojjUfSVM25kGRLTVhFYX7ASCzCPUD1s45LJ00Cp5qVazfSc6r/PegPP5WhH7l
         G1LXyg1h1fxiiF6gGcp2jLhDx2dhKeC5uP9NUGnchZuIWhHx6UZ+B9LHXpfK7XdNwTtX
         9QgYv5Ad7eukpQVjytZT+gJ4WzggEgQemF2/MxfTPf+LvK36BWNZefPijV5uF6gn/shs
         5O4Q==
X-Gm-Message-State: AOAM531j5C/mzgXdIROcg/P4kX8TkHaYHwWCk8+YRZZ9jQLLhvH2KSC9
        urouxTcQoFmGwEC5C8Ylv23LaAMyv28=
X-Google-Smtp-Source: ABdhPJywAeKzFawn0EKfgcKGFbomGus3wQHovVhP+cXvqYZgKoek4JIzkzvCda5UsHWUgxUsuFYwSQ==
X-Received: by 2002:a63:fd01:: with SMTP id d1mr21337894pgh.319.1615240849966;
        Mon, 08 Mar 2021 14:00:49 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 133sm11524949pfa.130.2021.03.08.14.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 14:00:49 -0800 (PST)
Subject: Re: [PATCH v6 3/3] hwrng: bcm2835: add reset support
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20210305070132.2986-1-noltari@gmail.com>
 <20210305070132.2986-4-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <23d9ea3e-4eb2-a327-2b3c-bfb78a46007f@gmail.com>
Date:   Mon, 8 Mar 2021 14:00:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305070132.2986-4-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/4/21 11:01 PM, Álvaro Fernández Rojas wrote:
> BCM6368 devices need to reset the IPSEC controller in order to generate true
> random numbers.
> 
> This is what BCM6368 produces without a reset:
> root@OpenWrt:/# cat /dev/hwrng | rngtest -c 1000
> rngtest 6.10
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 0
> rngtest: FIPS 140-2 failures: 1000
> rngtest: FIPS 140-2(2001-10-10) Monobit: 2
> rngtest: FIPS 140-2(2001-10-10) Poker: 1000
> rngtest: FIPS 140-2(2001-10-10) Runs: 1000
> rngtest: FIPS 140-2(2001-10-10) Long run: 30
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=37.253; avg=320.827; max=635.783)Mibits/s
> rngtest: FIPS tests speed: (min=12.141; avg=15.034; max=16.428)Mibits/s
> rngtest: Program run time: 1336176 microseconds
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
