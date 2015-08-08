From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: [PATCH] Update NX crypto driver maintainers and adding VMX
 maintainers
Date: Sat, 8 Aug 2015 18:29:27 -0300
Message-ID: <20150808212924.GA5448@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-kernel@vger.kernel.org, psfmorigo@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:34995 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992701AbbHHV3e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Aug 2015 17:29:34 -0400
Received: from /spool/local
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Sat, 8 Aug 2015 18:29:32 -0300
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Marcelo and Fin are no long IBMers, thus no longer NX maintainers.
Updating with the new names.

Adding VMX crypto maintainers.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 MAINTAINERS | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a9ae6c1..b66d359 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5067,9 +5067,21 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
 S:	Maintained
 F:	arch/ia64/
 
+IBM Power VMX Cryptographic instructions
+M:	Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
+M: 	Paulo Flabiano Smorigo <pfsmorigo.vnet.ibm.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/crypto/vmx/Makefile
+F:	drivers/crypto/vmx/Kconfig
+F:	drivers/crypto/vmx/vmx.c
+F:	drivers/crypto/vmx/aes*
+F:	drivers/crypto/vmx/ghash*
+F:	drivers/crypto/vmx/ppc-xlate.pl
+
 IBM Power in-Nest Crypto Acceleration
-M:	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
-M:	Fionnuala Gunter <fin@linux.vnet.ibm.com>
+M:	Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
+M:	Paulo Flabiano Smorigo <pfsmorigo.vnet.ibm.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/nx/Makefile
-- 
1.8.3.1
