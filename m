From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/6] crypto: talitos - remove calls to of_node_put
Date: Wed, 16 Jul 2008 18:21:46 -0500
Message-ID: <20080716182146.0b095f5d.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev <linuxppc-dev@ozlabs.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:39491 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758359AbYGPXWd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 19:22:33 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lee Nipper <lee.nipper@freescale.com>

Remove of_node_put calls since there is no corresponding of_node_get.
This patch prevents an exception when talitos is loaded a 2nd time.
This sequence: modprobe talitos; rmmod talitos; modprobe talitos
causes this message: "WARNING: Bad of_node_put() on /soc8349@e0000000/crypto@30000".

Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
this patchseries contains various fixes to the talitos driver, mainly as a
result of Lee's stress testing.

 drivers/crypto/talitos.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b11943d..01e6595 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1466,9 +1466,6 @@ static int talitos_probe(struct of_device *ofdev,
 		goto err_out;
 	}
 
-	of_node_put(np);
-	np = NULL;
