From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: [patch] crypto,ccp: Fix RT breaking #include <linux/rwlock_types.h>
Date: Tue, 05 Apr 2016 15:03:21 +0200
Message-ID: <1459861401.7776.4.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Gary R Hook <gary.hook@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38819 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305AbcDENDZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 09:03:25 -0400
Received: by mail-wm0-f48.google.com with SMTP id u206so3311846wme.1
        for <linux-crypto@vger.kernel.org>; Tue, 05 Apr 2016 06:03:24 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Direct include of rwlock_types.h breaks RT, use spinlock_types.h instead.

Fixes: 553d2374db0b crypto: ccp - Support for multiple CCPs
Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
---
 drivers/crypto/ccp/ccp-dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -16,7 +16,7 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <linux/rwlock_types.h>
+#include <linux/spinlock_types.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
