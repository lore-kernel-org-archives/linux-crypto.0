Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325EB17A2E0;
	Wed, 16 Apr 2025 07:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744790128; cv=none; b=eDkrN2YUtWOdnjV1DdAGJ9EZ1FM8VZSTwiGT9NB9h2naMifg15VfEoTDjW1FYoNRcz43A1Q10Qj46SRalpB9hrmmFYpchBMm4DtIxcyY5KyRssldZqhDc4e6F8r7sGBeZmhxXA7zWPA8yi9UwRCty+fwIhZXNQkbB1mb23ar3oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744790128; c=relaxed/simple;
	bh=JHr8jm4SpQUtr1H/evFPtWwdK3uzXFrh2zSLNDhRuhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E2ArBr1GjHEmjdbLAON7rb+HoiVtpfRmY4Bb4PItGr2HKEEeqYYF9rg3NJ8Y39eMaOfr5d7hxf9M76lofQozxe06/IVs0B8VcTBSKOtYQHc0WW2Jy3Sm7VGQn+tbFIl81+o8Gueivgb51zg2ROSgh+PPuMgobwI6drLHy06KL7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DPkwxQQP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DPkwxQQP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z4ImkPMPQU523ycyqzjrL8ve7cqt56BZMsA5wknU5kk=; b=DPkwxQQP+TfJ93xNDJfYehSWlD
	8B8Vr6eG5o1u5sQvRTMot5WODMIGtDt0hDm1lESP+8S86bw5HZqgBdtVmbx/dnlbMhFvfzK7e8pfL
	gM+N43B7PR6YE9NR6lJipqYPb6Cf+qFrdGzSt2yB+2YJI17C6NAbaclsdgBXsHHC87NWKYI4+5jtE
	PFq+tNGO8N+1BvlzEu5NzV3JmCp1xuN9MsF8AFzd1Tyw1p0HxAOUgakYOJfq8eU48bkEMoU2t42ND
	+JjmekeUj7dPeylkr5d1FzsvE4lrcaV53WehSDJzJahvP3DSBtDu0CsFJN050RI1t48Z41EuSecJq
	hIqF+RRQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4xbx-00G7qI-0B;
	Wed, 16 Apr 2025 15:55:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:55:09 +0800
Date: Wed, 16 Apr 2025 15:55:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zixun LI <admin@hifiphile.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel - add CRYPTO_ALG_KERN_DRIVER_ONLY flag
 to atmel-aes, atmel-sha, atmel-tdes drivers
Message-ID: <Z_9iXRZ-3sqUhOAM@gondor.apana.org.au>
References: <20250407102050.1747860-1-admin@hifiphile.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407102050.1747860-1-admin@hifiphile.com>

On Mon, Apr 07, 2025 at 12:20:49PM +0200, Zixun LI wrote:
> This patch introduces the CRYPTO_ALG_KERN_DRIVER_ONLY flag to the
> atmel-aes, atmel-sha, and atmel-tdes drivers. This flag is set for
> hardware accelerated ciphers accessible through a kernel driver only,
> which is the case of these drivers.
> 
> Signed-off-by: Zixun LI <admin@hifiphile.com>
> ---
> 
> v2: fix indentaion
> ---
>  drivers/crypto/atmel-aes.c  | 5 +++--
>  drivers/crypto/atmel-sha.c  | 6 ++++--
>  drivers/crypto/atmel-tdes.c | 2 +-
>  3 files changed, 8 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
