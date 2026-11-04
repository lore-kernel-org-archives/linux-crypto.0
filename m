Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771145;
	b=U7GjoD/ZXGK/tT/5d2HCw4crAhS4dI1/JDAht9DAxZPl1inrGMRuBhC0IwCdZSlnHAaD
	 GOoCWg/4eTgt+h5F9bQUAZEVAZaDlUm9sU4JYHut+RVOUv5MVTWiMCL281L4PJtoNt9Vg
	 +stKi0qYzoRg1tpR3GMyuptDdXBtsVcLhYHkx8uDLw+QsDl6GZI3O6aPftUvXqtVnXpGG
	 XfbT4xueUbJ0+p/LxT9C4pqrLgApkeUGE/S0DsvXC3pWVk7JmTamLgCFVGVSS4eUNWgbK
	 pv1tR5B0dDXGwZ1WXwJ0lpZzw6esDN65nnwxssFE7LALWwGj7NlcXy0JgcZHfkGpJ8Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771145;
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
	bh=LKWqu1K6wJh9tC1eLnIKS9niMoSOLaAcf08wS3D1aqM=;
	b=0JcfYoErrk5NhJW8p/R5s95kJtdLhCMksdM44YYLvI15emqj+1SjfpCctrnWPn+0QpzN
	 Ilol8z8+q2oPt9Prn2771UlYy77mTJPW6cpNGEJ75pB48BZ42CUP3qf3dxb4R20MHgQy4
	 u8NGeyr/57OV7IJZGfvXarFmRONIXC25gAK3wCNpp6oueZHw7C/9uY8o4IniNAZDHtoUt
	 iHNcN9zxI1TDIqxPFO4NeoM6nB5SaDrWPeWNcCo3W1GywDehu42hAn4TXKnPVYlJ3FFXI
	 hYnqwmfprFqqgkt6zEZp55BPzVD682g4hrzJVFrropj8uzBkbZX1EdpHF/0OKTWsGVA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=J4VxNtlm;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=TBLltFuY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DFE606A330;
	Wed,  4 Nov 2026 05:45:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02DFE606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=J4VxNtlm;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=TBLltFuY
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A42TOFv601514;
	Tue, 3 Nov 2026 23:45:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=LKWqu1K6wJh9tC1eLnIKS9niMoSOLaAcf08wS3D1a
	qM=; b=J4VxNtlmTJ9FKqM3ucj3a+eXnKZVjCD2iDyJkUd3cT4EZuqeIeTpI02tV
	soGzwd4jFr5h/97Ruvdx+NbeUM6miTMIlE/JrRJiilPi8X29Eq1orKfMtqtrpOfW
	BoWFuOGnl3oybU/khXL46ow7hibHGvGBcKbyGkMHDC3c7b8/rDpL6ZApB4Fei+3m
	Y7ULn9QfvhVs7QCcp0jIg1VQ25X0ZqQoDCgTRUcYiAK5n8ji5mslJ86zbHJemSZm
	7vI3jm0ymvd+Vibp5ooSeuIez6rk5DTe/mkmSSswB9HdYH3CaXpBEvinefNn2tTW
	8gK2dRJ5o0kdPr7oPFS60TSmzXlYA==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013017.outbound.protection.outlook.com [40.107.201.17])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hquyf0tng-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:45:39 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gW5OalNZvLVi/zMKpDkz6XLmYAWznbS/2OQuMbgz8HwHasSLujlJUP8nqw/0aBIbc01D2gezEJQtdawVLWg63RtABg0BCkSc98M9lz8KgogXqTrG84d8WjoTjcXhhzKqJFesKVeQUhKzmjVgtQvNTp1gMOKYZEYkW9N3MSv2NJ+Vi2GY/0go5mcTyb7nkvZ/YWA7h/KUOZ0f8yCkuUudztCMDkUCnC9aNSJR5CcZB5+YiFMYzVq69jUPnOxd8+6YpLZAPWdQUDSacnwTB0zxAuL84yK6eXcwWxLlV9w787R9nmh1/b1qVQS0t6ND4JACsSF3LEKivLxwImq31z4ipg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKWqu1K6wJh9tC1eLnIKS9niMoSOLaAcf08wS3D1aqM=;
 b=fP/+MDScc6b7TXavyHObGz7uTkGYEwinJlAgYsULm3G5wew9582a04X7PQZoU5XycmTX727bDlesDhuIYYLKsGna3PR8s+DdrpfIV/Geo6pd0lHlQAvoQtkXpB5syLoVR1Ig+gM/ihJ4AyAapMip4ezF8vggCYuUxwL3VmnC+NubZ4PtJGxXHtztinhh0eJbwOMVnfhZEWDUJjLx9vVC3Gu4bxmlv+jDpZ1+HRe8LplacFM/BihjXCCegIZAAUot0XdVHcMU3FfU1X5h/PFASRkeTM+m9HNv7bKyckg06YVWbC+GYbmVNda6se7RGB4UQitz5p4Dwe1F/6OfbSCgeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKWqu1K6wJh9tC1eLnIKS9niMoSOLaAcf08wS3D1aqM=;
 b=TBLltFuYNPs5Qc6a8gRbpDZK9/aYOVlT6lYBYHUJG1f7jsCvJvT+o9/Ytp+vbM7ZrRDdcxz1nLJTkuqKbVyGIxvjagiAMQF6cfzjT62BwiB41hHkvDpXFOKddL1glTXvFYcSPYuyrZRcaqY871woVH4JCFn+xcdL3vbZ9wl7Qng=
