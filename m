Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D195F346AFC
	for <linux-crypto@vger.kernel.org>; Wed,  4 Feb 2026 18:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770230954; cv=none; b=m0+83BUvC8rZyCZvWSZR6L0goADYZpiQY4rm4q1IgFsJIQENH/33hC4RuUci9lMuDOCl876kwTTwCz9i/acp1sY1H0syeqFLRpmQU/1+ytGNpwLdOeGkKUh4spYg3J/R5Ezt6J9O6fFQzQVeyokFrLhmQac28PvDdppqbslBWb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770230954; c=relaxed/simple;
	bh=wHmgQNyyQ6Upj7+JL6XWZvMhw+BPZdGY1PtM6MdtoLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j7qQzu97hjYmskT2GMT2Q2El7/Bqx3D4tUXcuNPK6QJK11BRwW1s6odMx42GufedXvExxV2PtS9bBllkMrWMp07symYIOj3XUC8UuWEsTHnf99iU8NIxP/dVv+6m80zQXHRG31rh+484kFPrCfrLcuTCwl0GBDei1i8X/mnAVgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f08uPGd4; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f08uPGd4"
Date: Wed, 4 Feb 2026 18:49:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770230951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjfPZJeH7W0tyAXZccSBDr1Jf1dziT02Ti4YrzFlQYU=;
	b=f08uPGd4dcaI3FVK/d4pK+H/sXu3Cy1o6tN2X3Jv/bLQZPLxnfe30kY04FmoujhNo8zhyg
	5C6SnreLJmlMRZwqVLOpt4wNi5Fv50DhO4hspcVeKL5iPA+KUON7lBL7N8GRuRhP5sMntA
	xmuMc0qU/GH37vB32p0qNXHVwiF2jvo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com, 
	ying.huang@linux.alibaba.com, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 00/26] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <t6n4qhqpexui7gfzkdw6r4ai3pztt7qg45fc5hjg3qydodp77n@oh5k6pzpyjwa>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <nlsqmn3x56ug7vfxw3vmpsmlyc6sie2plr22hpu7q6j7jq3adx@jbgg7sza67mv>
 <20260204103925.fd15632afc3bccc0ea8f500d@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204103925.fd15632afc3bccc0ea8f500d@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 04, 2026 at 10:39:25AM -0800, Andrew Morton wrote:
> On Wed, 4 Feb 2026 18:21:43 +0000 Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> 
> > On Sat, Jan 24, 2026 at 07:35:11PM -0800, Kanchana P Sridhar wrote:
> > [..] 
> > 
> > I think this series is really hard to move and respin in its current
> > form.
> > 
> > Herbert, could we take in the crypto patches separately (if they are
> > ready)? Not sure if it's better to take them through the crypto tree
> > (and provide a tag for Andrew?), or through the mm tree.
> 
> Keeping everything in the same tree is of course simpler.
> 
> > But either way,
> > most review is on the later zswap patches and respinning all these
> > crypto patch every time is a pain.
> 
> It's mainly a crypto patchset by linecount:
> 
> :  .../driver-api/crypto/iaa/iaa-crypto.rst      |  168 +-
> :  crypto/acompress.c                            |  110 +-
> :  crypto/testmgr.c                              |   10 +
> :  crypto/testmgr.h                              |   74 +
> :  drivers/crypto/intel/iaa/Makefile             |    4 +-
> :  drivers/crypto/intel/iaa/iaa_crypto.h         |   95 +-
> :  .../intel/iaa/iaa_crypto_comp_dynamic.c       |   22 +
> :  drivers/crypto/intel/iaa/iaa_crypto_main.c    | 2926 ++++++++++++-----
> :  drivers/crypto/intel/iaa/iaa_crypto_stats.c   |    8 +
> :  drivers/crypto/intel/iaa/iaa_crypto_stats.h   |    2 +
> :  include/crypto/acompress.h                    |   68 +
> :  include/crypto/algapi.h                       |    5 +
> :  include/crypto/internal/acompress.h           |   15 +
> :  include/linux/crypto.h                        |    3 +
> :  mm/zswap.c                                    |  724 ++--
> :  15 files changed, 3144 insertions(+), 1090 deletions(-)
> :  create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
> 
> So I expect it'll work to take all this into the crypto tree.

Herbert, are the crypto patches ready to be picked up? If yes, could you
please pick them, then we can figure out how to route the dependent
zswap patches based on the timeline?

> 
> > >   mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
> > >   mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
> > >     resources.
> > 
> > Andrew, I think this two zswap patches are in good shape, and are
> > standalone improvements. Do they apply to mm-unstable? Could we take
> > them in separately to lighten the load of respinning this?
> 
> "mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool" throws a few
> rejects.
> 
> "mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
> resources" also throws rejects when applied standalone.

Kanchana, could you please respin these 2 changes, and a new change to
store the nid in the zswap_entry, and send them out separately?

We can land them separate from the rest of the series to accelerate
things.
