Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E002C23E334;
	Fri, 18 Sep 2026 05:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789708250; cv=none; b=gwnej90MfzN7bvDUxj3ts+GwBcsNNHqqBHfzOW3lyvctEF1ogBdlJZGr9fTezPiNXVr+WCkFPplZGy/qyd3gxuW9+mGFD0BMCaP3k/mQx2XAdNP++mdIB25D79piUmXycE2SfGOeyvtOlABBaxkQha9qN+GpRBqk/2HT5jL25bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789708250; c=relaxed/simple;
	bh=21moiKY/FBQh7xVP87M9aTah01d7JTo/e8F5cR8Qomg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=EZqXXPJRWHvj5h2sq9z0Vzx6jPTlT0lSNZIT1ptg5YZtLXMvs6NHYTbQT+p3LzLffIjbGfP1teUmJ3i8LJpUhcYIbLpDZwKFVNUliC03IygIA6dLrzK1pxas/5z1ChzH5BzpOmqwXDNwkSf2nOr8lJRH0V3PxDHSbh/5vw7Bwj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cJeZCLZm; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cJeZCLZm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=sNFtuRqhjn/xnv0qfgiTqs7G5W2xe1Y7dYd6ZZmN9XY=; b=cJeZCLZmYZ/V3g/8eq9tRY18qH
	0w+BJz1dw/sLQMuchlvLGnzJRxFvzACHsLEqfF0zMZQwaPEAmOZH4EQU6neH7g2Q9KnaALnkP2S1P
	qfNYanuKlKpsYJZSuCuVTc3E4lX/yPA6t2cX+qaRtJct/0flLJD4OZkUZtNGCbNBKDPXzgEf6TQg4
	hpWhGoFDCWr7hUqHYPwS+6WdXDrKLC83vq3yDfE4/mRgx2U+jkkFpMhpPNwqWQ9x1TAGCxstlCv3I
	nsRol3jknpG3V5pm1cl18PDG3POZJmqOTHFarG1sFuL7PGuS5XnnYu+vt0eh5ID236g/DWwO928BB
	6QOi0S2A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7Qrw-0000000FHMx-0vdU;
	Fri, 18 Sep 2026 13:10:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 15:10:40 +1000
Date: Fri, 18 Sep 2026 15:10:40 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Fan Wu <fanwu01@zju.edu.cn>
Cc: thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, fanwu01@zju.edu.cn, songl@zju.edu.cn
Subject: Re: [PATCH] crypto: ccp - Fix use-after-free in backlog cmd
 advancement
Message-ID: <aqzH0FhaluDxMZMH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907060415.575656-1-fanwu01@zju.edu.cn>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Fan Wu <fanwu01@zju.edu.cn> wrote:
> CCP_CMD_MAY_BACKLOG commands are removed from ccp->backlog by a
> queue kthread and advanced asynchronously by ccp_do_cmd_backlog().
> The promoted command is no longer on either command list.
> 
> During device removal, ccp*_destroy() stops the queue kthreads and
> flushes the lists, but does not wait for a promoted work on system_wq.
> That work can subsequently access the devm-allocated ccp_device after
> it has been released, and wake a queue kthread whose task_struct
> kthread_stop() has already released.
> 
> Use a per-device workqueue for backlog advancement and destroy it after
> stopping all queue kthreads, so every promoted work has completed before
> the command lists are flushed. The queue kthreads are the only source
> of backlog works, so no new work can be queued once they are stopped.
> Individual cancellation is not possible because a promoted command is
> no longer reachable from either list.
> 
> Mark the device as halting before teardown. A draining backlog work
> then completes its command with -ENODEV instead of re-queuing it.
> Keep the halting check and the kthread wake under cmd_lock so teardown
> cannot stop the selected kthread between them.
> 
> This issue was found by an in-house static analysis tool.
> 
> Fixes: 63b945091a07 ("crypto: ccp - CCP device driver and interface support")
> Cc: stable@vger.kernel.org
> Assisted-by: Codex:gpt-5.6
> Co-developed-by: Song Li <songl@zju.edu.cn>
> Signed-off-by: Song Li <songl@zju.edu.cn>
> Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
> ---
> drivers/crypto/ccp/ccp-dev-v3.c | 19 +++++++++++++++++++
> drivers/crypto/ccp/ccp-dev-v5.c | 18 ++++++++++++++++++
> drivers/crypto/ccp/ccp-dev.c    | 33 ++++++++++++++++++++++++++++-----
> drivers/crypto/ccp/ccp-dev.h    |  4 ++++
> 4 files changed, 69 insertions(+), 5 deletions(-)

Thanks for catching this!

The backlog handling still looks a bit wrong though.  When you detach
a backlogged request after processing a normal request, there is
a gap before the backlogged request is added to the normal queue.

In that gap new requests could have come in and taken up the space
meant for the backlogged request.

I think this should be done atomically so that there is no gap
between the two operations, to ensure that the space is actually
reserved for the backlogged entry.

Once this is done, there should be no need to have a per-backlog
work struct, which means that you don't need to add a separate
work queue.  In fact, there may not be a need for a work struct
at all since this is all running out of process context anyway.

On a higher level, this driver should probably switch over to
using crypto_engine rather than doing backlog handling manually.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
