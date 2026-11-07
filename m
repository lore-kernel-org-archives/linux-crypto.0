Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063415;
	b=wxGbk/GpOb6rUMaf0br1R/8zvyY7l+XT1Z0kWTR5q61leJGKo+LyP8GO1Rl3mwzjNxpG
	 KZb6Fse84BM0Hiew43J2rZh/xIhjkqpZmpT8oB2LQc23MHBdAKi5LoeGrtJJ3QRo8V6eh
	 VIzmnUL29f1o6Oz35cwNXzBeBoCPo4pI3wNKCJ2wa1NN/bCBUi5osgufLQi0l4AMVTRFW
	 i6lMlzaP74OvzibH82EJ7kyRZqfEWtzAbDkzhSw22GZLpepDriV1EWWThtIp5RdVvjuPo
	 5DpxKgBfrVisQGljNtRxBDdg6/ulq0amwdBRDiJuNjUjrcqExvWs2waqG7JBO+AYm/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063415;
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=Yi+KxacF098NNfBcVvfSEmIXBQhnpyolIsnI55q3CUQ=;
	b=2pxmh4jIpKa95DduzyIi2HaeTEzJECN3rcCq5gjSJPHc/trfM5aVPALuh8c8HxK/ATEq
	 vY8FsdnHF2o7/zssrZTWY8Ew9h13fjRg0l08wX5f5Be3XIpiE929Z7JOUZ926bZEixKz4
	 t4ttJMHJMWNSxh+YxylsdIW8lGuv5/au00GiMBQZVB+xFsnzZYH/tiXavmQLCCwaH3zHj
	 fM61VVH2UfqxElEUNHzwUJBLEjHY2Zb0zXQT69R/xuOjiU60sCJyDKvmze6jHmGJbZZpD
	 Dd1vfPwnh3uE7nF/4WcIDiHZ8ZLVVZEwzwLOJLKUqRBgIiDLs/EMfh3F1R9MrdO3WMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=j9FbOHiv;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=pKujlqbM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F04606A33B;
	Sat,  7 Nov 2026 14:56:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30F04606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=j9FbOHiv;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=pKujlqbM
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7Bx8Ex2280004;
	Sat, 7 Nov 2026 08:56:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=Yi+KxacF098NN
	fBcVvfSEmIXBQhnpyolIsnI55q3CUQ=; b=j9FbOHivRoGosChq+UlfGdT8hBGsg
	bbyeBziaPP10R1q+s+7yqJvEOGXSvhrrI0vBEedHHFX8vFNWiz4m8Hddjto2++Il
	hWlUm541Pyc2gMYO8lXTSau+GFgtm5LaLK5v1atD7c7ZStAK6pN173zw2wocM3bG
	YRC60JwqFKrwaamhzogrTpJcf32EpXYOh6T3SYrreSnbmjZcA/+Zt8I/YjH+epJG
	iAefsrODeLeXwQHphcFD8O9Bs0H4G3lYZwWMfRklYBpxFb7thty3CB0IA1awLnl4
	FEzderDUtVOz9rJ5gYwmxBWrnAIfpEIGf8+wzKP4G2jt5kxVYPFFti5MA==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013024.outbound.protection.outlook.com [40.93.196.24])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4ht0vrh006-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:56:48 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y7zlWn70gMkSSNxeJ4ysX2OeBXibgFSynprmEP4f6JAbQRbJiySbMDujJDdQHX35tethyv9za9VkBcXtsvQcU9i7MIA38PSNug5omUn6kyzTjInwGLnkurO/n+B8YPx5mlqlAD0mTvlfLJ4ZOC9YOzjp2LZGzETgSLgUw7Tt+7LJltt44ipqSdKM4YT5iMNoonTNk/Xm3yKXP04j47GS7n3R1VV4GLFSIagFv1HBraKJ4PW69LUlhkfqAgoniO0OGxZ6B9N6Txm26+z/er4ozGAOykS8mYXCRCQ7lQsEv+DFGZquCUp4mqwUrQJYNi4wNJRA+40w4WK3Rl7J6oxkFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yi+KxacF098NNfBcVvfSEmIXBQhnpyolIsnI55q3CUQ=;
 b=IQRioMvUIZ1bfQu/TBfV7a/a3ecEkgSxVNDn1uzOVI1YcFFeMr9p9ZAlV378JRe51jTU22CZAYLVp9F0fHZMkjNGj9hqPybJUO3ZE7dgA41CfOdzeWJFLGtLTeZRhjTqQHHdAL0hfcY6pm9qit4O75B+gqDVJCdUSvDJ6bHRY7CcTkq4rr2YCR5HWTEddUA3OdBN/mGWnNtMg5XM0rskWqbs/gXOUjiZW2ipe+J+nzuPwTb2Pvrmb41Mi/p+BQO0K55Y1Z+sCWrLD3QKuO51WjILsBPCki315d6JoxF9XuyrPFCF6NFJijxM+tdAUtoSaLij9RT2ZamR/h0Rl6CwIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yi+KxacF098NNfBcVvfSEmIXBQhnpyolIsnI55q3CUQ=;
 b=pKujlqbMXzsVWUy+HqXfbD8Cq+XQ8oc7BR8beiFvH3cEgjN/eVIakWK4s7XefPdaZpwJNT3xUibncOugWfn5l0Bb2qzNz1vLh7pV8FWjJzKGF+bsq+1dcPLpXHLBGRTcnSFXmrZnDTOgx5e4PlCPnaMfFqhLUo9lf5JWYZdBsUw=
