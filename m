Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471185;
	b=jyi3bH5WxFkXefliRdT0/kl7z5GSNAdavJgHunj0KWlocNTo0M+dE7sFSeqWgnkSyLpK
	 3YDkWb3v5j4zbwACz7lrYO/KIZ/s1vE49Rv7T4CIeKZ4NZTL0OhuwQVGyJrrgjHiRK4xA
	 l5tOqieEP/w91AG+J16OrVg2KFvti/x8e4yPNz92yYHGtLWyHxiccZREMmT/0KJhtXjr9
	 9ceHKou1EF93XZW5u8r7L1XazSORZDC4YZWTR2pqpyxYLcibOqiD2giWgUOqCXGrYaZ+J
	 4tIHQHUR2lhZ1am4rlhTWHIWL9ssNPAsGOIhqFMzU3XC/7ckXRSDmb/3wcSIJOS4JiA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471185;
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
	bh=SD1fHk5hvb915mMgJhg/oP4M2nQOpM/Y5yV+5n+rdFc=;
	b=0mJtpFZvzX6uxT0rfN8HDzu+rQo1DCAB737OWAAVxJ4TIPhGPbo156d7yUfm/FsZux3J
	 wBsXaD7GyD/Bopn74WLoLFGLwTMERsSZXNHazK16N500TaKvGXKHu/blurxAxrT1IVGhA
	 Ybo76LXC65c0628mS4CQhgIqcTcrFCc4SJJ8UKFQyUe6/RFmM+Pv7KKamdAtYUIfKIt70
	 ZixMWsxMEHwxB819qSUroJE/D01vz2kAtBXG1504p9pT+T9Kwksrwn+6arpzJ378VQ68o
	 a363+B2XUH0/UKGNLDR8XI3m5WZ1TSeWIoKWsdWQJThfCDktvU+0L0jjcOsTHv8b42A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=esg3T0Ll;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=XQXeHxdu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9846360A261F;
	Thu, 12 Nov 2026 08:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9846360A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=esg3T0Ll;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=XQXeHxdu
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AC5j4ku2297883;
	Thu, 12 Nov 2026 02:13:02 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=SD1fHk5hvb915mMgJhg/oP4M2nQOpM/Y5yV+5n+rd
	Fc=; b=esg3T0LlQZSc+W8DQQD12mGT4g7SZ5/JI5toR4YF1XRZbZqoxBU5RvrIB
	RrHuJ2Y+RuHkjcPPhhuaQnka6fPx/NDg8CJGi5ftb5kEQJp2YoyBLpI3BqjekRAI
	uKtpV079hC4FWwg2NFEPymAkABkAFkJWyxbE8xuFFhzm+8rrV2ez7a0b2Qu1PjbM
	uldh3R9OY1Tv8b7OdUtyobzbUtts5cnfKSt743eKHOolBOWzmQUePwiNE08mVjHN
	F6qDQyqxd4ZPaeivZOvG71qd/yq6IlpHr2sg+ThUfQ3jzIJh7Dk6d6PI8IGJ+bfT
	kDsFoAxktCjDrtn5fTJeCkya228lg==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011054.outbound.protection.outlook.com [40.93.194.54])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hw7k48w2s-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:02 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I2qIBqU2S0pccNZtyK6QQFtjGAaOqtnAOvuajjCmB8f2V4jW7zROu8jlPd5Qxlc/Ipiry0bkseAYNoA8eqT7zR7p72GuF0Aoef9Yi5c1JP/kAhNtRwNwoC6mc7NLlkyt1vx1wBPrbsCAh3UyGc9ZHpiBRPXbUyhWGuIo+l7inVeXPPhms3P+iiMliCX0GZAT4UHevxj59TmNEDhpGn6ryEFCMfapVff+rHuK/1hpONCKiIN0Lc+KMXevJzLBfR+aP5W1WLimOzFEbgDwg4oRSjyY8tAtzguryfCoz5C7luhg62C1cOY6ek8lfczOc43owjHRDrJBsgjSJncDA70LuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SD1fHk5hvb915mMgJhg/oP4M2nQOpM/Y5yV+5n+rdFc=;
 b=roG9A2qL4dZZYSqnpQ7KS01FXvmUEFwwdltMbuIAiSMqHBidedKINzOP3M68NxggphYNJHTGcLVwE4NDXHLAPO8X9s+4IwmubGP6KudyTgO1BA7i6vQKGKUw6idw9530uVJBUSWU37i+KUbavWNKvuZNAjmtUWo6slvuy7qtNkL/9Hbuy4E3wdWHIvpUSvH7KPSx3s3S+WeIdk91TCwc75PnJ3M9xJtCo0pAG3FU4hQ2TqGtnqX1H2CeMncNZ/2pQszWTvcOcfg7xRBkkf1bCk2IQmfcccnNd+sZLVfKiyD1Gk/m+0TEG324yo6XkGJOXHDv3MoSK/WXGrUfZvng5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SD1fHk5hvb915mMgJhg/oP4M2nQOpM/Y5yV+5n+rdFc=;
 b=XQXeHxduVwmxYtex+YrKDbpTdbkPeYFD3whDcxT9yGnUaUu6WS1go/GSYvT4fVWlAdMAU92WiXUzlHr90+3fMr7E06n0fKR0PklbXCU221xh+m6J7eiN3jI9x0TsZ1gVZBZ/dcWh1aPlXDUawsjXjtTxCWH1bhtwTOZ3/rFac+Q=
