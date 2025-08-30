Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7279DC2EF;
	Sat, 30 Aug 2025 08:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756544360; cv=none; b=p/BcOF2rP/x3tKIHAdDxQ7t7J3EkaDFPN+2gC5RpJ8NpRPuuaA6x82faR0qGfefuzzRJTFm42nx3tod5zmXAKYHiin7v8hyBFpfzY8T/M82XPh0MZxHvZChw8wbM+sY9LeDGoOCTbalY+1Argwq2KJCHqaLJH24zz7ETNpFLNa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756544360; c=relaxed/simple;
	bh=JZ7paaJj7iN9dGdC9SF1N78pFNlgmPMECdUzlHM18bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gv+nqzQGSYo3GU1UnVGtkTwfOqdrMc5EBqRxCFz/4xO8q/SIbHXc1MfaEgOK2mXLwYhwwQabw2kq+7t9iGqvNIyN5lRSnW+6zm6i3EzUTg2hZredIaFuKXHn4WkrGI2w/+1p1ZE5GJ3KPON36Kh/E/097xqdzxsMh8K0Rog0p1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jau1YH1z; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jau1YH1z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fJcZLIIesEV+Sw30zRwnHPbqB44hsgZwWmAFq7sJG/I=; b=jau1YH1z3QE/D0GBjGC56JzsYD
	Y00OLoFBthQL380TBAgrT3JedA/1uJXAhCEC6iksIYVB1eMFivrxEVy9SVCFzI3Nec/Adg5Q67zrK
	MeEjmV8Z2izqCXlXiOHE55/HmeOY0k5zKB7bjUJE5+mGhwYimvnf4B+pddahJH9BnVz6Mz0MB7ve4
	SddWCCKJ/NelWJWoVqMuaVKbLaFYNoPUAXxCjurFBzkbsrkWAxfPCFAXBLpLguiRYXA51rrqjsV5o
	e5juahIKI9uC+nO/6pO4vfJt70tXNFrHwzSJDq8dIPw6qT8p5VnJCy09eWTYuqPB5whS3q13iCrkn
	rl9GAcFg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH67-0017FI-2W;
	Sat, 30 Aug 2025 16:54:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:54:04 +0800
Date: Sat, 30 Aug 2025 16:54:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Yang Shen <shenyang39@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon - use kcalloc() instead of kzalloc()
Message-ID: <aLK8LGzKNSLzTMqu@gondor.apana.org.au>
References: <20250821142732.34952-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821142732.34952-1-rongqianfeng@vivo.com>

On Thu, Aug 21, 2025 at 10:27:31PM +0800, Qianfeng Rong wrote:
> As noted in the kernel documentation [1], open-coded multiplication in
> allocator arguments is discouraged because it can lead to integer overflow.
> 
> Use devm_kcalloc() to gain built-in overflow protection, making memory
> allocation safer when calculating allocation size compared to explicit
> multiplication.
> 
> Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_main.c | 2 +-
>  drivers/crypto/hisilicon/sec2/sec_main.c  | 2 +-
>  drivers/crypto/hisilicon/zip/zip_main.c   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
