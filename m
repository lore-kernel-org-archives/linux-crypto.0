From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 6/8] random: fix comment for unused random_min_urandom_seed
Date: Tue, 27 Dec 2016 23:41:22 +0100
Message-ID: <8287186.H5QhrauTgY@positron.chronox.de>
References: <3254875.f5A5oHPdxF@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3254875.f5A5oHPdxF@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The variable random_min_urandom_seed is not needed any more as it
defined the reseeding behavior of the nonblocking pool. Though it is not
needed any more, it is left in the code for user space interface
compatibility.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d19108c..89d67c0 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -313,9 +313,7 @@ static int random_read_wakeup_bits = 64;
 static int random_write_wakeup_bits = 28 * OUTPUT_POOL_WORDS;
 
 /*
- * The minimum number of seconds between urandom pool reseeding.  We
- * do this to limit the amount of entropy that can be drained from the
- * input pool even if there are heavy demands on /dev/urandom.
+ * Variable is currently unused by left for user space compatibility.
  */
 static int random_min_urandom_seed = 60;
 
-- 
2.9.3
