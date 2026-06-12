Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C0234EF15;
	Fri, 12 Jun 2026 06:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781244061; cv=none; b=lqTPCi185jb2i3IpaGJgCTQ5RfzlTjFxZmrA94rZkLOw6Jnp2MkAuRo0POiCn+LCMhictDGmVIclhdKouCLmXN20FP2v4P6drv+95yW2VRBpYMXjzn6+WMssmVjHAM/si5/v7KvwjtZM5hZ8yrNlTAVupbjozGUceRETIyduZhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781244061; c=relaxed/simple;
	bh=0yegm3eGBOOZV2A1GhTmyIf4+BMiPvaqf/Jc2Gdj6m4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HMtknywLgQfl4GcpSyHTDw5bs9jOrD5IaZFJBmux5+33fM8DA7or0D2k6UcjhfhbS/mrRG4E9nvrjZfEbI4/vyrMW7UemdkrUl4PiqH57axI89XTdcT2+GyDcRd4VVoK8F+UfJEEz21Cu2f+m/0K0SRn7VTDZD7XtwUOWbmThr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VyqZs07Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VyqZs07Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DB21F000E9;
	Fri, 12 Jun 2026 06:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781244059;
	bh=dEOLjGXrCgZXGel/l6AP9eBHKjfvTQ8DdxUtTIy4yCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VyqZs07ZyQfs060hb7fOxSPPWHRUkqOo1M/LqIQBnwuWqKpU1I32WNPchqFMs2Xkg
	 1Y0FliB+HOgGrGGzCEhxFc7RhxZVj9yGzGiCeYBdEGS9cPPAz8mdLaLlPprxqqp8DH
	 n/tXS5ElxlPWb3+MjYVssZ7DtVEJSR7GKHYGBPrvgeO6OSTR+sr0gZ1BOoy0HdEehN
	 UYuXF4uDvd1C56mW5GBQJhYekaH9ehtBqgaiKFDLxuix4Kgff6edm/Mkwq978yJcSz
	 uqBqdG5MKL96gYbRZ+BTLV6mPsecnFtiudU6sW05ZiGRwLwXSmSq5GExGHQtkXnsj2
	 MlMMCQcxR9mHA==
Date: Thu, 11 Jun 2026 22:59:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	Andrea Mazzoleni <amadvance@gmail.com>
Subject: Re: [PATCH] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260612055933.GA6675@sol>
References: <20260612044034.117442-1-ebiggers@kernel.org>
 <20260612052247.GA8848@lst.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612052247.GA8848@lst.de>

On Fri, Jun 12, 2026 at 07:22:47AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 11, 2026 at 09:40:34PM -0700, Eric Biggers wrote:
> > Add an implementation of xor_gen() using AVX-512.
> 
> > Benchmark on AMD Ryzen 9 9950X (Zen 5):
> 
> Can you share the benchmark?

For now I had just hacked up do_xor_speed() as follows and changed
xor_force() to xor_register().  There should be a benchmark added to the
KUnit test similar to the one in the crypto and CRC tests, though.

diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index bd4e6e434418..8c5814af03d5 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -76,15 +76,24 @@ void __init xor_force(struct xor_block_template *tmpl)
 #define REPS		800U
 
 static void __init
-do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
+do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2,
+	     void *b3, void *b4, void *b5)
 {
+	for (int src_cnt = 1; src_cnt <= 4; src_cnt++) {
 	int speed;
 	unsigned long reps;
 	ktime_t min, start, t0;
-	void *srcs[1] = { b2 };
+	void *srcs[4] = { b2, b3, b4, b5 };
 
 	preempt_disable();
 
+	/* warm-up */
+	for (int i = 0; i < 8000; i++) {
+		mb(); /* prevent loop optimization */
+		tmpl->xor_gen(b1, srcs, src_cnt, BENCH_SIZE);
+		mb();
+	}
+
 	reps = 0;
 	t0 = ktime_get();
 	/* delay start until time has advanced */
@@ -92,7 +101,7 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 		cpu_relax();
 	do {
 		mb(); /* prevent loop optimization */
-		tmpl->xor_gen(b1, srcs, 1, BENCH_SIZE);
+		tmpl->xor_gen(b1, srcs, src_cnt, BENCH_SIZE);
 		mb();
 	} while (reps++ < REPS || (t0 = ktime_get()) == start);
 	min = ktime_sub(t0, start);
@@ -105,26 +114,30 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
 
 	pr_info("   %-16s: %5d MB/sec\n", tmpl->name, speed);
 }
+}
 
 static int __init calibrate_xor_blocks(void)
 {
-	void *b1, *b2;
+	void *b1, *b2, *b3, *b4, *b5;
 	struct xor_block_template *f, *fastest;
 
 	if (forced_template)
 		return 0;
 
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	b1 = (void *) __get_free_pages(GFP_KERNEL, 4);
 	if (!b1) {
 		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
 	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
+	b3 = b2 + 2*PAGE_SIZE + BENCH_SIZE;
+	b4 = b3 + 2*PAGE_SIZE + BENCH_SIZE;
+	b5 = b4 + 2*PAGE_SIZE + BENCH_SIZE;
 
 	pr_info("xor: measuring software checksum speed\n");
 	fastest = template_list;
 	for (f = template_list; f; f = f->next) {
-		do_xor_speed(f, b1, b2);
+		do_xor_speed(f, b1, b2, b3, b4, b5);
 		if (f->speed > fastest->speed)
 			fastest = f;
 	}

> In my local tree I have ports of the AVX2 and AVX512 implementations
> from snapraid (https://github.com/amadvance/snapraid), which in userspace
> give really good performance.  On my Laptop with a AMD Ryzen AI 7 PRO 350
> (which is a Zen5 with the slower double pumped AVX512 unit), both of
> them get over 1GB/s throughput on the snapraid benchmarks.  I've been
> holding them back as I don't have a good kernel benchmarking harness,
> and it's missing the quirks for old AVX512 or the newer AMD special
> cases.
> 
> Attached for reference.
> 
> Note that either way I'd prefer if we could get away from the stange
> old code organization with the DO{1-4} helpers which don't really
> help.

Well, doing the same on your avx512bw version and adding a column to my
table for it (by the way, I think it really just needs avx512f), I get:

        src_cnt    avx          avx512       avx512bw
        =======    ==========   ==========   ==========
        1          68423 MB/s   81940 MB/s   12067 MB/s
        2          56035 MB/s   74112 MB/s   10958 MB/s
        3          49396 MB/s   67011 MB/s   8608 MB/s
        4          43056 MB/s   60823 MB/s   8069 MB/s

So, your version isn't great, I'm afraid.  Making the inner loop be over
src_cnt does simplify the code a lot, but it destroys performance since
it turns into 9 instructions for each 64 bytes in each 3 buffers:

      5b:   89 c1                   mov    %eax,%ecx
      5d:   8d 70 01                lea    0x1(%rax),%esi
      60:   48 8b 0c cb             mov    (%rbx,%rcx,8),%rcx
      64:   48 8b 34 f3             mov    (%rbx,%rsi,8),%rsi
      68:   62 f1 fd 48 6f 0c 11    vmovdqa64 (%rcx,%rdx,1),%zmm1
      6f:   62 f3 f5 48 25 04 16    vpternlogq $0x96,(%rsi,%rdx,1),%zmm1,%zmm0
      76:   96 
      77:   83 c0 02                add    $0x2,%eax
      7a:   39 f8                   cmp    %edi,%eax
      7c:   72 dd                   jb     5b <xor_gen_avx512bw+0x4b>

You could try unrolling by 512 bytes, which should help.

- Eric
