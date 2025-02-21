Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937BF2036E6;
	Fri, 21 Feb 2025 09:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740129840; cv=none; b=oqgq+PwjilyPSqFfvLjhDz7XREorfEp7iX7YvgsMr8+7FHxxrUqILIqwqgWodibTRDN6PcRys6U7t37MiDJby+kN8g0d8Q15Vxhc4dv70YK8Lkh9iIYjNCa23EAahyyPMIkEdRYN09RD7InKBu0ZCVu6XPsNRcvQau4Og81T9TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740129840; c=relaxed/simple;
	bh=VTqL2XnC5htnZiKF5ASywBWWTl4Tel6bubj25oDkTgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVasmdAC/Fgym6HqbaNYTxVbZ1gvUl4HEe4gHOf0dHqpFrxu1xysDJSqT4V7Xb0zzAkaK+GOeMqKgtdH8AmE+oeZhCgaQcFeNYb9JXtumMTBy3CEm29zK8TxRhqiW7vlkbhpNwy+U+xtC9IgalZyNOEJ5achixuS6mFUToaQJLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jZD5AFoU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jZD5AFoU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y9aW+uSlw899RI1Ws5DGQNOt3u1p2nKiuPgW2U6+1sQ=; b=jZD5AFoUSKiuFfFs8EWzCea1nq
	s6YMIqpyjK3DypitcAdoh9CvHiikU2VXk4Ru1t7BlyJuPzHNDV4dJf2f6MBOd2PHk4X+xdVdcXekB
	y1czngYJ9YbeHFyOvuYoSz6VOHWh6AxjDKQF7RPJQmNYFRG2v59HEXclc8PCzFPOCW2t1BrjOXOiC
	VA+VAALP24HLW3+feEcIMPaWwAILcn0xu0oRtJeGse6NELDgXWFYA+sgfWeuxFBOpgOagmEOGMko3
	def3IxoMWitwjr4ENy/rLtvm9W/teOh2F1+UBigp7wYhkDVQC1jXe/F6cVCdggbTIrS3WHvbddASH
	qwJ4NH6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlPGC-000YM4-06;
	Fri, 21 Feb 2025 17:23:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 17:23:52 +0800
Date: Fri, 21 Feb 2025 17:23:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aead - use str_yes_no() helper in
 crypto_aead_show()
Message-ID: <Z7hGKAehdRV4OswO@gondor.apana.org.au>
References: <20250211095255.520170-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211095255.520170-1-thorsten.blum@linux.dev>

On Tue, Feb 11, 2025 at 10:52:54AM +0100, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_yes_no() helper function.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/aead.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
