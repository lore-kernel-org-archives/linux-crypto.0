Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ED92032D;
	Mon, 11 May 2026 00:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778460581; cv=none; b=ow5KsccJfFVoAhC6z3kQz9OLFuf15HdIUwBgUusgFkGMW6YdrK77+Kdp1xEXMLnmcj10KB82yyozaJPWs7pN6T+0N2Dq9iKQsJWGPtXmjLklu9DOBKgRloDO/TLDbgb61R+dHSpUSyZ5XYKMBiSfRXrRJKlmAfZzDDUnJ/crBaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778460581; c=relaxed/simple;
	bh=gs1HB7emQNi8Q66rLB/GEImFaxeNp14wWV3c6AhIvgA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TzzrcrXl9d3K+3dp6Ax7YUwIVfCzjqF8tJ58iWAPXKm5F4UO6bQZ7JZgpP5rwo5uTkEFcoKBaPY1OBh+ArFZ1Lei4HNScGaq6mg9xZXP3a8PR7hxRcLk7xNwzEtdjFEQ9BwfErboJpXbLKExkdzikTmna1YjsGJFuOy7lM863hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=sLjnjzAr; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="sLjnjzAr"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=z50qWErVEo77SkfGAkAgWi+on+P5jOv4G7LhP+/oeR0=;
	b=sLjnjzAr+0KToQu2Tl6n80uTa47dSnkjxaNXYSA+mjfUR/vuF56BptgQYXrBGM6GmcKrZzPrk
	lKjwROyQVMa3VwRYlFrYA3N7Uw6rXYG0MmhZOibYuBN9UhEe7+gTRoIq5RhKfQxM5EjDrCQixKf
	1StVtvwZ6HwWHoFkM8bntsE=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gDLX36fHtz1cyPg;
	Mon, 11 May 2026 08:41:55 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 50C294055B;
	Mon, 11 May 2026 08:49:30 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 11 May 2026 08:49:29 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 11 May 2026 08:49:29 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon/sec2 - lower priority for hisilicon crypto implementations
Date: Mon, 11 May 2026 08:49:27 +0800
Message-ID: <20260511004927.3469951-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: lizhi <lizhi206@huawei.com>

Lower the priority of HiSilicon's crypto implementations to allow more
suitable alternatives to be selected. For example, certain kernel
use-cases do not benefit from HiSilicon's symmetric crypto algorithms.
This change ensures that more appropriate options are chosen first while
retaining HiSilicon's implementations as alternatives.

Signed-off-by: lizhi <lizhi206@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 2471a4dd0b50..77e0e03cbcab 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -20,7 +20,7 @@
 #include "sec.h"
 #include "sec_crypto.h"
 
-#define SEC_PRIORITY		4001
+#define SEC_PRIORITY		80
 #define SEC_XTS_MIN_KEY_SIZE	(2 * AES_MIN_KEY_SIZE)
 #define SEC_XTS_MID_KEY_SIZE	(3 * AES_MIN_KEY_SIZE)
 #define SEC_XTS_MAX_KEY_SIZE	(2 * AES_MAX_KEY_SIZE)
-- 
2.33.0

