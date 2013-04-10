From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH] crypto: aesni_intel - fix Kconfig problem with
 CRYPTO_GLUE_HELPER_X86
Date: Wed, 10 Apr 2013 18:39:20 +0300
Message-ID: <20130410153920.15657.98615.stgit@localhost6.localdomain6>
References: <51652688.vLFH53k1uKh/xP2W%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, kbuild test robot <fengguang.wu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:57244 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763998Ab3DJPjY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Apr 2013 11:39:24 -0400
In-Reply-To: <51652688.vLFH53k1uKh/xP2W%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The Kconfig setting for glue helper module is CRYPTO_GLUE_HELPER_X86, but
recent change for aesni_intel used CRYPTO_GLUE_HELPER instead. Patch corrects
this issue.

Cc: kbuild-all@01.org
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 808ac37..0e7a237 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -678,7 +678,7 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_CRYPTD
 	select CRYPTO_ABLK_HELPER_X86
 	select CRYPTO_ALGAPI
-	select CRYPTO_GLUE_HELPER if 64BIT
+	select CRYPTO_GLUE_HELPER_X86 if 64BIT
 	select CRYPTO_LRW
 	select CRYPTO_XTS
 	help
