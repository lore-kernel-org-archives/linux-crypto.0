Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8341A42AA9
	for <linux-crypto@vger.kernel.org>; Tue,  9 Sep 2025 05:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757394057; cv=none; b=qi9p3NvSgKZoUo3a3jvY9HHMRSMn15/lJj/8tukZIvsjDA+34Ae7MOMA0OYkHPGYlvtR37Lzp3iRUGY7U+Kl2dKB4NeX2Vg+eQReKRrGBnKLfRPVaiR7yVFKUXmgKPYK1RjAenFq7jJB22jLW9m3fDdR+VAD/MpSutbUqzy/JDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757394057; c=relaxed/simple;
	bh=QPzBbB0C73iHiFf36sBz2yrUB/CVsdOMl0qXdXJeuP8=;
	h=Date:Message-Id:From:Subject:To:Cc; b=UukaDU05KIKxUa2YM4e8QmBeY7FMTGvXv3WJTuMbGsAw+ZOdb0Odim8wbHqfR7tEWh+H2U2HYf2o3jYS7eDr8X8PlC6M3RmhhY95blP+TN9KqI+IpWO4f5FK/GALnrQlxmFm1fHYWB7yR52MRuQ0rsIRK0ye05DXs7SU0jtcRZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HiBbySLF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HiBbySLF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TMf2aiIEPOzElp4Gjidav8LjKtJsVPDYMEaSDkIqgfg=; b=HiBbySLF1mlPWnBLVSIFaqY5Ap
	9dG/s2MFN1rFz7p7hhCPf6JNQFHsf3bYjj1aw9R1OQ8WVGFB8YR0DUIeT9nLuAEala4qFUZO2MczS
	NtVtxV885xLKyhWsCMDnxEONQ5TyVZbxMC/H4RHizgdor/Wg/e9Jyv7Vk7Znf1+9H0N3dqKOVlTNm
	eb6pareRX5TIFYOK8nYqcZtHgV2x+tnysN9+6Wl79nvQVhTGm1Xd4B5e+/wX9t5F6LRGhxvjXnKkX
	WinRiW4pcJisfMhg85/OXDEWgtpDvbPnPyIE831Ozcyo2g6SekJKpcUovO7NccVu8vts7VHwu/QUH
	jlBl6d7A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uvpo0-003pnJ-0G;
	Tue, 09 Sep 2025 12:34:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 09 Sep 2025 12:34:04 +0800
Date: Tue, 09 Sep 2025 12:34:04 +0800
Message-Id: <cover.1757392363.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/2] crypto: ahash - Allow async stack requests when specified
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch series adds support for passing stack requests down
to algorithms that do not do DMA on the request context, e.g.,
phmac.

Herbert Xu (2):
  crypto: ahash - Allow async stack requests when specified
  crypto: s390/phmac - Allow stack requests

 arch/s390/crypto/phmac_s390.c  |  1 +
 crypto/ahash.c                 | 22 ++++++++++++++++++----
 include/crypto/internal/hash.h |  3 +++
 3 files changed, 22 insertions(+), 4 deletions(-)

-- 
2.39.5

