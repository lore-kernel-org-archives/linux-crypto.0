Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0513647CA60
	for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2026 18:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237978; cv=none; b=BsCwBIV55vGAYi3kKkVWpVoKXo48cLNnRo1mr/Nr1kxyWFKZeIsCgGr8wP3oa3YlIJWuEl+3/eQZWImSAc2FA/DjJwCfugwFC4oETNRsKfD03FvzQb5pWC5aZ5FjRNqF0Qpq8ZB8vr7YJPWdvP4opQ3Z0a6TRjyhZZl5wVCVdnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237978; c=relaxed/simple;
	bh=yCdDdZ1nOCl+3Vkvo5RC/C0R7QieddoPbUQTZOQw5X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XIybNOVHdSs4Le76ICjcSpUKgPXinNkELLwdLvw9Pf6QIzVg7+go7YpDOepc4hUGPanXN3LTlseojg3iLhIqXNGVtwiVSWYs8xrmV2nad9VYPjM7U8PbNxrD0LlseSYYRLBLmdn4wHBkv29b6kcg5mUzxpiS1R+69T2wiMzk46c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 40AA3602A9; Sat, 12 Sep 2026 20:32:48 +0200 (CEST)
Date: Sat, 12 Sep 2026 20:32:44 +0200
From: Florian Westphal <fw@strlen.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kadlec@netfilter.org, linux-crypto@vger.kernel.org
Subject: Re: [v2 PATCH] rhashtable: Add rhashtable_flush_and_free helper
Message-ID: <aqWazNYddvTO5Sjn@strlen.de>
References: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> This patch adds the helper rhashtable_flush_and_free and its
> rhltable counter-part.  The intended user is netfilter:
> 
> https://sashiko.dev/#/patchset/20260828152256.8759-1-fw%40strlen.de

Thanks for working on this.

> The hash table will briefly become NULL during the flush call,
> in order to avoid race conditions against concurrent insertions
> and removals which may schedule new rehashes.

When you send next version, could you elaborate a bit why this is
required?  rht_deferred_worker grabs the ht mutex, so I don't understand
this problem.  Worst case is a single,
"useless" rehash of a most likely empty (or at least mostly empty) table.

I don't see why the

mutex_lock(&ht->mutex);
old_tbl = rcu_replace_pointer(ht->tbl, new_tbl, lockdep_rht_mutex_is_held(ht));

is bad.  It avoids the NULL checks and concurrent insertions will work.

From your previous comments, there are two cases:

1. rehash gets queued, then flush was called (before worker runs).
   This result in a "useless" rehash of a mostly empty table, but
   I don't see the problem with this (flushes are rare).

2. flush -> table replaced with empty one; *then* a rehash gets queued
   (e.g. because of parallel mass insert into the new, now
    not-so-empty-anymore table).

In this second case, the behaviour is the same as if no flush would
have happened.

-EBUSY is always possible regardless of a flush happening or not. Also,
a possible "wrong" -EBUSY is certainly better than guaranteed
-EBUSY during the synchronize_rcu() call?

That said, if it is really needed then this "guarenteed -EBUSY" is fine
for my use case: for insertions from kernel/(iptables -j SET target),
failure is already tolerated / acceptable, and insertions from userspace
serialize on the same netlink mutex as the flush request.
