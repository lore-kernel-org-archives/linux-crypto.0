Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F7313D246;
	Sun, 24 Nov 2024 23:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732490018; cv=none; b=WBpZvDHvayD80odmQoBJotegmEmRGnbNLY5xggKNVqrsvjiDASK0M6J64HfZNNqCNtHZ7/Q1ZyoR9RyFnmxpno7Qs/OttxQ4RILbX3A7j3ngwHKUSynG3APCaMpKTu1zMQ3GZGn3XIBYSwRROrjLhMx5W+ZmrPrVXsOuB52aJhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732490018; c=relaxed/simple;
	bh=JHUnnjmd6OaFYdcKTp20tiktkgxoI1YSFPMAF3hHrl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=muUcZl6mPrJVAw8vzznFmwjdy4ORN2/248ZPWpp6n92oxmZp9O60ogTiVJ6EvTYb41gG+69e9UsPIU7zI0qCX8s1/qw0v54IkGG617FyneDRJ2/QnSohsp4RDzRGIu2RKQ832kUBT9O/8RTM19gOamt5FOSPufQKZneQx6I7bac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oUZjO9t+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oUZjO9t+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zoDFH/wEtZZ6L3WftPAPhsC4ZbUVV6hIOcO0GRhArgc=; b=oUZjO9t++maWUXPJr5FQP4D5tu
	5NReK2IoNAdHAJ1l+HSOEnZiFunL4jCDOSn54/nKuj/lHiK/55rGhYe34cusEMIe4Bj6tMjIcBoQ3
	MmwdpIY0YJgd/tLIezOosLprjNpBYT0tCrOVDdctdJ4ah4DsLtUtpQ1kIkG2QFQ+mySEgUs/LsntF
	I+9QGF9fZ2yYKk43rQacTK8K/ZkAQdy3rfzvt7Lqj0e60nRMxL93XUid9TlzBquDwFIwCEQy5UzRb
	oWJiifwbwPzf3Lgt6WLljP/prEdLYjcrODN6UEaaRqkItYsFCWWTfpgrNPAS8YWHRc0gQJZX3QU4T
	tWD0fz5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tFLn4-001QQK-16;
	Mon, 25 Nov 2024 07:13:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 25 Nov 2024 07:13:18 +0800
Date: Mon, 25 Nov 2024 07:13:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: Ard Biesheuvel <ardb@kernel.org>, Zorro Lang <zlang@redhat.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug report] kernel BUG at include/linux/scatterlist.h
Message-ID: <Z0OzDle-VrrXf8rW@gondor.apana.org.au>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>
 <Z0A2W1FTTPt9PeI5@gondor.apana.org.au>
 <Z0BCtZi2YJywGJAk@gondor.apana.org.au>
 <Z0NTLDYJQC242GMB@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0NTLDYJQC242GMB@wunner.de>

On Sun, Nov 24, 2024 at 05:24:12PM +0100, Lukas Wunner wrote:
>
> Hm, my impression is that this needs to be fixed in arm64's
> virt_addr_valid() macro.

Regardless of what happens on arm64, you can't put a virtual
address into an SG list in general.  It's just not allowed.

In any case, we don't even need SG lists here since the correct
interface to use in rsassa-pkcs1.c is crypto_akcipher_sync_encrypt.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
