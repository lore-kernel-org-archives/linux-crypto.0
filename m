From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] crypto: arm: ignore generated SHA2 assembly files
Date: Mon,  6 Jul 2015 07:03:37 +0300
Message-ID: <e9fad4b90e8d3aac883e2a5ac99b330653bcc354.1436155417.git.baruch@tkos.co.il>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Baruch Siach <baruch@tkos.co.il>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:58180 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbbGFEFB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 00:05:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These files are generated since commits f2f770d74a8d (crypto: arm/sha256 - Add
optimized SHA-256/224, 2015-04-03) and c80ae7ca3726 (crypto: arm/sha512 -
accelerated SHA-512 using ARM generic ASM and NEON, 2015-05-08).

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 arch/arm/crypto/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/crypto/.gitignore b/arch/arm/crypto/.gitignore
index 6231d36b3635..31e1f538df7d 100644
--- a/arch/arm/crypto/.gitignore
+++ b/arch/arm/crypto/.gitignore
@@ -1 +1,3 @@
 aesbs-core.S
+sha256-core.S
+sha512-core.S
-- 
2.1.4
