Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471194;
	b=F2oZl9BTMThthA2uCfwtywkQOYyApvqqnKCL9QGSAiVKFqrfEktiRdXv/87CJvDbB45y
	 W/inYF9G+2rUQujcWqmqCXcncbEY/Rm2pjReb0URIUOdyeP402o8kLTfBSKE4Lf9TTSdH
	 Yw67QMI+OuwEeN0oRKAW1Fn/uxbL0VFI6eQm0U26y6qn1VJm9XRNzYQob9EXO7ZCGoL4O
	 qXvGcZ5ZP7hUSKkI0b4PpX2O6Vu4CY+GyFC5geu9m4wSZGdFNCL3NffvjSiPG5oGZ0tLo
	 /e5aKiP8wBDvpplDSYCNkH+Tfn22cOegNdOdM+68w1C5D9bG4WXO1aBKKj3tbSuHnuA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471194;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:To:CC:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=n9IAh6Ha3M5DllqXZRkXT45vI4T5UBS/I3stI4IGUnA=;
	b=gCEkmwGMjuz7DzqZ4gTNo7P5cbb+vehyXKrNyPkj2HmnLAVNUTrtkgMCuE+8wyX2YEXr
	 e+X/uAlVjqFZDbFyb3sPdzf1QBU/5jas6j51GZgwmEC0daOz9tALqF6WeOkBgoGSqyDrQ
	 oAUB3OfU35PTa8V6oyIVX/tZCLxEwmU0SC/UWzb2MqrgW/SolAc6yYJhlXISeWeXtse6n
	 /q24+MY/Pd/KGGO6Isaxt4taMdI1eoeAyXsgBLynFQX8sB5rUHArgF3/Vh5r2cPMitld9
	 VxA8trG5P9zcUIkgV74831xWXudt+N66WGmhamIuxzyDfcIGYN4DdTy/S+A7I6EGDpw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=KwAApMRc;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=bopu6dxK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF72B60A5BE0;
	Thu, 12 Nov 2026 08:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF72B60A5BE0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=KwAApMRc;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=bopu6dxK
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AC5iqIU2297462;
	Thu, 12 Nov 2026 02:13:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=n9IAh6Ha3M5DllqXZRkXT45vI4T5UBS/I3stI4IGU
	nA=; b=KwAApMRcBSHWwNQM1Cm1kQiT0yQ1wZeMB0tQYciWGEuCyg/JGSyb8yhy0
	nW7R+lD1UNrjv+zGO+Y9QsfPJpT5102qZGnnnBIEpuI3D9CRAs2vFF+HVQlVMWEw
	dzBUzHAW5U6JKLWEff5rF8aIJRhPWlTLdT8D2L1ofk3z61vpwJlc+3uhWatw6cAI
	mM9cKtjGYMXtdE35rsEQF4I1pAcyOOneORjD40AXdXUuwZB8MBgO9udV7AgBI77a
	JJ/pXDZuDsvpsMO2QTMfZzsHOQ4W8jl7q7kF5UWIeSLgEceqQ1T+l1OrgqGWYJAM
	cG04+lB5k9tDmeUQFCr8DmJgicolQ==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011039.outbound.protection.outlook.com [52.101.52.39])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hw7k48w3c-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:08 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eFzMUfjzi15cdDJQZXZPXSxj5/D/1jTNsOPxmDIMKsq54kXcB0LhivUrqmX50XowougCxuAriSwpAbhNu1/zZ3mzYT7oo1TG3+EsKKWLYui+W/a0AjgXvb9koaChzn7TqaXYkcy3Gf0hdM8Yi2rebsADAwawQaAdkeaiCQcsbSX1E0fCkUnRpifElzYWSTI78n3kZo4dwG/t8TANVywUExKzqPTj4MUD/loMLX4vRDQsn/ZdOutJ0uBlp6d46+FrnpQiGEEiYNmQ825jdQHbFV8hcY6g4Sw2PfUPUthByDUAf7nNwZtbJ8sbGJZS6valBytH+9sA3YR+5fp4A9b3FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9IAh6Ha3M5DllqXZRkXT45vI4T5UBS/I3stI4IGUnA=;
 b=n5ddWiEcY7Q/mFhGtFLfK0acbZbjh6XqqGOX45aULTC+y+dIw9YNXzVz502781Wcrf8SsAp8MCgvbF7UjqOSSAhTa1W532aff6LQR6BdrupCICR9oDAUWx4OiOTt9mDO+MXH+Ycz0RLTVwjjUsq/5V5L/koz4ibwHlrN5PHDnXQMRPB/Lo9U1IMFxEp0iyZnxfh2GKZHKVfqLJTxJKPdjwRjgSp4j315oiH+Gnn2JufUhrJNc9HC1Xjb+CfWZWNzrYR0P+EXs2g1hiwBK3CO0ZUuRaMqKpuvQRYZtmGNFF8meqvFcxvh1Fe1HNXiyAk0HDKMJA6VqLv0DmWQ6NnLVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9IAh6Ha3M5DllqXZRkXT45vI4T5UBS/I3stI4IGUnA=;
 b=bopu6dxKwpCQLch6z34VXInL9vdhInUUmZldq5MYxz7+HxnOwBuFGPpDBToQctrHphVDHKHcvvrFOben9ubYB6c59dtDQE8zWzm7Llesp8Q+p26oXybZ6+hOpKI62qfb6ErlhH+CMnFFrs6sIx+j37+Rr2W8Mzg6iB4vOd+ZWvw=
