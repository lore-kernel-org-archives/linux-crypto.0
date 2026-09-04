Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673803F1676;
	Fri,  4 Sep 2026 09:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515203; cv=none; b=nMZya5E/7eEWKxl3wm/muaZPmCrkbnfQaF5FtCd0+k5wfMj0Egthln/zcqPNCSLl2oWQlsOlrpvoqN6BTNKUWo9L+MfkZg5sJ5tbvBTdsem9R4V/V7vp06P3Dv30x4IhBWul1FRZyTt/GkU2sO/Ori6rIpPXGhf1mq8FNQpTX6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515203; c=relaxed/simple;
	bh=N0l9nDbmBTBehxz5mZsryvLmuCEEgbSTaKbh0ginApw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=R2iCYW5Gk4Zkheu53LoCh+K8VDV6hYleWJXaBdOT7d/4KvU2SUiO0/6pbrchyXI2h1KJTzPMwF5XJUNLCCghhxchKiDRoFSrkEWWRi0CAILHA3zHDXqxuj7WTff9VZV0RF4U+yPaH9W1xNB9IEJ9Z5Bl7t5GTsG/86HM8nagzpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hqQIgrjg; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hqQIgrjg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=wqTo49i+gokHhCKvNLAgA2RH/mQ1olz1bWffX3pIh10=; b=hqQIgrjgDkqcl7dU99bwDH3buQ
	2I0GSVjUJkSX7OLuyC8BpgWw/8NPuEhwzovpmYtp6pdD6YnAE1heGjgrP3chXYzuIXmDU4hzRM1md
	eKLbpVVcgMRsVNzGKwO0Q4HcAGp0oLgAEEunjuNkB3IUExG/pWCgdGZq4GBT7ePJF/bHkLq0DP2YO
	Mzn4NtpznvOGuFHi/W9M4WjdXoHgG6WRf+RMSQfdALIzErWqAn/y6cuf7j2aAw/SoAbglZBhcw2Wv
	uN21UL8wgGeSm2oQldHrhFK1EV++8s6YmCapheBw+HlIXhcqktAGB1C20Cb2OjUS08SOnIQUscObT
	uG/RlFPg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2QVG-0000000AmxU-3iIh;
	Fri, 04 Sep 2026 17:46:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:46:34 +1000
Date: Fri, 4 Sep 2026 19:46:34 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiawen Liu <1298662399@qq.com>
Cc: dsaxena@plexity.net, olivia@selenic.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: omap-rng: fix runtime PM cleanup
Message-ID: <apqTen-69j7XUR7Q@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_1DBD00BAFF365506D40F166D40DEE8F63B0A@qq.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Jiawen Liu <1298662399@qq.com> wrote:
> Clean up runtime PM on deferred probe.
> 
> omap_rng_probe leaks runtime PM state if devm_clk_get returns
> -EPROBE_DEFER after pm_runtime_resume_and_get succeeds. Direct return
> skips put/disable.
> 
> Route -EPROBE_DEFER paths through resource-matched runtime PM cleanup in
> omap_rng_probe.
> 
> Signed-off-by: jiawen <1298662399@qq.com>

Please use your full name in the Sign-off.

Sashiko had something to say about this patch:

https://sashiko.dev/#/patchset/tencent_1DBD00BAFF365506D40F166D40DEE8F63B0A%40qq.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
