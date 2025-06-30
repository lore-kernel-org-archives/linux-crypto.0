Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D64D28DEE5;
	Mon, 30 Jun 2025 18:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751306599; cv=none; b=Yo+sSTTnfSFm0MRAn6r6FuLaZT6TZxWNzz3Rdy6flq8H0JlcHFbug6bcX02uGwBxUH08SnNTvz+qct2CdjO6IGj/xfMBwOJX5md+5f4pF0RFkY+G9lXd+Z/ZntXitG+lCOtYRfybKB/Z4d5ThbgFpKQ4SeHVu4vSQEMDF2aJ25Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751306599; c=relaxed/simple;
	bh=mun4mDzD9QGfzUsYPMlVMOBNFMOVS6PbWZNAh9WcPPs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIxpMsBsxCo7dTleknLBn8sxF4imZMCmhFSemFO4pHxgzz1giDaMC/ZBQTmhYEir007OGmKBwT1HHphIsZAa1muBBsu9VwNvfVDhdD21cHulzl7n5AYKAOOSiHHspFeMrddQDh6Jlsu+NFkWMIQniP61oVH18bkU974nQHWyitI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=OoGjet8U; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="OoGjet8U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1751306597; x=1782842597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B2hTi/GxOSm/RnzJTxbjCOSgOg8C/fvtMLzHLPGLIF4=;
  b=OoGjet8UCZhUftVb9k1OoEzkQraQ1+aIWMpdOKqwKJm0kfFk6c5xt6lh
   J80pOCBkpm6kGJ6yS0Uk51VvW0W/fxpJ5JbODJatwQPKQ3UA8s7jPb6II
   Bd9sUdhlEyAzFPjz6d+EySdF7AFjY6YrcViOEPcN8Xc+ZfABboBAGx0MK
   zTrPWnVCgmGgw1rbt3Pceuuti1Lt5YkHsp1fGHnl7UTbzfQERFyS9FVca
   5QqQcv0utstZhjIvlJW/v1uH447uo74FLoZeajiq83QjQP00/N+euyi2d
   RMqUTfsOHh5K20UUNjO6K6k7IhZtzK3+xNvcLAC3ySoWI6FHllH0InaLf
   g==;
X-IronPort-AV: E=Sophos;i="6.16,278,1744070400"; 
   d="scan'208";a="211778403"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 18:03:15 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.21.151:26987]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.23.203:2525] with esmtp (Farcaster)
 id 4bdba48a-1b1a-4f01-80cc-6d8590867b0f; Mon, 30 Jun 2025 18:03:15 +0000 (UTC)
X-Farcaster-Flow-ID: 4bdba48a-1b1a-4f01-80cc-6d8590867b0f
Received: from EX19D004UWA004.ant.amazon.com (10.13.138.200) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 30 Jun 2025 18:03:15 +0000
Received: from dev-dsk-wanjay-2c-d25651b4.us-west-2.amazon.com (172.19.198.4)
 by EX19D004UWA004.ant.amazon.com (10.13.138.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 30 Jun 2025 18:03:14 +0000
From: Jay Wang <wanjay@amazon.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wanjay@amazon.com>
Subject: [PATCH v6.12 1/2] random: Add hook to override device reads and getrandom(2)
Date: Mon, 30 Jun 2025 18:03:11 +0000
Message-ID: <20250630180312.24627-2-wanjay@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250630180312.24627-1-wanjay@amazon.com>
References: <20250630180312.24627-1-wanjay@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D004UWA004.ant.amazon.com (10.13.138.200)

From: Herbert Xu <herbert.xu@redhat.com>

This patch introduces a hook mechanism to drivers/char/random
to allow the reads on /dev/*random as well as getrandom(2) to
be overridden by an external RNG.

This will be used to override drivers/char/random with a FIPS
RNG in a subsequent patch.

Signed-off-by: Herbert Xu <herbert.xu@redhat.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
[6.1: Handle some context in getrandom() and random.h, and convert the
extrng_*_fops to use random_write_iter().]
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
[6.12: Further resolve surrounding conflicts in getrandom() and random.h.]
Cc: stable@vger.kernel.org
Signed-off-by: Elena Avila <ellavila@amazon.com>
---
 drivers/char/random.c  | 114 +++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h |   7 +++
 2 files changed, 121 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 23ee76bbb4aa..032c5ffa814c 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -54,6 +54,7 @@
 #include <linux/suspend.h>
 #include <linux/siphash.h>
 #include <linux/sched/isolation.h>
+#include <linux/rcupdate.h>
 #include <crypto/chacha.h>
 #include <crypto/blake2s.h>
 #ifdef CONFIG_VDSO_GETRANDOM
@@ -330,6 +331,11 @@ static void crng_fast_key_erasure(u8 key[CHACHA_KEY_SIZE],
 	memzero_explicit(first_block, sizeof(first_block));
 }

+/*
+ * Hook for external RNG.
+ */
+static const struct random_extrng __rcu *extrng;
+
 /*
  * This function returns a ChaCha state that you may use for generating
  * random data. It also returns up to 32 bytes on its own of random data
@@ -610,6 +616,9 @@ int __cold random_prepare_cpu(unsigned int cpu)
 #endif


+static const struct file_operations extrng_random_fops;
+static const struct file_operations extrng_urandom_fops;
+
 /**********************************************************************
  *
  * Entropy accumulation and extraction routines.
@@ -980,6 +989,19 @@ void __init add_bootloader_randomness(const void *buf, size_t len)
 		credit_init_bits(len * 8);
 }

+void random_register_extrng(const struct random_extrng *rng)
+{
+	rcu_assign_pointer(extrng, rng);
+}
+EXPORT_SYMBOL_GPL(random_register_extrng);
+
+void random_unregister_extrng(void)
+{
+	RCU_INIT_POINTER(extrng, NULL);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(random_unregister_extrng);
+
 #if IS_ENABLED(CONFIG_VMGENID)
 static BLOCKING_NOTIFIER_HEAD(vmfork_chain);

@@ -1387,6 +1409,7 @@ static void __cold try_to_generate_entropy(void)

 SYSCALL_DEFINE3(getrandom, char __user *, ubuf, size_t, len, unsigned int, flags)
 {
+	const struct random_extrng *rng;
 	struct iov_iter iter;
 	int ret;

@@ -1400,6 +1423,18 @@ SYSCALL_DEFINE3(getrandom, char __user *, ubuf, size_t, len, unsigned int, flags
 	if ((flags & (GRND_INSECURE | GRND_RANDOM)) == (GRND_INSECURE | GRND_RANDOM))
 		return -EINVAL;

+	rcu_read_lock();
+	rng = rcu_dereference(extrng);
+	if (rng && !try_module_get(rng->owner))
+		rng = NULL;
+	rcu_read_unlock();
+
+	if (rng) {
+		ret = rng->extrng_read(ubuf, len);
+		module_put(rng->owner);
+		return ret;
+	}
+
 	if (!crng_ready() && !(flags & GRND_INSECURE)) {
 		if (flags & GRND_NONBLOCK)
 			return -EAGAIN;
@@ -1420,6 +1455,13 @@ static __poll_t random_poll(struct file *file, poll_table *wait)
 	return crng_ready() ? EPOLLIN | EPOLLRDNORM : EPOLLOUT | EPOLLWRNORM;
 }

+static __poll_t
+extrng_poll(struct file *file, poll_table * wait)
+{
+	/* extrng pool is always full, always read, no writes */
+	return EPOLLIN | EPOLLRDNORM;
+}
+
 static ssize_t write_pool_user(struct iov_iter *iter)
 {
 	u8 block[BLAKE2S_BLOCK_SIZE];
@@ -1560,9 +1602,60 @@ static int random_fasync(int fd, struct file *filp, int on)
 	return fasync_helper(fd, filp, on, &fasync);
 }

