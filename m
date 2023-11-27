Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0FAD62;
	Mon, 27 Nov 2023 03:28:13 -0800 (PST)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Sf3GV0bYzzWhbC;
	Mon, 27 Nov 2023 19:27:30 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm000005.china.huawei.com
 (7.193.23.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 27 Nov
 2023 19:28:10 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<songzhiqi1@huawei.com>, <liulongfang@huawei.com>
Subject: [PATCH] MAINTAINERS: update SEC2/HPRE driver maintainers list
Date: Mon, 27 Nov 2023 19:24:49 +0800
Message-ID: <20231127112449.50756-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000005.china.huawei.com (7.193.23.27)
X-CFilter-Loop: Reflected

Kai Ye is no longer participates in the Linux community.
Zhiqi Song will be responsible for the code maintenance of the
HPRE module.
Therefore, the maintainers list needs to be updated.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 97f51d5ec1cf..de394b632b99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9542,6 +9542,7 @@ F:	Documentation/devicetree/bindings/gpio/hisilicon,ascend910-gpio.yaml
 F:	drivers/gpio/gpio-hisi.c
 
 HISILICON HIGH PERFORMANCE RSA ENGINE DRIVER (HPRE)
+M:	Zhiqi Song <songzhiqi1@huawei.com>
 M:	Longfang Liu <liulongfang@huawei.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
@@ -9642,7 +9643,6 @@ F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
 F:	drivers/scsi/hisi_sas/
 
 HISILICON SECURITY ENGINE V2 DRIVER (SEC2)
-M:	Kai Ye <yekai13@huawei.com>
 M:	Longfang Liu <liulongfang@huawei.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
-- 
2.24.0

