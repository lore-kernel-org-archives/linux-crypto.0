Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7026F179A3
	for <linux-crypto@vger.kernel.org>; Thu, 10 Oct 2024 02:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728529042; cv=none; b=Uc0aGaFVe2y468mgQNMz5mcUEwXrEaictp7oHSYnZ56RRYvDVsY8hCRkx3i1Ujw+DpsQTfYB4+u9TqBKrgUJmE5nfA5Z8/5IQSuyCeij45ETn147p4e8vt36IxV9LM3SiUcPbvoaT7ROLVaLm+kIO/3epDk18UHg55vYvy9bTL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728529042; c=relaxed/simple;
	bh=3pgGgg/8xGkhEcXyoI2JirCDtveLVM146RhkyI4/dP8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OQtCokv21Iwr11FVt9VRnI2gR+xSgutru08sumK8bbT8BcE1k8kXu9uVfn72lxYgfP1zv5M90PlzNmgxvIThjMs/UbEi2owL/wpjHjDnDrezwhZW/Xtn2H6zxy1PEOw5Djp16a/HJ2txN3wYoSZd0d+Xw3xNegWmOSK5Vwn1mpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=p5Ix1ZS8; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="p5Ix1ZS8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1728528487; bh=3pgGgg/8xGkhEcXyoI2JirCDtveLVM146RhkyI4/dP8=;
	h=From:To:Cc:Subject:Date;
	b=p5Ix1ZS8PzG06FEWlKr/oFOcVQOiajHF6cWtn0PqeSjz0AW+JcvuOaroFi17RHg4A
	 aN4EGG0SvGl3dSgwia1kenlpH9FjXYO2aP1L+SL/l/jos2lXWZxFQzPbJW9ioS4wqH
	 6IpKmudG1V4sykSEncw/3NvrXyfmgy2A+4c+b7N4C8y9dV1WyC2bgOW6oVwhAApSoB
	 /dgzmDqGwUIIAMHhHybQbAbL55h/SrxEAnMsXE77ARdxEJQox2pNQOxEXuXS0/cGVo
	 GzMU6tXdWqdK0Ky8Jl1vvp/WBZcfYW3VVQfcW3+iNiYEmXtQhh3I9r8IF6HZ+IEzQY
	 gX466g2XEGszQ==
From: Joachim Vandersmissen <git@jvdsn.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Cc: Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH] crypto: jitter - output full sample from test interface
Date: Wed,  9 Oct 2024 21:47:34 -0500
Message-ID: <20241010024734.75871-1-git@jvdsn.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Jitter RNG time delta is computed based on the difference of two
high-resolution, 64-bit time stamps. However, the test interface added
in 69f1c387ba only outputs the lower 32 bits of those time stamps. To
ensure all information is available during the evaluation process of
the Jitter RNG, output the full 64-bit time stamps.

Any clients collecting data from the test interface will need to be
updated to take this change into account.

Additionally, the size of the temporary buffer that holds the data for
user space has been clarified. Previously, this buffer was
JENT_TEST_RINGBUFFER_SIZE (= 1000) bytes in size, however that value
represents the number of samples held in the kernel space ring buffer,
with each sample taking 8 (previously 4) bytes.

Rather than increasing the size to allow for all 1000 samples to be
output, we keep it at 1000 bytes, but clarify that this means at most
125 64-bit samples will be output every time this interface is called.

Reviewed-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
---
 crypto/jitterentropy-testing.c | 31 ++++++++++++++++---------------
 crypto/jitterentropy.h         |  4 ++--
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/crypto/jitterentropy-testing.c b/crypto/jitterentropy-testing.c
index 5cb6a77b8e3b..21c9d7c3269a 100644
--- a/crypto/jitterentropy-testing.c
+++ b/crypto/jitterentropy-testing.c
@@ -15,7 +15,7 @@
 #define JENT_TEST_RINGBUFFER_MASK	(JENT_TEST_RINGBUFFER_SIZE - 1)
 
 struct jent_testing {
-	u32 jent_testing_rb[JENT_TEST_RINGBUFFER_SIZE];
+	u64 jent_testing_rb[JENT_TEST_RINGBUFFER_SIZE];
 	u32 rb_reader;
 	atomic_t rb_writer;
 	atomic_t jent_testing_enabled;
@@ -72,7 +72,7 @@ static void jent_testing_fini(struct jent_testing *data, u32 boot)
 	pr_warn("Disabling data collection\n");
 }
 
