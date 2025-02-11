Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D691F0E42
	for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 09:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739267600; cv=none; b=aRegIlcaxue8JzYyOTkjV2/Ay43CJkqL5NR1K3vMtJSRJZxmxu+PZ93qPQjyrHULhxFk3U+iJ3Upf01XQVM6cglZ1Zli1OXEy/yMayaK4Z/lx1TemoEadONlQMAoa04u2VHkuM3U/uaySal1StOhrmFYPobkTxOwVQYoP2SbeTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739267600; c=relaxed/simple;
	bh=1a7ApAJdAEd4OnMnb4fnAyRo1gknRoFk8afUH4CkMs0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KqydHCwat5zdLNfQY6IgDGgHiuIk2Rk3hobMIH0bFZ32YamWpDXCf06IbMSK8FBvoLK7vmI573A8LB9NKLjHae+TONfNI9cVMcNItOr9OsQkSIZWRnPryhvcwVRzrl/0S2znTcLKKFXyW01egKAMcj2QRUmwswDObFLtLhE/U/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UgZW8/iG; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UgZW8/iG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739267595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p8q1NE03cEUxDGjQx65ZUxEtEWYO5w2XFxoiG7lm7FM=;
	b=UgZW8/iGHDuk7rj1RjfH/qT+9HXyeKh0WgVdSsNnnvdTmH8ZzDnY+8N9KvfPBhoAZC02aT
	7Isynwyt2yMWI8we7Aq1+NYRUv2ARyMEZgmW80c4C9wYyOZbfafgQN6Oe3LN0mg6f273zs
	94bY+SEWWiVRQFj87Qnv4PBjV/3vZ7E=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: aead - use str_yes_no() helper in crypto_aead_show()
Date: Tue, 11 Feb 2025 10:52:54 +0100
Message-ID: <20250211095255.520170-1-thorsten.blum@linux.dev>
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
 crypto/aead.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index cade532413bf..12f5b42171af 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <net/netlink.h>
 
 #include "internal.h"
@@ -156,8 +157,8 @@ static void crypto_aead_show(struct seq_file *m, struct crypto_alg *alg)
 	struct aead_alg *aead = container_of(alg, struct aead_alg, base);
 
 	seq_printf(m, "type         : aead\n");
-	seq_printf(m, "async        : %s\n", alg->cra_flags & CRYPTO_ALG_ASYNC ?
-					     "yes" : "no");
+	seq_printf(m, "async        : %s\n",
+		   str_yes_no(alg->cra_flags & CRYPTO_ALG_ASYNC));
 	seq_printf(m, "blocksize    : %u\n", alg->cra_blocksize);
 	seq_printf(m, "ivsize       : %u\n", aead->ivsize);
 	seq_printf(m, "maxauthsize  : %u\n", aead->maxauthsize);
-- 
2.48.0

