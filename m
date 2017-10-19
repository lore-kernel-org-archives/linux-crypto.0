From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 1/2] random: always call random ready function
Date: Thu, 19 Oct 2017 22:45:05 +0200
Message-ID: <20171019204506.25090-1-Jason@zx2c4.com>
References: <CAHmME9qwoSwFi7fsg1Z+gcEh1fBY+KY2rJ81UTHYn2ZMcjjwFA@mail.gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        tytso@mit.edu, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:57167 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753212AbdJSUp0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2017 16:45:26 -0400
In-Reply-To: <CAHmME9qwoSwFi7fsg1Z+gcEh1fBY+KY2rJ81UTHYn2ZMcjjwFA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As this interface becomes more heavily used, it will be painful for
callers to always need to check for -EALREADY.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8ad92707e45f..e161acf35d4a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1556,40 +1556,45 @@ EXPORT_SYMBOL(wait_for_random_bytes);
 
 /*
  * Add a callback function that will be invoked when the nonblocking
- * pool is initialised.
+ * pool is initialised, or calls that function if it already is.
  *
  * returns: 0 if callback is successfully added
- *	    -EALREADY if pool is already initialised (callback not called)
  *	    -ENOENT if module for callback is not alive
  */
 int add_random_ready_callback(struct random_ready_callback *rdy)
 {
 	struct module *owner;
 	unsigned long flags;
-	int err = -EALREADY;
 
-	if (crng_ready())
-		return err;
+	BUG_ON(!rdy->func);
+
+	if (crng_ready()) {
+		rdy->func(rdy);
+		rdy->func = NULL;
+		return 0;
+	}
 
 	owner = rdy->owner;
 	if (!try_module_get(owner))
 		return -ENOENT;
 
 	spin_lock_irqsave(&random_ready_list_lock, flags);
-	if (crng_ready())
+	if (crng_ready()) {
+		rdy->func(rdy);
+		rdy->func = NULL;
 		goto out;
+	}
 
 	owner = NULL;
 
 	list_add(&rdy->list, &random_ready_list);
-	err = 0;
 
 out:
 	spin_unlock_irqrestore(&random_ready_list_lock, flags);
 
 	module_put(owner);
 
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL(add_random_ready_callback);
 
@@ -1601,6 +1606,9 @@ void del_random_ready_callback(struct random_ready_callback *rdy)
 	unsigned long flags;
 	struct module *owner = NULL;
 
+	if (!rdy->func)
+		return;
+
 	spin_lock_irqsave(&random_ready_list_lock, flags);
 	if (!list_empty(&rdy->list)) {
 		list_del_init(&rdy->list);
-- 
2.14.2
