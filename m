Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB49F3BD22B;
	Mon, 27 Apr 2026 11:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777289421; cv=none; b=rgISK43G/bYewx5P5GwTbUFJRrFvAOpTvZ+hIVJFdcOsuteIdIAQAzCBVwFcL0SCeglcKmz0M1Ps6xlo8ByYVIsNePyXGos7qofPqbB36OPNWJlE/+Dx6NxQX/EtFRj8Un6FCiF3aj3dsubR7fETsVnf4d35Ea8H8qGH0NJAxzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777289421; c=relaxed/simple;
	bh=6uWPIxn7ztPLQR2vzfpBGcaoSWohqiLdJEyU5wHeWIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hIpDkpW1ALXLiUSOn/YlWboml9UGOmhvot+RzyYM4mS+GXnxEwUlbzjmpXAITIE66C1tllWfVx1a3QBIYnYlT7H6YN587d1yvVnxazCRJ42aHOpcGoXro2dOyMPCM5U7ffS9qflHWSnY5K2saaVLhDu2SvEVaOFLii4+fuyENtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AAiSRxe+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AAiSRxe+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qafNQ0xEOY5qhlm+wLT4AEic9YBI56O7zFUIfvV0p/E=; 
	b=AAiSRxe+Slb3G7C+CaAuCw0FXEVNvwsBQ5tm+1rxXjTmJezECU9MP+te1CnAd7PwvYGN3H1ZPEO
	d8M6OBgz+KeYafzYp8kC1xPZZ/+UBkxcG14qFJc3ekbqnoiiCt8lbT1q6s+tJ0VFy+W9LcjZLcrMY
	sRV6aAtnbjcvcYxmI882TVG8T/c9UMPgSYYb9lUukuL4vILYND3Z0oSaUIJ9buLtGhnrvH85Es/Lt
	qWv2HYZfGrqE5uLkt5lFjDUD5PDd4sljV7TcfHkBqf57DgNrwtXcV8Xr75pgtcODOorrAP0IOdxqq
	4frAdohppS82LZeOpi1g/pqi+4V3H4piRsig==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wHKA2-00993v-0I;
	Mon, 27 Apr 2026 19:29:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Apr 2026 19:29:58 +0800
Date: Mon, 27 Apr 2026 19:29:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Brauner <brauner@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] rhashtable: give each instance its own lockdep class
Message-ID: <ae9ItoKFvB12Qimn@gondor.apana.org.au>
References: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427-work-rhashtable-lockdep-v1-1-f69e8bd91cb2@kernel.org>

On Mon, Apr 27, 2026 at 01:09:57PM +0200, Christian Brauner wrote:
> syzbot reported a possible circular locking dependency between
> &ht->mutex and fs_reclaim:
> 
>   CPU0 (kswapd0)                    CPU1 (kworker)
>   --------------                    --------------
>   fs_reclaim                        ht->mutex
>     shmem_evict_inode                 rhashtable_rehash_alloc
>       simple_xattrs_free                bucket_table_alloc(GFP_KERNEL)
>         rhashtable_free_and_destroy       __kvmalloc_node
>           mutex_lock(&ht->mutex)            might_alloc -> fs_reclaim
> 
> The two halves of the splat refer to two different events on
> &ht->mutex.
> 
> The kswapd0 path is unambiguous: shmem_evict_inode at mm/shmem.c:1429
> calls simple_xattrs_free(), which calls rhashtable_free_and_destroy()
> on the per-inode simple_xattrs rhashtable being torn down with the
> inode.
> 
> The previously-recorded ht->mutex -> fs_reclaim edge comes from
> rht_deferred_worker -> rhashtable_rehash_alloc ->
> bucket_table_alloc(GFP_KERNEL) -> __kvmalloc_node ->
> might_alloc -> fs_reclaim. That stack stops at generic library code:
> there is no subsystem-specific frame above rht_deferred_worker, so
> the splat does not identify which rhashtable's worker recorded the
> edge -- only that some rhashtable in the system did.
> 
> Whether or not that recording happened on the same simple_xattrs ht
> that is now being destroyed, the predicted deadlock cannot occur:
> rhashtable_free_and_destroy() does cancel_work_sync(&ht->run_work)
> before taking ht->mutex, so the deferred worker cannot be running on
> the instance being torn down. If the recording was on a different
> rhashtable instance, the two ht->mutex acquisitions are on distinct
> mutex objects and cannot deadlock either.
> 
> Lockdep flags a cycle regardless because mutex_init(&ht->mutex) lives
> on a single source line in rhashtable_init_noprof(), so every
> ht->mutex in the kernel shares one static lockdep class. Lockdep
> matches by class, not by instance, and collapses all of these into
> one node.
> 
> Lift the lockdep key out of rhashtable_init_noprof() and into the
> caller. The user-visible rhashtable_init_noprof() /
> rhltable_init_noprof() identifiers become macros that declare a
> per-call-site static lock_class_key.
> 
> Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/69e798fe.050a0220.24bfd3.0032.GAE@google.com
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  include/linux/rhashtable-types.h | 22 ++++++++++++++++++----
>  lib/rhashtable.c                 | 17 ++++++++++-------
>  2 files changed, 28 insertions(+), 11 deletions(-)

Thanks for the patch.

But could you please try this patch and see if it also fixes
your problem?

https://patchwork.kernel.org/project/linux-crypto/patch/20260422213349.1345098-2-mikhail.v.gavrilov@gmail.com/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
