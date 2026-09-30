Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D3A46C4BF;
	Wed, 30 Sep 2026 11:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767577; cv=fail; b=JHX83rbTg1blP6tN9yJXo2jgt4kopOG7CaOyktXDtjkUpJIftwYXQF4tHQsd/+/MaG7TitLVUGwN7xzZlllneqRXWFYP00FbnbBY/W9Mux3OZygR3WPwLeCBc+S8W1bghKN4Idhj8BiqsDHyp7tIksQOmgxKnQMWI2nxaIIrKqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767577; c=relaxed/simple;
	bh=qBUYG2sjro647FJpLvksAaXi12maZFHc7xqt2vHo8Bc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W5ZiNURfseV+QEQfcyEzQvSsXj6KhW0pLTVhxeOunigiFoWDeHoN9ulnPIqOGnKqBfOdrV7DR5Hsl47/rK0TFkg0Q6koBxhl9dQUvm4oepFXUQXROp4iWb78Tv3FD9CIJgUTXWLTdH03QR6G7rP6Yc/RHwqVlLcrXCpYZo9p/1A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=mbYA6s6W; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=Umit7NkY; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="mbYA6s6W";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="Umit7NkY"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5e8t2989907;
	Wed, 30 Sep 2026 06:26:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=qWHF7NNzv4awW2+8gwJTrassw+kJjkK4k5fi3/GTn
	WY=; b=mbYA6s6WBll4FivlIVTq1wmWbkJg2G9RzpWhHuHRJkk0j4fewTTzHaI4A
	aYPH/zjQ/pZ2lRwONcztVAvgI7bOGOsfKwqLqrzQIYw/utumX7NB+FcJ8K1+X3ft
	nkM6ff2+PM6rpBnsvj41/P035nZ4x+aYw3nr5BXAJB3tOHtagB5mz47jWrsM1VZp
	5B+UG72zUMYMwyP5C7L0zVxcILxOKlf16neu/G0DRTBm2wwidxK3HNVk5lTuv3kk
	S0PgAKuOHcxTyCdNz9n1S9DxQR2C2KpuUUWB6qt84r/mu0dBCOCGhWam4CEI5O+g
	YvbfuEwgE9jvOfYRmM6aDmXSWBcZA==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013039.outbound.protection.outlook.com [40.93.201.39])
	by m0380145.ppops.net (PPS) with ESMTPS id 4h10t1r7xk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:10 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DNUoeakxumEjJxpNQYF+fqfnar/7lJANjTYAGblu5HjRiSkeOePcV5C64SsKG8VodIvjwzO/OnIr6dvnPO2byuvEiMqZ7z/j026Jxrug1xhd14smJo/7FmlkE2k6SkgL4yL6bbLCzxRw3cIEN0QceFDDLZm2Pph0bjDYoX6MVNFvaci0XA4Ny0GGKlLPbJpMzb5bQ9nOgdZ/dJOVhgfYx/We9925jKEs0wlZLL+NyY8r2TbZ8kGjT7kcuAzTZ0d3kz+WpQ1QHyr7YbH0GxanlipAiCDf9XdrobC+m3bvPy5jRdtTxSzAXuapm8xZn2I4FxvLtMp8spEEMTMlg9+pBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWHF7NNzv4awW2+8gwJTrassw+kJjkK4k5fi3/GTnWY=;
 b=v6JfbQO7RQ4edI/xAvIjXtZJnF6/5LF2/5PVHY0evWrtJjcORp7epinWifHZZpzkBRtAq6R7s6rD5NaF3LPTy9hSRnepH3K2Xboasl+QiRb0aR7Rl6Z/rE71469SaBwlsyaLhezjTMKY3Fe0Rpo7GgSL6rVEUQsYYSPhC5TKKk7mdzz5ccyt0g6Fgvf7tWicwq+tNmJy7ufWygsn5kgVWqqbFeT2BdaaIK1r30i+Il5JNEEeTOngWtYi18FstgmsubmmEqNl/JLROxAcN2p57DoYI+dXzeNbPFZmslg9LdWaJ3jT45lzMO4G3WifBof7+2t4JDnfAv1YNw5g0jYRqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWHF7NNzv4awW2+8gwJTrassw+kJjkK4k5fi3/GTnWY=;
 b=Umit7NkYXj9gMYMqbDEldjb2IKl2Cuy6ZvDtXf8Z7UzL77eqUqWv6u2o4V1oGlkzlLM5pYzM1z2TcV87OYfOAnk7+kkQDw2SYIVLzrU/B0UaJyL4RxRraAVZ18BRwT8jHllQSWdLuHR/GqC8SjuuG3v8rMOfb2FbyJQXGnN+V90=
