Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D2E412C14
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 08:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228246; cv=none; b=TqJQJVouozzfrCFup5P3f4msfjomGOBnoeAYWZa8HQ31HPI5lOIvGEm928ep6e+nTPZusB2lmqWdJHUNXbPtofoOnZ9Ts1Fh3+ktvX1LwW6lfy98sOHrR5PvGyVDFfvr3rBQXVvM9HLdYGRnyoi40T8d2dwAj77wp7WXTjaCJhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228246; c=relaxed/simple;
	bh=azMmEoFiUdEQmPw92upzvMoKhiNCMouur7MehU89fbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2FMITy/Aak0xOqQGeHOF8hF8UhZioVe8dpi8o9KLi1pq4XeqB86TGF9Qb6Qni5t8QmlXxuYcnmX2IKP1Mgu4zpk5+wJCSq+Ynt+Cm9F+G+iDe/QzEAPs3ccuOuahrxg4+JCLny81jYk1yjrw5NKq44Bab1wzLK9tY5OzieQZz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XKSPhqGD; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKSPhqGD"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d01663d816so3458015ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 01:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785228244; x=1785833044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ZhY4ex1aTAjiE+PVMiJFUKWM9IxWX54ffsV/gAsSm8=;
        b=XKSPhqGD93CPG3ZUlFzyhaqGm7e80NskgVfMkLzyl3I0p1BAfTcGOHRisB2P6dksh5
         Fgu6FL8D78BgzWCiAh38VnlvetCpiqhNZK6+bPvli6AKbtC4Zk3nNE8uaLem4RfqJ6KA
         X2igVLjqFIrsANQdMCn9rGrldyYWldCvFHEo/x+1jaEKLS0xp1ccS0xQAwAfwZj/uM/x
         /WEEytqxZSLtrJ3GL+FcXB8F9l4jCjuS2RVKM5l9Z7cEPb0FWBen9L4Lv2mPVjbIet/2
         540vtc1ruZO4CKQ3SKtUK5Ujydv0aj2R3m3TjI2huv3nh3jIW7k/baC3dLAwfEk87hBp
         vQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785228244; x=1785833044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+ZhY4ex1aTAjiE+PVMiJFUKWM9IxWX54ffsV/gAsSm8=;
        b=rAvr3MzHmok/snms2zHrVrdwDv2Q7MXgqabmFAjVKAtg2UHfyxN+l0lbAh5l04ofBa
         5SoxChcUbTpM1wJG8v4Hp7kInGGAxszP/TlfNynVFsstDJE8U2N+1fE2MlrJ9BfWTuAc
         BjG0wDqjLqoodS7VI9VwbCEIK+gmJi/j+S0xip4B+G+Us0X5toFOxXBnhCLJAIzCPXgK
         /hTaDyO68elzF3YnRg3BXSiiDe8Mzch/PeA/xB+BB8saGC05UjVGha7oHtITjRaMW/EB
         W+A8yDpb8tKdESRYAQw5n7quQ5fk7NyUiHpAvRM/igKE8y+PQxVNnqB2XRPaIzRM7g6W
         M7kw==
X-Forwarded-Encrypted: i=1; AHgh+Rpp7TJiG+dBfJZIP3uCFgdaafpt0RS44VKHwyEIqjCcLQVaYWchEOyb/rsx/xUGl83tS+rt2A+WQYjk+3M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+Onhun1DEGpOZLSYpeITN/Sp812L3ITY+wk6intFjm+67GIpK
	OfD/f83fQVOdb0Z9l3yr1Vx8DLw/4bJe2NuQdIRBIOK2Y02XlhAlalbB
X-Gm-Gg: AR+sD13XdMdDBJntW4utjaP4BukShAZrColO6XWMjcR+Q2P7tBwxphfPLhsQYzlT42h
	ugc+T4L6eoh4OaeWrkfYq1ZWG9IrkM+rKg729zXdvw73U4GDDPPOz+e+r6IV7PMMQ8eW2/tP7xi
	tjj5uIsKzXI+TWGKb1C6d9ty1bDTEfbxjNM+rsKzo0NjpcAuHYlwUYVndpp9Y6V/6eyXF7+Kmdg
	RBvtzW+UAyfiDl82nxqBUO3OKMzzwyCC7QtX8GOTaBu8cp1MYUi3jqT8GntURw5ptXVfnR241qE
	hNUTzIkeomAgJZNEhPf6rYbGs+TmVAzQU2WgYAaPPLRoMXPFUDs+URN5CS+c1tPJcYXGfoprcC6
	XSUhU+/oYgO5Cbb7HfxO6rh8G+IEYWYCNnSzMa0kQaSNz8T9xuJM/K0CvmIrYrJaD+yb34T70x5
	rN
