From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] random: add backtracking protection to the CRNG
Date: Mon, 30 May 2016 01:39:24 -0400
Message-ID: <1464586765-14436-5-git-send-email-tytso@mit.edu>
References: <1464586765-14436-1-git-send-email-tytso@mit.edu>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45498 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161016AbcE3FkM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 May 2016 01:40:12 -0400
In-Reply-To: <1464586765-14436-1-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index bf370a3..860862f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -436,7 +436,8 @@ static int crng_init = 0;
 #define crng_ready() (likely(crng_init >= 2))
 static void _extract_crng(struct crng_state *crng,
 			  __u8 out[CHACHA20_BLOCK_SIZE]);
-static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE]);
+static void _crng_backtrack_protect(struct crng_state *crng,
+				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used);
 static void process_random_ready_list(void);
 
 /**********************************************************************
@@ -832,8 +833,11 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 		num = extract_entropy(r, &buf, 32, 16, 0);
 		if (num == 0)
 			return;
-	} else
+	} else {
 		_extract_crng(&primary_crng, buf.block);
+		_crng_backtrack_protect(&primary_crng, buf.block,
+					CHACHA20_KEY_SIZE);
+	}
 	spin_lock_irqsave(&primary_crng.lock, flags);
 	for (i = 0; i < 8; i++) {
 		unsigned long	rv;
@@ -893,9 +897,44 @@ static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
 	_extract_crng(crng, out);
 }
 
+/*
+ * Use the leftover bytes from the CRNG block output (if there is
+ * enough) to mutate the CRNG key to provide backtracking protection.
+ */
+static void _crng_backtrack_protect(struct crng_state *crng,
+				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used)
+{
+	unsigned long	flags;
+	__u32		*s, *d;
+	int		i;
+
+	used = round_up(used, sizeof(__u32));
+	if (used + CHACHA20_KEY_SIZE > CHACHA20_BLOCK_SIZE) {
+		extract_crng(tmp);
+		used = 0;
+	}
+	spin_lock_irqsave(&crng->lock, flags);
+	s = (__u32 *) &tmp[used];
+	d = &crng->state[4];
+	for (i=0; i < 8; i++)
+		*d++ ^= *s++;
+	spin_unlock_irqrestore(&crng->lock, flags);
+}
+
+static void crng_backtrack_protect(__u8 tmp[CHACHA20_BLOCK_SIZE], int used)
+{
+#ifdef CONFIG_NUMA
+	struct crng_state *crng = crng_node_pool[numa_node_id()];
+#else
+	struct crng_state *crng = &primary_crng;
+#endif
+
+	_crng_backtrack_protect(crng, tmp, used);
+}
+
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
-	ssize_t ret = 0, i;
+	ssize_t ret = 0, i = CHACHA20_BLOCK_SIZE;
 	__u8 tmp[CHACHA20_BLOCK_SIZE];
 	int large_request = (nbytes > 256);
 
@@ -920,6 +959,7 @@ static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 		buf += i;
 		ret += i;
 	}
+	crng_backtrack_protect(tmp, i);
 
 	/* Wipe data just written to memory */
 	memzero_explicit(tmp, sizeof(tmp));
@@ -1473,8 +1513,10 @@ void get_random_bytes(void *buf, int nbytes)
 	if (nbytes > 0) {
 		extract_crng(tmp);
 		memcpy(buf, tmp, nbytes);
-		memzero_explicit(tmp, nbytes);
-	}
+		crng_backtrack_protect(tmp, nbytes);
+	} else
+		crng_backtrack_protect(tmp, CHACHA20_BLOCK_SIZE);
+	memzero_explicit(tmp, sizeof(tmp));
 }
 EXPORT_SYMBOL(get_random_bytes);
 
-- 
2.5.0
