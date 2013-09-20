From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/4] ARM: pull in <asm/simd.h> from asm-generic
Date: Fri, 20 Sep 2013 20:46:49 +0200
Message-ID: <1379702811-8025-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1379702811-8025-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:64929 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3ITSrh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Sep 2013 14:47:37 -0400
Received: by mail-we0-f175.google.com with SMTP id q59so903679wes.34
        for <linux-crypto@vger.kernel.org>; Fri, 20 Sep 2013 11:47:35 -0700 (PDT)
In-Reply-To: <1379702811-8025-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index d3db398..6577b8a 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -24,6 +24,7 @@ generic-y += sembuf.h
 generic-y += serial.h
 generic-y += shmbuf.h
 generic-y += siginfo.h
+generic-y += simd.h
 generic-y += sizes.h
 generic-y += socket.h
 generic-y += sockios.h
-- 
1.8.1.2
