From: Axel Lin <axel.lin@ingics.com>
Subject: [PATCH] crypto: picoxcell: Add terminating entry for
 platform_device_id table
Date: Sun, 04 Nov 2012 23:36:25 +0800
Message-ID: <1352043385.11324.4.camel@phoenix>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jamie Iles <jamie@jamieiles.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37675 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2KDPgc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Nov 2012 10:36:32 -0500
Received: by mail-pb0-f46.google.com with SMTP id rr4so3380976pbb.19
        for <linux-crypto@vger.kernel.org>; Sun, 04 Nov 2012 07:36:32 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The platform_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/crypto/picoxcell_crypto.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 410a03c..f4d3d8f 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1863,6 +1863,7 @@ static int __devexit spacc_remove(struct platform_device *pdev)
 static const struct platform_device_id spacc_id_table[] = {
 	{ "picochip,spacc-ipsec", },
 	{ "picochip,spacc-l2", },
+	{ }
 };
 
 static struct platform_driver spacc_driver = {
-- 
1.7.9.5
