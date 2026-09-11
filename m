Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9902237B3FE;
	Fri, 11 Sep 2026 05:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104762; cv=none; b=F6vL6NMg37rjhElhYFUGRJXJxKcZic6wAif5bNFFpbhFo84EvT1VT/lyiE36h4fnGxfKUZbE5KVOAHD19yODYSjglDp/0kYu7fPeU37xtTXOeO/fHTfTo0kqjHuGARfpBtiBEY3m44Yh2dz0+pkTKGQ+96t5gjNs3Iwr4riUzL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104762; c=relaxed/simple;
	bh=roUbVsxt7Qm8e8sbeFUR2KtD6TjYwdZVigeatZ///YA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=sVyKJ3VfU8K2tm2r/o5WUurYhyl8nusY6zHk9bNtTqMXAVrbZ/SbblvQw0Lhh7sSJSAnJ2ZJrmr3ApVIyCX48+y02vpPp9DeHRZ5dKsLb9jN+boFPy3ibCCykoQhERZ3qhHHp5p/gl34uHcDREk/hcC9fBjfvv1oKFb2bY2Xts8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=J0Yxh4tj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="J0Yxh4tj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=Cw/6iUe+OXctJ3/QTaiN6oy6i+6c0PDli5dcQiIXkfw=; b=J0Yxh4tjBj5YKKEdEgtH9x9dDZ
	HUw/QmkvMfO3s65qzitIIoAMriuYkpBlHUUc4dR+KIUyqhcqKZ3/FuAUWtcbaXLKq8CZ8X7QWO62y
	2/8Ag6k5pjnnGyTlF0BhT//NfGJnzv4asC4mPM5BBcJZsypSp78LFmreP3svU32+YUt0wYfPMW1Re
	ADQuTPSo9Xo5XUF3+riI53qhZdLu8rVsmeLS7QWzPYxS8JTzNnz+hcoZTJI7JqE+T4ed9doZB9For
	cMrEf+XnXSfM2z1NOigAKN0SKnAe+/NN47yM+cGZDu3otQJj1rbeYdhco2uye/jdg+qb5ar3PVJqD
	AL0P7RKQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tsJ-0000000CuCD-1Njk;
	Fri, 11 Sep 2026 13:32:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:32:35 +1000
Date: Fri, 11 Sep 2026 15:32:35 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: mario.limonciello@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	runyu.xiao@seu.edu.cn, jianhao.xu@seu.edu.cn
Subject: Re: [PATCH v2] crypto: ccp: Initialize DBC ioctl mutex before
 registering device
Message-ID: <aqOScxbMjvMWmB-I@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830015104.2040153-1-runyu.xiao@seu.edu.cn>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Runyu Xiao <runyu.xiao@seu.edu.cn> wrote:
> dbc_dev_init() registers the DBC misc device before initializing
> ioctl_mutex. Once misc_register() publishes the device, userspace can
> open it and invoke dbc_ioctl() while the mutex is still uninitialized.
> 
> Initialize ioctl_mutex before calling misc_register() so the published
> ioctl callback always sees an initialized mutex.
> 
> Fixes: c04cf9e14f10 ("crypto: ccp - Add support for fetching a nonce for dynamic boost control")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/20260829133410.1708684-1-runyu.xiao@seu.edu.cn/
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> Assisted-by: Codex:GPT-5
> ---
> v2:
> - Move mutex initialization before setting up the misc device, as suggested
>  by Tom Lendacky.
> 
> drivers/crypto/ccp/dbc.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
