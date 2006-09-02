From: rsnel@cube.dyndns.org
Subject: [PATCHv2 1/6] crypto: trivial comment improvements
Date: Sat, 02 Sep 2006 03:00:22 +0200
Message-ID: <11571588302892-git-send-email-rsnel@cube.dyndns.org>
References: <20060901103707.GA17110@gondor.apana.org.au>
Reply-To: rsnel@cube.dyndns.org
Cc: linux-crypto@vger.kernel.org, Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:51981 "EHLO
	smtp-vbr13.xs4all.nl") by vger.kernel.org with ESMTP
	id S1750774AbWIBBAp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Sep 2006 21:00:45 -0400
To: herbert@gondor.apana.org.au
In-Reply-To: <20060901103707.GA17110@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Rik Snel <rsnel@cube.dyndns.org>

Just some minor comment nits.

- little-endian is better than low-endian
- and since it is called essiv everywere it should also be essiv
  in the comments (and not ess_iv)

Signed-off-by: Rik Snel <rsnel@cube.dyndns.org>
---
 drivers/md/dm-crypt.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 91d4081..06961f7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -99,12 +99,12 @@ static kmem_cache_t *_crypt_io_pool;
 /*
  * Different IV generation algorithms:
  *
- * plain: the initial vector is the 32-bit low-endian version of the sector
+ * plain: the initial vector is the 32-bit little-endian version of the sector
  *        number, padded with zeros if neccessary.
  *
- * ess_iv: "encrypted sector|salt initial vector", the sector number is
- *         encrypted with the bulk cipher using a salt as key. The salt
- *         should be derived from the bulk cipher's key via hashing.
+ * essiv: "encrypted sector|salt initial vector", the sector number is
+ *        encrypted with the bulk cipher using a salt as key. The salt
+ *        should be derived from the bulk cipher's key via hashing.
  *
  * plumb: unimplemented, see:
  * http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/454
-- 
1.4.1.1


-- 
VGER BF report: U 0.496196
