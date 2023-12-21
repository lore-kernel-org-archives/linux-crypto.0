Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE284C60B
	for <linux-crypto@vger.kernel.org>; Thu, 21 Dec 2023 09:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="rzXpcEbd"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BL7vQ1R003779;
	Thu, 21 Dec 2023 01:32:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=PPS06212021; bh=NEy4Y
	fZoK6dde2Wp78jOszDNCbWSSKjzlT2mOSNpclM=; b=rzXpcEbdZycGgFRuWoMd5
	nN8Hab8MziViybGcOsqjZZkAeTgOZk9PTjuGv6ojulAy3qejT6ZjQbv4aeyMW7uK
	DxbgJ5x/uFjhT86Fq31ApkbGMgI+TOKBcoCEV5IEYm2T+V7/v8uDw8ezsRTfXXYl
	l/Bd4Zvp8UyCTkBmVmLAehw1rPChFqfGnodg3z6WtJSDBP7gJa+knxGVZiOs5PK5
	f4LYlvW83i3KN2CtyW1+e1uDp/vuyGPECmX2KAWeW9BcwoVm93BQkZfciFj9V+fZ
	YjWm/4ayXg0DLRnagnTAjXx90t1JVG1qTCw/2XzpaoLAJDvN8IBTGvHD181hBcIm
	g==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [147.11.82.252])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3v1824p39m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 21 Dec 2023 01:32:13 -0800 (PST)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Dec 2023 01:32:19 -0800
Received: from pek-lpd-ccm2.wrs.com (147.11.1.11) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.35 via Frontend Transport; Thu, 21 Dec 2023 01:32:16 -0800
From: Kun Song <Kun.Song@windriver.com>
To: <horia.geanta@nxp.com>, <aymen.sghaier@nxp.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <filip.pudak@windriver.com>,
        <heng.guo@windriver.com>, <kun.song@windriver.com>
Subject: [PATCH v5.10.y] crypto: caam/jr - Fix possible caam_jr crash
Date: Thu, 21 Dec 2023 17:32:09 +0800
Message-ID: <20231221093209.984929-1-Kun.Song@windriver.com>
X-Mailer: git-send-email 2.26.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: UE_G9Ze_DlBuojYkfnYnRnZGjGuDz_yq
X-Proofpoint-GUID: UE_G9Ze_DlBuojYkfnYnRnZGjGuDz_yq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-16_25,2023-11-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 mlxscore=0 impostorscore=0 mlxlogscore=893 lowpriorityscore=0 bulkscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312210068

Test environment:
  Linux kernel version: 5.10.y
  Architecture: ARM Cortex-A
  Processor: NXP Layerscape LS1028

Crash in reboot tests:
  Reproducibility: 1%

If a job ring is still allocated, Once caam_jr_remove() returned,
jrpriv will be freed and the registers will get unmapped.Then
caam_jr_interrupt will get error irqstate value.
So such a job ring will probably crash.Crash info is below:
--------------------------------------
RBS Sys: Restart ordered by epghd(0x1)
RBS Sys: RESTARTING
caam_jr 8030000.jr: Device is busy
caam_jr 8020000.jr: Device is busy
caam_jr 8010000.jr: Device is busy
arm-smmu 5000000.iommu: disabling translation
caam_jr 8010000.jr: job ring error: irqstate: 00000103
------------[ cut here ]------------
kernel BUG at drivers/crypto/caam/jr.c:288!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Hardware name: freescale ls1028a/ls1028a, BIOS 2019.10+fsl+g3d542a3d22
pstate: 60000085 (nZCv daIf -PAN -UAO -TCO BTYPE=--)
pc : caam_jr_interrupt+0x128/0x130
lr : caam_jr_interrupt+0x128/0x130
sp : ffff80001144be50
x29: ffff80001144be50 x28: ffff800010f61008
x27: ffff800011228000 x26: ffff800010f61008
x25: ffff000027904800 x24: 0000000000000072
x23: ffff8000113ba140 x22: 0000000000000001
x21: ffff800011433000 x20: ffff000027904e80
x19: 0000000000000103 x18: 0000000000000030
x17: 0000000000000000 x16: 0000000000000000
x15: ffffffffffffffff x14: ffff8000113ebcb8
x13: 0000000000000008 x12: fffffffffffcac8f
x11: ffff00000038bb00 x10: ffff8000112a1e90
x9 : ffff8000100a99c0 x8 : ffff800011249e90
x7 : ffff8000112a1e90 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000
x3 : 0000000000000000 x2 : 0000000000000000
x1 : 0000000000000000 x0 : ffff0000279ac600
Call trace:
 caam_jr_interrupt+0x128/0x130
 __handle_irq_event_percpu+0x84/0x2b0
 handle_irq_event+0x6c/0xfc
 handle_fasteoi_irq+0xc8/0x230
 __handle_domain_irq+0xb8/0x130
 gic_handle_irq+0x90/0x158
 el1_irq+0xcc/0x180
 _raw_spin_lock_irq+0x0/0x90
 caam_rng_read_one.constprop.0+0x248/0x370
 caam_read+0x8c/0xb0
 hwrng_fillfn+0xfc/0x1cc
 kthread+0x14c/0x160
 ret_from_fork+0x10/0x30
Code: 2a1303e2 d00029a1 910ee021 940b2b1d (d4210000)
---[ end trace f04d90f3ad0da5f4 ]---
Kernel panic - not syncing: Oops - BUG: Fatal exception in interrupt
Kernel Offset: disabled
CPU features: 0x28040022,21002008
Memory Limit: none
--------------------------------------

Disabling interrupts is to ensure that the device removal
operation is not interrupted.

Signed-off-by: Kun Song <Kun.Song@windriver.com>
Reviewed-by: Hen Guo <Heng.Guo@windriver.com>
---
 drivers/crypto/caam/jr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 6f669966ba2c..d191e8caa1ad 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -135,6 +135,10 @@ static int caam_jr_remove(struct platform_device *pdev)
 	jrdev = &pdev->dev;
 	jrpriv = dev_get_drvdata(jrdev);
 
+	/* Disabling interrupts is ensure that the device removal operation
+	 * is not interrupted by interrupts.
+	 */
+	devm_free_irq(jrdev, jrpriv->irq, jrdev);
 	if (jrpriv->hwrng)
 		caam_rng_exit(jrdev->parent);
 
-- 
2.26.1

