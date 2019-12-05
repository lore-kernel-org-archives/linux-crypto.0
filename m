Return-Path: <SRS0=t288=Z3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46609C2D0BE
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 00:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1369720674
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Dec 2019 00:10:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QxOqKsya"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbfLEAKK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Dec 2019 19:10:10 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34670 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728011AbfLEAKJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Dec 2019 19:10:09 -0500
Received: by mail-pj1-f65.google.com with SMTP id t21so504218pjq.1
        for <linux-crypto@vger.kernel.org>; Wed, 04 Dec 2019 16:10:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UytXlJZhh+PP1i+glyLgAUD5cLw4G7yz6Wut2v8BXhA=;
        b=QxOqKsyapbqk+/pSPb0Gw2Zm18hm9broo8Lb2eTyKrlGq1tWPs1ASqa2OqeLoIwsEx
         BoANHo1kmP9OCpEq2InAs+RHshYy90hD0yubM1yudLe6UDy+JcaESXTdlzUroge7wYxC
         XzqyYr7HB31mp90bODmkfoR4cJF73mTUtle3Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UytXlJZhh+PP1i+glyLgAUD5cLw4G7yz6Wut2v8BXhA=;
        b=WZ1jtu0Zbc4kxuxD7FXG7lMhqnk9IYAPGeyVn08uktni+PzA/294y8pUeUY9/qohvc
         sVYf8/oXdoCrViny8RQieIa+WraUAVxoUP+yEylAZhB2/0zzishGuoyo9IFb+hM87v4d
         uVKvGj3C6nKbglfWJqzYyzTsrpydFAin9r7qwOkStYE6/zC1ytGWCnCK8bsSZI/SPI8s
         ThmgMBURyfrzy5PXoD28+4CFXiCwGXVmkSiz2TYy/X87wZ3sXy16bS78Wbzd2JmNdZmB
         ayI5wju4Y9CcVtpOXe8TC2WdzZUG139siTu0JT6vjP7Pinn+OVXvdrCnH/ufntPHyh13
         nzlA==
X-Gm-Message-State: APjAAAVuP5li7WGh03uG9wsRwIjoUS9awCvZZdIiFsB3k4nusBlBvUDc
        ynwTD59t11+tFRozawFH0D8dkQ==
X-Google-Smtp-Source: APXvYqx2egJZownjeOB7aUkypSGIaPs5//EOll6rmXEBNtoJ5uqK7nOQ4gDytmta4ltf50AKitqeKA==
X-Received: by 2002:a17:90a:9f04:: with SMTP id n4mr6211836pjp.76.1575504608976;
        Wed, 04 Dec 2019 16:10:08 -0800 (PST)
Received: from thgarnie.kir.corp.google.com ([2620:0:1008:1100:d6ba:ac27:4f7b:28d7])
        by smtp.gmail.com with ESMTPSA id 73sm8422303pgc.13.2019.12.04.16.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 16:10:08 -0800 (PST)
From:   Thomas Garnier <thgarnie@chromium.org>
To:     kernel-hardening@lists.openwall.com
Cc:     kristen@linux.intel.com, keescook@chromium.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Thomas Garnier <thgarnie@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: [PATCH v10 00/11] x86: PIE support to extend KASLR randomization
Date:   Wed,  4 Dec 2019 16:09:37 -0800
Message-Id: <20191205000957.112719-1-thgarnie@chromium.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Minor changes based on feedback and rebase from v9.

Splitting the previous serie in two. This part contains assembly code
changes required for PIE but without any direct dependencies with the
rest of the patchset.

