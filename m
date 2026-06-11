Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EE738D404;
	Thu, 11 Jun 2026 08:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168041; cv=none; b=fBuo/4QJZyaxHMpf4c4Yg7nPBfNdImyqYvaKcVR92VKaMX4178A52JzyYlf9DNDUgGUtEPLkExR/4BZXT346/EAi3KqXE3VgkdM4iWLcN/Onw7YOJNruazLHAhytonsVOJ+hE7x1hz9AUdJA7h3nbeb417/kCg/UeA7JBeHYkgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168041; c=relaxed/simple;
	bh=/wxBMEUhN3ByWnFQe9UC6D4pJA1lgI719i1WRKwf77U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijLBgCalgriADU59TBANopUdr2iPhayW0Yno/pUqkuwbS2SyXcvitdlEpgDjowoetBZ6CLehPIxVTGm/vu7sbpOZdOM5kupDPNXDpgsRqLrMp53vu0G9rGEIW2y4mFwXpeTS2PG6/7RfqDSn5qSUp/9nFFv1842SvttbcdExX3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=FVQOzdz+; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="FVQOzdz+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=7RT/e/rEU6HtQrgQutT6dH2HWck7fSGFRVH+ob7Y5Jg=; 
	b=FVQOzdz+wvnLw9SCgjzPpZPLLufKeRL4/TWdQpv2RlD/PhCWDmMJOLlo8gJ/B59Bijw47SG20ZH
	2DiisZJrH5292MvKK/gdvfHBm63WGoLaVDXg9onW8swEllXwURN/7SVZXcyCSfNYIPJxbV+yL6AAK
	0n5GqtMMRfFiRglXlkx1n+k+XodNOta10gjlsPT7YAj68ULcsVXrWWGAFlIEMSasYWCMPyFUYeQvl
	iYjVCkJVwDbCDWIjwXVC/vY0pnD0AQ1rQc18+5gDoGgAza32POb3v7Sl8/FdYWv9gtdPACNRQ2o7y
	9/se2bWHCC5tT6nNmENp3LpbPCnAW2W94Heg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXbAh-00000004Xbs-2xVM;
	Thu, 11 Jun 2026 16:53:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:53:55 +0800
Date: Thu, 11 Jun 2026 16:53:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Felix Gu <ustc.gu@gmail.com>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Lukasz Bartosik <lbartosik@marvell.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: marvell/octeontx - fix DMA cleanup using wrong
 loop index
Message-ID: <aip3o32MIAMrrHah@gondor.apana.org.au>
References: <20260602-otx-v1-1-e0c9ec50cb04@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-otx-v1-1-e0c9ec50cb04@gmail.com>

On Tue, Jun 02, 2026 at 10:38:26PM +0800, Felix Gu wrote:
> The sg_cleanup path used list[i] instead of list[j] when unmapping DMA
> buffers, leaking successfully mapped entries and repeatedly unmapping
> the failed one.
> 
> Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
> Signed-off-by: Felix Gu <ustc.gu@gmail.com>
> ---
>  drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
