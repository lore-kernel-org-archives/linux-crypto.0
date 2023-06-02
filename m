Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEEAC7EE24
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 15:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbjFBPLo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 11:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236450AbjFBPLm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 11:11:42 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AF510E6
        for <linux-crypto@vger.kernel.org>; Fri,  2 Jun 2023 08:11:15 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-65131e85be4so1837309b3a.1
        for <linux-crypto@vger.kernel.org>; Fri, 02 Jun 2023 08:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1685718662; x=1688310662;
        h=to:from:cc:content-transfer-encoding:mime-version:date:message-id
         :subject:references:in-reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YrYBSW8qeXE8L8yfvdl8QinykFnJTuk07/XjwMoUeVE=;
        b=qu93yN+BiKoQR/bKXLpg56UTzaPfupYXZkwPAS/SM4sV/8V5hm62649tjUEpGP7YLW
         CTcl/91RCAuHjZlaVLKPhSq1JgbIhQ88RkyebHa/Ru9bQcq3orZF1/Phc0RHYqyK/txS
         4ygVpr4xdpOMgj96fS+DTrwY+vc2+sSk+p2eCCsYHGJhDaUmbzM5QUrHanNekHFnbv64
         kVnW8lRrLFGxezD/kIDCpKMfjO4phXPEtYQqJ0Qk1ZhLZ2WB0wNNOfrbrlUgTZGsFWPc
         AMGr7p26DJUfKXi09NOnK2bbdSdhTPsoLDw+CouGXT0eMAERoW7PF+x7a4qOBxCsePKu
         IJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685718662; x=1688310662;
        h=to:from:cc:content-transfer-encoding:mime-version:date:message-id
         :subject:references:in-reply-to:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YrYBSW8qeXE8L8yfvdl8QinykFnJTuk07/XjwMoUeVE=;
        b=BTINCZ3ZWhEJuU4gWJKx/85RdU43hZfxATciW+WavGCtgenJ8CxlRP+er4raA648GP
         jkHg/Gjbz+77Z7Ga4Z09Xn7oPYkqef9oP4k5b8xAcnCW69ie/GqiAmk9mEyG/wCd3wMX
         iLRN1y9L84Rkz3AemQYfL/NUFpdgjoAzct2RK58tPLEF/cyz5TiNOLVjarFgYOMF2IZ2
         rigSWkDx6BxogBDZFqvA9WG2MdFecdMxZzWRhUVtaolOaGVzrAhoFoBp4Ef8w7+nI8VS
         BN5aP4IBFSl6PTQ1WB/k65/v05rb9ui7r4dyJcbjkLMZuD4wBEjmzBsnVFCTPb06UYus
         rP9w==
X-Gm-Message-State: AC+VfDyiPkrFZLxn3ZxX0m3zdxWP/MvoycXr/vhKJPpbTnQ/vgcGK3m8
        SplqCRoIw3gxcuMl98M80abYIw==
X-Google-Smtp-Source: ACHHUZ5lq868GyrBxPLkEgZi3NcLZ0qAOyZwshzbl/Lk7FSKdcWKA6GQThH1Jum2CNXd5wP4XzABMA==
X-Received: by 2002:a05:6a00:88d:b0:64f:5406:d59e with SMTP id q13-20020a056a00088d00b0064f5406d59emr17852377pfj.17.1685718662535;
        Fri, 02 Jun 2023 08:11:02 -0700 (PDT)
Received: from localhost ([135.180.227.0])
        by smtp.gmail.com with ESMTPSA id n12-20020a62e50c000000b00634a96493f7sm1114822pff.128.2023.06.02.08.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 08:11:02 -0700 (PDT)
In-Reply-To: <20230515054928.2079268-1-sunilvl@ventanamicro.com>
References: <20230515054928.2079268-1-sunilvl@ventanamicro.com>
Subject: Re: (subset) [PATCH V6 00/21] Add basic ACPI support for RISC-V
Message-Id: <168571787727.17224.6663458864222960682.b4-ty@rivosinc.com>
Date:   Fri, 02 Jun 2023 07:57:57 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-901c5
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Weili Qian <qianweili@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Marc Zyngier <maz@kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        llvm@lists.linux.dev, Sunil V L <sunilvl@ventanamicro.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On Mon, 15 May 2023 11:19:07 +0530, Sunil V L wrote:
> This patch series enables the basic ACPI infrastructure for RISC-V.
> Supporting external interrupt controllers is in progress and hence it is
> tested using poll based HVC SBI console and RAM disk.
> 
> The first patch in this series is one of the patch from Jisheng's
> series [1] which is not merged yet. This patch is required to support
> ACPI since efi_init() which gets called before sbi_init() can enable
> static branches and hits a panic.
> 
> [...]

Applied, thanks!

[01/21] riscv: move sbi_init() earlier before jump_label_init()
        https://git.kernel.org/palmer/c/24fc18087f42
[02/21] platform/surface: Disable for RISC-V
        https://git.kernel.org/palmer/c/7f2e20459b28
[03/21] crypto: hisilicon/qm: Fix to enable build with RISC-V clang
        https://git.kernel.org/palmer/c/fbb995a7b27c
[04/21] ACPI: tables: Print RINTC information when MADT is parsed
        https://git.kernel.org/palmer/c/4d02d88d2b92
[05/21] ACPI: OSL: Make should_use_kmap() 0 for RISC-V
        https://git.kernel.org/palmer/c/214c236223b8
[06/21] RISC-V: Add support to build the ACPI core
        https://git.kernel.org/palmer/c/a91a9ffbd3a5
[07/21] ACPI: processor_core: RISC-V: Enable mapping processor to the hartid
        https://git.kernel.org/palmer/c/8b7809e28952
[08/21] RISC-V: Add ACPI initialization in setup_arch()
        https://git.kernel.org/palmer/c/724f4c0df766
[09/21] RISC-V: ACPI: Cache and retrieve the RINTC structure
        https://git.kernel.org/palmer/c/f99561199470
[10/21] drivers/acpi: RISC-V: Add RHCT related code
        https://git.kernel.org/palmer/c/e6b9d8eddb17
[11/21] RISC-V: smpboot: Create wrapper setup_smp()
        https://git.kernel.org/palmer/c/61946127ab49
[12/21] RISC-V: smpboot: Add ACPI support in setup_smp()
        https://git.kernel.org/palmer/c/ce92546cd637
[13/21] RISC-V: only iterate over possible CPUs in ISA string parser
        https://git.kernel.org/palmer/c/914d6f44fc50
[14/21] RISC-V: cpufeature: Add ACPI support in riscv_fill_hwcap()
        https://git.kernel.org/palmer/c/396c018332a1
[15/21] RISC-V: cpu: Enable cpuinfo for ACPI systems
        https://git.kernel.org/palmer/c/0b144c818989
[16/21] irqchip/riscv-intc: Add ACPI support
        https://git.kernel.org/palmer/c/7023b9d83f03
[17/21] clocksource/timer-riscv: Refactor riscv_timer_init_dt()
        https://git.kernel.org/palmer/c/cd12d206685a
[18/21] clocksource/timer-riscv: Add ACPI support
        https://git.kernel.org/palmer/c/21f4f92410dc
[19/21] RISC-V: time.c: Add ACPI support for time_init()
        https://git.kernel.org/palmer/c/714aa1d1c8ca
[20/21] RISC-V: Enable ACPI in defconfig
        https://git.kernel.org/palmer/c/0b8e15ca0082

Best regards,
-- 
Palmer Dabbelt <palmer@rivosinc.com>

