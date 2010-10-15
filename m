From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2.6.36-rc7] crypto: use cancel_delayed_work_sync() in hifn_795x
Date: Fri, 15 Oct 2010 14:09:00 +0200
Message-ID: <4CB8445C.1060109@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:49975 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab0JOMJI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Oct 2010 08:09:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make hifn_795x::hifn_remove() call cancel_delayed_work_sync() instead
of calling cancel_delayed_work() followed by flush_scheduled_work().

This is to prepare for the deprecation and removal of
flush_scheduled_work().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/crypto/hifn_795x.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: work/drivers/crypto/hifn_795x.c
===================================================================
--- work.orig/drivers/crypto/hifn_795x.c
+++ work/drivers/crypto/hifn_795x.c
@@ -2700,8 +2700,7 @@ static void __devexit hifn_remove(struct
 	dev = pci_get_drvdata(pdev);

 	if (dev) {
-		cancel_delayed_work(&dev->work);
-		flush_scheduled_work();
+		cancel_delayed_work_sync(&dev->work);

 		hifn_unregister_rng(dev);
 		hifn_unregister_alg(dev);
