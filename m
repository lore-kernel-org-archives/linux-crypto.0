Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D26299AA3
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765801607; cv=none; b=nc0TEVFPtV1e2TvxRoYYihXOkFQAeWoPqlT+BuCe019nt5UCNYiVIgWjWgO3Lmg6tiAqcq3aMSkIviTdW8ldfuycBpJotHRfaGpGCy3PXVr7d0OvBsvmL4QB1yJx710/UBzW6ljk4V3nirtGFQG28ZdycK72mg38iDORwovqtTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765801607; c=relaxed/simple;
	bh=XBGKZ/ITWegS8/ZOHvxWMsrdL4N3bSH2oHummdA8vgo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T2l0NZiulyEnEd6FUMGO+2exXaifSTBRTH6HqWADyrqOKUYz5EPsp2jZqbqNKkuqkWxwkRM9I9jKDvpMMwT13/X8pO+S2QovHuyAaryk2BOGSq5es6CMro/B0I9bMDohLpcUVbjmnjxJPrk+1gIJth/Iltf9cHZVUehSh7byoIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AaU3J27r; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AaU3J27r"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765801599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MW5H/hhDK3ViWMzsjxgvpJkjVz/r8K1RDrjdz24ubXo=;
	b=AaU3J27rkREZl98Fuz8kBeSs0paOtwoJjMtSFpYDTVgQEpmFGYWpGR3rXw6ceyov3Y/9qm
	OY0/F6dQWIYhP8oz1uMp2LSILnqqd1bK7xqRYZFI6JsuwXOxTjcu2sbINdVuV8ODIPTUA5
	XQy1x9Q+Yl/hoQT0EdK30skNyPv4dtY=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: octeontx2 - Use sysfs_emit in sysfs show functions
Date: Mon, 15 Dec 2025 13:26:05 +0100
Message-ID: <20251215122608.385276-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace sprintf() with sysfs_emit() in sso_pf_func_ovrd_show() and
kvf_limits_show(). sysfs_emit() is preferred for formatting sysfs output
as it performs proper bounds checking.  No functional changes.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index 1c5c262af48d..f54f90588d86 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2020 Marvell. */
 
 #include <linux/firmware.h>
+#include <linux/sysfs.h>
 #include "otx2_cpt_hw_types.h"
 #include "otx2_cpt_common.h"
 #include "otx2_cpt_devlink.h"
@@ -507,7 +508,7 @@ static ssize_t sso_pf_func_ovrd_show(struct device *dev,
 {
 	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", cptpf->sso_pf_func_ovrd);
+	return sysfs_emit(buf, "%d\n", cptpf->sso_pf_func_ovrd);
 }
 
 static ssize_t sso_pf_func_ovrd_store(struct device *dev,
@@ -533,7 +534,7 @@ static ssize_t kvf_limits_show(struct device *dev,
 {
 	struct otx2_cptpf_dev *cptpf = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", cptpf->kvf_limits);
+	return sysfs_emit(buf, "%d\n", cptpf->kvf_limits);
 }
 
 static ssize_t kvf_limits_store(struct device *dev,
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

