From: David Miller <davem@davemloft.net>
Subject: [PATCH 5/7] n2_crypto: Log algorithm success/failure in kernel log.
Date: Tue, 25 May 2010 17:43:42 -0700 (PDT)
Message-ID: <20100525.174342.28815272.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37731
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758463Ab0EZAnc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 May 2010 20:43:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/crypto/n2_core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 3a4eed4..77939e4 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1277,8 +1277,11 @@ static int __devinit __n2_register_one_cipher(const struct n2_cipher_tmpl *tmpl)
 	list_add(&p->entry, &cipher_algs);
 	err = crypto_register_alg(alg);
 	if (err) {
+		pr_err("%s alg registration failed\n", alg->cra_name);
 		list_del(&p->entry);
 		kfree(p);
+	} else {
+		pr_info("%s alg registered\n", alg->cra_name);
 	}
 	return err;
 }
@@ -1318,8 +1321,11 @@ static int __devinit __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 	list_add(&p->entry, &ahash_algs);
 	err = crypto_register_ahash(ahash);
 	if (err) {
+		pr_err("%s alg registration failed\n", base->cra_name);
 		list_del(&p->entry);
 		kfree(p);
+	} else {
+		pr_info("%s alg registered\n", base->cra_name);
 	}
 	return err;
 }
-- 
1.7.0.4
