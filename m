Return-Path: <SRS0=oD/a=4Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F27DC3F2C6
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 00:01:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15D93246A8
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 00:01:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="og7wbWl6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgB1ABL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Feb 2020 19:01:11 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39903 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730134AbgB1ABL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Feb 2020 19:01:11 -0500
Received: by mail-pj1-f66.google.com with SMTP id e9so482403pjr.4
        for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2020 16:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AjOtp5FR+EutG91iiiNHeLTtXSRa+F8rsDdCFbNQiKA=;
        b=og7wbWl6rTie1f9y+17pPNODfxhRLbqyDmNOgU3ni+5ldYJnCUnsKtnloJk0Et5Vjq
         JIIzeny0AtgNula80xkra5O9DFF//GYNz4kKVUZxQzcux2YO2BZl++Zo6OBw2K2+iUKK
         w0a3VGbl1Got9ch5YVPfo5JI2si+sbT1lhW6Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AjOtp5FR+EutG91iiiNHeLTtXSRa+F8rsDdCFbNQiKA=;
        b=EbRRGlKkCDXqefxI2m/cwrH+wFGkU7dMfblYMGFFDuQWCG2/8HpwQ2eLU3v5kNaHj0
         wNfdSOJgA+Kv4e9NnFYFhOrCcUoF7oBeDHAoyPaAcu2LZ0K5eTZgGY1Q8uaO5MN4hJar
         s3bXN3dZ/UCYX9D+LhHsIxARv4hamPrsfrgmWsoJMh2F2XTb9QKEkN5KLUInOWolmhN3
         zSn2BHXuTtQF1tqszwjt4XDOH6x1dJ8dM5qVjouvw1df5LNfZk4lhGp7ZVsUN2TSXmxF
         DNg7Q5Ofka2zBdMq9Zos5ypnU1NDHllur/OyZHQ53zuJBSjGnflzB4TQjmWN9cD/Dmmb
         TTlA==
X-Gm-Message-State: APjAAAW57AwM9mGd9AmdS19hAKfO9h2Gfn9Zi3w9RnlfShoasHof7Xfr
        JCthLEMsMm5v6ctWHnTsQnt9ig==
X-Google-Smtp-Source: APXvYqzOftm1lL+gALRY9HoLca3CVgYdN/lXyS29L66lhzrvv8B7l3DTwmKTJiw1+t9iUzbkbEElYw==
X-Received: by 2002:a17:90a:ef17:: with SMTP id k23mr1496185pjz.139.1582848069749;
        Thu, 27 Feb 2020 16:01:09 -0800 (PST)
Received: from thgarnie.kir.corp.google.com ([2620:0:1008:1100:6e62:16fa:a60c:1d24])
        by smtp.gmail.com with ESMTPSA id c18sm7314476pgw.17.2020.02.27.16.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 16:01:09 -0800 (PST)
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
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Garnier <thgarnie@chromium.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Cao jin <caoj.fnst@cn.fujitsu.com>,
        Allison Randal <allison@lohutok.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: [PATCH v11 00/11] x86: PIE support to extend KASLR randomization
Date:   Thu, 27 Feb 2020 16:00:45 -0800
Message-Id: <20200228000105.165012-1-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Minor changes based on feedback and rebase from v10.

Splitting the previous serie in two. This part contains assembly code
changes required for PIE but without any direct dependencies with the
rest of the patchset.

Note: Using objtool to detect non-compliant PIE relocations is not yet
possible as this patchset only includes the simplest PIE changes.
Additional changes are needed in kvm, xen and percpu code.

Changes:
 - patch v11 (assembly);
   - Fix comments on x86/entry/64.
   - Remove KASLR PIE explanation on all commits.
   - Add note on objtool not being possible at this stage of the patchset.
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
 include/asm/bug.h                   |    2 
 include/asm/paravirt_types.h        |   32 ++++++++++--
 include/asm/pm-trace.h              |    2 
 include/asm/processor.h             |    6 +-
 kernel/acpi/wakeup_64.S             |   31 ++++++-----
 kernel/head_64.S                    |   15 +++--
 kernel/relocate_kernel_64.S         |    2 
 power/hibernate_asm_64.S            |    4 -
 24 files changed, 268 insertions(+), 182 deletions(-)

Patchset is based on next-20200227.


