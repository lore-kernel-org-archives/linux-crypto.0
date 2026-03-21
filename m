Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B0B2C3261;
	Sat, 21 Mar 2026 08:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774082996; cv=none; b=Dv61jaCLIJHg02MRyTDnuCly+8SDEkdzBVgYUybi94l3WbTspy9wQz1c2M707iVVyA/TOyK+9ko1r/yelE2LcxtAh/Juadkh/T6WBo4EtSjfpKsYIOcdtS3dTPrZwcJmZDYNw+Xn4SbLC9S/2iiW79Qt7LF7XyCeVxI8jgAQe/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774082996; c=relaxed/simple;
	bh=CA+YIWaojfP38npTLLPM31oox8W0W6hsDr0xp1gJGpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A0/KI0eQcRaabgK96GTRnM5dwmX6R7OfEZvxMCUpKKKuyN/PkgzMDhX1B3WdJXp0Sqj8Ara3i5KHmfdSLPuNyjOxPQiLmtOY+lqiol3Qxk8BdgV8Eyz3V/2dn1jxPvGr9Aoi969FHIzcpfv5Dl625gKw0LFMwZGWN547u9ads/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Wa8RdLY0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Wa8RdLY0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=RAxIzWTuy22nnOYxmUl9KXUYNohiykvRR08CzcQwPiU=; 
	b=Wa8RdLY0CPXbt7lxcSxC+/xJTKSXcghh6trzTlFgnA7PPq/IU4J1z2+JM5N7+hfx4ijYgi3Xpo6
	eSicS39ERjCoDRPiriFAEBTmOnfSVmXL6xPteY6XqYYe86oHEU4nTE7lRDTqo3Sovs2Gk29LLfXie
	8or/8IYiQsxs3nT5c0gEENQ+nQZGcTEENoEAYPLJz9BGKmkX5vYfoJAYBf8G/JMS/Zo3SYLgUJYQr
	kYPKwjnYgo5gdFbCE05bW6R3neHgCbjaiZmxPxiVmort992+DfKLyRoQty8C0ipiumAf5A2Wo3Si5
	nBfJ1bUCUqKF5JEYBZxFA5cJgobArjXvHC6w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3s1n-00GJBM-2K;
	Sat, 21 Mar 2026 16:49:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:49:51 +0900
Date: Sat, 21 Mar 2026 17:49:51 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ZongYu Wu <wuzongyu1@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com
Subject: Re: [PATCH] crypto:hisilicon - add device load query functionality
 to debugfs
Message-ID: <ab5br0J6j75zPa8n@gondor.apana.org.au>
References: <20260313094039.3390686-1-wuzongyu1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313094039.3390686-1-wuzongyu1@huawei.com>

On Fri, Mar 13, 2026 at 05:40:39PM +0800, ZongYu Wu wrote:
> From: Zongyu Wu <wuzongyu1@huawei.com>
> 
> The accelerator device supports usage statistics. This patch enables
> obtaining the accelerator's usage through the "dev_usage" file.
> The returned number expressed as a percentage as a percentage.
> 
> Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
> ---
>  Documentation/ABI/testing/debugfs-hisi-hpre |  7 +++
>  Documentation/ABI/testing/debugfs-hisi-sec  |  7 +++
>  Documentation/ABI/testing/debugfs-hisi-zip  |  7 +++
>  drivers/crypto/hisilicon/debugfs.c          | 54 +++++++++++++++++++++
>  drivers/crypto/hisilicon/hpre/hpre_main.c   | 18 +++++++
>  drivers/crypto/hisilicon/sec2/sec_main.c    | 11 +++++
>  drivers/crypto/hisilicon/zip/zip_main.c     | 19 ++++++++
>  include/linux/hisi_acc_qm.h                 | 12 +++++
>  8 files changed, 135 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
