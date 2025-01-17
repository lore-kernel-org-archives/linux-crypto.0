Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3581F95A
	for <linux-crypto@vger.kernel.org>; Fri, 17 Jan 2025 14:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737125033; cv=none; b=m+ikpelVXPpJWBE6yu4bG3Qb7AsEv+EA9wLUOz8449sfyyjiSI4tVvfGr8xVg5OUC4DFoGdC0+n9+xELZK5P3j4LUUVkCvs/Wp4l6+kGRGKHu84BbBWDoTlzoejkisbWsKCnUDqxR5ypeEHi/M77rA42fN6ziNetbSFnhRGZ5CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737125033; c=relaxed/simple;
	bh=L+jnUuVw5tHSuKsG1L26FNCTyudvNRqMNGuL4PR2gQk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=naaO7Qu1WOaNsWNTtwVwxT0/ltTOD274fkIVBHRQoDZJcaOHlfOfDIIskP0u3doKmplwfgd58UmKAd+p+tYUYXBkdzNQV3SjWAvf3q3TZYUEDNiaaSjSxO0bNu3gYszjggVM3ImFN8JbB/ZbaoTo3bvWhmR/gdrXB3qpTHcTXN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KkC0DwL6; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KkC0DwL6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737125023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=io/bCKxwPZ79N+0N7ve4jDVVx21YRZW953Oyfq+VcU4=;
	b=KkC0DwL6kb4ta5oagNgWxP3If0pv1sE5BPORnmIq4n28Ppx2nNIUVvswKhE4dTgdAXxNwI
	/B/u3zYMBw+URuWsqzJ/+ehP8vHa8n5o7V2O2Wnudnbi47XNfVY6mTTbrpLGVZxQhI1WbD
	mVUtl14QqTL+g7OvjYDZrtJXJl1EWZQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: skcipher - use str_yes_no() helper in crypto_skcipher_show()
Date: Fri, 17 Jan 2025 15:42:22 +0100
Message-ID: <20250117144222.171266-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_yes_no() helper function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/skcipher.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index a9eb2dcf2898..e3751cc88b76 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -22,6 +22,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <net/netlink.h>
 #include "skcipher.h"
 
@@ -612,7 +613,7 @@ static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 
 	seq_printf(m, "type         : skcipher\n");
 	seq_printf(m, "async        : %s\n",
-		   alg->cra_flags & CRYPTO_ALG_ASYNC ?  "yes" : "no");
+		   str_yes_no(alg->cra_flags & CRYPTO_ALG_ASYNC));
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "min keysize  : %u\n", skcipher->min_keysize);
 	seq_printf(m, "max keysize  : %u\n", skcipher->max_keysize);
-- 
2.48.0

