Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD753AC2B;
	Mon, 21 Oct 2024 05:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729489528; cv=none; b=I1MVKydp3jewVsLOmI2yp2yvv/jW9C3VcJnWZx72NkK7UskrZRXD5NNJxYhrzmILZknAhlZhCzse+SqbxIhRheZmLi/yXOMmRBfc+NSlYD3wlTTwWYGUj8U3wNBtJ1mEW2OyAGN7dj/YGFsjPgZJMimHmtVpi8TbyUKYQUO0QGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729489528; c=relaxed/simple;
	bh=JYptBPQHNhYtuULkGTLytaSxU6CUjpd+KMr7VtVcKo4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EJayNxklWgNvrB94vCrRy2XUxUkKxk7xpeh09UWzVBh9458yuCiq+qM5HN/1eGwMalVkPOGDzKZE/ZYJd6CiNPbEq6mwaDoA4AgCix3nMpJzpyTiGMctJIxyzF2WyB7THV2g6lwPyBiKIOtJjPzzWZbR1kcZz4bVh+lrUSwyKcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OBf6E359; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OBf6E359"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8e5CY7Lw/x8fmDP71xfC89X81csXiRTOwuB+hVJ2ets=; b=OBf6E359TH4gO6BUbXBr5CyBJJ
	POuol7Mx/AbpM/CQZ3t1KzTJCQPdSr6+WSDwPuowK3c4kpZvxZuomMpwP9dvtM9v3YsHqAEHK98io
	MThH+satmC8F4X/olQAv83l2hLE+pH85C5oVZwbYH0JKaZX7qZf5NOeohPAgOyfRMZ/k4xgohBzpb
	9x2CvlIkEhMcjij5Gjp5OupFZu0SZq4RjBknR1Yz8RMOA3TMQ/rAqzGgFy8ZiuPeM0tL2tWMnWfPz
	0UYRKw5Q1OeRfMn0euOUPfm8hmUfs0c33rEpkUo3TD3yfRBn+7pttYr45qbWUl+ppTvwEFOzzq4ZY
	99i+qQJQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t2lEC-00AsBQ-0W;
	Mon, 21 Oct 2024 13:45:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 21 Oct 2024 13:45:16 +0800
Date: Mon, 21 Oct 2024 13:45:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.12
Message-ID: <ZxXqbFAO9VN3ugIR@gondor.apana.org.au>
References: <ZEYLC6QsKnqlEQzW@gondor.apana.org.au>
 <ZJ0RSuWLwzikFr9r@gondor.apana.org.au>
 <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZbstBewmaIfrFocE@gondor.apana.org.au>
 <ZgFIP3x1w294DIxQ@gondor.apana.org.au>
 <ZkrC8u1NmwpldTOH@gondor.apana.org.au>
 <ZvDbn6lSNdWG9P6f@gondor.apana.org.au>
 <Zw9RM_jNu9vqp9T8@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw9RM_jNu9vqp9T8@gondor.apana.org.au>

Hi Linus:

The following changes since commit e845d2399a00f866f287e0cefbd4fc7d8ef0d2f7:

  crypto: marvell/cesa - Disable hash algorithms (2024-10-10 17:03:35 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.12-p4 

for you to fetch changes up to cd843399d706411ff80520fb7883afeeefa76e98:

  crypto: lib/mpi - Fix an "Uninitialized scalar variable" issue (2024-10-16 13:38:16 +0800)

----------------------------------------------------------------
This push fixes a regression in mpi that broke RSA.
----------------------------------------------------------------

Qianqiang Liu (1):
      crypto: lib/mpi - Fix an "Uninitialized scalar variable" issue

 lib/crypto/mpi/mpi-mul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
