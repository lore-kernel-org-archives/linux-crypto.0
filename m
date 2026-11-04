Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771107;
	b=zXWC/ktpDVsc0uk6yrmSK6dZUDzL2JRiOKtzFUXjIRkUrxvOBpkOO4XKCE3sZnijvmJk
	 i3NEAWyp9jzgD1+YuAz3A4V1uiUT1y6Fhv9e9nfrF61Z2QdlL3giEArGWzedUYEYzOstm
	 fCxVfyB8Xlb/8utKujaqVyEzoI9JPcR6JweYxUX+6zdSh8aW5yMNQ27hMc/LXwm7OgO05
	 RZV5DAydpv8Gk3AWq1Yb9wvZzg+LRfDTrrX7d40Rl3c5IbYVsEq2wKKVpRwsLOkDVlMot
	 gD3e/UegDzlUrsgGlxlirR3REhnp1b6Dw8ufQEc7pgiwWTnp0lOv5muZIZPKBOe3Kjg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771107;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID:
	 References:In-Reply-To:To:CC:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Bb32UF9ZVcxzmHBpVv+Icj1sYUMZQmJHxw3NUO65RII=;
	b=HMq0yGunUNq2NRLIBxSppxLmhUwvrOVmZZcSMkpsO2EmKEBBiwZ0tTdvjjygb0Rkdg/q
	 CK6AwlS5DzMn1gf69t1UssIfyN8aGbrXUIp1QylGqSYc/5fY5L3HRUq5xlMkpnKDxoU6v
	 3pGDcx0fL1KenEbLw+f8GRhxQrINmFHYCrRJVrd/lKFY7IXYSxyNAEuUeeh2UGwTPKr30
	 7H0xdqCVEsQurEySOn4BmMp8qWAqo13opu/tUqYihzJsFcPXpTeleOXOPJK6kC882YF0I
	 j/teFIr3L4l3gr+vxrwhj5RLyWKu40MvXi6RuBNAVEe31yvGcELY3gk4mhFbqX0wMfw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=Op2P5nN5;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=nSY21S+K;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821E1606A335;
	Wed,  4 Nov 2026 05:45:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 821E1606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=Op2P5nN5;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=nSY21S+K
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40S4Iq771704;
	Tue, 3 Nov 2026 23:45:03 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=Bb32UF9ZVcxzmHBpVv+Icj1sYUMZQmJHxw3NUO65R
	II=; b=Op2P5nN5na7FS6/0fd3XuQp5yacsa3mZGrnCmU5BLcpSy1mGeNwFAKR6D
	B03H7jMbM746E6rzMgOXwKrdY4TXFKvytZZVLkLG6lXk8UqzXHvFPWOheaxz6+Ey
	pLNWxvii1JdrJdR/6zdxFbyncmKN/Uef5VrYwFvJe9bPNwKHKGWX9qNZoXg5kbIM
	nSfFh2uUmWjj4iWznPLdKGs47/YwgCdYD+PkClqNoUWUpu9PtYfa4NLvkYOhXFtx
	eg+nhMRMzuT3XiRV17NfrTf6tTJ02qBvk30eNTYDW1kTytNbtSsmCKuR2hJLX7U2
	EcryUd7EUtHeZMty3BYunFgodvjzg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012027.outbound.protection.outlook.com [52.101.43.27])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqqra25gt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:45:03 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bl1T/4GGOTLLYklxUjW2eAbL1lzr5JPT5ApC6GQYtTvtUgHlPCqHQV01lH9M72vf76BOuuuMW9ibfMjJoJmndxZLdO8vnomRSwyXI67neoGwvY61sxTARCZFIOlJKeUDJp87q0bPHNUNtq9k1fTjx7u/V8Z4gx93f+ginbbnQ4xTrfqEAO1Egd3V0//F7UEnPEO4Ltf5mQIqchs1bvJX/lFxGIKAjyqxrI9Q4rHrNqAA+bMb5g3HP6ilP1xkjj0YSqpmbX0+juxaaqlJ5fnZR9TzKamti9K3BDl5+pXTUT7WQQ0/knjmbWqwLCZCP5eXWBw1mz2qWv/R8dj34b0uqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bb32UF9ZVcxzmHBpVv+Icj1sYUMZQmJHxw3NUO65RII=;
 b=cKjEHHJ+7I0igCGGABujo6adBbFsULzkdk3Qj9YTiIdQ4t4+MXyNQwL3cJEiazNPJzaBaKSjY1nnGxRg10lkQE2yAtl+tPG+zhvIBjQJlURgJ7Qf23jmvwZJ3IrCs61H+CvCzs4qrh1t1HyDG9wnfRaAhfH1rguv1XvlLZAku1JBM230XqoPhnSZ8g8FRpG0G9oodxccAEq3o06uBDpTAZTM+FDu+EgDfQONa9Ru7AvGzbrSMmY40FIeCaDjejMsXzVblePQE6LxoHiYeCu3sYhjFkBQFMRHFIxqgHYJZM+fzKJFZAjrkSlvoMw6c1HExJ0/7mn12HEl8LwNOw7yZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bb32UF9ZVcxzmHBpVv+Icj1sYUMZQmJHxw3NUO65RII=;
 b=nSY21S+KOUW54NyFofPOWeyNehM5rEuP9B/yngcZ2M019AMRwQzU+pLMASXGecQTK3xLboru9ZbAgo323/7usNtrCN635MDl4+QHzsSmxqZ/xkMUgYa+vd8kBPWN6MnBCiYpcw+dO8I9Qry1s5bymczx3wF81lrFN8KqHcpNziE=
