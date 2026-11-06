Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964379;
	b=4SLqoXq9vSz2tibSauoYwd5NR6gIYFxQOWovkYmTYmMthwGPs6Djggua/WUi/MWs4/fb
	 vj0G1Zj/iTxKQ09Y8+nErKWfEIpDMyMyjrp2rmrd8T/03x3NnPqyu+1maeX8v5lGBlk+W
	 PAkldZ1fiQNx4nR5aPE1G//QZu/9mv5U/95lzJw1ZUPuzPZbpynDi48cGOcPfzMV/nkUo
	 JUr/NxKOsyAE5H/LQV4LXk3cFDMokCwXzsGTzMzXgutYuq9T+R6v8kTMkdW53OUopI3mI
	 AAoH0xhMmQNrquuNEpl7unBIw0eOxV9Ilug3nIQ7wMZP7ovwn3ZjHzm8gxVPUqG7iyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964379;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=IrtBx70IGrZR+xti2Gbk8jTJWI2O0dNnEpiHwlFt96Q=;
	b=pmD7361tvFsW/dAnw3VM8WfgJwvuazmESfktuvNmqwsOweZGyi3gB0g9poTICQpWpB4B
	 dfIBMlyZnxX7yNYdf1Ypo2WvO0A2rZLywfPi24xXSJyA9uhjkyZKymGPKgEh8R1RvlABl
	 jOlOTxvSE/8S9qlVXqZ4PAApH//OEsQe31Uu1Qf+6GrYFMzDveUW/WCgN6FdEaiZ090cz
	 sSd6h1FC+esE/s9E+fmvvlecGSnmOseoip0pBPmB4yEwtctg/YaiKuYGQVP7Z+R492Es8
	 Md71eIoR5apHFEguX9iNkXlRzOj81WQdYlJVc5K0AKW6t3baHHXyoJ+fjrD6d56gq4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=rsPfBbY9;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AF9606A335;
	Fri,  6 Nov 2026 11:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54AF9606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=rsPfBbY9
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IrtBx70IGrZR+xti2Gbk8jTJWI2O0dNnEpiHwlFt96Q=; 
	b=rsPfBbY9RHC/vk1wSrMzXMjMU4qFpD8QxIE3NFfbKIkpdYIZDcu1MremiPFaGgQLTOc1Ob4mg3Z
	nJ0gnaE8W3cssxfir2SalKGSEAPPjnLgtZLg+OpJBY2raBmD5b1u6m5WFa6WYye7VBF13l8w6DYY2
	WsEvZ8CWhV5Sgdr1rbuizrXdz7HWAtvk3gGK7KhmOTbPcDVnTQUF+/pOGjPel6HrtnLpUWecPZefN
	++u51lV1Hm5Rmn/lqcvhSIUYMMB+R7P5XMCqtqxdSH9CA1Rzt7nzhCQN8x3Ml9ZSR6EcD9ZETA7fD
	gKAv5M0XtJYSj/usYkLAdxE+Bc1U4nsPtSmA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPI5E-0000000Br0X-2ZhD;
	Fri, 06 Nov 2026 19:26:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:26:12 +0800
Date: Fri, 6 Nov 2026 19:26:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Brian Norris <briannorris@chromium.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-pm@vger.kernel.org,
	Ulf Hansson <ulfh@kernel.org>, linux-kernel@vger.kernel.org,
	Hadar Gat <hadar.gat@arm.com>, Olivia Mackall <olivia@selenic.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 01/13] hwrng: cctrng: Discard
 pm_runtime_put_autosuspend() return value
Message-ID: <au25VCRKopC2NI4I@gondor.apana.org.au>
References: <20261006231900.3230373-1-briannorris@chromium.org>
 <20261006161337.1.I8e0880001b352bc2b0e99c40b78cb57e03c88a12@changeid>
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
In-Reply-To: <20261006161337.1.I8e0880001b352bc2b0e99c40b78cb57e03c88a12@changeid>

On Tue, Oct 06, 2026 at 04:13:29PM -0700, Brian Norris wrote:
> Printing an error message on pm_runtime_put_autosuspend() returning a
> non-zero value is not particularly useful.
> 
> Returning an error code from pm_runtime_put_autosuspend() merely means
> that it has not queued up a timer or work item to check whether or not
> the device can be suspended and there are many perfectly valid
> situations in which that can happen, like after writing "on" to the
> device's runtime PM "control" attribute in sysfs for one example.
> 
> Accordingly, update cc_trng_pm_put_suspend() to simply discard the
> return value of pm_runtime_put_autosuspend().
> 
> This will facilitate a planned change of the
> pm_runtime_put_autosuspend() return type to void in the future, similar
> to commit 3afd8df02433 ("PM: runtime: Change pm_runtime_put() return
> type to void").
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> This patch is independent of the rest of the series, except for the end
> (changing the return type). I expect it can be applied by individual
> maintainers, and we pick up the end once the dust is settled.
> 
>  drivers/char/hw_random/cctrng.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
