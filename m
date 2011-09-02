From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] random: add blocking facility to urandom
Date: Fri,  2 Sep 2011 10:37:28 -0400
Message-ID: <1314974248-1511-1-git-send-email-jarod@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, Matt Mackall <mpm@selenic.com>,
	Neil Horman <nhorman@redhat.com>,
	Herbert Xu <herbert.xu@redhat.com>,
	Steve Grubb <sgrubb@redhat.com>,
	Stephan Mueller <stephan.mueller@atsec.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab1IBOhn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Sep 2011 10:37:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Certain security-related certifications and their respective review
bodies have said that they find use of /dev/urandom for certain
functions, such as setting up ssh connections, is acceptable, but if and
only if /dev/urandom can block after a certain threshold of bytes have
been read from it with the entropy pool exhausted. Initially, we were
investigating increasing entropy pool contributions, so that we could
simply use /dev/random, but since that hasn't (yet) panned out, and
upwards of five minutes to establsh an ssh connection using an
entropy-starved /dev/random is unacceptable, we started looking at the
blocking urandom approach.

At present, urandom never blocks, even after all entropy has been
exhausted from the entropy input pool. random immediately blocks when
the input pool is exhausted. Some use cases want behavior somewhere in
between these two, where blocking only occurs after some number have
bytes have been read following input pool entropy exhaustion. Its
possible to accomplish this and make it fully user-tunable, by adding a
sysctl to set a max-bytes-after-0-entropy read threshold for urandom. In
the out-of-the-box configuration, urandom behaves as it always has, but
with a threshold value set, we'll block when its been exceeded.

Tested by dd'ing from /dev/urandom in one window, and starting/stopping
a cat of /dev/random in the other, with some debug spew added to the
urandom read function to verify functionality.

CC: Matt Mackall <mpm@selenic.com>
CC: Neil Horman <nhorman@redhat.com>
CC: Herbert Xu <herbert.xu@redhat.com>
CC: Steve Grubb <sgrubb@redhat.com>
CC: Stephan Mueller <stephan.mueller@atsec.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/char/random.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 81 insertions(+), 1 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index c35a785..cf48b0f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -289,6 +289,13 @@ static int trickle_thresh __read_mostly = INPUT_POOL_WORDS * 28;
 static DEFINE_PER_CPU(int, trickle_count);
 
 /*
+ * In normal operation, urandom never blocks, but optionally, you can
+ * set urandom to block after urandom_block_thresh bytes are read with
+ * the entropy pool exhausted.
+ */
+static int urandom_block_thresh = 0;
+
+/*
  * A pool of size .poolwords is stirred with a primitive polynomial
  * of degree .poolwords over GF(2).  The taps for various sizes are
  * defined below.  They are chosen to be evenly spaced (minimum RMS
@@ -383,6 +390,7 @@ static struct poolinfo {
  * Static global variables
  */
 static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
+static DECLARE_WAIT_QUEUE_HEAD(urandom_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 static struct fasync_struct *fasync;
 
@@ -554,6 +562,7 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 	/* should we wake readers? */
 	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
+		wake_up_interruptible(&urandom_read_wait);
 		kill_fasync(&fasync, SIGIO, POLL_IN);
 	}
 	spin_unlock_irqrestore(&r->lock, flags);
@@ -1060,7 +1069,55 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	return extract_entropy_user(&nonblocking_pool, buf, nbytes);
+	ssize_t n;
+	static int excess_bytes_read;
+
+	/* this is the default case with no urandom blocking threshold set */
+	if (!urandom_block_thresh)
+		return extract_entropy_user(&nonblocking_pool, buf, nbytes);
+
+	if (nbytes == 0)
+		return 0;
+
+	DEBUG_ENT("reading %d bits\n", nbytes*8);
+
+	/* urandom blocking threshold set, but we have sufficient entropy */
+	if (input_pool.entropy_count >= random_read_wakeup_thresh) {
+		excess_bytes_read = 0;
+		return extract_entropy_user(&nonblocking_pool, buf, nbytes);
+	}
+
+	/* low on entropy, start counting bytes read */
+	if (excess_bytes_read + nbytes < urandom_block_thresh) {
+		n = extract_entropy_user(&nonblocking_pool, buf, nbytes);
+		excess_bytes_read += n;
+		return n;
+	}
+
+	/* low entropy read threshold exceeded, now we have to block */
+	n = nbytes;
+	if (n > SEC_XFER_SIZE)
+		n = SEC_XFER_SIZE;
+
+	n = extract_entropy_user(&nonblocking_pool, buf, n);
+	excess_bytes_read += n;
+
+	if (file->f_flags & O_NONBLOCK)
+		return -EAGAIN;
+
+	DEBUG_ENT("sleeping?\n");
+
+	wait_event_interruptible(urandom_read_wait,
+		input_pool.entropy_count >= random_read_wakeup_thresh);
+
+	DEBUG_ENT("awake\n");
+
+	if (signal_pending(current))
+		return -ERESTARTSYS;
+
+	excess_bytes_read = 0;
+
+	return n;
 }
 
 static unsigned int
@@ -1078,6 +1135,21 @@ random_poll(struct file *file, poll_table * wait)
 	return mask;
 }
 
+static unsigned int
+urandom_poll(struct file *file, poll_table * wait)
+{
+	unsigned int mask;
+
+	poll_wait(file, &urandom_read_wait, wait);
+	poll_wait(file, &random_write_wait, wait);
+	mask = 0;
+	if (input_pool.entropy_count >= random_read_wakeup_thresh)
+		mask |= POLLIN | POLLRDNORM;
+	if (input_pool.entropy_count < random_write_wakeup_thresh)
+		mask |= POLLOUT | POLLWRNORM;
+	return mask;
+}
+
 static int
 write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
 {
@@ -1178,6 +1250,7 @@ const struct file_operations random_fops = {
 const struct file_operations urandom_fops = {
 	.read  = urandom_read,
 	.write = random_write,
+	.poll  = urandom_poll,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
@@ -1266,6 +1339,13 @@ ctl_table random_table[] = {
 		.data		= &input_pool.entropy_count,
 	},
 	{
+		.procname	= "urandom_blocking_threshold",
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.data		= &urandom_block_thresh,
+	},
+	{
 		.procname	= "read_wakeup_threshold",
 		.data		= &random_read_wakeup_thresh,
 		.maxlen		= sizeof(int),
-- 
1.7.1
