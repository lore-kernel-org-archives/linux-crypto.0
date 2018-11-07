Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from foss.arm.com ([217.140.101.70]:47458 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbeKGTJw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 14:09:52 -0500
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: yamada.masahiro@socionext.com, linux-crypto@vger.kernel.org,
        linux-kbuild@vger.kernel.org, kbuild-all@01.org
Subject: [RFC PATCH 0/4] Minor improvements over handling dependency on GAS
Date: Wed,  7 Nov 2018 09:40:04 +0000
Message-Id: <1541583608-26375-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With recent changes in Kconfig processing it is now possible to expose
dependency on specific tools and supported options via Kconfig rather
than bury it deep in Makefile.

This small series try to address the case where the whole feature, for
instance arm64/lse or arm/crypto, depends on GAS.

Vladimir Murzin (4):
  kconfig: add as-instr macro to scripts/Kconfig.include
  arm64: lse: expose dependency on gas via Kconfig
  arm64: turn "broken gas inst" into real config option
  ARM: crypto: expose dependency on gas via Kconfig

 arch/arm/crypto/Kconfig         | 31 +++++++++++++++++++++----------
 arch/arm/crypto/Makefile        | 31 ++++++-------------------------
 arch/arm64/Kconfig              |  4 ++++
 arch/arm64/Makefile             | 18 ++----------------
 arch/arm64/include/asm/atomic.h |  2 +-
 arch/arm64/include/asm/lse.h    |  6 +++---
 arch/arm64/kernel/cpufeature.c  |  4 ++--
 scripts/Kconfig.include         |  4 ++++
 8 files changed, 43 insertions(+), 57 deletions(-)

-- 
1.9.1