X-Received: by 2002:a17:902:f709:b0:2b2:67ca:5ff9 with SMTP id d9443c01a7336-2d015902adfmr19995905ad.0.1785228243662;
        Tue, 28 Jul 2026 01:44:03 -0700 (PDT)
Received: from mincom1 ([175.235.236.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7bc585sm48168505ad.51.2026.07.28.01.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 01:44:02 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-crypto@vger.kernel.org
Cc: Jihong Min <hurryman2212@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] crypto: move cycle benchmark helpers out of tcrypt
Date: Tue, 28 Jul 2026 17:43:29 +0900
Message-ID: <e0ce93088c1d9772e928fcbd113a446b7fb7442f.1785226804.git.hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1785226804.git.hurryman2212@gmail.com>
References: <cover.1785226804.git.hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the reusable AEAD, ahash, and skcipher cycle measurement loops
into a dedicated benchmark module. Preserve tcrypt's existing output
and benchmark behavior while allowing crypto drivers to use the same
helpers for runtime comparisons.

Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 crypto/Kconfig             |  15 ++-
 crypto/Makefile            |   2 +
 crypto/benchmark.c         | 180 +++++++++++++++++++++++++++++++
 crypto/tcrypt.c            | 213 +++++--------------------------------
 include/crypto/benchmark.h |  24 +++++
 5 files changed, 242 insertions(+), 192 deletions(-)
 create mode 100644 crypto/benchmark.c
 create mode 100644 include/crypto/benchmark.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index f1e372195273..0cba261e3b88 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -244,13 +244,22 @@ config CRYPTO_KRB5ENC
 	  profile.  This is required for Kerberos 5-style encryption, used by
 	  sunrpc/NFS and rxrpc/AFS.
 
-config CRYPTO_BENCHMARK
-	tristate "Crypto benchmarking module"
-	depends on m || EXPERT
+config CRYPTO_BENCHMARK_LIB
+	tristate
 	select CRYPTO_AEAD
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
 	select CRYPTO_SKCIPHER
+	help
+	  Build reusable benchmark helpers for Crypto API algorithms.  This
+	  internal library is shared by tcrypt and drivers that select
+	  implementations from measurements made while their devices are
+	  initialized.
+
+config CRYPTO_BENCHMARK
+	tristate "Crypto benchmarking module"
+	depends on m || EXPERT
+	select CRYPTO_BENCHMARK_LIB
 	help
 	  Quick & dirty crypto benchmarking module.
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 8386d55a9755..77720b746503 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -165,6 +165,8 @@ UBSAN_SANITIZE_jitterentropy.o = n
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE) += jitterentropy-testing.o
 obj-$(CONFIG_CRYPTO_BENCHMARK) += tcrypt.o
