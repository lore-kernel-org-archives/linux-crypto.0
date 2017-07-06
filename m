From: Chris Gorman <chrisjohgorman@gmail.com>
Subject: [PATCH] drivers: crypto: geode-aes: fixed coding style warnings and error
Date: Thu,  6 Jul 2017 14:44:56 -0400
Message-ID: <1499366696-7243-1-git-send-email-chrisjohgorman@gmail.com>
Cc: linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chris Gorman <chrisjohgorman@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34551 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbdGFSpG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2017 14:45:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

fixed WARNING: Block comments should align the * on each line
fixed WARNINGs: Missing a blank line after declarations
fixed ERROR: space prohibited before that ',' (ctx:WxE)

Signed-off-by: Chris Gorman <chrisjohgorman@gmail.com>
---
 drivers/crypto/geode-aes.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index fe538e5..eb2a0a7 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -1,10 +1,10 @@
  /* Copyright (C) 2004-2006, Advanced Micro Devices, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+  *
+  * This program is free software; you can redistribute it and/or modify
+  * it under the terms of the GNU General Public License as published by
+  * the Free Software Foundation; either version 2 of the License, or
+  * (at your option) any later version.
+  */
 
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -30,6 +30,7 @@ static inline void
 _writefield(u32 offset, void *value)
 {
 	int i;
+
 	for (i = 0; i < 4; i++)
 		iowrite32(((u32 *) value)[i], _iobase + offset + (i * 4));
 }
@@ -39,6 +40,7 @@ static inline void
 _readfield(u32 offset, void *value)
 {
 	int i;
+
 	for (i = 0; i < 4; i++)
 		((u32 *) value)[i] = ioread32(_iobase + offset + (i * 4));
 }
@@ -515,6 +517,7 @@ static void geode_aes_remove(struct pci_dev *dev)
 static int geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	int ret;
+
 	ret = pci_enable_device(dev);
 	if (ret)
 		return ret;
@@ -570,7 +573,7 @@ static int geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 }
 
 static struct pci_device_id geode_aes_tbl[] = {
-	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_LX_AES), } ,
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_LX_AES), },
 	{ 0, }
 };
 
-- 
2.7.4