Received: from SJ0PR03CA0013.namprd03.prod.outlook.com (2603:10b6:a03:33a::18)
 by SJ0PR10MB5858.namprd10.prod.outlook.com (2603:10b6:a03:421::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:45:33 +0000
Received: from MWH0EPF000A6731.namprd04.prod.outlook.com
 (2603:10b6:a03:33a:cafe::18) by SJ0PR03CA0013.outlook.office365.com
 (2603:10b6:a03:33a::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Wed, 4
 Nov 2026 05:45:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 MWH0EPF000A6731.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:45:32 +0000
Received: from DLEE205.ent.ti.com (157.170.170.85) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:12 -0600
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:12 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:12 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxv521920;
	Tue, 3 Nov 2026 23:45:08 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:23 +0530
Subject: [PATCH v2 13/30] crypto: sa2ul - preserve full authentication key
 lengths
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-13-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=1913;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=X5OM2MVBLjSzICra0RGvfcJoKE4WjC4Q+nJN+ISH86M=;
 b=+lkKNXBHkETs98UVUe5UN6Bbn7eP+yxcOJTjaLUZ5Hxs5BVWXH2jF+6qJ5pbaUbXO/NdreFBK
 RMugXL+UAC6DfsFpV6lT6F9c3+ywTldsbYE5y0IEDUZ48z7zZNMu6XJ
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6731:EE_|SJ0PR10MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e8a798e-3341-4106-4080-08df3a36d729
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|82310400026|56012099006|261021123027099003|261028144727099003|261022105027099003|261021121427099003|261022075727099003|261026140227099003|10067099003|261102123227099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ZiNHpZO39rhaz1FfLUH/3NhG67NhPyjRI8XzzJZqOuOBaCZdBzKex10v4ojsHzfXyi1juvIj80LZml2sjjL9ZYDNArC424jhVsiCXy/mg2C5K/97JeTNaXKmsQM8zdAZokP5eMWait/XbWkIAWzhoESEqmcl10xGcfr9jilrQ4u/6r8X0tBaKii8NmMMuGj7w3pNZZ5oP58LEW4iDTnGWwZJKGgN5/ZyXXHeuKdzPk8JMadXncDfClmYYRjo568QI7onD5trxUSw5Dl7esXu0IYp8bjVn/+WOlkoskFKNiXXRZJpvcury3TwyS/KwLHC8//c/Ly6jsSHJy9UThYwEGVoABE1iB2aY3WtIVvJXfsT/HnrNdq0kwQf2HGEojuHAIYWHROXD0vl1ZLq+MAeZNmP5vex1fsdDo+mLytCYkq9SDmCPhdj1jHfzJqAAVUHAZ0fPZlNGHqF0TBiPMWTk99vOiGykiq5kG4zqh7khmgENWbs16G4HUP9P7VaVsxypG2j/Ee2D5zg37YFFixd2IEd0sb0gaeVM+888UMBpVFmX5tvsrTkyopLnsQCxeJgMFNB4nCTCp1fm4Of/0vDy2BTGC5gSxPm9OTCLOHu6bv8Am8Iw3/UJ6td8ypMp4QfdfOFaS9hbFaAr+Q2faQd2iSehhtxS7pc13v6fCrzE8IO6zfVivY23WqT8UXUjcsT9HtNg8rsk1vT0RKVshWjhg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(82310400026)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261021121427099003)(261022075727099003)(261026140227099003)(10067099003)(261102123227099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qNSlPZ2MNYU37DfcM82R4IXCa+KSonW4rxwXZLqyru0aYQZdMgt11FSmyL6YYPiqWQJM+FXyBiEKju4hOr+6bbRGSECgRJdjaKlIk/GW2J+yy96/AKswOQWj3gPXAXwC00So6ISYO9Ep92mZJG2vZChiHt1Qg/Jgbyy+OvOFyK1HlBNDzrMZf3UFs6AT4Rpy0rwJMwX0oudv/F11lqtUPkaviSXKrUpkgHC/jFmjUzw/xNkEz2h+4ZE+UzcZMVGLLzd5Hr3WGlAQR8QcLREli6f6z4P7b0gyXsPe7yqlbUnhlb2zyFCB4KHK8XH3fB1bMC1k8u+2CrX14ZTMg+p4X4m/VzRWGCVqK/6A090l7nx3dCxShCDSQGjII5az/5YbkbAZkkHpa/Mc2sRgzYH/WdIUMV+Rajb6L750KSxtlHh3C9bqmlC0xKeSU4xMoQYR
X-Exchange-RoutingPolicyChecked:
	NYcGs+7JMGZfxvrIOvpIjO4s2wfRFDs7n36KbqT06TWBkytyxZqHRlIhhXsVy1B1BAlVVpE2Bv5UX9XtFryznKvKK7Vl7jYNbel/HquE64yJUB17ZWWsbRA2BAgpfZv6eRKd9AETt2g2Hw7RSPriRcq6ILLdLxpOY8LQfr4FAbgWykJlMx21LiKZokaPn3Je4spCDkGBdrjQqYAODQXuLVxEMjHo2pl1lJ6w5W1RI/ZatfA4ZrulL/n/Lya9kZ7IeOpBssUFRG+5psSJkSF8P9opv+eVNk23+aS9RIZAoVCLOWIDKgKIYHS+YtTeY37/xN1x8mEnRSkC1d+JeX45Hw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:45:32.1001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e8a798e-3341-4106-4080-08df3a36d729
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6731.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5858
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX8DlE3YpG/AW0
 yAl3tDqsnmj2/gH8W302FMyxLeQD8R/o9iZa8rETizy9zhT/XHyEFsVe/f8g84nXrRQ0YzJ+Nh4
 F+QLDgomqQhdCoK7DARO1N2yiD1rfvxxv6T1rGFXUZkn6H7B/YF2d9xNzXDy8oaoJvlF+XRRcNb
 FO6szOL2U5xvNx8wVgjQhM7CMWZU4/6IKhMNm3NPqgEcm33w2JkKDXdGmDes25OYYqNkWvExttX
 Mg/tNPx5xF+4NMz7vRZV0OAURdRzuq5q2547WeC7nj1exRah8Mb9LTI4/Ve3ZaehB98s+kCnUdL
 SL/qEV+DTNSULxANmAh/AyyZmhbhF9p5LEM24CM746hfW/zQQj912GoYbGkOGCW0phx4Jo/Sjzg
 uDHhRskMZmRzpfQYrgcTwZCpg+rCPPHg9wyVVxrzgyfHbSzVNHRzkK28Zb5fc85pk3kpHtK6lKA
 OdUNu20XVLUukSSIJtQ==
X-Proofpoint-GUID: 1yj4iSPVJyfqg1SEelXr3IF5isPLQrdK
X-Proofpoint-ORIG-GUID: 1yj4iSPVJyfqg1SEelXr3IF5isPLQrdK
X-Authority-Analysis: v=2.4 cv=MpzHeGae c=1 sm=1 tr=0 ts=6aeac683 cx=c_pps
 a=XX75RHJXRTy/mnnqXKIK7Q==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8
 a=veDwBS7oRki6qJhGZCEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX8CgTiqR0QS03
 KCifvXFxMP+sQsU4ynHl22PWo2J5QrJosd13H8/vqcMvMHL//sVgq0WfEVvAHP+1O215EZfPr9G
 APcMwyTi53kU1AdZY5xNFIv3Yt77FHk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

Authentication keys come from the Crypto API with an unsigned-int length,
but narrowing that length to u16 before HMAC preparation silently changes
keys longer than 65535 bytes. Carry the full length through security
context setup and ipad/opad preparation so long keys are hashed intact.

Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 23a821de46cd..3c25c98e3e92 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -356,8 +356,8 @@ static void sa_swiz_128(u8 *in, u16 len)
 	}
 }
 
-static void sa_prepare_iopads(struct algo_data *data, const u8 *key, u16 key_sz,
-			      __be32 *ipad, __be32 *opad)
+static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
+			      unsigned int key_sz, __be32 *ipad, __be32 *opad)
 {
 	union {
 		struct hmac_sha1_key sha1;
@@ -455,8 +455,8 @@ static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
 }
 
 /* Set Security context for the authentication engine */
-static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
-			   u8 *sc_buf)
+static void sa_set_sc_auth(struct algo_data *ad, const u8 *key,
+			   unsigned int key_sz, u8 *sc_buf)
 {
 	__be32 *ipad = (void *)(sc_buf + 32);
 	__be32 *opad = (void *)(sc_buf + 64);
@@ -619,7 +619,7 @@ static void sa_dump_sc(u8 *buf, dma_addr_t dma_addr)
 static
 int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 	       const u8 *enc_key, u16 enc_key_sz,
-	       const u8 *auth_key, u16 auth_key_sz,
+	       const u8 *auth_key, unsigned int auth_key_sz,
 	       struct algo_data *ad, u8 enc, u32 *swinfo)
 {
 	int enc_sc_offset = 0;

-- 
2.43.0

