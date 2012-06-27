From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: algapi - Fix hang on crypto allocation
Date: Wed, 27 Jun 2012 13:31:01 +0200
Message-ID: <20120627113101.GB1869@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:43726 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab2F0L6d (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jun 2012 07:58:33 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

git commit 398710379 (crypto: algapi - Move larval completion
into algboss) replaced accidentally a call to complete_all() by
a call to complete(). This causes a hang on crypto allocation
if we have more than one larval waiter. This pach restores the
call to complete_all().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/algboss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index f97027e..769219b 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -87,7 +87,7 @@ static int cryptomgr_probe(void *data)
 	crypto_tmpl_put(tmpl);
 
 out:
-	complete(param->completion);
+	complete_all(param->completion);
 	kfree(param);
 	module_put_and_exit(0);
 }
-- 
1.7.0.4
