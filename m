Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5ED293479
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 07:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744357136; cv=none; b=YKuj5qIP2k6eKXEbXe0GApkcDjdHTDQ34dcgWrdkXa/oPuD9ZuSjfOEcg1TcqIa0iQlrB92dBypD/g/WYZgxoyLBfrzqUBrjxC8MwYKObrd4zq8jkM93/KzPJ75hdv32mIvtQQTvJ65PV7S8eaokzT85vRINXurkIcfBEHhETAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744357136; c=relaxed/simple;
	bh=oK7kQtES5jCLWD5OsCQJpKxBvLQUmA9fhCbRdSsVXCE=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=cStcmb7gHzVDmRd+j6RO/FbXpoRGcvwDxZUMHv1a/ZsYgu226Cel//CCHGUhuSj9xdVneZgSYf4QV3BH32QZL8Y6V6Rr20JErgNfeHf3uJZOJGobLd8hy6zMeCdFrnmuBS8oxLWk3kPrcvNEfra8WSd9ypFcaRpp2mzZFat7qsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ShhfuHbU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ShhfuHbU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IWMfSqCPHZcF5cG0myN0JM1HrJburuNplKT9o3/xpyQ=; b=ShhfuHbUE/KnJ/6Md110WWk4he
	0lBz8BrfXUadmA9x+dvQPsUsqorGvR8NCDQncLIb1vf0AHiQ6ZG/4umMwL5SB1mQhxWnQW0ynCi8I
	CHrTPDzk/QaiQTqyt3+1vM+gxmVZL6M3fTXIbWUa5cqJPqroEgsZvYp6iCElgSv8CWqhCRTrnN1p+
	ma5ZYoThieGUCP1JQPeAN9R9ZK8cQk9G1otLBcnCXFyzHLtVluzgxJkGnKPYxW4tlMID2L6FdJJoP
	Cnhtq6WKn8t1kHK+wEzRdb3AOr5tTtdrPLI6QTJCnlVvsx5hvL9u51OUqyX34IsOOFIhWuzSrdfNe
	acgc/KGQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u38yQ-00ElpU-0I;
	Fri, 11 Apr 2025 15:38:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 15:38:50 +0800
Date: Fri, 11 Apr 2025 15:38:50 +0800
Message-Id: <d5ff0b1692cd91a155855fe3aac1b0e8a8f70633.1744356724.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744356724.git.herbert@gondor.apana.org.au>
References: <cover.1744356724.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] crypto: simd - Include asm/simd.h in internal/simd.h
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Now that the asm/simd.h files have been made safe against double
inclusion, include it directly in internal/simd.h.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/crypto/internal/simd.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/crypto/internal/simd.h b/include/crypto/internal/simd.h
index be97b97a75dd..f56049bd1660 100644
--- a/include/crypto/internal/simd.h
+++ b/include/crypto/internal/simd.h
@@ -6,6 +6,7 @@
 #ifndef _CRYPTO_INTERNAL_SIMD_H
 #define _CRYPTO_INTERNAL_SIMD_H
 
+#include <asm/simd.h>
 #include <linux/percpu.h>
 #include <linux/types.h>
 
@@ -46,9 +47,6 @@ void simd_unregister_aeads(struct aead_alg *algs, int count,
  * self-tests, in order to test the no-SIMD fallback code.  This override is
  * currently limited to configurations where the extra self-tests are enabled,
  * because it might be a bit too invasive to be part of the regular self-tests.
- *
- * This is a macro so that <asm/simd.h>, which some architectures don't have,
- * doesn't have to be included directly here.
  */
 #ifdef CONFIG_CRYPTO_MANAGER_EXTRA_TESTS
 DECLARE_PER_CPU(bool, crypto_simd_disabled_for_test);
-- 
2.39.5

