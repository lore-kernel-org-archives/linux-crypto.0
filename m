Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C10FC77B73
	for <linux-crypto@archiver.kernel.org>; Mon,  8 May 2023 11:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbjEHLxB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 May 2023 07:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbjEHLw4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 May 2023 07:52:56 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEED461B3
        for <linux-crypto@vger.kernel.org>; Mon,  8 May 2023 04:52:54 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1aaed87d8bdso30294125ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 08 May 2023 04:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1683546774; x=1686138774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2Y6V/YituSxYMT9MKT/kC3H8mpZSafPKSyryqKuDM4=;
        b=V3nYn5EL0y1Ojcml3lwOj2QjAW7B9L25T1oC99mYgTjiDU2F/e+SV1rumPYxsFvn2i
         pykgj+wvD0+FHHjlsCQDBaOKA/tQl1oXAlZaWzQjUQc4HrLq+aSkMaeYaOkdPHSmsgOy
         QMG6QPBWu11XcTx7k8V/3DL7eBvxuysW3cQCTPGbF/cp4feril8E6yJTmY1uewsrnQVK
         ZG0ZXSIdWYPZ7oUD0gZEsgMESfvwsSstF6miQxya+tzM4IdKnFpNNc5aNxAsPLAYJNXF
         WkOhoua8NR0VbgYL7CBx4w5ctn9OMlE/2UnkywoGlNQajIqLkzv6w5I/A/h4gRPRmE75
         9Slg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683546774; x=1686138774;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z2Y6V/YituSxYMT9MKT/kC3H8mpZSafPKSyryqKuDM4=;
        b=dmwS9qBvw85rFx7a3lNQVKsz1LEAl/mG2SV+HVbtDecJBxtAJ21QvMA3QJH/ja7JtP
         BdNriiTmT5ongtXYFMtx2qwmiFdllWrSSj0RQ6hHfDSIAL5zb5GGFz81CJ3qubNiDAQq
         XyTN4DKmrYeU/GHcWRVQLsV7e7r1SN+PpSoJ9x/ryj3zUMDK2F78YLJ2MF3g0cpDD9qZ
         fWALSq4KQP27JE/xLE2+RcXDAu8CfqPKecImmq7c27W7UlZekmYiokDwwBu0B8c8sgxW
         8bkcABIsm7xiHEVgEBrSYPXz/sGGZozJpw/I/UPy28VRB2eaJSg73Se3nIRmdi83XGe5
         6sJw==
X-Gm-Message-State: AC+VfDwjo6QKpuHb1yryopizVMCaKSNr/9YZwiDlheGrl2YmRX4S4mr8
        cPHogTpnD1h+x4A5bk5eHKklPQ==
X-Google-Smtp-Source: ACHHUZ4prNAdICwAaSQsV2rt6Xb7oE8D3s56s6rB058xABbz/MUOwr8u2I6R4O2V7x9xTDq54l7HqA==
X-Received: by 2002:a17:902:c947:b0:1ab:2659:b533 with SMTP id i7-20020a170902c94700b001ab2659b533mr12659351pla.3.1683546774038;
        Mon, 08 May 2023 04:52:54 -0700 (PDT)
Received: from sunil-laptop.. ([106.51.189.144])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902904900b001aaed524541sm7015149plz.227.2023.05.08.04.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 04:52:53 -0700 (PDT)
From:   Sunil V L <sunilvl@ventanamicro.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux-crypto@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        llvm@lists.linux.dev
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
        Tom Rix <trix@redhat.com>, Sunil V L <sunilvl@ventanamicro.com>
Subject: [PATCH V5 00/21] Add basic ACPI support for RISC-V
Date:   Mon,  8 May 2023 17:22:16 +0530
Message-Id: <20230508115237.216337-1-sunilvl@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch series enables the basic ACPI infrastructure for RISC-V.
Supporting external interrupt controllers is in progress and hence it is
tested using poll based HVC SBI console and RAM disk.

The first patch in this series is one of the patch from Jisheng's
series [1] which is not merged yet. This patch is required to support
ACPI since efi_init() which gets called before sbi_init() can enable
static branches and hits a panic.

Below are two ECRs approved by ASWG.
RINTC - https://drive.google.com/file/d/1R6k4MshhN3WTT-hwqAquu5nX6xSEqK2l/view
RHCT - https://drive.google.com/file/d/1nP3nFiH4jkPMp6COOxP6123DCZKR-tia/view


Changes since V4:
	1) Rebased with 6.4-rc1 which has ACPICA patches now.
	2) Split cpufeature.c patch into two by adding patch 2/7 from Conor's series [2]
	3) Updated caching RINTC logic to avoid global.
	4) Added driver patches to enable allmodconfig build at the start of the series.
	5) Updated tags

Changes since V3:
	1) Added two more driver patches to workaround allmodconfig build failure.
	2) Separated removal of riscv_of_processor_hartid() to a different patch.
	3) Addressed Conor's feedback.
	4) Rebased to v6.3-rc5 and added latest tags

Changes since V2:
	1) Dropped ACPI_PROCESSOR patch.
	2) Added new patch to print debug info of RISC-V INTC in MADT
	3) Addressed other comments from Drew.
	4) Rebased and updated tags

