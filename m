From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] crypto/ccp: remove rwlocks_types.h
Date: Wed, 11 May 2016 12:06:20 +0200
Message-ID: <1462961180-11135-1-git-send-email-bigeasy@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, tglx@linutronix.de,
	Peter Zijlstra <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:47623 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbcEKKGZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 06:06:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Users of rwlocks should include spinlock.h instead including this
header file. The current users of rwlocks_types.h are internal.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/crypto/ccp/ccp-dev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 4dbc18727235..2a8ad712a5f2 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -16,7 +16,6 @@
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <linux/rwlock_types.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
-- 
2.8.1