Received: from BN9PR03CA0034.namprd03.prod.outlook.com (2603:10b6:408:fb::9)
 by MW6PR10MB7589.namprd10.prod.outlook.com (2603:10b6:303:23b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Sat, 7 Nov 2026
 14:56:44 +0000
Received: from BN2PEPF000055DE.namprd21.prod.outlook.com
 (2603:10b6:408:fb:cafe::9) by BN9PR03CA0034.outlook.office365.com
 (2603:10b6:408:fb::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:56:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF000055DE.mail.protection.outlook.com (10.167.245.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Sat, 7 Nov 2026 14:56:43 +0000
Received: from DLEE208.ent.ti.com (157.170.170.97) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:32 -0600
Received: from DLEE212.ent.ti.com (157.170.170.114) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:32 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:56:32 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7EuURQ190365;
	Sat, 7 Nov 2026 08:56:31 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, "Vishal Mahaveer" <vishalm@ti.com>
Subject: [PATCH v11 00/15] Fix several issues in DTHEv2 driver
Date: Sat, 7 Nov 2026 20:26:03 +0530
Message-ID: <20261107145618.2349562-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DE:EE_|MW6PR10MB7589:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e05736d-a413-40ca-a7b1-08df3cdf5637
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|376014|6133799003|18002099003|261026140227099003|261028144727099003|13003099007|10067099003|261021121427099003|261102123227099003|261021123027099003|261009223027099003|261022105027099003|261026121527099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	aWi5V3m0n1tUF7a408Us97iCbYbwnTkmCxjGs7HhydDVjq8SZPDBnQ3sf0mnQyuZa3P1FwfPpguNQA8Ey2eAT2YWz9XJvLZkGiZM9xJ3V73l5hUrtqtei2rTInoNNNydjjrZnWljaJvsmCcb+ZIkdupDvLf2zgPrqIPj98EdSkzxeaBfTdznhDYna/ulAS9QxOADXxkQpjgbzpui8fxUubGQqGV/2NP4KqyCrzFPLoN09GOfDJeiZ3bkHTtaxw/HRyqQk6GytvOAHywn4zh3JhLO4cY78gZo6hfI9InclNEKpaitf4psA05qYCy7nA83I9G3vCTfh9YajFhUuGorV4xfVt1m7s69bDyGLAj5aY1ZYfGstmnFCvX/qgdCrfodHX8ty5orZW6VixqOyWD8Knh+zU8OU29gq92x1UAwbfrtLgOnSNotM0i7JGUPDFGyRs1LaMxXiWw7WRhgVots+OHdYH0VB6gOq5q4lrcThxM7bQSt3ZCP/2oGFHucAsgBW36hnx0edJy9gea+yYzYPV98yXWnUz+BvgwezHsi6ilkmEZgZb8viHAhUGLJhky4NpWykdc3lDpbORWEuCyiUjpdmlMwoNLeOd4q1D4KF7APpNTmXmNTIkV4cIJ+NsiHwKSUo6UQokXyPpAixx3SAA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(376014)(6133799003)(18002099003)(261026140227099003)(261028144727099003)(13003099007)(10067099003)(261021121427099003)(261102123227099003)(261021123027099003)(261009223027099003)(261022105027099003)(261026121527099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MgUUl8jnH1N88ZZRIvFuCuQd7ooCTv0fADyBFzK4PtzhHwUg7lUr0y5qCnNeGnECxVa7hDodir9Lz6O0qEc/AZviJceseslJr7D0pOSfgmRUrGxJXpXe9Ja03oOwstCpupYY+Z+pfWdWBHWYDKVjacChYgRO0Q7z1jdjcBfnkxF6XMQzTHSfNnhkHBn1WCuz+aoLQrL6VmeYuDNLORSkncNiBJ85WjuJ/eGDi/rymj1d63jFY/yZBMyD33jMxV9RSirlRKYp7YgI2W+QalctcAjI8Dw9qr2NQBxpb2N4PlevSHCAZezobxN4tJsych1KMz+/4NLg+6fhzn2ox/rTtkFO51GdwBI3b441h3bIEbTq0gQJmBraH4chv2Z1j+xnCf6VbMMOcpE4K0lhU2FDmY3HKAu0X4A0TvMziYt+/GlbHx1MowHqPGWlC+ArI3iC
X-Exchange-RoutingPolicyChecked:
	dvIcGhxBjUC9l8Ptqy9/uWanUkI3FHMvnb4bcOO6lepFWCyEcohpOJfIQHPOCQiF2W3CM4clQkRSCreubWxr9SINhQ86765qfNuqcJTEiZuhA5B5ejWzq3edvVwlmUK8DVbUvtBLiT3OdExFSU837df5hhf5/zfhrRezwV2I3u25LSUJqx1YxAiF++DzPuSwdTcT2f+nECZUBRPIDgUsb9VZyMm+QzMG2fY4Y+X+zrtkrroFrMlOrXEpZTRexnWqGLFf9/ztXcrMkLQHsbIYXZBaaMvJU1BzzI7K2OIjJxREOOu7hboVBIe5qpxW1+ANnasrmsETptBiQGFJE1K0fA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:56:43.0531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e05736d-a413-40ca-a7b1-08df3cdf5637
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DE.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7589
X-Proofpoint-ORIG-GUID: QR0M-ZZCMswMzVkaOwWG8jNyCIDa_7ri
X-Proofpoint-GUID: QR0M-ZZCMswMzVkaOwWG8jNyCIDa_7ri
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX8tlpZJi1NOd9
 WRhzxdSzwQgBEhupuj8ThEuU9AFvbO0S2QJq4kTDBqKd/xvd/wsvR4/bigFDEpRfolB+8YuxGN6
 fxzCk/TC1kD6fThBipExOIXbeFdZTL4=
X-Authority-Analysis: v=2.4 cv=aaf0Dhot c=1 sm=1 tr=0 ts=6aef3c30 cx=c_pps
 a=SvXgiSASQu/JPdBzctYFLA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=UxwojoEslEplIN4H4qAA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX7aPcQL04O/CY
 LBEn9/g4gS/C9o9LweMTbXF7x5UQG/8ZZ4IWI/0nqo5mcgI0bo67fXLktWS/0iCXlmXU2Ug3Nrt
 beBzKckwH0tqcfoQ8G8+Kuaoe8aEZwvjIOtGgUcFjzu4bwU7Q6CWiljYvtZKVX9CWWyTO8Upyxx
 CXZKgt3RDDx3cjVYjkvnFV15JcSJeZDH6AtJJR8/35pJ6evcaN0of4cMgKCiZWQwq099/VdDS7Q
 GIY8P1srXdU6ux2nMELxT4PLn3KTLo0FJNFZqKJ0181uYu9M4Vg3LtmlCa8fWufrgBMiCbTaWqs
 DnXdBS/+/jPDQoXIPShBzf0FbkyZD7U/g3N4DlzRybHx0Lv5MUuF/3MZ+Jb2sKmmKXJpe5sL5OK
 Qq08RrDKjcHfBTK0vfTMDHZCPQkJ+fR/m/Qs6f0GWa/LGHfAMqCplzrUKIA5MjVMX6k/lAmC1D0
 kbVOGzxO9SNf6qzK1yw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611070059

This series fixes a handful of independent and mostly benign till now
issues in the DTHEv2 driver which were flagged by bots and AI agents.
Except for the fifth patch in this series which was found in an
internal testing.

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

