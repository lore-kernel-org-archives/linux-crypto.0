Received: from mailout2.hostsharing.net (mailout2.hostsharing.net [83.223.78.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51714EA370;
	Wed, 29 Jul 2026 18:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.78.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785349737; cv=none; b=ELoCvJmvDU8gE6GuazfPb2rH1rGzQrtI9hWDrITOr1ROlKhBCwt9i506y7MD8CFtNMSQZ5YoU1Zc3fwxn43zAtUIPfAZ9o/9+JM+FbRc/IO6+bMnKYCwaHA/VFp21xkhmb2ASXNikTFCB9siakmaJKPyBwJDE0o+D3SzYVdQmoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785349737; c=relaxed/simple;
	bh=RzYBPmxdO5o2Y7MtYT5jxKTyWeIIps2WLLrT3XQsbns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ledDsoVH4ShEqvo5Dm/aWxqAr1KyQb2VruJHSNcapRNhBRxdBskwcJvh1Quo3AV12AI0GCjQe18fcGRcDkeMfmSb4KQ/7/tt3WxXZ8RqRTBcN4xROc6NyCad/1AI5KID1UWrkK3NDwYgu0WAl+UJE/UrXnPWr/DQEMoJTVz6MRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.78.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout2.hostsharing.net (Postfix) with ESMTPS id 7B71710615;
	Wed, 29 Jul 2026 20:28:49 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 686C16034322; Wed, 29 Jul 2026 20:28:49 +0200 (CEST)
Date: Wed, 29 Jul 2026 20:28:49 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH] crypto: ecc - Add NIST P224 curve parameters
Message-ID: <ampGYdgcMMDasJ5y@wunner.de>
References: <20260729-add-nist-p224-curve-v1-1-334dfbe16683@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729-add-nist-p224-curve-v1-1-334dfbe16683@bootlin.com>

On Wed, Jul 29, 2026 at 05:51:04PM +0200, Paul Louvel wrote:
> Add the parameters for the NIST P224 curve and define a new curve ID for
> it. Make the curve available in ecc_get_curve().

Usually we'd also want test vectors in crypto/testmgr.h.

> +static struct ecc_curve nist_p224 = {
> +	.name = "nist_224",
> +	.nbits = 224,
> +	.g = {
> +		.x = nist_p224_g_x,
> +		.y = nist_p224_g_y,
> +		.ndigits = 4,

This should be 3 because DIV_ROUND_UP(224, 64) = 3.

Thanks,

Lukas
