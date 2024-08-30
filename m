Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4667573176;
	Fri, 30 Aug 2024 10:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725014887; cv=none; b=e+ztgi2mxdSKf/KS5DW2FTaOLonRkQwzB5lzPz51eym6S3H85PWLwZYKpuG2aL5YXEhRKcrJHj4FUvClOZKJdH8l90R5gWjmRgYolqGa9cLAru7j+0A+VNNgclrusrMpJnHZMFVtOs69RLYOC0fOyQ0QRr1T2a20uOH9SQeHxak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725014887; c=relaxed/simple;
	bh=QeblxJZNNOww57+xnRWC5XqKAmxtvWYgkYw8o4CM7/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KF5L87FBJterABMKxJWpMj+amIxq3E+jODb5QcaCzPWcMjCk5+SVnOmJmzbWpAEDannRutXYUC8TUsE6NKTmWEq+QYI9m+yAtPtK6IONFv7XS5Im5EQ0YYUxRISNJ70yl8IUDoEQ27YSNMGfmw/jWRtWOaKPQPLtXNdVoChVMUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjz1v-008Uy9-36;
	Fri, 30 Aug 2024 18:47:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:47:45 +0800
Date: Fri, 30 Aug 2024 18:47:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: shenyang39@huawei.com, wangzhou1@hisilicon.com, davem@davemloft.net,
	jserv@ccns.ncku.edu.tw, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/zip - Optimize performance by
 replacing rw_lock with spinlock
Message-ID: <ZtGjUeJOy_-C7Gae@gondor.apana.org.au>
References: <20240823183856.561166-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823183856.561166-1-visitorckw@gmail.com>

On Sat, Aug 24, 2024 at 02:38:56AM +0800, Kuan-Wei Chiu wrote:
> The req_lock is currently implemented as a rw_lock, but there are no
> instances where read_lock() is called. This means that the lock is
> effectively only used by writers, making it functionally equivalent to
> a simple spinlock.
> 
> As stated in Documentation/locking/spinlocks.rst:
> "Reader-writer locks require more atomic memory operations than simple
> spinlocks. Unless the reader critical section is long, you are better
> off just using spinlocks."
> 
> Since the rw_lock in this case incurs additional atomic memory
> operations without any benefit from reader-writer locking, it is more
> efficient to replace it with a spinlock. This patch implements that
> replacement to optimize the driver's performance.
> 
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
> Note: Build test only.
> 
>  drivers/crypto/hisilicon/zip/zip_crypto.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
