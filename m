Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09DB3D4103
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jun 2026 23:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780701099; cv=none; b=Bsm/+cds6Nk9QEazJAx4zCSmOmcCbfonoMB4QqHHwvHWSNBfhOjVq2xidjSG30XBhsXvSdScD0csxoeY3pb0nIYtrrRqmEgyS4YeL+NW8AWGrfm3X/pANmzOGwV7JAvQhdDIAEmYECXAgXl7VYnP6q3jn1YquWCnmqeVcDUx/cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780701099; c=relaxed/simple;
	bh=a/enk+eANyIgyQleSoJPuHNM1/k3ZrNDkE1GeAUhZU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZlGLraKQduALZlzEP9Rx0aI/fKYaCGLT5NLN4CwjuT7YiEUdzj/rnFGj/EdS+uedrhdIWzFYst73hGKD9bg8+8FY88qsuNfjbJnrDIdtTaLhPF0XYnutO/eFjn0aMJST1HQQGI6qrZmgfu+cCPCwtNdrFCGMCuplBOro2DTDxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dvFNa0i5; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dvFNa0i5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780701096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8eHCBkCKvXRNQUKgss+sOaOi4DZULFW/LQPXYHuT8qw=;
	b=dvFNa0i5ze0/orkdHB2XcCXozvUQc95WC2rNn/ATxNdurwk9jPb+z3VgnI4KpV+Tn4trnM
	D1PFetjxOWnjfaAwC5X5n8e94MMowfhb/rd9mplcdVTkhAzzX+KP++Jy35Lith6paghHX+
	UQ7nj3NAz2Ypajpw1FvPTYfMB12NTXM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qat-linux@intel.com,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH v2 2/6] crypto: cavium - use 2-arg strscpy where destination size is known
Date: Sat,  6 Jun 2026 01:10:59 +0200
Message-ID: <20260605231056.1622060-10-thorsten.blum@linux.dev>
In-Reply-To: <20260605231056.1622060-8-thorsten.blum@linux.dev>
References: <20260605231056.1622060-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1059; i=thorsten.blum@linux.dev; h=from:subject; bh=a/enk+eANyIgyQleSoJPuHNM1/k3ZrNDkE1GeAUhZU0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnK4Q3se36c5NnSf0667KO/ud0BZ9XGE3b/1DP455/8f sBuUWVYRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEwk+QTD/zyel99LugInl85g /ZzwkqXnW5XVvKM2/47z+melZqWwTGNk+MonlhexuGNzHj/DisUJK58/szp89X6rIr/v8wuVcjd KGQE=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To simplify the code, drop explicit and hard-coded size arguments from
strscpy() where the destination buffer has a fixed size and strscpy()
can automatically determine it using sizeof().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/cavium/nitrox/nitrox_hal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cavium/nitrox/nitrox_hal.c
index 1b5abdb6cc5e..e36c1741bb78 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/delay.h>
+#include <linux/string.h>
 
 #include "nitrox_dev.h"
 #include "nitrox_csr.h"
@@ -647,7 +648,7 @@ void nitrox_get_hwinfo(struct nitrox_device *ndev)
 		 ndev->hw.revision_id);
 
 	/* copy partname */
-	strscpy(ndev->hw.partname, name, sizeof(ndev->hw.partname));
+	strscpy(ndev->hw.partname, name);
 }
 
 void enable_pf2vf_mbox_interrupts(struct nitrox_device *ndev)
