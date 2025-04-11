Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1263528C5CD
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 07:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744357130; cv=none; b=Oqy0qpNUZ0H+phEbLtGOdANNlDvIah0qcjsCdZdlVCF5VOzByIHB2hyZ+6+ETSs0T2OAW3cwZLke2nsZIqbv6lc0wvp8pfl2b9N5nKLnsw3WsFeVnNkl2yWqn/SYQ3Poa1laFECYeEkPM+qr0hyZtb51RySEO255X6Tr//slY4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744357130; c=relaxed/simple;
	bh=w+nuiIxcaVaiCX/lq6lRZ+MOCu02g6Lx/iYkdSqMBFc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=TtZXyE2/pwHiNWyr22d4XukU9k2xD//HadUM6TTcW3rgjIzgX6byiPDw7evxY15uTRS7jZ7opVY/u5sMK/YADhIqzuzzQ7PNbMGYzaa7VoKPOR2LfB09XmKpN39OQt1BzWbDHe7GfOm9E/Rr7C7yPLANucBzy3hIC1/tWmRliD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=l6BVQ3rL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="l6BVQ3rL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8xT3L0g4J9pkrsZlAAtYbK06kg1ofQkFXOAuvrJ+aew=; b=l6BVQ3rL8nhgBlp+Y8y/AnYUSp
	S+wIdVtApKrGgJmSjZ3fyyhrOyER8AvOvEg/We8RKqPyKX1r+3f5NU8oat2iXavZ8u1kSV73unddB
	HLp5d35uh5S0fwWOBTgpUbbtigQO0K/Gli7S3cPwk6CjEV5e0VauZfOPDtcBzAHofHT7NdNy81rAq
	n5fXSwph+5AljZrf4TfBdFel/RBK3R13fx9PAg1fyllF7+1XHDiQ8VdnNVfnQK5m0u0J+VEws6wTu
	Oo9nU6odC9hodT9tCp4FIawubxYLti0+KwldC4v8qqnEGtOCxCikQy6Ityl4nwaGvmjh9hiqoS3Rs
	lkFIrbpA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u38yJ-00Elob-0k;
	Fri, 11 Apr 2025 15:38:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 15:38:43 +0800
Date: Fri, 11 Apr 2025 15:38:43 +0800
Message-Id: <c2a0a6a3467c6ff404e524d564f777fad31c9ebc.1744356724.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744356724.git.herbert@gondor.apana.org.au>
References: <cover.1744356724.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/4] asm-generic: Make simd.h more resilient
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add missing header inclusions and protect against double inclusion.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/asm-generic/simd.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/simd.h b/include/asm-generic/simd.h
index d0343d58a74a..ac29a22eb7cf 100644
--- a/include/asm-generic/simd.h
+++ b/include/asm-generic/simd.h
@@ -1,6 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_GENERIC_SIMD_H
+#define _ASM_GENERIC_SIMD_H
 
-#include <linux/hardirq.h>
+#include <linux/compiler_attributes.h>
+#include <linux/preempt.h>
+#include <linux/types.h>
 
 /*
  * may_use_simd - whether it is allowable at this time to issue SIMD
@@ -13,3 +17,5 @@ static __must_check inline bool may_use_simd(void)
 {
 	return !in_interrupt();
 }
+
+#endif	/* _ASM_GENERIC_SIMD_H */
-- 
2.39.5

