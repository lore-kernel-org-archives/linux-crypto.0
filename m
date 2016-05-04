From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] random: add backtracking protection to the CRNG
Date: Wed,  4 May 2016 15:25:51 -0400
Message-ID: <1462389951-29439-5-git-send-email-tytso@mit.edu>
References: <1462389951-29439-1-git-send-email-tytso@mit.edu>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462389951-29439-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 897c75e..028d085 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -886,6 +886,34 @@ static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
 #endif
 }
 
+/*
+ * Use the leftover bytes from the CRNG block output (if there is
+ * enough) to mutate the CRNG key to provide backtracking protection.
+ */
+static void crng_backtrack_protect(__u8 tmp[CHACHA20_BLOCK_SIZE], int unused)
+{
+#ifdef CONFIG_NUMA
+	struct crng_state *crng = crng_node_pool[numa_node_id()];
+#else
+	struct crng_state *crng = &primary_crng;
+#endif
+	unsigned long	flags;
+	__u32		*s, *d;
+	int		i;
+
+	unused = round_up(unused, sizeof(__u32));
+	if (unused + CHACHA20_KEY_SIZE > CHACHA20_BLOCK_SIZE) {
+		extract_crng(tmp);
+		unused = 0;
+	}
+	spin_lock_irqsave(&crng->lock, flags);
+	s = (__u32 *) &tmp[unused];
+	d = &crng->state[4];
+	for (i=0; i < 8; i++)
+		*d++ ^= *s++;
+	spin_unlock_irqrestore(&crng->lock, flags);
+}
+
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
 	ssize_t ret = 0, i;
@@ -913,6 +941,7 @@ static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 		buf += i;
 		ret += i;
 	}
+	crng_backtrack_protect(tmp, i);
 
 	/* Wipe data just written to memory */
 	memzero_explicit(tmp, sizeof(tmp));
@@ -1457,8 +1486,10 @@ void get_random_bytes(void *buf, int nbytes)
 	if (nbytes > 0) {
 		extract_crng(tmp);
 		memcpy(buf, tmp, nbytes);
-		memzero_explicit(tmp, nbytes);
-	}
+		crng_backtrack_protect(tmp, nbytes);
+	} else
+		crng_backtrack_protect(tmp, 0);
+	memzero_explicit(tmp, sizeof(tmp));
 }
 EXPORT_SYMBOL(get_random_bytes);
 
-- 
2.5.0
