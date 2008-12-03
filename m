From: Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH] crypto: talitos - Fix modpost warning
Date: Tue,  2 Dec 2008 22:29:16 -0600
Message-ID: <1228278556-1056-1-git-send-email-galak@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-crypto@vger.kernel.org,
	kim.phillips@freescale.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:53199 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbYLCEbi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2008 23:31:38 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Removed __devexit from talitos_remove() since its also called from
talitos_probe().

WARNING: vmlinux.o(.text+0x28a008): Section mismatch in reference from the function talitos_probe() to the function .devexit.text:talitos_remove()
The function talitos_probe() references a function in an exit section.
Often the function talitos_remove() has valid usage outside the exit section
and the fix is to remove the __devexit annotation of talitos_remove.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/crypto/talitos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b6ad3ac..2479348 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1357,7 +1357,7 @@ static int hw_supports(struct device *dev, __be32 desc_hdr_template)
 	return ret;
 }
 
-static int __devexit talitos_remove(struct of_device *ofdev)
+static int talitos_remove(struct of_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct talitos_private *priv = dev_get_drvdata(dev);
-- 
1.5.6.5