Changes:
 - patch v10 (assembly):
   - Swap rax for rdx on entry/64 changes based on feedback.
   - Addressed feedback from Borislav Petkov on boot, paravirt, alternatives
     and globally.
   - Rebased the patchset and ensure it works with large kaslr (not included).
 - patch v9 (assembly):
   - Moved to relative reference for sync_core based on feedback.
   - x86/crypto had multiple algorithms deleted, removed PIE changes to them.
   - fix typo on comment end line.
 - patch v8 (assembly):
   - Fix issues in crypto changes (thanks to Eric Biggers).
   - Remove unnecessary jump table change.
   - Change author and signoff to chromium email address.
 - patch v7 (assembly):
   - Split patchset and reorder changes.
 - patch v6:
   - Rebase on latest changes in jump tables and crypto.
   - Fix wording on couple commits.
   - Revisit checkpatch warnings.
   - Moving to @chromium.org.
 - patch v5:
   - Adapt new crypto modules for PIE.
   - Improve per-cpu commit message.
   - Fix xen 32-bit build error with .quad.
   - Remove extra code for ftrace.
 - patch v4:
   - Simplify early boot by removing global variables.
   - Modify the mcount location script for __mcount_loc intead of the address
     read in the ftrace implementation.
   - Edit commit description to explain better where the kernel can be located.
   - Streamlined the testing done on each patch proposal. Always testing
     hibernation, suspend, ftrace and kprobe to ensure no regressions.
 - patch v3:
   - Update on message to describe longer term PIE goal.
   - Minor change on ftrace if condition.
   - Changed code using xchgq.
 - patch v2:
   - Adapt patch to work post KPTI and compiler changes
   - Redo all performance testing with latest configs and compilers
   - Simplify mov macro on PIE (MOVABS now)
   - Reduce GOT footprint
 - patch v1:
   - Simplify ftrace implementation.
   - Use gcc mstack-protector-guard-reg=%gs with PIE when possible.
 - rfc v3:
   - Use --emit-relocs instead of -pie to reduce dynamic relocation space on
     mapped memory. It also simplifies the relocation process.
   - Move the start the module section next to the kernel. Remove the need for
     -mcmodel=large on modules. Extends module space from 1 to 2G maximum.
   - Support for XEN PVH as 32-bit relocations can be ignored with
     --emit-relocs.
   - Support for GOT relocations previously done automatically with -pie.
   - Remove need for dynamic PLT in modules.
   - Support dymamic GOT for modules.
 - rfc v2:
   - Add support for global stack cookie while compiler default to fs without
     mcmodel=kernel
   - Change patch 7 to correctly jump out of the identity mapping on kexec load
     preserve.

These patches make some of the changes necessary to build the kernel as
Position Independent Executable (PIE) on x86_64. Another patchset will
add the PIE option and larger architecture changes. PIE allows the kernel to be
placed below the 0xffffffff80000000 increasing the range of KASLR.

The patches:
 - 1, 3-11: Change in assembly code to be PIE compliant.
 - 2: Add a new _ASM_MOVABS macro to fetch a symbol address generically.

diffstat:
 crypto/aegis128-aesni-asm.S         |    6 +-
 crypto/aesni-intel_asm.S            |    8 +--
 crypto/aesni-intel_avx-x86_64.S     |    3 -
 crypto/camellia-aesni-avx-asm_64.S  |   42 +++++++--------
 crypto/camellia-aesni-avx2-asm_64.S |   44 ++++++++--------
 crypto/camellia-x86_64-asm_64.S     |    8 +--
 crypto/cast5-avx-x86_64-asm_64.S    |   50 ++++++++++--------
 crypto/cast6-avx-x86_64-asm_64.S    |   44 +++++++++-------
 crypto/des3_ede-asm_64.S            |   96 ++++++++++++++++++++++++------------
 crypto/ghash-clmulni-intel_asm.S    |    4 -
 crypto/glue_helper-asm-avx.S        |    4 -
 crypto/glue_helper-asm-avx2.S       |    6 +-
 crypto/sha256-avx2-asm.S            |   18 ++++--
 entry/entry_64.S                    |   16 ++++--
 include/asm/alternative.h           |    6 +-
 include/asm/asm.h                   |    1 
 include/asm/paravirt_types.h        |   32 ++++++++++--
 include/asm/pm-trace.h              |    2 
 include/asm/processor.h             |    6 +-
 kernel/acpi/wakeup_64.S             |   31 ++++++-----
 kernel/head_64.S                    |   15 +++--
 kernel/relocate_kernel_64.S         |    2 
 power/hibernate_asm_64.S            |    4 -
 23 files changed, 267 insertions(+), 181 deletions(-)

Patchset is based on next-20191203.


