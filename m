From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/7] random: print a warning for the first ten uninitialized random users
Date: Mon, 13 Jun 2016 11:48:34 -0400
Message-ID: <1465832919-11316-3-git-send-email-tytso@mit.edu>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com,
	Theodore Ts'o <tytso@mit.edu>, stable@kernel.org
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45062 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424453AbcFMPt2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 11:49:28 -0400
In-Reply-To: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since systemd is consistently using /dev/urandom before it is
initialized, we can't see the other potentially dangerous users of
/dev/urandom immediately after boot.  So print the first ten such
complaints instead.

Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4e2627a..74596d3 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1458,12 +1458,16 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
+	static int maxwarn = 10;
 	int ret;
 
-	if (unlikely(nonblocking_pool.initialized == 0))
-		printk_once(KERN_NOTICE "random: %s urandom read "
-			    "with %d bits of entropy available\n",
-			    current->comm, nonblocking_pool.entropy_total);
+	if (unlikely(nonblocking_pool.initialized == 0) &&
+	    maxwarn > 0) {
+		maxwarn--;
+		printk(KERN_NOTICE "random: %s: uninitialized urandom read "
+		       "(%d bytes read, %d bits of entropy available)\n",
+		       current->comm, nbytes, nonblocking_pool.entropy_total);
+	}
 
 	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
 	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
-- 
2.5.0
