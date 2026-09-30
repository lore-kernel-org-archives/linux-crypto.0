Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1234A496D5C;
	Wed, 30 Sep 2026 13:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773226; cv=fail; b=PQTvCP7YN6dU1n8Z++boFphs0dzFeZLFo+S0RSIbdVjyuvb6z9Ddy5o5VKg/ThydzAcnBN8GGE9WOFDRweJQIb8h1VhaB6TGmPXkIluUybLb/+uI/m7E4HZEACCA0l1RzbjCZsvywKZJ6Lm7WTFgUjLv9QcMqh14f3RQS+DcmkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773226; c=relaxed/simple;
	bh=qBUYG2sjro647FJpLvksAaXi12maZFHc7xqt2vHo8Bc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cusg+nL7Y9120QVcOn67+mG5ldTVsrZLDijIn2o01kkfwWWpLolgXv/fWtLZxKqqMmODQalZJja8QZH5WDq5nXYu05xPxBfO0P49D41i8wsxNhpt7gJXJH4KxoZogHmYpNCh9zu3gz3LEpr2pOTopFhz/xNAjbx1mud5e9EfEJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=OvlZSEwX; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=Z9QQhGJA; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="OvlZSEwX";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="Z9QQhGJA"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB5v1r3214059;
	Wed, 30 Sep 2026 08:00:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=qWHF7NNzv4awW2+8gwJTrassw+kJjkK4k5fi3/GTn
	WY=; b=OvlZSEwX5lB7D4TasW4VvD8k5ewoksKD+6lpVTjamPsODJQdeCvLyJ1bP
	d0OpymTucByn61WkzxCskyaQWSw+CKgOrmiTmf4oV7TPnp3+ruH2coxH2NiUpOyP
	xePd0ROuwr3knz3WO32fV+xryrkEplqdTqtyYHd2F3CoMdV+uDUp/DsNlv75imZ7
	jv7lYhXX78TnzCKpSukl3LITuPXzgolMiX80/Gv7BxokkUHZk5RyVGxIQqcaLRFN
	wte+Nbs9xXnhabeQIXi/dfOgNv3nR/s4OxZGNcszBS2YdW6Dlxnp/N8MExJF8sBi
	KE2qzSzNV0enyvuqEK5I4mFQvAjrQ==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0ydv95sw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:00:07 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rw7QRfaq/yi0VXBOqbFz2cgwriXCnYANkQjl0UCBIH10AtJ64dXpu//iPyf9bfM/XoFZkqSwlSX/qReSkpj46ofisTc8BDa4PB6HfabIit8r8E4NJEjToQlGX5C33zqiH7jdD90IPUZyQrWQj+t/9td8LoUBKuzdu09+yLDDzZKUDvJaP/AcWFX1rDhAYeLzXhVE0dPQfTPS8JyV7xlNI86NNpb4wiPtNQEDjzUv0FAALT/Kl5/sKU2ZE5SkGue1RRxYm5Nk9xKYdjMt/wKEkDl53Mms8Ir9oLx9k2lrKYNuIs/CHWA7acZsSgyAOiss08mjMd9ca0nZU9KVjjBCEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWHF7NNzv4awW2+8gwJTrassw+kJjkK4k5fi3/GTnWY=;
 b=pX8eU70v2helAqawy6/NUBu4VvYf+WOr4Rv/9GHc94UsTCJbZRK9ABMQ221vOrKnNF6RIUkr8Wm5TrFKtTtlOoJpHDicSqlf9c5pFh4/4g9MluNvWndmpCZgFodxU/9lK/kanFgSLXZyNuZYvjDaWeSdEe9/jtNWY+SM/tlsPZHX5mxO3L2qL7G3RGXXVvsSE3VXN6ooPt7PyRDkhAlQcKK8y1PEryhfIcEVIbc+cr5kNX2a85ReeagUhqTntFvLoekNAqSkSha5UZ/MWE20R9/YZoytB1oo6OSfFB+e6qM6VxidvZjYk8lFOb/jtN2ecIpCAPXuTKht3AWtJrNYsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWHF7NNzv4awW2+8gwJTrassw+kJjkK4k5fi3/GTnWY=;
 b=Z9QQhGJAIylN0bj69hlhWyZsZNbokDX2rRpfGipizpkRJMZwV12lOea+FETy9V+JoyUN7ELbVkEmllZl3ew2C3Ou37FQzZ4Y1MC4weAOC0nWa0Qdi732EqzJhlTy/lYOdMxNcG4CXiIMqzBNzjQekU17evThJv95ckfx+Z/Z4GE=
