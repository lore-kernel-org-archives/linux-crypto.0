Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA9B29346E
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 07:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744357128; cv=none; b=NdSAf1Dm6uO3R37nEAHm1xL+hcxxJcsxTwImvj+47Xr+wxaeqD5fkMV4EAaF33wMg7b7NrMEuUXZSiDsD1L4s8h5Arm/sQWgOGKRkN3TSV2r4xzXRDdwmVVjPcz/0eUNdMr7f6s4qrRUHAnDHyEe/ypT5o7W+lGY5EBd2qmB7BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744357128; c=relaxed/simple;
	bh=bKT9HfW1O29t5I1z3yaThlYgC1GHA+9Zpu5rduGgdso=;
	h=Date:Message-Id:From:Subject:To; b=Ul/fQPj/PDhwWRuoP0AZsTgoR0dexC0ZM2VgwaEDlKWvnn3Gcdrpx8rEXrilIE59oMlm0lRrSrvkIJTMqE7NIYz0F1eYvqSETqgIlzBvhSgCdf9JDWvKEGjfGHB1YzDhAAWfoqlg9uXfY/+W4/90a+b6fTDsZN0xQsEJC3hG6pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=svc5gNhE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="svc5gNhE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:Message-Id:Date:Sender:Reply-To:Cc:MIME-Version
	:Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9ZKTDkMHf3d1THF+O9ThGHTz+u8wNMovO+PUECfHaSo=; b=svc5gNhEmpAjrrEgTDkZwm3o4m
	bv5L2xsGLYr+Aac86yKCr32hCrXM86WQr1gcUPcVRrTPiHJMfQoZpwV1bTq47R6HaMqN6x/6qpkhf
	dcH3bRK9jD1/o1FOG/gGb+9EfVddNYD/p4xxaaT4ZmfTcpLJK3YPRG8P5XoPWTdMRIqIQpINaUIJz
	INbzvDPs7U2SjcRNguuTpOEoGPrdCFKphQG+mo/efdzMb7lWoNFKhB7cyg6zDM5XpNFLmKfxKjtTF
	LM4rGCyJrEgX9YUdhXTEpwuUImBRE3qdVHTi4dJYj4gWI65g6HNvjRL2FzaN0ojFx3S+sejEo9HOL
	7Bh1PCnQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u38yG-00EloD-2y;
	Fri, 11 Apr 2025 15:38:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 15:38:40 +0800
Date: Fri, 11 Apr 2025 15:38:40 +0800
Message-Id: <cover.1744356724.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/4] Make crypto/internal/simd.h resilient
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

If you include crypto/internal/simd.h without asm/simd.h the build
may fail because may_use_simd isn't defined.  Fix this by including
asm/simd.h in crypto/internal/simd.h.

It turns out that there is a generic simd.h, it just couldn't be
included twice.  Thiat patch series fixes this problem.

Herbert Xu (4):
  asm-generic: Make simd.h more resilient
  arm: Make simd.h more resilient
  x86: Make simd.h more resilient
  crypto: simd - Include asm/simd.h in internal/simd.h

 arch/arm/include/asm/simd.h    | 8 +++++++-
 arch/x86/include/asm/simd.h    | 6 ++++++
 include/asm-generic/simd.h     | 8 +++++++-
 include/crypto/internal/simd.h | 4 +---
 4 files changed, 21 insertions(+), 5 deletions(-)

-- 
2.39.5

