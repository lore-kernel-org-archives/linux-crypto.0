Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EE922D794;
	Wed, 16 Apr 2025 07:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744790148; cv=none; b=lczNHpwYAPi1qiuX3c5aTVf37vs6GjnaBpDUkaof3+LIyE20U8gmnVL+ojksA6DmVo8SaKT85Zv0whA0ZUzCw2u3Wa4gFiXUhl1zdJ30Wxs/DSioYEbs0ivOPLs71SstKE0Q6H60l4P/GikqUxsR2Mxxj+EOmRWjJCWIvzYjMl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744790148; c=relaxed/simple;
	bh=DLa69yhUnebKn/Pz/CMMOrUV+in+icleDAt1FkRwB7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q306x28UmCd8vubioTGNmnvdUU6xVGoxPs8OeJ/074inzjWZrxZZiMrwgMpzfbsNMZM7y/hh+epbQcHJ1Bpu21WgQNZXoUWvkmLNAEsXr9LpKudf9WfHidZ/bYbYgjzlQLubTFnxul2x6i/AgB5o3px0BXKCcSAC1YJiGzq0B84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BWQQjaa0; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BWQQjaa0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Awn6TDzc/G0MBph7vogQedcH0Es+2l6T5ToqoL4LOxw=; b=BWQQjaa0+UsSSaRmZ7GfotIjKo
	41gzRscKBzMXg3bh6G+MMApkrvYg9ZlOb97Boi5L0AGuCunNuSeREpG7zGxcpuAoRYr3BSQxi3czL
	KEjyROY+2gac4FU8dVmFMSILAzgoP9g0RWF8MV0x2LXmo/hxDMS78kOKBfwckxiIcs8zwOa9I/so2
	RFktrlo9c23iq4ASdWXKzwr6FnJDexEloDUFvknKNSftiTuzrIHdpeTu4KySDOqJgYbTIgI0YIKum
	+24D/s/wz7n8K8DVW/GPneEymz7d4LrbLU7U4y76Umi7rCjuNk3eitFyELTz7aMYHfh92UZVQQbJM
	H9MwGG8w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4xcR-00G7qr-0A;
	Wed, 16 Apr 2025 15:55:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:55:39 +0800
Date: Wed, 16 Apr 2025 15:55:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] crypto: img-hash - use API helpers to setup fallback
 request
Message-ID: <Z_9ie2KwYhCaK_mB@gondor.apana.org.au>
References: <20250407123604.2109561-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407123604.2109561-1-ovidiu.panait.oss@gmail.com>

On Mon, Apr 07, 2025 at 03:36:01PM +0300, Ovidiu Panait wrote:
> Rather than setting up the fallback request by hand, use
> ahash_request_set_callback() and ahash_request_set_crypt() API helpers
> to properly setup the new request.
> 
> This also ensures that the completion callback is properly passed down
> to the fallback algorithm, which avoids a crash with async fallbacks.
> 
> Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
> ---
>  drivers/crypto/img-hash.c | 41 ++++++++++++++++++++++-----------------
>  1 file changed, 23 insertions(+), 18 deletions(-)

Patches 1-2,4 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
