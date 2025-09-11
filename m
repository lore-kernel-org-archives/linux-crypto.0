Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14338362092;
	Thu, 11 Sep 2025 17:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757613187; cv=none; b=bZuhp0aLC7yp5KBNAfdTw8x8Eh5X3jZ05/ymr7UVdUYkzRE6aFGi/6bm/wO8fyOwatEzZZw1Z29o6OX0SjUr67YZ63/ue5AOgmiQ6Aioa/mupdmaZs+XEEupB2MndnvqAD0XCZ8IhJXZnOe+74wkrFW0g7a5eBIyTiR7mB1f354=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757613187; c=relaxed/simple;
	bh=Z2+nBVkWPIG88TqQQAQmMSXJogs17OhTvk+WeLYH5XY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ec+DqISJgnY5v2YF+wVZwncqjcsdpNh0jWwX2oqK+g96WXV4/qijORmVhmEbCgkceOdAtdNqrVvLyy20JcfPKvA2WNMp2A6+n3DZYDP0XsndTt33O7m5jo8gagIdl/mV5++eeED2oKHqV4Lwn6INe+35g2FQYviu2brH2aM03Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bkf3Wnkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bkf3Wnkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520F5C4CEF0;
	Thu, 11 Sep 2025 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757613186;
	bh=Z2+nBVkWPIG88TqQQAQmMSXJogs17OhTvk+WeLYH5XY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bkf3WnkqmhSBMwSLyzsGZ4azoGtNd8x/AeMvYcXme2KsLCIEMQZtg0JCCc0qUpn1v
	 z+u3JV55OoKd/cRJ6z1iBNauxJ8IY3vgnqPeeCjoP6Me9/aABeN2uwINlWrmbuDTwg
	 2ZAEVKEL4LaW+BUqXN5EXd9Z3vxEV7T36Ngf2dwKRUpV2qo0xtn+0oBYPXaDxpFMKo
	 oi5aJWCkp7UljPT7nxxCFxB4+IUEG/RoY+2H0P0xN4n5nIPexb1NlE92bPoInX0VtG
	 r4ZnCaWOYjkUaGV2sCttM3XsoIt94mqYpPGnYpbPB5uyczrJ7QqVvd3/6z+a1xgSi3
	 HCnY4YKUgLeQA==
Date: Thu, 11 Sep 2025 10:51:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com,
	Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
Message-ID: <20250911175145.GA1376@sol>
References: <20250829164500.324329-1-ebiggers@kernel.org>
 <20250910194921.GA3153735@google.com>
 <CAG_fn=W_7o6ANs94GwoYjyjvY5kSFYHB6DwfE+oXM7TP1eP5dw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG_fn=W_7o6ANs94GwoYjyjvY5kSFYHB6DwfE+oXM7TP1eP5dw@mail.gmail.com>