Changes since V1:
	1) Dropped PCI changes and instead added dummy interfaces just to enable
	   building ACPI core when CONFIG_PCI is enabled. Actual PCI changes will
	   be added in future along with external interrupt controller support
	   in ACPI.
	2) Squashed couple of patches so that new code added gets built in each
	   commit.
	3) Fixed the missing wake_cpu code in timer refactor patch as pointed by
	   Conor
	4) Fixed an issue with SMP disabled.
	5) Addressed other comments from Conor.
	6) Updated documentation patch as per feedback from Sanjaya.
	7) Fixed W=1 and checkpatch --strict issues.
	8) Added ACK/RB tags

[1] https://lore.kernel.org/all/20220821140918.3613-1-jszhang@kernel.org/
[2] http://lists.infradead.org/pipermail/linux-riscv/2023-May/031239.html

These changes are available at
https://github.com/vlsunil/linux/commits/acpi_b1_us_review_v5

Testing:
1) Build latest Qemu 

2) Build EDK2 as per instructions in
https://github.com/vlsunil/riscv-uefi-edk2-docs/wiki/RISC-V-Qemu-Virt-support

3) Build Linux after enabling SBI HVC and SBI earlycon
CONFIG_RISCV_SBI_V01=y
CONFIG_SERIAL_EARLYCON_RISCV_SBI=y
CONFIG_HVC_RISCV_SBI=y

4) Build buildroot.

Run with below command.
qemu-system-riscv64   -nographic \
-drive file=Build/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT.fd,if=pflash,format=raw,unit=1 \
-machine virt -smp 16 -m 2G \
-kernel arch/riscv/boot/Image \
-initrd buildroot/output/images/rootfs.cpio \
-append "root=/dev/ram ro console=hvc0 earlycon=sbi"

Jisheng Zhang (1):
  riscv: move sbi_init() earlier before jump_label_init()

Sunil V L (20):
  platform/surface: Disable for RISC-V
  crypto: hisilicon/qm: Fix to enable build with RISC-V clang
  ACPI: tables: Print RINTC information when MADT is parsed
  ACPI: OSL: Make should_use_kmap() 0 for RISC-V
  RISC-V: Add support to build the ACPI core
  ACPI: processor_core: RISC-V: Enable mapping processor to the hartid
  RISC-V: ACPI: Cache and retrieve the RINTC structure
  drivers/acpi: RISC-V: Add RHCT related code
  RISC-V: smpboot: Create wrapper setup_smp()
  RISC-V: smpboot: Add ACPI support in setup_smp()
  RISC-V: only iterate over possible CPUs in ISA string parser
  RISC-V: cpufeature: Add ACPI support in riscv_fill_hwcap()
  RISC-V: cpu: Enable cpuinfo for ACPI systems
  irqchip/riscv-intc: Add ACPI support
  clocksource/timer-riscv: Refactor riscv_timer_init_dt()
  clocksource/timer-riscv: Add ACPI support
  RISC-V: time.c: Add ACPI support for time_init()
  RISC-V: Add ACPI initialization in setup_arch()
  RISC-V: Enable ACPI in defconfig
  MAINTAINERS: Add entry for drivers/acpi/riscv

 .../admin-guide/kernel-parameters.txt         |   8 +-
 MAINTAINERS                                   |   8 +
 arch/riscv/Kconfig                            |   5 +
 arch/riscv/configs/defconfig                  |   1 +
 arch/riscv/include/asm/acenv.h                |  11 +
 arch/riscv/include/asm/acpi.h                 |  84 ++++++
 arch/riscv/include/asm/cpu.h                  |   8 +
 arch/riscv/kernel/Makefile                    |   1 +
 arch/riscv/kernel/acpi.c                      | 250 ++++++++++++++++++
 arch/riscv/kernel/cpu.c                       |  30 ++-
 arch/riscv/kernel/cpufeature.c                |  42 ++-
 arch/riscv/kernel/setup.c                     |  11 +-
 arch/riscv/kernel/smpboot.c                   |  77 +++++-
 arch/riscv/kernel/time.c                      |  25 +-
 drivers/acpi/Makefile                         |   2 +
 drivers/acpi/osl.c                            |   2 +-
 drivers/acpi/processor_core.c                 |  29 ++
 drivers/acpi/riscv/Makefile                   |   2 +
 drivers/acpi/riscv/rhct.c                     |  83 ++++++
 drivers/acpi/tables.c                         |  10 +
 drivers/clocksource/timer-riscv.c             |  92 ++++---
 drivers/crypto/hisilicon/qm.c                 |  13 +-
 drivers/irqchip/irq-riscv-intc.c              |  70 +++--
 drivers/platform/surface/aggregator/Kconfig   |   2 +-
 24 files changed, 774 insertions(+), 92 deletions(-)
 create mode 100644 arch/riscv/include/asm/acenv.h
 create mode 100644 arch/riscv/include/asm/acpi.h
 create mode 100644 arch/riscv/include/asm/cpu.h
 create mode 100644 arch/riscv/kernel/acpi.c
 create mode 100644 drivers/acpi/riscv/Makefile
 create mode 100644 drivers/acpi/riscv/rhct.c

-- 
2.34.1

