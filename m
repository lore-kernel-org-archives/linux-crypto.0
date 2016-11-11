From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] crypto: nx - drop duplicate header types.h
Date: Fri, 11 Nov 2016 20:50:38 +0800
Message-ID: <3923d14d2f0129262f8088e1a1880718765fdce9.1478868492.git.geliangtang@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
To: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33419 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756399AbcKKMup (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 07:50:45 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Drop duplicate header types.h from nx.c.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/crypto/nx/nx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 42f0f22..036057a 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -32,7 +32,6 @@
 #include <linux/scatterlist.h>
 #include <linux/device.h>
 #include <linux/of.h>
-#include <linux/types.h>
 #include <asm/hvcall.h>
 #include <asm/vio.h>
 
-- 
2.9.3
