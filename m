Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067637;
	b=y4zy0gl1YLnjZnR8szEs9TfWbzbBHgiwlDbFkaJ9TpjUpWB1K6S3RPOrZIpQFBpHiAmb
	 iyVVFjBgKfaQ8phyiZPOjiq+Hat3TIQ6iUhoKQLLomYIIpCBp6MduPDrsPNwWwCEWZnKY
	 qasU3RKTqLsGStr21uMA9euW/j294yAZqmeWb0zb5CupiW7f1bFZqtekOQXpREB2ao4hE
	 l9SUZfdKHOCZsGGLVlbnBRly21iXAHh8iHVH8fUNw+CaDbuOEaFRMYmg9PjqZ08c+vcrp
	 xKiSfC9LrgjQufzWb/mZygIOQAVKv5A8MD/fG/rF+ndXbkWW+BO8NhC9lfgCaO8n/2w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067637;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:To:CC:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Uks+Vk8+OjkOV2tG/ABQF2NkGdym98KSUq0RS4+vUSk=;
	b=k4f/jDpF1z89wscPQhG7lzRWl783dKYpCkoatU3jAtr/KnJkt5aEASbsD05vPBLXewC4
	 KqxNQmerRn1vWs9Id+rDxcbAAmgFtOzT+la2WT3evzQP0S11atjKa48AinBtKSIbkezGL
	 QVRYEg6gfAxZ88REhkdMiYoyHtxH8woqJZ+wJQh8lYdLF0qTKlgecwGs4yrOVeEnOtsft
	 SZqsR+NfPVak9seOAVH1V20btFqjz1I3RVtorSjZyRG+zjwrYM6Snea+Q2kDD7zsaaguS
	 YLXRv2fBlUlDCe9+FysPUzp9a7LU4uemo9rhYtunjfnK35idcYTSRBBSzQ4/Lr7bydQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b="A/ZE/9dw";
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Dvh5Tt4W;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42330606A339;
	Sat,  7 Nov 2026 16:07:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42330606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=A/ZE/9dw;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Dvh5Tt4W
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7Exts52334848;
	Sat, 7 Nov 2026 10:07:14 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=Uks+Vk8+OjkOV
	2tG/ABQF2NkGdym98KSUq0RS4+vUSk=; b=A/ZE/9dwUOv0fbwMTGL6L1drRvEO+
	cW8WJ+6VoO03q+1KnBBwHjRlAwmRGWqHj279DUyrTWFBLVh3AkHxQTHPsvEIp6uQ
	HuVrj5QPIukbNiHeBm4hDv6cEYtP82+MCv9Db3Kp6NnYlCNfNC2adDYxbCVc/Vn4
	i1ua1Drib++XB346pUfoyiaxjr/NaCMQVQqYYGIPMpNM24+lpvdhxyCK6QtMaKOt
	QCNj1QquZNWxb8xSlKQbSiakU925BMXZSokkziinhrx/fQVkYKYPbslBz7/qXVRq
	VeWKRvvxOOFmQCJRiTfJQiZLMOwaXqvtIOM82ox2eG0Tekfa8JvtITzkA==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011006.outbound.protection.outlook.com [52.101.57.6])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyydub-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:14 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gCXAVhY5W7nX1+A9V51W3f1mD3a6hfa8VZZurxxzgMKQo3/oQJx4tuyXZADGmXqKuGE/Fw8EdBw6yQGcN67OMAxNwGaLqMGs1O640E+N5JGFmir2s3Cq2DJFI9m/pvC57JVEihudhqW6AXNggzig+KdkENCYoPasBiYOMxJCpen9pR4jhUmmLcuzayYBQufU9JYaxK5BbsqOfy7xXvCrsSj+drYczt6WMl7TatumTtmXolAngb88Wlms3NKZeNC1pM49UHQ8Df1ip9XI/DjncAyUnORri6lFMl21YQCuu2/86why2IgS6QkqU8OBWkJKXpL0KVLS4yYjV0iJqGw60w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uks+Vk8+OjkOV2tG/ABQF2NkGdym98KSUq0RS4+vUSk=;
 b=qdSKtJM78m8It0KrxICm+ZMhfcEU4dE51goN9oLBnwZUG7FSHHogUCd6UOFQFRiV7aFnGFGR5kRpF1S+iBksXkidp6QkiGzYFIQMpd0q6a6Weu48l5iE0qKLwJH7r/zETp/5LocbrHWm+GIL0P6kikxDq/P4gFbX1slFtvemw4D99d16YNrtVugBg1OtLfuUyrRX0vlzRyu8mZ45FlIUa4i6v/IhOn7/esOGxkDeMc5pbZz/HsEFlSBxpSpdZhhII/i7ql8uv4zXEh/fXZPEl1NwsUds2+oxgzXbczXskNnq2WxROgii7k1Lik46Gab41WRGvbma1xQ06jSlPrTGdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uks+Vk8+OjkOV2tG/ABQF2NkGdym98KSUq0RS4+vUSk=;
 b=Dvh5Tt4WFLB0o3z2/as1ZQi6n56POhBSP0//ijAF54BlyvvW559nK0k64OZFFM3njnwvGZBOn2ybuC+Ie5p5T1omhlGhfE+QCQpTAFkoG1M731riNPk+9fyFW5rh5Xaqcbad4LAOYY6cBPotfwCTgu06C3HWCGh+ekkzCP+R71U=
