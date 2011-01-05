From: Dennis Gilmore <dgilmore@redhat.com>
Subject: [PATCH] crypto: use __devexit not __exit in n2_unregister_algs
Date: Wed,  5 Jan 2011 15:36:27 -0600
Message-ID: <1294263387-8984-1-git-send-email-dgilmore@redhat.com>
Cc: dennis <dennis@daedalus.ausil.us>,
	Dennis Gilmore <dgilmore@redhat.com>
To: linux-crypto@vger.kernel.org, herbert@gondoa.apana.org.au,
	David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.ausil.us ([74.119.218.133]:53269 "EHLO mail.ausil.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1AEVzU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Jan 2011 16:55:20 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: dennis <dennis@daedalus.ausil.us>

fixes fedora sparc build failure, thanks to kylem for helping with debugging

Signed-off-by: Dennis Gilmore <dgilmore@redhat.com>
---
 drivers/crypto/n2_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 88ee015..3372491 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1542,7 +1542,7 @@ out:
 	return err;
 }
 
-static void __exit n2_unregister_algs(void)
+static void __devexit n2_unregister_algs(void)
 {
 	mutex_lock(&spu_lock);
 	if (!--algs_registered)
-- 
1.7.3.4
