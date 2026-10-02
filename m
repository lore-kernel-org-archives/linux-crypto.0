Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85777443A88;
	Fri,  2 Oct 2026 08:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790928908; cv=none; b=ZyMXGBoKdnai7SjMNtDl3xovsIiRl0xqDCRw4Q+ULvMabL20MSh7xbazsnfDlhsZN+S5RhPEkEIqaFpbNjUxlwH88/5QadTUOV2Oa1BtPejtTdr0T4ArTdlOvLXcM/b2tDoGWK2WxY0oA2Q7iLzmD29YlY+1SkJBMj2wcdOfkYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790928908; c=relaxed/simple;
	bh=KNaCP2PFESA5gByNaKfkseBlE1xrlvAF6+R56hwbu68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gv1uPEWZ9zj/aD1aU+fYplR/AYIlkMmu8wvjv2eHe8qjrZ/U5n0v1gPh7qnaR6mJKbhVUiDCqWr4X3A/h/IRiGG5iaAo03N3WmbluCsgRm6j5T5+DdrB2UALpyVfrXxrabiT1iyGmgV0KmbuTuGiuqA4C+74Zw8hYQ3q+v4yZug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cW0FdBY7; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cW0FdBY7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+rtPOGSXYDqrtDbngoAW/eJ/AfaN/6sKPLmlow3JZyI=; 
	b=cW0FdBY7Gi9Kw8VFRC8vfTAlvNIAjWH/JEnbi6laKNEUORFLQS2ozZwmh/8WneEF1MBPFwjKxB4
	JBd9pf3IRxwriL1HX+CjUUNP2Sp7fPiyGsOvcRsYmJR68q6D0YIHFjEc0smdWNc7rUv+ptWnen4JW
	JxczpaBtOu5JjBQ0Eyi5P2jepjV55nP0vrWK2EDhcBluenUKn02SdUgAOxqTFNux5D/lTpl7j1585
	4heZK8k6d+NN2XRJvEQWItTeGhbdCnMLYG3NsJEYAbBkSB8GnEAEhkTXn/Bgf7RopIv+926HYAuSS
	Fs2p3DiK0Q7/2l/e8h0SgB/BbgfCAB9p7MOg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYQ2-00000002mQ6-0jxz;
	Fri, 02 Oct 2026 16:15:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:15:02 +1000
Date: Fri, 2 Oct 2026 18:15:02 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] crypto: cast5 - use memcpy_and_pad() in
 cast5_setkey()
Message-ID: <ar9oBkT8yRtzMpkx@gondor.apana.org.au>
References: <20260921061120.29694-6-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921061120.29694-6-blum@kernel.org>

On Mon, Sep 21, 2026 at 08:11:20AM +0200, Thorsten Blum wrote:
> Use memcpy_and_pad() instead of separate memcpy() and memset() calls to
> simplify cast5_setkey().
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  crypto/cast5_generic.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
