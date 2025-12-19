Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16F7339B4A
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155907; cv=none; b=tHeL7JdwMqRXtKhnBk1lv5VHV20VSeXlFGSmUAdi+yQbz2g7+lVC6RzUaQby36jcfCWNiB+rOLH79wjaKMXWEdVRiia3HI0+3XOBKrA8SHFlVHWLZTlN+eZSBqTaSIKzxVYAZyS1lufzUvpKx7Gzi/bda9Gt73F1PNCIZ3+9odQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155907; c=relaxed/simple;
	bh=sMGUIoQxg3G664STiv430sfu1xKgYecR9VNdQ9rtbvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uefRSxXGsNeTSfeGgjf6aOahrvpdhh6vMkOrfZjTEWzkL++6uaeqKSd40zjqfA9H0FPTpV4GGuQJhX227bl/xDu+ll8PWYXarFHaV+IePTxD7nd6JAsaaQ4oCnGa9F1f82j3B5ZYFntmdTlo0p2F0TPkXdPqKQqF0YTvcGjqDcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IErtSfYR; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IErtSfYR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766155897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iboLvR4FYE8AnCSTwKUHIL0JFFQep9MPw9WsziO1mR8=;
	b=IErtSfYR1w9t937yJQdIU+KyUyVc1HGvkyPFNKc1JbQQM8iGkboqVmO6K1F++vQd5fBJhd
	ZrTto0fHiKmtWcOjCZ5gfBE6rfFBA+E8gFTW1bNEuRd5EtJJ0A2TpgR5BYk4jZ7wpZSrwp
	9u5EskNGBMYPIp/4TGCfHpgFyGARK84=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] crypto: acomp - Use unregister_acomps in register_acomps
Date: Fri, 19 Dec 2025 15:51:17 +0100
Message-ID: <20251219145124.36792-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the for loop with a call to crypto_unregister_acomps(). Return
'ret' immediately and remove the goto statement to simplify the error
handling code.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/acompress.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..b353615fe265 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -337,17 +337,13 @@ int crypto_register_acomps(struct acomp_alg *algs, int count)
 
 	for (i = 0; i < count; i++) {
 		ret = crypto_register_acomp(&algs[i]);
-		if (ret)
-			goto err;
+		if (ret) {
+			crypto_unregister_acomps(algs, i);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-	for (--i; i >= 0; --i)
-		crypto_unregister_acomp(&algs[i]);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_register_acomps);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

