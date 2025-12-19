Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D80C33A9C4
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 14:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155908; cv=none; b=WZzB7qoNbAhXBevQwxkaBgcjZTfGwWTudeacF4L8zn3ascmedKglo8t4JelYotBuhcIQSPcTqcgdxcQlWa1205jhVGd6GNpj5E0cwvMVloegJoWUusF2OVDRbt6QQmAM+eExLTs53hZQtgrkOVu8bNzpA/32IMOoF5CyqSY6pVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155908; c=relaxed/simple;
	bh=pPLVQ92F0dkw5BJJFlhsvrbtZ7wHMazfP7JnfQUK0Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQQZBSJXZryg/kgq/c2JXuZSqVkZ/TFkq+BRkS0YfWZnIDc8g08/FE4U/ECQ+3VyjrMMds+heaf9t3nJnvwKcKzVymW2ZyKHqJT0NuXo9DPCNthLm88a3GTMITaPTjb0LoJmIkzbUvHbXoNaSylOGACYXZyOd8AOBi5Rs1MvGT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ap4/Sl1b; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ap4/Sl1b"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766155903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ePgeg9/vAN9yfv2CC7IxGs5LqIYWaj6JCMM+Rlq6gPI=;
	b=Ap4/Sl1bIM3KzvuN3xMYLV6WezBQX1tj9zvm0K9Hwence1vUq0a2So5h8ZyHiUF2Cxzi+P
	CmtDPIIqwhHJh5xekLF1PZ21r2mbshAl+b185ZcsNlnGaX1l9npv9t0I7LvB0GinRmKvQb
	2omJ7Gkoe8GpLC0KrCcOuVTrtPg8n5I=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] crypto: ahash - Use unregister_ahashes in register_ahashes
Date: Fri, 19 Dec 2025 15:51:18 +0100
Message-ID: <20251219145124.36792-2-thorsten.blum@linux.dev>
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

Replace the for loop with a call to crypto_unregister_ahashes(). Return
'ret' immediately and remove the goto statement to simplify the error
handling code.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/ahash.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 66492ae75fcf..c563a68dc000 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -1020,17 +1020,13 @@ int crypto_register_ahashes(struct ahash_alg *algs, int count)
 
 	for (i = 0; i < count; i++) {
 		ret = crypto_register_ahash(&algs[i]);
-		if (ret)
-			goto err;
+		if (ret) {
+			crypto_unregister_ahashes(algs, i);
+			return ret;
+		}
 	}
 
 	return 0;
-
-err:
-	for (--i; i >= 0; --i)
-		crypto_unregister_ahash(&algs[i]);
-
-	return ret;
 }
 EXPORT_SYMBOL_GPL(crypto_register_ahashes);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

