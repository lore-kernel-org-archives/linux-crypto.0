From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/3] crypto: talitos - fix warning: 'alg' may be used
 uninitialized in this function
Date: Mon, 13 Sep 2010 17:45:33 -0500
Message-ID: <20100913174533.43d052ab.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:10939
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab0IMWpn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Sep 2010 18:45:43 -0400
Received: from mail6-db3 (localhost.localdomain [127.0.0.1])	by
 mail6-db3-R.bigfish.com (Postfix) with ESMTP id A03A0DB0323	for
 <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 22:55:05 +0000 (UTC)
Received: from DB3EHSMHS002.bigfish.com (unknown [10.3.81.250])	by
 mail6-db3.bigfish.com (Postfix) with ESMTP id 0F26522004B	for
 <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 22:55:00 +0000 (UTC)
Received: from az33smr02.freescale.net (az33smr02.freescale.net
 [10.64.34.200])	by de01egw02.freescale.net (8.14.3/8.14.3) with ESMTP id
 o8DMjYD4008140	for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 15:45:34
 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net
 [10.64.32.10])	by az33smr02.freescale.net (8.13.1/8.13.0) with ESMTP id
 o8DMjeqQ018070	for <linux-crypto@vger.kernel.org>; Mon, 13 Sep 2010 17:45:40
 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

drivers/crypto/talitos.c: In function 'talitos_probe':
drivers/crypto/talitos.c:2363: warning: 'alg' may be used uninitialized in this function
drivers/crypto/talitos.c:2363: note: 'alg' was declared here

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4bcd825..d4c1fc2 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2389,6 +2389,9 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 					DESC_HDR_MODE0_MDEU_SHA256;
 		}
 		break;
+	default:
+		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
+		return ERR_PTR(-EINVAL);
 	}
 
 	alg->cra_module = THIS_MODULE;
-- 
1.7.1
