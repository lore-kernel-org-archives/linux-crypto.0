From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] crypto: pcomp - pcompress.c should include <crypto/internal/compress.h>
Date: Wed, 25 Mar 2009 16:17:18 +0100
Message-ID: <1237994238-3545-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1237994238-3545-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59401 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755135AbZCYPRW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Mar 2009 11:17:22 -0400
In-Reply-To: <1237994238-3545-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

make C=1:
| crypto/pcompress.c:77:5: warning: symbol 'crypto_register_pcomp' was not declared. Should it be static?
| crypto/pcompress.c:89:5: warning: symbol 'crypto_unregister_pcomp' was not declared. Should it be static?

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/pcompress.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/crypto/pcompress.c b/crypto/pcompress.c
index ca9a4af..bcadc03 100644
--- a/crypto/pcompress.c
+++ b/crypto/pcompress.c
@@ -26,6 +26,7 @@
 #include <linux/string.h>
 
 #include <crypto/compress.h>
+#include <crypto/internal/compress.h>
 
 #include "internal.h"
 
-- 
1.6.0.4

