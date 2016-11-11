From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] crypto: jitterentropy - drop duplicate header module.h
Date: Fri, 11 Nov 2016 20:45:00 +0800
Message-ID: <964e57d45e980dce9a3f0a3ae22e3e07dae90b9f.1478868167.git.geliangtang@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34285 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756512AbcKKMpH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2016 07:45:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Drop duplicate header module.h from jitterentropy-kcapi.c.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 crypto/jitterentropy-kcapi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index c4938497..787dccc 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -39,7 +39,6 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/fips.h>
 #include <linux/time.h>
 #include <linux/crypto.h>
-- 
2.9.3
