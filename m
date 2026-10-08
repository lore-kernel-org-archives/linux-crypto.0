Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B543BD638;
	Thu,  8 Oct 2026 08:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448088; cv=none; b=HLc4MUyCNbWhed7fC8u8cEZ9uOjQmNvi3M9eq3fqdgOS6FbxHFuOnaG9Z5e/xOsGP+jcueMvOaoAuLGCL+FX4gYftZRwsdqnETfqFGBWN9Bbb98M4OaPHj9MkdUxoT2ZgaXaXhUjwld3J2HzFLeKezLd30PJvfeQqdCQ6JeNmEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448088; c=relaxed/simple;
	bh=EuBA128hXeCR8JmIS8R6pNG0eJW+KJC5QhtaCPCJXmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwpE/qXDs8dItTrDBQvcGqXD1iph+us3vHxGIoof8lAy1KQ1S1JSSzflsst7/kFIGO4ZpNbMvRQI+i9nblLyxIp5Rvgd/h6HwcpHMNqkAAcBWZrIY4alPr3oAa2ntGilqlmtKe1FLXJz3/xPcoyOJTN++9a2xw/BoX9KgHZReUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fnFHgSXb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fnFHgSXb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=sNT+W80Z5JEqnaaO8YBUuD4jDz+3u0qB1a0toon9Zx0=; 
	b=fnFHgSXbC+V7FZJVCz1rJni8XB6MCtosH7DI3VNqIZ7Fuo/uOpsUrsA7F6TcVMLqtpvsPTp4zPo
	hL6zgKDtMLQYPb+u4gc8UmKqwPoJoQMTYgumisqD7w2l0iUEmpPkM7FeqdpMqxmh2oz+GyIpf+R82
	XjCLloC38uR1u23ju3BMan0vzGyXTFr4TxKlXMp/XGLR/HlFvsC092cNXc+YkJOueYJVzAhicNOic
	QM2kt0PrtrxCewW592/HRQbjTXzXdujF3R4OeZIXwDHnpCb74j0Rnm2oF5T/1IKObRJoSv5Riw24y
	sIKrfhUPwE8UBYg/UZyAEYp06Gt13QjpWpQw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjTr-00000001nuj-27Wx;
	Thu, 08 Oct 2026 16:28:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:27:59 +1100
Date: Thu, 8 Oct 2026 19:27:59 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: huangchenghai <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, liulongfang@huawei.com,
	qianweili@huawei.com, wangzhou1@hisilicon.com,
	linwenkai6@hisilicon.com
Subject: Re: [PATCH 2/4] crypto: hisilicon/sec2 - fix scheduling while atomic
 in aead soft fallback
Message-ID: <asdUD5XOvhQbpHNN@gondor.apana.org.au>
References: <20260911102942.387778-1-huangchenghai2@huawei.com>
 <20260911102942.387778-3-huangchenghai2@huawei.com>
 <aq0AtfUHUw1qOD2Y@gondor.apana.org.au>
 <c19bbae6-e1f1-4ca4-8156-8b1fb6746319@huawei.com>
 <arn3y4kT0izjENFR@gondor.apana.org.au>
 <82938646-1ee4-4789-8911-051c43b84d57@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82938646-1ee4-4789-8911-051c43b84d57@huawei.com>

On Wed, Sep 30, 2026 at 09:22:31AM +0800, huangchenghai wrote:
>
> The sizes vary by algorithm. The worst case in the sec2 driver is
> authenc(hmac(sha512),cbc(aes)) at ~568 bytes, mainly due to reqoff = 2 *
> SHA512_DIGEST_SIZE plus the embedded HMAC ahash request. The ccm variants
> are ~468 bytes since crypto_ccm_req_priv_ctx embeds a full ahash_request
> union along with two 3-element scatterlist arrays. gcm(aes) and gcm(sm4)
> are ~288 bytes and fit within the current 384.
> 
> The only concern with bumping MAX_SYNC_AEAD_REQSIZE is stack usage, since
> SYNC_AEAD_REQUEST_ON_STACK allocates on the 16KB kernel stack. But the
> fallback path is shallow -- driver -> crypto_aead_encrypt -> template
> internals -- so the additional stack usage should be fine.
> 
> Would increasing MAX_SYNC_AEAD_REQSIZE to 1024 be acceptable? That covers
> all current algorithms with some headroom. Per-call stack allocation would
> be roughly 1KB, which seems reasonable for this path.

Thanks for looking into this.

My preference would be to change authenc to store everything on
the stack *if* both skcipher and the hash are actually sync.

Let me write something up.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