+obj-$(CONFIG_CRYPTO_BENCHMARK_LIB) += crypt-benchmark.o
+crypt-benchmark-y := benchmark.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
diff --git a/crypto/benchmark.c b/crypto/benchmark.c
new file mode 100644
index 000000000000..ad27cdaa7491
--- /dev/null
+++ b/crypto/benchmark.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <crypto/aead.h>
+#include <crypto/benchmark.h>
+#include <crypto/hash.h>
+#include <crypto/skcipher.h>
+#include <linux/module.h>
+#include <linux/timex.h>
+
+int crypto_benchmark_aead_cycles(struct aead_request *req, bool encrypt,
+				 unsigned int warmup_runs, unsigned int runs,
+				 u64 *total_cycles)
+{
+	struct crypto_wait *wait;
+	unsigned int i;
+	u64 cycles = 0;
+	int ret;
+
+	if (!req || !req->base.data || !runs || !total_cycles)
+		return -EINVAL;
+
+	wait = req->base.data;
+	*total_cycles = 0;
+
+	for (i = 0; i < warmup_runs; i++) {
+		if (encrypt)
+			ret = crypto_wait_req(crypto_aead_encrypt(req), wait);
+		else
+			ret = crypto_wait_req(crypto_aead_decrypt(req), wait);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < runs; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+		if (encrypt)
+			ret = crypto_wait_req(crypto_aead_encrypt(req), wait);
+		else
+			ret = crypto_wait_req(crypto_aead_decrypt(req), wait);
+		end = get_cycles();
+		if (ret)
+			return ret;
+
+		cycles += end - start;
+	}
+
+	*total_cycles = cycles;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_benchmark_aead_cycles);
+
+int crypto_benchmark_ahash_cycles(struct ahash_request *req,
+				  unsigned int block_size,
+				  unsigned int update_size,
+				  unsigned int warmup_runs, unsigned int runs,
+				  u64 *total_cycles)
+{
+	struct crypto_wait *wait;
+	unsigned int processed;
+	unsigned int i;
+	u64 cycles = 0;
+	int ret;
+
+	if (!req || !req->base.data || !block_size || !update_size ||
+	    block_size % update_size || !runs || !total_cycles)
+		return -EINVAL;
+
+	wait = req->base.data;
+	*total_cycles = 0;
+
+	for (i = 0; i < warmup_runs; i++) {
+		if (update_size == block_size) {
+			ret = crypto_wait_req(crypto_ahash_digest(req), wait);
+			if (ret)
+				return ret;
+			continue;
+		}
+
+		ret = crypto_wait_req(crypto_ahash_init(req), wait);
+		if (ret)
+			return ret;
+		for (processed = 0; processed < block_size;
+		     processed += update_size) {
+			ret = crypto_wait_req(crypto_ahash_update(req), wait);
+			if (ret)
+				return ret;
+		}
+		ret = crypto_wait_req(crypto_ahash_final(req), wait);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < runs; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+		if (update_size == block_size) {
+			ret = crypto_wait_req(crypto_ahash_digest(req), wait);
+		} else {
+			ret = crypto_wait_req(crypto_ahash_init(req), wait);
+			if (ret)
+				goto measure_end;
+			for (processed = 0; processed < block_size;
+			     processed += update_size) {
+				ret = crypto_wait_req(crypto_ahash_update(req),
+						      wait);
+				if (ret)
+					goto measure_end;
+			}
+			ret = crypto_wait_req(crypto_ahash_final(req), wait);
+		}
+measure_end:
+		end = get_cycles();
+		if (ret)
+			return ret;
+
+		cycles += end - start;
+	}
+
+	*total_cycles = cycles;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_benchmark_ahash_cycles);
+
+int crypto_benchmark_skcipher_cycles(struct skcipher_request *req, bool encrypt,
+				     unsigned int warmup_runs,
+				     unsigned int runs, u64 *total_cycles)
+{
+	struct crypto_wait *wait;
+	unsigned int i;
+	u64 cycles = 0;
+	int ret;
+
+	if (!req || !req->base.data || !runs || !total_cycles)
+		return -EINVAL;
+
+	wait = req->base.data;
+	*total_cycles = 0;
+
+	for (i = 0; i < warmup_runs; i++) {
+		if (encrypt)
+			ret = crypto_wait_req(crypto_skcipher_encrypt(req),
+					      wait);
+		else
+			ret = crypto_wait_req(crypto_skcipher_decrypt(req),
+					      wait);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < runs; i++) {
+		cycles_t start, end;
+
+		start = get_cycles();
+		if (encrypt)
+			ret = crypto_wait_req(crypto_skcipher_encrypt(req),
+					      wait);
+		else
+			ret = crypto_wait_req(crypto_skcipher_decrypt(req),
+					      wait);
+		end = get_cycles();
+		if (ret)
+			return ret;
+
+		cycles += end - start;
+	}
+
+	*total_cycles = cycles;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_benchmark_skcipher_cycles);
+
+MODULE_AUTHOR("Jihong Min <hurryman2212@gmail.com>");
+MODULE_DESCRIPTION("Crypto API benchmark helpers");
+MODULE_LICENSE("GPL");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 61a2501bfe9b..81c77f3d7a17 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -20,6 +20,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <crypto/aead.h>
+#include <crypto/benchmark.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
 #include <linux/err.h>
