Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 572F9C76188
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Apr 2023 10:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237711AbjDEK4L (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Apr 2023 06:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237644AbjDEK4G (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2023 06:56:06 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB99A59C4
        for <linux-crypto@vger.kernel.org>; Wed,  5 Apr 2023 03:56:04 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so36855008pjz.1
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2023 03:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680692164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qHjNmNubtW1m6x/ZHSROLzC6UE26oZx7ZrLiozJA6N0=;
        b=cDCnQAlVg9wphWyj020XoXu348UrwEHznmRRm3HENM8CHxPrsB4ftiLhtCukY5QAS1
         CwBBjAHsCSYAMx2GgBoncQw7+9YyR71AMr2GaaRR1lRn7sqbWtNwZfzyNbyrEJTIWSeP
         lpvajki5RiSaNzESIU3JMJZqDQcCUfxS4Nw351KgGTvAex3xD9lBOO/ZlgPSdCLXZQWE
         yt4H/DUHQl8arz3OuSIFiy9Y9v0m5Ve3DxDtYTut/wSWZ0NOL44uMcCpCzSgL/p5n0Ao
         d+rZSPbZuqfD52fpeaM2haOafL/rVPiGAqsWfMj9b+EVyRJk7i0D2c2bvyVZAlW2jOEM
         hjtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680692164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qHjNmNubtW1m6x/ZHSROLzC6UE26oZx7ZrLiozJA6N0=;
        b=bcZpyRUSkPJxPvvgkU1HNX4A45y5mrdGdSB6AUmWGZcXHtjZsoI1jwGOZfbLfleebt
         sRsWi8RHv1eZBdxZ51zEuYNbqRkvWV93umESG907iZ2GITCfk/XwVX93WJy/+G0MTD7x
         HmaZjgVo/WYW7mb6QN4D8BQohOamS5wW/cqIiHI3WML9Atd5c43FbDrFICOgrZyp0dKI
         BudaC6yy0t3RiChJGpJD1JBgYU32cCozHa7A1Ym2uQFvvfKLzmTLiBMo8hrf6DMySHVk
         LvXIjOVxAVP+/q7YFOv3yJq3L3BkSzHGl8q0Glha3WrQ45ZiVzVi6gwuWQcCexlREEVe
         CxBw==
X-Gm-Message-State: AAQBX9dpC4Y4GxVkVpDhSR3CeCOnZzxSz+paa5KHoT7vxKGVMa3iEz7u
        MgG6jFsja3fqr0qdXS0qdrC73g==
X-Google-Smtp-Source: AKy350brsIvQ17YKEK+9sMHxvtlGFWTIhRtaYlWAqmfzPxrLO54umhrjiJOK/GO6T6r+7/92elotug==
X-Received: by 2002:a17:90b:4b46:b0:23b:4614:6f84 with SMTP id mi6-20020a17090b4b4600b0023b46146f84mr6472024pjb.28.1680692164415;
        Wed, 05 Apr 2023 03:56:04 -0700 (PDT)
Received: from sunil-laptop ([106.51.184.50])
        by smtp.gmail.com with ESMTPSA id d14-20020a17090a498e00b00234afca2498sm1077701pjh.28.2023.04.05.03.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 03:56:04 -0700 (PDT)
Date:   Wed, 5 Apr 2023 16:25:49 +0530
From:   Sunil V L <sunilvl@ventanamicro.com>
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        llvm@lists.linux.dev,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Tom Rix <trix@redhat.com>, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Len Brown <lenb@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Anup Patel <apatel@ventanamicro.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH V4 16/23] clocksource/timer-riscv: Refactor
 riscv_timer_init_dt()
Message-ID: <ZC1TtYAELzHtTJTu@sunil-laptop>
References: <20230404182037.863533-1-sunilvl@ventanamicro.com>
 <20230404182037.863533-17-sunilvl@ventanamicro.com>
 <20230404-flatware-ditto-e5c71d5a36c2@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404-flatware-ditto-e5c71d5a36c2@spud>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 04, 2023 at 10:25:38PM +0100, Conor Dooley wrote:
> On Tue, Apr 04, 2023 at 11:50:30PM +0530, Sunil V L wrote:
> > Refactor the timer init function such that few things can be
> > shared by both DT and ACPI based platforms.
> > 
> > Co-developed-by: Anup Patel <apatel@ventanamicro.com>
> > Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> > Signed-off-by: Sunil V L <sunilvl@ventanamicro.com>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> 
> Forget an R-b or drop it intentionally from v3?
> https://lore.kernel.org/linux-riscv/c2c1bdb5-aee6-4f4c-9f7d-073917e75b88@spud/
> Please say why if you drop or ignore tags between versions.
> 
Sorry, missed those tags. Not intentional. Will update in next revision.

Thanks!
Sunil