Received: from BN0PR04CA0148.namprd04.prod.outlook.com (2603:10b6:408:ed::33)
 by PH8PR10MB997765.namprd10.prod.outlook.com (2603:10b6:510:39f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 13:00:04 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::59) by BN0PR04CA0148.outlook.office365.com
 (2603:10b6:408:ed::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 13:00:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 13:00:02 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:12 -0500
Received: from DFLE200.ent.ti.com (10.64.6.58) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:12 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:12 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxBR63153715;
	Wed, 30 Sep 2026 07:59:11 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 02/15] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Wed, 30 Sep 2026 18:28:46 +0530
Message-ID: <20260930125859.1749849-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930125859.1749849-1-t-pratham@ti.com>
References: <20260930125859.1749849-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|PH8PR10MB997765:EE_
X-MS-Office365-Filtering-Correlation-Id: f176eebb-fa81-48b3-2ce0-08df1ef2be23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|23010399003|1800799024|10067099003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	p6TQC59augHbqDI20fbXudRD4Lbu11XIzslGS1yMBpDcb2gduavuuLfbqXqS5IufoyBeliVSi6TsyuV6H5chXBi4uPmc5AbD3SbaLNvtz3yN6SwFa8urUMz/J/pg0BSJXJYpxB39dI/WJApHdVTCKFpVZGqDPKwbIsddk4RuHz8/l4ap93w9I2XtmMcFJFtONeC6XxnlyyevDxls3jlzrFoAQVS/IDN2+jMUon1Ci4lZWBz/kEx3e4RohWLl3CHWnF/3Bv3ATMiqE+PUP2cjEUKrNNfWYFGs7ErdFz3jF2sx3rxOWXrmkiosp0LuYx0c0Nkvy+HpUeKBX+914ebjNB7Uk4hUuBBt1tlzn3z7yF70Vpko2lWLbmTzM2QKOe9bRbhfbNlAnDwqOpA3t2niAcCV5yaHTRJhYeEIb/qCOQjLbji9QSm6Ld5ps5bHpRkQlWuqozyMMiaHivkvNazkjRYrrpV4UC4DrVG6m9m2BePQMa01iWmLeOLObCHrZWBkRNCDKiZHnIKvPo4w+AhdxqLniwuyf8Y8N4v7hICxxmaB2Qj6e+NVe5/RYGPcY8XNtWt9ZCWkKpx/qmum1KRgZG75h6ikrfTFJb99AG2DmUuuibEce2g45cygsgr2DXwwf2t8DpoWsf4qm7ZuBYpMt2iGUEBdM4vcedLghvg8jaSTTX5tEQDMZxBdJlX0be/Z+/NY2nvu7ZtQFLJdut103Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8UP/r11GQSv6P7IOyLwGTvM54Bp+sT1uir+usTwbrhehhlqo/Y8KGyYLUzKA+46glrdDauqaLRPMxAqGY59ne2z+mHZ5fdglleqk578C5GybMEvKtVj5VtHU3a+UnMR3csJXaXd3pGn2oZvBrFYCVJ0xW4eyuk16YgJQjQwxgPIS5BJLcs1KQgv6YGGBy1h1tZ2ncOBcruRYZ/5ZUY2dzbRsQdovIjU1Pz3x2SiVpBQvSiEtjOjBliazijfIROYFSCYYnXzsDAEx+VI0N9tcpCc/qR9VNfgNkx4VuSbPnHZQaDVuIxT+anU742h/UtS80B3lpYn+s+ajyWSBSbJBqjxzKW0fbqkyIUjm8YMFnOQIB6dvvw5M9od8Dwz6zfYrv8skx5L+SRGPXR3TJsHO66AGQaAfU4w7OToD/ym0IwlugfyHQiXpIrzeFYDzJePi
X-Exchange-RoutingPolicyChecked:
	1ua11JK5/pfLJ9Sbks2HZ6pd6y6xKVr4yk4o04sVuhP3dt7L7r5EK/WcsUs+Kdp8mGnx71u9Z5ooEt0VXT19I8F507Ur7u69tU+BLs1Jekz4XomoZdsPAGntQig5vJy35/S1xJBk26fKR/JK8bN0c13n5e7SGQ3x/1ESQlx6IAc8O6MDgy8IJg+PTzIIz2COp6rTLm2l909t02U0F/DcHBdM9szcQrV0xYSrcrbV9hIzRKv5fVp0gFKgQkcmlMyc7JAtaGj/gJe3bqj3dCQUyeB3JpjXDMorcvMwjfL2eET5gKagUqAFdsYbcZoEAYjSpoUGZ4u3Nnu5z3BaEKEAZQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 13:00:02.9551
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f176eebb-fa81-48b3-2ce0-08df1ef2be23
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB997765
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXyCabSfPrcUEy
 VzQW//8GJLrAOl0KCVUyqPPuqA8s56LCB2tx/n9pRuDk3+qHeGNJY+01sJeHJKfusotV/3WVKU2
 Aq2X1RtZy3+moMibtHXb0Avl5Sqz5II=
