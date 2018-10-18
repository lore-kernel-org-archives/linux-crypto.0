Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:46347 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726816AbeJRW67 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 18:58:59 -0400
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net-next v8 01/28] ARM: makefile: use ARMv3M mode for RiscPC
Date: Thu, 18 Oct 2018 16:56:45 +0200
Message-Id: <20181018145712.7538-2-Jason@zx2c4.com>
In-Reply-To: <20181018145712.7538-1-Jason@zx2c4.com>
References: <20181018145712.7538-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The purpose of CONFIG_CPU_32v3 is to avoid ldrh/strh on the RiscPC,
which is pretty much an ARMv4 device, except its bus will choke on the
half-words. The way to make the C compiler not output ldrh/strh is with
-march=armv3, which doesn't support them in the ISA. However, this
prevents certain cryptography code from working that uses instructions
like umull. Fortunately there's also -march=armv3m that does support
those, making it possible to continue assembling optimized cryptography
routines for our beloved RiscPC.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---

Notes:
    This commit has been submitted to the proper ARM tree and is working its
    way upstream. It's included in this series here so that kbuild 0-day bot
    doesn't get too nervous about RiscPC, but is already entering the tree
    through arm-next.

 arch/arm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index d1516f85f25d..7fd4bcaf0721 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -74,7 +74,7 @@ endif
 arch-$(CONFIG_CPU_32v5)		=-D__LINUX_ARM_ARCH__=5 $(call cc-option,-march=armv5te,-march=armv4t)
 arch-$(CONFIG_CPU_32v4T)	=-D__LINUX_ARM_ARCH__=4 -march=armv4t
 arch-$(CONFIG_CPU_32v4)		=-D__LINUX_ARM_ARCH__=4 -march=armv4
-arch-$(CONFIG_CPU_32v3)		=-D__LINUX_ARM_ARCH__=3 -march=armv3
+arch-$(CONFIG_CPU_32v3)		=-D__LINUX_ARM_ARCH__=3 -march=armv3m
 
 # Evaluate arch cc-option calls now
 arch-y := $(arch-y)
-- 
2.19.1
