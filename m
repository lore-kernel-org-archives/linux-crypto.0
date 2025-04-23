Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C580621FF51
	for <linux-crypto@vger.kernel.org>; Wed, 23 Apr 2025 09:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745400154; cv=none; b=rGACloJ9cXMDwpg8Li4+eA/5sLRRjTMjGpodPta/CFlL1Qs7It1YD4N51paHGmIeFptRfWf0E3uJ4qFeGsVi/FOOcF+dJgHrIx93ASFBMQICVadIRP3xN5WpaCQFyqdRitqaIIrZiGZKDr/CcXXpC2BiqELOqHq8YvVc/RijbSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745400154; c=relaxed/simple;
	bh=pjY1aCVsw5OGK9B+xHCBXEt/84tNCoKSmnP4yDCCfYs=;
	h=Date:Message-Id:From:Subject:To; b=Bdqv5sIyDRERMBMGMLPpYlPBwgkT7WkaiZQzj67j4zmqUFReasTa6ozPRdKyIE7+YyHOxw6ZcJbwMIf3mbesYV1xl+KhlM9wFGDccxGl3e2QEHqMUZ+BnWjPHySKuC4FOxsgIyc0cSFFaa6x3yrHmWJovFUglkMu8v5s7qmHDEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AHhkZ614; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AHhkZ614"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5O2NZKFNEmGY7IRDQ+SdTKnBYrqmutqkRkRXmJxzL1s=; b=AHhkZ614/PFaDwtQYkRY9uQzxM
	qC8dtgSXnggpGLf9IJO6JWY45zin4xUESRVDtNkgOVhZG5R1cgq9C4YbUnKv7EPgDRj08LAna+big
	6jO1MbW0syhZ1mph4qTmqJVela0i/SYYDGjUFXdIQ8STq3UBl9mLuW4U5Ox82FEpUHm3S+hmK5lfk
	XLb3jDxoxZTI3zVvAjhUyfOC1FJ6Mp3MDMb3NBOWPJHHsEuURZkNfdSbKZv7/EEVtnLKoCFXOGWHN
	DkO1E2sogZIJ5AF86h2XGRxPCgiHtstlD42YRcoDK+PWHWJK180LZiGVdKsGNmBlqosZVmCY4ntdF
	375lGGdQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7WJG-000LDf-1g;
	Wed, 23 Apr 2025 17:22:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Apr 2025 17:22:26 +0800
Date: Wed, 23 Apr 2025 17:22:26 +0800
Message-Id: <cover.1745399917.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/2] crypto: api - Add crypto_request_clone and fb
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This series moves the common request cloning and fb code into the
Crypto API.

Herbert Xu (2):
  crypto: api - Add crypto_request_clone and fb
  crypto: hash - Fix clone error handling

 crypto/acompress.c                  | 29 ++--------------
 crypto/ahash.c                      | 51 +++++++++++++----------------
 crypto/api.c                        | 20 ++++++++++-
 crypto/shash.c                      |  3 ++
 include/crypto/acompress.h          |  9 +++--
 include/crypto/hash.h               |  9 +++--
 include/crypto/internal/acompress.h |  7 +++-
 include/crypto/internal/hash.h      |  7 +++-
 include/linux/crypto.h              | 11 +++++--
 9 files changed, 79 insertions(+), 67 deletions(-)


base-commit: 63dc06cd12f980e304158888485a26ae2be7f371
-- 
2.39.5

