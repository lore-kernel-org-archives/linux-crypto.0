Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254E8342528;
	Fri, 16 Jan 2026 06:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768543604; cv=none; b=oOnYoWLR8yTZ2nP4sLSDcVu3tY/lY6rjRY8NzLmr7Dt/sHn2QuawnBJDBOvkzE1eL+H35RAeg9B0+SjxkTLlac30vCIDV75Wqy3jF3c2tqD5CktsGI6PlRhqae1e7N0mqHG6s4uOVvuNP1K+JUnxS7oxrDkaBcyhruMEUn/+dsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768543604; c=relaxed/simple;
	bh=HVwW3rKac2tIMEQrFQdJ6BEtyn94C1pxOHzCM6jcGmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kpu9hSUR0+0e5EeEXBW4FL52M+0cBGZg9ORil8QvL0kYgm0zoTEY54II1uESlkOpsq90eF8zKUfQ30dWCainsmZYRrKF0GOQ4q6wZacAcNgax3B+UCZdfNrQ4zSFWdPV7UaS8WBL2F3i6YawC+Kw7ISILH21Lsm5/7t2cEED2N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=M369rt78; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="M369rt78"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+KGC7lTCcKc0vBvJ8uPtFlnVv2ATE6XSFty/u8lvDUk=; 
	b=M369rt78Qv5F1tZtl+TzKN5wqpLuHcvZFQSJ2ayb983FmfT9ffVMfVrdUNNG3aIGR8BFuU2x/Ii
	yRyxUbiYoHL7Y4YZUnODpoTVULf378NXh4OZT+CLVGdRQxxuPxyoxeaFtd3zRdk56Q9qZv6MYpgxx
	M26Zy5fWV7CCgKH7QlT0Q7+Kh3OlCY1Y1rYvnJzJ/VBaTtaqRcRj4PlAlehUH+JlDBbSr6jXpG3m8
	Y66cTTAhbUumpPGQCs52zYt0iI0sraaGJhE4GRRkQDZwFAk9mpdvm8/aiZ1zSB6CkI88c6zhz9s1S
	RlMmn9t1FcakeNAWqgh8JEKz3KEEcPkWxTLQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vgcyk-00HDOb-2s;
	Fri, 16 Jan 2026 14:06:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Jan 2026 14:06:38 +0800
Date: Fri, 16 Jan 2026 14:06:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, yuzenghui@huawei.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, fanghao11@huawei.com,
	liulongfang@huawei.com, qianweili@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/sgl - fix inconsistent map/unmap
 direction issue
Message-ID: <aWnVbnHAUUk_AO81@gondor.apana.org.au>
References: <20251219033619.1871450-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219033619.1871450-1-huangchenghai2@huawei.com>

On Fri, Dec 19, 2025 at 11:36:19AM +0800, Chenghai Huang wrote:
> Ensure that the direction for dma_map_sg and dma_unmap_sg is
> consistent.
> 
> Fixes: 2566de3e06a3 ("crypto: hisilicon - Use fine grained DMA mapping direction")
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/sgl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
