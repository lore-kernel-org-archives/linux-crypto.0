Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1637C33E34E;
	Sat, 15 Aug 2026 01:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786757193; cv=none; b=Wt+aduEBtauunUmHcoPQPHNJxXo3nypCuw1WCp9RHdKSUg7l13n3mBI+SeI3D2cCOdd2u77knDCUoqLcQnxone6tGig6He6qj6zc0qRrWY5oFCOTJrsL3/hepwMPgfvqBbrE1CKof/nxVS4KmCGG6or9nAQsl1Dv24gdUVVPUec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786757193; c=relaxed/simple;
	bh=eLXVjv9kWLqV14er1XbJbfCkRgtvUehoXl0MNl79yC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQIL5UBqelxxY36U120RnA1SXYG8CT0xHA9hcRIni58VNBSPASNprejvwlU4sRPg7SOX86mtanffbL1I3PHjmpN813jXPDhU00KHNbXEU9HXuoOWgWv1eLsTrOxYdYbvrvhXPAWY/zUt5nio2skTH3nhiKY3naWE1lHqCgzm/4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Yjl7MfAr; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Yjl7MfAr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wzOgGzjSmbGYIb3zzodKHagfvD5rdx4s7qoWmE0C484=; 
	b=Yjl7MfAr2VPhOkHBJihSMbdqjX/SkiiJRmQj9/OPxQiVb3CGZb5iEBIzTpbK2QtTIHzcU2jck47
	LETv+tcxaCy05rySEaYZxJSRo+KA+MuosmfZiEe5AJfaE3lBsEy14M05J+K7l3E9C4hleElG71aiC
	+8gCOG+qzG0ca5aN+Z98gGJ6FiUGdPRLtqnuJpbkyZDBuzfUzx1OLytSQe8hwGXG8nFc5WFlJuNtG
	XPEE7VHXLXGwcjCIbGtBwiUI4dRia5v1pFRXMLo9TAFo+wVdfywNSBO3ugiTI3gV2k+mkkCDOqNHy
	XERn6HHaRA9FZQo6yLIwWrjOrkBuvquoHOpw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv3AJ-000000054u0-3Xfy;
	Sat, 15 Aug 2026 09:26:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:26:27 +1000
Date: Sat, 15 Aug 2026 11:26:27 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chenghai Huang <huangchenghai2@huawei.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, prime.zeng@hisilicon.com,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com, yinzhushuai@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/sec2: fix CCM algorithm long packet
 failure
Message-ID: <an_AQyFtQr4nDiVg@gondor.apana.org.au>
References: <20260804022207.4073268-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804022207.4073268-1-huangchenghai2@huawei.com>

On Tue, Aug 04, 2026 at 10:22:07AM +0800, Chenghai Huang wrote:
> From: Zhushuai Yin <yinzhushuai@huawei.com>
> 
> In the CCM B0 block the message-length field Q spans L bytes, where
> L (cl in the driver) is derived from the cipher IV flags byte as
> c_ivin[0] + 1. set_aead_auth_iv() hardcoded writing only the last 2
> bytes of a_ivin with cryptlen, implicitly assuming cl = 2.
> 
> When cl = 3 (a shorter nonce yielding a 3-byte length field) and the
> packet is longer than 65535 bytes, cryptlen no longer fits in 2 bytes.
> The dropped high byte made the auth IV built by the driver differ from
> the one consumed by the hardware, so the software/hardware comparison
> failed and the CCM request errored out.
> 
> Write the last cl bytes of a_ivin in a loop driven by the IV's CL
> value, so the length-field width always matches the algorithm
> configuration instead of assuming a fixed 2-byte field.
> 
> Fixes: c16a70c1f253 ("crypto: hisilicon/sec - add new algorithm mode for AEAD")
> Signed-off-by: Zhushuai Yin <yinzhushuai@huawei.com>
> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
