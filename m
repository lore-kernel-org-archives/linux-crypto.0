Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8314E293479
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 07:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744357133; cv=none; b=lrLwuaFo4Hh2NjSZoQMUSnUCHYLha6MlzTPHNniY+rpXdGkiGO6Bi3pEcyJISQoeAYW0HnqsW5pGTycoa8zl7bHcRKvTVhbeAxxI0VOpV3TzjrUYLWLHZKgzck3+JxckYVcezzK9CY4brcHVNqFQOf6AJJ4ToCk7Y9YUKjCbi5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744357133; c=relaxed/simple;
	bh=nBHpRMyGWIVMgsR00Ds/HbzB64vqXAQtfnxT5SVRrrk=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=cbHAXhBMDe6feJcPOIHX+YKhKAlmE3zCDCeGeV8ds9+QSRHbq/ZUl2DEkPS+JUZGqTQ9NjIS/sa+0FA3C8bm0emUdmGGJBydfygfL4ovaoOjHjXJB29L4HRA38BPwR2Vorb9lSR/gnY9Qfx/mFEzntLSnvReSTPzJ2leaN1S/cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GycDtRzg; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GycDtRzg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vfP8/dGbktqQo+ZQgy52TP9sSOelEMQ7yktovnNSv2o=; b=GycDtRzgYpUne4tpDvVRqucAK3
	76A7MhmdyO0hJlTW1PqR5PkecIevCyrDuUTbzdmasSnkgRiRMtjaUL895HNSyK1Ga5zbAZz/bb2pB
	aZ2h/HyIRL5W1nhc5/09hB1fShdjdDAUHzm4dWvVOmGeJrWYgXOERRxepZdSwsgiVgL88Tq1WDxu1
	kOqvPR7vj1RxdJLDAKx/6N2nRyDtfsoEHZ29f6eqVPsoRGhvqMAli3QiFwF+Wh1QWBnRSE22TZh0R
	aLt7RbmExhUG9OBozkc7VyehoKninQApgjKrw5A+WR+vGbw5C+q43m6ligQwVjRW2XVKuz3c8Jzo8
	x3cfMbyA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u38yL-00Elp8-1d;
	Fri, 11 Apr 2025 15:38:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 15:38:45 +0800
Date: Fri, 11 Apr 2025 15:38:45 +0800
Message-Id: <5aee9b968a894282393f6b8ccac1583830b5ddd5.1744356724.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744356724.git.herbert@gondor.apana.org.au>
References: <cover.1744356724.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/4] arm: Make simd.h more resilient
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add missing header inclusions and protect against double inclusion.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/include/asm/simd.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/simd.h b/arch/arm/include/asm/simd.h
index 82191dbd7e78..d37559762180 100644
--- a/arch/arm/include/asm/simd.h
+++ b/arch/arm/include/asm/simd.h
@@ -1,8 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_SIMD_H
+#define _ASM_SIMD_H
 
-#include <linux/hardirq.h>
+#include <linux/compiler_attributes.h>
+#include <linux/preempt.h>
+#include <linux/types.h>
 
 static __must_check inline bool may_use_simd(void)
 {
 	return IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && !in_hardirq();
 }
+
+#endif	/* _ASM_SIMD_H */
-- 
2.39.5

