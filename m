From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v9 09/38] crypto: ccp: Build the AMD secure processor driver only with AMD CPU support
Date: Mon,  4 Dec 2017 19:04:09 -0600
Message-ID: <20171205010438.5773-10-brijesh.singh@amd.com>
References: <20171205010438.5773-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: bp@alien8.de, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171205010438.5773-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This is AMD-specific hardware so present it in Kconfig only when AMD
CPU support is enabled or on ARM64 where it is also used.

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Gary R Hook <gary.hook@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
 drivers/crypto/ccp/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index 6d626606b9c5..9c84f9838931 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -1,5 +1,6 @@
 config CRYPTO_DEV_CCP_DD
 	tristate "Secure Processor device driver"
+	depends on CPU_SUP_AMD || ARM64
 	default m
 	help
 	  Provides AMD Secure Processor device driver.
-- 
2.9.5
