Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3F8179A3;
	Sun, 16 Feb 2025 05:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739683511; cv=none; b=EPNPB80eyZaX58wSQCWp46uTjw7/iyvhl627+pNM4ob0gXab8RAPFg8CKHRkMYOfDL7ExhUVyR8P3B2LBL7rvW5VRC+XQltR3mxDWwmZlNC+g7KvnFWewn4UkEdro7wRzwoZOj+37EQNawnh9fUC3tBKFXtC0T9w0AW7CEhzM8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739683511; c=relaxed/simple;
	bh=2k7jsRbX0DaWUoSSnWMxAc94Yy7zmLEnfPBfG0aBEmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4xqx5ETBGIvO+4Gfnr0Y4QP+9DilJGEIlIxxLmft7mcmzPqwciy1QgFNDs6/UjBzoxrcZ+35nYJwA90c3UPg5FGl+37PfoM0jtvyULsOsszRcKYLNxymMBSI/lxx+63sNgpv+k/Gbgw7Ugf0+6tMuaHMJi8njsQAhfhkzzwzws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TpVS7IJI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TpVS7IJI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BY0A3c1Li3XJjvwHRgkIRQoUbXu6gu2G0SOZZ3jPeog=; b=TpVS7IJIU7qjQRLoWFHHZOVq2z
	dYlK0LpVicENiuQEMegVUknNDa41pzzQTWFR2bgq0eeZnA5noFHKCYnZ0AYWuhkfT2wjk4/MYlb92
	m8hj9h5Y/SeYXaIZ+DktHhLXkVtsWysbgGCqcLP+IXuCFpef+dra93xYVZ+ATJHm4CY+be2930+eu
	QRLUkLpCKFswH+jRACjz5E8bbF8FomfL7szuAdnjhsVFaMZS9KA97uAeDhjBFWoOZqUubqfFvC7Ok
	xgz80sWZPPqLpXm2w+/SIMGeiYdS0leUdsWov957pXk/xgKcDnOHtAz/AlnuFHOu4DZQkgAPsVIEr
	WUEzCU4A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjWw2-000hJI-1v;
	Sun, 16 Feb 2025 13:24:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 13:24:39 +0800
Date: Sun, 16 Feb 2025 13:24:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Gonglei <arei.gonglei@huawei.com>,
	zhenwei pi <pizhenwei@bytedance.com>,
	lei he <helei.sig11@bytedance.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio Perez <eperezma@redhat.com>, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH 0/5] crypto virtio cleanups
Message-ID: <Z7F2l98tVC7Wqybn@gondor.apana.org.au>
References: <cover.1738562694.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1738562694.git.lukas@wunner.de>

On Mon, Feb 03, 2025 at 02:37:00PM +0100, Lukas Wunner wrote:
> Here's an assortment of trivial crypto virtio cleanups
> which I accumulated while working on commit 5b553e06b321
> ("crypto: virtio - Drop sign/verify operations").
> 
> I've used qemu + libgcrypt backend to ascertain that all
> boot-time crypto selftests still pass after these changes.
> I've also verified that a KEYCTL_PKEY_ENCRYPT operation
> using virtio-pkcs1-rsa produces correct output.
> 
> Thanks!
> 
> Lukas Wunner (5):
>   crypto: virtio - Fix kernel-doc of virtcrypto_dev_stop()
>   crypto: virtio - Simplify RSA key size caching
>   crypto: virtio - Drop superfluous ctx->tfm backpointer
>   crypto: virtio - Drop superfluous [as]kcipher_ctx pointer
>   crypto: virtio - Drop superfluous [as]kcipher_req pointer
> 
>  .../virtio/virtio_crypto_akcipher_algs.c      | 41 ++++++++-----------
>  drivers/crypto/virtio/virtio_crypto_mgr.c     |  2 +-
>  .../virtio/virtio_crypto_skcipher_algs.c      | 17 ++------
>  3 files changed, 21 insertions(+), 39 deletions(-)
> 
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