Received: from BN9PR03CA0474.namprd03.prod.outlook.com (2603:10b6:408:139::29)
 by CH3PR10MB7704.namprd10.prod.outlook.com (2603:10b6:610:1a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 08:13:00 +0000
Received: from LV8PEPF00000059.namprd02.prod.outlook.com
 (2603:10b6:408:139:cafe::43) by BN9PR03CA0474.outlook.office365.com
 (2603:10b6:408:139::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:13:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 LV8PEPF00000059.mail.protection.outlook.com (10.167.245.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:13:00 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:42 -0600
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:42 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:42 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8Ce9W1455995;
	Thu, 12 Nov 2026 02:12:41 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 08/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Thu, 12 Nov 2026 13:41:56 +0530
Message-ID: <20261112081204.1146395-9-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000059:EE_|CH3PR10MB7704:EE_
X-MS-Office365-Filtering-Correlation-Id: 7973792b-273c-4c46-96da-08df4094c441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|376014|56012099006|22082099003|18002099003|261102123227099003|10067099003|261026121527099003|261021121427099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	bQvHVhtTZM2OP8PbKNmr+j/Bo38V1K87XMVmgaeQ9DZNrf0rVkvx3+KJijpm5HS6Fjfazr6h5wsQ+B3JwZ9J0rvNxJOOsbt3mqm12jz3dvf6QEnbE5xp0v2MKftMOA/vZ/m37NDVqQMH22QvYq3+3o25RPmYwVJHghOXSTNtNDyJi3JVc5kehIGGK9tFFENb0oX5MefOJ+kQv/ktiVQ/pbQo0mpSe6zO50+TwoGIggxGzs1+ZajlWRO5z1gFrzhB0k6a4WickytOhvPMq8HSiYxB6jnBPjdxEpYXShqG3x2sqY8aS215crJa+rvufJIgOSA53GbyGKM3hP/BAIHx0uaUdrw1BD/EfZfS5rzahMSNvxCVkbfZ2CsVCy8ErcSjqPpmPUCcELhpbXtVwG3pC4Zgv0ksWEztwMHGbPGv9GIe4TF4imojq+5wgDrFnir6KvBy+jo9WP/7aFGIrwUuxNZdFrePsBiDNXm61eUx4ESfH1b0F4Lb/xhgpjog9kVsQx3sBc+Fq3apEjL/dVxzV8Ig/nmeCVi/5ujd3a1G+wb0g+fly7Gi5cu6yJ4qD5ZewQJoCNQlnvOBpYiidDrW1BBmVflEc5Ka33n8n+iHVa80cyA0QqDOs+yd0rCYadyX7JUqBjF4x+Na2QyrGA8R99N+nxke7MjY5pLqUd2vxY7GiRB9jlG2iZNT1pRxzJdi90MdnNuKkzAtjFRwuGQ0Xw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(56012099006)(22082099003)(18002099003)(261102123227099003)(10067099003)(261026121527099003)(261021121427099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xr4a3ZhC//p9DHk57H7DLKiv/+GE+mf1Y0zDQ0lyGVb3fuFQ4fCRW+0uRpSbkBYXXEzKJWbQH5GM4YCKFlBUtlGImP1q7aTym29s1ifgBZVl5jJQHYOkl/ibUluUDMbw8tBnu8vVLb2EqRbXcAZHCZd7G44meWK5xr3sMSf/F/fcWYpJA0roxaeZ7MNCmQ9uwDnfiMQG48sEvv1k/v7gEmW0jSUVwzmlC3gnVEzw4b3iQ7RWezH53BHzgdHiwTm0bdCPIkj+lCZq9bYQpQszDQFVmRC2F7WLdAG2Eae8mkV/h3jQ8TP1xIsmADUugU4PEXlfpdvYxaqzcGoV0Lbtv4RLkh2mD+zvqEEw1sL9fC/CyOf9lIUEEdrCLxGChsrbq52Py43lUeN4Xgk2F1q71o3ZAUG8o/LXD0HI9Y+O5mb3vXEDNEzEkXFINpgfJs0a
X-Exchange-RoutingPolicyChecked:
	Zk6XlpgN8K8fXz2yZ0IawIhTvie3gsQ4IJSsQNalzD4VdYgUNFdHfmyrVrn9rf7FcqWYjrucFejdSrRXpYy6Y6lBOGfb9I4riv97pz6B4Z2LyM7JDFgDZqzWF+uj7RRDXcAmOMQV8fbyt3vO25Ezr+lfFvHv7OJtLCD2zAAEf+tSYsERflwwgTVOycsyZyBOBK+g7HRicFyb/U3OQp3IC8fMwNlFWQMkIw1QWEJFqeXXrF6js7+GZxkQ56/SDlnj0z9qgtDej2t7oKFVIItVCk1jsAW+Hy81KehW63r76/kQsRbF5sMsEExKPj2hbJpoyVpEr/M9zDOMoc0/lkyR8w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:13:00.0628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7973792b-273c-4c46-96da-08df4094c441
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000059.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7704
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfXwcCo8EKD3fi7
 oGsazZi05hFeIMzPmtL6emF3PJGDvcpdQsH12v+Njz8VoNpHl7PmxdHn2nAFvoT+Lf8wwMlQhrf
 DcyoTs4PYxf9oSQbyO04ga/zBoqeamI=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6af5750e cx=c_pps
 a=cVuenkWoTzwZy9czxFkdkA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-GUID: W0_0m3EcFJ-cNVtap5Kw74_L2WBYtezM
X-Proofpoint-ORIG-GUID: W0_0m3EcFJ-cNVtap5Kw74_L2WBYtezM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX13KVg1tVVftT
 fh5A9gFG8SUNVbSqMWdkrLQ2rS8Xlz5nye3KDBOhY4PrsQAtwoYhjWGyMBbGoOp1LCn1SCcWMGi
 IyA94bGZvduxgpY1ELOsqTDKN4N4oNc6twkT+ybcn+ZO26lK/TpDH9vObXk7RheG5hzAl93yzc2
 ETdG1YS4EZHEotdqpOM5LCRltYc61zb77+IiKzcg6yOLyBjGTGDhyA6r/ZWkj0Bt4sA1bJowKTx
 ADq7Pwu5b1mM0wg4pYawmta8F1n31lS5hS1u26LyGNgQ8XIz6ZQF3LcG4phoS/hUmwb8Lj4nT+b
 pCce1EfbyvrnyetbHrkQk6tUinNXd8GCbkTm+UJfKlM6F8Y2OH2BdSoL8qnnnZKwnAcq3vRRF89
 v1xflvqTy4EEWrtF1s7VMhAaAySqYOFXvvPaP5Bl6zTUOAHy6rW9VEJQS2sFbBooXOJ4hW5L4xa
 RqPyWH6BAP7X5Bm+2Gg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AES
driver.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ef053264a5541..beaaca862f39d 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -354,6 +354,11 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
 	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
+	if (src_nents < 0 || dst_nents < 0) {
+		ret = -EINVAL;
+		goto aes_inval_nent_err;
+	}
+
 	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
 	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
@@ -512,6 +517,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (ret == -ENOMEM)
 		ret = dthe_aes_do_fallback(req);
 
+aes_inval_nent_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-- 
2.34.1