Received: from CH5PR04CA0024.namprd04.prod.outlook.com (2603:10b6:610:1f4::9)
 by MW4PR10MB5749.namprd10.prod.outlook.com (2603:10b6:303:184::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 08:12:59 +0000
Received: from CH2PEPF000166C5.namprd04.prod.outlook.com
 (2603:10b6:610:1f4:cafe::ae) by CH5PR04CA0024.outlook.office365.com
 (2603:10b6:610:1f4::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:12:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH2PEPF000166C5.mail.protection.outlook.com (10.167.244.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:12:57 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:22 -0600
Received: from DFLE212.ent.ti.com (10.64.6.70) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:22 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:22 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CKRq1455629;
	Thu, 12 Nov 2026 02:12:21 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 01/15] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Thu, 12 Nov 2026 13:41:49 +0530
Message-ID: <20261112081204.1146395-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261112081204.1146395-1-t-pratham@ti.com>
References: <20261112081204.1146395-1-t-pratham@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C5:EE_|MW4PR10MB5749:EE_
X-MS-Office365-Filtering-Correlation-Id: 962ba860-7287-406b-52a4-08df4094c2c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|23010399003|1800799024|56012099006|18002099003|22082099003|261021123027099003|10067099003|261009223027099003|261021121427099003|261026140227099003|261022105027099003|261028144727099003|261102123227099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	QdnsKSkjUw2d1II+y1ASkxj/5NGJj8162v/ONjw1j4KTMug5nOPUh5YhcuHwA7Su8M+gOCTBWFo2UIU2EasJxPXOkWH7v4ol+alJGgLzxyUUZX62O+9JOdhY7TmV7jQfoXQ88ii+WPryUOMrW+sbH7reKU9NV/do6t+dnAwOddXVcJtmif8eruTz69Yodxc8B27MbmX2L7me+DG5QCH4jWlMmjmHMqg3swrfQzPCdvIuFK0QdiZFA9JwlGuU9nqQ/r1qbcszlMTKPPzf/em4lcO+dEUez/UyP87+8NGLxTCmQGpMuMQsvGKmVEpfFDG45dLbfF1bgLzU47vptU1RqTY9YzmjC+cHnGzn7oiuK6pFS12RY10NTOoGNqzpRjXIVB21sw6GNRgLTp32a6SUB6UPVQi30vx0aPGuZB0CTyKcDN2uDvjBe7pRIwVVuPVPVQun5+TfmekG1vr0pbQ1yheJgeAKPKWA0ZrdqZ8uGDdxqGfdyxOq9ovAUSU2b71aJKnuDZdHsS/ij56o7PJS6s7Cq/2mb9wD0wTKWku1V1SjhkMt/yczr0iCDCKyK9c6OVIUfMBqr4zysRODexoFxyG1F4Ftm6vGUvcChipQ6shISPdDcxHc/mp9mKUQhgZLKXg5+JXhCTaRjrFPu8oL9eNzTB7CFokB4hpffqHfp34=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(23010399003)(1800799024)(56012099006)(18002099003)(22082099003)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261026140227099003)(261022105027099003)(261028144727099003)(261102123227099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YEG1Qrz/4eMjZPSFbQB/+NHqfCyH1W9Cqmw+EFICJMn/2vtmUyXRGPzMEgSBLdo8v2B3Z+YV/349AOE6i5Tx5BxEZ4WrBxmdw6TS1cJNwdGUIAl5XuJW8zvkgvAerEpQkfC1chzLHPDMAo0WJhZAIb0QbEkS7aXnmGmfrpTXHKckWt/VpQ/D0KeRPHnWxt/k7uUP25CxN3C8T20VpRt34EkdLwh6QVf6y2BufPNH+aB0q35hwLymXGHRp5bweDnh2EawJoinJJ3lP3Igrvpbvpy5NfZQ3dJ6jzE8TbisfoDYsAdyIUx31YyCgaMF/RtpRmqOCrLOjb72Htk6dTFJN/7sUFzbOmxwwESvXJ6Al7Y9lDuknGjHx6hY0/zzeC5/cQdrrN+zi81c5Kpq8B8iZziwMrr0Jh0RxlKfFUz6fYrZJqMJ6moEiSzb+GsqpwU3
X-Exchange-RoutingPolicyChecked:
	LhUIwgnnKM3qGTQWGCR64+4BFJi0BJf6Xvr+aG0ppq29fIHHhcy3e1TEEjLCoxg1SgOBhiag5qSO803Zu8XJXaV+vqmjgCjJvgSgNRFo2bqRfBiDbt7gEKfgIueFNfLucWXZYWjUmawM0k7N5PjxuAu6F3w+hK/Uji36mH+jC3wKT7tmnDz4hH1ijZqAgFMqVGEvEUstooT6vn3qG1UHKETQHimx4Fj84H54uAZsUeRX2y7eOB5EJBPpf/sS86kGYimzNPUhzBqD5qTQCFw2THYA1G/pH7c06oRZ2vg7h9gb8uKzdzS8/LBKElVciif2ZaL3yvmQmEPA3qyL+PO1Dw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:12:57.6035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 962ba860-7287-406b-52a4-08df4094c2c6
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5749
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX4T4krF3HevjY
 hVkcsM7GAnuEsLKFCzy0sa5tSpCX8Rx5OV6cgx5mt6OVOoi6DajHyknavIzlSObOsnNT7XIFl0O
 st7RebTQayZBaKm98HN7UZ6fVvlTt7s=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6af57514 cx=c_pps
 a=GQEFHjoEDIuuLG6+yye4Mw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=sozttTNsAAAA:8
 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-GUID: fsWiGeUoF_cCzBa7DHX4fpfUW6YHk_Ln
X-Proofpoint-ORIG-GUID: fsWiGeUoF_cCzBa7DHX4fpfUW6YHk_Ln
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX/D1nWd+UAPYi
 A+MxsTKJMnb3FYQts2OTKTGh9yuEiuxAQxYBjm7ufHPcwB4O/8DNnRGF8UrLYy5oUVRRrldPwWq
 +pFABQW6yu6kq5k5gi8Gp2gI8z7O16bov11zrTtWimUR5wUC3TSdWhGgmSHleRB8pVVMREGI1nk
 N/pgOqaxQnFuQLNgDsWq3beESh6Cuw1w9zro+nZ9k9GBzHbLe/8vYR2H6zE/wEbQHiU/NF5nxkC
 uMX88X6qkYl4AyNqTlAJR4ybQQZ16EV0hbDJtjdF709hRIk+OztTa+x3AU/wZ7V3kWJNRP3P8iK
 XN5np2qy8POeIOqI4JAw7ZbvqvupjTyWaqB0qOL/HJL5alP0zSvLRvk1LcbEUubvfDKANBYALq2
 qFo1ubuBiJRb1so6FygrGwgtumoxsxY+qi1qdWstBB8LS9fNnYapEqH1NZAv/Fw/bywwkXFqLNY
 hfsSAUMdqCta/M1BDZQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

From: Mert Seftali <mertsftl@gmail.com>

dthe_get_dev() fetches a device from the global device list with
list_first_entry() and then checks the result for NULL. However,
list_first_entry() never returns NULL: on an empty list it returns a
bogus pointer computed from the list head. The NULL check is therefore
dead code, and an empty list would be treated as a valid entry and
moved around as if it were a real device.

Use list_first_entry_or_null() so the existing NULL check works as
intended and an empty list is handled gracefully.

[pratham:]
Add null checks on dev_data in callers of dthe_get_dev().

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202606111933.69GGTKxr-lkp@intel.com/
Signed-off-by: Mert Seftali <mertsftl@gmail.com>
Co-developed-by: T Pratham <t-pratham@ti.com>
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 12 ++++++++++--
 drivers/crypto/ti/dthev2-common.c |  2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index a3c069ca2baf2..dfb26be6d20ac 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -112,6 +112,9 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -124,6 +127,9 @@ static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -571,10 +577,12 @@ static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	ctx->dev_data = dev_data;
+	if (!dev_data)
+		return -ENODEV;
 
-	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
+	ctx->dev_data = dev_data;
 
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index ba6cde75d3611..cb4b8b38a5ec8 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,7 +39,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
-- 
2.34.1

