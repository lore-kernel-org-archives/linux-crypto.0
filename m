Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0A2223321
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 07:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744788905; cv=none; b=aTjA/XvLbUGrGJ1aKLjNNLfkiAakAuxpRLrk2bLJ08ERNwiz0WZeXhgvnDEWaJeB0RbGMyiIl053wnqJae8EiT24RoUBI9ikwTF3+pmo6xWINTeSWPoioKMuS0d429ClYEGu5A0dh/tNPWfwYujmAlI/VDy3VkxCsbIwoVpn/9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744788905; c=relaxed/simple;
	bh=/rSkUlRMIYutwroDDrhkL3uyz2tVBRpizO4Dt4kqB50=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fyf3MQJTxpdHxYAb3Ki4xypm2/l1/VcTN93e/YhTHPO/w+/nRASVuF0V27IcUlu66pzXNsCNxOzD9xcI8c97WyShdrmjW/X+0fV5L7UpuC5qPY2hPlR5ZlSHyT7CP3wHrT711N+KjDbRnUeZ4X0SrG+naLrMqsj2zg2Ep7QPqA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bAd2j5z2; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bAd2j5z2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I9xNfDrduYiVApjRUC/zZgAO49pbWESNTh53sBjja9Y=; b=bAd2j5z2wYumuFODp7gRKNlw61
	JbaXxvtkkX6sC417FzQSEpgJWTQi3evSg6+l3E5w9owz5gMkGOvG38abFG7JNMh9z/Cc95Zg/eGAO
	l+bMw5HPMqINsLqnYsF14vHUMpprIbhU+r1Utwm69DJ8zU8HtIL9pksvDa1G9nborn6NmZRvlNPl0
	LlR4zB+Zhgn1Eoadp1ROxUK2yGe4DrI/psyT7oDQqCzHzf+Y4YXbWrwBHaAxtbEh1OPaAQyd9U8DV
	CD5u9djqZwTI7iMzb0UjA9dHrgWW8A9xYjVJ6b4h3omKFFGagJLIhwxjuOmMTK4lcmn1JW37nmGNx
	vnRK+Eew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4xIR-00G7Uy-0E;
	Wed, 16 Apr 2025 15:35:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:34:59 +0800
Date: Wed, 16 Apr 2025 15:34:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: powerpc - Include uaccess.h and others
Message-ID: <Z_9do9hu5E0BxLAO@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The powerpc aes/ghash code was relying on pagefault_disable from
being pulled in by random header files.

Fix this by explicitly including uaccess.h.  Also add other missing
header files to prevent similar problems in future.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/powerpc/crypto/aes.c b/arch/powerpc/crypto/aes.c
index ec06189fbf99..3f1e5e894902 100644
--- a/arch/powerpc/crypto/aes.c
+++ b/arch/powerpc/crypto/aes.c
@@ -7,15 +7,15 @@
  * Author: Marcelo Henrique Cerri <mhcerri@br.ibm.com>
  */
 
-#include <linux/types.h>
-#include <linux/err.h>
-#include <linux/crypto.h>
-#include <linux/delay.h>
 #include <asm/simd.h>
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
 #include <crypto/internal/cipher.h>
 #include <crypto/internal/simd.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
 
 #include "aesp8-ppc.h"
 
diff --git a/arch/powerpc/crypto/aes_cbc.c b/arch/powerpc/crypto/aes_cbc.c
index ed0debc7acb5..5f2a4f375eef 100644
--- a/arch/powerpc/crypto/aes_cbc.c
+++ b/arch/powerpc/crypto/aes_cbc.c
@@ -12,6 +12,10 @@
 #include <crypto/aes.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
 
 #include "aesp8-ppc.h"
 
diff --git a/arch/powerpc/crypto/aes_ctr.c b/arch/powerpc/crypto/aes_ctr.c
index 3da75f42529a..e27c4036e711 100644
--- a/arch/powerpc/crypto/aes_ctr.c
+++ b/arch/powerpc/crypto/aes_ctr.c
@@ -12,6 +12,10 @@
 #include <crypto/aes.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
 
 #include "aesp8-ppc.h"
 
diff --git a/arch/powerpc/crypto/aes_xts.c b/arch/powerpc/crypto/aes_xts.c
index dabbccb41550..9440e771cede 100644
--- a/arch/powerpc/crypto/aes_xts.c
+++ b/arch/powerpc/crypto/aes_xts.c
@@ -13,6 +13,10 @@
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
 
 #include "aesp8-ppc.h"
 
diff --git a/arch/powerpc/crypto/ghash.c b/arch/powerpc/crypto/ghash.c
index 77eca20bc7ac..9bb61a843fd3 100644
--- a/arch/powerpc/crypto/ghash.c
+++ b/arch/powerpc/crypto/ghash.c
@@ -11,19 +11,19 @@
  *   Copyright (C) 2014 - 2018 Linaro Ltd. <ard.biesheuvel@linaro.org>
  */
 
-#include <linux/types.h>
-#include <linux/err.h>
-#include <linux/crypto.h>
-#include <linux/delay.h>
+#include "aesp8-ppc.h"
 #include <asm/simd.h>
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
+#include <crypto/b128ops.h>
 #include <crypto/ghash.h>
-#include <crypto/scatterwalk.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
-#include <crypto/b128ops.h>
-#include "aesp8-ppc.h"
+#include <crypto/scatterwalk.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
 
 void gcm_init_p8(u128 htable[16], const u64 Xi[2]);
 void gcm_gmult_p8(u64 Xi[2], const u128 htable[16]);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
