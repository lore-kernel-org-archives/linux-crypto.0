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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33E7C433E6
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 22:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD6476526C
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 22:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCHWCv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 17:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhCHWCb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 17:02:31 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C40DC06174A;
        Mon,  8 Mar 2021 14:02:31 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id lr10-20020a17090b4b8ab02900dd61b95c5eso1554232pjb.4;
        Mon, 08 Mar 2021 14:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jM0aMBmmhTztqgN5h3kB6FaJ9cykVJo290q6WIFV/eI=;
        b=FWz9weZU85PuPVqVTmVbWKrJiPbKr3/hfD1IoO30Jbx4LSsSDznxbUdKCnIUYJrkHA
         CA6o46KD54s/m4+l9AQdSYorr6V1V2FKw3BbMZEmgHnXPaktQh2Y0FGg9Yy8Ut3m+JO6
         8fdTQYQFY2OlHntEmdz+qAtRUZ3tOaJ7ax3S31/ELL+I5QzGc7gPKILEY5gIuJj0IlJe
         oAj8rNsjkNztBUiIXPVCmU5uaW/TL6WQaLWEu0Um3DWzfu1UX2KT1VY5L5CEn7crqNwG
         TyUgk5cp2W1wj9mYIMpWilyyH6oV5TEoavme8GJXEASVZyLcwug0dHESGXgg8Pv8Vmbc
         uaDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jM0aMBmmhTztqgN5h3kB6FaJ9cykVJo290q6WIFV/eI=;
        b=I4/nx/yuMEfwR9VYZgjclLwdmMCLv0pJc4FbIDfUNl2nLHME0xs5yyR/OSMa1uiQT0
         CJ1GfDmc49TP/hPx+OLb0NTg+gMiM71g+Wyi7U2+oz+i/Pa5T/RKAE3aMlf6lh8Dk7FN
         a3arKcccJraNFwfCGPLxHxmD8t+S0WK+NtD3jnpBLonXXQ/Fsp7KmL+pamr/XbI/Pq2J
         mD+10RGSapnJ5JbMI4SH2OBA40tInwHH7t7Bf/F/gXxJB40XgKsKiM+/9wwUSzplhW2h
         TKMtaiZJxFB3bLhRzbQxXsTwVnvaxIwW/NpRJsrNyNQYOv73Gbho71sPHvPuTtJ9XZBZ
         fGsA==
X-Gm-Message-State: AOAM530DLsFd01hfLehWRsLY0Jw2l9tlIYy0+kR3l5Ge/neOCNKs/KSQ
        NEJd8RagpFSAWf+BRa2HYa4uR8Ja+9M=
X-Google-Smtp-Source: ABdhPJx1VaDerbRTmifZWuqwadtQfQDsE8Uz9o05eIPsoNiNgc4x5yqTRtm5SopAlqPF2xGs5rdB1Q==
X-Received: by 2002:a17:90a:8b83:: with SMTP id z3mr1058447pjn.75.1615240950708;
        Mon, 08 Mar 2021 14:02:30 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d1sm340717pjc.24.2021.03.08.14.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 14:02:30 -0800 (PST)
Subject: Re: [PATCH v6 2/3] dt-bindings: rng: bcm2835: document reset support
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
 <20210305070132.2986-3-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <21e734f0-029e-7abc-da7e-fdd928590555@gmail.com>
Date:   Mon, 8 Mar 2021 14:02:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305070132.2986-3-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/4/21 11:01 PM, Álvaro Fernández Rojas wrote:
> brcm,bcm6368-rng controllers require resetting the IPSEC clock in order to get
> a functional RNG.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
