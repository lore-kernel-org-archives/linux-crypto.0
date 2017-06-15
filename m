From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] crypto: n2: make of_device_ids const
Date: Thu, 15 Jun 2017 17:28:10 +0530
Message-ID: <9ab9e99928c8add9d11779c5f5a267f10f166875.1497527778.git.arvind.yadav.cs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36683 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752141AbdFOL6l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2017 07:58:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

of_device_ids are not supposed to change at runtime. All functions
working with of_device_ids provided by <linux/of.h> work with const
of_device_ids. So mark the non-const structs as const.

File size before:
   text	   data	    bss	    dec	    hex	filename
   2001	   2168	     48	   4217	   1079	drivers/crypto/n2_core.o

File size after constify dummy_tlb_ops.:
   text	   data	    bss	    dec	    hex	filename
   3601	    536	     48	   4185	   1059	drivers/crypto/n2_core.o

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/crypto/n2_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 4ecb77a..2694513 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -2169,7 +2169,7 @@ static int n2_mau_remove(struct platform_device *dev)
 	return 0;
 }
 
-static struct of_device_id n2_crypto_match[] = {
+static const struct of_device_id n2_crypto_match[] = {
 	{
 		.name = "n2cp",
 		.compatible = "SUNW,n2-cwq",
@@ -2196,7 +2196,7 @@ static int n2_mau_remove(struct platform_device *dev)
 	.remove		=	n2_crypto_remove,
 };
 
-static struct of_device_id n2_mau_match[] = {
+static const struct of_device_id n2_mau_match[] = {
 	{
 		.name = "ncp",
 		.compatible = "SUNW,n2-mau",
-- 
1.9.1
