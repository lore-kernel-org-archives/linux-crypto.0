From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] Constantly reseed nonblocking_pool during initialization
Date: Mon, 13 Mar 2017 11:28:07 +0100
Message-ID: <1669891.oFFFdJQWCi@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Pascal de Bruijn <p.debruijn@unilogic.nl>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58044 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751088AbdCMK2K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Mar 2017 06:28:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ted,

The issue fixed by the patch below is visible in all kernels between 3.13 and 4.7. The patch is developed against 4.7.0. It is tested against 4.4.53.

If you concur, I would recommend to send it to stable.

---8<---

The nonblocking_pool is reseeded after the expiry of
random_min_urandom_seed seconds since last reseed. This approach is not
suitable during early boot time of user space due to the following: When
user space starts an entropy gathering daemon (like the rngd or other
daemons) very early during the boot cycle before cryptographic services
are started to provide entropy to the input_pool, the entropy will not
reach the nonblocking_pool immediately even though this is the intention.

This can be illustrated with the following log where a user space
entropy gathering daemon is started around 6.1 seconds after start and
it is guaranteed that it will inject 256 bits of entropy via the
RNDADDENTROPY IOCTL at that time. Thus, the complaint about an
insufficiently seeded nonblocking_pool should be gone after that
event. Further, at the time of the IOCTL, the "nonblocking pool is
initialized" statement should appear. Yet, the log shows that even
after 34 seconds after boot there is still insufficient entropy
in the nonblocking pool.

[    6.072296] random: udevd: uninitialized urandom read (16 bytes read, 4 bits of entropy available)
[    6.072346] random: udevd: uninitialized urandom read (16 bytes read, 4 bits of entropy available)
[    6.072358] random: udevd: uninitialized urandom read (16 bytes read, 4 bits of entropy available)
[    6.072369] random: udevd: uninitialized urandom read (16 bytes read, 4 bits of entropy available)
[    6.083754] random: udevd: uninitialized urandom read (16 bytes read, 4 bits of entropy available)
[    6.083766] random: udevd: uninitialized urandom read (16 bytes read, 4 bits of entropy available)
[    6.085852] random: udevd: uninitialized urandom read (16 bytes read, 4 bits of entropy available)
[   34.602241] random: ssh-keygen: uninitialized urandom read (32 bytes read, 103 bits of entropy available)
[   34.606645] random: sshd: uninitialized urandom read (32 bytes read, 103 bits of entropy available)
[   34.711321] random: nrpe: uninitialized urandom read (32 bytes read, 103 bits of entropy available)
[   53.337494] random: nonblocking pool is initialized

Reported-by: Pascal de Bruijn <p.debruijn@unilogic.nl>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
Tested-by: Pascal de Bruijn <p.debruijn@unilogic.nl>
---
 drivers/char/random.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0158d3b..58d9b7f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -984,7 +984,8 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 	if (r->limit == 0 && random_min_urandom_seed) {
 		unsigned long now = jiffies;
 
-		if (time_before(now,
+		if (r->initialized &&
+		    time_before(now,
 				r->last_pulled + random_min_urandom_seed * HZ))
 			return;
 		r->last_pulled = now;
-- 
2.9.3
