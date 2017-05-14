From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v11 2/5] random: conditionally compile code depending on LRNG
Date: Sun, 14 May 2017 16:28:00 +0200
Message-ID: <74740507.fE4fldbO5y@positron.chronox.de>
References: <7746835.7W6fIIgSam@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59570 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751477AbdENObm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 May 2017 10:31:42 -0400
In-Reply-To: <7746835.7W6fIIgSam@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When selecting the LRNG for compilation, disable the legacy /dev/random
implementation.

The LRNG is a drop-in replacement for the legacy /dev/random which
implements the same in-kernel and user space API. Only the hooks of
/dev/random into other parts of the kernel need to be disabled.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 include/linux/genhd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index acff943..2a8d748 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -428,8 +428,13 @@ extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
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
2.9.3
