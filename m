From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 7/7] random: add backtracking protection to the CRNG
Date: Mon, 13 Jun 2016 11:48:39 -0400
Message-ID: <1465832919-11316-8-git-send-email-tytso@mit.edu>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com,
	Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45048 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424296AbcFMPt2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 11:49:28 -0400
In-Reply-To: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d640865..963a6a9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -436,7 +436,8 @@ static int crng_init = 0;
 #define crng_ready() (likely(crng_init > 0))
 static void _extract_crng(struct crng_state *crng,
 			  __u8 out[CHACHA20_BLOCK_SIZE]);
-static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE]);
+static void _crng_backtrack_protect(struct crng_state *crng,
+				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used);
 static void process_random_ready_list(void);
 
 /**********************************************************************
@@ -826,8 +827,11 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
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
@@ -889,9 +893,46 @@ static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
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
+	struct crng_state *crng = NULL;
+
+#ifdef CONFIG_NUMA
+	if (crng_node_pool)
+		crng = crng_node_pool[numa_node_id()];
+	if (crng == NULL)
+#endif
+		crng = &primary_crng;
+	_crng_backtrack_protect(crng, tmp, used);
+}
+
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
-	ssize_t ret = 0, i;
+	ssize_t ret = 0, i = CHACHA20_BLOCK_SIZE;
 	__u8 tmp[CHACHA20_BLOCK_SIZE];
 	int large_request = (nbytes > 256);
 
@@ -916,6 +957,7 @@ static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 		buf += i;
 		ret += i;
 	}
+	crng_backtrack_protect(tmp, i);
 
 	/* Wipe data just written to memory */
 	memzero_explicit(tmp, sizeof(tmp));
@@ -1473,8 +1515,10 @@ void get_random_bytes(void *buf, int nbytes)
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
