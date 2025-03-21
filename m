Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E891E571A
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 08:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742546619; cv=none; b=HBu0I6TyJ5ksFGJKZZYyaAl7heAdd3EZZrei5cPbBfbvP7b8Qt7CEBidKodtY9PmHWgkb2I2LrzlQO+Fg+VbiQp7wQ31mnDtT3h+MXcJ9ethKt8r+R8z9bV8TJfyge6S7/dSTFKN6bGj6bY6inwNX9M/ZZE0NhOqbQS6ZehUsas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742546619; c=relaxed/simple;
	bh=ff5YoT9VlHSSeWmdc9DHtmodsQ4n3aF8hkiaM4O613k=;
	h=Date:Message-Id:From:Subject:To:Cc; b=B7EGV066xbgvUNjcqLo9fdfvqqcQVlFz1JzsRnFX035Bf74bJoUGnPudoYvTwCFQwD+u5xkRl90h9bS1jrbh/qSj7GQo7rK2/2fvIKr425a0DrIpw6gCERu4gNxX9yfq9+x10Z5zg7v7ZNVNA0gKxp4iiXIv0MJLDA5wHVdYAaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pDkpBPkF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pDkpBPkF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TVl1MnT6P15TqmSUbd2sBl4dVfUn+qHdRrbGNwYetJs=; b=pDkpBPkFWhHR3nGYDUm/MOU5zG
	jG4328rGQruseOu5q2JFBDBMhJ1clvYjplZoj7Ot7LUaKF+PLPu+muAf2FeXiHO3H0B1SX0kQvTph
	VC+tGzmyQdQtb5DMyCz6P2VCcMRNEAeHk0F7Fj7cL+MQ4c/EbyMaEe36g7BkP2FmTB9DTo+uYWmbS
	DeLznTDQcadznp+wnFyZyb1j02Sb6yXEyht15xqBY8DlSd+IbqkSDqjfRwWtG1WzPh0Gl16mAqVku
	txRGfg2EuPTerboDegvrdGXJDqmMUMQa7sY+3/OGxKcERCUCVwgwJfbO73WAlhskhORcO4PL7LEb0
	tUMBSToA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvXyP-008xvJ-3C;
	Fri, 21 Mar 2025 16:43:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 16:43:25 +0800
Date: Fri, 21 Mar 2025 16:43:25 +0800
Message-Id: <cover.1742546178.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/4] Fix synchronous fallback path for request chaining
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

It turns out that the fallback path for synchronous algorithms
is broken for ahash and acomp.  It was difficult to identify
because a separate fast path already is normally used for shash
and scomp.  So to reproduce this crash, you would either have to
create a new algorithm that is synchronous, or disable the fast
path for scomp and shash.

This patch series fixes that particular fallback path and adds
multibuffer testing for ahash and acomp.  Note that you may not
be able to reproduce the crash without disabling the fast paths
or adding your own custom synchronous acomp/ahash algorithm that
does not support chaining.

Herbert Xu (4):
  crypto: hash - Fix synchronous ahash chaining fallback
  crypto: testmgr - Add multibuffer hash testing
  crypto: acomp - Fix synchronous acomp chaining fallback
  crypto: testmgr - Add multibuffer acomp testing

 crypto/acompress.c |  33 ++---
 crypto/ahash.c     |  60 +++++----
 crypto/testmgr.c   | 302 ++++++++++++++++++++++++++++++++-------------
 3 files changed, 254 insertions(+), 141 deletions(-)

-- 
2.39.5

