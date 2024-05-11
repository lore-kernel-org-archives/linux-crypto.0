Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24E037169;
	Sat, 11 May 2024 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715439036; cv=none; b=RxndVzEkHHmGOW+L3oKAl4h6pdV7CAs6bWCGM+XFuzz8TX0uA0icwcdO1I2S7oGyn71lTDajtWhZkxPQ9/EO0790cytfU3dpC1UmxH83ac0oQbilODXmi9mO9ktHuul66u7umyUQVjfdEvOV8xNx6g0MWYgb6CIunHuf9Z/8oWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715439036; c=relaxed/simple;
	bh=Or4B34c3rYVTCVE0dgMdafyit7OgreMhX6CT0OCT+Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oXXEtgjZTGBnuf9nhS0XR5kvxi7HewOJ4NUANQBPMe/7XudxpaaXI3Ijp+0laolnkwDIsKtNMcLzJwY/Co9B/KPRJvvb89kcC7r9PlQmuChqnecGx5iUYS/rDVF9+DcS7nKUYL6EneC+OjlPDvHQqsKrfatYHioue7DTGNg5aVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=U1pcO8nx; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="U1pcO8nx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=fhaEOquCPm5KL0XeqYcL2P1KsEnzAksVwgM2ZGUXBPY=; b=U1pcO8nxXd2Vmbl8
	1/GJd2iPMCb24wDFtEtymoMs8eBCE3xr4/SXnNJeIwMcrFrHgOSsffEgjEBIoq0tNjXIlqUTGKRq0
	CF0c0SDgXFQ8LqnOzDCYYzX3MAW6L/otD6dDgXnzNYanTSBjzl+n61OWyNJGzCqJTC9IwP8XNV/I+
	mPsiCubx4qxYyLjEKHhA1oz3sG/YKeKobeBZFRUvbyOdPZkOG4pTiGrzIVAb/4Vqba0GEQfnNjN8E
	qOdzsUwclq45/v7gQkAEGVPw4dvDOLxAyBVJ26AuYZfraLGjYjaGg/2H4BdM/PG135cD3YaCA3+19
	o+IYIX7LcbowJInaqw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1s5o3H-000W38-1U;
	Sat, 11 May 2024 14:50:19 +0000
From: linux@treblig.org
To: jesper.nilsson@axis.com,
	lars.persson@axis.com
Cc: herbert@gondor.apana.org.au,
	linux-arm-kernel@axis.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] crypto: acix: Remove unused struct 'dbgfs_u32'
Date: Sat, 11 May 2024 15:50:17 +0100
Message-ID: <20240511145017.226166-1-linux@treblig.org>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

'dbgfs_u32' appears unused.
Remove it.
(pdma_stat_descr is also unused, but I'm assuming it's
some useful layout description of firmware/hardware
so best left in)

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/crypto/axis/artpec6_crypto.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index dbc1d483f2afa..75440ea6206e2 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2811,13 +2811,6 @@ static struct aead_alg aead_algos[] = {
 
 #ifdef CONFIG_DEBUG_FS
 
-struct dbgfs_u32 {
-	char *name;
-	mode_t mode;
-	u32 *flag;
-	char *desc;
-};
-
 static struct dentry *dbgfs_root;
 
 static void artpec6_crypto_init_debugfs(void)
-- 
2.45.0

