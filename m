Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E98C45023;
	Sun, 19 Jan 2025 04:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737261983; cv=none; b=AW2afcldXnNFxbMmyWzApeaqgaXepdbYH7zywbfPChe3FBjGiV37EcUO8t3HTW8fGlFbMVVRiwVLYTMNjHYyr3rhzJSooTvrHOTjagn+nA5IliUSHoI4jfXiIfT5m/lnQBaZsHJyq2UnzP1ui8cw2pNQn/YWxST50hbV32LSzpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737261983; c=relaxed/simple;
	bh=Yyp0/xqYdZZqOCHjgwu0+cS2qVJD0MIHsRTCeHFvRgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3y+0C6ongI4c5eF5rDEK+PCXPr4OCN5vZmphOwZ5CXHChvRiH8RT70Jhi7Wvwngp1be9NpkxE2tBgiVA7zxaFM/ridgjOpPzNJWmisUNnDnt1STw0NEuP7EGk5BNbziDkzugxLMOXepISP+PHlcro9+JMKf9rHUkFixt4nRpBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Tyv5naov; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Tyv5naov"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kLUKgd2hAE8AB9rvdl9Bzukvw8QgwIcOUzft9k/Vsnc=; b=Tyv5naovbOG5ckbtzCFaHsiruY
	rL1aqGgyn6PMOsm1/MVzYYT71sw96XNNF72Bz7Ya4OMUXQAsfmcGr7XLXMBsNIt/OXlfrMxum2lHt
	hSF3EsjXbbTv6zpQ6EFbB476FPTor54bG0Dv5NYd26S8cm7yGGv4SrNQtuaG+fQ7hQLbOhVPO7yjH
	NzOm90COyh+kAF5v0+Sb/c8ODlCQYHm/oHr/9OkZDLLz5Igvx2Hc6NqTTYa/VMoJRHf3goDe6wVcA
	uy43ZotiDp0X7osUEBK82zbjMkBtb9xfyoRzFEome0c0xQnSFM3AJWUyMEgwnXsYn7RsnUqYj1Wnh
	7TDcONRQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tZMzB-00AVYA-23;
	Sun, 19 Jan 2025 12:45:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 19 Jan 2025 12:45:54 +0800
Date: Sun, 19 Jan 2025 12:45:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	nstange@suse.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, chenridong@huawei.com,
	wangweiyang2@huawei.com
Subject: Re: [PATCH v2 0/3] padata: fix UAF issues
Message-ID: <Z4yDggNAlq6lRfAq@gondor.apana.org.au>
References: <20250110061639.1280907-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250110061639.1280907-1-chenridong@huaweicloud.com>

On Fri, Jan 10, 2025 at 06:16:36AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Fix UAF issues for padata.
> 
> ---
> v1->v2:
>  - use synchronize_rcu to fix UAF for padata_reorder.
>  - add patch to avoid UAF for 'reorder_work'
> 
> Chen Ridong (3):
>   padata: add pd get/put refcnt helper
>   padata: fix UAF in padata_reorder
>   padata: avoid UAF for reorder_work
> 
>  kernel/padata.c | 43 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 35 insertions(+), 8 deletions(-)
> 
> -- 
> 2.34.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