X-Proofpoint-GUID: Gt0IpGnyFpki2vX7RxXCTipS857hpQWD
X-Authority-Analysis: v=2.4 cv=TegDJhQh c=1 sm=1 tr=0 ts=6abd07d7 cx=c_pps
 a=QD3RM0NeKQHimiaxCRpEvg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=HiAi_RwYt-Wiez6k4EgA:9
X-Proofpoint-ORIG-GUID: Gt0IpGnyFpki2vX7RxXCTipS857hpQWD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX1f/iE9IOrOFG
 OpKBYJ2b76X/PHIVw/UZhQKBzY2VyvLFM72mPE+nBZsUQDQ9DYC7KOLililsyem1vOQ0JgblNNF
 jEjPDGjcKDlfvv3nckfXI7BysNasp7SdUbmgg5SLW5XI+IiUEFeer8LKrNxhUwFoAW6nw9EOdyU
 cJ2c8xb16GlzU2n2LkYm59akki6adWqtj7yXEeDLyth5AxW5r3fYRvfDQ9bp6RKfJRMQZe+SLmk
 +CaFqpOGepMDxplt3XpYRiRqiMenfaI7k7sCmuWL8/td47iIHbp61n2wEl/Kx2m0eO931v9KvQa
 1kZ3BNcGYLaI8X05AIHmBq8m50rtqXglN8jUYc+FZjsjmaNYiuicf2zayMTouKC6kU33e2SJDWH
 kDifyQv7LaRm74g0pLpgeqlH7wEmD2Bad8oSc8LBJqxD2vMnmfpOGCZSBg7JZMQTWqrXXiMDzsR
 bIJRB6F7kYgyUSjiQiQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

Probe and remove functions use spin_(un)lock for acquiring the
dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
spin_(un)lock to spin_(un)lock_bh to avoid potential deadlock when a
softIRQ process tries to acquire the already held lock.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index cb4b8b38a5ec8..1886538168103 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -154,9 +154,9 @@ static int dthe_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev_data);
 
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_add(&dev_data->list, &dthe_dev_list.dev_list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	ret = dthe_dma_init(dev_data);
 	if (ret)
@@ -200,9 +200,9 @@ static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
 
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	dthe_unregister_algs();
 
-- 
2.34.1

