Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21A222F151
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020695; cv=none; b=DMpQXyC/6YD9YLUPS0cg+yd6aDgFY69a4c43Py8LFE+GWFu0yUA9VnsfImAjl2vBroR/+V5YkQCE6l9pgiqSCeJEpnuBsG0LQ0vrVMXaSkAfVPfSyBM7Tt+aFLMh+99vTk5zL+vY+Zq9/jnDI2w7Kl5sfzGnNsVzK/wVD72iIC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020695; c=relaxed/simple;
	bh=VzCd01ZqKsmTk23ae3zmIu86OLc968210Bz3U7AYgQY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=fG5Pa+2NqxBJ7LoAfjhM5pU7O/6XK4GqhAk38v/Hd7Q1l+W4+XjR8WjV7egnxARXrnvaQJR9Cvx1ad1ixtg6M20k9iSZF6D684oJ2AYX+vrpeNo2beh3pECcdYUBAWp15aB1O3Gyjr7pADzC51Sj1aidPpxilcKGciFDnE721a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=J51kJRsw; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="J51kJRsw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WCivWcIHjxorcgVZBRiEwQlWk2V0oGAkizrN5oIGyb8=; b=J51kJRswBNCeOHDpnx9WVscpBN
	+Y/meLbm26Kzq5opbohrMJtbFQ7pdVeeqc/76if6OerShcLp8Go1++NSDHq4I8JRyCs7xbpjpAfs2
	P25lMQjVIv4STYVGtAUQ2goyHWQJjBdkPG9JkDyc0QZfTGyF8ZyRbQJDOxFBS8Ktz2q26ZD+lTk2R
	+XUAxEinNqYyP/qP4zUItsx87BNOzaaaIxPiViRvQlbcf+xjBvQ3Pq1BuIcQ1/1voTeUlzdmH9sAM
	lveNi7b6L85ZZpx8Is6tXXUQFfOR3v1rnDi3y8VDErcJOvOmzsnrDubybMFt8s8PBFf3wYuNhzMZO
	8rIt4GPA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jRw-00DTPV-2O;
	Mon, 07 Apr 2025 18:11:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:11:28 +0800
Date: Mon, 07 Apr 2025 18:11:28 +0800
Message-Id: <57e65fccc1538060570387d8aeca791d94c7e96f.1744020575.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744020575.git.herbert@gondor.apana.org.au>
References: <cover.1744020575.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/4] crypto: ccp - Add missing header inclusions
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The gutting of crypto/ctr.h uncovered missing header inclusions.
Add them.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/ccp/ccp-crypto-aes.c  | 15 ++++++++-------
 drivers/crypto/ccp/ccp-crypto-des3.c | 15 ++++++++-------
 drivers/crypto/ccp/ccp-crypto-main.c | 13 ++++++++-----
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index d11daaf47f06..685d42ec7ade 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -7,15 +7,16 @@
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  */
 
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/delay.h>
-#include <linux/scatterlist.h>
-#include <linux/crypto.h>
-#include <crypto/algapi.h>
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
-#include <crypto/scatterwalk.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 #include "ccp-crypto.h"
 
diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index afae30adb703..91b1189c47de 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -7,14 +7,15 @@
  * Author: Gary R Hook <ghook@amd.com>
  */
 
-#include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/delay.h>
-#include <linux/scatterlist.h>
-#include <linux/crypto.h>
-#include <crypto/algapi.h>
-#include <crypto/scatterwalk.h>
 #include <crypto/internal/des.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 #include "ccp-crypto.h"
 
diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index ecd58b38c46e..bc90aba5162a 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -7,14 +7,17 @@
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  */
 
-#include <linux/module.h>
-#include <linux/moduleparam.h>
+#include <crypto/internal/akcipher.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/ccp.h>
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
-#include <linux/ccp.h>
+#include <linux/module.h>
 #include <linux/scatterlist.h>
-#include <crypto/internal/hash.h>
-#include <crypto/internal/akcipher.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
 
 #include "ccp-crypto.h"
 
-- 
2.39.5

