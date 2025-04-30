Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77801E32D3
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993194; cv=none; b=GJLLDul6+DsuHmETc5QAugekR6jZ3YLzCO+2oy6iHd9b8SirH798PNCOQ08rDlNKIpExRLMo3wbztzGgStx2GYofDJ7E3q2oxJfRfyDla+XFkt/v4jPUe7ERBMu/4mmt3ywNaAeoEWUJwI/5qCSYvkTvwKyHSLbSlFh/oc+Pwx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993194; c=relaxed/simple;
	bh=DaYDqmhza6s/uBIt+LiFL5CNp9aX7SMF74AzzvVxWM8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=cVM9ewYlQS+p2JMf2tHB1f7yb1qVa+alttIB/wKS/IG15FkW5t2B2bcpopwkRd83G7QaWhdUF2N5BFkpy3T50dqP+meAb0kjMcpBRz24SFuRvYkEWIqFi2D1AzhtCfe2YXOdqH6N7qH+qx4vbX03YrGK97NqrJEo29JyNL1nxIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=slnri1Gc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="slnri1Gc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2IwvIr4oeEU+S3gLAzVDaKGglLN037XH+F4FYsQHjyE=; b=slnri1Gc4pekyKlBjk5ahTVUJs
	BkayWHntuRKZg8g72JE7v+1yuB5qJPFezxBsrmEi1NzcE8OjSNxmX527CVObIGSeSoYSA3T1zTump
	1SG4znUQoHlIIcl7et3ec1hBxxIOntWts4/rVEqIdO9FImE/TQxjNBmAMapU8pG/Cs2vji7F81XFc
	tVyfwbrwYL3+hSaBf+OpuKMPISqh+S0kF/H6+wTVur35IJarIBPbjG76qaoYB7kwCFZ6w0MrDOBru
	VLS+1azEQAZhFlWIvkkISVgK00CTKW4ZXlssjvyRo/uYhDqAIdxhmLlqg5R3pJsQA9OQpJFqOgVDO
	WDC8IoPQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0aT-002AaY-05;
	Wed, 30 Apr 2025 14:06:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:29 +0800
Date: Wed, 30 Apr 2025 14:06:29 +0800
Message-Id: <5f35650f144effecb985ea80473293bf789ed3b3.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 06/12] crypto: powerpc/sha256 - Export block functions as GPL
 only
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Export the block functions as GPL only, there is no reason
to let arbitrary modules use these internal functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/powerpc/lib/crypto/sha256.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/lib/crypto/sha256.c b/arch/powerpc/lib/crypto/sha256.c
index c05023c5acdd..6b0f079587eb 100644
--- a/arch/powerpc/lib/crypto/sha256.c
+++ b/arch/powerpc/lib/crypto/sha256.c
@@ -58,13 +58,13 @@ void sha256_blocks_arch(u32 state[SHA256_STATE_WORDS],
 		nblocks -= unit;
 	} while (nblocks);
 }
-EXPORT_SYMBOL(sha256_blocks_arch);
+EXPORT_SYMBOL_GPL(sha256_blocks_arch);
 
 bool sha256_is_arch_optimized(void)
 {
 	return true;
 }
-EXPORT_SYMBOL(sha256_is_arch_optimized);
+EXPORT_SYMBOL_GPL(sha256_is_arch_optimized);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA-256 Secure Hash Algorithm, SPE optimized");
-- 
2.39.5

