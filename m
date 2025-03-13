Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00A11EDA32
	for <linux-crypto@vger.kernel.org>; Thu, 13 Mar 2025 05:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741842898; cv=none; b=TJpoJzzA4QYEF3gx4TaIE2WM7GSHOcoaiCS/VCmLRfjk7swN9w8sCWLl+C+Syl6OmJL7E+fukMP4AorOhyHgNSBPy7CX3XMbOQ6cDPeuhQcMbLkRMS1ThIoOhP6FPogWNU5yQbKBqX7rpsPjCvmm8dTFVw2e9GiHdih2TxM1X2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741842898; c=relaxed/simple;
	bh=6zrOYFcFh7GuX7axx5yqDCmnoEHY+maa6VTvynDSAY0=;
	h=Date:Message-Id:From:Subject:To:Cc; b=KywLS09r5IrokC4jmLLG5alxvPq+3TySHZRD9zhCYrlNaSTkVMDSu3UQ7tLzXp6BYk1omSUdeN7CsQ7/VS47Tok9ae5NjNcFcV1dgv/091xZGGQyWROp8rO+N8ZZNevoC34lkVSEXODiMbOy0rl0zB9uqoG1SQsiCs0rW16zEn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=SCQ+5IJ4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="SCQ+5IJ4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:Message-Id:Date:Sender:Reply-To:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Vpef4dYK/FvMH7HfJ1slCteGXnZRJeaNL4u0emP9MTI=; b=SCQ+5IJ4Y/LYcH/hGyzTWM20Lf
	2YAxnXyNw0d6FgU/EKQ4NnbW731LYZtXdw4ioLtQnTjNeyMUoUsf3qDlyAmKdDEdjv7bu83Cs3GDd
	CfC8olObFKFdhu/Lb+aL0uFrT0/7sQDobvjqE+xuwM2ivbZkd3FEkI4VVqmuHue5aHqlaZ/stpSf2
	CE+viYjvX8mFsFbCHN/cx5nTVucOrecN4EXl54vIjiLYqWp54qhKuY9yDE2YrkEF4rOwbHgHEl6gK
	U962cTaGi/RVF3b2tj9Ea/15M47Z1fyNLhrSAhpu0rxRxk4WwFmgqKnq4B7aGj1fvq/ol9fblbg19
	Ub0ayCwQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tsauB-0068Pv-2A;
	Thu, 13 Mar 2025 13:14:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 13 Mar 2025 13:14:51 +0800
Date: Thu, 13 Mar 2025 13:14:51 +0800
Message-Id: <cover.1741842470.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 0/3] crypto: Hash scatterwalk fixes
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

v3 restores the krb5 patch and adds kmap_local support to sg miter.
Also remove nth_page since it appears to be unnecessary.

This patch series is based on top of:

https://patchwork.kernel.org/project/linux-crypto/patch/20250310172016.153423-1-ebiggers@kernel.org/

This was prompted by using nth_page instead of incrementing struct
page by hand.  However, that turned out to be unnecessary so what
remains are simply two bug fixes.

Herbert Xu (3):
  lib/scatterlist: Add SG_MITER_LOCAL and use it
  crypto: krb5 - Use SG miter instead of doing it by hand
  crypto: hash - Fix test underflow in shash_ahash_digest

 crypto/ahash.c                   | 40 +++++++++++++++++++++-----------
 crypto/krb5/rfc3961_simplified.c | 35 ++++++++++++----------------
 include/linux/scatterlist.h      |  1 +
 lib/scatterlist.c                | 12 ++++++----
 4 files changed, 50 insertions(+), 38 deletions(-)

-- 
2.39.5

