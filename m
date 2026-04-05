Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E26342173
	for <linux-crypto@vger.kernel.org>; Sun,  5 Apr 2026 19:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775418624; cv=none; b=RIWTqb5HAL6SlwKWzjQX7NJAMAP05eRXt2hVOd3YBVYrQrD/+edlSsYOWxERJLsHSUdHpW+tQnwI63JD19rlSXTv1sPs6YagZpHykH/o7QdO6b1XHmib8FSrpKf5l5fJDDgXKP5XdP//dpPesORFjBmacfPv4gUZuNPASrThA4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775418624; c=relaxed/simple;
	bh=evS6sJd1RnWlkbjgcPhwUsPNQVfDbE9QZrru+rBlhSE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mcTC29Az2R0yADekYvzvzU/m+wwGqK6oukmMGqRonGrZBlH1lzsUCVmGILgWgwib2/95be+IafgwuNcBeokp09vRiMviluSy0sMDSYdx3jKofqP/o7bShhIgri80IGh9aWYWZTPrZGRAaPLw0ViGvUQDISpwj60jZLdJT8LQj/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LD5/4NCQ; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LD5/4NCQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775418619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mUwPl5fcDvn9ZEfXd/e0M/SWxMo4KU7sgVV2RlJ9akY=;
	b=LD5/4NCQ18mx4DKXfJWl94X+bEf8MZ3Ks1Ky0N+upX0gr/0pdPesSmU5RgkFPVCUYsOEuY
	miZivQxX7LDIprFoYXAje7N9IYA50Ho/VC3765jWLKKxPl9qVAdokAm61+8bYzIv7Dzcj/
	gXnUmEEaLPA02eweDL4V54VVl8ynTd8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: af_alg - use sock_kmemdup in alg_setkey_by_key_serial
Date: Sun,  5 Apr 2026 21:49:41 +0200
Message-ID: <20260405194940.990619-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=820; i=thorsten.blum@linux.dev; h=from:subject; bh=evS6sJd1RnWlkbjgcPhwUsPNQVfDbE9QZrru+rBlhSE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJmX9lyxUzx39lP0z7rNv7v9T6Zs3m25uvK7wHRtgaOxr VNFtj450lHKwiDGxSArpsjyYNaPGb6lNZWbTCJ2wsxhZQIZwsDFKQATEdzJ8D/42fspvDwWTa3b bTK/OPIHXtD8XV+kcnnLt8yFsatZs+oY/nDU8fHPkdG3LZjY/+/X55uLk3m3i/v2/OW8Jh0X7b+ qhw0A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sock_kmalloc() followed by memcpy() with sock_kmemdup() to
simplify alg_setkey_by_key_serial().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/af_alg.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 8e0199394984..25d2bfae31dc 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -324,15 +324,13 @@ static int alg_setkey_by_key_serial(struct alg_sock *ask, sockptr_t optval,
 		return PTR_ERR(ret);
 	}
 
-	key_data = sock_kmalloc(&ask->sk, key_datalen, GFP_KERNEL);
+	key_data = sock_kmemdup(&ask->sk, ret, key_datalen, GFP_KERNEL);
 	if (!key_data) {
 		up_read(&key->sem);
 		key_put(key);
 		return -ENOMEM;
 	}
 
-	memcpy(key_data, ret, key_datalen);
-
 	up_read(&key->sem);
 	key_put(key);
 
