From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] random: properly align get_random_int_hash
Date: Mon, 30 May 2016 01:39:25 -0400
Message-ID: <1464586765-14436-6-git-send-email-tytso@mit.edu>
References: <1464586765-14436-1-git-send-email-tytso@mit.edu>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au,
	andi@firstfloor.org, sandyinchina@gmail.com,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464586765-14436-1-git-send-email-tytso@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Eric Biggers <ebiggers3@gmail.com>

get_random_long() reads from the get_random_int_hash array using an
unsigned long pointer.  For this code to be guaranteed correct on all
architectures, the array must be aligned to an unsigned long boundary.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 860862f..90fb569 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2033,13 +2033,15 @@ int random_int_secret_init(void)
 	return 0;
 }
 
+static DEFINE_PER_CPU(__u32 [MD5_DIGEST_WORDS], get_random_int_hash)
+		__aligned(sizeof(unsigned long));
+
 /*
  * Get a random word for internal kernel use only. Similar to urandom but
  * with the goal of minimal entropy pool depletion. As a result, the random
  * value is not cryptographically secure but for several uses the cost of
  * depleting entropy is too high
  */
-static DEFINE_PER_CPU(__u32 [MD5_DIGEST_WORDS], get_random_int_hash);
 unsigned int get_random_int(void)
 {
 	__u32 *hash;
-- 
2.5.0
