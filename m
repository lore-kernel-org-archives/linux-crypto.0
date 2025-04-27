Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A371FDA8C
	for <linux-crypto@vger.kernel.org>; Sun, 27 Apr 2025 00:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745714578; cv=none; b=kX2wTKQpLjqmEfgNgXc5DS0PZdktT+22MFZk1wW5f/5SEtTMs3qKXp7Uf6mzVHbLsgIiH4tpHN9HR/JVRUZb0CsDs3BNk/qe5SaefaSAFZi4OkncnzDvWUIjGnAT5LyinqF+6oONczFRF0w/BCr8nFozEeoY/7oXkmCmYq63OGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745714578; c=relaxed/simple;
	bh=KVsNV5Lgzi7f30+tC/N//NcJP+vDWXC13ggc/+nhz70=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=qtEqfT+Q2U5PEczcCpSBjUNeSkPyiQ8bToHvV+nHhjHPPy402ztvIVM0ewR4jvVJHZ7s+M2l2h6TdcC8DOp/q1ESM0r2jzgvcZbOjgxe7HGsWp2/gbJfNU0mrbRUPmD8VdD22dp0vyAea5CCcJFqQwg60o84h/S+m8xpydzHSIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AeM+ucad; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AeM+ucad"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5krD8iHc4hvXGIczvPnHFx90xALI4abOJJ7okksDnZ4=; b=AeM+ucadD9ubSyqFO3N7mwQNxo
	1gYG7xLpkxSpGeNcO5axzq4c3wpPqULTyCfeLDFcex7jTcVRcc+tjGnHlNXzPzL7ne6csmWGj05+j
	Ul71xFGhgdKsh3E48O12bCTwoiHao67mHrzvCAVPuoD6Jxqb/OC2fC9bpb9qSLl2GYC/JmT0Qd2X7
	Gg82XWjjAlulyErGJteReTWt327VO2ulGIYFBMY4NHRIKsFOREQsp1GhyOEqEUG5n880BaTV+Xthk
	perLwPj8BpnkiPetPUoXi95m91rnkWsYqECOU6ENGn3qNYhfA1fnWnAmNonlsib4n1DPT4C+acOW0
	mNPqfpkA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8q6d-001J9U-36;
	Sun, 27 Apr 2025 08:42:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Apr 2025 08:42:51 +0800
Date: Sun, 27 Apr 2025 08:42:51 +0800
Message-Id: <1015a3ab7e6c41f5143268e021a099dd42a563ae.1745714222.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745714222.git.herbert@gondor.apana.org.au>
References: <cover.1745714222.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: ccp - Include crypto/utils.h for crypto_memneq
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Include crypto/utils.h to get crypto_memneq rather than relying
on random inclusions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/ccp/ccp-ops.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index cb8e99936abb..109b5aef4034 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -8,13 +8,14 @@
  * Author: Gary R Hook <gary.hook@amd.com>
  */
 
-#include <linux/dma-mapping.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/interrupt.h>
-#include <crypto/scatterwalk.h>
 #include <crypto/des.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/utils.h>
 #include <linux/ccp.h>
+#include <linux/dma-mapping.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 #include "ccp-dev.h"
 
-- 
2.39.5

