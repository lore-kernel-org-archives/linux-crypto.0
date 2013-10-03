From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/3] ARM: pull in <asm/simd.h> from asm-generic
Date: Thu,  3 Oct 2013 23:59:24 +0200
Message-ID: <1380837566-18242-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: nico@linaro.org, patches@linaro.org, linux@arm.linux.org.uk,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43875 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab3JCWAw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Oct 2013 18:00:52 -0400
Received: by mail-wi0-f179.google.com with SMTP id hm2so730991wib.12
        for <linux-crypto@vger.kernel.org>; Thu, 03 Oct 2013 15:00:51 -0700 (PDT)
In-Reply-To: <1380837566-18242-1-git-send-email-ard.biesheuvel@linaro.org>
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
