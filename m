Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF14446857;
	Fri,  4 Sep 2026 10:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516103; cv=none; b=oIP609fGcCeE4sAQ7jG/Z0pq79f6l6JjOFceocQQOYsqAuEKa387zP7mISQk9SPHSsFqFMddH1w0mC6LZZxqbSz6rBafUc15xyRAn2YCl8sdfhY20g1LJozApH08QEqRNGHVmvzk1claKcYkII1z6JaNMnD/PLjEvlg6/0dS+18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516103; c=relaxed/simple;
	bh=e2LwPM5bIyTWiTFsTIlnd/t7fRW1M5IYJLzKlP/T6lE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVARTM72vKedOqJPQ5FHceF1zoiKzYmBLdBejnDU7u106tuBs0vYPKoqd9HQJIABZDgBvFy3AitMNyVO7pgMQ5TMEya3/1Ht5dL1eU0nh++zegRbaZTN1ERvDQ0uqN5tZaOayAuWlvlQBIPNHbMnPIyurx70MuxN/e5tI3caumU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=J6YrDoD1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="J6YrDoD1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=bhgRyH9RGuN/2L6t4wfa5EYseJ/z8tmtpDQ9K/kjtLE=; 
	b=J6YrDoD1sBdq519/M/bxKvsGYZpqYPaog8ycGmX0y6akpv3SGt2cT7rX722vJIoau6v8zT0267G
	Nn1poqWAwtIITF6ZR4QNcuAkGc33+ErUNGLHrmYKp4BtCzlIBVGVuVdwdZ8JizsoxJcenlQNn63/w
	LFROPIixHIhL4jXbHAojK+NtLGXf92Uut035LIQTAhTy0H7Y3EPprs2fpBIDC6MRYXuJt78LZ88wR
	YtrkPVlh0E89Iqq4NFrxdpZ3OKCJ7VLAHs/+tM+YgAsuPGhDZlvnLsbkyaAmiaTu+ZUOO/O9D0HZ1
	/ohWNL7Mk+U/za+Mk1hMUQ6OgR8hhF5GXI9g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Qjp-0000000AnKm-1M1T;
	Fri, 04 Sep 2026 18:01:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 20:01:37 +1000
Date: Fri, 4 Sep 2026 20:01:37 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qce - simplify control flow in register functions
Message-ID: <apqXAef3a5koT9oF@gondor.apana.org.au>
References: <20260815150946.12142-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260815150946.12142-3-thorsten.blum@linux.dev>

On Sat, Aug 15, 2026 at 05:09:47PM +0200, Thorsten Blum wrote:
> Remove the goto statements and handle errors directly to simplify the
> control flow in qce_aead_register(), qce_ahash_register(), and
> qce_skcipher_register().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/qce/aead.c     | 9 ++++-----
>  drivers/crypto/qce/sha.c      | 9 ++++-----
>  drivers/crypto/qce/skcipher.c | 9 ++++-----
>  3 files changed, 12 insertions(+), 15 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
