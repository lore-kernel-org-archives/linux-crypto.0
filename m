Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43CFC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 22:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E4276525A
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 22:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhCHWCt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhCHWCQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 17:02:16 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25B0C06174A;
        Mon,  8 Mar 2021 14:02:15 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id t26so7330094pgv.3;
        Mon, 08 Mar 2021 14:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=teXBaIPmj8mJ8GcckoOf+oVhLmcH40XiMMZr4uyARUs=;
        b=dm8fmGwgwpr+sA4DhL1YEGKp63XpY++NP2HLFhCafoNVW0bJPIIRt/4CXYNim9vATQ
         uP/jfJ93lhmtWmqlW/UFGtozFihUrUc8oNCvIO58/d4tuaYqD1A3IFYlrYBzSmwx7n+9
         3YjvIBuA7wGEOaSTvsBMqtq2m6iriFB71Q0y4odKIj8S0fTrq3/uw2Y9YPrHEE+h0UKk
         G8+8j8eFWq81qkW/ETzcQJvbkwtnvE4xVg40eDfpsFfCss4LmxfN0vUDrjWX1VokDjWR
         1+C69prIpeoLXOZAK+XGd4/QMKzWKV70jMDLG4SVV55g1yyVafOjx/pUY3dsRmUPpyMi
         2P0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=teXBaIPmj8mJ8GcckoOf+oVhLmcH40XiMMZr4uyARUs=;
        b=RD9HiO3lHJ38K0d2khV51fy7Eg7Vu0pE2PmP/mqqpKTGhCQX1kI+gI6S+CJr3kVyIc
         fdBDiHEjdebi8eabFy7ccusXC73IUBgmLWHB9IGeiHjqGg9nlj7RE72Yz7v8i5W7mH0X
         c3Msi6hAU+uzJP/GfMUuNlksBoUaZLjeKcxsH59Tbyg1kt/wP+cpCIjmSBbiwBnKq03e
         N+AGxXx0fC45k7kvMsosKn9Pzt0jcxuzPgUdtB5W1y2sX4tydIHVjcTpCKqm6iKudUaV
         Rr6NKeHJkh+PNtrdxUo9Rh1EZ4CL0KJRM/igFMP0LrCJ7ARKTb/qvyaMO36zPc2ztiRh
         K9Bw==
X-Gm-Message-State: AOAM532UEtGn8t1L7XZEzaSWj+jgM5kJopBbf/a7weRRvjvlB8tRs+1l
        dfcGHTtUgkkeEumm3La7OmwA+fpKXno=
X-Google-Smtp-Source: ABdhPJzbBsE1eW2reN0b5cCZScQH4rKtcESorPCQKKRMuVuAmJTKwQqsYqxUUq9S5qO4s/4e+wfE2A==
X-Received: by 2002:a05:6a00:894:b029:1dc:2f68:5f0 with SMTP id q20-20020a056a000894b02901dc2f6805f0mr22375365pfj.23.1615240934963;
        Mon, 08 Mar 2021 14:02:14 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b17sm11655969pfp.136.2021.03.08.14.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 14:02:14 -0800 (PST)
Subject: Re: [PATCH v6 1/3] dt-bindings: rng: bcm2835: add clock constraints
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
 <20210305070132.2986-2-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dd42370d-626e-4846-19ee-c90dcc27f835@gmail.com>
Date:   Mon, 8 Mar 2021 14:02:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305070132.2986-2-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/4/21 11:01 PM, Álvaro Fernández Rojas wrote:
> brcm,bcm6368-rng controllers require enabling the IPSEC clock in order to get
> a functional RNG.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
