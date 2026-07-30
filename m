Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675873C8C68;
	Thu, 30 Jul 2026 07:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397253; cv=none; b=FjD4NuX1BTtt5KEMmkBCNOHV2waw/lf1EYZ0MMcMNME0li8PIZWFSMZDlOjMFr9CeqDVViMAbzenogPxJnmVJ+PrFMmQrr+stXbPPcwLyfo4Ug8NzIp3QgmccTnSI+SU8sqV5Sl3HyX4w8UTMB0BofZJMPoo96WD/gCxeK0/HxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397253; c=relaxed/simple;
	bh=r1uRJHXZl9JQTJf6KqB3+ixdNUsearLgvqoKpeYUW24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RYFALZeOAg/jIa289hLf5Pf3a2m+kwSBGwJxzGJxlG5DFCD7awQVdtMpfc4+sY08xQSrYmBItIrs2HEJ9UihX0r8gdn27iqEzm3bwy50LdUegBmXc2QxJ8dv7e2z7R8K1xVO0nag+kjb/yd5AnOuu+rHvRYINo2LifZ1EBlIrqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gMyzSscK; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gMyzSscK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IK9dCHSNTpVy2ZRTYGaBFRHT2Kts5WFfu4T5v81xuUw=; 
	b=gMyzSscKqbs0+f0d0BkthuLr+RjT2VP0eE1lUUiJHZd9truxL0t75v5gFTcIXYmOL23PSN6MHxb
	nsBanewJndGU7x5N23kmB1Lx7HfCnMizwuWGuEB0vyLbB3opCppbR0aWUSm+JMcnWuPeIjVxxbFL9
	SN/sxPlcfVLia4fyHV9utxPDwjgDBwloojp+eB9zX5erknXkBVawLA49t0jtz1GuyUjoLwUP/f2E/
	mUD8R1LKs7QvHruqgtmcmX5YW+JYIVYj370Tsu+cff+/d0vNqemHIpKr2FmelbLmvKj7C+EfLYX4W
	urP6lQAi8KShZuq8lzVSCj5ig7HzqoBJM/9A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpLNm-00000000Rxn-39Qs;
	Thu, 30 Jul 2026 15:40:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:40:46 +1000
Date: Thu, 30 Jul 2026 17:40:46 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: bcm - use memcpy_and_pad in ahash_hmac_setkey
Message-ID: <amr__ndnhqoxNb5S@gondor.apana.org.au>
References: <20260720232249.117992-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720232249.117992-3-thorsten.blum@linux.dev>

On Tue, Jul 21, 2026 at 01:22:50AM +0200, Thorsten Blum wrote:
> Use memcpy_and_pad() instead of memcpy() followed by memset() to
> simplify ahash_hmac_setkey().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/bcm/cipher.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
