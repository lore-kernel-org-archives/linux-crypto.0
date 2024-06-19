Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E663F155C8E;
	Wed, 19 Jun 2024 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818322; cv=none; b=GdD9qB62hZza1Nd96XltoLrelKatrIEVmvIl8AfGaEGS6AK14FznrMR+cCnB5Cb3Inoo0lhvVY+3eWkN7VyBxwCaQsN9/MzZck4IFHwPxsUUcAS6f06SLnCEXVm1R15uNwiNDQdSuB4IRhEbYfKf8TXsxbOWwny6/+UVc8EYdXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818322; c=relaxed/simple;
	bh=Bk8pDU+SPg5xF1wbzUJW8YF5QkNMCQk0wDQv5SKdeSo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kLRj7/AVvqnHi3hN9W3+HJGr204l5XUkQTSWInKxJglFzQnZOqcH94IOxKW87ukL5xEC0HhHVt3CtaknHmu2BdMBfeYHhleETPOYwDcVIXE+uxh1cYb1akrQzSXSCP+CLE36CF35AM56ZTeL4ElDtqFx3g4ssctKKb+qhQxkKXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Se7Za0se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Se7Za0se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE82C2BBFC;
	Wed, 19 Jun 2024 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718818321;
	bh=Bk8pDU+SPg5xF1wbzUJW8YF5QkNMCQk0wDQv5SKdeSo=;
	h=Date:From:To:Cc:Subject:From;
	b=Se7Za0segNU66V+823W3EJnFXofqChSRcSnLsR/AgAb6p4vYOhC+VMTVfY7TlIfRG
	 aJydnAvXCtRMAJzQG7rTyGY4TreNQszmg6i3At0w/TH9Ld8FmhUE9M8NUjfn+PD6Fb
	 ynZUBbnIw0Pmw+BogfQNDX19+3NTfCXShYu0FrV10FeLk8nxnblUjKjdVmRi/6tKfw
	 JTU5/Nvq9lS0e6Cz7lRypYNzsEjd85FqtM0Rjyu4aHU0hVgQ+afMhNEcOuP72bQUoY
	 PUSOeEIF2eaaH1XNnn6M2dq457+/f7zWfE8DolizUG8rxinvygznA8TgQmotAi86mW
	 bGnFusMSNGsCQ==
Date: Wed, 19 Jun 2024 19:31:57 +0200
From: Helge Deller <deller@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: xor - fix template benchmarking
Message-ID: <ZnMWDdKJHfYQLDzS@p100>
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
clocksource as e.g. x86 machoines with TSC.
But other machines, e.g. my 4-way HP PARISC server, don't have such
fine-grained clocksources, which is why it seems that 800 xor loops
take zero seconds, which then calculates in the logs as:

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

diff --git a/crypto/xor.c b/crypto/xor.c
index 8e72e5d5db0d..29b4c0fd89d7 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -83,33 +83,29 @@ static void __init
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
+	t0 = ktime_get();
+	/* delay start until time has advanced */
+	do { start = ktime_get(); } while (start == t0);
+	reps = 0;
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
