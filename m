Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D1E78F52;
	Sun,  2 Mar 2025 06:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740896042; cv=none; b=MlF5sfXGHxSQYagzfGpzGqOq5SoUcPQ35v+W57WKuqWBJ7i0vbwo9jBN+N0ohrzL/jLx9DE+KBcotRN+lYfnFVhos8XHNnDKBTTeXFfdvafAs50RUw6TSoCD2TWCqHHbjJ9fvGYixQjihuoqm1JrXCSStIOtvveXB3zxbqTZDUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740896042; c=relaxed/simple;
	bh=fXnOO29zrjMzk6AuHFmDaJ4j8Jrh10RwvkJhUqrL3h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brorzC2Wl5zlg0qIM9mf2zlooxyUcRXCRbjwBotkTFNH452FXuQwN9OP43pw+I2eOfgf8aG7hDIW0uKUccxnFTWsoy0vkxR+2rAMJHInAVXjDcnQLzFZrTPVx3rnVDK1T1f5YlII59nsZhHNRCDU5d0plDo2weAfKsTiYTWHqn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=coAJxYSn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="coAJxYSn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Kq8751Bj7CLtWGxrhvdirEHzhBMYorr0p6I+vRvm7+A=; b=coAJxYSndDOyoXqaNBf29NdRUk
	NexYvCnFV8UxumEa9J/ZQseIB2MZJFJtV/FU5o+OuY2cgI967N16wIOmBiGynUuK80hzRg6izbVzF
	brze8dybE/8bq3R85voVHY6tdQvwxcXBVPXz4ttpirR7ANHXgeyi7IQ9/KFxXYGQjrcAYrE6zahmb
	9xzj1D7sK3nVzFanRoFvvkS8iCU7R/QL9WNA4nHxNDyf9eKzTlaCLCPvgP7szjIG8O+4wGIGaB7Lc
	PzqTvt5s8SP3rqY7QKBYMNns9yOpf16BuuG0z46sV5Mhn2w9VEgaGhmGIv1NK11b58bwA2dT0xj1/
	tJ3iublg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tocZx-002zRo-36;
	Sun, 02 Mar 2025 14:13:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 02 Mar 2025 14:13:33 +0800
Date: Sun, 2 Mar 2025 14:13:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Chen Ridong <chenridong@huawei.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] crypto: bcm - set memory to zero only once
Message-ID: <Z8P3DdA9d4nqTJVv@gondor.apana.org.au>
References: <20250219111254.2654-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219111254.2654-2-thorsten.blum@linux.dev>

On Wed, Feb 19, 2025 at 12:12:53PM +0100, Thorsten Blum wrote:
> Use kmalloc_array() instead of kcalloc() because sg_init_table() already
> sets the memory to zero. This avoids zeroing the memory twice.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/bcm/cipher.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

This patch has already been applied.  Please check whether there
is any discrepancy between the applied version and this resend.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
