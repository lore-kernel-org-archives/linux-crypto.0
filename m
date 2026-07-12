Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F8B17C203;
	Sun, 12 Jul 2026 03:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783825375; cv=none; b=Hzl3nzNmv28ijWsRDmmlK+EXxEWcGF5HFYls21MKpYUkNcWOyzPrN8BnVcLTDioV/t/wBmopMm8YXNFroF7uKn3dJUFk+1E56G2xQGbcli8yeKn/6YgEu6ERow/mq8X/DtzzB/cSOgrdKOWpnBTH1ULujW9Chk+8KHJb375wAIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783825375; c=relaxed/simple;
	bh=DOR0ni7bbfAXQwbOUWpkehrUfd6sxGsr17SmA2tr3LM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eg1XtGLr7i3gMFGn1CaxdjCoSg4jG3fdRQ2oKMN2F0Kj8LyM5c098TVcf5V+DhEdaqDYiB4F2ixdoCZW+/P/Ir1B6QSFeHm8mABEyoE6Oqg+PGmcFHrLe60LrhZsJTA3yVQvPx/eBNK8/Yp/5KLHxkNQNoL1BlNyNrpXj31RyRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=O+bt4UU8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="O+bt4UU8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IGjzba5R0fPfNAYmwgs2ccd2zCCepjFwAJcMABMNhjM=; 
	b=O+bt4UU8ISQOPLom94qxJjvSLJJ5wjmCwJMj3ppiJehc04bSFYIEcYHO7NpRL7nH5LbnZYcon3a
	CMg8eQV9xTwMP9YdzemuS32v+9FVaOmvXPvCbHkuA5CezNuncLheJyIq0KSHqsKYNYfJ0ba9o+8st
	aelLXzfZQhs1VXp+vn8Lan/DsCCcRlKv5eA/Hk4v5fl4pXoe4Y8rET6J39nqGG0fRTO41pqSsjQpk
	On0KCNb4g9zaQKr5HWXUeVlwRoacD6dsgtmNVDlwhEdqa818451L0zS/pHU/q9MTPjxy6YFeBlpUj
	PSYWDl4BQxSDl50j4OwFi6cxEQpg42jTpy5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wikSk-0000000Cm3O-2wIM;
	Sun, 12 Jul 2026 11:02:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Jul 2026 11:02:38 +0800
Date: Sun, 12 Jul 2026 11:02:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
Cc: tgraf@suug.ch, akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com, kys@microsoft.com,
	Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v3] lib/rhashtable: clear stale iter->p on table restart
Message-ID: <alMDzpDrUzdB8e0r@gondor.apana.org.au>
References: <20260707164115.4979-1-blbllhy@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707164115.4979-1-blbllhy@gmail.com>

On Tue, Jul 07, 2026 at 12:41:15PM -0400, Cen Zhang (Microsoft) wrote:
> rhashtable_walk_start_check() has two restart paths when resuming a walk.
> When iter->walker.tbl is valid, it re-validates iter->p against the table
> and sets iter->p = NULL if the object is gone.  When iter->walker.tbl is
> NULL (table was freed during resize), it resets slot and skip but forgets
> to clear iter->p.
> 
> rhashtable_walk_next() then dereferences the stale iter->p, reading
> freed memory.  This is a use-after-free.

Maybe I'm misreading the original patch (in the Fixes header).  But
it seems the whole point of having it is to look for iter->p in the
new table.  Even if the hash table remains the same iter->p could have
been freed since we hold no reference to that object.

If that is the case, then resetting iter->p on a resize doesn't
fix this at all since the root cause is that iter->p is being
held with no reference.

I think we should just revert the original patch since the whole
concept doesn't seem to work (although it's salvageable for the
non-rhlist case).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
