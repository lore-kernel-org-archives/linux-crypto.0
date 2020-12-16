Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7712C2BBCD
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F99224CED
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Dec 2020 17:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgLPRqs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:46:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:21271 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbgLPRqs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Dec 2020 12:46:48 -0500
IronPort-SDR: u9zGBRcPOyO++jtyKUv4NUIK5fE6JoGXu52fxrStJAelgak/WZ6xnmM5qnSnU6mvZNQ+dbhQwA
 Ik6r5GiuCJsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="171593373"
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="171593373"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 09:46:07 -0800
IronPort-SDR: R11X8xLiVTp1uBkKEvnu2S1hFcl/sE5CpanM+WOd8DnMNLUsi3k/fEwQR5ioe31KrlOm9HyOj4
 FTgYHF86dcTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,424,1599548400"; 
   d="scan'208";a="391854158"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Dec 2020 09:46:07 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, ning.sun@intel.com,
        kumar.n.dwarakanath@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH 0/8] x86: Support Intel Key Locker
Date:   Wed, 16 Dec 2020 09:41:38 -0800
Message-Id: <20201216174146.10446-1-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Key Locker [1][2] is a new security feature available in new Intel CPUs to
protect data encryption keys for the Advanced Encryption Standard
algorithm. The protection limits the amount of time an AES key is exposed
in memory by sealing a key and referencing it with new AES instructions.

The new AES instruction set is a successor of Intel's AES-NI (AES New
Instruction). Users may switch to the Key Locker version from crypto
libraries.  This series includes a new AES implementation for the Crypto
API, which was validated through the crypto unit tests. The performance in
the test cases was measured and found comparable to the AES-NI version.

Key Locker introduces a (CPU-)internal key to encode AES keys. The kernel
needs to load it and ensure it unchanged as long as CPUs are operational.

The series has three parts:
* PATCH1-6: Implement the internal key management
* PATCH7:   Add AES implementation in Crypto library
* PATCH8:   Provide the hardware randomization option for the internal key

This RFC series has been reviewed by Dan Williams, with an open question of
whether to use hardware backup/restore, or to synchronize reinitialize the
internal key over suspend / resume to avoid the implications of key restore
failures.

[1] Intel Architecture Instruction Set Extensions Programming Reference:
    https://software.intel.com/content/dam/develop/external/us/en/documents/architecture-instruction-set-$
[2] Intel Key Locker Specification:
    https://software.intel.com/content/dam/develop/external/us/en/documents/343965-intel-key-locker-speci$

Chang S. Bae (8):
  x86/cpufeature: Enumerate Key Locker feature
  x86/cpu: Load Key Locker internal key at boot-time
  x86/msr-index: Add MSRs for Key Locker internal key
  x86/power: Restore Key Locker internal key from the ACPI S3/4 sleep
    states
  x86/cpu: Add a config option and a chicken bit for Key Locker
  selftests/x86: Test Key Locker internal key maintenance
  crypto: x86/aes-kl - Support AES algorithm using Key Locker
    instructions
  x86/cpu: Support the hardware randomization option for Key Locker
    internal key

 .../admin-guide/kernel-parameters.txt         |   2 +
 arch/x86/Kconfig                              |  14 +
 arch/x86/crypto/Makefile                      |   3 +
 arch/x86/crypto/aeskl-intel_asm.S             | 881 ++++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c            | 697 ++++++++++++++
 arch/x86/include/asm/cpufeatures.h            |   1 +
 arch/x86/include/asm/disabled-features.h      |   8 +-
 arch/x86/include/asm/inst.h                   | 201 ++++
 arch/x86/include/asm/keylocker.h              |  41 +
 arch/x86/include/asm/msr-index.h              |   6 +
 arch/x86/include/uapi/asm/processor-flags.h   |   2 +
 arch/x86/kernel/Makefile                      |   1 +
 arch/x86/kernel/cpu/common.c                  |  66 +-
 arch/x86/kernel/cpu/cpuid-deps.c              |   1 +
 arch/x86/kernel/keylocker.c                   | 147 +++
 arch/x86/kernel/smpboot.c                     |   2 +
 arch/x86/lib/x86-opcode-map.txt               |   2 +-
 arch/x86/power/cpu.c                          |  34 +
 crypto/Kconfig                                |  28 +
 drivers/char/random.c                         |   6 +
 include/linux/random.h                        |   2 +
 tools/arch/x86/lib/x86-opcode-map.txt         |   2 +-
 tools/testing/selftests/x86/Makefile          |   2 +-
 tools/testing/selftests/x86/keylocker.c       | 177 ++++
 24 files changed, 2321 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/crypto/aeskl-intel_asm.S
 create mode 100644 arch/x86/crypto/aeskl-intel_glue.c
 create mode 100644 arch/x86/include/asm/keylocker.h
 create mode 100644 arch/x86/kernel/keylocker.c
 create mode 100644 tools/testing/selftests/x86/keylocker.c

-- 
2.17.1

