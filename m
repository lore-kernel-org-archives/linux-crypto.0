From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: pcrypt - Fix use after free on padata_free
Date: Fri, 26 Nov 2010 08:49:17 +0100
Message-ID: <20101126074916.GQ1868@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:51822 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0KZHtV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Nov 2010 02:49:21 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

kobject_put is called from padata_free for the padata kobject.
The kobject's release function frees the padata instance,
so don't call kobject_put for the padata kobject from pcrypt.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 crypto/pcrypt.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index de30782..75586f1 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -504,7 +504,6 @@ err:
 
 static void pcrypt_fini_padata(struct padata_pcrypt *pcrypt)
 {
-	kobject_put(&pcrypt->pinst->kobj);
 	free_cpumask_var(pcrypt->cb_cpumask->mask);
 	kfree(pcrypt->cb_cpumask);
 
-- 
1.7.0.4
