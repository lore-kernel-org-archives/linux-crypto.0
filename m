Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771298;
	b=p0gMpT8wbgnkk8NDV3zJTsNXTueYmS/9M/rHQbpq1NCIsgZoVieGTIRBNnIEste0fSUe
	 Inn2NlCBmh2oIPNDe6oMow/0bjveSbhc8c2Xr2nvvFRZuKiN4fqYQ182bQX/NmP7cQRM9
	 7MNhn97N49qqYKQeJx+ghTb/0otaaP0LJzJ5WnE7smR7wdrHXcVde/P1hqcPuYn3uHEiL
	 eX2LT09/YAWYXJf8Njmg4WN1/T0erNILX84MWK5K3M4iSxF0OG+Eyx8MwYUDUAj0JZ6rZ
	 TGBRDz1em580R2saBHjOk/VUZx58Yiwa3lC1i+IHr14iVpDPoWPDbNiNTExpPpM+Tpw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771298;
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
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=LdYNcAviFattEEABNH0JtAi3UJKf3CE+POwkOeZk8HE=;
	b=Siu2i74ps+TJwhNxm+lCfyyhTMwA5EI1NqRcTephFD3rPDW/QrDGAREK6obZ3dd5uVSD
	 yVzD24a+9jEUSNRi9FBBDWJccDEVLOQErn8dFujRBewxO9C9X0gQS6Z/YWZH8KxAFEWbk
	 /MSLTkcY3+eEFaKYV4NmSQjOWikKQb6mQ7gNrkfLgsN8MRSsysDsQVYAds4puqE/R4l1m
	 CWZwKO3xXph0ISRLxO1AcR+1X8KGRhgQENfMcY9EiDDBW8uCnSHuwfCzyUvyu5KuG+A8p
	 HKvwMpg7l1lTLNFYQ3vq1NB7w0CLD4naGF/zPg8vpxJMXW9QFdC377NCZAm363fFJGQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=lFSBOhAi;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=hnsiEgLY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E57A606A339;
	Wed,  4 Nov 2026 05:48:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E57A606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=lFSBOhAi;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=hnsiEgLY
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A42TLP8601421;
	Tue, 3 Nov 2026 23:48:13 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=LdYNcAviFattEEABNH0JtAi3UJKf3CE+POwkOeZk8
	HE=; b=lFSBOhAiLRYDN8T7i/ku/x8ANIxwy8LGuM1auT/XXyr7noQtGmjCjQ3qm
	5MtcuGmFIch02w80cKSUzYJKET2cF0qgKFGUZ0uJvZ280ZsM2/1xDdCjrH+4b/Kp
	q/zUeE7WGhjWiChubQFGX4dIiNOO06ns0XC8tSHOTotGcZcDAxjR+FJ2YFnwLqup
	wUZr4XAsXa2pN0nrXsHt80Sz+aYCfmzXmt4QZ3qc7juerx8Cvx/YL/5/5LRgjMML
	sWrLZGJPeW3RNwwC/KB7fWNSSsVLIruMduhsAWQNn0cxa2W31a7unYequR54Sn4T
	K0FlPW23f1eYbHVHFjx42tvbyq/dg==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011005.outbound.protection.outlook.com [40.107.208.5])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hquyf0u1a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:48:12 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncbrtNv5YPzjD6V4qXTrPDh/2Bs69z5JjVa9T5KndakbccHXMFvORyEB4HHd8F94yfVT4oGP328sQLXqnwkwEG4whtCc98Dr8zRs5Y1iCMZfxsw5FYeSJdabyUFoJUYJWo8vjU+2wt9Ubl0CpwaYBdC8nPi3N1m7wfZjYvpxVpJRItTuN64Yf6hta+rulVpNTqfJQYggykelitGmDvmbsbQYRmD+uXaOSWbUn1fZEZIcjav9/Dt6/HbvDcE1TNYI8hCQieF+ejSesxdSq++AjFmJ8WYFR2mY7PlqxbUsifDnxfixlsOOEWFcXsUqZLtu1olnFt+lEOBWlEM/34//PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LdYNcAviFattEEABNH0JtAi3UJKf3CE+POwkOeZk8HE=;
 b=OM/WrZgsOrmr8ZFYbiIcl1HJjGUSrXq6QooXRU+qGnoqSqWkY8Lq7oN8AgKWFmZlY+DfxRNpthS8wvg4aQg5Xkl6HJraUkp9Kdk00JbJEz+SuvsBOkN5woJGThMdv8g8WypwwDpHgeYLRmTuMcup0lZwRVUNHqbtEml/GGp/Xi3SvWpE7i+7lMY8QvqEQv8HN/TLPOax9mmlSrV+PNR6XsD7sJs8NMUpP6rSJA/NSY76LxbxhfAPviQl+JY7z7Y1RxArpsi4RLD6Go57jpjmRsVf9ojJsq5cSyDpHrjadmSZ+p8xOv/htSnGxvNt8uj5t7vMCgK3EM+4d+yjvJT+ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LdYNcAviFattEEABNH0JtAi3UJKf3CE+POwkOeZk8HE=;
 b=hnsiEgLY0L+rKWssgImUXR7Jqv+RCGumsw+EpIPjzAgaZZwbO/E19nr5QKQpQonD5Xs8Mig4urI1+GeUEIVIBNcQjWMOUoPcsJNO+eaE2I1VSMyADj03oRK1CyIo+pj5MNw3oQdxtTqZeqS51+oiLr0+SM3YLvbgAdGI0I5aQYc=
