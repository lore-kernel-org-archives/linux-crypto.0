Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D8430F534
	for <linux-crypto@vger.kernel.org>; Sun,  8 Mar 2026 23:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773012323; cv=none; b=J57iyx64pmvUzwJugyIM64VWxyX6Z+E+f6QqHXy3v7Qbkr7rJeEW5ks5Cs0SH7ieBimoSaeeJEKeyrfedC1U37lFMy4aoRp3D+04kbT7IojeuhKG1U+QolexCJanEKzcc+viLUNBgKcHkpB5romXscYVxV5tHgiIxOAohGLSBes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773012323; c=relaxed/simple;
	bh=nqj4YND/KgmZUOiN5flyhdGVD/KL8lrlWmefXh7ljAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oApb7oxxmdYfS9/wNzkudPmCpJaSgysNVDdnuOC6xFaQocL2cfoAaal6LhPaRXQflFmodM1O/0OY+lh90cjljWR0CwHemPrNCdC64AqY3qCrsew7/nYSAy6ToIfMZvNOIvmlIdOCf6WJlmskP8TkxFA9oAoomEgZU2YOL+teIEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JP3dI2ps; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JP3dI2ps"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773012309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iTPXCABkEggbDIGuCh1IV5kp7+i1+yPmZYrmuxmytjM=;
	b=JP3dI2psjPagAtQyZKtKh9NlHT+UdTW+78Qf2AuEq/Jj+EKOI7vuKDqm6YBouy9JeoXw6L
	IOA+OYn6Zc8CuKBA+KXfyLT3NeLSCF2z56RHuO7jdibraqj2PWFTn+clBvAs224baB08aa
	7lt/NXJxE1NZ0o04cQbhgoMXbHZPg80=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel - use list_first_entry_or_null to simplify find_dev
Date: Mon,  9 Mar 2026 00:22:32 +0100
Message-ID: <20260308232230.544209-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1160; i=thorsten.blum@linux.dev; h=from:subject; bh=nqj4YND/KgmZUOiN5flyhdGVD/KL8lrlWmefXh7ljAE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnrWLZpnpZjmmTkv8DIx1zd4mvWNbbsk3pyByf81Xwfz uSq9yW6o5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACZi0srIcNJfccokhXIX8YU+ 18zM7i9WLHp4/3DDPVn7gPNPJD6rtjMyfKqSdl9XPf1ltbyRlopxSOnmKQpJXwTF3365PZdx7Ts vfgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use list_first_entry_or_null() to simplify atmel_sha_find_dev() and
remove the now-unused local variable 'struct atmel_sha_dev *tmp'.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-sha.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 1f1341a16c42..002b62902553 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -404,20 +404,13 @@ static void atmel_sha_fill_padding(struct atmel_sha_reqctx *ctx, int length)
 
 static struct atmel_sha_dev *atmel_sha_find_dev(struct atmel_sha_ctx *tctx)
 {
-	struct atmel_sha_dev *dd = NULL;
-	struct atmel_sha_dev *tmp;
+	struct atmel_sha_dev *dd;
 
 	spin_lock_bh(&atmel_sha.lock);
-	if (!tctx->dd) {
-		list_for_each_entry(tmp, &atmel_sha.dev_list, list) {
-			dd = tmp;
-			break;
-		}
-		tctx->dd = dd;
-	} else {
-		dd = tctx->dd;
-	}
-
+	if (!tctx->dd)
+		tctx->dd = list_first_entry_or_null(&atmel_sha.dev_list,
+						    struct atmel_sha_dev, list);
+	dd = tctx->dd;
 	spin_unlock_bh(&atmel_sha.lock);
 
 	return dd;
