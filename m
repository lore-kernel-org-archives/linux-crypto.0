Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D211BD035
	for <linux-crypto@vger.kernel.org>; Wed, 14 May 2025 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747214560; cv=none; b=FhatkqSP1O2ZsSY68bXq9eR2LDJnBgqDSN61AWFfc5RQRLvisdsX1HYDVMRoNAxFFISTIkFiIExuJHeZTArF6RjkGRlJiwi+9jAueTIT3QmqRfrWL1rwkv+NVaCzAklR31sTuZ84ON676MSU8VKQUKkSE3tQYbUSPjYyFxpjpmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747214560; c=relaxed/simple;
	bh=+/LHkOlE4pVDMKXpcFLeiXLQw+g6QvbjO6ygOHFrzpw=;
	h=Date:Message-Id:From:Subject:To; b=shq2I/RGl2hNAnSmc32sPFgNcSfN7vVinxoEn38YKTJP5p6emk4OkTiDYIcFoB3YnOG2fXjSAef/bFI+hGWmSjC2mYBe1XR1bQX2o8ETn1/qEdNH6LQGlvF5bqISB5ZOSLF0Q32HPnWaPNH7SzRlHHJ3On76WJJHOYobmfO6kOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c9z3djVi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c9z3djVi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oAhWWW6ROTEG3CqrytkYkoM0XqJkI4mC+Qb+Zw5insU=; b=c9z3djVi+rU1UzPYYFHKRM8THz
	v4OPJQPTx6sJHVCRHEfq7sTZM4WY7nN6BATYEPIpLt8NoG2EnbQMv0yYGiJeLsoJ5vyOxPp5Ju/3a
	5UTa3ZEt/QLuzoJ6OJza//lcfVT/HZPobVVXKJBBvyNmxJ2AcKwlo2Bx7AsTajojg7H4dXylVrY/2
	z6TwnmKTUt1TvfkddP5rhHtgXbd2idC8ajFZsPfrcVhaURs0beBT9zmDurzjKnTR0KyrnttVL7Pcz
	ZZAn5iwdx7qUOcs1UT7BqVX2lTDKyLLaMWY8do6cPFKoCb1AIEaC37qfrhqevKF4UfacCW3nlSbwR
	YdQ/9BDQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF8Jn-0060JI-0O;
	Wed, 14 May 2025 17:22:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 17:22:27 +0800
Date: Wed, 14 May 2025 17:22:27 +0800
Message-Id: <cover.1747214319.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 00/11] crypto: Add partial block API and hmac to ahash
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v3 adds hash export format testing and import_core/export_core
hooks for hmac.

This series adds partial block handling to ahash so that drivers
do not have to handle them.  It also adds hmac ahash support so
that drivers that do hmac purely in software can be simplified.

A new test has been added to testmgr to ensure that all implementations
of a given algorithm use the same export format.  As a transitional
measure only algorithms that declare themselves as block-only, or
provides export_core/import_core hooks will be tested.

Herbert Xu (11):
  crypto: hash - Move core export and import into internel/hash.h
  crypto: hash - Add export_core and import_core hooks
  crypto: ahash - Handle partial blocks in API
  crypto: hmac - Zero shash desc in setkey
  crypto: hmac - Add export_core and import_core
  crypto: shash - Set reqsize in shash_alg
  crypto: algapi - Add driver template support to crypto_inst_setname
  crypto: hmac - Add ahash support
  crypto: hmac - Add ahash support
  crypto: testmgr - Use ahash for generic tfm
  crypto: testmgr - Add hash export format testing

 crypto/ahash.c                 | 572 ++++++++++++++++-----------------
 crypto/algapi.c                |   8 +-
 crypto/hmac.c                  | 390 +++++++++++++++++++---
 crypto/shash.c                 |  46 ++-
 crypto/testmgr.c               | 132 ++++++--
 crypto/testmgr.h               |   2 +
 include/crypto/algapi.h        |  12 +-
 include/crypto/hash.h          |  73 ++---
 include/crypto/internal/hash.h |  66 ++++
 9 files changed, 881 insertions(+), 420 deletions(-)

-- 
2.39.5

