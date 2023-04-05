Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68650C761A6
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Apr 2023 10:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237812AbjDEKqo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Apr 2023 06:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbjDEKqn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2023 06:46:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAFF19B2
        for <linux-crypto@vger.kernel.org>; Wed,  5 Apr 2023 03:46:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c18so34006432ple.11
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2023 03:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680691602;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=otykqullkWmg0A8KD35JF+HvspAaLoRDA6Fr6QFOB1A=;
        b=UQ0uumG4XH81lWfK6pVQa6G5b2bhg0H+jTMz7NTZVbIIyh41o0CBkytB6xZpFe/MDh
         Yffh5qenGWrU9TxMdihhNju6UMyitiMEbH/S8wc2qQG1KulmNjPVmxbe+5lvAhEFomTo
         UVZm4lhSh/J0/m6bMtf8ttgxYxkKl7fMCt60yIF06Ptxf/mvXyFUkNGGUYB2n0DaTbEg
         azqFX9oSbODaFFg4PbBU08adA+7I25vr0zw2LIqhUF9vuMMdUc7mKurF6cxQ3IPMwZvq
         T3aNBPO0bWfwSYeSYziw6ebXlP1MKTFYUr1w/FPVCAfBHvf9/tdCNmCXNug8DyFs3WjS
         4MCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680691602;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otykqullkWmg0A8KD35JF+HvspAaLoRDA6Fr6QFOB1A=;
        b=n0MfGh+F/7zjAiLuOa7lH2w7MttUecZztczQV3x+q9HEgS+weO7+vnFACe/ALENuEe
         UElpk/IN3IhJc8u647RdM/ruVTfipiNoZd834uwebirMUONEucssBTZaH/UH5KJA6XUA
         rXSRYx7d2joSJM1He7DRpTlE89qfSDYOnCSis36AjzlvuXnuH1w+D48os/UbSVNKSIEl
         eDHOaSzo//l+oQ5h7e4dhzRmWGqXhsiKNkyzDqWBNn70DjGkGkX4IoRzcb/9M31OSZUp
         ytIKzHhkZbossgEcl/gBb2C3iR7YyyD92kD+VxrvM0Q4WPeBt6sQQV0ifAgvIh4t6F6a
         9wyA==
X-Gm-Message-State: AAQBX9edBAFILJNqWqqCnPFZBrSyU/MjeXUneQYrHaUnMf4gMXlI57mL
        dYr1MLQEk6GR43wfWTEv/SJVzmvrO5GNpGxmpRg=
X-Google-Smtp-Source: AKy350bK44iNVZ3LLDOTnB4w4y2fswThth90M15FEkZbqe29HOhrRwzj1s6JWfRQJI6BiNBgiUWAxA==
X-Received: by 2002:a17:902:e294:b0:1a1:8edc:c5f8 with SMTP id o20-20020a170902e29400b001a18edcc5f8mr4558701plc.56.1680691601853;
        Wed, 05 Apr 2023 03:46:41 -0700 (PDT)
Received: from sunil-laptop ([106.51.184.50])
        by smtp.gmail.com with ESMTPSA id g20-20020a62e314000000b0062b5a55835dsm10319322pfh.213.2023.04.05.03.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 03:46:41 -0700 (PDT)
Date:   Wed, 5 Apr 2023 16:16:28 +0530
From:   Sunil V L <sunilvl@ventanamicro.com>
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        llvm@lists.linux.dev, Weili Qian <qianweili@huawei.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tom Rix <trix@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Mark Gross <markgross@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH V4 23/23] crypto: hisilicon/qm: Workaround to enable
 build with RISC-V clang
Message-ID: <ZC1RhA1Wi0B54sTO@sunil-laptop>
References: <20230404182037.863533-1-sunilvl@ventanamicro.com>
 <20230404182037.863533-24-sunilvl@ventanamicro.com>
 <20230404-viewpoint-shank-674a8940809a@spud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404-viewpoint-shank-674a8940809a@spud>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Conor,

On Tue, Apr 04, 2023 at 10:59:41PM +0100, Conor Dooley wrote:
> Hey Sunil,
> 
> This one made me scratch my head for a bit..
> 
> On Tue, Apr 04, 2023 at 11:50:37PM +0530, Sunil V L wrote:
> > With CONFIG_ACPI enabled for RISC-V, this driver gets enabled in
> > allmodconfig build. The gcc tool chain builds this driver removing the
> > inline arm64 assembly code. However, clang for RISC-V tries to build
> > the arm64 assembly and below error is seen.
> 
> There's actually nothing RISC-V specific about that behaviour, that's
> just how clang works. Quoting Nathan:
> "Clang performs semantic analysis (i.e., validates assembly) before
> dead code elimination, so IS_ENABLED() is not sufficient for avoiding
> that error."
> 
Huh, It never occurred to me that this issue could be known already since I
always thought we are hitting this first time since ACPI is enabled only
now for RISC-V. Thank you very much!. 

> > drivers/crypto/hisilicon/qm.c:627:10: error: invalid output constraint '+Q' in asm
> >                        "+Q" (*((char __iomem *)fun_base))
> >                        ^
> > It appears that RISC-V clang is not smart enough to detect
> > IS_ENABLED(CONFIG_ARM64) and remove the dead code.
> 
> So I think this statement is just not true, it can remove dead code, but
> only after it has done the semantic analysis.
>
Yes, with more details now, let me update the commit message.
 
> The reason that this has not been seen before, again quoting Nathan, is:
> "arm64 and x86_64 both support the Q constraint, we cannot build
> LoongArch yet (although it does not have support for Q either so same
> boat as RISC-V), and ia64 is dead/unsupported in LLVM. Those are the
> only architectures that support ACPI, so I guess that explains why we
> have seen no issues aside from RISC-V so far."
> 
> > As a workaround, move this check to preprocessing stage which works
> > with the RISC-V clang tool chain.
> 
> I don't think there's much else you can do!
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> 
> Perhaps it is also worth adding:
> Link: https://github.com/ClangBuiltLinux/linux/issues/999
> 
Sure, Thank you very much for digging this!

Thanks,
Sunil
