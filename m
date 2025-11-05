Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9E32DC332;
	Wed,  5 Nov 2025 14:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762354368; cv=none; b=EfnvGUpOL8wCQT/VZoYuEVLkek1tOj6e+NBDHju6J8KS2C5Okir8ttvR8AiVTfrC26XKMk+5QfcPXbTyVErHtN4KYQvxkPFF/26T7vDWO4uZS3iKNdoV+OcvWecnVSlzNZPGKqNmtTkVU396lt5n0cHF+1SAlO6Y/DbFiqYjc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762354368; c=relaxed/simple;
	bh=9gw1fRNEgUEyLwOYb2BA2vCkFpQAcbdbeE3Y/HO2sYA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QOGFtmbSvP6+rK+t4fIdLUmEWNu1W0AwN8MN+U4b6uaThTpfega9xwy27uJ97rp50M44/pO+x85ARHlOwAVb7S8uAf/arqbTYYi11dqm36d0+P1unw+2RzKcffCT5KgTgbThy6iUQPG1zCXQ6RGIyuqc+M622O1OFJH1lEhtAeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from spb1wst022.omp.ru (87.226.253.162) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Wed, 5 Nov
 2025 17:52:31 +0300
From: Karina Yankevich <k.yankevich@omp.ru>
To: Corentin Labbe <clabbe@baylibre.com>
CC: Karina Yankevich <k.yankevich@omp.ru>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-rockchip@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>, Sergey
 Shtylyov <s.shtylyov@omp.ru>
Subject: [PATCH] crypto: rockchip - drop redundant crypto_skcipher_ivsize() calls
Date: Wed, 5 Nov 2025 17:52:04 +0300
Message-ID: <20251105145204.2888978-1-k.yankevich@omp.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.1, Database issued on: 11/05/2025 14:42:52
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 59
X-KSE-AntiSpam-Info: Lua profiles 197802 [Nov 05 2025]
X-KSE-AntiSpam-Info: Version: 6.1.1.11
X-KSE-AntiSpam-Info: Envelope from: k.yankevich@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 75 0.3.75
 aab2175a55dcbd410b25b8694e49bbee3c09cdde
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_black_eng_exceptions}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {relay has no DNS name}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info:
	127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;87.226.253.162:7.1.2;omp.ru:7.1.1;spb1wst022.omp.ru:7.1.1
X-KSE-AntiSpam-Info: FromAlignment: s
X-KSE-AntiSpam-Info: ApMailHostAddress: 87.226.253.162
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 59
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 11/05/2025 14:45:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11/5/2025 1:23:00 PM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

The function already initialized the ivsize variable 
at the point of declaration, let's use it instead of 
calling crypto_skcipher_ivsize() extra couple times.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 57d67c6e8219 ("crypto: rockchip - rework by using crypto_engine")
Signed-off-by: Karina Yankevich <k.yankevich@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 9393e10671c2..e80f9148c012 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -321,8 +321,7 @@ static int rk_cipher_run(struct crypto_engine *engine, void *async_req)
 	algt->stat_req++;
 	rkc->nreq++;
 
-	ivsize = crypto_skcipher_ivsize(tfm);
-	if (areq->iv && crypto_skcipher_ivsize(tfm) > 0) {
+	if (areq->iv && ivsize > 0) {
 		if (rctx->mode & RK_CRYPTO_DEC) {
 			offset = areq->cryptlen - ivsize;
 			scatterwalk_map_and_copy(rctx->backup_iv, areq->src,
-- 
2.34.1

