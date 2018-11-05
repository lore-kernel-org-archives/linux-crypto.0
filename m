Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:42126 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbeKEVYb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 16:24:31 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Ofir Drang <Ofir.Drang@arm.com>, Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: cts: document NIST standard status
Date: Mon,  5 Nov 2018 12:05:01 +0000
Message-Id: <1541419502-7286-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

cts(cbc(aes)) as used in the kernel has been added to NIST
standard as CBC-CS3. Document it as such.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Suggested-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f7a235d..9176023 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -430,11 +430,14 @@ config CRYPTO_CTS
 	help
 	  CTS: Cipher Text Stealing
 	  This is the Cipher Text Stealing mode as described by
-	  Section 8 of rfc2040 and referenced by rfc3962.
-	  (rfc3962 includes errata information in its Appendix A)
+	  Section 8 of rfc2040 and referenced by rfc3962
+	  (rfc3962 includes errata information in its Appendix A) or
+	  CBC-CS3 as defined by NIST in Sp800-38A addendum from Oct 2010.
 	  This mode is required for Kerberos gss mechanism support
 	  for AES encryption.
 
+	  See: https://csrc.nist.gov/publications/detail/sp/800-38a/addendum/final
+
 config CRYPTO_ECB
 	tristate "ECB support"
 	select CRYPTO_BLKCIPHER
-- 
2.7.4
