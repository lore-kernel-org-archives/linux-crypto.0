From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] crypto: ccp: Build the AMD secure processor driver only with
 AMD CPU support
Date: Sat, 30 Sep 2017 10:30:54 +0200
Message-ID: <20170930083054.eeblfi65qpz2xop7@pd.tnic>
References: <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
 <20170929162322.47553-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170929162322.47553-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

just a small Kconfig correction. Feel free to add it to your patchset.

Thx.

---
From: Borislav Petkov <bp@suse.de>

This is AMD-specific hardware so present it in Kconfig only when AMD
CPU support is enabled.

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
index 627f3e61dcac..f58a6521270b 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -1,5 +1,6 @@
 config CRYPTO_DEV_CCP_DD
 	tristate "Secure Processor device driver"
+	depends on CPU_SUP_AMD
 	default m
 	help
 	  Provides AMD Secure Processor device driver.
-- 
2.13.0

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
