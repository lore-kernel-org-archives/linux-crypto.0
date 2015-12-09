From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] crypto: asymmetric_keys/signature.c does not need <module.h>
Date: Wed, 9 Dec 2015 15:05:28 -0500
Message-ID: <1449691528-29040-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:33934 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbLIUGA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 15:06:00 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This file does not contain any modular related function calls.  So get
rid of module.h since it drags in a lot of other headers and adds to
the preprocessing load.  It does export some symbols though, so we'll
need to ensure it has export.h present instead.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 crypto/asymmetric_keys/signature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/signature.c b/crypto/asymmetric_keys/signature.c
index 7525fd183574..da0821eb69fd 100644
--- a/crypto/asymmetric_keys/signature.c
+++ b/crypto/asymmetric_keys/signature.c
@@ -13,7 +13,7 @@
 
 #define pr_fmt(fmt) "SIG: "fmt
 #include <keys/asymmetric-subtype.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/err.h>
 #include <crypto/public_key.h>
 #include "asymmetric_keys.h"
-- 
2.5.0
