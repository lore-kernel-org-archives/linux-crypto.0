Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063447;
	b=GB0suSy7y50iQiWCgzC525hlqglL3gkBrbok7yPjp18dba60NNg12h0k47erKIAj3iSX
	 ezv2mv/c7DQsgKsIBwvXWVAXtzycW0IW4zFtCKegxPNL3wtraGzNr3NPQq3NXAHdgBtjt
	 Od47NkBEEFO+BEQt2WuC9nqKR2avKMEskpc5Ud3KZ215Oog5O2oyMVDVxRhdehbANLEtU
	 MMbKumZNv29gqgN+BRMOyFWZK9+3EW7r0j97n9eycdE/saBqRFy3bOvrfjnSn3c/sshYB
	 gdjGtRTC/w+sk4qkP0fiOc+pmDyd/yE/tYp7kLklE0neEPXBNEdZLpCQVhRu+PRL0AA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063447;
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
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
	b=Ehqw/zNaiLQsAOBFXOiHqwOkFcruih8JjHZIrUD5M0ennQA8Z7eFbW05G4VSgxi6NaJr
	 VA7Yq3VuYOmhjIMApykx7KdWuiVJXoeSd6hEIpHCx1syakeoH0llzUXt9nCc8suNQnk1o
	 8vxxNWlzkgy1B27s9mh2lefStEdp1bJlVcQcaNbl7awqVG3n2jCOsWKLlxUk89KjTmCsJ
	 /ZFjQ7hHu660AbZ/d+mq84pTkvKs+7Y2xkaozY05pVEjKYKPEvO1o27GTjjgyDQAIAl/o
	 PBLTn5YQsJPUJTBfeQbgR0Lzd001TXj3qzx3uucNoRnqBGNRRJwPRuY6+z/AOQhp+lA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=ovIIO1kz;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=pNhMLuE2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02BF606EE8F;
	Sat,  7 Nov 2026 14:57:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A02BF606EE8F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=ovIIO1kz;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=pNhMLuE2
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7Bx8Kb1610421;
	Sat, 7 Nov 2026 08:57:22 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLi
	nQ=; b=ovIIO1kzbizq+nsRtBoZ0dfL48gmxe/kytUT2sVlLslWNmpq/CdbgGUF+
	Zhv1FbaKpxC0xXfz/T+3O+6g5lznWRG5THRsp7iq8JsXfURGKPNRFIEtdNbckhnW
	h/MU5AEqdLlNVrA4LcH4lZOEI0IcucYuHtZ6r9LTQ/Y9aABVu0zjaO5YVPaz+/n+
	tliSFnvr63EhEFOR0UQYuQ5WFSoZyPkIcH+cX8w6dzK94VsQhMwF+6T5BeTXtdid
	MfLO0X3w+pR9MmfKwVZ4M3IJG3Cg3t1ORx/dyCy6xX0WI9qvdIJco8Wt6yKFJLZJ
	ypXcR6qzXhG335nrHy3HE24FVCg8A==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012005.outbound.protection.outlook.com [52.101.43.5])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4ht0wqs08b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:22 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mmNOS40Q368GmcT3cuMuh5V44sZb7toIQSOPeQEE34DXmZ5gIvDmqNI76H+0i0FqdZUgqLS0A/Oo9lmVNww6ZYAXiORcwM6F/8Lvo3ey5p3uOFAHiwrZlwjoYgikv56x3m+s80T+CAyXzCmi2u9GCy/JZVa4Q9Y5yAGeQkx5r+CuBrCz9uzNL8ZT+VnOtaxGiMXVlBXNLtexVe41Jd7uIHyovbFNUgvWx37UAdtLftaZK5+iwh0Dw/dVLMjGGk5BHUvYlFnHfb0MIYD5Mq/wP/Pg2Y/ksJTMb+OwGfmHcU95R68glbXJqgft0QeDxj/iz6y4hpa8kopNvO5zx9ScAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=skADODjyhISpcT/OQKSoM28y/z6TVXOcm65byEJyqFYIE9fG9NEVuvaDhtqgUrHkhZWYFHvA1W3hx+Qf0zMyROXWnnxyoPDwWnS6Yq7oC5N+/gZsHBFW6M5fiFxYq9ed6rwTdj0t8E+T4mbM5fB4KPKuSiQIqQOd+CM3x53YBgLyLb+CwGhq2UY39d6a7E6wVDpsV0dYs3EOg2qZ5Pby41VtPXwsfto/HzEHKpHDxcRkBVL7+8j1fzfwdxBGzTZCoTA2zRIvxRx9Mykrg4k9OQ/GXG3Oh8h4ZfnY7/U+yMHTtGoGKOQA8HeccNjavQ9VsBVOVv3zAf8WtqYLXgotfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=pNhMLuE2hWfN/ILUDq4N0hVOP7aS1igVl+xak0iW0hCEx8LJmSukQ4OF02CtyWxBH5ngaS4r7Qsy7Ljmk1MBq6dRn6/cxce7lPvGPiSarTGxCDtJ4A9nqsl2bwVGh8FVtgHxx1CyATggAqUslmHbhjt4Qe3WNMzHUFpb1WMheK8=