Received: from DS7PR03CA0202.namprd03.prod.outlook.com (2603:10b6:5:3b6::27)
 by DS4PPF9146A834F.namprd10.prod.outlook.com (2603:10b6:f:fc00::d31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Sat, 7 Nov
 2026 16:07:11 +0000
Received: from CY7PEPF000000F1.namprd05.prod.outlook.com
 (2603:10b6:5:3b6:cafe::9d) by DS7PR03CA0202.outlook.office365.com
 (2603:10b6:5:3b6::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CY7PEPF000000F1.mail.protection.outlook.com (10.167.247.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:09 +0000
Received: from DFLE208.ent.ti.com (10.64.6.66) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:06:40 -0600
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:06:40 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:06:40 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G6diD276590;
	Sat, 7 Nov 2026 10:06:39 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, "Vishal Mahaveer" <vishalm@ti.com>
Subject: [PATCH v12 00/15] Fix several issues in DTHEv2 driver
Date: Sat, 7 Nov 2026 21:36:15 +0530
Message-ID: <20261107160631.2592763-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F1:EE_|DS4PPF9146A834F:EE_
X-MS-Office365-Filtering-Correlation-Id: 587019bd-20fa-4fe7-9857-08df3ce92d4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|261021121427099003|56012099006|261021123027099003|261028144727099003|261009223027099003|261022105027099003|261026140227099003|261026121527099003|10067099003|18002099003|261102123227099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	6y5G8h+lIa3l/16KSFFhvszWPn9evzs9YJH5pm6u14nm3yNjucR06TTDqSJI6mlwKtCeDNrNrkrEygv0Bmv1F5iCHGrGrAQVGQhEoV9LFRLslACi4UPEye/keZCIDidqOBUiG4v2o8rDLGzSjo6bLoRF/Cb2f1I6sBTxMM+dsvCbPpDWRcw4JzTZ4vqCT6WC0iQO8VeWZm7A/0xJ2b7kbaOE4lKFLHCXsknxMY5f6o3xZ0TZ4wYG2os68qvQ/HYY5KAuaw6U907dTnBCtqgL7ZKCv+86g2u1V6Q7HhlD5u/1SiGQ239+A2U1mNbVUWkwdOWoIUct6ge430brnYHlJbUy8T/0Qes+bmzT0S0yqhmJKGDMN4sUNRHkBJh1iwGNXftV3KGzCQzwmQFo158fvBxnChMBCIS32t7uuYjmqPqcpLQ26RBQ3lsOHc2U6fDRQQugVoam2o0mhF3Djlzf2lJ1zYpV2rejIuQK70Ex3e6sFPWYfji1C6vlFuqkuFTVnht8srbumCWK/+ZMKgPJ/QO9VAtditThw9XOFbbxn/g0v47uBhkQvZmWR9Exhb9IVp5B4TCprTGG+EykWauxq14knzusbN0+S/e1cgnbwVMoZ50U5r1ZpElcNTjLSJ/IcC9OhgupmqqdYqZDAayo5Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(261021121427099003)(56012099006)(261021123027099003)(261028144727099003)(261009223027099003)(261022105027099003)(261026140227099003)(261026121527099003)(10067099003)(18002099003)(261102123227099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uH5kNcUxDeNXBwiOVCCLfQiyNYccyFJoyazKPHq6llrVDvYsfKTFbUq7FjxWfMqftSA5EvQm89oBcfhcKMs6KUbyen4yZU6HEw+Vl/lFxn6oVWnQZOt6mU7emvBvOEwrx+jYErEOBJGl7cDVMp7q7zqoJ2Ogp5KIMizYns1SKUq07G+usdsI/va7cBI2NqKBmeNMPllylej3k5vNYsj4QeZtFqeg4Y/FLfgfAA5ulWfdIjbCHVqqTuBwBgOkuc+6hZXsfmtP+dTq/KWeS2K1DZyKI30uUvZT8HfEAN3UrWKAddmKoiHpeIq+dVXxSCohwHCduieLXxpfZMI2uXBJXGkLbLUMdiTm0L7UoVE265T4g4nzJN+IArmcHqKtFE0wnQUAksidXG/lapeQd+oVhnE7nNf1ZC4hwZ/R1vHQh011Kmx0fgq3NNUme0MmkzXj
X-Exchange-RoutingPolicyChecked:
	dtsRgxmI8BKYsV/C/gMgPxnjmub1zu/s6yZIpIx6pq4PSSINTiMOX5dQRcKQVeBO1AZ2GjVHrMPm3sAkcsvJ2oOUQFMZN1892hRgTUoUcY6d2Bvm0bLzKhT2Xh08bQp0xcDucK9zQKpEqDOjwl2YXaeiTlqVswbYiUItQ3mrBSnTObETvbKIi1SRLo9uoD4Cu42fBum9ju+9w60yBbysPhmfl3iOM3lfIosPW9lhXXa3fwek/5dnc8LUDN+B1Z1vyexdO84Ss0eIaNe7exTbr37qKrU+q8ooWOUI38oxG04n1lWkROzp+yKsBld/Bid59ggQN+zTE2Z76dNmOea0Fw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:09.4232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 587019bd-20fa-4fe7-9857-08df3ce92d4d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF9146A834F
X-Proofpoint-GUID: jxuME4kNxRPigMQwgec3EttijTlWQjfL
X-Proofpoint-ORIG-GUID: jxuME4kNxRPigMQwgec3EttijTlWQjfL
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX+aAD+GchhFOd
 sb0FVlrNPjkqdZsYgbwKHKpl4hAkC8lkloe0JwgTLBbdZ9+6QOBCDSMautZsk95cKmDDJvuOw/h
 /8U2CXtTlOCJHbEfjo7MLy4+ECGVDao=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef4cb2 cx=c_pps
 a=kL55mFjriFqHcOBXBnqb6g==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=UxwojoEslEplIN4H4qAA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX6qR1Ocko/x2Z
 w2E7MzHO+ZT8W+yYBbq1ey89152hV0Q5n2TX5PkuMb2RwGg8gyufN4dww3tqER21GuAMO78fXb8
 bZ2nfeiTUcKckrStB6eDqTW8lLURVvwsjsK2RDv0cY/VD5x+IXvsvv87N62VQ9cuGGW/DMJm+Ty
 h9M6aRfeKJVRo8LoYkUXp4kFiORHsyJNM7Eo6s/frvexJXwuYkAhRzOaeWmtdCUdh5xyKx82BJd
 YQOL6XRsJXbHRQLf2oj21bV2WU5M4X8hSQ/wI8WjB9rSgX3kumwU6wi2TLNYyRgkCG9JP1WOXq8
 spDpgX58nfnRqGkdpp21EDCKn9iRHtAB3naHPHIhjwqfXFJES/OUcdwj++dOfHSqoAZccJTi4lu
 4piTPo7iROQq1yLJjtfXuYuirmJoldYC1MOG8HLXWSCHIjOd67nSTAV5MlbO9+DBO9WJFwO/s+C
 E9tmZ0f9u3Mn+59OyCw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070063

This series fixes a handful of independent and mostly benign till now
issues in the DTHEv2 driver which were flagged by bots and AI agents.
Except for the fifth patch in this series which was found in an internal
testing.

The Sashiko review on DTHEv2 hashing driver patch series v5 pointed out
some pre-existing issues which needed to be fixed [1].

One of the issues had already been flagged by kernel test bot and a fix
sent on the list by Mert [2].

I included this patch in this series with minor edits. Then the Sashiko
review page for [2] had more comments [3]

Overall this resulted in a bunch of fixes patches which would have
deviated the DTHEv2 hashing driver series had they been included with
it. So I clubbed them together in a new patch series which is this.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
Links:
[1]: https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com
[2]: https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
[3]: https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com

Changelog:
v12:
 - Rebased and resolved merge conflicts. No functional changes.
v11:
 - Changed order of operations in probe.
 - Added comments in AEAD Tag helper functions.
v10:
 - Corrected typo (dev --> ctx->dev)
v9:
 - Changed extensive completion re-init based wait to using kref in
   patch 04/15
v8:
 - Minor fix based on Sashiko comment (corrected spinlock)
v7:
 - Fixes based on Sashiko comments (added locking around
   dthe_put_drvdata)
v6:
 - Fixes based on Sashiko comments (waitqueue -> completion; DMA
   alignment for cache coherency)
v5:
 - Fix spinlock inconsistency patch
v4:
 - Fixes based on Sashiko comments
v3:
 - Fixes based on Sashiko comments
 - Some reordering of patches
v2:
 - Fixes based on Sashiko comments

Link to previous versions:
v11: https://lore.kernel.org/all/20261107145618.2349562-1-t-pratham@ti.com/
v10: https://lore.kernel.org/all/20261016124456.1802080-1-t-pratham@ti.com/
v9: https://lore.kernel.org/all/20261016114806.1749515-1-t-pratham@ti.com/
v8: https://lore.kernel.org/all/20261001085245.2922974-1-t-pratham@ti.com/
v7: https://lore.kernel.org/all/20260930125859.1749849-1-t-pratham@ti.com/
v6: https://lore.kernel.org/all/20260930112533.1593952-1-t-pratham@ti.com/
v5: https://lore.kernel.org/all/20260918102245.2784000-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20260910175619.2122149-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20260910104202.1537226-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20260827132318.613876-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20260827105711.527182-1-t-pratham@ti.com/
---

Mert Seftali (1):
  crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()

T Pratham (14):
  crypto: ti - Fix spinlock inconsistency in DTHEv2
  crypto: ti - Fix potential memory corruption on highmem pages
  crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
  crypto: ti - Trim scatterlists to correct length in AES
  crypto: ti - Align buffers to cacheline for DMA
  crypto: ti - Separate padding buffer for src and dst
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
  crypto: ti - Terminate DMA on all error paths in AES to clear
    descriptors
  crypto: ti - Terminate DMA on all error paths in AEAD to clear
    descriptors
  crypto: ti - Do AEAD software fallback on only ENOMEM
  crypto: ti - Correct AEAD tag operations against dma cache
    invalidation
  crypto: ti - Change lengths in AES to u64 to avoid potential overflows
  crypto: ti - Change lengths in AEAD to u64 to avoid potential
    overflows

 drivers/crypto/ti/dthev2-aes.c    | 378 +++++++++++++++++++-----------
 drivers/crypto/ti/dthev2-common.c |  79 +++++--
 drivers/crypto/ti/dthev2-common.h |  66 +++++-
 3 files changed, 361 insertions(+), 162 deletions(-)

-- 
2.34.1

