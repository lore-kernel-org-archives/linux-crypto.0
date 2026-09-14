Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA1B47A872
	for <linux-crypto@vger.kernel.org>; Mon, 14 Sep 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789397709; cv=none; b=HViDiyTojmarhXUON6bW3VhJcgvepq9xKnM9OeaSO2RWUxV9tX5eHOxKYei1RTq22U6W2+F1lw2zdq1qoKVEAcTAKosoACx/hzs40xzSNTGRg6qx9lv4y/RQUjf+pVUz/uCzsWN7hBGsEo30w5yvvC0o/uE5V12MAUkI4tl/dDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789397709; c=relaxed/simple;
	bh=UX9s3118GyqJUsOLinQmCVkOJm0Uag2TmAVVMPw1YQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hctz2CA2AvGxn6moz0BGS/kI0LUhi62CovQPnYqGimrXXN+bRSjPiB+MLTO3KUSllAU3o999CsNmOqCB1qwIYLifU84BNQmB27VVg4Vl3NwRTR6mvMr4/Vm1fdD8e5Yg9/PQrlJevKm5OV/l1C7O7wp8SSh4GB0cVx82bzuU+NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BD35C60460; Mon, 14 Sep 2026 16:55:04 +0200 (CEST)
Date: Mon, 14 Sep 2026 16:54:58 +0200
From: Florian Westphal <fw@strlen.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kadlec@netfilter.org, linux-crypto@vger.kernel.org
Subject: Re: [v5 PATCH] rhashtable: Add rhashtable_flush_and_free helper
Message-ID: <aqgKwiRQ5oz-Mwc-@strlen.de>
References: <aqUmlWEzhR3pKYuP@gondor.apana.org.au>
 <aqWazNYddvTO5Sjn@strlen.de>
 <aqXf46iXp4BhuPud@gondor.apana.org.au>
 <aqXqftkCP3Jv1CXK@gondor.apana.org.au>
 <aqX9l6vIJdzBSiUE@gondor.apana.org.au>
 <aqYQJlrjbxEgp4Y4@gondor.apana.org.au>
 <aqfJgFY73ZYtFJmH@strlen.de>
 <aqfPeIDmYPI8-ZTb@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqfPeIDmYPI8-ZTb@gondor.apana.org.au>

Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Sep 14, 2026 at 12:16:32PM +0200, Florian Westphal wrote:
> >
> > Thanks, I rebased the ipset rhashtable conversion patches
> > on top of this; all tests pass.
> 
> Please take this patch via your series as I don't to add features
> to the kernel without a user.

Will do, thanks!  One minor nit:
rhashtable_rehash_table() has a comment that still referts to
rcu_head_after_call_rcu.

Are you OK with this small change?

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 63129a8e223b..511383708e19 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -358,8 +358,8 @@ static int rhashtable_rehash_table(struct rhashtable *ht)
         * table, and thus no references to the old table will
         * remain.
         * We do this inside the locked region so that
-        * rhashtable_walk_stop() can use rcu_head_after_call_rcu()
-        * to check if it should not re-link the table.
+        * rhashtable_walk_stop() can check tbl->dying before it
+        * re-links the table.
         */

I can mangle this locally here.

> > > Once rehashes are completely gone, ht->nelems is reset to zero,
> > > and the new table is installed.
> > 
> > Wrt. to this, you could do:
> 
> The problem with this is that during the flush, nelems will be out
> of whack with reality which will cause rhashtable to do grow the
> hashtable unnecessarily, followed by a sudden shrinking.

Right, lets go with rejecting insertions then.
