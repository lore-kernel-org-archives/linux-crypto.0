Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4B533A9F9;
	Fri, 19 Dec 2025 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155910; cv=none; b=il/4s8pNxtL/CprVm/CNmYopsVXNaeLnvk7J86f00c+AVrq2F4w1qyzw5UtxGaj2KTWaZMAEL9dkc7QWWAzmc52UdKYqd8lWLWBLdvgK5c7IhnQMIq4rnKMUdwgw+bshEWSGKbQDK+I2vWn41ZCPb0K1OLGVE/wcDrI3cErMmdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155910; c=relaxed/simple;
	bh=8kd9eRqsuZhwL9ohEWlSfovF8KaKTzdEtx2iRoGiZd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fey1cxo51mhx5gJ4xZqFZVdqgk25khSGMZkZji9z3rSQ5zBi7rpK7SBnByNYCuAFN5MLm0Cz2MR5gZCL9xR8iI56uyFTNN0WHUUSwg7RNb6MqANm+r/Vf/Idt9VfR8lrvkAByG5pKSnoiEO9elp8T/Bo5+NcyzN/L6iBZ4FiKH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hKOZBUX7; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hKOZBUX7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766155906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=plKTm7kBvAdGtcnlL8hmrbTTZDSkKvIsT/4vTR17Mgw=;
	b=hKOZBUX7CoaRNG1lMa5bxgfO/fGL0nk+iFwzzA9vxmXOIPwhwwDbv0FUlLO9hsneK1ZFvL
	TUynmITXQ2bhGmyJegJI1Bu4d3PFDrseddTtsuJ1T/bhnw+yhGQGdU+Zi88S8wj8pNppfs
	04s2CwSM4duzRGXNv+dYuVml2TuNVNE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] crypto: lskcipher - Use unregister_lskciphers in register_lskciphers
Date: Fri, 19 Dec 2025 15:51:21 +0100
Message-ID: <20251219145124.36792-5-thorsten.blum@linux.dev>
In-Reply-To: <20251219145124.36792-1-thorsten.blum@linux.dev>
References: <20251219145124.36792-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace the for loop with a call to crypto_unregister_lskciphers().
Return 'ret' immediately and remove the goto statement to simplify the
error handling code.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/lskcipher.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index c2e2c38b5aa8..bb166250b732 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -384,17 +384,13 @@ int crypto_register_lskciphers(struct lskcipher_alg *algs, int count)
 
 	for (i = 0; i < count; i++) {
 		ret = crypto_register_lskcipher(&algs[i]);
-		if (ret)
-			goto err;
+		if (ret) {
+			crypto_unregister_lskciphers(algs, i);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-	for (--i; i >= 0; --i)
-		crypto_unregister_lskcipher(&algs[i]);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_register_lskciphers);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

