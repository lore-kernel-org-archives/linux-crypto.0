Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168167;
	b=uaGjJPTyLzaedGHnJo1igJ+uSaVuQEcaso1/PajNS31rkNmz7Wys4JaW/G5w6dZ7lCNZ
	 5Dc3MoMdIrFxiZT+QNGgclk7nJiUB6oKNTTKGb/62jMf9vhjkGnmU/K0PDuLALg2tRLnX
	 XyKzMLEvkFVn6SvAuylbnO4GFdKKeG+EVdT3zys98r1hg2AMzaDo8U4ogT2urksyCIjJ/
	 UHSwRMgS+PRWjJODw2cccDVc0AicxJGqqd7S2ydSeCTqqWOGtHGp6Rgzzu0QH9eyOAGDu
	 hfqHk65y5Ji1iifNdsRQItgcVHC3e1biVNGtJb3Gmv7ZhXvSls5yPvJ3JvXEH6JF1qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168167;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=Ahj0CzU1hVbnWhl0n2zcJwrXID4d5ZIGphREm93F3NE=;
	b=JX804phf43UlX77criWJajsrbq3649QpkDazlXOJ9Cbb/OSb+ZSDj9BgEHRQfH/5F+y4
	 gdzXzA8U6mVOVGArDL96+YVztqqrP2a3zMRAHV6i0lRKblkO5BLrSwpKs/Alt4wLF0Jnh
	 x7zwL84Dt3nGyesfw+11vvuojaMa9Qamp0mQ9zQz4NSRkc1+cMCBC+jI0Y6qe9ws7Cqjj
	 eUmAja0LvNvChc+WqCnX3arKwiFHCQoes2liBJ1Pjc8vzYf740y4NT/DcSvfbddFML2jy
	 laYJEH99vfmJxeafBoskigbhOpQuEIysnPxjEjgucEtDFrpVNlYg/ammwkbK74ptngg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=H1WVx17U;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324F1606A326;
	Fri, 20 Nov 2026 09:49:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 324F1606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=H1WVx17U
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Ahj0CzU1hVbnWhl0n2zcJwrXID4d5ZIGphREm93F3NE=; 
	b=H1WVx17UduHJXhsqMth2XijYI7d19aD7TZi6FtWGof7pRRJ3VSEfG3vC9nTPyfz8/AuXGq7C4Kl
	YMEOhKp910Qe5OBCsN/Ku3B71lxP5JMCvFn+EvmakYHvfNrjnLvUypvTDTlZ4v193LYUU4LjfWbz+
	ILC1Pkfj6dDYc3l4bTMzZLqF0S1iG9kJ7xPW3Hi1Sq9U76HjQjefdcoq4FDMxb7UNzy7jevOWoR5S
	2oSPWvRmw5167Vo5PypkR+tsm5QYvjgszgw0kkBkSJCzCdg8B6n3zvIhnEvY0LSdl33+3y70Ehg4i
	fLC+YLtepD1gFX6QdtA7rtWdEzF6hHn5dO7A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULF1-0000000HYWQ-27Cr;
	Fri, 20 Nov 2026 17:49:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:49:11 +0800
Date: Fri, 20 Nov 2026 17:49:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tomas Paukrt <tomaspaukrt@email.cz>
Cc: "David S. Miller" <davem@davemloft.net>,
	Shawn Guo <shawnguo@kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, Marek Vasut <marex@denx.de>,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: mxs-dcp - Fix softirq locking and completion
Message-ID: <awAXl6j7tb5NNTjQ@gondor.apana.org.au>
References: <1qB.ZqMy.4DIhrOb2ZPx.1gyQAk@seznam.cz>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1qB.ZqMy.4DIhrOb2ZPx.1gyQAk@seznam.cz>

On Mon, Nov 09, 2026 at 11:38:38AM +0100, Tomas Paukrt wrote:
> The request queues are protected by plain spin_lock(), but requests are
> enqueued from softirq context (e.g. by ESP on packet receive) as well as
> from process context, while the channel threads dequeue them in process
> context with bottom halves enabled. A softirq that runs on the same CPU
> while the lock is held either deadlocks on SMP, or corrupts the queue on
> UP where the spinlock does not provide any protection.
> 
> In addition, the channel threads call the completion callbacks with
> bottom halves enabled, although the crypto API requires them to be
> called with bottom halves disabled. With IPsec, esp_input_done() then
> runs xfrm_input() and gro_cells_receive() in plain process context,
> which races with the NET_RX softirq on the per-CPU GRO cell queue and on
> the xfrm state, and defers the NAPI poll until the next interrupt.
> 
> This was observed with strongSwan on i.MX6ULL: the throughput drops
> quickly and eventually no packets are decrypted at all.
> 
> Fix this by taking the queue locks with spin_lock_bh() and by calling
> the completion callbacks with bottom halves disabled.
> 
> Fixes: 15b59e7c3733 ("crypto: mxs - Add Freescale MXS DCP driver")
> Signed-off-by: Tomas Paukrt <tomaspaukrt@email.cz>
> ---
>  drivers/crypto/mxs-dcp.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
