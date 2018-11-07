Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:47470 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbeKGTJx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Nov 2018 14:09:53 -0500
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: yamada.masahiro@socionext.com, linux-crypto@vger.kernel.org,
        linux-kbuild@vger.kernel.org, kbuild-all@01.org,
        Will Deacon <will.deacon@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 1/4] kconfig: add as-instr macro to scripts/Kconfig.include
Date: Wed,  7 Nov 2018 09:40:05 +0000
Message-Id: <1541583608-26375-2-git-send-email-vladimir.murzin@arm.com>
In-Reply-To: <1541583608-26375-1-git-send-email-vladimir.murzin@arm.com>
References: <1541583608-26375-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are cases where the whole feature, for instance arm64/lse or
arm/crypto, can depend on assembler. Current practice is to report
buildtime that selected feature is not supported, which can be quite
annoying...

It'd nicer if we can check assembler first and opt-in feature
visibility in Kconfig.

Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 scripts/Kconfig.include | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/Kconfig.include b/scripts/Kconfig.include
index dad5583..07c145c 100644
--- a/scripts/Kconfig.include
+++ b/scripts/Kconfig.include
@@ -22,6 +22,10 @@ success = $(if-success,$(1),y,n)
 # Return y if the compiler supports <flag>, n otherwise
 cc-option = $(success,$(CC) -Werror $(1) -E -x c /dev/null -o /dev/null)
 
+# $(as-instr,<instr>)
+# Return y if the assembler supports <instr>, n otherwise
+as-instr = $(success,printf "%b\n" "$(1)" | $(CC) -Werror -c -x assembler -o /dev/null -)
+
 # $(ld-option,<flag>)
 # Return y if the linker supports <flag>, n otherwise
 ld-option = $(success,$(LD) -v $(1))
-- 
1.9.1
