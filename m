From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2] hw_random: core, sleep interruptible in read
Date: Fri, 27 Nov 2015 16:50:43 +0100
Message-ID: <1448639443-21760-1-git-send-email-jslaby@suse.cz>
References: <20151127130603.GA29503@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
	Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40857 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbbK0Pur (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 10:50:47 -0500
In-Reply-To: <20151127130603.GA29503@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

hwrng kthread can be waiting via hwrng_fillfn for some data from a rng
like virtio-rng:
hwrng           D ffff880093e17798     0   382      2 0x00000000
...
Call Trace:
 [<ffffffff817339c6>] wait_for_completion_killable+0x96/0x210
 [<ffffffffa00aa1b7>] virtio_read+0x57/0xf0 [virtio_rng]
 [<ffffffff814f4a35>] hwrng_fillfn+0x75/0x130
 [<ffffffff810aa243>] kthread+0xf3/0x110

And when some user program tries to read the /dev node in this state,
we get:
rngd            D ffff880093e17798     0   762      1 0x00000004
...
Call Trace:
 [<ffffffff817351ac>] mutex_lock_nested+0x15c/0x3e0
 [<ffffffff814f478e>] rng_dev_read+0x6e/0x240
 [<ffffffff81231958>] __vfs_read+0x28/0xe0
 [<ffffffff81232393>] vfs_read+0x83/0x130

And this is indeed unkillable. So use mutex_lock_interruptible
instead of mutex_lock in rng_dev_read and exit immediatelly when
interrupted. And possibly return already read data, if any (as POSIX
allows).

v2: use ERESTARTSYS instead of EINTR

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: <linux-crypto@vger.kernel.org>
---
 drivers/char/hw_random/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index a064237ff362..ca5a5325eb6f 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -238,7 +238,10 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 			goto out;
 		}
 
-		mutex_lock(&reading_mutex);
+		if (mutex_lock_interruptible(&reading_mutex)) {
+			err = -ERESTARTSYS;
+			goto out_put;
+		}
 		if (!data_avail) {
 			bytes_read = rng_get_data(rng, rng_buffer,
 				rng_buffer_size(),
@@ -288,6 +291,7 @@ out:
 
 out_unlock_reading:
 	mutex_unlock(&reading_mutex);
+out_put:
 	put_rng(rng);
 	goto out;
 }
-- 
2.6.3
