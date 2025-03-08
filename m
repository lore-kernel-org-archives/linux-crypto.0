Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162072744E
	for <linux-crypto@vger.kernel.org>; Sat,  8 Mar 2025 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741437926; cv=none; b=k7SxVuoc0TpXplRkuup88CVZBrFTxO27bVwhGU5k1AlcdvTQ+mgBXz9A8QSoYVuolOdSI3itfbDFhkaH4MH/GVSSQx0n3hl7edvMrvnjUanv13fghYSXPhcmIfb0ivj9W+Hy6VwGynLC51v1WXcvUSc14lhP1lu1cB7FmDjBQrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741437926; c=relaxed/simple;
	bh=XFuYhjIQ7qGwi0dD59Wqlh2yXP1oTa/VacAq3V2N7yk=;
	h=Date:Message-Id:From:Subject:To:Cc; b=FizDQZQKl0ZmeD6/xPHrRlAelHc329jaLZd9Vt2BkTQf50CXD6zIfqO730cwIdATvhoaE8it6B9NEhmjU/I6+0uSipq7hreE0dfuPuCrvcodd0FYY7hr6fJnFf+OqtNv46fcAFJIUHZpJifTtFbAcSQ4DrMJaKGaFIzmuuAC7vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MbNVjLRN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MbNVjLRN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DqOrOYuO1uxJATvC4JNln4bqfSN5l9g8sIZIBBAc6Y0=; b=MbNVjLRNs12C2hTlzFV7rsWWeC
	UeRvClWWQo0MvTZnGHipHdqEy5XZ5o4k5/xREfLjg/PyAg9VULpfOKXuDC6SrB7ge/2NRNUsuvBDg
	Xqlft/io86fbVZ4WnGrHABLR/qWNA4kijo8OIuxVzvgVlT7R4WgqAE7WsCUNPLKMmxRqTom3jS8XP
	6o7PB/NJmeb9hmh4OdHdyFwe4RhxDJSPeWYJrenNBZ+pZeD2CdCIKhtxkOAS0up+UwX2iKyHhh2f2
	Xe20L56iapuTpox3DMWSo05c2GKovIJbAwCMv3xQp2wSKN2QYefT4wAA16HqY2Q8QT4qHzn3YAKZ+
	Ixzpi6BA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tqtYM-004r8w-34;
	Sat, 08 Mar 2025 20:45:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 08 Mar 2025 20:45:18 +0800
Date: Sat, 08 Mar 2025 20:45:18 +0800
Message-Id: <cover.1741437826.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 0/3] crypto: scatterwalk - scatterwalk_next and memcpy_sglist
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v3 renames maddr to __maddr.

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

