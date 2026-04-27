Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9DE30DEAC
	for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 21:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777325726; cv=none; b=EPAbMonNT3zHiQjSD+Ba+FdImCXg5I675qzwvnk7WksQz9Bf46QMiYb5WvfX2rY23JsEotEhHi5AbZT8BXLw2rn2iqqLhpagTEiAMWY3qwEgmHjsMNfoo2w+9ySm38nGvHserDoD9MKdSZ56ki7StrX5Jntp9TVZWG1sNsGb5To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777325726; c=relaxed/simple;
	bh=qgllXYA1bcpLBesDHMwFUEhsRnB93WJWpcDX9NlloQI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IBsZ4yCFiYRH6qk2A+64MPaY445wfmImU57s6TEGvIQFG/beJGCWmn0b+wCq9j9b6GTJwrGjBs5f+ZOzXNnTk+VKhxZ9J18DREdR/U3pCnRbRTXGEfpvpHCALZF1U1k8fJILPTCaHSaRTnf3lVuakgkdaNhFUhluH9Guscy8o0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uDqsTYm6; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uDqsTYm6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777325722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3FGIRSJ7hIXl4Oys064lCYYDG01CT2U3Bca8yeemABc=;
	b=uDqsTYm636Z2C8hklYdb0bUCWNG2vSFXywuToYYVQVpdJ3vQpfoOj/n5Y4/bXcCf7nIlj1
	OdII6zUXKCO7l/D1fKILeRJoi+QClEWQoaRTUQxZdXZltcc15RtK1YlsoPXuMX+WeCpWtH
	PA1qPaXukIz2BmT38E409CmokqhxJ6Q=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: starfive - use list_first_entry_or_null to simplify cryp_find_dev
Date: Mon, 27 Apr 2026 23:35:06 +0200
Message-ID: <20260427213504.420377-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1211; i=thorsten.blum@linux.dev; h=from:subject; bh=qgllXYA1bcpLBesDHMwFUEhsRnB93WJWpcDX9NlloQI=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnvr3W81uR99WJCl8vV3UbrpXzur3F8qiMrmxZwMixfa rJEZZttRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAExEaSPDP41T834KdUSECtql ePt/CeVr0vBSqTBbJyK1OnrihuY7Vgz/7OfUbmiukjHTeLhsxy+9FIG5D1iNYsrOZ/3ymMYYMmM 3KwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use list_first_entry_or_null() to simplify starfive_cryp_find_dev() and
remove the now-unused local variable 'struct starfive_cryp_dev *tmp'.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/starfive/jh7110-cryp.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index 42114e9364f0..e19cd7945968 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -36,19 +36,14 @@ static struct starfive_dev_list dev_list = {
 
 struct starfive_cryp_dev *starfive_cryp_find_dev(struct starfive_cryp_ctx *ctx)
 {
-	struct starfive_cryp_dev *cryp = NULL, *tmp;
+	struct starfive_cryp_dev *cryp;
 
 	spin_lock_bh(&dev_list.lock);
-	if (!ctx->cryp) {
-		list_for_each_entry(tmp, &dev_list.dev_list, list) {
-			cryp = tmp;
-			break;
-		}
-		ctx->cryp = cryp;
-	} else {
-		cryp = ctx->cryp;
-	}
-
+	if (!ctx->cryp)
+		ctx->cryp = list_first_entry_or_null(&dev_list.dev_list,
+						     struct starfive_cryp_dev,
+						     list);
+	cryp = ctx->cryp;
 	spin_unlock_bh(&dev_list.lock);
 
 	return cryp;
