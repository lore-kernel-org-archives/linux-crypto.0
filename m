Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067682;
	b=5plNq3CR24PGYEvLVcRgZEL5mtJ+0j8pTN4okStEWps2rVOYn99Jr8Fib3Xct3ORMQFr
	 bLgz+R0FdpuNtuDL+J8Xt6gZ8zsFPP92R06m50H+1HxpdBkytz4+OvovzCfrHRjZRZ7Xc
	 rDyezq1V/H1DQVD8LOl04HOzVTO1DpW1ILx9EwWvfRQK4/sw/l1vvEeBPu9Tow6JLEM2w
	 BzYxj5OxAPQYWfcw5BQ5JJ4g9R7b22HpOFtFuT9qjyVuOu3Vu/X0zRFtc6/6PQUWn1KMO
	 Z0snt25vA82dcYqnX1X8IwbwXlW9K7yd+XCcCFnJMyUC3FjUu7QUidlfTYC2H2QUbcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067682;
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
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=G7ilXA3R8kq242rCty31KatfsMVRUuvZ02TJ3o5Equ4=;
	b=usJz8re7dQmx8FIOvLzbIoJfruuw6RPBeHrhVdXS4wHBNIS1KZ+S2g79Wxd6thXxX49/
	 w2HopgkVxz/SH+eJTG1cnz08VNC5zNXo0Xf2WFi8TOi+XXh9Ij0r94LlfANHBxqB6+VDR
	 CnJYt5A773Zhg3eE6naoTrdeknNhD3aHh3QyLsjXLvCAf3IDpDrJGXgRsi5pJAKhEUl6Y
	 iUt9PJaeHREuiC1dplQt6MzB10q263iSPRZPND/hYaeO/4WFHgUwl1lhZz/5k6nN8kN2h
	 rfCFU8jPatLsmxKGyC5RvgnZeapIiYoi7mdFWtCw2LEeAN14xkyHqU7LFmbr3tr7P3A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=gE0L31LU;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=rCmeEKbE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30CE606A32D;
	Sat,  7 Nov 2026 16:08:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A30CE606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=gE0L31LU;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=rCmeEKbE
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7F0EWa2608831;
	Sat, 7 Nov 2026 10:07:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=G7ilXA3R8kq242rCty31KatfsMVRUuvZ02TJ3o5Eq
	u4=; b=gE0L31LUIq+FKPuA/8awDHklC3egDfnD9OOXbOQirSdZslYLETQ+OKa3z
	yvRdgDdJwQ8gFCFeocpO8d7ogNp+UiQWlpk6M80+s3sCfyXpXEOSlW58JXi7yHpM
	5pWLrUW0NkumbtgOhFBvn0CW0dDUboxMf9ujHE3JoOoKCzKSf4l9KQS89amsnu2r
	nSB3Qn66+ri0btiDr2kwlUwkqqKVUYA56Eozc8cuOyJDQhpJN0iReLIfAljrChxB
	xISef0ZY2ZCzNbEgISYV8pHYtxGFq5FDEOuqcN3jLU5dMAkkfads6bb3oUKI0wj0
	xhogRKeOVNfSVFR8DwDynyjnGsR5w==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010017.outbound.protection.outlook.com [40.93.198.17])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4ht0vrha45-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:57 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gsFPkE7UYLSeKKgEVoYXzI6ZWQWhu81+bV6991epBhm+wNNZKx+v8dFVcqjSQ3qCfZBu2ILMxbYhDeYpxpvW7HF8C4W7xCDTWWxYI6w1DkgU0KrTrChplj0QSzA46/4bzGhUkpMT+tVhj6jh9lTgW3uETpHD4cc9jKVnAXPvmdD+srQeVQJGCOOmaD9Qq3wQy05glAMrptSUNujbMX94Kzaez54z+5mw8qjjCTxAuhLfASPZjFsAd5fYd0AqBMTYd+fqVeRSzEApjb3QEqDByxARspH9YOOito8L/u6FCNVX6erC90l9k9zHRWqHGLQAmdbtlsmiVyi7t+g7j5+imA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7ilXA3R8kq242rCty31KatfsMVRUuvZ02TJ3o5Equ4=;
 b=cZP+wACmRZlBSrCozzHy7tYCHvqdV3hARAcn3ZoT7kWn0Jy2d5fcI27WhNkr/GnxGo9nApHjc9jKXLFoQy+7C2IJuYhy7i/5XEfEPhpRblFqtIWQHgHoZjKnZ4Rsv5aoJS18wZg306cUG0ZK/PoM7R+NaarCwD0j7oFsWOmyns5plA76mQDOK5JGtYJhKvhtGJvpbC6I8YNuAqVpTZ8tvIYG8LVwtM7gxuurrXMLQ9mWqWjTqGPn8sChueKevamRel2HpisUlZjIvMWBetSrYaIZlgRAiLxbSinHJxNnSqrPuV2lEtkwlBcAtYabCjcyQAGmNQHMqOPN9930skGeMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7ilXA3R8kq242rCty31KatfsMVRUuvZ02TJ3o5Equ4=;
 b=rCmeEKbEL1R5bjZIFllVhCDuVgj8jtVSWr3IaLaEY63SMuQH65ehojGzv9GUsjTQtt7+1t3whOuebtFwrOdsVV34GFyNSO+JoFf0/YIk+DpnleZaZ4NdmzH46z6ZjdDAb3bJweuPSgjcmmNmPeDAu0W8UOnsdXrEkwRj/QpaBSc=
