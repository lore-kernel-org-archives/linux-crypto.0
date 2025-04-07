Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F92D230BDA
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021261; cv=none; b=RwZ/jn/nXf3lwS/4/x6scN/IdYyz2fPSqF+nc4eRpHv8toraQFhLFZ2mp43ol9NBd6/JHu5F5PW2Ug6vZJPKQZ5726++akESTsE7GApG+aTYItebMW6TQciEC7IYnp7rgZlsHIypu0xhnNx+Qlblf/lx+YZsi7Y5RKfV9SDPVnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021261; c=relaxed/simple;
	bh=Zw/ah8hzPYq26LjtBZuBjcyq+pxHqT4A/tZwfu2+mD8=;
	h=Date:Message-Id:From:Subject:To; b=C4m0tngHmO4i7VXoUO3fdzVJ6bbb9OzRQYlZjck2AbrU2BRefD2m3qOSxnlof0t7r32Zm0SG9RLHOcR/uxlH9dzgsCbSgRl+HIFw1OH3Jx3huyQrnM1xIGsTplWzx5XZ3Y0iEv7ND8pQA5hA+upjcql41NgUKCDNFeW66EGdfLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GmoD4EGH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GmoD4EGH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=T1XKbLZo6VCD/AeZHoA0YxLJYjzYk0EDPfADPWqJc1A=; b=GmoD4EGHrreyfxDEXytsn11Koj
	NbpgVWip5uPDvSmnHMi+feqJnYISTUZq1etcVtFStZgYiVaUGRHQ0nmD8UcgNGlTiz2Cop7K/uZNA
	MLDY6e0VTyqC46wsY+jcSjIN9ezzCfknGe8LgqssoFNgmOA8BKjOnQ0PyVSOhYNikQRkKgZLcEaoO
	7ssWnin/QNh0NJmp8rmN5Os5oAIpEMjfM6NElXIQvuA0zPls6N3yPrhbjAyiyWDRe14QfPVLtZbuW
	XW/40QRkr0kMINZebwBQfCQs9S8CN3c5+Lsfwzc6QhllNam2JDmrQCtiZ71ebenEzscoPy+dq5e7r
	beNYkCNQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jb5-00DTYu-0c;
	Mon, 07 Apr 2025 18:20:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:20:55 +0800
Date: Mon, 07 Apr 2025 18:20:55 +0800
Message-Id: <cover.1744021074.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/7] crypto: Add reqsize to crypto_alg
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch series adds a reqsize field to the bas struct crypto_alg.
A dynamic reqsize was needed for fallback algorithms.  As we will
switching to synchronous fallbacks with requests allocated on the
stack, this will no longer be necessary.

Also document the fact tha cra_init and cra_exit should not be used
in new code.

Herbert Xu (7):
  crypto: api - Mark cra_init/cra_exit as deprecated
  crypto: api - Add reqsize to crypto_alg
  crypto: acomp - Use cra_reqsize
  crypto: qat - Use cra_reqsize for acomp
  crypto: iaa - Use cra_reqsize for acomp
  crypto: acomp - Remove reqsize field
  crypto: ahash - Use cra_reqsize

 crypto/acompress.c                            |  2 +-
 crypto/ahash.c                                |  4 ++--
 drivers/crypto/intel/iaa/iaa_crypto_main.c    |  2 +-
 .../intel/qat/qat_common/qat_comp_algs.c      |  2 +-
 include/crypto/hash.h                         |  3 ---
 include/crypto/internal/acompress.h           |  3 ---
 include/linux/crypto.h                        | 20 +++++++++----------
 7 files changed, 14 insertions(+), 22 deletions(-)

-- 
2.39.5