Received: from BN9PR03CA0649.namprd03.prod.outlook.com (2603:10b6:408:13b::24)
 by SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Sat, 7 Nov 2026
 14:57:16 +0000
Received: from BN2PEPF000055DA.namprd21.prod.outlook.com
 (2603:10b6:408:13b:cafe::9c) by BN9PR03CA0649.outlook.office365.com
 (2603:10b6:408:13b::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:57:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF000055DA.mail.protection.outlook.com (10.167.245.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.0 via Frontend Transport; Sat, 7 Nov 2026 14:57:16 +0000
Received: from DLEE201.ent.ti.com (157.170.170.76) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:15 -0600
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:15 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:57:15 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7EvDQO3374144;
	Sat, 7 Nov 2026 08:57:14 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 14/15] crypto: ti - Change lengths in AES to u64 to avoid potential overflows
Date: Sat, 7 Nov 2026 20:26:17 +0530
Message-ID: <20261107145618.2349562-15-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107145618.2349562-1-t-pratham@ti.com>
References: <20261107145618.2349562-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DA:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 566486ae-a8af-4456-2c87-08df3cdf69f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|82310400026|36860700016|56012099006|261021121427099003|261021123027099003|261009223027099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	c1oNdK7Fj/9bR44+hMEGl6Ss5vscejK5J9srTRDhzX3hygj7Igp41+30eFo+iY/t5pYdPDdSyzUo7aKdvBKZBOF/kyAuyGFaNdf5o3wm1QKeD49AIkk6NuBXJfl2fzDh5cYtAJX30N0TmAtdWYzNmMqf7i7J2q/0OP/gjJDD7AQu/WOry3fV0WEesGNPcLJzbNcxXWLHH4ypwxec0xcO3TcSHGNdimkuzdWS69r+BzcP5tLQC4XuorKNGLoEvf00ioO7ao70ZsjKrUk8RfNIbnk+FTZgT6niuyMVC/K+5Jf7FfCllRrM4E/GBMc+43kWbO5lDmuTVb0jbLCnmc6C/OM8HnxPT9B0EVmyijnPj3Mhdn2ICmT9KSsvbRyoyYcyDic4xlwQtj6n4GuYS3YgUiMln608dkHGxWcIDcuLXkL4k8jUsJR78zz4++skI7wj+2iCq9GZlPR2+MVti87uRMhxbX3dlMoVZ6Xn7mF77F5MxKcT4ehbicjdGFazcuDX3iCqkWQlcLFb+SyUqX1pMOLjECNRluoISB2eXmkRuX85/izVniq+eQJFHiJoBqo5K/MMyGkSGwtz80B5uTIw0+bR2RZedwWG7NY9V0lhZYUBL1P4MQP/tV8O+iFsB/a+phB09WLV7V9lAEZ8XcZJUidgi7hnElNmroVLWnk/YT7x0myihyIcbo7yl7Y5MfH/jTDdyCPChPx0rQKkBR2VLg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(82310400026)(36860700016)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	d4XoBOJ4jJZyQDQ0zCZ88MCP8wP7Dp/ByTaJUaL7ap0RqmCMn8eKo10rvTw93E9DlM1va/kzVfKqrjoZdyJaBRK9Vf8GlQM0xqrU7y9MhbRJQKRFUrurXMbD39OQZgXgBJhVy9fTSaZra/7Ou8zm3Cb8OgREFZsAAyUZTKWTHhTF19lmCMPm8gFo4FgK8orm92l5LGR1Hqdq0HehcmczzCxBz6xR+g2dhZUycPfNJ25ZczurO6/osh00bZXTq6xdiWcRNUbVJ287UYEq+TFDb++2HXthyALPmNmEutPL7kOYVOgitd4wNuRT89UwbuHX/NNvcwEoEZs33MEN/KSvHQwfUllT1BXQqX6AOHrRTyS54K4quVSiwwsisxU1h5qnG0/qyT4zAcoLuMQJ1II+0bOHgHK4VOgLd1CXW44kyn+he7J8TJZSgI9vs3dFm04x
X-Exchange-RoutingPolicyChecked:
	dGyevb3fLAOpawxs3aYkwSed6lPgK4DFzy/4n2ZUXqt757Ee726CviBPTzXqf+/nCp9Bec5/ouDGdyAUfJ4kRhC4FYl3TWA518M0oGs9vryPcqBgPuaZIMieAgPYXSMT3zb73XMnLQU5Qct809xb3byKhS/6BonzW/b16gkk3d7G0uhNReODhZQPPslu6oulgr63N/ZU30FqJnA59r/MdL96S0H012jwBnIV1IizxNivLsA3ZZdgrGzWpoFnZatPucH4/vITWB26a1qKmR8QodKFl706TaKcU5/uGAk4V2ZBNqlmwi/kK919hAQ3sP5TEKgVRLmIyl6Sa2wOb80OiQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:16.1658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 566486ae-a8af-4456-2c87-08df3cdf69f4
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Authority-Analysis: v=2.4 cv=H/hOUOYi c=1 sm=1 tr=0 ts=6aef3c52 cx=c_pps
 a=Zi+2/POLpdgQ9anv5Nu4tw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=sQKIhDeqCqRtbGPzpkwA:9
 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX9ep2y3g1R9vg
 7AeToshgf/sX2rwDnZeDwRx6eZgcF7Qy8MbfoGcJOUbS8ZNJLHlwQEKxtFoqrhgqcg1E4sNKtF0
 54lArfC0H+cgsEIg4mFltPKOQpyDgCJTI/dUeMztBrJuCkxdCbfQwP2hWraLqF4QuXAJ1dHUp5X
 aLRwHCmHqksyCqHayWdF4uhjwRpAYWq5Ketvf9DzTE7jx4ICu/RZoGvWXJyJCjtEMLnjsqrgHCy
 KuMq4oJM6GrX8A6hLJYuApYxoJfgr+8+ygBV5pH6iwuMMAX7gnAPwkfl4X09K57NyOJrnFn9gHs
 gAlBi7chYIGJHXWKwu2IbpMkxXwFcyk+8siLUKBOQaL5Evh4Tt3/RpO3K9d25vcyw+74rRSlqf6
 tMikcBNXp/omK/fdqd6evBb19xQUDTqQQgr7zTSmXk/8enCzGcrBBDWPmlcAuVLzGIKFxHo8Uyz
 XaTO8bomnM73vM5raYg==
X-Proofpoint-ORIG-GUID: p6sO2rZesJxgneW5IHcyOjB7qbSpu0VS
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX59Yh4FJxymG2
 ZwmZA1knv6niZKgniGgOtSTc5jiMuHsbmd6Oukso0i9cBdSjNrOKHmw528NjlHQ5mXXAxwDMm2C
 3SxgVJHJEtGg9c6a4wLYr+EIii70Gk8=
X-Proofpoint-GUID: p6sO2rZesJxgneW5IHcyOjB7qbSpu0VS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

Change cryptlen from unsigned int to u64 to avoid overflow when added in
padding length calculation.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 657653d6c62f8..e141ab8980000 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -326,8 +326,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
-	unsigned int len = req->cryptlen;
-	unsigned int pad_len = 0;
+	u64 len = req->cryptlen;
+	u64 pad_len = 0;
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	struct scatterlist *sg;
-- 
2.34.1

