From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] MAINTAINERS: change 842 NX owner email address
Date: Wed, 29 Jul 2015 19:50:46 -0400
Message-ID: <1438213846-7327-1-git-send-email-ddstreet@ieee.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35318 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbbG2Xu7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jul 2015 19:50:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change my IBM email to my personal IEEE email.

I'm leaving IBM, so my email there won't work anymore.  This changes
the owner to my personal email, so I can still get cc'ed on patches,
until someone at IBM sends a patch to take it over.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 91e9b78..6295ec5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5073,7 +5073,7 @@ F:	drivers/crypto/nx/nx_csbcpb.h
 F:	drivers/crypto/nx/nx_debugfs.h
 
 IBM Power 842 compression accelerator
-M:	Dan Streetman <ddstreet@us.ibm.com>
+M:	Dan Streetman <ddstreet@ieee.org>
 S:	Supported
 F:	drivers/crypto/nx/Makefile
 F:	drivers/crypto/nx/Kconfig
-- 
2.1.0
