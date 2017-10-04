From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v5 09/31] crypto: ccp: Build the AMD secure processor driver only with AMD CPU support
Date: Wed,  4 Oct 2017 08:13:50 -0500
Message-ID: <20171004131412.13038-10-brijesh.singh@amd.com>
References: <20171004131412.13038-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Borislav Petkov <bp@suse.de>, brijesh.singh@amd.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171004131412.13038-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This is AMD-specific hardware so present it in Kconfig only when AMD
CPU support is enabled or on ARM64 where it is also used.

Signed-off-by: <brijesh.singh@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
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
