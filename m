Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3617F3A784A;
	Mon, 27 Apr 2026 12:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292477; cv=none; b=ko0CQG8kkaXS+IXoHnkRnp1XgVy+vRZFjuvAbNCkninjzBvAj0ijhAy51pdCLNv7dL2gYy6qDLaAInGXl9gnLu8uJkmzgGu+vr7mpZ2DrHrZx1rwDU1YyGQB0ZwAHBvIsgTG+rW8UGa+MEaevZr7239X8xH1Nz3frU4JyKcOWJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292477; c=relaxed/simple;
	bh=y5YbLZwgt5tGfMeBdX7DbB1fAcNv5JOlbmjt5fbiW8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VpNoTkbuvpk9ZFu8ozHIzhjPWT5v7rSG9Bt6W0mfVL6JwZrQGv54B9wcr8fHuiQP6utku/yqHsjZ8Xp/X4ENc/crD9QEpy8lvqVk9U+Du2tiMhJtUQM7vTNQCvrtD/Ix7g8odab33RTwSSg4DnukjA8Uvao7UFLKFrI8vqVbOus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RscBaywc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RscBaywc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF84C19425;
	Mon, 27 Apr 2026 12:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777292477;
	bh=y5YbLZwgt5tGfMeBdX7DbB1fAcNv5JOlbmjt5fbiW8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RscBaywcFhwoI3SqDyzrigx+bPwRL4F6kV1gY7DSITn7AFSvt/XrXV9jwgFBMmfma
	 l7QsGrNpDg/2TqwSm8SaY5BPQDb5DXHP0Fmo461xxj9R/kycEznf2AqDxoL/OqlRCE
	 Ki4cDJipE+/Lz4ezngsXUthKafX+XMzveZM3Xx0hZIjXlUwtMXfIWrz91FRyODKRfP
	 RiCdz6kaME6KLLcia+I1KwgxGdsieiSYwd84Rge2TqMFb/J2WCiprpOGphi8tZkjtq
	 VtDOKaJARCp2y0VReMYF906QaVSy+BGMZNvp8ZZNKps7Gk8KJa60XxCotrq8+wOgq0
	 vDA61Tu0ebQGg==
Date: Mon, 27 Apr 2026 14:21:10 +0200
From: Christian Brauner <brauner@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com, 
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>, 
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] rhashtable: give each instance its own lockdep class
Message-ID: <20260427-ledig-urform-4719da0a06d2@brauner>
References: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
 <ae9ItoKFvB12Qimn@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ae9ItoKFvB12Qimn@gondor.apana.org.au>

On Mon, Apr 27, 2026 at 07:29:58PM +0800, Herbert Xu wrote:
> On Mon, Apr 27, 2026 at 01:09:57PM +0200, Christian Brauner wrote:
> > syzbot reported a possible circular locking dependency between
> > &ht->mutex and fs_reclaim:
> > 
> >   CPU0 (kswapd0)                    CPU1 (kworker)
> >   --------------                    --------------
> >   fs_reclaim                        ht->mutex
> >     shmem_evict_inode                 rhashtable_rehash_alloc
> >       simple_xattrs_free                bucket_table_alloc(GFP_KERNEL)
> >         rhashtable_free_and_destroy       __kvmalloc_node
> >           mutex_lock(&ht->mutex)            might_alloc -> fs_reclaim
> > 
> > The two halves of the splat refer to two different events on
> > &ht->mutex.
> > 
> > The kswapd0 path is unambiguous: shmem_evict_inode at mm/shmem.c:1429
> > calls simple_xattrs_free(), which calls rhashtable_free_and_destroy()
> > on the per-inode simple_xattrs rhashtable being torn down with the
> > inode.
> > 
> > The previously-recorded ht->mutex -> fs_reclaim edge comes from
> > rht_deferred_worker -> rhashtable_rehash_alloc ->
> > bucket_table_alloc(GFP_KERNEL) -> __kvmalloc_node ->
> > might_alloc -> fs_reclaim. That stack stops at generic library code:
> > there is no subsystem-specific frame above rht_deferred_worker, so
> > the splat does not identify which rhashtable's worker recorded the
> > edge -- only that some rhashtable in the system did.
> > 
> > Whether or not that recording happened on the same simple_xattrs ht
> > that is now being destroyed, the predicted deadlock cannot occur:
> > rhashtable_free_and_destroy() does cancel_work_sync(&ht->run_work)
> > before taking ht->mutex, so the deferred worker cannot be running on
> > the instance being torn down. If the recording was on a different
> > rhashtable instance, the two ht->mutex acquisitions are on distinct
> > mutex objects and cannot deadlock either.
> > 
> > Lockdep flags a cycle regardless because mutex_init(&ht->mutex) lives
> > on a single source line in rhashtable_init_noprof(), so every
> > ht->mutex in the kernel shares one static lockdep class. Lockdep
> > matches by class, not by instance, and collapses all of these into
> > one node.
> > 
> > Lift the lockdep key out of rhashtable_init_noprof() and into the
> > caller. The user-visible rhashtable_init_noprof() /
> > rhltable_init_noprof() identifiers become macros that declare a
> > per-call-site static lock_class_key.
> > 
> > Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/69e798fe.050a0220.24bfd3.0032.GAE@google.com
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> > ---
> >  include/linux/rhashtable-types.h | 22 ++++++++++++++++++----
> >  lib/rhashtable.c                 | 17 ++++++++++-------
> >  2 files changed, 28 insertions(+), 11 deletions(-)
> 
> Thanks for the patch.
> 
> But could you please try this patch and see if it also fixes
> your problem?
> 
> https://patchwork.kernel.org/project/linux-crypto/patch/20260422213349.1345098-2-mikhail.v.gavrilov@gmail.com/

Possibly, I don't have a way to easily reproduce this though.
Imho, the right thing would be to have both: actual useful keyed lockdep
annotation and - if safe - dropping the mutex.
