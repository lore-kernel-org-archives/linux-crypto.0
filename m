Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93FE22094
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 06:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742364587; cv=none; b=bsgzmn5YgVG3sUw70WOIcHKlC30qlOSe7bj0aOGAOzMR9o7dnwe3FnGvGoBMb3SHLzRq97o5p+REjIxrZ3UmmMe14Xvq9gqPNyOxVPcg6iE3UqCA67MhaZj5tEEmQdq1AioHNCl/kWKpuSJNEt61RaMTgoL5XbfTovGtyO0am8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742364587; c=relaxed/simple;
	bh=5bgkkkKfuGmBdlUgvABQ2QD+eyVu69idjjCmcXrT9J4=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M/T6ScWbIVFjOwe0ZH+jjfYnkwAA00xznnBj+jvaPnIkD61xnRGLe684APLf77EkqVM7xk2pt/9ez+3QXoK+pSVOJkknGQk+oZBc262BayDdf/72lU2KwU2S32iN8l9Var7XW+GDLDNhHk992ZrVWruBKfhlwQOnSwkpcWAWHSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=I6NlySZr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="I6NlySZr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0+XD6O8xyedMl3AoWHmggCqGRCg3RUoU+Yrl2lBdlqk=; b=I6NlySZrui7AHrrREe6aF7nOto
	+ijiB4T82ijOTtgAH68+X9XgL8nJP0hc4JNto/+yVwTrnlXXgo98eAB0kHDZPKZBAxf/tplffJ/gF
	krv4soGGuvg9vZEXKH1CCgna2G44zqvu0LrxACOx1nZq0vw6sVCFL3Ij786YUi5K66vmW9/H2tPrB
	LgodPbuOYvm00G5Ro7GvyY/wegVXWvBFqzK5+ItO2WRwxrO17SmgszzyFZA5tE9aR9Z2pAf1EzbgD
	WS2NwYWoc5Qz6a449FJl+RKl9KyYaBwI/z5UYw3Qs+4r9AKXMS9Wzsf7ZM3nQw7TnygSIx8MgZC7m
	gla+PmUA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tumcW-008IYY-2G;
	Wed, 19 Mar 2025 14:09:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Mar 2025 14:09:40 +0800
Date: Wed, 19 Mar 2025 14:09:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jan Glauber <jglauber@cavium.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Cavium and lzs
Message-ID: <Z9pfpHP783E3W6pz@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The cavium driver implements lzs which may be used by IPsec.
However, there is no generic implementation for lzs in the kernel.

This is important because without a generic implementation we cannot
verify the driver implementation automatically.

Unless someone is willing to step up and implement lzs in the
Crypto API, I will remove the cavium lzs implementation.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
