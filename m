From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 2/2] crypto: caam - fix RNG init for SEC with RNG version greater than 4
Date: Tue, 5 Feb 2013 12:21:25 +0200
Message-ID: <1360059685-4953-3-git-send-email-alexandru.porosanu@freescale.com>
References: <1360059685-4953-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:15760
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985Ab3BEKW1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Feb 2013 05:22:27 -0500
Received: from mail87-co9 (localhost [127.0.0.1])	by mail87-co9-R.bigfish.com
 (Postfix) with ESMTP id 502892603EA	for <linux-crypto@vger.kernel.org>; Tue,
  5 Feb 2013 10:22:27 +0000 (UTC)
Received: from CO9EHSMHS012.bigfish.com (unknown [10.236.132.239])	by
 mail87-co9.bigfish.com (Postfix) with ESMTP id 1BBB9400077	for
 <linux-crypto@vger.kernel.org>; Tue,  5 Feb 2013 10:22:26 +0000 (UTC)
Received: from localhost.localdomain ([10.171.77.122])	by
 az84smr01.freescale.net (8.14.3/8.14.0) with ESMTP id r15AMLxJ028285	for
 <linux-crypto@vger.kernel.org>; Tue, 5 Feb 2013 03:22:23 -0700
In-Reply-To: <1360059685-4953-1-git-send-email-alexandru.porosanu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For SEC including a RNG block with a version greater than 4,
special initialization must occur before any descriptor can be
submitted. Not only SEC with a version greater than 5.0 need
this, but also any SEC that has RNG block version ID greater
or equal to 4.

Example platforms: BSC 9131/9132 have SEC v4.4 but RNG 4

Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
---
 drivers/crypto/caam/ctrl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index d5e6837..132b98a 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -305,10 +305,10 @@ static int caam_probe(struct platform_device *pdev)
 	}
 
 	/*
-	 * RNG4 based SECs (v5+) need special initialization prior
+	 * RNG4 based SECs need special initialization prior
 	 * to executing any descriptors
 	 */
-	if (of_device_is_compatible(nprop, "fsl,sec-v5.0")) {
+	if (get_rng_vid(topregs) >= 4) {
 		kick_trng(pdev);
 		ret = instantiate_rng(ctrlpriv->jrdev[0]);
 		if (ret) {
-- 
1.7.7.6
