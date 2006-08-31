From: Rik Snel <rsnel@cube.dyndns.org>
Subject: [PATCH 1/6] crypto: trivial comment improvements
Date: Thu, 31 Aug 2006 14:39:31 +0200
Message-ID: <11570279781564-git-send-email-rsnel@cube.dyndns.org>
References: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Reply-To: Rik Snel <rsnel@cube.dyndns.org>
Cc: linux-crypto@vger.kernel.org, Rik Snel <rsnel@cube.dyndns.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:12041 "EHLO
	smtp-vbr4.xs4all.nl") by vger.kernel.org with ESMTP id S932168AbWHaMkW
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Aug 2006 08:40:22 -0400
To: herbert@gondor.apana.org.au
In-Reply-To: <11570279761772-git-send-email-rsnel@cube.dyndns.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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

