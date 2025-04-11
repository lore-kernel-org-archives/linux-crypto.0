Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFBF2572;
	Fri, 11 Apr 2025 01:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744335398; cv=none; b=B1r5NwteWLLDYdOquhLUP3V49CpdcUQEp+L0CdH6/+7J1AaAh4O0s7GRo219mxFtwsItVJlHZcoLttBeLgJOgKZ3wx44ilvBCicUTXODXdajC/sSk1Cuz1gsN+j6Zzeo+Wep7Xl7/OklO4QkAF7WbAObKhNERxoxRQ2+GKdu1F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744335398; c=relaxed/simple;
	bh=fQBdgq71zwqghA5hM7H+yifMZwkDFJFJPay74hhV2JM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ffEw26stxrn5AXgNjae8XBKfvInLu6bv53tbcTiXlHAOGf0JJYI7Bq+ZMLvXt9mRKJ/ddYNbbShYnZaBgZZ+ebxDTcKOVYweo2hRvmSaO9e1hpzKQCU/cCU5o2HTsugXgjIQD4jfwPrKDRxOX34+LsQOyXJGOgp6b+6lULNzNUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=o2t9rEns; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="o2t9rEns"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=k4mUhMPnz7n/1tUD5l57xPqlwJeX3gxYXuVwlnKsorE=; b=o2t9rEnsz0XaMVHxTRRQQ0kp1J
	NFje4aH/Ahhdauh8NI0Cxu56mTGYfSgyGVfOOZCR9kDXBMUbNNYRLS2j+IGExAsM2awsu/P8eG4S6
	qlreGMTT8UH/6WJC84ETQh9STryGoXFp98hKQxgfqeKzamwrsE+SbJaSaedn3gi1p0v1kNgjCqORL
	ct0Vv0e8IZzX4A6wDpy1U3WRfmpvzBFCa0sNaJ+dX5crpyPrboEWYu7mPrIwGweVRSvmtXfl05l47
	qeNEB8aitFVkRSlBFI9nq/PRfY2q+hlp5RZMIU1ePEcuJ2fyxk+MLakKT8s5YCddLp2xGqcV599Vr
	vakScJeg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u33Jj-00EiB9-2r;
	Fri, 11 Apr 2025 09:36:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 09:36:27 +0800
Date: Fri, 11 Apr 2025 09:36:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sean Anderson <sean.anderson@linux.dev>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org,
	Valentin Ciocoi Radulescu <valentin.ciocoi@nxp.com>
Subject: Re: [PATCH] crypto: api - Allow delayed algorithm destruction
Message-ID: <Z_hyG816TRNGoSaP@gondor.apana.org.au>
References: <17f9af67-de10-4b96-99ef-3c5cd78124c0@linux.dev>
 <Z_SxYFdyBJTYe_7G@gondor.apana.org.au>
 <e3dd2f83-8451-47b0-a774-a697b861ceb3@linux.dev>
 <Z_XiPLmSVs8PGTZD@gondor.apana.org.au>
 <Z_XpfyPaoZ6Y8u6z@gondor.apana.org.au>
 <cf7e20a2-dc30-4940-9abe-bbf5ea1ac413@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf7e20a2-dc30-4940-9abe-bbf5ea1ac413@linux.dev>

On Thu, Apr 10, 2025 at 07:24:25PM -0400, Sean Anderson wrote:
>
> The above patch didn't apply cleanly. I seem to be missing cra_type. What
> tree should I test with?

The patch goes on top of cryptodev.  But it won't do anything
without a corresponding patch to caam that moves the algorithm
data structures into dynamically allocated memory, and adds a
cra_destroy hook to free that memory.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
