Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EAD296D04
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 05:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747288477; cv=none; b=OxJD8lAlaJRg86BF05rTfFk7br4IhLO9MwN7plO9AepwLw31Mi3l+qrIUhftYAQBAQz7B0DYW03ibyUrUixuD/lfmJ3XXM+bSZCAm+Gd5Xfhb6pQBS8sxERFAsSPpIN+wky8ysOLUjM10y5QB6+Y7B1EZW5N1OevYJJS8WQmU9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747288477; c=relaxed/simple;
	bh=ARdQ0qCRthhh2cTsArQ0hXjM9zV9CCP+tpEo8iX67q0=;
	h=Date:Message-Id:From:Subject:To; b=Mj1VeubrxheRupG8cE6TUn0E8ILGG98mJ7TeHNUqSciSOxz8iS7K/Dm8IPQToT3x3BFj4oDogpUs/IsI7BSkehnQEqzk48ciA9MS23d3D7Oqi17RKt4CdqHZB7caPAiraUfYF2s546wC/DnGuLZfNG8otrGFIX+tk9qWFbCjy+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mxFlV0tS; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mxFlV0tS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=arJKPE4/KJfJUkM12NBlBmdGyDYpcCkZVpoQcdSGMnA=; b=mxFlV0tSPVov1US9CzyIFw/b71
	Orxrnrob8qr/FonvgQQFZxakcZfdN1dxI232p5zSx/rl9V+Md7Dbe/IOKXe9fAeMTThOEdDbNxxB3
	/3r0av+8Ej4iWjKBOhQn3iNyo8Ho8vhMbRYaImQnYdMl9dFWA+HX1FO5LIyTaWrjsDB75P9L7k4eT
	3e26HHbXbEpejSPLSnV+VCvr+4oKDt1UVKpvhJt2vfVs4lG0qhYArKEzaNZN35/Pq39s+gA19cau5
	RPSgJj2DiNZpdMF4Jxrg3hSej+E8VaKAwpRtIoYlbhcxrZWHjMECytnl6H0ApJ3hcVyuoc+pU6R/G
	Vp3WenMg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFRY6-006Eb7-2Q;
	Thu, 15 May 2025 13:54:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 13:54:30 +0800
Date: Thu, 15 May 2025 13:54:30 +0800
Message-Id: <cover.1747288315.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v4 PATCH 00/11] crypto: Add partial block API and hmac to ahash
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v4 switches the name of the hmac shash and ahash instances.  The
ahash instance will bear the hmac name while shash gets the driver
name of hmac-shash.  Add patch to silence testmgr warning on -17
for shash allocations as it is expected.

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
  crypto: testmgr - Ignore EEXIST on shash allocation
  crypto: hmac - Add ahash support
  crypto: testmgr - Use ahash for generic tfm
  crypto: testmgr - Add hash export format testing

 crypto/ahash.c                 | 572 ++++++++++++++++-----------------
 crypto/algapi.c                |   8 +-
 crypto/hmac.c                  | 392 +++++++++++++++++++---
 crypto/shash.c                 |  46 ++-
 crypto/testmgr.c               | 134 ++++++--
 crypto/testmgr.h               |   2 +
 include/crypto/algapi.h        |  12 +-
 include/crypto/hash.h          |  73 ++---
 include/crypto/internal/hash.h |  66 ++++
 9 files changed, 883 insertions(+), 422 deletions(-)

-- 
2.39.5

