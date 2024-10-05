Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F7E322B;
	Sat,  5 Oct 2024 05:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106184; cv=none; b=OCO24ejchXaX8fb6j6x2SpWynP9r+4S7rewC8EnYxhplbVyMuinn7P5Jt6z1v8jbvFSDmutcpgkx9Sc7ugKSLUZ3kfRp3RmHTRJEUzzJTyGq7eGWnWb5wmDOkYVicN1DinaJ6ygHEQV6O7YImZvIjEB1hXhg+IsUBb9HlT7WQGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106184; c=relaxed/simple;
	bh=mIluBhSVaAAZ85GoTd9dKYLsIfMXB8BikfEvmvGa6zc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=SpKQjFmDlaNda4cK1G7CD8WEIgbSY2RblGoqr2YMIIjN/2miBuOUSP5Mz2zQZk4Mt1YtoudJXHPefQ1/X3Ru7IkQ786QReS0rTOVA+oldvZVgyku9eCLDAa4fxSevdvtBUmUvJ57bf7pdvPy0mQR7fMfXMGi8gd7MVsSD5B2IYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=f+BallSl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="f+BallSl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bgduNDVUW7IvjOOcmNkqrjQO4EKeMg7qKlVmi8rGSvY=; b=f+BallSlkzMTTgal6Cr+VOLySp
	nhwyNsi6o9+VaxF3sUOA2ymt649gi5QTyQhhycL8RLD7d7z7xWXn5g1n7xB7J9cw8fjJumEnxgBEX
	aeRQsf3zTIBHKYmG0MpfmABmjPV46c6QSF4twBiOl1U84ZRfWW+7oyuG9seetZHq9Da/+obbqD/Mx
	qBVw8D0t/Ni992msyDcC2W4IA9Huz3re843hB2un15Fa1IvDw02Ol7TRgVu785v3EoAohch/G7UWu
	UsW2zju5w2VXyhiQZ87yrBZCobAK8d4wlsu0lPI7zEVJ/OwV7FqKh1xU3Y0zZET3HyUwol1Ut7Anm
	HV9ANv5w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxCH-0071T0-35;
	Sat, 05 Oct 2024 13:29:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:29:31 +0800
Date: Sat, 5 Oct 2024 13:29:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: clabbe@baylibre.com, davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	tangbin@cmss.chinamobile.com
Subject: Re: [PATCH] crypto: amlogic - Remove redundant assignment and error
 messages
Message-ID: <ZwDOu3C70Q1MwG-l@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911121751.1900-1-tangbin@cmss.chinamobile.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Tang Bin <tangbin@cmss.chinamobile.com> wrote:
> In the function meson_crypto_probe, devm_platform_ioremap_resource()
> have already contains error message, so remove the
> redundant assignment and error messages.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
> drivers/crypto/amlogic/amlogic-gxl-core.c | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
