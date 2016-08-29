From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: hide unused label
Date: Mon, 29 Aug 2016 14:38:25 +0200
Message-ID: <20160829123837.3363565-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:55550 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756406AbcH2Mi4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2016 08:38:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto/xor.c: In function 'calibrate_xor_blocks':
crypto/xor.c:156:1: error: label 'out' defined but not used [-Werror=unused-label]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 39457acda913 ("crypto: xor - skip speed test if the xor function is selected automatically")
---
 crypto/xor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/xor.c b/crypto/xor.c
index b8975d92cd94..1817015381ef 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -153,7 +153,9 @@ calibrate_xor_blocks(void)
 #undef xor_speed
 
 	free_pages((unsigned long)b1, 2);
+#ifdef XOR_SELECT_TEMPLATE
 out:
+#endif
 	active_template = fastest;
 	return 0;
 }
-- 
2.9.0
