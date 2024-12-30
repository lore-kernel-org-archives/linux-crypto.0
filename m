Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCE71632C8
	for <linux-crypto@vger.kernel.org>; Mon, 30 Dec 2024 11:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735558655; cv=none; b=OmF39pz/hdapENd/6IrSvct1FnrMPAd9NQfBbX5KYnvj1tzWAdxSdcsq6+QtLt1iIxQ22etb4odiJ57EfmOLemrm8rHtfTdbsWzi5bkhSSkcSSyC+wgpoWm5GjoEVBw7fKdzzu6dlQHk8IhLhY5MZR1NZpqgOEEeTq8/MsGtD3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735558655; c=relaxed/simple;
	bh=ZO1VEo3CLmLAUVyPYN3GqTEhTsude9+PT+5VF4g6QyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JnvArk+qt5NEnJEV0kW9oU9sgy4k4pFRTSwW+zB6xT5STqex0gwQIMu7Wv24SNSCC6N2s+YpKUapz3I19oQCx61qLu2it5pXK/yuqWd/AnAUQ0vmoIljITz/ViASop4C/Jy7nmzkjznXLeQL/j40eefGV+E1wFdlpC0IlRLAf98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pJ63e/TN; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pJ63e/TN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735558649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qjBECjd4SBrvIPvDRUgoP+x7cyQacQEzLy5iXx7PyWA=;
	b=pJ63e/TNWUHZURex87SKYpz62sKnAMftqT1midhtTcpoXVSME2JUy7EJTlCZcOWrRqZuAl
	aJg9UfuQ2YT/08MxURzfJ/3C+PzFwHhBpxnYV9uQox4+Zj0Q9fnLy5/3aYz8zuxe9iWLQY
	zeFvcxV9UcVVSW2IyLk/JzPNnd3gehI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: proc - Use str_yes_no() and str_no_yes() helpers
Date: Mon, 30 Dec 2024 12:36:54 +0100
Message-ID: <20241230113654.862432-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_yes_no() and str_no_yes()
helpers. Remove unnecessary curly braces.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/proc.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/crypto/proc.c b/crypto/proc.c
index 56c7c78df297..522b27d90d29 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -47,13 +47,10 @@ static int c_show(struct seq_file *m, void *p)
 		   (alg->cra_flags & CRYPTO_ALG_TESTED) ?
 		   "passed" : "unknown");
 	seq_printf(m, "internal     : %s\n",
-		   (alg->cra_flags & CRYPTO_ALG_INTERNAL) ?
-		   "yes" : "no");
-	if (fips_enabled) {
+		   str_yes_no(alg->cra_flags & CRYPTO_ALG_INTERNAL));
+	if (fips_enabled)
 		seq_printf(m, "fips         : %s\n",
-			   (alg->cra_flags & CRYPTO_ALG_FIPS_INTERNAL) ?
-			   "no" : "yes");
-	}
+			str_no_yes(alg->cra_flags & CRYPTO_ALG_FIPS_INTERNAL));
 
 	if (alg->cra_flags & CRYPTO_ALG_LARVAL) {
 		seq_printf(m, "type         : larval\n");
-- 
2.47.1

