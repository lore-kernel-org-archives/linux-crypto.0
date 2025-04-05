Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA4C2E62BD;
	Sat,  5 Apr 2025 02:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743819808; cv=none; b=mDFxbZPej6W4NBQBjDpGMGtkFo4IILVronOiTDHlcS9jy2n/L4mZuKFBHYea8ZnZSlApHfZAYVy70FQkuboZigMS9YzGkpgQtum4OyUp47yaTuW5+D4DgOjk6V6jkAAmw1efy7IlVEayUQI/b2yt2ZxmXxxw+pJ+Mjsecx2NZ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743819808; c=relaxed/simple;
	bh=79iB+q5guGsFJTVjU62Rx/G8rbhA37s+4KYQojqccaE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qhNi087GNOH942TRV+4KmoIb5s1GZbp5oLR3p+xhaRPPiBk6DEpWWvnglJN29n+YMkTxn0Rr+O0EdUfUJ/Hmwi3dLI3OZepBZ6di0RFy0ha4gDVdp+afHWWULAG6f0s9JDk+OpK7Qbt9HpQ5dDppZfZ8Gbokbv0x0i+/0MYpnwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IWRt4z7/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IWRt4z7/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yqIiL/YsL6xZjLIOaV8A3+UIiac9A/otviMuXI9F/Zk=; b=IWRt4z7/1C+jJMsmnTwL9DjZlV
	iHti0kPFeLe1x7BJFs/j0Lt/mYtyMnxvXQIzB5VAjeRVEPIRKhB0SCozDs/MOR4+eT6dS0j8AB8Bv
	pHZOwb+NLONn9YU+taTbd/v+PdqcatyBKXr33RevfAGZPHCAVn0CVzzpF7eYgTQ4J+9ktC/8AuziX
	0/gzRgYGxuV37mJZ00e7LqZwRVt1WQrtl7j0oFPFI0AZeLmpzDotPuGhwE7tOyf2oakqoew6IehwT
	6GpI7yRg27U8t8MwLSsBkgVwARbEeAT9agoOXt5QtJH959/zhU14y6p84Wyg/RH9t7YzNGaVjhnxd
	G9TarFUw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0tBk-00CxkN-1y;
	Sat, 05 Apr 2025 10:23:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Apr 2025 10:23:16 +0800
Date: Sat, 5 Apr 2025 10:23:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.15
Message-ID: <Z_CUFE0pA3l6IwfC@gondor.apana.org.au>
References: <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Z11ODNgZwlA9vhfx@gondor.apana.org.au>
 <Z-ofAGzvFfuGucld@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-ofAGzvFfuGucld@gondor.apana.org.au>

Hi Linus:

The following changes since commit 9764d5b0cd0ea4846fd46c7d0b4238ea122075a9:

  Revert "crypto: testmgr - Add multibuffer hash testing" (2025-03-30 09:39:57 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git tags/v6.15-p3

for you to fetch changes up to 12e0b15b1986736af8c64b920efad00c655a3c79:

  crypto: inside-secure/eip93 - acquire lock on eip93_put_descriptor hash (2025-04-03 19:04:33 +0800)

----------------------------------------------------------------
This push fixes a race condition in the newly added eip93 driver.
----------------------------------------------------------------

Christian Marangi (1):
      crypto: inside-secure/eip93 - acquire lock on eip93_put_descriptor hash

 drivers/crypto/inside-secure/eip93/eip93-hash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
