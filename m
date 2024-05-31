Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9602A1420D0;
	Fri, 31 May 2024 09:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717149518; cv=none; b=i5F4rOJzZKpk0/N3BklWj2B5Oc3/uLvkDhM4dKUAAzaFCrJ25+q/YVWPeer625e599Ki3yOnB1YjWXTxbPMdIa9MVk3rQIBs7zaFehtn/wJTu1rSBMIOOKV2A847vgEfgco9DqCpIxL22RPIib9InbpfbbEkZiuZuQxFaApipks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717149518; c=relaxed/simple;
	bh=CKyLj97UPUEBz/XeOsBo/51NPdT+IpIDcONQXH9fiRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ewFresylOb2Th4IjdNuUvbjJIe5oFe8j5g+8Wyi1QG7GeWYzxjbGq/8OT0t+vI1mIm+X/M9jxeeY4++ebJjD3wXqYdKI2anD0ztLq7YNkW3tQkCHbRvmaufx9MWqNke/d6wCVRxTjOllX3ueP2Ug3ieUCo12FquAy29Zg3mimXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCz1o-004AJP-01;
	Fri, 31 May 2024 17:58:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 17:58:30 +0800
Date: Fri, 31 May 2024 17:58:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Deming Wang <wangdeming@inspur.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - Fix typo
Message-ID: <ZlmfRuKhFxWWyB6I@gondor.apana.org.au>
References: <20240513060742.2134-1-wangdeming@inspur.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240513060742.2134-1-wangdeming@inspur.com>

On Mon, May 13, 2024 at 02:07:42AM -0400, Deming Wang wrote:
> The mapings should be replaced by mappings.
> 
> Signed-off-by: Deming Wang <wangdeming@inspur.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
