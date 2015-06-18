From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] MAINTAINERS: clarify drivers/crypto/nx/ file ownership
Date: Thu, 18 Jun 2015 12:28:32 -0400
Message-ID: <1434644912-18807-1-git-send-email-ddstreet@ieee.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33405 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbbFRQ2r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 12:28:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update the "IBM Power in-Nest Crypto Acceleration" and
"IBM Power 842 compression accelerator" sections to specify the correct
files.

The "IBM Power in-Nest Crypto Acceleration" was originally the only
NX driver, and so its section listed all drivers/crypto/nx/ files,
but now there is also the 842 driver which has its own section.  This
lists explicitly what files are owned by the Crypto driver and which
files are owned by the 842 compression driver.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
Leonidas, I assume you'll update the owner line at some point too,
since you're the new NX Crypto owner.

 MAINTAINERS | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb06e1e..d6fb983 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4856,11 +4856,19 @@ M:	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>
 M:	Fionnuala Gunter <fin@linux.vnet.ibm.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
-F:	drivers/crypto/nx/
+F:	drivers/crypto/nx/Makefile
+F:	drivers/crypto/nx/Kconfig
+F:	drivers/crypto/nx/nx-aes*
+F:	drivers/crypto/nx/nx-sha*
+F:	drivers/crypto/nx/nx.*
+F:	drivers/crypto/nx/nx_csbcpb.h
+F:	drivers/crypto/nx/nx_debugfs.h
 
 IBM Power 842 compression accelerator
 M:	Dan Streetman <ddstreet@us.ibm.com>
 S:	Supported
+F:	drivers/crypto/nx/Makefile
+F:	drivers/crypto/nx/Kconfig
 F:	drivers/crypto/nx/nx-842*
 F:	include/linux/sw842.h
 F:	crypto/842.c
-- 
2.1.0
