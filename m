Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5304D38385
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 05:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744436222; cv=none; b=r5qYD6teXmEbPnbInrpvr3glFNUIpY6HCliefdZLJFUjzcOlDfkteATAe6clFIXFAmeRIL/2Oj2kqkV0KaTjzMqWlfo72VoN9aFF78OZyDm0MbSi6bU2aY2MeiqgjbjqYZB8eIpS1JnYXiZqGod0E2Ly4DPy7x0MI/DdkT5czTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744436222; c=relaxed/simple;
	bh=9RuPPPL9YK4/BDWvbtaRhpcMwkffVrgKMwb47+ceFGw=;
	h=Date:Message-Id:From:Subject:To; b=tWjuxyM7vjM9eeLkNJIXmMHpj65VNxSKUyndDCEp6GYtvjd/9EOIO82pAi9AOo+/VCNffstNVrmAl8XWNKaDHTESmLSvUbGxVpkTkciyPyBGUJeq6YnooVWE0k3rYWjGc23Ck3RJKYC8vMv4aiJhFCFnufu/frulnqyO+Z2x+zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SlxNANFL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SlxNANFL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oQXV7gx0+BD4p+P/phibv8JLfpOvLjdYctsVwyyoQbg=; b=SlxNANFLg1pv9pSVUvJcwguOB8
	BXWG50TJ7fuYwlj9TiqDtMWo24JSAZdW6sXCeXb43OY+VMntgBMUQu1mUdwkEIHxAO/3ABS/lN6Oc
	3ydi5VtQit9pf3gdXiawbTI6mlFUvaYc/fn1ZCMy44Grcqt5/BlTL/di99HS/QwyXXRwUNt/0h5JK
	Hoe+mQ8Wi/LvrJa48g07z3B+q462aQZjkiOqeleQRRbNSMhHxZUEV8dRH+JoWcRY/21c0e9R8d/Sm
	/XCf5mUVZNufPxU8TUTl0qZ7jjJPqPrsLi64HOExxoTEtlgmGNAQ1TW3iigxMD13OnfcF73+YBxDe
	w5QDd3VQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3TXs-00F2sD-2Z;
	Sat, 12 Apr 2025 13:36:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 13:36:48 +0800
Date: Sat, 12 Apr 2025 13:36:48 +0800
Message-Id: <cover.1744436095.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/5] crypto: Remove request chaining
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v2 rebases on top of the ahash chain disabling patch for stable.

This series removes request chaining from acomp and ahash.

Herbert Xu (5):
  Revert "crypto: testmgr - Add multibuffer acomp testing"
  crypto: deflate - Remove request chaining
  crypto: acomp - Remove request chaining
  Revert "crypto: tcrypt - Restore multibuffer ahash tests"
  crypto: ahash - Remove request chaining

 crypto/acompress.c                  | 117 ++++----------
 crypto/ahash.c                      | 169 ++++----------------
 crypto/deflate.c                    |  14 --
 crypto/scompress.c                  |  18 +--
 crypto/tcrypt.c                     | 231 ----------------------------
 crypto/testmgr.c                    | 145 ++++++++---------
 include/crypto/acompress.h          |  14 --
 include/crypto/algapi.h             |   5 -
 include/crypto/hash.h               |  12 --
 include/crypto/internal/acompress.h |   5 -
 include/crypto/internal/hash.h      |   5 -
 include/linux/crypto.h              |  15 --
 12 files changed, 130 insertions(+), 620 deletions(-)

-- 
2.39.5