Received: from CH5P223CA0013.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::8)
 by DS0PR10MB997578.namprd10.prod.outlook.com (2603:10b6:8:316::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 05:45:02 +0000
Received: from CH1PEPF0005BD5B.namprd02.prod.outlook.com
 (2603:10b6:610:1f3:cafe::53) by CH5P223CA0013.outlook.office365.com
 (2603:10b6:610:1f3::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:45:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH1PEPF0005BD5B.mail.protection.outlook.com (10.167.244.244) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:45:01 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:01 -0600
Received: from DLEE214.ent.ti.com (157.170.170.117) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:01 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:01 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxs521920;
	Tue, 3 Nov 2026 23:44:58 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:20 +0530
Subject: [PATCH v2 10/30] crypto: sa2ul - fix struct documentation for
 match_data
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-10-15ab90b3f9c2@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
        Colin Ian King
	<colin.i.king@gmail.com>
CC: Andrew Davis <afd@ti.com>, Pratham T <t-pratham@ti.com>,
        "Kamlesh
 Gurudasani" <kamlesh@ti.com>, Udit Kumar <u-kumar1@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Manorit
 Chawdhry" <m-chawdhry@ti.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=780;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=YPA0PSuozodNknkg8Tp68Dx1w8o/leaUU/GpH9GrbYY=;
 b=BMHfXX2BORVgTuGjq2H/MToOrd4jFlXHeQ1Y3AeDhYavj7R+Ws3R+V4X9+WNJ0ayVYKTc6sVt
 vR2JW/X/zMZBJklCevUUZaAaKx70RCiUrb0fynLWMSBxduShiFV0xPn
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD5B:EE_|DS0PR10MB997578:EE_
X-MS-Office365-Filtering-Correlation-Id: 74b928a5-7729-41a1-98c4-08df3a36c52a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|1800799024|23010399003|10067099003|22082099003|18002099003|56012099006|261102123227099003|261021121427099003|261026121527099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	0fbm+QcOWee/22QWBUYvHOfnd55UHrJ0570fJMO2TepH5d7A5WyyRLb4vvbcz8/A7osEhzW0+J1CunfLEOxPEcfRY+gcEPf4NAf0mWEGRoV7GycryM6+R06+/CBbc9WcyF3bBT1463/fiabTK2gkiQiyaVE6iqFSNmFOSXsbp/ZMXP2KbzLrqOKpj5GSnX0XAMzOoDreKFM+RghpP+ydYPesVJU+FVHj/bbDCg7Amqf7TR1BbDqjl3iRuC60mdFYxsrUqTZmy7ohCKiIkyyhJpmcpthkPOXZEA9ca/Nu2s5ehjcOqhcedCuh/687A4vHrQK969bXkTLxzcdiodbb3mnKRLf3GJ1vIGZmLtR0uy/uGIlZ4EYKzrTJ0XE81eyGVWbMNLhaIiiX6wDbulN547Y1G7wBOsJwAlZwRf98FNt8psib2tsX/LA959B9ZMXGw8n+VcXF9zxsjy/RNew9PKMm5Hp4d54deXgOQW3TPkrPgW17QyeZouLujqOBuEYZLYADldT4AFyQRQU7EfjV+8eaJrYEz6x8Dd9+qA80fIvHDQNdzUDoL2cC5spIZKowLQbLz2gKw2LWtOuf532R5pY4yOh5FAydHIIszUh8wB5Zr/t2uK7HGqUWLokysNtd20Nu6SoMFoEolvdwCDNsqxSYlxkvsJr4kRlwdR4BGg0FEaTtR+9caM5H+jBz1QTXcLyMGTgcaSNhfT/piWTkmA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(1800799024)(23010399003)(10067099003)(22082099003)(18002099003)(56012099006)(261102123227099003)(261021121427099003)(261026121527099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OBc3DchYTjacef6a8HvZLfx894Bb6KG9tpfIgrRUrhU73eQwuuj3EprbIMNIv1YwPlhq5k9vwb6FyGDPTNGy/XW6wWfKym2NOKUaePrX2cP8PSOFhU0iApObhNSRhYHzcIRRj8h1huniAb2Vu6sajbbyYAyCYinrAe0L9WA3O4mXQrNuAeiJH7HMbJvPX7ZNjqy5UXvjn4IB6QHVHODSWil8fnZk+n1g9X2gIixuqVaAnJ2DUViHZyNhyfdrfYG+fMMPMir8DABiuDPoF6r1PRGX3DAAy5oiKwsHavdFyrD7QXmkWf5MGHEALvhqVFjtTUxemiq9NzO2Zz01gwAn/9YR0oumlOxc7hXvdXMVkEwRQpLsy0kZZw4ZHWkeDFbw9LVONgjXG9YJH4qD6+XEtjJzMxbaBZXHtxtVGJ82T7dAEdT33aHxYvDlSbwGH91l
X-Exchange-RoutingPolicyChecked:
	H30Lv9ztaNQpTOZtgctE28OfMkGxDxJGGg8DbVNV5i+vNuawFpQbA+mn9DaTwA63Go7Jq17zEx4ObLQiCmg9BRIhEvHNitm/9yT9GIhNPhX8QQfcgaZYWB/lQ3iJmu7IBWVobnS5UF9zgYofRCBfQnLEAjLh41DxhdpaN9sszJPscjS8R/Z2So2tCPunNhQpH7CzDBeaJ97Z/3bttnDZwoInjwdUWVCXQnnxXSaYt1d9152+5skgrAlf40ONFU0S6AwiXwlKp1FON0y+LNLbbMu7aWuhwzyJCAbOjburta49Qw+Y12XfcXNAwN7az7i0H6soYoEjA3BPpDIPwZCV+Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:45:01.9531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74b928a5-7729-41a1-98c4-08df3a36c52a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD5B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB997578
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX8+c6SdcJPxoG
 oLdtfZiyrncrE/sMAPK89lNw2c+hYmSlftWObN5z0zhy+x4JpyfvDaIlR2EOoxH7ON6aUFi9IZP
 /hWXOemc8Mwl790vOO6317Txx5XXils=
X-Authority-Analysis: v=2.4 cv=F9TC5ahN c=1 sm=1 tr=0 ts=6aeac65f cx=c_pps
 a=8g4i1X1tkAMDiabECo8pFg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8
 a=pd6C3ukSS_s5mK9FejMA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX4AtLuyGJqf3Q
 6fW+haZaeQnhA1frHst5VNCLhOO7gcZvCpanZ7+ygBuEgTOHnBUQZzXWmGHF1y3+NzmYwWcOdNu
 Ny9+ippxg89inE25t9gWIddzLz4EnZXVZbQuyNBgriDRzYkOAts4JOWt9R2QiWaQ7l6bIFioHrj
 GpMnGaHzR4Ymo1wF6c6Y0KpFcK1sbFqeLADQpYqLpDvgMW4OQOswgKcEToD2GdC2pTImPaNJACB
 WQC0muW22jRAbhzG3fTZPRgSz+3KweIJ9erVuiW5Z9OZeofijt2yjjBnKmczHD7PXPRNfqYExbX
 GeN2piZxfsdV5/3phjsIvpKr04PUk1Y8jyEHP+MQ6T4I7uxt2y2xTZ4Klvc3XFK7bOUWi5kfGMI
 ESBagQCM9qfHQynESW3QrUXUKcpTH5e4FtXnoqvC5r83kIZURr59TN74Mdk/6+Lhgacpcv30eCc
 eOQ46EfYh/2KMvJnqzA==
X-Proofpoint-ORIG-GUID: YKuSnQZnBdi6aYJD8jG3eFKQdVR6kCA4
X-Proofpoint-GUID: YKuSnQZnBdi6aYJD8jG3eFKQdVR6kCA4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

The device context stores SoC-specific information in match_data, but its
kernel-doc still describes soc_data. Match the documentation to the
existing member name.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index eedfad49793b..a717c5bcf061 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -175,7 +175,7 @@ struct sa_match_data;
 
 /**
  * struct sa_crypto_data - Crypto driver instance data
- * @soc_data: Pointer to SoC specific data
+ * @match_data: Pointer to match data
  * @pdev: Platform device pointer
  * @sc_pool: security context pool
  * @dev: Device pointer

-- 
2.43.0

