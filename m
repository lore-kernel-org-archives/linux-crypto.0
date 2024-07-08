Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B581419B5;
	Mon,  8 Jul 2024 12:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720441497; cv=none; b=GoL9SnMtqoMAp+eNmpOactgqP7A88GbqkXMpjRWKGZCauyemMwCklLolgUIQD0NetC16JYKmjw2UbjIzvdQB9DwXnzcdyOTDzgtJPVui0gaSjJWnDoGXT1C3pdJPJ+K6ffmOfnB6cV8qOdKP8IKToK5AoHHZjjwh8o8YNLhFwO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720441497; c=relaxed/simple;
	bh=hAjK1CSgalbDgXlil2C5+pUhvGQFCTOlGlL6Abg5m5c=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mEYb1T/H/ChrPzAskFPrhByVMXVLOgETh0MuyXpLaQbUqpGoPDvcTdJwClZOcqn04tOV9ToT68ycphs4fKx0rWjFCr/EgBFYStMdfW0HpEH2cbS7fy7uvSr64UOeR9dHBbgGXnj0htbJdsxuNY4Cj9oDepkh4LON+E8t50Xa+uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IqblDYz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IqblDYz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156C6C4AF0A;
	Mon,  8 Jul 2024 12:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720441496;
	bh=hAjK1CSgalbDgXlil2C5+pUhvGQFCTOlGlL6Abg5m5c=;
	h=Date:From:To:Subject:From;
	b=IqblDYz0wjoX6XXXaYKaFiMx+pGX9c8cP9UZqRpWykL6Kved7cDMUk7dxwCuYqkI0
	 /Z33YJpDR/8MPPXLOqWoF7qFzKeMaW/iAtiyGhYAq/l1X8VDwm2NM+Zl0rkgqatfU9
	 Z+KbMOTepkzG9Maj7ncIklKjVhgBYjfnZZ1n7H06abKk3AHKCOWZ13b38A8xO6JsYB
	 TlVut0V1TluIB673+EvoLQSRABAsJ8Y3E2PJFuvIx8tlTyNMKdmfF9M+yh1dMmMvMB
	 WAZR0Q/Ekhz216spDqmQR/HDad9SQbnrkmX+MqEF/Kyhth/zQd9oxSku6gPzyc8DN9
	 TqmI/cfIpwc5g==
Date: Mon, 8 Jul 2024 14:24:52 +0200
From: Helge Deller <deller@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org
Subject: [PATCH v2] crypto: xor - fix template benchmarking
Message-ID: <ZovalOTfarFv1SZa@p100>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commit c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
switched from using jiffies to ktime-based performance benchmarking.

This works nicely on machines which have a fine-grained ktime()
clocksource as e.g. x86 machines with TSC.
But other machines, e.g. my 4-way HP PARISC server, don't have such
fine-grained clocksources, which is why it seems that 800 xor loops
take zero seconds, which then shows up in the logs as:

 xor: measuring software checksum speed
    8regs           : -1018167296 MB/sec
    8regs_prefetch  : -1018167296 MB/sec
    32regs          : -1018167296 MB/sec
    32regs_prefetch : -1018167296 MB/sec

Fix this with some small modifications to the existing code to improve
the algorithm to always produce correct results without introducing
major delays for architectures with a fine-grained ktime()
clocksource:
a) Delay start of the timing until ktime() just advanced. On machines
with a fast ktime() this should be just one additional ktime() call.
b) Count the number of loops. Run at minimum 800 loops and finish
earliest when the ktime() counter has progressed.

With that the throughput can now be calculated more accurately under all
conditions.

Fixes: c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
Signed-off-by: Helge Deller <deller@gmx.de>
Tested-by: John David Anglin <dave.anglin@bell.net>

v2:
- clean up coding style (noticed & suggested by Herbert Xu)
- rephrased & fixed typo in commit message

diff --git a/crypto/xor.c b/crypto/xor.c
index 8e72e5d5db0d..56aa3169e871 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -83,33 +83,30 @@ static void __init
 do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 {
 	int speed;
-	int i, j;
-	ktime_t min, start, diff;
+	unsigned long reps;
+	ktime_t min, start, t0;
 
 	tmpl->next = template_list;
 	template_list = tmpl;
 
 	preempt_disable();
 
-	min = (ktime_t)S64_MAX;
-	for (i = 0; i < 3; i++) {
-		start = ktime_get();
-		for (j = 0; j < REPS; j++) {
-			mb(); /* prevent loop optimization */
-			tmpl->do_2(BENCH_SIZE, b1, b2);
-			mb();
-		}
-		diff = ktime_sub(ktime_get(), start);
-		if (diff < min)
-			min = diff;
-	}
+	reps = 0;
+	t0 = ktime_get();
+	/* delay start until time has advanced */
+	while ((start = ktime_get()) == t0)
+		cpu_relax();
+	do {
+		mb(); /* prevent loop optimization */
+		tmpl->do_2(BENCH_SIZE, b1, b2);
+		mb();
+	} while (reps++ < REPS || (t0 = ktime_get()) == start);
+	min = ktime_sub(t0, start);
 
 	preempt_enable();
 
 	// bytes/ns == GB/s, multiply by 1000 to get MB/s [not MiB/s]
-	if (!min)
-		min = 1;
-	speed = (1000 * REPS * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
+	speed = (1000 * reps * BENCH_SIZE) / (unsigned int)ktime_to_ns(min);
 	tmpl->speed = speed;
 
 	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
