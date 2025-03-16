Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E5739ACC
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 09:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742118633; cv=none; b=kneOAEm2v84d2gx3000aSmm2lulJvLer5H/3biHpvATMvRrui1EvmI4jgwTmnT/gZJ1NWDqB7//tRvAUdn6pNoxhqyicXhphuY/uqvcHSfX1Qo2xSLG6bQNhVuccrAIcIn0iXFR/rpqh9MYdDp/mRKsvkJG+czuRGsR5s3c2m2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742118633; c=relaxed/simple;
	bh=X5TEGFpf/LD1tMGDAOr6biesHYun2y3Om/OjrkNjqZQ=;
	h=Date:Message-Id:From:Subject:To; b=Pk9bCGMRVUk/lBOrVozZ2O/aE86zEHnHFX+2Paf3C8XSwDP0y4BLr9nwH6xJAkvgxxz6rrtOlFD2Bf94BW+PTyExVkHU5P7alKoxog1O/5JzBTziJW3isNaowUMerkTezGPipIDwtfIKcNzrYK72UqpLF5NcVQ4Pbmd8gsTkrLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=i4iQ2Fi4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="i4iQ2Fi4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MenQ0Ac6Gwi7xqm7CLAXaD0emuo/hPHkX2oRAJ7ek24=; b=i4iQ2Fi4vX6xzafvnJkPASchEQ
	kidItEc2COsAxNQBLZ43WR5pyfsDUJNTmtO110Ym1c0YN6sOXEVpi5+ZWDUL5toQfmEwHC0eXkEr9
	NCEzdZA70+J4W2hRWelfCWZyAZg6wM7oxcSyTwQu1fhKmUgVTliGkeuUZrcMOtcrmX1Jc1F8lwlgZ
	aQp/zlZ0nehj3VGyPLb75NfrDm6/A7C/kfMbFj17Nmxy6mQiXFvB9tlA7Kmv4FexkgdxgIQFcJ7bd
	F+HV3FkI3arndnjoIGaZa6t8gZlkGoI8wC76PuZfDlmVA/tjzV5PQiVw8+x9IdaZA0SqHn7wtJXh/
	XvBa1F+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttkdP-0071Mg-2Y;
	Sun, 16 Mar 2025 17:50:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 17:50:19 +0800
Date: Sun, 16 Mar 2025 17:50:19 +0800
Message-Id: <cover.1742118507.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/2] crypto: scomp - Fix memory leak on module unload
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This mini series fixes the leaking of stream memory when an scomp
algorith module is unloaded.

Herbert Xu (2):
  crypto: scompress - Fix incorrect stream freeing
  crypto: api - Call crypto_alg_put in crypto_unregister_alg

 crypto/algapi.c    | 3 +--
 crypto/scompress.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

-- 
2.39.5

