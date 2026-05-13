Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52103175A7F;
	Wed, 13 May 2026 14:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778682720; cv=none; b=HrYlN3TbeV8vbDOm2zaGQdDHdHqW73njsfNrQND3w10O9pjKAJlE/l4oQWd5Fi1Bti6y+Cfy3sBHd/pJL8xjwelQ5BBWpOSmsimAVMnI2bqPsRhsm2EJN75Z45550kbSq/7v4O8jLACFzm6F6AV3oQ0MsokMhGC5iPhZ+AJVxuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778682720; c=relaxed/simple;
	bh=X04OMkGyc6eloOHNS9rY34El1djqfpcQqDlCkpg51i8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLknJ2Css5ah6tom67rMf3Bl/KcZe1/x/gIzbSWTxbBBDTS33uUOXm0nij+XYrOgDrSs7sJcWChmFnQitvAVo7W2zfhlznhDWyLxrQSM6mXuPqh79/5Ut8p7wte4XHlBJJf3EkxpAY1Fq5K+3oPMo72HsAthnZO8LcjWmAMeS7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id A6177370;
	Wed, 13 May 2026 16:31:55 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 8E2CB6016B8F; Wed, 13 May 2026 16:31:55 +0200 (CEST)
Date: Wed, 13 May 2026 16:31:55 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Anastasia Tishchenko <sv3iry@gmail.com>
Cc: Stefan Berger <stefanb@linux.ibm.com>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ecc - Fix carry overflow in vli multiplication
Message-ID: <agSLW1XpMab2VYNV@wunner.de>
References: <20260513105741.55534-1-sv3iry@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513105741.55534-1-sv3iry@gmail.com>

On Wed, May 13, 2026 at 01:57:40PM +0300, Anastasia Tishchenko wrote:
> The carry flag calculation fails when r01.m_high is saturated
> (0xFFFFFFFFFFFFFFFF) and addition of lower bits overflows.
> 
> The condition (r01.m_high < product.m_high) doesn't handle the case
> where r01.m_high == product.m_high and an additional carry exists
> from lower-bit overflow.
> 
> When commit 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
> introduced crypto/ecc.c, it split the muladd() function in the
> micro-ecc library into separate mul_64_64() and add_128_128() helpers.
> It seems the check got lost in translation.
> 
> Add proper handling for this boundary by accounting for the carry
> from the lower addition.
> 
> Fixes: 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
> Signed-off-by: Anastasia Tishchenko <sv3iry@gmail.com>
> Cc: stable@vger.kernel.org # v4.8+

Reviewed-by: Lukas Wunner <lukas@wunner.de>