Received: from MW4PR04CA0303.namprd04.prod.outlook.com (2603:10b6:303:82::8)
 by LV8PR10MB7776.namprd10.prod.outlook.com (2603:10b6:408:1e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 05:46:14 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:303:82:cafe::6b) by MW4PR04CA0303.outlook.office365.com
 (2603:10b6:303:82::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Wed, 4
 Nov 2026 05:46:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:14 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:54 -0600
Received: from DLEE215.ent.ti.com (157.170.170.118) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:54 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:54 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ09521920;
	Tue, 3 Nov 2026 23:45:50 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:35 +0530
Subject: [PATCH v2 25/30] crypto: sa2ul - correct scatterlist DMA ownership
 transitions
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-25-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=1955;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=h1x7MostX3tS+dfXD3o4i821laQTCg3tltWv1mZ6a+I=;
 b=YFHHfhn5pcpnaEqiVbPOAY3290jlhmC3a2VCeAJlRH1+OOjS09h+fP1XS+nocAq24OxXDYLno
 gztthL9FTcAB4p8bP587jWHy9z0pv0Hd09WEKh+J9xe3EuxJ4mNzV2B
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|LV8PR10MB7776:EE_
X-MS-Office365-Filtering-Correlation-Id: 66b85de3-c020-4fa7-f71d-08df3a36f031
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|261022105027099003|261021121427099003|56012099006|261021123027099003|261009223027099003|261026140227099003|261102123227099003|261028144727099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	v/exAaY9pwJLf76ZxTHq6vKtNIn4MMuJ8LI9tjTGAuzuX9kuYrvtlA7be0IroSkSNZDk0sjHAMmqhr0M3Ug5W3wB7xInrk1sAnwQewfPIpBoQ6Jne17u3TFQnSY00lWD0XsGekzbTgc1AgLLljmQ8WckLZGDRutLdz5RDUh9QbbdYcOpZd1Ft2plA4+oob2yLTmUhKhLRCDnIvMqNLM+gzHfWvHcF8teMbjiOlX2VUGBc5l4T5IxnmnzhvdrI1TRo3xu3am/gHqa9lkGMlEip45KFbEcjECtuhu17vGSt4ukBFoahRFsczW0rVFQLwqLuuw98PHXy1rLDGeaqrWjWIuadqTOOQVycm56EMrgzdEkTuxTgKRCRIsgiOFo9Kz3zmLpmXLaL6K4vuAHkc6KJIuEQKSkJVE69VmDjbzownFwm1s4lYBxtk2xyC+hlP3UIADUDsNUD6vrrD6wzX+ha1PHhwvGpIc0Pfoo1csX8casL0DcBY33eq9DFfHpZoBthw6OEpTEkpXMwUdjK9K8BP6FVtZxw63yfqTI2zhHZyG1SAhl9Qt5KzPDSomoXF2UWopZRZHoPyY7Vmz+0D/AuckPgl6dTwxudpsoQb+QMk5xmp1cAoUhWxr5bhmj3ansmdXNYHWw+Hx3b2ho6v5t0OvH3mk4IdUTP+tZXdu3wqg5m4P/enk+UDhYALc7ZTvSLKpfoYeeaNsjKdA6Ah1WQg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(261022105027099003)(261021121427099003)(56012099006)(261021123027099003)(261009223027099003)(261026140227099003)(261102123227099003)(261028144727099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OABobvVzPQEMBPLQ7j12g17ukt8Fjc9iHK1rxzIaHazcpCVzEq93W+tqhWHUY1kx+JtEoH1ZV+2BE19tZQtKb+CFOdFdRpGmzGnXzbWQaFI+febTeUhVPGUSO3qY0TrwlPRDYln3UlAl+i/vOKlsrjB3T1Rp1UV6lgqvC0vbSwtSJAMGDol+40b90rZ1I/qugPixrfURnct7KhGzlYSE1zKWjGdNnEsBv79B/l24yXjzXIWHTa+8hzGgnHAnv3D7EM90G+O1IjftqXgZ4yIqnHkIbewCpj8lb8KbnvbWRWHwKj0+8FvN6Ss4yR0PnfjOIj4oOYE+eT67atODXdtQ+TqoKDb8ZBKuKVh1/y748pQeoXzP96vn53Xwmxsv9bkm2XIR2DpKoKauf3y9jmPhjYmo4Z0gMMJdbCCr1Biqs3KveRQ2YE4PoZ1jhWNmy12W
X-Exchange-RoutingPolicyChecked:
	Rs2W+LY/oROFMgV/XfCX8/B5fAo9Y7Lc2Y7SIFGbUX39pEkbMWeDPnrbATxIsWHeaeY+Zv2N949yXXR8M0bAbgvdsH5NE/W9y4bEsi3K4mEYfhW3JY0JsfeoFJhB/dMDFQRNBiCcmNWGn++Xh3PdvvNflORb3IpWHXer+z2zoH95ZJASPyn9V2B/kMZ9lOUYsJJGXKzuze0PZkQZCp6VySgAEjth34/3SBooVYusr8mjpm8OoEWFt/4dn/LWliYPiIFv6COBROEsfS80nJuV4UOIXDcY1Q9NxlyyBLnB8m1NAiw//XW7OoMKNcZIxuBULbmpWdga9GCUeKs7l2p+qQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:14.1049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b85de3-c020-4fa7-f71d-08df3a36f031
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7776
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXwZcRfqeW/+HD
 zrfUSOhWZ80ae9KjTrPSwH4xoWq8gx5XDq6SBTYnfd6qm9XTCwRucopONhjuJhCN8kmr6LgBFjI
 SrX549QjpBZzJfDSCmYYsa8LaB6r40/hfKmPrpcCzFeMuq7OI3BUe4NSpYt2J1uFejZTtzW8fTZ
 vFTT2cfG7D636g7BCOhgOO0M9O3UPBedBkh56Npv1RBOsq/p0DWmROs43keESOUSvUnHKZsxccX
 /bF8gp5qvPW/1V2katsSbL4lxK0o/AJhQJXGUi6JQIQ3M3+UjGGj9rFLi+5Gg3SouJ2OzmgRQwE
 VJy4mSNFyboJ7NsFrPHKhsfFANZFb56MBNGdtENveZ7YZkHGiVJP6bXwoxK0TV45znPyEHYj2u3
 F810qpwKYcJeyK3cWN04IGzQZ4w45C9lOCbNdQlWg0Ipo2h/yIkn/bw+JmpO1Y4ZuY8twP4eNso
 ZZjHDE451xRUFHRDApw==
X-Proofpoint-GUID: 7PyFIcGOqS3ydlpFLv8re5zlVgk1S7sn
X-Proofpoint-ORIG-GUID: 7PyFIcGOqS3ydlpFLv8re5zlVgk1S7sn
X-Authority-Analysis: v=2.4 cv=MpzHeGae c=1 sm=1 tr=0 ts=6aeac71d cx=c_pps
 a=yinnKzpnBJ+MbdtTFrOrGg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8
 a=cG5UY5NkamPOuPjzYtEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX6AMSvdueseeh
 RLJo9vLUvQJ63WwK/qVHjW+0jG4DybF2/i0NcLbOOfE8iecdSm9MD0UCHDBu2+JCIHBP2vJN385
 A7hm257jI24lrRxg7xiPxx3josU9CQ8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

Use each scatterlist's recorded mapping direction for CPU/device
ownership transitions, including bidirectional in-place buffers.

Completion callbacks modify results after synchronizing them for CPU
access. Skip the implicit synchronization on unmap so cache maintenance
or bounce-buffer copyback cannot overwrite those CPU modifications.

Fixes: 00c9211f60db ("crypto: sa2ul - Fix DMA mapping API usage")
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index e34c52de5ec4..d4c0e5b836ac 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -925,13 +925,17 @@ static int sa_3des_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key,
 static void sa_sync_from_device(struct sa_rx_data *rxd)
 {
 	struct sg_table *sgt;
+	u32 dir;
 
-	if (rxd->mapped_sg[0].dir == DMA_BIDIRECTIONAL)
+	if (rxd->mapped_sg[0].dir == DMA_BIDIRECTIONAL) {
 		sgt = &rxd->mapped_sg[0].sgt;
-	else
+		dir = rxd->mapped_sg[0].dir;
+	} else {
 		sgt = &rxd->mapped_sg[1].sgt;
+		dir = rxd->mapped_sg[1].dir;
+	}
 
-	dma_sync_sgtable_for_cpu(rxd->ddev, sgt, DMA_FROM_DEVICE);
+	dma_sync_sgtable_for_cpu(rxd->ddev, sgt, dir);
 }
 
 static void sa_free_sa_rx_data(struct sa_rx_data *rxd)
@@ -943,7 +947,7 @@ static void sa_free_sa_rx_data(struct sa_rx_data *rxd)
 
 		if (mapped_sg->mapped) {
 			dma_unmap_sgtable(rxd->ddev, &mapped_sg->sgt,
-					  mapped_sg->dir, 0);
+					  mapped_sg->dir, DMA_ATTR_SKIP_CPU_SYNC);
 			kfree(mapped_sg->split_sg);
 		}
 	}
@@ -1110,7 +1114,7 @@ static int sa_run(struct sa_req *req)
 		mapped_sg->split_sg = src;
 	}
 
-	dma_sync_sgtable_for_device(ddev, &mapped_sg->sgt, DMA_TO_DEVICE);
+	dma_sync_sgtable_for_device(ddev, &mapped_sg->sgt, dir_src);
 
 	if (!diff_dst) {
 		dst_nents = src_nents;

-- 
2.43.0

