Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F2B28DB56;
	Sat, 31 Jan 2026 02:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769828119; cv=none; b=az/y4ZRfA+BRCHK7QEIiikqQHkN5dlTjAhlvbI7jEBD6oMtQNWVWXM4+v6o5NwogwosJI5tCV1fByqtpmURhU8uVFExljSV1yW3p/t9db6D7e0/xhGvccHVUUdwjq1huNtrCEbe2lPaJLJtLoTsoVCswKBMe4/Tve8g1SjSSATQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769828119; c=relaxed/simple;
	bh=IA+ghsh360HYo4gsHo8NEIHFS5DulWQ3PK4IoStuT9k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ScPbZYARjSCSdfEeKWlp1MCT5ArX1gVzncwTndGQorUPsiXg+HI91xvCD/5LAL8Wu0xYYM3/LDIPxzb2j4tkWqxlyzjU4zHrd4In91DfzSVTqHzQnA/tHjpsFcXql+XE32H9k2/+z2cwXXq2456YGQB3qTn4ppIlN5cyQsESMdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UT7g4hXD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UT7g4hXD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qXdDCrUIU9Rw9G1TuIJ+LeB79yzkx61r7N1iQJdvtJA=; 
	b=UT7g4hXDbmQzhy1H5Ulv7MIbmi1NZEvLqsYx8bI+9sgRrYTwbZQQIxXb1wwDwRbr/M6mSnYZROP
	WPaaEoekbYDTM591iyjqoe5JQrtoBErtQ8cYtHWlO+lR3yB5JoZrI14tqjdejcFg0QOoj2/A18+u0
	BhFUOHCjiRmR0XtJLIdP6C8CgJOs9L7wR7gIsO3KkPeDyQ2HLsWDKjbkdlqH/z2qG16OeWA9ay+Wx
	XRPgzYyMMOMvFSO44t1yXSJtZxMtqoPTaLDKCU+KYMNh0/JzvM3rmNFXmrxyxkAa8s5F1HvNg0oRz
	TfEt82E+tPP4gUumJ58uFbj1NQQB8BqlHmUQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm18G-003S02-3B;
	Sat, 31 Jan 2026 10:54:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:54:44 +0800
Date: Sat, 31 Jan 2026 10:54:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bibo Mao <maobibo@loongson.cn>
Cc: Gonglei <arei.gonglei@huawei.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	wangyangxin <wangyangxin1@huawei.com>,
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/3] crypto: virtio: Some bugfix and enhancement
Message-ID: <aX1u9MbmxwGywyDd@gondor.apana.org.au>
References: <20260113030556.3522533-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113030556.3522533-1-maobibo@loongson.cn>

On Tue, Jan 13, 2026 at 11:05:53AM +0800, Bibo Mao wrote:
> There is problem when multiple processes add encrypt/decrypt requests
> with virtio crypto device and spinlock is missing with command response
> handling. Also there is duplicated virtqueue_kick() without lock hold.
> 
> Here these two issues are fixed, also there is code cleanup, such as use
> logical numa id rather than physical package id when checking matched
> virtio device with current CPU.
> 
> ---
> v4 ... v5:
>   1. Only add bugfix patches and remove code cleanup patches.
> 
> v3 ... v4:
>   1. Remove patch 10 which adds ECB AES algo, since application and qemu
>      backend emulation is not ready for ECB AES algo.
>   2. Add Cc stable tag with patch 2 which removes duplicated
>      virtqueue_kick() without lock hold.
> 
> v2 ... v3:
>   1. Remove NULL checking with req_data where kfree() is called, since
>      NULL pointer is workable with kfree() API.
>   2. In patch 7 and patch 8, req_data and IV buffer which are preallocated
>      are sensitive data, memzero_explicit() is used even on error path
>      handling.
>   3. Remove duplicated virtqueue_kick() in new patch 2, since it is
>      already called in previous __virtio_crypto_skcipher_do_req().
> 
> v1 ... v2:
>   1. Add Fixes tag with patch 1.
>   2. Add new patch 2 - patch 9 to add ecb aes algo support.
> ---
> Bibo Mao (3):
>   crypto: virtio: Add spinlock protection with virtqueue notification
>   crypto: virtio: Remove duplicated virtqueue_kick in
>     virtio_crypto_skcipher_crypt_req
>   crypto: virtio: Replace package id with numa node id
> 
>  drivers/crypto/virtio/virtio_crypto_common.h        | 2 +-
>  drivers/crypto/virtio/virtio_crypto_core.c          | 5 +++++
>  drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 2 --
>  3 files changed, 6 insertions(+), 3 deletions(-)
> 
> 
> base-commit: 9c7ef209cd0f7c1a92ed61eed3e835d6e4abc66c
> -- 
> 2.39.3

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