-static bool jent_testing_store(struct jent_testing *data, u32 value,
+static bool jent_testing_store(struct jent_testing *data, u64 value,
 			       u32 *boot)
 {
 	unsigned long flags;
@@ -156,20 +156,20 @@ static int jent_testing_reader(struct jent_testing *data, u32 *boot,
 		}
 
 		/* We copy out word-wise */
-		if (outbuflen < sizeof(u32)) {
+		if (outbuflen < sizeof(u64)) {
 			spin_unlock_irqrestore(&data->lock, flags);
 			goto out;
 		}
 
 		memcpy(outbuf, &data->jent_testing_rb[data->rb_reader],
-		       sizeof(u32));
+		       sizeof(u64));
 		data->rb_reader++;
 
 		spin_unlock_irqrestore(&data->lock, flags);
 
-		outbuf += sizeof(u32);
-		outbuflen -= sizeof(u32);
-		collected_data += sizeof(u32);
+		outbuf += sizeof(u64);
+		outbuflen -= sizeof(u64);
+		collected_data += sizeof(u64);
 	}
 
 out:
@@ -189,16 +189,17 @@ static int jent_testing_extract_user(struct file *file, char __user *buf,
 
 	/*
 	 * The intention of this interface is for collecting at least
-	 * 1000 samples due to the SP800-90B requirements. So, we make no
-	 * effort in avoiding allocating more memory that actually needed
-	 * by the user. Hence, we allocate sufficient memory to always hold
-	 * that amount of data.
+	 * 1000 samples due to the SP800-90B requirements. However, due to
+	 * memory and performance constraints, it is not desirable to allocate
+	 * 8000 bytes of memory. Instead, we allocate space for only 125
+	 * samples, which will allow the user to collect all 1000 samples using
+	 * 8 calls to this interface.
 	 */
-	tmp = kmalloc(JENT_TEST_RINGBUFFER_SIZE + sizeof(u32), GFP_KERNEL);
+	tmp = kmalloc(125 * sizeof(u64) + sizeof(u64), GFP_KERNEL);
 	if (!tmp)
 		return -ENOMEM;
 
-	tmp_aligned = PTR_ALIGN(tmp, sizeof(u32));
+	tmp_aligned = PTR_ALIGN(tmp, sizeof(u64));
 
 	while (nbytes) {
 		int i;
@@ -212,7 +213,7 @@ static int jent_testing_extract_user(struct file *file, char __user *buf,
 			schedule();
 		}
 
-		i = min_t(int, nbytes, JENT_TEST_RINGBUFFER_SIZE);
+		i = min_t(int, nbytes, 125 * sizeof(u64));
 		i = reader(tmp_aligned, i);
 		if (i <= 0) {
 			if (i < 0)
@@ -251,7 +252,7 @@ static struct jent_testing jent_raw_hires = {
 	.read_wait = __WAIT_QUEUE_HEAD_INITIALIZER(jent_raw_hires.read_wait)
 };
 
-int jent_raw_hires_entropy_store(__u32 value)
+int jent_raw_hires_entropy_store(__u64 value)
 {
 	return jent_testing_store(&jent_raw_hires, value, &boot_raw_hires_test);
 }
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index aa4728675ae2..4c5dbf2a8d8f 100644
--- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -22,11 +22,11 @@ extern struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 extern void jent_entropy_collector_free(struct rand_data *entropy_collector);
 
 #ifdef CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE
-int jent_raw_hires_entropy_store(__u32 value);
+int jent_raw_hires_entropy_store(__u64 value);
 void jent_testing_init(void);
 void jent_testing_exit(void);
 #else /* CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE */
-static inline int jent_raw_hires_entropy_store(__u32 value) { return 0; }
+static inline int jent_raw_hires_entropy_store(__u64 value) { return 0; }
 static inline void jent_testing_init(void) { }
 static inline void jent_testing_exit(void) { }
 #endif /* CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE */
-- 
2.46.1

