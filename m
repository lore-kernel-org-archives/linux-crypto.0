From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/7] random: properly align get_random_int_hash
Date: Mon, 13 Jun 2016 11:48:36 -0400
Message-ID: <1465832919-11316-5-git-send-email-tytso@mit.edu>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Cc: linux-crypto@vger.kernel.org, smueller@chronox.de,
	herbert@gondor.apana.org.au, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com, hpa@zytor.com,
	Eric Biggers <ebiggers3@gmail.com>, stable@kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45068 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1424675AbcFMPt2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 11:49:28 -0400
In-Reply-To: <1465832919-11316-1-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers3@gmail.com>

get_random_long() reads from the get_random_int_hash array using an
unsigned long pointer.  For this code to be guaranteed correct on all
architectures, the array must be aligned to an unsigned long boundary.

Cc: stable@kernel.org
Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 64e35a4..83f5cd0 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1778,13 +1778,15 @@ int random_int_secret_init(void)
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
