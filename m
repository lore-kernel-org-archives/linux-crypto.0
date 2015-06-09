From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] random: Remove kernel blocking API
Date: Tue, 09 Jun 2015 18:19:42 +0800
Message-ID: <E1Z2GdC-0002nC-Br@gondolin.me.apana.org.au>
References: <20150609101830.GA10521@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>, Ted Tso <tytso@mit.edu>,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58491 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbbFIKTy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 06:19:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes the kernel blocking API as it has been completely
replaced by the callback API.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/char/random.c  |   12 ------------
 include/linux/random.h |    1 -
 2 files changed, 13 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index a1576ed..d0da5d8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1265,18 +1265,6 @@ void get_random_bytes(void *buf, int nbytes)
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
- * Equivalent function to get_random_bytes with the difference that this
- * function blocks the request until the nonblocking_pool is initialized.
- */
-void get_blocking_random_bytes(void *buf, int nbytes)
-{
-	if (unlikely(nonblocking_pool.initialized == 0))
-		wait_event(urandom_init_wait, nonblocking_pool.initialized);
-	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
-}
-EXPORT_SYMBOL(get_blocking_random_bytes);
-
-/*
  * Add a callback function that will be invoked when the nonblocking
  * pool is initialised.
  *
diff --git a/include/linux/random.h b/include/linux/random.h
index 30e2aca..e651874 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -21,7 +21,6 @@ extern void add_input_randomness(unsigned int type, unsigned int code,
 extern void add_interrupt_randomness(int irq, int irq_flags);
 
 extern void get_random_bytes(void *buf, int nbytes);
-extern void get_blocking_random_bytes(void *buf, int nbytes);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
 extern void get_random_bytes_arch(void *buf, int nbytes);