On Thu, Sep 11, 2025 at 11:09:17AM +0200, Alexander Potapenko wrote:
> On Wed, Sep 10, 2025 at 9:49 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Fri, Aug 29, 2025 at 09:45:00AM -0700, Eric Biggers wrote:
> > > Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> > > kmsan_internal_set_shadow_origin():
> > >
> > >     BUG: unable to handle page fault for address: ffffbc3840291000
> > >     #PF: supervisor read access in kernel mode
> > >     #PF: error_code(0x0000) - not-present page
> > >     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
> > >     Oops: 0000 [#1] SMP NOPTI
> > >     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
> > >     Tainted: [N]=TEST
> > >     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> > >     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
> > >     [...]
> > >     Call Trace:
> > >     <TASK>
> > >     __msan_memset+0xee/0x1a0
> > >     sha224_final+0x9e/0x350
> > >     test_hash_buffer_overruns+0x46f/0x5f0
> > >     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
> > >     ? __pfx_test_hash_buffer_overruns+0x10/0x10
> > >     kunit_try_run_case+0x198/0xa00
> >
> > Any thoughts on this patch from the KMSAN folks?  I'd love to add
> > CONFIG_KMSAN=y to my crypto subsystem testing, but unfortunately the
> > kernel crashes due to this bug :-(
> >
> > - Eric
> 
> Sorry, I was out in August and missed this email when digging through my inbox.
> 
> Curiously, I couldn't find any relevant crashes on the KMSAN syzbot
> instance, but the issue is legit.
> Thank you so much for fixing this!
> 
> Any chance you can add a test case for it to mm/kmsan/kmsan_test.c?

Unfortunately most of the KMSAN test cases already fail on upstream,
which makes it difficult to develop new ones:

[    1.322395] KTAP version 1
[    1.322899] 1..1
[    1.323644]     KTAP version 1
[    1.324142]     # Subtest: kmsan
[    1.324650]     # module: kmsan_test
[    1.324667]     1..24
[    1.325990]     # test_uninit_kmalloc: uninitialized kmalloc test (UMR report)
[    1.327078] *ptr is true
[    1.327525]     # test_uninit_kmalloc: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:173
                   Expected report_matches(&expect) to be true, but is false
[    1.330117]     not ok 1 test_uninit_kmalloc
[    1.330474]     # test_init_kmalloc: initialized kmalloc test (no reports)
[    1.332129] *ptr is false
[    1.333384]     ok 2 test_init_kmalloc
[    1.333729]     # test_init_kzalloc: initialized kzalloc test (no reports)
[    1.335285] *ptr is false
[    1.339418]     ok 3 test_init_kzalloc
[    1.339791]     # test_uninit_stack_var: uninitialized stack variable (UMR report)
[    1.341484] cond is false
[    1.341927]     # test_uninit_stack_var: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:211
                   Expected report_matches(&expect) to be true, but is false
[    1.344844]     not ok 4 test_uninit_stack_var
[    1.345262]     # test_init_stack_var: initialized stack variable (no reports)
[    1.347083] cond is true
[    1.347847]     ok 5 test_init_stack_var
[    1.348145]     # test_params: uninit passed through a function parameter (UMR report)
[    1.349926] arg1 is false
[    1.350338] arg2 is false
[    1.350746] arg is false
[    1.351154] arg1 is false
[    1.351561] arg2 is true
[    1.351987]     # test_params: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:262
                   Expected report_matches(&expect) to be true, but is false
[    1.354751]     not ok 6 test_params
[    1.355229]     # test_uninit_multiple_params: uninitialized local passed to fn (UMR report)
[    1.357056] signed_sum3(a, b, c) is true
[    1.357677]     # test_uninit_multiple_params: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:282
                   Expected report_matches(&expect) to be true, but is false
[    1.360393]     not ok 7 test_uninit_multiple_params
[    1.360676]     # test_uninit_kmsan_check_memory: kmsan_check_memory() called on uninit local (UMR report)
[    1.362916]     # test_uninit_kmsan_check_memory: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:309
                   Expected report_matches(&expect) to be true, but is false
[    1.365946]     not ok 8 test_uninit_kmsan_check_memory
[    1.366415]     # test_init_kmsan_vmap_vunmap: pages initialized via vmap (no reports)
[    1.368805]     ok 9 test_init_kmsan_vmap_vunmap
[    1.369223]     # test_init_vmalloc: vmalloc buffer can be initialized (no reports)
[    1.371106] buf[0] is true
[    1.371937]     ok 10 test_init_vmalloc
[    1.372396]     # test_uaf: use-after-free in kmalloc-ed buffer (UMR report)
[    1.374021] value is true
[    1.374463]     # test_uaf: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:378
                   Expected report_matches(&expect) to be true, but is false
[    1.376867]     not ok 11 test_uaf
[    1.377229]     # test_percpu_propagate: uninit local stored to per_cpu memory (UMR report)
[    1.378951] check is false
[    1.379432]     # test_percpu_propagate: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:396
                   Expected report_matches(&expect) to be true, but is false
[    1.382201]     not ok 12 test_percpu_propagate
[    1.382625]     # test_printk: uninit local passed to pr_info() (UMR report)
[    1.384329] ffffc900002bfcd4 contains 0
[    1.384933]     # test_printk: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:418
                   Expected report_matches(&expect) to be true, but is false
[    1.387474]     not ok 13 test_printk
[    1.387824]     # test_init_memcpy: memcpy()ing aligned initialized src to aligned dst (no reports)
[    1.390061]     ok 14 test_init_memcpy
[    1.390327]     # test_memcpy_aligned_to_aligned: memcpy()ing aligned uninit src to aligned dst (UMR report)
[    1.392359]     # test_memcpy_aligned_to_aligned: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:459
                   Expected report_matches(&expect) to be true, but is false
[    1.395181]     not ok 15 test_memcpy_aligned_to_aligned
[    1.395467]     # test_memcpy_aligned_to_unaligned: memcpy()ing aligned uninit src to unaligned dst (UMR report)
[    1.397845]     # test_memcpy_aligned_to_unaligned: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:483
                   Expected report_matches(&expect) to be true, but is false
[    1.400221]     # test_memcpy_aligned_to_unaligned: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:486
                   Expected report_matches(&expect) to be true, but is false
[    1.403059]     not ok 16 test_memcpy_aligned_to_unaligned
[    1.403437]     # test_memcpy_initialized_gap: unaligned 4-byte initialized value gets a nonzero origin after memcpy() - (2 UMR reports)
[    1.406077]     # test_memcpy_initialized_gap: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:532
                   Expected report_matches(&expect) to be true, but is false
[    1.408340]     # test_memcpy_initialized_gap: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:538
                   Expected report_matches(&expect) to be true, but is false
[    1.411063]     not ok 17 test_memcpy_initialized_gap
[    1.411338]     # test_memset16: memset16() should initialize memory
[    1.413393]     ok 18 test_memset16
[    1.413651]     # test_memset32: memset32() should initialize memory
[    1.415427]     ok 19 test_memset32
[    1.415739]     # test_memset64: memset64() should initialize memory
[    1.417513]     ok 20 test_memset64
[    1.417783]     # test_long_origin_chain: origin chain exceeding KMSAN_MAX_ORIGIN_DEPTH (UMR report)
[    1.419805]     # test_long_origin_chain: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:584
                   Expected report_matches(&expect) to be true, but is false
[    1.422415]     not ok 21 test_long_origin_chain
[    1.422752]     # test_stackdepot_roundtrip: testing stackdepot roundtrip (no reports)
[    1.424598]  kunit_try_run_case+0x19d/0xa50
[    1.425243]  kunit_generic_run_threadfn_adapter+0x62/0xe0
[    1.426252]  kthread+0x8cd/0xb40
[    1.426747]  ret_from_fork+0x189/0x2b0
[    1.427320]  ret_from_fork_asm+0x1a/0x30
[    1.428245]     ok 22 test_stackdepot_roundtrip
[    1.428519]     # test_unpoison_memory: unpoisoning via the instrumentation vs. kmsan_unpoison_memory() (2 UMR reports)
[    1.430771] =====================================================
[    1.431682] BUG: KMSAN: uninit-value in test_unpoison_memory+0x146/0x3e0
[    1.432705]  test_unpoison_memory+0x146/0x3e0
[    1.433356]  kunit_try_run_case+0x19d/0xa50
[    1.433979]  kunit_generic_run_threadfn_adapter+0x62/0xe0
[    1.434773]  kthread+0x8cd/0xb40
[    1.435263]  ret_from_fork+0x189/0x2b0
[    1.435846]  ret_from_fork_asm+0x1a/0x30

[    1.436692] Local variable a created at:
[    1.437270]  test_unpoison_memory+0x41/0x3e0
[    1.437903]  kunit_try_run_case+0x19d/0xa50

[    1.438766] Bytes 0-2 of 3 are uninitialized
[    1.439433] Memory access of size 3 starts at ffffc90000347cd5

[    1.440517] CPU: 3 UID: 0 PID: 99 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc5-00110-ge59a039119c3 #3 PREEMPT(none) 
[    1.442247] Tainted: [N]=TEST
[    1.442725] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[    1.444376] =====================================================
[    1.445263] Disabling lock debugging due to kernel taint
[    1.446103] =====================================================
[    1.447007] BUG: KMSAN: uninit-value in test_unpoison_memory+0x23f/0x3e0
[    1.447996]  test_unpoison_memory+0x23f/0x3e0
[    1.448650]  kunit_try_run_case+0x19d/0xa50
[    1.449319]  kunit_generic_run_threadfn_adapter+0x62/0xe0
[    1.450122]  kthread+0x8cd/0xb40
[    1.450611]  ret_from_fork+0x189/0x2b0
[    1.451181]  ret_from_fork_asm+0x1a/0x30

[    1.452010] Local variable b created at:
[    1.452894]  test_unpoison_memory+0x56/0x3e0
[    1.453537]  kunit_try_run_case+0x19d/0xa50

[    1.454407] Bytes 0-2 of 3 are uninitialized
[    1.455043] Memory access of size 3 starts at ffffc90000347cd1

[    1.456182] CPU: 3 UID: 0 PID: 99 Comm: kunit_try_catch Tainted: G    B            N  6.17.0-rc5-00110-ge59a039119c3 #3 PREEMPT(none) 
[    1.457925] Tainted: [B]=BAD_PAGE, [N]=TEST
[    1.458545] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
[    1.460239] =====================================================
[    1.461617]     ok 23 test_unpoison_memory
[    1.462056]     # test_copy_from_kernel_nofault: testing copy_from_kernel_nofault with uninitialized memory
[    1.464122] ret is false
[    1.464538]     # test_copy_from_kernel_nofault: EXPECTATION FAILED at mm/kmsan/kmsan_test.c:656
                   Expected report_matches(&expect) to be true, but is false
[    1.467250]     not ok 24 test_copy_from_kernel_nofault
[    1.482563] # kmsan: pass:11 fail:13 skip:0 total:24
[    1.483790] # Totals: pass:11 fail:13 skip:0 total:24
[    1.484532] not ok 1 kmsan
