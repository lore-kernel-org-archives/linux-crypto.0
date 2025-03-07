Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793B513C682
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 03:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741318582; cv=none; b=RO+AOgs+vYqVwTBHEZxYWK/cdEr8v9MOmshTY/k+q26OsQi0iO3ngLeyUZaiuC3c4PVKgwLIZ0d9TgxZJpgPKW++DHczzeVVhyXVqjiQE1ak2amR0qA6rAjCMgc4nZw0PrRRM9fn/UJM9upqMTWLdcqP5Wb7vJ4vtuJXdgE5i8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741318582; c=relaxed/simple;
	bh=4r2Y3oM34Ko8M3PBjd4AQF5vsG5hCVANy0OL0lSNh7Q=;
	h=Date:Message-Id:From:Subject:To:Cc; b=nTbS/9v5qJk5OKu+2tYq97JUm2h6dO4LBWjlzcCwSJe0gheSQX7KfIYT4zTmhfzzAqy45icKGqxpzPKwoj7JEDWByT7Jedy62kpo0+kIZ98rzw9DGlFBs1efWQLSJ8xVklkvZOjJgm+AjUlS4zF9JiZglyAi1P2umJMq7v9eO18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JegJ2HZk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JegJ2HZk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8YNc4xETYsgqJ8/G9F9hIYKacUXhxJf9zfaXeZ9XCsI=; b=JegJ2HZk/YW2wPOrB8jVUZWrg9
	JwHNRpg4Phtr+BdNV9ds6TzNkw3ALGRFXnfMAhxZ4QQECnH0KAaTWUZ87Tfl6ji1FeyDgPb8aK47w
	3AqJmPdkjkrySz7TAQ4cPzxAVmkgfGLeQS2MD0u0xIZIALblc00nxXKuXrKEJUNtVPAGQyswIbO7x
	KSeZ7/GiqNzy9+dGFsqhdmntQ6oPpnAuIA+aswAQ4kOvpJvXv3tSaTpSq6xm497jrk6bItIz3nYE3
	pQbypHkizQIbOO6Hb8n6ZxgpaSGrna1YNxldP2TCJSCUPeOVW18G7gEgJhYde0hUHOr5w3cYdG1YQ
	Yjcvg6nA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqOVS-004UaA-1T;
	Fri, 07 Mar 2025 11:36:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Mar 2025 11:36:14 +0800
Date: Fri, 07 Mar 2025 11:36:14 +0800
Message-Id: <cover.1741318360.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/3] crypto: scatterwalk - scatterwalk_next and memcpy_sglist
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v2 incorporates suggestions by Eric Biggers, and makes the addr field
const in struct scatter_walk.

This patch series changes the calling convention of scatterwalk_next
and adds a new helper memcpy_sglist.

Herbert Xu (3):
  crypto: scatterwalk - Change scatterwalk_next calling convention
  crypto: scatterwalk - Add memcpy_sglist
  crypto: skcipher - Eliminate duplicate virt.addr field

 arch/arm/crypto/ghash-ce-glue.c       |  7 ++---
 arch/arm64/crypto/aes-ce-ccm-glue.c   |  9 +++---
 arch/arm64/crypto/ghash-ce-glue.c     |  7 ++---
 arch/arm64/crypto/sm4-ce-ccm-glue.c   |  8 +++---
 arch/arm64/crypto/sm4-ce-gcm-glue.c   |  8 +++---
 arch/s390/crypto/aes_s390.c           | 21 ++++++--------
 arch/x86/crypto/aegis128-aesni-glue.c |  7 ++---
 arch/x86/crypto/aesni-intel_glue.c    |  9 +++---
 crypto/aegis128-core.c                |  7 ++---
 crypto/scatterwalk.c                  | 41 +++++++++++++++++++++------
 crypto/skcipher.c                     | 35 +++++++++++------------
 drivers/crypto/nx/nx.c                |  7 ++---
 include/crypto/algapi.h               |  8 ++++++
 include/crypto/internal/skcipher.h    | 26 +++++++++++++----
 include/crypto/scatterwalk.h          | 38 ++++++++++++++-----------
 15 files changed, 140 insertions(+), 98 deletions(-)

-- 
2.39.5

