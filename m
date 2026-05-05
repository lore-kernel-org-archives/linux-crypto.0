Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A1030E0D5;
	Tue,  5 May 2026 09:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973011; cv=none; b=D4+MEgQeR3Q7YO9RIvtf4WpTHe19UTmQwX+UQItpRiaZjSLB3UOEnz64xD4sjVciouHw7m01/5UC0Ych/BXQHl7i1OqIV5uEVWjL6jBi2IW782hfklf9M8P0qglSQHlNcsL5MCpR6VUT7o/znEOyb85a+54cu1K0wxuDn0Z0L1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973011; c=relaxed/simple;
	bh=4KJSCF0c6tOsMazIw+J2MrjxFAOLC7TRZh+4n2aaI1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s6FZ4a1fT+zsES/q7z94sOvtLe0UhVMB2uW2LrhmRsxR9v+lXA0S1MU2/yXEUbgIhuqFsMzmDvvbyN1HOBRKhWnD7aYxiGvvS0qdrPCaWBe+vxj4l/AomHUACfhmiQ6WEiQ3l1rwnqW4avI9ln9Bwf9gpId7Z1cpmj/w6xczQOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=RLroAZ8D; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="RLroAZ8D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=FDGrH/gjLCcgvh70hN6Wh/TtU/Kw9/DV2FPzC3wmGdE=; 
	b=RLroAZ8Dvxow7svdIpFTwNiMUkfZeAqdTHsLlxqFhIHDE8RQGGMWpPfVpRiLf+emqrvm+39ndq5
	cHyPVrCne6GPLp1g+9svI8oNiiOacVtm21DwE88V5cHK2KUiuUyNN6skwwmcVsEpDRfaHLcD7RFOc
	0mg6KI0hxuMqiPV5whyZiWdv1tWQq/Y3IIuJSgwvhVrTe5E39SlF4vJJvOClYPqrASut1YmJa0k4T
	81BB++CLsxkOiDGC55T2FcpIbyjE0QC7F5NhOPNqUJglb3Qxgw7sxINIS7dxWPxfUDzpqTsGc390M
	j8vjiUbCfOi+8ALyF2eH01Ui2+ix4W7KWT8g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKBzm-00BNlN-2K;
	Tue, 05 May 2026 17:23:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 17:23:14 +0800
Date: Tue, 5 May 2026 17:23:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Thomas Graf <tgraf@suug.ch>, Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/1] rhashtable: drop ht->mutex in
 rhashtable_free_and_destroy()
Message-ID: <afm3Ahuq02BSxvxy@gondor.apana.org.au>
References: <20260422213349.1345098-1-mikhail.v.gavrilov@gmail.com>
 <20260422213349.1345098-2-mikhail.v.gavrilov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422213349.1345098-2-mikhail.v.gavrilov@gmail.com>

