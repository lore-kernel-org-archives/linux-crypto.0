Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AD21A071C
	for <linux-crypto@vger.kernel.org>; Sun, 11 May 2025 09:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746954577; cv=none; b=DbZgYNsyAzud+xWkq5vCkSRED7AiZ6artZ/VqjHWbOQQ4kKPh5gZogiP729P6emENX8dQ1vIfaOOUz+a4AbTCZA1fiJDnUztS7jzQPgRoq1UeE9Vbba+7na6S6GOl8zbsb2elF78zQtOVcEoFcrA3ohWa2McDdxJUofSVqUSlnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746954577; c=relaxed/simple;
	bh=0SwktNyJt+XpHums8FGzgqAjzqIiUGpigThPfpZUets=;
	h=Date:Message-Id:From:Subject:To; b=Wqe2Fh1hRurkX6wA4PmiC06fNLOI1WoIm3zrG5IsKlmKdW2rqYttRfJ+QDeNkOxu2fCBGnpwjyQ7YQGUi2kFj+kvNiv+l8Os8gWs5FKicTkYr47vfw/jWFpZtLlVH0dXqUmxZX/mVmAQzUaaqp/FziFpoec1Ut5t6umoprp6o+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oOBJ/rAx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oOBJ/rAx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=n/ZbDviJGYTMQxQ2+KdD76Sc8nDFyR9hAuc9lN5OuWQ=; b=oOBJ/rAxMe1Bcciu1zxr5T/rFF
	A0erZdVA9S1F6QN1LveODfasTzZv0YjMljwK4IW0RjXW/LYCXhiZla80YhwIgiOBypCrhwh2h04mb
	Odj/P+4vqvJbgKTxAbKBZl9SZaubrYtQx40RLPt+egivWPmO+TyGRTv4W3KCXP+jcNiXAYw2hbeWK
	U1i/mhQQlzJZeDQpA0orNXm+R38z6oTWLuzIVwq1F6AghMsT/F97jvK+iZ8R+Lqff5av3hFKaulxd
	qqlg9SIPPpQ9W7DCuoA+Hq2wO9cru1wmDM5YKx9LX11iNMOx2d7aM1bvsFxIit4SwLhtIM7v9QP2K
	dQwPbjrw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uE2gb-005COs-0l;
	Sun, 11 May 2025 17:09:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 11 May 2025 17:09:29 +0800
Date: Sun, 11 May 2025 17:09:29 +0800
Message-Id: <cover.1746954402.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/6] crypto: Add partial block API and hmac to ahash
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v2 fixes a typo in the virt address fallback handling in ahash.

This series adds partial block handling to ahash so that drivers
do not have to handle them.  It also adds hmac ahash support so
that drivers that do hmac purely in software can be simplified.

Herbert Xu (6):
  crypto: hash - Move core export and import into internel/hash.h
  crypto: ahash - Handle partial blocks in API
  crypto: hmac - Zero shash desc in setkey
  crypto: shash - Set reqsize in shash_alg
  crypto: algapi - Add driver template support to crypto_inst_setname
  crypto: hmac - Add ahash support

 crypto/ahash.c                 | 554 ++++++++++++++++-----------------
 crypto/algapi.c                |   8 +-
 crypto/hmac.c                  | 353 ++++++++++++++++++---
 crypto/shash.c                 |   2 +
 include/crypto/algapi.h        |  12 +-
 include/crypto/hash.h          |  63 +---
 include/crypto/internal/hash.h |  57 ++++
 7 files changed, 666 insertions(+), 383 deletions(-)

-- 
2.39.5

