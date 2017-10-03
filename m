From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v4 05/29] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Tue, 3 Oct 2017 18:17:18 +0200
Message-ID: <20171003161718.mabp74olsxbmpewv@pd.tnic>
References: <20170919204627.3875-1-brijesh.singh@amd.com>
 <20170919204627.3875-6-brijesh.singh@amd.com>
 <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
 <1fc76eee-f25b-cd38-cc8d-0404ec94cf79@amd.com>
 <20170930161104.452sia6a5y5duyn4@pd.tnic>
 <55879570-04d7-a627-5f4b-b94f1604ece5@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55879570-04d7-a627-5f4b-b94f1604ece5@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 01, 2017 at 03:05:11PM -0500, Brijesh Singh wrote:
> I think theoretically a 32-bit host OS can invoke a PSP commands but
> currently PSP interface is exposing only the SEV FW command. And SEV

Let's cross that bridge when we get to it.

> feature is available when we are in 64-bit mode hence for now its okay
> to have depends on X86_64. I will add CRYPTO_DEV_CCP_DD depend on
> CPU_SUP_AMD || ARM64 and CRYPTO_DEV_SP_PSP depend on X86_64 and send you
> v4.2.

No, please add my patch below to your set for the CRYPTO_DEV_CCP_DD
dependency as it is a separate thing. Your patch should concentrate only
on adding the PSP and its dependencies.

Thx.

---
From: Borislav Petkov <bp@suse.de>
Date: Sat, 30 Sep 2017 10:06:27 +0200
Subject: [PATCH] crypto: ccp: Build the AMD secure processor driver only with
 AMD CPU support

This is AMD-specific hardware so present it in Kconfig only when AMD
CPU support is enabled or on ARM64 where it is also used.

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
index 627f3e61dcac..f19f57162225 100644
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
2.13.0

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
