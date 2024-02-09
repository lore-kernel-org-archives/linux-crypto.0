Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5F756476
	for <linux-crypto@vger.kernel.org>; Fri,  9 Feb 2024 05:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707454893; cv=none; b=B3eR6QpsDru11LiLJToubxMcz8DtaanoAx+utZ9nFxvKB7LwMdkkfEefsIK4daek/TObhrVRPwQAYpVxoaYNowKxtHKACEa+zOfUhZ05S6dJB1emPisdRkRZu1RAH1oYzTXxbYmvcN6VN4xz1Z3qkm9Z+ck12+kxnt0qZgH3DE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707454893; c=relaxed/simple;
	bh=i0IkRnpsq5KCwV3SYeSYR3wJD03s8+gROTQByf2cmPs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=VK5uXYSJp5n7yKnWzcCooQQrvn3BahwD2xmQtvvFcZUTWn/SU1dDPW5Sm0u+ykt1V+RQ6kPN2kATo5tbJsE79vGZLu5wZPziDJzDxROcg80rkmCxdutj8fnmy76LwGfwkfRz7t2g88WlZArjA6mSNiGPNNMqLASZTbdc58CTIdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rYJ0x-00BhjL-AV; Fri, 09 Feb 2024 13:01:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Feb 2024 13:01:41 +0800
Date: Fri, 9 Feb 2024 13:01:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Li RongQing <lirongqing@baidu.com>
Cc: linux-crypto@vger.kernel.org, lirongqing@baidu.com
Subject: Re: [PATCH RESEND] virtio_crypto: remove duplicate check if queue is
 broken
Message-ID: <ZcWxtYtNzXd1UPgQ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240201061716.16336-1-lirongqing@baidu.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Li RongQing <lirongqing@baidu.com> wrote:
> virtqueue_enable_cb() will call virtqueue_poll() which will check if
> queue is broken at beginning, so remove the virtqueue_is_broken() call
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> drivers/crypto/virtio/virtio_crypto_core.c | 2 --
> 1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
