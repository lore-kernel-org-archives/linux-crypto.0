Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16A72BE053;
	Fri, 17 Jul 2026 08:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784276230; cv=none; b=lBGXzcD1D33KrXOUcdCjM9CXLeNUx1z2YLYc6KIAw77DzN6R3Lp1qxGmzmRf73LwewRy4ZXnNK817p4ofPlTmIMdh2MuvTA/MHxT+1sPF93Nr342ylgqQ6UIlN+dpuk4hp1OimjrcZOXqLoY07HMUMk0uuaGUoMMutTeJau3QN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784276230; c=relaxed/simple;
	bh=7zk/OTDMxQMCxjEMzOyIuIxdFCiOVw+icfbZUvJ7QSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D333oQg4bLOeh9AUkMn/fx3vEvL0UXjymfYJ512tlsC9VDQDsCI4TWpuBeOyuC+dWJQzGfSPAXa7wM7kAaDIqDqHpE9hx6gVrq5hsQKd3SycOAjzjtT+Oj6s33LMRsS4I2Sh87LFJ5+Q8RchAJlFWvpc8bDZOBnGCNGMuabf9G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Fe8PuOb7; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Fe8PuOb7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4IO8nzfRzmQnremlogH0nyZ7Ud5v++zzdWBdmgNrSYY=; 
	b=Fe8PuOb7EfytiJ23sHrVKPY9FBnIGeDe2eQi33OoaZqIo00ez92nm/pK7KVs8KtRD4Zed9Hazy/
	hbEuotGynWyxLa/8eip29xmc1/I2wx1gIAEfio5a6zRDPTb5T9meu1EIi0+YwrGJ1a7J4Td99mgte
	BzBlBbLkoRy5eWR9hdW7OePXhuao9V7Fvi0zQqq6paV8DMr+O17fYM47J4AD595WYpQpUqOHsUlLv
	s9wKwImVu5aaiQTkmjQ7vHQl9l4/r3rT0Xoq2Ixv+/WzPBCI9NA5O5gQHRdgmHpK73NwSQGvnwSKV
	uxYyMzUHY8RfBhkVZLITf5i1K8EnbqKx9sgw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wkdkX-0000000EOBG-2UNf;
	Fri, 17 Jul 2026 16:16:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Jul 2026 18:16:49 +1000
Date: Fri, 17 Jul 2026 18:16:49 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pan Chuang <panchuang@vivo.com>
Cc: Olivia Mackall <olivia@selenic.com>, Hadar Gat <hadar.gat@arm.com>,
	Frank Li <Frank.Li@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Jia Jie Ho <jiajie.ho@starfivetech.com>,
	Deepak Saxena <dsaxena@plexity.net>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>,
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <imx@lists.linux.dev>,
	"moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] hwrng: drivers - Remove redundant
 dev_err()/dev_err_probe()
Message-ID: <alnk8UV-b2uTMsll@gondor.apana.org.au>
References: <20260710105318.376496-1-panchuang@vivo.com>
 <20260710105318.376496-2-panchuang@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710105318.376496-2-panchuang@vivo.com>

On Fri, Jul 10, 2026 at 06:53:06PM +0800, Pan Chuang wrote:
> Since commit 55b48e23f5c4 ("genirq/devres: Add error handling in
> devm_request_*_irq()"), devm_request_irq() automatically logs
> detailed error messages on failure. Remove the now-redundant
> driver-specific dev_err() and dev_err_probe() calls.
> 
> Signed-off-by: Pan Chuang <panchuang@vivo.com>
> ---
>  drivers/char/hw_random/airoha-trng.c | 4 +---
>  drivers/char/hw_random/cctrng.c      | 2 +-
>  drivers/char/hw_random/imx-rngc.c    | 2 +-
>  drivers/char/hw_random/jh7110-trng.c | 3 +--
>  drivers/char/hw_random/omap-rng.c    | 5 +----
>  drivers/char/hw_random/xgene-rng.c   | 2 +-
>  6 files changed, 6 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
