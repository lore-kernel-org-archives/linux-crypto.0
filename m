Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19838821;
	Sun,  2 Mar 2025 08:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740903085; cv=none; b=Q2tE3DtAHfFDt0x/+NGKDCXSZ/83tHYe7CjE1eJXccGpJOBPZsVuo7Ui4x6QsBRnVUBX/+BtHIFnN7WVDqFO9nMIuoHNGUgFAV4MOJbykkyhTve7qORBjMuUs8x4TB5b1M5uTMRDLQyujWUAOyKWdB7LfkMgAFZw5TKHpV6BzJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740903085; c=relaxed/simple;
	bh=Oj21fHseDZRxUGv0tOmdZH5fOZw2vpGrmKO2kt8iFpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkVSc0524CHwWHKooQZc1DpD14wfVqu3eyTYtH+Qpnr9Sly679wqXhr4bgBx5+5YNbOv9hfJdY9PHki6kdAoI1oVBr0JiE1fzUi+4hMhqzETJaKU/uAZwXO4r0Z+w6o0x4tQVcowjnrnGltJpHH8FE1q4uApjSBnDnjJZko8204=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=A64tvFv+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="A64tvFv+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZUQr+pM4bGTUd/BqvBzzLNb5rJImjNN8i+QOGKG80os=; b=A64tvFv+7lwDUu9ln4DGcoGLnj
	dd1J79+ybo4J4AprGKH89ToxnOx9KicgYphGQmDxn+W/DWdW5iMdUKn1IdBwtCmjlv/kBFulOMCRu
	HpSK2wEJRG8QjP+RJrj9GscGwQobcJloH+nHKuIg1rNf0SexfGwm9L2AOcKcCPfDF83nFOT2mAegq
	K4Z2x04kZ9w45vq6PjyD38wLXx4NmmSlA03GRKbv5u/gQOAV5Q5Ly1mVLb2SfoXeNojkjRAGcw22z
	RqTbzXU6NoeOtm2yqmBp/rFPX5/Kf1NwHtIPZXHJ+kDQVeeYzAAweEPSu9FK/uAc/FTalo7rtddXi
	qJRj6Seg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toePm-0030pn-01;
	Sun, 02 Mar 2025 16:11:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 02 Mar 2025 16:11:10 +0800
Date: Sun, 2 Mar 2025 16:11:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Olivia Mackall <olivia@selenic.com>, Dragan Simic <dsimic@manjaro.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: Fix indentation of HW_RANDOM_CN10K help text
Message-ID: <Z8QSnbnIPaqJd-Qr@gondor.apana.org.au>
References: <54eae580e3ee5686db692dd6c0927b23134a1cec.1739977165.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54eae580e3ee5686db692dd6c0927b23134a1cec.1739977165.git.geert+renesas@glider.be>

On Wed, Feb 19, 2025 at 04:03:32PM +0100, Geert Uytterhoeven wrote:
> Change the indentation of the help text of the HW_RANDOM_CN10K symbol
> from one TAB plus one space to one TAB plus two spaces, as is customary.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> While commit 67b78a34e48b9810 ("hwrng: Kconfig - Use tabs as leading
> whitespace consistently in Kconfig") fixed some indentation for the
> HW_RANDOM_CN10K symbol, it did not fix everything...
> ---
>  drivers/char/hw_random/Kconfig | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
