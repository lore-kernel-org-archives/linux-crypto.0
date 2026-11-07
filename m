Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067672;
	b=e66aWWZrWmrkt9hkshHLnWNYbIwUqHtCf8e/NZgqV3Rggo19wZ3uvsXGA5b96YLz11vR
	 aKHque1CBolwP+kvpoqnSXITx6IaoWs9RiikAGbtmqbotKokybK4+WvxnmoHdZTnWs8aY
	 yEPIn3VKffjwb/9ls8N5uD2z1yO5x7DIQlgikZH9VBvgGU3XYz2uW22ewnst4pLwY3raO
	 ZCZDFzN3e38lQN+KEXK3te8/+XXkv5PZmBybe8OHlbtauXIjid8nc1QOf9sTqD+qnzE6H
	 UiBhOhsncJ8wL1z5FyoRSFHSW9lsQOnseBpe1OMuZ1Fn+gDXky3Oj89LZcia2uto2dw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067672;
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=9OrI+pjQR3Sg4d7As/pFtcaxFPnK+ARuetgIV8PKfxE=;
	b=4QqucIb2FQzbqxIya1/kfMw2rxPxZPHPxBnP4lJjySLh9KyEIBBwK1y3e1RXDfTAX2rU
	 32/s7QKUICNYU4nrKcRg71Qp4jl/wm/En9DvyMeSFEH9ZX2kYRGrwo9jl+vYjLCLhLrdJ
	 VXNEkiv2zNR4oMJmZPQM5j+GzGgTYfSDTTy4910g8b5rNAn8y8kFTOOXG6iK5nNq/feH7
	 +pjenMc+m2JzIVu1xOw6nPdZiFS5Azt2x+2LZN1JYa+bKsPJUekCFmX1LDQ14Snuytair
	 01L0UVVw6a8D01ziX7NB2MkHomwdLSffEn/oZetiFAOluB9hcCphmG+xaX3lJZb4dtA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=evgrCaHd;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=IPv+aUIl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38656082BC5;
	Sat,  7 Nov 2026 16:07:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F38656082BC5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=evgrCaHd;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=IPv+aUIl
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7Exx5i2335376;
	Sat, 7 Nov 2026 10:07:50 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=9OrI+pjQR3Sg4d7As/pFtcaxFPnK+ARuetgIV8PKf
	xE=; b=evgrCaHdzmG5ce+AeycuhSI32SqOhdwcRMgM3oE9EdpYyma5iOS5NCMz+
	d1kItQvfu1ohGBY9tQjQXEiZNTOEa43hpbDIbA5LG6R6mXoZfpWsDf55qpZFcn2u
	/hFmgQIVmNWQIjqe3iI1uw/qE/KRdxKn+L+rZ37oIUebrAThscmv0cHjnDbv781t
	FgrXgQZgCmtchKGj4nd7UTfPY34XgWK2yuhYmJoRlOCHsTfsykJTFF9f7EQXAleQ
	jGeRMYv0yZG+ENbfYUzckxWjfbbvYRjrzoWuLQf0gwRvd6lcUa9zZ9napi9Sr+Hf
	ny4foQF4rjNDgY28kL+d9pzCipRXg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012059.outbound.protection.outlook.com [52.101.43.59])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hsbwyydwr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:49 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=utb2O545g0m65AAbJp2zuXBPISrizNt2aaE7C4VLT+pnOOiX9T1RQUKPq20eIPs5YQzVbwMF7byfAut7YF/Ir1lORki3UKkMzIsB3MXou8oXxf4OnWfbwOUoT/QE4j3lBd9A5owzBtanpBRrPto8nZzmmzl4BCmAjoIfA+HleqlSNrZRfQ2oM4WgTJaoChTjLF2ZInNFCrldh49/5FWx0KoC82l7WNqflR0Bdhlqc/207STuzKMYUhVtQkelnGiDW1fFZsc9YT6B+gdooadYXDW36E/F4pWTan/7zMY9ahQaWZ6w8vwlmF357Z7wXR13pzkinAWhN9RpzCdxexk/Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OrI+pjQR3Sg4d7As/pFtcaxFPnK+ARuetgIV8PKfxE=;
 b=mx+XwEQrxXxlMWZcGTvIzbMboZnw64xk5BNS1o2ck/T1FHWtTVwBR1G5MIe9Xw5NweegrWKcKFoTbquLmaYfF7liqiyaKbp/zmDJ0FaHC/ZFnga/o0wEalK+Y7ETNxv+GRljsF911edTIhLiL8PZsGHh+DNh8xydu2DJ6DGUyyK4tAMGiS++ejIj7Y9wao9mNF+zKx63ZsbxeJS37yG6CO/t2K6EkgnDgSL4sViJXGg2Z7TfLY5Ik4sq3rGv7282cNmtgxPBWglpy5Ms08x1RpSzwxl3Z8WiRBZkbT78YVSbEdCAIYkKO73Y+3ehXaeMe+lNYle+pHQg67MiuekT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OrI+pjQR3Sg4d7As/pFtcaxFPnK+ARuetgIV8PKfxE=;
 b=IPv+aUIlK3QtpFK7u+kuTKFZTpmWjCFLYyfxxFmj+WN2il3uXudrLiuIhI/hIvEnqW6oSiNNjxbUUcFioyoSmoDswN8SqkjenQdFInNgiRoGdbuJU3/keOQoueM2JSxqMeIF/hXgG1l5ZLcMKGXUWU6oS3NmJzK1U6qAYog6uqs=
