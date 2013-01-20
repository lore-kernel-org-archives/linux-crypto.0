From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 22/36]
 arch/x86/crypto/crc32-pclmul_asm.S:87:2: warning: #warning Using 32bit
 code support
Date: Sun, 20 Jan 2013 18:05:31 +1100
Message-ID: <20130120070531.GA27746@gondor.apana.org.au>
References: <50fb3f38.VIxxNsjMujPGjroT%fengguang.wu@intel.com>
 <20130120005545.GA3328@gondor.apana.org.au>
 <50FB86D9.1070200@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Alexander Boyko <alexander_boyko@xyratex.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:59888 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750808Ab3ATHFj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Jan 2013 02:05:39 -0500
Content-Disposition: inline
In-Reply-To: <50FB86D9.1070200@xyratex.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 20, 2013 at 09:55:37AM +0400, Alexander Boyko wrote:
> You can kill it.

OK.

commit 7983627657db5e37594af5c28cdb623855eb554f
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Jan 20 18:05:02 2013 +1100

    crypto: crc32-pclmul - Kill warning on x86-32
    
    This patch removes a gratuitous warning on x86-32:
    
    arch/x86/crypto/crc32-pclmul_asm.S:87:2: warning: #warning Using 32bit code support [-Wcpp]
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/crc32-pclmul_asm.S b/arch/x86/crypto/crc32-pclmul_asm.S
index 65ea6a6..c8335014 100644
--- a/arch/x86/crypto/crc32-pclmul_asm.S
+++ b/arch/x86/crypto/crc32-pclmul_asm.S
@@ -84,7 +84,6 @@
 #define LEN     %rsi
 #define CRC     %edx
 #else
-#warning Using 32bit code support
 #define BUF     %eax
 #define LEN     %edx
 #define CRC     %ecx

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
