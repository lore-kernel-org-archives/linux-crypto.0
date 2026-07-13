Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8ACE35C19B;
	Mon, 13 Jul 2026 05:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783919924; cv=none; b=OsxefgqdBcvYSgND8Rm8eUOAjCFSFFIU2djJQkkKZoMVdSYljdAiUJynmysrjVulxX1iW5ez2NtdCciKCiy0J68CzcineP8ZAXkolbIB+sTa74bgr4Zv6Vp1V1UH2Kw5lwI8JdPusHfYhXS8uK0yjXxi+IqQ0j/SUFdyqMAJlao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783919924; c=relaxed/simple;
	bh=4fwXoZadB/hIQjBRRzXdNKpYHZkGLpFc6Etmmhb/2DI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PO/IkZjAj0IC+G/AWs829/LHuR4tkgob5eRsBHN1lJxkVwR/w9YO6v4VMC6n+2IKlytM88uOzfzK9Qx7R6Qkh1FsB7GRzIzNYTypFoImr+KCnGTIewiAsLN0lTI77UlTyqXfCkQbIGNQODCxRhnj+oBsfcUGslK0pelV4QD3ziE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=O9GvKxEY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="O9GvKxEY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fYZz6TfHnUdNxCual9jQ9UNrmQt8A02dTTjENI4uzkU=; 
	b=O9GvKxEYcBO52O4lj4Tsc2114cqHMztOaNF6LpLvU+j30E65rNJI1SX41q1CqQA7bsV2/Ux2rXX
	PkCsgSzJnUk52eP6AAM4XXnxMQaIcifPYYPjJO9hVBzSi4HrMUsJA8RoVj0g1ZGwG/LrXrFWI9UYJ
	PA01K6dLwjkvSZ7Icaek6NSMe8jhJpfzsOuA3X9zU2fJOGkBRTYcE7r7am4um/RBNLgtpUEM60a0Y
	9mJQfKNGzd9ujwb2QYVHnmg7nbLXlKb7HsxJSYB0ZeSg7d8vxeefkvsnQZt1qenutM88G7MS5v9no
	VNNDPFlH+2mqm6ssdKS3YPUd2IM40ike5tWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj93u-0000000Cyz5-38Ef;
	Mon, 13 Jul 2026 13:18:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 15:18:38 +1000
Date: Mon, 13 Jul 2026 15:18:38 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
Cc: tgraf@suug.ch, akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com, kys@microsoft.com
Subject: Re: [PATCH v3] lib/rhashtable: clear stale iter->p on table restart
Message-ID: <alR1LokGnmW-qTMm@gondor.apana.org.au>
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
> 
> Any caller that does multi-fragment rhashtable walks across
> walk_stop/walk_start boundaries is affected.  Concrete cases include
> netlink_diag (__netlink_diag_dump in net/netlink/diag.c) and TIPC
> (tipc_nl_sk_walk in net/tipc/socket.c).
> 
> Crash stack (netlink_diag):
>   BUG: KASAN: slab-use-after-free in rhashtable_walk_next+0x365/0x3c0
>   Read of size 8 at addr ffff88801a9d2438 (freed kmalloc-2k, offset 1080)
>   Call Trace:
>    rhashtable_walk_next+0x365/0x3c0 (lib/rhashtable.c:1016)
>    __netlink_diag_dump+0x160/0x760 (net/netlink/diag.c:122)
>    netlink_diag_dump+0xc2/0x240
>    netlink_dump+0x5bc/0x1270
>    netlink_recvmsg+0x7a3/0x980
>    sock_recvmsg+0x1bc/0x200
>    __sys_recvfrom+0x1d4/0x2c0
> 
> Fixes: 5d240a8936f6 ("rhashtable: improve rhashtable_walk stability when
> stop/start used.")
> Reported-by: AutonomousCodeSecurity@microsoft.com
> Closes: https://lore.kernel.org/linux-crypto/CAB8m9Wh559e+=n8z51gB8DrbEyCc2mc0MgGjrRR6_VXBmU=2AQ@mail.gmail.com
> Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
> ---
> v3: Solved patch format issue
> v2: Fix commit subject in Fixes tag
> Link: https://lore.kernel.org/linux-crypto/CAB8m9Wh559e+=n8z51gB8DrbEyCc2mc0MgGjrRR6_VXBmU=2AQ@mail.gmail.com
> 
>  lib/rhashtable.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
