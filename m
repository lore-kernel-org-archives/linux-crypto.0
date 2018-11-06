Return-Path: <SRS0=45GR=NR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46824 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbeKFVlQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Nov 2018 16:41:16 -0500
Date: Tue, 6 Nov 2018 17:46:14 +0530
From: Brajeswar Ghosh <brajeswar.linux@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux@armlinux.org.uk
Cc: jrdr.linux@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sabyasachi.linux@gmail.com
Subject: [PATCH] arm/crypto/aes-ce-glue.c: Remove duplicate header
Message-ID: <20181106121614.GA1985@hp-pavilion-15-notebook-pc-brajeswar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove asm/hwcap.h which is included more than once

Signed-off-by: Brajeswar Ghosh <brajeswar.linux@gmail.com>
---
 arch/arm/crypto/aes-ce-glue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index d0a9cec73707..5affb8482379 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -10,7 +10,6 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
-#include <asm/hwcap.h>
 #include <crypto/aes.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
-- 
2.17.1