@@ -473,48 +474,6 @@ static int test_aead_jiffies(struct aead_request *req, int enc,
 	return 0;
 }
 
-static int test_aead_cycles(struct aead_request *req, int enc, int blen)
-{
-	unsigned long cycles = 0;
-	int ret = 0;
-	int i;
-
-	/* Warm-up run. */
-	for (i = 0; i < 4; i++) {
-		if (enc)
-			ret = do_one_aead_op(req, crypto_aead_encrypt(req));
-		else
-			ret = do_one_aead_op(req, crypto_aead_decrypt(req));
-
-		if (ret)
-			goto out;
-	}
-
-	/* The real thing. */
-	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
-
-		start = get_cycles();
-		if (enc)
-			ret = do_one_aead_op(req, crypto_aead_encrypt(req));
-		else
-			ret = do_one_aead_op(req, crypto_aead_decrypt(req));
-		end = get_cycles();
-
-		if (ret)
-			goto out;
-
-		cycles += end - start;
-	}
-
-out:
-	if (ret == 0)
-		pr_cont("1 operation in %lu cycles (%d bytes)\n",
-			(cycles + 4) / 8, blen);
-
-	return ret;
-}
-
 static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			    struct aead_speed_template *template,
 			    unsigned int tcount, u8 authsize,
@@ -669,7 +628,13 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 							secs);
 				cond_resched();
 			} else {
-				ret = test_aead_cycles(req, enc, bs);
+				u64 cycles;
+
+				ret = crypto_benchmark_aead_cycles(req, enc, 4,
+								   8, &cycles);
+				if (!ret)
+					pr_cont("1 operation in %llu cycles (%d bytes)\n",
+						(cycles + 4) / 8, bs);
 			}
 
 			if (ret) {
@@ -768,101 +733,6 @@ static int test_ahash_jiffies(struct ahash_request *req, int blen,
 	return 0;
 }
 
-static int test_ahash_cycles_digest(struct ahash_request *req, int blen,
-				    char *out)
-{
-	unsigned long cycles = 0;
-	int ret, i;
-
-	/* Warm-up run. */
-	for (i = 0; i < 4; i++) {
-		ret = do_one_ahash_op(req, crypto_ahash_digest(req));
-		if (ret)
-			goto out;
-	}
-
-	/* The real thing. */
-	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
-
-		start = get_cycles();
-
-		ret = do_one_ahash_op(req, crypto_ahash_digest(req));
-		if (ret)
-			goto out;
-
-		end = get_cycles();
-
-		cycles += end - start;
-	}
-
-out:
-	if (ret)
-		return ret;
-
-	pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
-		cycles / 8, cycles / (8 * blen));
-
-	return 0;
-}
-
-static int test_ahash_cycles(struct ahash_request *req, int blen,
-			     int plen, char *out)
-{
-	unsigned long cycles = 0;
-	int i, pcount, ret;
-
-	if (plen == blen)
-		return test_ahash_cycles_digest(req, blen, out);
-
-	/* Warm-up run. */
-	for (i = 0; i < 4; i++) {
-		ret = do_one_ahash_op(req, crypto_ahash_init(req));
-		if (ret)
-			goto out;
-		for (pcount = 0; pcount < blen; pcount += plen) {
-			ret = do_one_ahash_op(req, crypto_ahash_update(req));
-			if (ret)
-				goto out;
-		}
-		ret = do_one_ahash_op(req, crypto_ahash_final(req));
-		if (ret)
-			goto out;
-	}
-
-	/* The real thing. */
-	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
-
-		start = get_cycles();
-
-		ret = do_one_ahash_op(req, crypto_ahash_init(req));
-		if (ret)
-			goto out;
-		for (pcount = 0; pcount < blen; pcount += plen) {
-			ret = do_one_ahash_op(req, crypto_ahash_update(req));
-			if (ret)
-				goto out;
-		}
-		ret = do_one_ahash_op(req, crypto_ahash_final(req));
-		if (ret)
-			goto out;
-
-		end = get_cycles();
-
-		cycles += end - start;
-	}
-
-out:
-	if (ret)
-		return ret;
-
-	pr_cont("%6lu cycles/operation, %4lu cycles/byte\n",
-		cycles / 8, cycles / (8 * blen));
-
-	return 0;
-}
-
 static void test_ahash_speed_common(const char *algo, unsigned int secs,
 				    struct hash_speed *speed, unsigned mask)
 {
@@ -931,8 +801,15 @@ static void test_ahash_speed_common(const char *algo, unsigned int secs,
 						 speed[i].plen, output, secs);
 			cond_resched();
 		} else {
-			ret = test_ahash_cycles(req, speed[i].blen,
-						speed[i].plen, output);
+			u64 cycles;
+
+			ret = crypto_benchmark_ahash_cycles(req, speed[i].blen,
+							    speed[i].plen, 4, 8,
+							    &cycles);
+			if (!ret)
+				pr_cont("%6llu cycles/operation, %4llu cycles/byte\n",
+					cycles / 8,
+					cycles / (8 * speed[i].blen));
 		}
 
 		if (ret) {
@@ -1249,53 +1126,6 @@ static int test_acipher_jiffies(struct skcipher_request *req, int enc,
 	return 0;
 }
 
-static int test_acipher_cycles(struct skcipher_request *req, int enc,
-			       int blen)
-{
-	unsigned long cycles = 0;
-	int ret = 0;
-	int i;
-
-	/* Warm-up run. */
-	for (i = 0; i < 4; i++) {
-		if (enc)
-			ret = do_one_acipher_op(req,
-						crypto_skcipher_encrypt(req));
-		else
-			ret = do_one_acipher_op(req,
-						crypto_skcipher_decrypt(req));
-
-		if (ret)
-			goto out;
-	}
-
-	/* The real thing. */
-	for (i = 0; i < 8; i++) {
-		cycles_t start, end;
-
-		start = get_cycles();
-		if (enc)
-			ret = do_one_acipher_op(req,
-						crypto_skcipher_encrypt(req));
-		else
-			ret = do_one_acipher_op(req,
-						crypto_skcipher_decrypt(req));
-		end = get_cycles();
-
-		if (ret)
-			goto out;
-
-		cycles += end - start;
-	}
-
-out:
-	if (ret == 0)
-		pr_cont("1 operation in %lu cycles (%d bytes)\n",
-			(cycles + 4) / 8, blen);
-
-	return ret;
-}
-
 static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 				struct cipher_speed_template *template,
 				unsigned int tcount, u8 *keysize, bool async)
