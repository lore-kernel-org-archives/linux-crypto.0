From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 3/3] crypto: vmx - Ensure ghash-generic is enabled
Date: Wed, 28 Sep 2016 13:42:11 -0300
Message-ID: <1475080931-7926-4-git-send-email-marcelo.cerri@canonical.com>
References: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        George Wilson <gcwilson@us.ibm.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:32974 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932997AbcI1QnG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Sep 2016 12:43:06 -0400
Received: by mail-qk0-f182.google.com with SMTP id g67so52714351qkd.0
        for <linux-crypto@vger.kernel.org>; Wed, 28 Sep 2016 09:43:06 -0700 (PDT)
In-Reply-To: <1475080931-7926-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add CRYPTO_GHASH as a dependency for vmx_crypto since p8_ghash uses it
as the fallback implementation.

Signed-off-by: Marcelo Cerri <marcelo.cerri@canonical.com>
---
 drivers/crypto/vmx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/vmx/Kconfig b/drivers/crypto/vmx/Kconfig
index a83ead1..c21b09a 100644
--- a/drivers/crypto/vmx/Kconfig
+++ b/drivers/crypto/vmx/Kconfig
@@ -1,6 +1,6 @@
 config CRYPTO_DEV_VMX_ENCRYPT
 	tristate "Encryption acceleration support on P8 CPU"
-	depends on CRYPTO_DEV_VMX
+	depends on CRYPTO_DEV_VMX || CRYPTO_GHASH
 	default m
 	help
 	  Support for VMX cryptographic acceleration instructions on Power8 CPU.
-- 
2.7.4
