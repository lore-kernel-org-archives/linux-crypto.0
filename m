From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] crypto: add .gitignore for crypto/*.-asn1.[ch] files
Date: Thu, 25 Jun 2015 16:18:03 +0600
Message-ID: <1435227483-15604-1-git-send-email-kuleshovmail@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org,
	Alexander Kuleshov <kuleshovmail@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:35062 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbbFYKSJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 06:18:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There are two generated files: crypto/rsakey-asn1.c and crypto/raskey-asn1.h,
after the cfc2bb32b31371d6bffc6bf2da3548f20ad48c83 commit. Let's add
.gitignore to ignore *-asn1.[ch] files.

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 crypto/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 crypto/.gitignore

diff --git a/crypto/.gitignore b/crypto/.gitignore
new file mode 100644
index 0000000..ee32837
--- /dev/null
+++ b/crypto/.gitignore
@@ -0,0 +1 @@
+*-asn1.[ch]
-- 
2.4.4.410.gc71d752