On Thu, Apr 23, 2026 at 02:33:49AM +0500, Mikhail Gavrilov wrote:
> rhashtable_free_and_destroy() is a single-shot teardown routine:
> cancel_work_sync() has already quiesced the deferred rehash worker, and
> the function's documented contract requires the caller to guarantee no
> other concurrent access to the rhashtable. Under those conditions
> ht->mutex is not protecting anything -- taking it is a leftover from
> the original teardown path.
> 
> That leftover is actively harmful: it closes a circular lock-class
> dependency with fs_reclaim. The deferred rehash worker takes ht->mutex
> and then allocates GFP_KERNEL memory in bucket_table_alloc(),
> establishing
> 
>     &ht->mutex  ->  fs_reclaim
> 
> After commit b32c4a213698 ("xattr: add rhashtable-based simple_xattr
> infrastructure") introduced simple_xattr_ht_free(), which calls
> rhashtable_free_and_destroy(), the simple_xattrs teardown became
> reachable from evict() under the dcache shrinker. The subsequent
> per-subsystem adaptations made the reverse edge concrete in three
> independent code paths:
> 
>   * commit 52b364fed6e1 ("shmem: adapt to rhashtable-based simple_xattrs with lazy allocation")
>   * commit 5bd97f5c5f24 ("kernfs: adapt to rhashtable-based simple_xattrs with lazy allocation")
>   * commit 50704c391fbf ("pidfs: adapt to rhashtable-based simple_xattrs")
> 
> Any of the three closes the cycle
> 
>     fs_reclaim  ->  &ht->mutex
> 
> which lockdep reports as follows. This particular splat was observed
> organically on a workstation kernel built from vfs-7.1-rc1.xattr at
> ~35h uptime under normal mixed workload, with CONFIG_PROVE_LOCKING=y.
> The path happens to go through kernfs:
> 
>   WARNING: possible circular locking dependency detected
>   7.0.0-faeab166167f-with-fixes-v1+ #191 Tainted: G     U
>   kswapd0/243 is trying to acquire lock:
>   ffff8882e475c0f8 (&ht->mutex){+.+.}-{4:4},
>     at: rhashtable_free_and_destroy+0x36/0x740
>   but task is already holding lock:
>   ffffffffa8ad1d00 (fs_reclaim){+.+.}-{0:0},
>     at: balance_pgdat+0x995/0x1600
> 
>   the existing dependency chain (in reverse order) is:
> 
>   -> #1 (fs_reclaim){+.+.}-{0:0}:
>          __lock_acquire+0x506/0xbf0
>          lock_acquire.part.0+0xc7/0x280
>          fs_reclaim_acquire+0xd9/0x130
>          __kvmalloc_node_noprof+0xcd/0xb40
>          bucket_table_alloc.isra.0+0x5a/0x440
>          rhashtable_rehash_alloc+0x4e/0xd0
>          rht_deferred_worker+0x14b/0x440
>          process_one_work+0x8fd/0x16a0
>          worker_thread+0x601/0xff0
>          kthread+0x36b/0x470
>          ret_from_fork+0x5bf/0x910
>          ret_from_fork_asm+0x1a/0x30
> 
>   -> #0 (&ht->mutex){+.+.}-{4:4}:
>          check_prev_add+0xdb/0xce0
>          validate_chain+0x554/0x780
>          __lock_acquire+0x506/0xbf0
>          lock_acquire.part.0+0xc7/0x280
>          __mutex_lock+0x1b2/0x2550
>          rhashtable_free_and_destroy+0x36/0x740
>          kernfs_put.part.0+0x119/0x570
>          evict+0x3b6/0x9c0
>          __dentry_kill+0x181/0x540
>          shrink_dentry_list+0x135/0x440
>          prune_dcache_sb+0xdb/0x150
>          super_cache_scan+0x2ff/0x520
>          do_shrink_slab+0x35a/0xee0
>          shrink_slab_memcg+0x457/0x950
>          shrink_slab+0x43b/0x550
>          shrink_one+0x31a/0x6f0
>          shrink_many+0x31e/0xc80
>          shrink_node+0xeb3/0x14a0
>          balance_pgdat+0x8ed/0x1600
>          kswapd+0x2f3/0x530
>          kthread+0x36b/0x470
>          ret_from_fork+0x5bf/0x910
>          ret_from_fork_asm+0x1a/0x30
> 
>    Possible unsafe locking scenario:
> 
>          CPU0                    CPU1
>          ----                    ----
>     lock(fs_reclaim);
>                                  lock(&ht->mutex);
>                                  lock(fs_reclaim);
>     lock(&ht->mutex);
> 
> Note that lockdep tracks lock classes, not instances: the two
> &ht->mutex sites are on different rhashtable objects (the deferred
> worker was triggered by some unrelated rhashtable growth), but because
> rhashtable_init() uses a single static lockdep key for all rhashtables,
> this is a real class-level cycle. Once reported, lockdep disables
> itself for the remainder of the boot, masking any subsequent locking
> bugs.
> 
> Drop the mutex. After cancel_work_sync() the rehash worker is quiesced
> and, per this function's contract, no other concurrent access is
> possible; the tables are therefore owned exclusively by this function
> and can be walked without any lock held.
> 
> Switch the table walks from rht_dereference() (which requires
> ht->mutex to be held under CONFIG_PROVE_RCU) to rcu_dereference_raw(),
> which has no lockdep annotation. rht_ptr_exclusive() already uses
> rcu_dereference_protected(p, 1) and needs no change.
> 
> This is the only place in lib/rhashtable.c where &ht->mutex is
> acquired from a path reachable under fs_reclaim; the deferred worker
> is the only other site and it is the forward edge. Removing the
> acquisition here therefore eliminates the class cycle for all three
> subsystems that use simple_xattrs, not just the one in the splat
> above. No locking-semantics change is introduced for correct users;
> incorrect users would already be racing with rehash worker completion
> regardless of the mutex.
> 
> Synthetic reproduction of the splat within a few-minute window was
> unsuccessful across several attempts (tmpfs and kernfs zombies via
> cgroupfs with open-fd-through-rmdir, with and without swap, up to
> ~60k reclaim-path executions of simple_xattr_ht_free() in a single
> run), consistent with the rare coincidence-of-edges profile of the
> bug: the forward edge is already registered in /proc/lockdep on any
> idle system via rht_deferred_worker, but the reverse edge requires
> evict() to complete kernfs_put()'s final release inside the fs_reclaim
> critical section, which in my attempts was ordered against rather than
> interleaved with the worker.
> 
> Fixes: b32c4a213698 ("xattr: add rhashtable-based simple_xattr infrastructure")
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> ---
>  lib/rhashtable.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