+static int random_open(struct inode *inode, struct file *filp)
+{
+	const struct random_extrng *rng;
+
+	rcu_read_lock();
+	rng = rcu_dereference(extrng);
+	if (rng && !try_module_get(rng->owner))
+		rng = NULL;
+	rcu_read_unlock();
+
+	if (!rng)
+		return 0;
+
+	filp->f_op = &extrng_random_fops;
+	filp->private_data = rng->owner;
+
+	return 0;
+}
+
+static int urandom_open(struct inode *inode, struct file *filp)
+{
+	const struct random_extrng *rng;
+
+	rcu_read_lock();
+	rng = rcu_dereference(extrng);
+	if (rng && !try_module_get(rng->owner))
+		rng = NULL;
+	rcu_read_unlock();
+
+	if (!rng)
+		return 0;
+
+	filp->f_op = &extrng_urandom_fops;
+	filp->private_data = rng->owner;
+
+	return 0;
+}
+
+static int extrng_release(struct inode *inode, struct file *filp)
+{
+	module_put(filp->private_data);
+	return 0;
+}
+
+static ssize_t
+extrng_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+{
+	return rcu_dereference_raw(extrng)->extrng_read(buf, nbytes);
+}
+
 const struct file_operations random_fops = {
 	.read_iter = random_read_iter,
 	.write_iter = random_write_iter,
+	.open  = random_open,
 	.poll = random_poll,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
@@ -1575,6 +1668,7 @@ const struct file_operations random_fops = {
 const struct file_operations urandom_fops = {
 	.read_iter = urandom_read_iter,
 	.write_iter = random_write_iter,
+	.open  = urandom_open,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.fasync = random_fasync,
@@ -1583,6 +1677,26 @@ const struct file_operations urandom_fops = {
 	.splice_write = iter_file_splice_write,
 };

+static const struct file_operations extrng_random_fops = {
+	.open  = random_open,
+	.read  = extrng_read,
+	.write_iter = random_write_iter,
+	.poll  = extrng_poll,
+	.unlocked_ioctl = random_ioctl,
+	.fasync = random_fasync,
+	.llseek = noop_llseek,
+	.release = extrng_release,
+};
+
+static const struct file_operations extrng_urandom_fops = {
+	.open  = urandom_open,
+	.read  = extrng_read,
+	.write_iter = random_write_iter,
+	.unlocked_ioctl = random_ioctl,
+	.fasync = random_fasync,
+	.llseek = noop_llseek,
+	.release = extrng_release,
+};

 /********************************************************************
  *
diff --git a/include/linux/random.h b/include/linux/random.h
index b0a940af4fff..6cfb75741ade 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -9,6 +9,11 @@

 #include <uapi/linux/random.h>

+struct random_extrng {
+	ssize_t (*extrng_read)(void __user *buf, size_t buflen);
+	struct module *owner;
+};
+
 struct notifier_block;

 void add_device_randomness(const void *buf, size_t len);
@@ -120,6 +125,8 @@ void __init random_init(void);
 bool rng_is_initialized(void);
 int wait_for_random_bytes(void);
 int execute_with_initialized_rng(struct notifier_block *nb);
+void random_register_extrng(const struct random_extrng *rng);
+void random_unregister_extrng(void);

 /* Calls wait_for_random_bytes() and then calls get_random_bytes(buf, nbytes).
  * Returns the result of the call to wait_for_random_bytes. */
--
2.47.1