Received: from PH8PR05CA0015.namprd05.prod.outlook.com (2603:10b6:510:2cc::16)
 by MN2PR10MB4383.namprd10.prod.outlook.com (2603:10b6:208:1d4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 11:26:08 +0000
Received: from BY1PEPF0002696B.namprd05.prod.outlook.com
 (2603:10b6:510:2cc:cafe::72) by PH8PR05CA0015.outlook.office365.com
 (2603:10b6:510:2cc::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 11:26:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BY1PEPF0002696B.mail.protection.outlook.com (10.167.244.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:07 +0000
Received: from DLEE208.ent.ti.com (157.170.170.97) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:25:48 -0500
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:25:48 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:25:48 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBPlFo3025060;
	Wed, 30 Sep 2026 06:25:48 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 02/15] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Wed, 30 Sep 2026 16:55:20 +0530
Message-ID: <20260930112533.1593952-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930112533.1593952-1-t-pratham@ti.com>
References: <20260930112533.1593952-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0002696B:EE_|MN2PR10MB4383:EE_
X-MS-Office365-Filtering-Correlation-Id: e03baad5-7d9e-4ad2-af68-08df1ee59ef6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|82310400026|36860700016|18002099003|22082099003|56012099006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	SlnBLW5A+JibGRYDn+N9xXlAJnQNAMwDIpe0t+ehP8/06wojxr9bDJA52DvV3+AExNS/L5f1XjP+4SeEBwThc5GF4BzC9OhkvD0rwUzNgi50qVjn6cs9djY9bCzeUEXEyTpR0oIrOhHD3+0iyp7NG6mcV+xkFcIXzkTN3yOw1ium4wDWyAB020XFgFs/DfUsT+syd01AEcNA33rcqMzxPEhtT/tHFSFK1vwf5BKdShi9t88g0fMAltAqhbaHx+FLZ7KtGcOvNV69XoMLD3YrsWKAOV8GgLDfn51aHSIfEhSBiRN/ajbm+1V5YDnYvYytOtioMYckpAWdLRojTJ+ftJD54s2ZiA/CjDtO0c1lOS46MQajYl4WqmveRq7t6x2gMtfi5B5E4JRACGtCbkUapX91tVKuwK8gBFDvZBz0jqTkn6lXKbDMZhVGKelu05qMYWXPtnuDmiq+0asw9QIqj+tMAot6dND7E4eoatBIBs6IItdY+kfMF/jfvNs56Qx+2z8X6c2m3nku7imMh9jnrGngMwfOYcRn9l6UOYCQ7jIB9Gte/Xc+rCgOsz1+CO74topOFKG7WDZ5B0Z3IZKmBd5JSk/i6Uu7vLaJsgsPXKQyF3Ax13dcJh7xkUAjpdiR1WipxhJHEZI5gD7p7KcIlW/+hfNcTdZ1E54G9C3bRa7gFpKzZcKQ+UW4FVnK7SkHwlLKNFQGd15Yx51gbkGW0A==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(82310400026)(36860700016)(18002099003)(22082099003)(56012099006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wleu/51ThBxM0VkO+cl0XOdF7kkqPw7sl/zwcSJ5QaCmcnIS6ECb/0TUdqie5nKqgKiv+gF985FGLeetSGm1pn+oiO3pvCDyX4+pTjUvWlekSHgip6XfBp0qIYgoon3QV2zFIE28B0MyNgPtaxCoCKBBBDAZQp7Ef9agUxoPUwLLttkI0RIXN8BA2K5jiLbH4Zu0JCgh1+jTHGvDRCEv6za/P5vrMFpgcwJpkV2/cKo92/wO/IK8jezKH0fI81uemPpvpNWv8eNLv7l520ZGwzE4H15x8xm+I6hkVPx6EFA4pGjEjgbOfgMw0PeR2sJqtoWitts7p/EwNb1iHsalQ0oqQEauspIdQuUjl9gfmwqdlelCp3ncsHEmAgiujxdea+wLhjELDidFD1/hSDqdaKz7w9Uso36N8cPCkmCswL5d1m7NObDl247h7/0cjkVL
X-Exchange-RoutingPolicyChecked:
	thlTUoDRlHTP9NXKmQ1jA2oXBSO6Jb/EhPLGiz5wHW+GTSYll31oPCz+4jXlsy/+C/avN+nzhS9Q90CCjDp2jFeqtLdnd4Ku5qlUiDn9UUFN1gMgrB/MJRdg9CrSTumPp5oPWA2vXcItkWI1wqnX4qypVY4AikUxDAoi9YNmaxy6WEgn0qGSf9QYSokRyZ4Fh/pn1nyVOUVcXWZy7qJg+9TySgGxO8Dc1/a2pd/Z7U5mFHrkJnK2a3zP0D/BIg2E25jcf6t2TKKo+ORPefoUMdS9cxcEHc6l2M0ARQ0MbXmGxyV67vuAyB0RCLtS7SaVPifKyZmevVABkpd2gnHMCA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:07.1529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e03baad5-7d9e-4ad2-af68-08df1ee59ef6
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0002696B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4383
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX8qLd5F3vU27c
 PM7ez6AQmtlrA2I32+eVkZ1QxzzF8INhwJykRK2SqEQuvGtSdPx+KXHqah+fd7JAinI9C7PJQxt
 UxJZ1cjhWqkZG2+9Dhj1lAraAUlnyaI=
X-Proofpoint-ORIG-GUID: qGcb2qmCAV8IieCV8BS13AIWgz4dhXnF
X-Authority-Analysis: v=2.4 cv=C7R8WgP+ c=1 sm=1 tr=0 ts=6abcf1d2 cx=c_pps
 a=OPuTCcLOD/60NKbq+Taa8g==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=HiAi_RwYt-Wiez6k4EgA:9
X-Proofpoint-GUID: qGcb2qmCAV8IieCV8BS13AIWgz4dhXnF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX10UDVxmaFIpc
 WNITVpeWe9/FXVi+d8BX5osBDrVGoyKLXc63p4iW57ucuLFCmhSYHEekNrduJUS4bO/xf07hHZK
 7Mv5e5y5GnWCGL+RgwZptEsES5h+aP/9VRs56+gh3qvyih5AmBvG3UpIo72768C9ij0WkQwUFZE
 nJAAGc8YCp/0bMaZ9x5Y/tjXUeWCqIo0sKJGEB31HYMwfdQGsA/saK4bX1j8nHofzkt/YLC+kP3
 0uSi1vvXCwp7DgI6XB7Z2oOngbohg6WkHR4e7cOlBEMlVSIrmpfc6++OaxXmTcNkYIYUCpFHeyn
 b4WmKIpWzCqj6wukQNgCl3vf1Zs4GLSxdWOM/VqDBG/6c65MkwVBBFDRRw8nGYEoT3ZNHzRwFtR
 TsKbBS60+zmaeuRHLnkbrTBtd6z9tjEO6FmYVs4KDU85RQoeGZDHehsSqLMUqoeSrgOJu0HSaXz
 QrSb3bNPW7SA3nM+xhg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

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

