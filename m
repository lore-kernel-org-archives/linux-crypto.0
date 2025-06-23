Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA5119F40F;
	Mon, 23 Jun 2025 09:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670472; cv=none; b=gr36ckNd5q6+JTCow9vwA7B7s6D/MV9sGbaXGPNxDIqeGIYowZ/aq8/OSUAIO5N8VN81KLG+Ug1EzFbFmQGk3kv9Z++TH8e5FEEWA5+MkYP80yOyy5zk+pYcEFZFSk4FTEMPyo8Fos+jY7xsnakNekcaJJPakAbq8Qqz2+hDve8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670472; c=relaxed/simple;
	bh=xB38TcCLu3+82uTnlKr9eJXWn6quvpnALLWg8EhWsvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTSDYZtzcEGtEQNnJm7zGYHJewHaGDF7tQGwydbbNXxCGEHFd59P7ysZiJIukJ+tAJE0TITEsVUVsZtrlPzhD7BKgRs//HnZoCjQ8Mf67R9lrqSRFlxirTd/rcXXl83OlJAHZp8qzPU3m+gZDqjTfMC7aPjb/DcvUDUulaWLtCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZJYwCt/1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZJYwCt/1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rrj7xmeWsaYEs+b59Xu6ZhIhwnsn9oGNVVzm3qZFXi0=; b=ZJYwCt/1YSfPxxVhxjKWB5BxOO
	ZAY7XWLF8weWu3UurufpNuaixzvetK4o0XWh7va0R8iMcPAZSyOlxqfJCZdOAT62qt+mAQunHTizW
	y/+D7kFK7guYgtJB4AfxwGRyNtDEAV376su7sXi8gt2L4aGMLuRCEdWC13p+1irpsPaB1bONFJjXq
	Lkm1hKS+drGd7lZvgsM4zmcaSHMhBqnb+OybTs/MA/TN7MO40Pjs0r0nd9wNISca9IKNH8gaGGxw2
	BhHijgJARQmkI+aVisswgpr6ozSdO9P/eRKZ5O427pnL4rOumoxAGlRpnreoAgAsoxawYN72LZCcx
	lRkbnyVA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTd6d-000FYl-1G;
	Mon, 23 Jun 2025 17:20:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:20:43 +0800
Date: Mon, 23 Jun 2025 17:20:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
	davem@davemloft.net, virtualization@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-crypto: Remove unused virtcrypto functions
Message-ID: <aFkcawtiloUrjm3I@gondor.apana.org.au>
References: <20250614000505.596563-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250614000505.596563-1-linux@treblig.org>

On Sat, Jun 14, 2025 at 01:05:05AM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> virtcrypto_devmgr_get_first() and virtcrypto_dev_in_use() were added in
> 2016 by
> commit dbaf0624ffa5 ("crypto: add virtio-crypto driver")
> 
> but have remained unused.
> 
> Remove them.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  drivers/crypto/virtio/virtio_crypto_common.h |  2 --
>  drivers/crypto/virtio/virtio_crypto_mgr.c    | 36 --------------------
>  2 files changed, 38 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
