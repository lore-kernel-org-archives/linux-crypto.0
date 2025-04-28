Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB431EA65;
	Mon, 28 Apr 2025 03:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745809746; cv=none; b=SZYSWT3nX7qObDtK+Uu5P2NASzX1xVx63njPGnaauj+FtdUN2pNqlK/6zOdbDzjcQW/lcZ/SRQ3ZxATrabM7tPpDCznvUkN2E1LouCNfGI+o5Q0d5Bv3h8iFKhWBPLH4EV2MQavxo2Nam5cdAKHp6HBZJs+PuNZhkfE+/kkhSoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745809746; c=relaxed/simple;
	bh=iLTEHCZSyJzcBLSrNbt97hFYVdaUqh8fJjiDPwHlhPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5Y1rN1qFFs8HcH9Ya4BuBEhVu2CS0yogR50eAFWYtHKJTCg2TdQA0XCkZu73wGrba7LVR9mSOM0CoWxN2f+q+8CQDiDxDhSakOi1glRN+ErJ7QptpxanGiWHSiqvnMVOmbnKHXO36KPLwEjHVTHC13v9Mv8B6qUc8ZIkBTY0Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SQkVXEkc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SQkVXEkc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J3vzUMnOsLaNzEHK42kIA445AJiwOm/XYFtRR4x1Ggk=; b=SQkVXEkc3vuSoeiHUmoL/qBNUy
	ysWSAblsbuvUOG359Wyk/8nWoScXQd4L7GIJ4Xd38Hcrj2DR/a8pmabQhQWHVazQcejXNpHsyTx1h
	h/hBQpNTKVok/u3+xY4E14431RXX10DkJtH35PSM2PeKugoHN+xXUWPEWscOwg5Dwhs61VBuKUffQ
	4Si1gvfB0kxo1fWQxO2/ox72IJsK4hfGGpCJ0J2gDDJ2un/boFeEENZZtHe/JqpcaAYV0Q00tIET8
	xWo1iROXM3b9xws4ee+6hhR7Yr66v541/IhLwjgXTLCirHAfiEGSxh9ytC5afOEKx0eB3hrNWQihe
	Phc+NUCA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9ErR-001VTp-0b;
	Mon, 28 Apr 2025 11:08:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 28 Apr 2025 11:08:49 +0800
Date: Mon, 28 Apr 2025 11:08:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, jernej.skrabec@gmail.com,
	samuel@sholland.org, wens@csie.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev
Subject: Re: [PATCH RESEND] crypto: sun8i-ss: do not use sg_dma_len before
 calling DMA functions
Message-ID: <aA7xQbuV2oOU1oFq@gondor.apana.org.au>
References: <20250427111236.25668-1-clabbe.montjoie@gmail.com>
 <e147c220-92e1-40cb-920b-916cf6703b40@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e147c220-92e1-40cb-920b-916cf6703b40@gmail.com>

On Sun, Apr 27, 2025 at 09:23:40PM +0300, Ovidiu Panait wrote:
> 
> On the other hand, multi_v7_defconfig has CONFIG_NEED_SG_DMA_LENGTH
> enabled, so sg_dma_len(sg) defaults to sg->dma_length and it would need
> to be used after calling dma_map_sg() (as indicated in the comment from
> include/linux/scatterlist.h).

In general, only use sg_dma_len if you are mapping an entire
SG list with dma_map_sg.

If you're using dma_map_single, do not use sg_dma_len.

This is because dma_map_sg will try to merge entries together,
thus creating an sg_dma_len that is bigger than the original
(and reducing the SG list length accordingly).

OTOH dma_map_single can't possibly do that.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
