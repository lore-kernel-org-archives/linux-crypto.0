From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 43/87] hwrng: core - sleep interruptible in read
Date: Mon, 15 Jan 2018 13:34:42 +0100
Message-ID: <20180115123353.719845276@linuxfoundation.org>
References: <20180115123349.252309699@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965709AbeAOMkB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jan 2018 07:40:01 -0500
In-Reply-To: <20180115123349.252309699@linuxfoundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

4.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 1ab87298cb59b649d8d648d25dc15b36ab865f5a upstream.

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
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -238,7 +238,10 @@ static ssize_t rng_dev_read(struct file
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
