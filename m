Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B25A232395;
	Wed,  4 Feb 2026 18:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770230367; cv=none; b=muMYQ7nqiR6TIGwczs+4IHMgEwGatlsOEnRdtU9UwYD7nwXGfT0bqdhVAGOpDphM/ApmyjleQEpDkflVoeSmJCYK+oQUb6WAZYMmUwfs8+9bzM2N8lQ+dmlDmnUqvs/LqrFivnecjrZ4KiFROLZQjYQ1igbASvQBJo6jMiwTLr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770230367; c=relaxed/simple;
	bh=eFXYiDyxDYUB6JOD3ot86OdVYBZMkI+eBQk1Lhhu8j0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=F1yQ+2JdyexXH05+eKz4f0yewIsOozeaJDjtQF4YT+iCJZ7idqZElqZALurwuQa+YPfa3Z35zRWmIq6Njw6L2auaBeSZ6IJ1zjg1+87BOAoD2SA1CaBoDM0a+97UaENN3LOlQu3MfN8Mi/W/fyAa9Yo5HhE4ljpB7XT8bDioSSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AzM9PswD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AzM9PswD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DD6C4CEF7;
	Wed,  4 Feb 2026 18:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770230366;
	bh=eFXYiDyxDYUB6JOD3ot86OdVYBZMkI+eBQk1Lhhu8j0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AzM9PswDjHjAkz6T3vFt6SICBKgk1v3X79cQxFG2JfNH7S3cJ0qF0dSeWeX4nivZ2
	 oCZLVVdapJSCo/6JBadydcJmh4dGPbDG2QBn3B+tm7M6ICdB5K0obuE8vav74gOtks
	 7Q696AonpWUAL13woaegLufSvCP6eUplcqQ8b414=
Date: Wed, 4 Feb 2026 10:39:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
 nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
 ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com,
 senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
 linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
 ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
 vinicius.gomes@intel.com, giovanni.cabiddu@intel.com,
 wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 00/26] zswap compression batching with optimized
 iaa_crypto driver
Message-Id: <20260204103925.fd15632afc3bccc0ea8f500d@linux-foundation.org>
In-Reply-To: <nlsqmn3x56ug7vfxw3vmpsmlyc6sie2plr22hpu7q6j7jq3adx@jbgg7sza67mv>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
	<nlsqmn3x56ug7vfxw3vmpsmlyc6sie2plr22hpu7q6j7jq3adx@jbgg7sza67mv>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 4 Feb 2026 18:21:43 +0000 Yosry Ahmed <yosry.ahmed@linux.dev> wrote:

> On Sat, Jan 24, 2026 at 07:35:11PM -0800, Kanchana P Sridhar wrote:
> [..] 
> 
> I think this series is really hard to move and respin in its current
> form.
> 
> Herbert, could we take in the crypto patches separately (if they are
> ready)? Not sure if it's better to take them through the crypto tree
> (and provide a tag for Andrew?), or through the mm tree.

Keeping everything in the same tree is of course simpler.

> But either way,
> most review is on the later zswap patches and respinning all these
> crypto patch every time is a pain.

It's mainly a crypto patchset by linecount:

:  .../driver-api/crypto/iaa/iaa-crypto.rst      |  168 +-
:  crypto/acompress.c                            |  110 +-
:  crypto/testmgr.c                              |   10 +
:  crypto/testmgr.h                              |   74 +
:  drivers/crypto/intel/iaa/Makefile             |    4 +-
:  drivers/crypto/intel/iaa/iaa_crypto.h         |   95 +-
:  .../intel/iaa/iaa_crypto_comp_dynamic.c       |   22 +
:  drivers/crypto/intel/iaa/iaa_crypto_main.c    | 2926 ++++++++++++-----
:  drivers/crypto/intel/iaa/iaa_crypto_stats.c   |    8 +
:  drivers/crypto/intel/iaa/iaa_crypto_stats.h   |    2 +
:  include/crypto/acompress.h                    |   68 +
:  include/crypto/algapi.h                       |    5 +
:  include/crypto/internal/acompress.h           |   15 +
:  include/linux/crypto.h                        |    3 +
:  mm/zswap.c                                    |  724 ++--
:  15 files changed, 3144 insertions(+), 1090 deletions(-)
:  create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c

So I expect it'll work to take all this into the crypto tree.

> >   mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
> >   mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
> >     resources.
> 
> Andrew, I think this two zswap patches are in good shape, and are
> standalone improvements. Do they apply to mm-unstable? Could we take
> them in separately to lighten the load of respinning this?

"mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool" throws a few
rejects.

"mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
resources" also throws rejects when applied standalone.


