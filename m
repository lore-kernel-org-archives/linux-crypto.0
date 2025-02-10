Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAA11C5D4A
	for <linux-crypto@vger.kernel.org>; Mon, 10 Feb 2025 10:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739181927; cv=none; b=fxXMY1Yh6CMspwjg3/c7Snkde6rWfuxGqHaEI9Ap6UvTXjUFI7TOG+PJ1MUCUzch22uyqpN0lRKWa11xGNc8HYTt9rfFk4DyjHRQUWURYMYnTPUvg3ilcAIp8VvhnPLuFeoCwTfVlG0HeX7IVjNxylDxhcV04xRBiEsyn42VziA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739181927; c=relaxed/simple;
	bh=/GXtnNgBhVaK9si1n2wfXRE8IjQEsoRgqZ4hA3aAVL4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cI0VetPIvk6ZIdjbD+snp8hPIDPAbArxbNZ5YDNMZooqs2I1LW9E8JhJmUjRW4bySsLhnEeBCQw1AzAadHtL345mjg4nAI6bPZHsRj96cYHPTjgVSAm5lhspzSFHocrkQ13YmHrnXDlkZV5y91m6gcLZFtiC9REFp4t5de7et7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=huSHdnOu; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="huSHdnOu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739181913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/yfZjw6DEKW+KVLwMtE/ioFVCrDSjPMT5tt7y5+KtVs=;
	b=huSHdnOueFx28IvLMOKd8lBxBePdyz/7trxJSiHfqEBTytR+VZDFyj3N5Abx7VXfk/1v3n
	ft0pPMklYm5+9iuAzTt/4nA68bv6hgkVBVBB2eLVPewfhAFr2FWW3TUXIkIQzGK1G/TQRz
	saHAOckNebKxzoflikj83W/9U6KNRy4=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ahash - use str_yes_no() helper in crypto_ahash_show()
Date: Mon, 10 Feb 2025 11:04:48 +0100
Message-ID: <20250210100449.1197-1-thorsten.blum@linux.dev>
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
 crypto/ahash.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index b08b89ec26ec..923c68a39ddd 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <net/netlink.h>
 
 #include "hash.h"
@@ -536,8 +537,8 @@ static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 static void crypto_ahash_show(struct seq_file *m, struct crypto_alg *alg)
 {
 	seq_printf(m, "type         : ahash\n");
-	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
-					     "yes" : "no");
+	seq_printf(m, "async        : %s\n",
+		   str_yes_no(alg->cra_flags & CRYPTO_ALG_ASYNC));
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "digestsize   : %u\n",
 		   __crypto_hash_alg_common(alg)->digestsize);
-- 
2.48.0

