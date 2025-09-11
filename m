Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601CB2DC778;
	Thu, 11 Sep 2025 19:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757619075; cv=none; b=oi7wHknVluHGw/aaOYikz63NRB1kW7vgylphjhAVrbbQGGCe+JmFdmmCkGGWbnkmnfyn22Cc8CTNG0JtLOTJlSdNIQrq0qb8C+mTSkMfIfPoiBAQglKlB/DOsR9aU1ChcpS5EGY6VpLocnHWMhR2MNuZCHUeUuZlHw2QyR96/3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757619075; c=relaxed/simple;
	bh=Qlsnxx5xoSOGiAxOfSS6gsBgNRLsgue6LjVool+d9vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JhqFqHq24doHk9tny2WGbGSDmTuM83Sik1Lks8XTUIMKxm+ViEkhLsqUoADdBqZOVdA1a2ZQldiOqavFAOBzqLi8CWTeAFs985aFt1Is/G6zDNQ3FSjiIL/IOWPaYBI0sZIQ61SpJqGOUcGLqIWG+4MfwUxegE55wi9D26DNOo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=exip/QW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="exip/QW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A6DC4CEF0;
	Thu, 11 Sep 2025 19:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757619074;
	bh=Qlsnxx5xoSOGiAxOfSS6gsBgNRLsgue6LjVool+d9vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=exip/QW4v+IgClXJq68192Q8g2BA14FnRL3v6oxVrQVhnFn7FMEV52G1a8EYl9v49
	 PE654ArlxFQn+0nlJBVUp139EeUiOS/ZEI8Ba/H6wgpazoZsGJqgr1yhNa+RyRGztX
	 +ZsA4LN2czoOdGXqNmvaHMbiTH8mvL2CzdMHVWqMy+RLbvijvCdOfP/wfWHVLPl84Z
	 ZHaJj7k5Iiya8QZII8YDnIXGt+XsMQKWmnlEX+4NZb/37R22F6HmFCl74XoCnvi/Kt
	 kj+LZtENT5LZrhO7SxwS7w8ji4b8y8BfwYm2gTmKN4rOLTM/7ZkeTykUO9QyCt16Er
	 vTolONRdHF5xw==
Date: Thu, 11 Sep 2025 12:29:53 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com,
	Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
Message-ID: <20250911192953.GG1376@sol>
References: <20250829164500.324329-1-ebiggers@kernel.org>
 <20250910194921.GA3153735@google.com>
 <CAG_fn=W_7o6ANs94GwoYjyjvY5kSFYHB6DwfE+oXM7TP1eP5dw@mail.gmail.com>
 <20250911175145.GA1376@sol>
 <20250911190302.GF1376@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250911190302.GF1376@sol>

On Thu, Sep 11, 2025 at 12:03:02PM -0700, Eric Biggers wrote:
> On Thu, Sep 11, 2025 at 10:51:45AM -0700, Eric Biggers wrote:
> > On Thu, Sep 11, 2025 at 11:09:17AM +0200, Alexander Potapenko wrote:
> > > On Wed, Sep 10, 2025 at 9:49 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > On Fri, Aug 29, 2025 at 09:45:00AM -0700, Eric Biggers wrote:
> > > > > Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> > > > > kmsan_internal_set_shadow_origin():
> > > > >
> > > > >     BUG: unable to handle page fault for address: ffffbc3840291000
> > > > >     #PF: supervisor read access in kernel mode
> > > > >     #PF: error_code(0x0000) - not-present page
> > > > >     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
> > > > >     Oops: 0000 [#1] SMP NOPTI
> > > > >     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
> > > > >     Tainted: [N]=TEST
> > > > >     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> > > > >     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
> > > > >     [...]
> > > > >     Call Trace:
> > > > >     <TASK>
> > > > >     __msan_memset+0xee/0x1a0
> > > > >     sha224_final+0x9e/0x350
> > > > >     test_hash_buffer_overruns+0x46f/0x5f0
> > > > >     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
> > > > >     ? __pfx_test_hash_buffer_overruns+0x10/0x10
> > > > >     kunit_try_run_case+0x198/0xa00
> > > >
> > > > Any thoughts on this patch from the KMSAN folks?  I'd love to add
> > > > CONFIG_KMSAN=y to my crypto subsystem testing, but unfortunately the
> > > > kernel crashes due to this bug :-(
> > > >
> > > > - Eric
> > > 
> > > Sorry, I was out in August and missed this email when digging through my inbox.
> > > 
> > > Curiously, I couldn't find any relevant crashes on the KMSAN syzbot
> > > instance, but the issue is legit.
> > > Thank you so much for fixing this!
> > > 
> > > Any chance you can add a test case for it to mm/kmsan/kmsan_test.c?
> > 
> > Unfortunately most of the KMSAN test cases already fail on upstream,
> > which makes it difficult to develop new ones:
> 
> The KMSAN test failures bisect to the following commit:
> 
>     commit f90b474a35744b5d43009e4fab232e74a3024cae
>     Author: Vlastimil Babka <vbabka@suse.cz>
>     Date:   Mon Mar 10 13:40:17 2025 +0100
> 
>         mm: Fix the flipped condition in gfpflags_allow_spinning()
> 
> I'm not sure why.  Apparently something related to lib/stackdepot.c.
> 
> Reverting that commit on top of upstream fixes the KMSAN tests.
> 

Rolling back all the BPF (?) related changes that were made to
lib/stackdepot.c in v6.15 fixes this too.  Looks like there was a
regression where stack traces stopped being saved in some cases.

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index de0b0025af2b9..99e374d35b61d 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -638,12 +638,11 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 	struct list_head *bucket;
 	struct stack_record *found = NULL;
 	depot_stack_handle_t handle = 0;
 	struct page *page = NULL;
 	void *prealloc = NULL;
-	bool allow_spin = gfpflags_allow_spinning(alloc_flags);
-	bool can_alloc = (depot_flags & STACK_DEPOT_FLAG_CAN_ALLOC) && allow_spin;
+	bool can_alloc = depot_flags & STACK_DEPOT_FLAG_CAN_ALLOC;
 	unsigned long flags;
 	u32 hash;
 
 	if (WARN_ON(depot_flags & ~STACK_DEPOT_FLAGS_MASK))
 		return 0;
@@ -678,11 +677,11 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 				   DEPOT_POOL_ORDER);
 		if (page)
 			prealloc = page_address(page);
 	}
 
-	if (in_nmi() || !allow_spin) {
+	if (in_nmi()) {
 		/* We can never allocate in NMI context. */
 		WARN_ON_ONCE(can_alloc);
 		/* Best effort; bail if we fail to take the lock. */
 		if (!raw_spin_trylock_irqsave(&pool_lock, flags))
 			goto exit;
@@ -719,14 +718,11 @@ depot_stack_handle_t stack_depot_save_flags(unsigned long *entries,
 	printk_deferred_exit();
 	raw_spin_unlock_irqrestore(&pool_lock, flags);
 exit:
 	if (prealloc) {
 		/* Stack depot didn't use this memory, free it. */
-		if (!allow_spin)
-			free_pages_nolock(virt_to_page(prealloc), DEPOT_POOL_ORDER);
-		else
-			free_pages((unsigned long)prealloc, DEPOT_POOL_ORDER);
+		free_pages((unsigned long)prealloc, DEPOT_POOL_ORDER);
 	}
 	if (found)
 		handle = found->handle.handle;
 	return handle;
 }
