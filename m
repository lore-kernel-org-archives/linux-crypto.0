Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2C4190468
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744454867; cv=none; b=kxBvmXYYf1dt6LYeZQOMQJGK/YQaTXeVlyemUeWVBiqSX0hPtiLfzowGa23uk40Vj7J/tjNYkmTlmACUA/r1BR29DFx9R5YTr/qlbagD3Quw0drBSMghfZb0foLvUmpO3hgJivFJf5deKeansuKibEO1s9Lm0B7YM1kYfJF/aIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744454867; c=relaxed/simple;
	bh=eYia4oWsPLxDS+9nTWFQqn0uUNid/WbQGa3x5rbouG8=;
	h=Date:Message-Id:From:Subject:To; b=h6u1QgJrEcoyWvXyG6fy4xXLzeAqnLG8MyjjecnBzquMxs89CwiZUzy1ibPpRebM5mlA3vwBgv1yhBRDyhgQ+/rPq/bPkCAtcOZQidP/J6VI8rNfUzbfBUribi46NAxN7GEDVyACj05gxWbzXfDym1GDbCdbWcCMgrip6z4oLJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=s88+bKWm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="s88+bKWm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=40T9dGEcPvbOjfYo0nNkXkrKdZdMRGtK/KIJmPxs3L4=; b=s88+bKWmRd0xJ6Qi4EBnkxzaKi
	dSR4mP+Ij0Jqsx4LodiXOi8XcN3MVUI/5hvfX/aEE9615ye0QjWHbjh5DRr6TKqwsEs/9kYVaJS8P
	Z+i+bwK4qb+6cO6BQMXVJl6meMcsdaEov2VXSfmp7VQ5u7xQnwfMIVzG8ZV2R1EUmcFp6BkqK1Aer
	bzVDH6X1hEVc4UsErkihtAtg1qJKECQ7WGSazSmWmmGI+5T7B6INTbRe/BAQLOE2BXMdnsOMI3Ejy
	SephpwUE4Z2IJo7ZPlj1hq18YZot6Cbz/2ZuquTLckSkIYspzcdSjsM6GchWnfSIwnyXNV127wLHs
	e/zQDDIg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YOg-00F5De-0H;
	Sat, 12 Apr 2025 18:47:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:47:38 +0800
Date: Sat, 12 Apr 2025 18:47:38 +0800
Message-Id: <cover.1744454589.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/4] crypto: shash - Remove dynamic descsize
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Dynamic desc sizes were created for fallbacks.  However, it's
actually never needed in practice since the only shash fallbacks
that can be used all have the same descsize.

Once the fallback cases go away, its use in hmac becomes gratuitous
as the spawn descsize is constant.

Remove the two fallback users and then fix hmac to use the spawn
descsize.  This allows the dynamic descsize to be removed.

Herbert Xu (4):
  crypto: padlock-sha - Make descsize an algorithm attribute
  crypto: zynqmp-sha - Make descsize an algorithm attribute
  crypto: hmac - Make descsize an algorithm attribute
  crypto: shash - Remove dynamic descsize

 crypto/hmac.c                      |  4 +---
 crypto/shash.c                     | 18 +-----------------
 drivers/crypto/padlock-sha.c       | 14 +++++++++++---
 drivers/crypto/xilinx/zynqmp-sha.c | 11 +++++++++--
 include/crypto/hash.h              |  3 +--
 5 files changed, 23 insertions(+), 27 deletions(-)

-- 
2.39.5

