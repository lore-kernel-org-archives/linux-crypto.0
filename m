From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 06/11] arm64: pull in <asm/simd.h> from asm-generic
Date: Wed, 14 May 2014 11:17:26 -0700
Message-ID: <1400091451-9117-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: catalin.marinas@arm.com, jussi.kivilinna@iki.fi,
	herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:46951 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaENSRy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 14:17:54 -0400
Received: by mail-yh0-f41.google.com with SMTP id f73so2030185yha.14
        for <linux-crypto@vger.kernel.org>; Wed, 14 May 2014 11:17:53 -0700 (PDT)
In-Reply-To: <1400091451-9117-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 83f71b3004a8..42c7eecd2bb6 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -40,6 +40,7 @@ generic-y += segment.h
 generic-y += sembuf.h
 generic-y += serial.h
 generic-y += shmbuf.h
+generic-y += simd.h
 generic-y += sizes.h
 generic-y += socket.h
 generic-y += sockios.h
-- 
1.8.3.2