@@ -1405,8 +1235,13 @@ static void test_skcipher_speed(const char *algo, int enc, unsigned int secs,
 							   bs, secs);
 				cond_resched();
 			} else {
-				ret = test_acipher_cycles(req, enc,
-							  bs);
+				u64 cycles;
+
+				ret = crypto_benchmark_skcipher_cycles(req, enc, 4,
+								       8, &cycles);
+				if (!ret)
+					pr_cont("1 operation in %llu cycles (%d bytes)\n",
+						(cycles + 4) / 8, bs);
 			}
 
 			if (ret) {
diff --git a/include/crypto/benchmark.h b/include/crypto/benchmark.h
new file mode 100644
index 000000000000..09dc0fb38483
--- /dev/null
+++ b/include/crypto/benchmark.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _CRYPTO_BENCHMARK_H
+#define _CRYPTO_BENCHMARK_H
+
+#include <linux/types.h>
+
+struct aead_request;
+struct ahash_request;
+struct skcipher_request;
+
+/* Requests must use crypto_req_done() with struct crypto_wait callback data. */
+int crypto_benchmark_aead_cycles(struct aead_request *req, bool encrypt,
+				 unsigned int warmup_runs, unsigned int runs,
+				 u64 *total_cycles);
+int crypto_benchmark_ahash_cycles(struct ahash_request *req,
+				  unsigned int block_size,
+				  unsigned int update_size,
+				  unsigned int warmup_runs, unsigned int runs,
+				  u64 *total_cycles);
+int crypto_benchmark_skcipher_cycles(struct skcipher_request *req, bool encrypt,
+				     unsigned int warmup_runs,
+				     unsigned int runs, u64 *total_cycles);
+
+#endif /* _CRYPTO_BENCHMARK_H */
-- 
2.53.0
