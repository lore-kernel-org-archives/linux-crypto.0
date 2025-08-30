Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECA91EF36C;
	Sat, 30 Aug 2025 08:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756544046; cv=none; b=H/ntQyDk3hpUMMatGbBn8aAQX929gxyLiDbtCcDJ7xnA3PAfy1dmeG2zvpvcEOfSPF0Nr1K477eNajZ5MPCz+euYAcPNM5r5XddKP4HZNwUcWVzKkxsll/LgN8MQpTzL6ip7P0lmA+HAZvk0FwnuTK/a/ABb8GlAtgZNEBsyle4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756544046; c=relaxed/simple;
	bh=TkGMmig8HAxFSUakdNm0Yi8lvaRNd5+oiElJ09B0AGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ocwOkr2q5SwtrXt1goW6JqjI9AEkVTp5MvDEMWNAHeKO73iPyacbGjY1iGx5L6bUEVmGUB7Utpy0QNERtF7IkxCzrFugtl7EcEE7TFxf1O34n5qFa41xlkte7eeerUyuo/RkSQwIrU2LWoJ4JHvZt8io06uWRZ4F+ogjF4Ip8Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=r7WWn6tl; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="r7WWn6tl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rBI+nGpLjcS8vu0mZdYySLi8aD1xML097paK8Lcw/vQ=; b=r7WWn6tlvzVxlhyE3IskLzTV1w
	Ucu6VaQFKatOgS+TPbQNCxpRMIbZ+wd1ISmgTdmUNjhf62QHTDLq29+EEhIQ6ffigNuD+KkpBW2m1
	qVkQUFjYt7w0f1M64un9S72reTOYWZSsFxCblfnBUSGrkVNLGx6IuU3p8PrWd9pORrm/oX8lNz5np
	Sr3yg8z2ijHK305zZvQlK1Wc53emiJpI8IrdOXDYfk3HpwgtiKxUqY/g7R3KGBAJFfhVfax6uy6KY
	PV3LIUNXmRyftwJevE/CwNDs2XX3oIB2APFvTOZ1Ewh1QHCaXTeQRALXq5oFgFoOqa6+CIPjULlBz
	t4VyWbqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH5s-0017F8-1k;
	Sat, 30 Aug 2025 16:53:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:53:48 +0800
Date: Sat, 30 Aug 2025 16:53:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jack Xu <jack.xu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Colin Ian King <colin.i.king@gmail.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: qat - use kcalloc() in
 qat_uclo_map_objs_from_mof()
Message-ID: <aLK8HN_33c2Nvhe5@gondor.apana.org.au>
References: <20250821142028.33256-1-rongqianfeng@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821142028.33256-1-rongqianfeng@vivo.com>

On Thu, Aug 21, 2025 at 10:20:26PM +0800, Qianfeng Rong wrote:
> As noted in the kernel documentation [1], open-coded multiplication in
> allocator arguments is discouraged because it can lead to integer overflow.
> 
> Use kcalloc() to gain built-in overflow protection, making memory
> allocation safer when calculating allocation size compared to explicit
> multiplication.  Similarly, use size_add() instead of explicit addition
> for 'uobj_chunk_num + sobj_chunk_num'.
> 
> Link: https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments #1
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---
> v2: Changed explicit addition 'uobj_chunk_num + sobj_chunk_num' to use
>     size_add().
> v3: Revise the version description to keep it consistent with the changes.
> ---
>  drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