Received: from CY5PR16CA0017.namprd16.prod.outlook.com (2603:10b6:930:10::6)
 by BY5PR10MB4193.namprd10.prod.outlook.com (2603:10b6:a03:202::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 16:07:46 +0000
Received: from CY7PEPF000000F0.namprd05.prod.outlook.com
 (2603:10b6:930:10:cafe::35) by CY5PR16CA0017.outlook.office365.com
 (2603:10b6:930:10::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CY7PEPF000000F0.mail.protection.outlook.com (10.167.247.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:45 +0000
Received: from DFLE208.ent.ti.com (10.64.6.66) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:19 -0600
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:18 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:18 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G7Hql3460127;
	Sat, 7 Nov 2026 10:07:18 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 12/15] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Sat, 7 Nov 2026 21:36:27 +0530
Message-ID: <20261107160631.2592763-13-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F0:EE_|BY5PR10MB4193:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dd7804e-b48f-4c3b-6b03-08df3ce942d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|261026140227099003|261022075727099003|261009223027099003|56012099006|261022105027099003|261021121427099003|261021123027099003|261102123227099003|261026121527099003|261028144727099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	AbmL0+v9auyDl5fbSJ5ywPWPgasu9Eupv4qmT1s2seVY7zo2Orhq6PztshmqcGJuvKrmnnrnTOFYpB0hh3cKq8CJAt+Ay9HYYa7eBPK3+yoasnc1zve4Wg9lSO6/fAWzwcPQTw3mc7V/iZyMJZ+HBCUiX2xxUxnPvjvG9TK6fqR7qOg1ea9trNv0cz06IXOi9dI+rjTofIxkk645K1StnsJUYtKiyVkWKiAtZCT0hxrZaHPjLmKkTmAT8Kv1R5B2jvqiIcx3owH7lm5Cl4KW/26U+FcwXXUwTNqLzG9DS+zRH5JLEMjWJfOvff4hSPAHN1W3kwoajEMYsy4GJ6O6B1db9c9abzNuufVnYZfuY0/Ycl2MUCTeutEU4x+HqiZfnNJBr7FSn76gTzRp71sDGKL06g8/LTnt2ZHDnRwdLBqvO0LERdfU7KOW9XglxZBRvFd0AD2KhSzlVcoHYGIkozzEHqE6A0b1kedBgeI1Hx9jq3CaNWWSo5L7iES2doNqN2f2Tox47iRK4h4SHP2v/kH6LSsNR9xOKQnAgBs/9fe2js63eBXtAALppgSm3EAzux7/AAt6ZtxoqJpCP4Xl25QmTU8nFKH0FnOx4gUXPW7knrwORGBpPUy+bACTIX7lps0JnfzgxyT5qanKI7VnWktFjmIYE9DTrDwV8iTAyRq5R12i6IUin8ugP+UpUVaV7+PKI2KHo1iTaEZUfS4kSg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(261026140227099003)(261022075727099003)(261009223027099003)(56012099006)(261022105027099003)(261021121427099003)(261021123027099003)(261102123227099003)(261026121527099003)(261028144727099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Bl2rMnyt5HskxoS0Kab25RfchcS6p0VS1lm//AeKSqklFTtXL8uDut0LwjuCDZ6w9yRfMQCmC17pQ/F101GFGtjH0sqaOPn/b3IrcWp4m6r3spklLTrL7B6hNfHMwbMP7H613CBMJfGTeihQ1H3dzeKN491Vtf85vVf1Khz3SwWM4B+6glCqpxkTvINf0oeZHGTjIhF7A/ohY+BspQdBGxz6Z1H5AriQqY91yltot6XSzxBrfXk5ANJHwc7GnPQ2KhIKQVHk+JtBw+v6xGkWPWs9hg3qRZL1Dz0nZPwqWXcvGf/srV/IAkCFaxkefRply2I6LLSdu8sCy5pTMUih/teIFTHDWDUM2CweIVNO5LSUZdwHpx5c3I+U97FSJQf8JVMfgSUrpPrjbtUNmK9v8t6q5lN10oCEIdHOdvHSWYUHVnLBjOvV02yr3ZJ932uY
X-Exchange-RoutingPolicyChecked:
	By8q7u+/cdd/Ggs+U2JWI8QVCCHcaSCH+CWoxdvVQM1632RnlAH5AYm5eGVZS99Pq3q65YJA1B96j9ap5ZnFBIPUJR0ywnOJKvJN1K0yjfm5OLe8V1qm9hu4RjyZ6Y/JPeV3zzuwTkAaNyBrrw9P/owohHIQmm0p1R65T6mjSF6R3oIrqrFjUYFkMy3YNMB9PrV3zbv87P+EnDbzpRvbRU80c3irYH+JSiCcDpl3q55Zu0MVKs/h4zx0ZzsUlif/JMga4doCMgyaR6H93Vf8nA/fS4tBocY0tK0l4Q0Un5jOz4fZl5H1/DYE2mpWqIqGtMCPqFXx8o96yopBVMQP1w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:45.5380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd7804e-b48f-4c3b-6b03-08df3ce942d5
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4193
X-Proofpoint-GUID: iSzOmfc9FZrKjq6fTPP0TRspuw26ztx4
X-Proofpoint-ORIG-GUID: iSzOmfc9FZrKjq6fTPP0TRspuw26ztx4
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX/PU7MQWOUVjh
 BoYIgB8/uBiaAYrvvINnkv5/Vj86uZEq3d2QfgRdTDqbSAb/wuxGrNZ+IGiJmzUP7KwXR+7grbP
 2rIIxNP3ZoLJY7es2MHEwkV72LUC7iA=
X-Authority-Analysis: v=2.4 cv=fvNJ914f c=1 sm=1 tr=0 ts=6aef4cd5 cx=c_pps
 a=tVU0SsWZS/EEg8/MReKahA==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX0TAxe8HTX/Fc
 r7tR/1XyB7Za4f86Tdwq6ET75TA9dZKKQIQcMLPmVhxBYRcm8L2lfIVWwNRXxPPAixMoIVY9LEb
 sFX40KEWSk4GY2gpS5PK+mhuvRh57qTnBwU3dUQFBU8o7E13HB+TU+tFe0IRacHVUFkDY1Sb1N9
 thB+4hIDgWh+0Wrws7jlFBPfXgjC81t+9W63yhGxkO4NBQL95GSoSepXSGJbRomRvnXMqaELOsJ
 Eaqq3FFjiF+U5QhZFhPldHM17ME2XuACAKZCexIgdppE4qezra7w9RZSLJlbii7LPQikkm+YNVX
 6mO4Eq2ssFCV6wOflY2iCN1YHI/DomRE8Ss4PCeMjo+/pCbVdMRiURCLE/6ZEmdVOi7fd7jme8i
 GraZB+VUC4o5lfpToVi+XrsEuX6dzQaDQng6fiv43eljcGTt48OBKNmvxPRnmrIsyF81YPLbKsJ
 hYWypdAtMS/snaiveyA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070063

Similarly in how AES part of this driver, we are falling back to
software when memory allocation fails (we get -ENOMEM), fix the AEAD
part also to only do fallback when we fail only due to -ENOMEM. This is
because we are doing memory allocations with GFP_ATOMIC in the beginning
which might fail. Any other failure paths might have modified the data
or buffers already. Doing a software fallback on them might give
incorrect or corrupt results.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index f1f12126382aa..e7a7024f19cbd 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -1177,7 +1177,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
 	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
-	if (ret)
+	if (ret == -ENOMEM)
 		ret = dthe_aead_do_fallback(req);
 
 	local_bh_disable();
-- 
2.34.1

