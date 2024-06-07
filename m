Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A098415A4A2;
	Fri,  7 Jun 2024 11:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761484; cv=none; b=j3qXgmxzHy4A06zSiSJxx4+nNgFEQ9g0F7sb90NG9BXGJZ6iO7VWNBPqAru1Eagxd/BlwOkxTa46Cg8UQX34czVeBb2jhdUoLPa0CPFqEhuuwpF/JBl2Y7GcscfPwL4q5HFfTKZGiGY2R9DXvCtLWjr9MUvyQow2Otr9eLczi08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761484; c=relaxed/simple;
	bh=BJgA5mjSOdgFasg9fVU69D0IkoNIEebkOV1Dysjw+vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UAGkmDgl9pMyLmjP/AyKkX3UK73gYXiXHWB/vGA2H/sKa/W+Ef7neFxqW8liFa71n8RyW5VLMj8ZRa0I8aIvIiYA1T/V3Yfs+5kLbPrjzfKNEAk8X6PEwicxZh6A/b+sQWiiiLfaTYASGw28cOg7LhA87zTXkHywIyT688lTr4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYEH-006pKV-20;
	Fri, 07 Jun 2024 19:57:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:58:00 +0800
Date: Fri, 7 Jun 2024 19:58:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, shenyang39@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com
Subject: Re: [PATCH V3 0/2] crypto: hisilicon - adjust vf configuration
 sequence and optimize zip reg offset
Message-ID: <ZmL1yH-6e6VE4Dtd@gondor.apana.org.au>
References: <20240601025150.1660826-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240601025150.1660826-1-huangchenghai2@huawei.com>

On Sat, Jun 01, 2024 at 10:51:48AM +0800, Chenghai Huang wrote:
> The VF enabling and disabling issues are fixed, and the ZIP address
> offset calculation is optimized.
> 
> Chenghai Huang (2):
>   crypto: hisilicon/qm - adjust the internal processing sequence of the
>     vf enable and disable
>   crypto: hisilicon/zip - optimize the address offset of the reg query
>     function
> 
>  drivers/crypto/hisilicon/qm.c           | 11 ++----
>  drivers/crypto/hisilicon/zip/zip_main.c | 48 +++++++++++--------------
>  2 files changed, 23 insertions(+), 36 deletions(-)
> 
> -- 
> 2.33.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
