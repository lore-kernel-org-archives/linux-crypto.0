Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF02FC433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A16AA61221
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 20:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhENUVw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 16:21:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:16073 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232913AbhENUVs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 16:21:48 -0400
IronPort-SDR: YPfSbfV+vMfuWPhGEMhFYCZePmcjllgQ7njTIA2zVEtjIyJji5i0Yi+i6b/f/Wf14DWgv4ILxu
 oGDFvTrTAJEQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="199921577"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="199921577"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 13:20:33 -0700
IronPort-SDR: RBs3HdpDAuXU63U/4/HTzHylrG8b8nOsKoYbMs5SSUqDwuENuyetmjugVr6opyQSlkrkEFPl6d
 bBogcnMgfI1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="438147150"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by orsmga008.jf.intel.com with ESMTP; 14 May 2021 13:20:33 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, chang.seok.bae@intel.com
Subject: [RFC PATCH v2 00/11] x86: Support Intel Key Locker
Date:   Fri, 14 May 2021 13:14:57 -0700
Message-Id: <20210514201508.27967-1-chang.seok.bae@intel.com>
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
* PATCH1-7:  Implement the internal key management
* PATCH8-10: Add a new AES implementation in the Crypto library
* PATCH11:   Provide the hardware randomization option

Dan has asked for this to go out as another RFC to have more conversation
before asking the maintainers to consider this implementation.

Changes from RFC v1 [3]:
* Refactored the AES-NI implementation and fix the AES-KL in the Crypto
  API. (Ard Biesheuvel)
* Revised the AES implementation description. (Dave Hansen and Peter
  Zijlsta).
* Noted the binutils version and made it prerequisite. (Peter Zijlstra and
  Borislav Petkov)
* Reorganized helper functions. With that, simplified the feature
  enablement check.
* Added to flush cache lines when removing key from memory.
* Separated the opcode map update into a new patch. Also, included AES
  instructions.
* Refactored the LOADIWKEY instruction in a new helper.
* Folded the backup error warning. (Rafael Wysocki)
* Massaged changelog accordingly.

[1] Intel Architecture Instruction Set Extensions Programming Reference:
    https://software.intel.com/content/dam/develop/external/us/en/documents-tps/architecture-instruction-set-extensions-programming-reference.pdf
[2] Intel Key Locker Specification:
    https://software.intel.com/content/dam/develop/external/us/en/documents/343965-intel-key-locker-specification.pdf
[3] RFC v1: https://lore.kernel.org/lkml/20201216174146.10446-1-chang.seok.bae@intel.com/

Chang S. Bae (11):
  x86/cpufeature: Enumerate Key Locker feature
  x86/insn: Add Key Locker instructions to the opcode map
  x86/cpu: Load Key Locker internal key at boot-time
  x86/msr-index: Add MSRs for Key Locker internal key
  x86/power: Restore Key Locker internal key from the ACPI S3/4 sleep
    states
  x86/cpu: Add a config option and a chicken bit for Key Locker
  selftests/x86: Test Key Locker internal key maintenance
  crypto: x86/aes-ni - Improve error handling
  crypto: x86/aes-ni - Refactor to prepare a new AES implementation
  crypto: x86/aes-kl - Support AES algorithm using Key Locker
    instructions
  x86/cpu: Support the hardware randomization option for Key Locker
    internal key

 .../admin-guide/kernel-parameters.txt         |    2 +
 arch/x86/Kconfig                              |   14 +
 arch/x86/crypto/Makefile                      |    5 +-
 arch/x86/crypto/aes-intel_asm.S               |   26 +
 arch/x86/crypto/aes-intel_glue.c              |  208 +++
 arch/x86/crypto/aes-intel_glue.h              |   61 +
 arch/x86/crypto/aeskl-intel_asm.S             | 1181 +++++++++++++++++
 arch/x86/crypto/aeskl-intel_glue.c            |  390 ++++++
 arch/x86/crypto/aesni-intel_asm.S             |   90 +-
 arch/x86/crypto/aesni-intel_glue.c            |  310 +----
 arch/x86/crypto/aesni-intel_glue.h            |   88 ++
 arch/x86/include/asm/cpufeatures.h            |    1 +
 arch/x86/include/asm/disabled-features.h      |    8 +-
 arch/x86/include/asm/keylocker.h              |   30 +
 arch/x86/include/asm/msr-index.h              |    6 +
 arch/x86/include/asm/special_insns.h          |   36 +
 arch/x86/include/uapi/asm/processor-flags.h   |    2 +
 arch/x86/kernel/Makefile                      |    1 +
 arch/x86/kernel/cpu/common.c                  |   21 +-
 arch/x86/kernel/cpu/cpuid-deps.c              |    1 +
 arch/x86/kernel/keylocker.c                   |  264 ++++
 arch/x86/kernel/smpboot.c                     |    2 +
 arch/x86/lib/x86-opcode-map.txt               |   11 +-
 arch/x86/power/cpu.c                          |    2 +
 crypto/Kconfig                                |   23 +
 drivers/char/random.c                         |    6 +
 include/linux/random.h                        |    2 +
 tools/arch/x86/lib/x86-opcode-map.txt         |   11 +-
 tools/testing/selftests/x86/Makefile          |    2 +-
 tools/testing/selftests/x86/keylocker.c       |  177 +++
 30 files changed, 2638 insertions(+), 343 deletions(-)
 create mode 100644 arch/x86/crypto/aes-intel_asm.S
 create mode 100644 arch/x86/crypto/aes-intel_glue.c
 create mode 100644 arch/x86/crypto/aes-intel_glue.h
 create mode 100644 arch/x86/crypto/aeskl-intel_asm.S
 create mode 100644 arch/x86/crypto/aeskl-intel_glue.c
 create mode 100644 arch/x86/crypto/aesni-intel_glue.h
 create mode 100644 arch/x86/include/asm/keylocker.h
 create mode 100644 arch/x86/kernel/keylocker.c
 create mode 100644 tools/testing/selftests/x86/keylocker.c


base-commit: 6efb943b8616ec53a5e444193dccf1af9ad627b5
--
2.17.1

