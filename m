From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [RFC PATCH v12 2/4] random: conditionally compile code depending on LRNG
Date: Tue, 18 Jul 2017 09:58:31 +0200
Message-ID: <1830340.t0pR7po4tk@positron.chronox.de>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Jason A. Donenfeld" <jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3910055.ntkqcq1Chb@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When selecting the LRNG for compilation, disable add_disk_randomness and
its supporting function.

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/genhd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e619fae..7e08ebc 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -422,8 +422,13 @@ extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
 extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
 
 /* drivers/char/random.c */
+#ifdef CONFIG_LRNG
+#define add_disk_randomness(disk) do {} while (0)
+#define rand_initialize_disk(disk) do {} while (0)
+#else
 extern void add_disk_randomness(struct gendisk *disk) __latent_entropy;
 extern void rand_initialize_disk(struct gendisk *disk);
+#endif
 
 static inline sector_t get_start_sect(struct block_device *bdev)
 {
-- 
2.9.4
