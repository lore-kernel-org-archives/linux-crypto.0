Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADF922094
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 06:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742364303; cv=none; b=nzroGjC/BgaTX5uuCo6a1C1ufcxT90PK9TDtZxl385OhwBC3qGvnNEKzJ+vibbwZpQGZWihFBC4EhXrWjZG0kQPGz/IvDev0KNDzVJyzVuvuqgRBNeJtliycxRFd0oDffBF5s0h1FGt2xNO8KxNt75Phi4SLpoJ3uNbORK/Jbzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742364303; c=relaxed/simple;
	bh=Q5HBmxfBO1f/zkUdCsmHNHOQfeCqbZEMmXQ47c3UTMw=;
	h=Date:Message-Id:From:Subject:To:Cc; b=pbFznUT9Lh2Lz6knHkRjKf0LKKk3YPIEaRsX9inO5HxZf6CxJoKWBipVL+ITjPAtB8ZuvadjdRHXfTUlbb44wCzwSYuYuJVZaifoTicob4MpwdqY3Git48ZfZDOENwE92HL22GxkGD3OctgTGhhn7gReQayno1iQsPdwxWkCcjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mOtWm4Bb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mOtWm4Bb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3aL9FIhVYh/b26b/S1eH8FzYHx6nO6oebFLQM3ibbZg=; b=mOtWm4BbUWn+ooGT6gbogkWST4
	PDeqrpywUwIbVQ8BbVFTzt/BLzDOhEmPviYodtvtdc76uJ2OIA5CcEsvFhNrb2n9CXCEajIr7Gc1U
	KaTQ+y3DU7TXjxIn1IaDcw9VABs6Hntw6l1X/gmL656iaFVxQM5wrkJI2VejOa4+c4D8xjJeY3//F
	+wzJtTKmAmjpZZZgISDWMChUTZFLdD6qkdEf+QLtHbkd/zCJme6D8lRWZG1OLMBBxKmeYW09TDyQe
	FBkNUrDF6to5UEcdFboW+Ccy8A2DLMv1LecCXTj1l3HIK6yw31ThNQ2KI52gaLaMary71NetBMKvl
	kl6AHPtg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tumXp-008IUS-31;
	Wed, 19 Mar 2025 14:04:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Mar 2025 14:04:49 +0800
Date: Wed, 19 Mar 2025 14:04:49 +0800
Message-Id: <cover.1742364215.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/3] crypto: Add SG support to deflate
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch-series adds SG support to deflate so that IPsec can
avoid linearising the data.

Herbert Xu (3):
  crypto: acomp - Move scomp stream allocation code into acomp
  crypto: acomp - Add acomp_walk
  crypto: deflate - Convert to acomp

 crypto/acompress.c                  | 228 ++++++++++++++++
 crypto/deflate.c                    | 405 ++++++++++++++--------------
 crypto/scompress.c                  | 133 +--------
 include/crypto/internal/acompress.h |  77 ++++++
 include/crypto/internal/scompress.h |  28 +-
 5 files changed, 534 insertions(+), 337 deletions(-)

-- 
2.39.5

