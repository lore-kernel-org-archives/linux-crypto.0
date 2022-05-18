Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85327C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 18 May 2022 22:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiERWFw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 May 2022 18:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiERWFm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 May 2022 18:05:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B234ABF66
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2022 15:03:38 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ds11so3406510pjb.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 May 2022 15:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iMSU8o/vmnYNF8oQukQMHTmX2hEc142qWw/OVQkloYA=;
        b=MOOXL5WVm4dB91B2uKf9xSR4S+HJHSL0TSMbqIdkTz9lYASuHqAVOAh95f3WbJIGEb
         2IaGHgmG9CFXLXuPdZupCWf8T178NlwE1qWO2jFgLEwYvF+sfpOK8l6uvCeDw5Wt4s/P
         33mlqihbA8q89DMJJhJswWsj/E81EP1S3Q2TM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iMSU8o/vmnYNF8oQukQMHTmX2hEc142qWw/OVQkloYA=;
        b=Vhh1opKaoqdkZYD/wE3QhORpLpwmkkUs/yzzBXCwb5Q+0btjOGwVpOwfDcXpjCmwsL
         oNG5mNgMd3Yow+Ow/Fkra7+EGMFJuy/r4vobQlcGgQs8ZY7mMMRR5dssjeBrmgS2KMqA
         HC9CwHuvH/D2YepuNN/urd62Bt/uMTcj8bRz7jeDz29YGGmuZwSs72dn/AKlqgJrEPSr
         PsV4yJ+LkoeVbqkXgP+dmSGJzBgKgNyfx5Q0/bxZZs9e1Ah0XsXbxZkwjWiukSG1j1zK
         UEMDLYUWw5zAopQAyDRKvHdK+uG48tIpKfXi4ngFeiLsip28kW7rftajQhB7COVthRJp
         O46A==
X-Gm-Message-State: AOAM531VrzlpAE8RKCjjBjpjcc7ZRV4yTWupOt75BbXI0nDK4pehLO9C
        3i23mqYNr4hLz42tNRe2gCrGsA==
X-Google-Smtp-Source: ABdhPJy+E8w/oaLMW4XqP48igVHAKcm8FsJk8ICdSbgkBYqluSRAo5HHX3Oe93HcFbp3abQCi2+fww==
X-Received: by 2002:a17:903:1c3:b0:161:8b3d:7948 with SMTP id e3-20020a17090301c300b001618b3d7948mr1426496plh.158.1652911418065;
        Wed, 18 May 2022 15:03:38 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p42-20020a056a0026ea00b0050dc762818dsm2529221pfw.103.2022.05.18.15.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 15:03:37 -0700 (PDT)
Date:   Wed, 18 May 2022 15:03:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, gustavoars@kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3] crypto: Use struct_size() helper in kmalloc()
Message-ID: <202205181503.AA72D88E15@keescook>
References: <20220518062518.236965-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518062518.236965-1-guozihua@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 18, 2022 at 02:25:18PM +0800, GUO Zihua wrote:
> Make use of struct_size() helper for structures containing flexible array
> member instead of sizeof() which prevents potential issues, as well as
> increase readability.
> 
> Reference: https://lore.kernel.org/all/CAHk-=wiGWjxs7EVUpccZEi6esvjpHJdgHQ=vtUeJ5crL62hx9A@mail.gmail.com/
> 
> Signed-off-by: GUO Zihua <guozihua@huawei.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
