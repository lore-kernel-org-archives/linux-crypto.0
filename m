Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7E928C5CD
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 07:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744357134; cv=none; b=ltWYhUSTIr2DrPuFNW5SgkSCo9Q+vMI9sE0MsXh5cijpJ8HEtCc8yh2sVA+W/EbrSsKCo4eFi6+v3zVHafr+Ut5x1WN/Kg96SJ8CAiWmhuu76MHUu9pU4sHqUukZ1f/KNpbKFxPSTwfX4BwVykYhIiDoxeDh8UE4s6pCU56Qq6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744357134; c=relaxed/simple;
	bh=BTSVAM+rJGYEbUzJ/aXStyTodyDO5+zFpOgIMlyLNw0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Z2/iqf6cIXUWbwxfaCytZoR/6/NAN9/jKa0pMFowCFdh+P0bOsF24/SPGt3+sc1RBD156MObuyg7q4iOzDbnNP8KGIPH4iScM0MK0PvGtkyfLER9UKpf5ks/UKPm+slLfEWC9bYdNWZJ0qb7Mog7DJrBIEl0bs3YBdK2cR+SBdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qiPLFgBi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qiPLFgBi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f4+AHjfTP0gbpqzoaJLkNMzhjOJ1KjVIMG4FuMTNhLM=; b=qiPLFgBiibYhVUyHiBDqcQ6Ynx
	xogbZjP0Gpp7cCkD2jNZtKtXjo7WONiscHeIG2Jns6j9YKe1iHEEhIJ+mqZ237Dh/IvPhnuzacdbF
	vzRa8wKPplUxfBqmiHeGmW2ObQtqiyRUaZLO++YEJ+P9bdv4+DZ2NJq1tex8as+d8oIKJvNTmWjJY
	LS3TdzTU5IYRIHPugZOjAGjhsS0pTSGLVgDDxYP7matsyMcViOMEynrSEZI/IcwD6Hr1JOr0BjIjX
	dYmvvZql5KCLZg71Y5EGnPE3kOdG0facqqnOz4dKfU77cMa73j0hQJ4KTJfW1JV5Of2r2x9hJajPa
	5SScvm2Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u38yN-00ElpJ-2Y;
	Fri, 11 Apr 2025 15:38:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 15:38:47 +0800
Date: Fri, 11 Apr 2025 15:38:47 +0800
Message-Id: <774f7e64100f817230ab29da6dbaefa70223e95a.1744356724.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744356724.git.herbert@gondor.apana.org.au>
References: <cover.1744356724.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/4] x86: Make simd.h more resilient
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add missing header inclusions and protect against double inclusion.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/x86/include/asm/simd.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/simd.h b/arch/x86/include/asm/simd.h
index a341c878e977..b8027b63cd7a 100644
--- a/arch/x86/include/asm/simd.h
+++ b/arch/x86/include/asm/simd.h
@@ -1,6 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_SIMD_H
+#define _ASM_SIMD_H
 
 #include <asm/fpu/api.h>
+#include <linux/compiler_attributes.h>
+#include <linux/types.h>
 
 /*
  * may_use_simd - whether it is allowable at this time to issue SIMD
@@ -10,3 +14,5 @@ static __must_check inline bool may_use_simd(void)
 {
 	return irq_fpu_usable();
 }
+
+#endif	/* _ASM_SIMD_H */
-- 
2.39.5

