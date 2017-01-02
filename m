From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] crypto: picoxcell - Fix module autoload for non-OF registration
Date: Mon,  2 Jan 2017 12:38:02 -0300
Message-ID: <1483371482-4956-1-git-send-email-javier@osg.samsung.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Jamie Iles <jamie@jamieiles.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57006
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932966AbdABPiQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Jan 2017 10:38:16 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the driver is built as a module, autoload won't work because the module
alias information is not filled. So user-space can't match the registered
device with the corresponding module if the device isn't registered via OF.

Export the module alias information using the MODULE_DEVICE_TABLE() macro.

Before this patch:

$ modinfo drivers/crypto/picoxcell_crypto.ko | grep alias
alias:          of:N*T*Cpicochip,spacc-l2C*
alias:          of:N*T*Cpicochip,spacc-l2
alias:          of:N*T*Cpicochip,spacc-ipsecC*
alias:          of:N*T*Cpicochip,spacc-ipsec

After this patch:

$ modinfo drivers/crypto/picoxcell_crypto.ko | grep alias
alias:          of:N*T*Cpicochip,spacc-l2C*
alias:          of:N*T*Cpicochip,spacc-l2
alias:          of:N*T*Cpicochip,spacc-ipsecC*
alias:          of:N*T*Cpicochip,spacc-ipsec
alias:          platform:picochip,spacc-l2
alias:          platform:picochip,spacc-ipsec

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/crypto/picoxcell_crypto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 47576098831f..64449b7c00af 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1808,6 +1808,7 @@ static const struct platform_device_id spacc_id_table[] = {
 	{ "picochip,spacc-l2", },
 	{ }
 };
+MODULE_DEVICE_TABLE(platform, spacc_id_table);
 
 static struct platform_driver spacc_driver = {
 	.probe		= spacc_probe,
-- 
2.7.4