Received: from CH0PR03CA0211.namprd03.prod.outlook.com (2603:10b6:610:e7::6)
 by DS0PR10MB7246.namprd10.prod.outlook.com (2603:10b6:8:fe::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 16:07:53 +0000
Received: from BL2PEPF000352CD.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::9e) by CH0PR03CA0211.outlook.office365.com
 (2603:10b6:610:e7::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:53 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BL2PEPF000352CD.mail.protection.outlook.com (10.167.249.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:51 +0000
Received: from DFLE211.ent.ti.com (10.64.6.69) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:21 -0600
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:21 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:21 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G7JeE277477;
	Sat, 7 Nov 2026 10:07:20 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 13/15] crypto: ti - Correct AEAD tag operations against dma cache invalidation
Date: Sat, 7 Nov 2026 21:36:28 +0530
Message-ID: <20261107160631.2592763-14-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107160631.2592763-1-t-pratham@ti.com>
References: <20261107160631.2592763-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CD:EE_|DS0PR10MB7246:EE_
X-MS-Office365-Filtering-Correlation-Id: 30448482-0287-493d-9e99-08df3ce94629
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|56012099006|261021135927099003|261021123027099003|261021121427099003|261009223027099003|261026121527099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xJVzp51p8cy00lgtuhYM0NEnenu8aJgvTeGf0xILddpP39pg/xylthf5hRKoWFV2xgMJTBTca3pOW9dyu0L6QuPhTzJejOQXcchrkMObaTliY98Sb4ZbrtbS3HrfXltRc91E2LIiHllf6/woqCxErRmZzzF/hxIekGMhTzZzCCLh28dB9wYlxTDM1+pXXBqreY1sh0W3t9ei+ubHV0F128LfRCaYGgEs+Rc5hfpfWDEg0YBGoRogDDCOh4Egzx1K/RulPB2eDZ9W88qgl2KyATL0c3zYC2poDIHqjcnuGEglzIAVRrviIzGzrTV3ycjxfKCHmc78VZ50+3n/En2YLP8O7mGsNHrzTQRbyz8897WyvwwiOj2bchf8sUxa4pNw4XAGTsqd3Wx2pgceNa25p6a7b2OjY0hPM9Hyc/zRAxqtyaajii5RYjTo1V2g30KaPJQ8AdNIyalFYo9gqqxrUPWhUujBmDQCyaj874/NGwY60CWBnrGFXJpK3sRM2Aeuqg449yqoqW/4IBHhKvfgMwcHo5tuvzI2rT5AbXi+zEySUbweS/6tZYgTqNC2elBjZmbDRMiL5Si5WHhZs7QjRNV9NlRH8zd9pU72xdDS2CTJAyVr7w0bbv5OGUu/4tLxuRe2DVjBBsJrVgKQA7loFrDDzeniZUF6QtvOmF+GcqsMdNBZI7Awd6tOY+W2lYcEh+K1oSbH9jdgx+Zxwm0j9w==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(56012099006)(261021135927099003)(261021123027099003)(261021121427099003)(261009223027099003)(261026121527099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2Y6x3d1BeBhm6TAVUAMkFuwPdymDJHFGZruPsnluU5cFboQapjrwW2mQAcYS9/Cw/RDXpQqAJlYd/dF4WnQTuT1QJkLcFeRsuRnmSWHlClrOvwVwtBoO3IiOqxZ6rPJGM5Xp4o6imH8j/8whmJxnZ2wtt/YHOY8ZQcJw+ad7S1vMiCUdg10Xk6Gubr0UotpLP8oOHUrFpO1nYtFzLpH6WYNsj5mXPTae1woSDT+UX+Ti7HqqaOb38dRbRIfIJLU1G5XPjbuWaM47QZTtJl7oy5O1GVWet/YzhN2Ko+OiftcWjwd5NUVofvKRvlmExAZbKr+tCgBrCz9YHyZUbkwRbm/vx/+0Nw3m5JOzPEYS6SEncEFbb1TpoSAhWZkIPEX7RmVYx3+lzW6NRN3qYh5NnQCCCzXhHel15GEUJr1Ao+KL7Fb43KqVyBOgTd+z4J5e
X-Exchange-RoutingPolicyChecked:
	cJpdPbqOzYcNFo2InEBTc08CkfXjyfFK40tOrsYCvjBHsxRqFfddZ8LioQYOFwjMgOAU4aXPluKxc/a5HUyJunmVC72d+fu0Y/lF5lquqzzzcvxqgiaBop/ra2LCm5mv7xqmGGvXFJTUPD6CJ9z8WrrBGskGODaebFNFGJorvhszrXenllH0XKM1rvD+ZjWYfn2B5DqWY575qD+VA0AN5dcOcLXVc6qN6PSBOdHUHWOoJfQjwdVGhJ7h0DsEtLRxlPfqvNsjYbAsr7vsSBC3VMq/oVEwudR8kQYiArr1J9o0I5c0Q32T6mhMh4qIJ10Sf4TGGDqtxW0G8E9OUUNqBg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:51.0932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30448482-0287-493d-9e99-08df3ce94629
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7246
X-Proofpoint-ORIG-GUID: lP_v5j76M_kxlMxL01U9Gi9nPltnTffq
X-Proofpoint-GUID: lP_v5j76M_kxlMxL01U9Gi9nPltnTffq
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2NCBTYWx0ZWRfX18pz8EiBHVDA
 PBHx28t+ZO97clZvbEJbZQpC73y4CcWAvUnLkcXzat/v/JZase2Gu07ZHrvmZd+3hoURCbqSEFm
 GdbMY6RRLOxCsGJWbmr+9y4AgB6CDWg=
X-Authority-Analysis: v=2.4 cv=aaf0Dhot c=1 sm=1 tr=0 ts=6aef4cde cx=c_pps
 a=gXOkrB+iIAMM2YfcT1gRiQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=BSBB0G2mMgAadyb2BJkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2NCBTYWx0ZWRfX+PNHildO+faR
 xytKqv8EyInFDGsGy9wkXaH+3B+NNrcUAN846+CFIAlVO5k+0EY8A/tKm4U91m5uUjuE+PFvPi3
 B3PuMyavzSLoSgVzPncSbKxcRXdJSBypTr1SvGWBKNRYLQGFge1/E+2Adpg53HzPc6OhYTKvCSy
 Ej6Ud6gChJlqBBl1LAbWw1HT5tqHWNlU6L7yOEvISsyACzLb1ccDedKRuplfVzhaW7UT3yrMGnA
 fSNhPuYcBTvzAODdh8S4zwCQXDcgdIBb7+aDZ2bGsg9XhKDzbGjXifVKIz0IToFZMATZXJdfy5i
 Rtr9Dj+QIXzG3MKOUhyaOLa1V9td5JBu4D6tYZEF634rYQNH0lHjF6rf2dXEFcbhJhRfOEwLflc
 KF5uMxPdy+ZxjHHttsWrHLrJkHCua80y1vOmdoYkI0AQzi06d1dY4Vh0oa50DqGvjUWBh4NBEoa
 OhgPWmJwvlpQasQvWIA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611070064

There are two issues wrt tag operations (tag read/write in AEAD
algorithms) pointed out by Sashiko:
1. dma_sync_sg_for_cpu() before tag operations always uses rx_dev. But
   dst is mapped with tx_dev in case of inline operations. This is
   "technically" a no-issue right now as both devices use different
   channels from the same dma device. But it is nice to be correct.
2. dma_unmap_sg() is being called after tag operations. But between
   them, there is no synchronisation step. So tag operations writing TAG
   into the dst scatterlist could in theory be lost in the cache
   invalidation done as part of unmapping scatterlists.

Now, in the current code, we can correct both of these with some
conditional logic and repeating the sync (this time with
sync_for_device). However, it felt more elegant to move the TAG
operations to occur after all the scatterlists are unmapped. This
ensures all buffers are properly synced as well as avoids unnecessary
repeated syncing of caches.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index e7a7024f19cbd..220f08fd38977 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -915,6 +915,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
 	bool cleanup_tx_chan = false;
+	bool do_tag_ops = false;
 
 	int ret;
 	int err;
@@ -1138,15 +1139,11 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		ret = 0;
 	}
 
-	if (cryptlen != 0)
-		dma_sync_sg_for_cpu(rx_dev, dst, dst_nents, dst_dir);
-
-	if (rctx->enc)
-		err = dthe_aead_enc_get_tag(req);
-	else
-		err = dthe_aead_dec_verify_tag(req);
-
-	ret = (ret) ? ret : err;
+	/*
+	 * Need to read TAG registers if data is submitted, even in case
+	 * of DMA timeout, to clear the hardware states
+	 */
+	do_tag_ops = true;
 
 aead_dma_prep_dst_err:
 	if (diff_dst && cryptlen != 0)
@@ -1162,6 +1159,16 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
 
+	/* Do tag ops after scatterlist unmapping syncs caches */
+	if (do_tag_ops) {
+		if (rctx->enc)
+			err = dthe_aead_enc_get_tag(req);
+		else
+			err = dthe_aead_dec_verify_tag(req);
+
+		ret = (ret) ? ret : err;
+	}
+
 aead_dma_map_aad_err:
 	if (diff_dst && cryptlen != 0)
 		kfree(dst);
-- 
2.34.1

