Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771212;
	b=4l/Lx7f81+Q0c/klKbLrgLejtsOwSQ2ID/lXAklyUEhylEtIdyJnmIwGGiEJmHe5+SYg
	 6GEigIQF1o3yMmFpk3LxNfxDjXhTun4+Bag8ccA7Sk9iB37AKkpPBqjKmhENHGoUpIKkZ
	 qhtw2EuvFB3xNNm/CZhnFzj8YbgCwU8SzraU8n2SE7KPlUgrEkFybBOkuKTlYa4zQ2SmJ
	 0HTjAze6J3Osm091Zba/rRxufN6DelJgLWEipQ8GYlQMuM+GEXhaiS+P2EODhSq/kqaYb
	 AdLmxoIWvBYggmYEOugfYvRSzxo1z9pYoIQc1M+JFYLg6Sidlc+c18cf8Ycy/ISFZqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771212;
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
	bh=ZQaCGParA2zMdsGJbHid+TrrK4lTnE/Vs6WCGdPPHOU=;
	b=LVbGRo7ez38UgpzScicCxXP4Ck5OBFpd5/hpQPdbBBiuEbokhw+FisCWy6qaekHHKNiX
	 IJxg74/AqmCqdb4UNd59zHvkZJwq8BQUlBaNSwp6XFvnD69pGxxvVBkMFsmPDkFW1AEc6
	 pB5SdN6zyrUQ/HW/eXfRmGe/b8VYvsK7kkzbHKKQekl5UX5CFAncm6E5OZxzucnaHUSR3
	 sUtttOs/mn3ct+ZU0FE8GhwPnghbH0V45nIW23gdEHjimjymFjI6NF1VoxnWoI65iyQb5
	 iTniSubY6E9dbi3Yj0Y8QfnYTiePJpAwcRQd56IX+13n4Lve6lD9ofv9Ter5uur+p9w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=DupiMWtZ;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=ayMripNZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D2F606D801;
	Wed,  4 Nov 2026 05:46:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95D2F606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=DupiMWtZ;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=ayMripNZ
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A45i2ng771707;
	Tue, 3 Nov 2026 23:46:48 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ZQaCGParA2zMdsGJbHid+TrrK4lTnE/Vs6WCGdPPH
	OU=; b=DupiMWtZTmXgZ34iNRJBTFrMSjjwPXCTh54vawL6RasWj2kTD5l4LGdA9
	WdABSlUDNXY5I0zQe9SvHeG0RZNpcBJGOEOSgpqQ9fNiqDlmxncm8ZiUiAwaPlwq
	crrp4JSC30aWIzl9zXWKIyDmfH2Y23SP0ahxHk/4QtyIgPtIXCzZkgHsbQTieMGM
	A1ZYWS4AnIW1R+a7BBPvlZw3d1cqKEzTGmVH4PaaPiw1meTepT8rMHukFedvMD1b
	Sg0nbSTOCKqmqMtqbKICo6QFA2c8SNXHZBtJMDn2gLqOFGwMBuGlw8FPkC+EiYSS
	zGyqt3RLf5RmHMvwki+83tVA6GTgw==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012026.outbound.protection.outlook.com [52.101.43.26])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hqqra25sr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:47 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AprP+lHdlecZB8Q7Vc5zqgwDAFuGC9dcvHsc3xWqNnWiYf4MFhl0oy5/FiuRAg/NK0ElOSQtsGD3bWcuCK+cAAfx0IPgxl//nb42qPl6xMiFgQJi03qMVHjG5G2OiRqq1JuYWnNsk+SUsGthP6J1SQ1xxY96yOTq2p8bdcdMDP13ovbSZcym8a9rQVWFEhxodLqOOuL/QR1h9la0/EuHnzgsSeN0gaz6PhaJywnClNW1kbWpZRF2Ud7JURe4km7kjxnqG5qPbDBsRH6peyMqx9WyfidbJzuchM9LHrlvoBOzls5rgF6f6g0PyD4bteyP2gMM1vefSHrLOjMsk6B2uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQaCGParA2zMdsGJbHid+TrrK4lTnE/Vs6WCGdPPHOU=;
 b=qfkANS/0yK/u9Ma/OANrsiedDKdz+ifMecCAISv5kztaLm8KipqyfyWW2NbQyX68IdInr1Hvp05qRXiMjgrguMG/9xDnpekPUHmqcrU79i5llUFVl3zaI5aIO6LqIA2OKG94U2QED7+IuF06gDmANpKoWQC4OYhroLbrEbJNSIIW+UcuggyxODVmqX0Ut95Hx02IWwkWOSw9+haTcuQ08yEnq0sFzsHSCZXYzieeX7oISOqlgmNkXEKRwTZjVWE/D+SNQZ/mKT8N5dTGATzck+z6J4/x/mu0pKqt9D03vHJys1VB8ujZG/I+Lp11Pk6NtOr60oQRIKrgroSnStSHTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQaCGParA2zMdsGJbHid+TrrK4lTnE/Vs6WCGdPPHOU=;
 b=ayMripNZScazXWNKZh5/eeAOGcOSLuqsrsPUSgEOpc8rySagSNc+CKb4ytMynBq9vZLpjxLh/Nl33zt4b1tsoRrdSJBjthI7hl84zSImfRW1en7F+GvdLOIE9HnWOKw6Ah9H+Jpl+MepCDOtFUqWcsLQc0TV5ysJ0pdDU7zr/Eg=
Received: from SJ0PR13CA0208.namprd13.prod.outlook.com (2603:10b6:a03:2c3::33)
 by SJ0PR10MB6400.namprd10.prod.outlook.com (2603:10b6:a03:44c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 05:46:39 +0000
Received: from CO1PEPF0001886A.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::93) by SJ0PR13CA0208.outlook.office365.com
 (2603:10b6:a03:2c3::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Wed, 4
 Nov 2026 05:46:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CO1PEPF0001886A.mail.protection.outlook.com (10.167.249.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:38 +0000
Received: from DFLE206.ent.ti.com (10.64.6.64) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:50 -0600
Received: from DFLE202.ent.ti.com (10.64.6.60) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:50 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:50 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ08521920;
	Tue, 3 Nov 2026 23:45:47 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:34 +0530
Subject: [PATCH v2 24/30] crypto: sa2ul - calculate DMA metadata length
 from the command label
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-24-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=4830;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=PnI2+bOeoQlMU1vZEUOfTMPaw2uM3bEnRee9emXpEoc=;
 b=qkbxJFp2XwiBM79EEEULwIdhx7D5kyQqAEBjHeU7gbnp/RY8X6E+DE/hP1FhBrVewfXhP0qkf
 9LTtCvjQvmkCVepMQDaqyj5HbPdBtI2OFCJjAVemcY3Ea69hN4k6gjv
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF0001886A:EE_|SJ0PR10MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: 14f1b2c4-da77-4cd7-c8a1-08df3a36fea3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|23010399003|10067099003|18002099003|22082099003|3023799007|261022105027099003|261021121427099003|261021123027099003|261102123227099003|56012099006|261026140227099003|261009223027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	J44JkZ9LWNr67n8lUsPeBqZJ4mHT3dvVtphNZb4+3j7hgUhGPklMBEZJR82zSZmY6NdbUwD0iaSaUxSHyHZXqODZEfT+tbrjgDXlKRxMLqZ2PD78+XPJ43ULaUqIEW4jpASn+1oQU+tk8TYlBYlacxWxA0HPSp4Mb7PiqdMQAvQrPwGChocTqAtAdStCdtzn2dRfCnipudIW49ZCAWmfquZNZbepPRfbMsp27TLCHyGFBHUOFPAdzPrn/4ma07CAxKzm5KRznL0oY4djsLNiOTcxfVJqeRQzpL/wCHNm6SPfuccQsA0zJh+xGiNZ2xIO7DWxOUq20gSZBC5Ewt/+UVGszXz2XOAsejELp8Z/1GJ6EYDeDRpvboMg5VdsuUH9AgaGFmqrm53L+pjqrwHmUrCrNxjt+zpYRRH/FPm+XLy0sv1HfCTo9QiELAd72zmX4RcebveomsMvlCUKaXLtnwMQJl/jjO4efxtAihiEdSzSGs6HgBGliiw1zBUfkc4kcuASntPJrNsQgSPGqdNbIygppCvDvzWwcNne97llsz+G2jeaMDeP/slXiNqxWN8Sy71UUslY44spzPBY6MzS6F/L28xfseYzCwORyyIjJMZ5n3OQMj669aKHh9+0iCSIsKJ6MH5ing5hl/aUmJrGMFwv415Sl1HpfP8kgmZwGxzJ3p9oddy2W6qeYma3bIl5jBkND17rMafQWq2eyy8lbQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(23010399003)(10067099003)(18002099003)(22082099003)(3023799007)(261022105027099003)(261021121427099003)(261021123027099003)(261102123227099003)(56012099006)(261026140227099003)(261009223027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OwuaerB9jI0CSR8s6BChDcc6aiaEr7290XhLa7+fC4DoCfsyVCv71oC/MNeyuCCIrWbsHT1STeZRu+t7sgSoeeNHLhBCp6tV3fiUzZwAlSdPKGWHMQJ5PicnydHv3j8azwrOWBzDHYrTIcztsqtqnH+t6fGYL/Yzp9furaZOpoOME71gVOwTVfjsuuyB9Lp0qu0jmBu9sNEeLkyN6+uI6lxwlgySwmc0lUVo1JqanIz4uPWCpl4IjG4GHg46VYvnSvPI78rXtb8QlMFP7wqK14IiCnsKCNneAWoqWIEFlOEx0iGoCR5Yq2j6V6vYhMw6Mxty8SjDgYHe+2s+/ZEC7pBJSnnYZGnOHG76RcaVHcgTVuNtjCQGwkvMdrAoVtoabb6zGDvOzgazDfW3WkfTgImvbtCzg5NY3+EM5gaIRLo88LFZ3ThjafN/NOGpKHni
X-Exchange-RoutingPolicyChecked:
	zoIDABynHUWGjWkITQoIRglpmJX779T4sbX3IO6C/+P2cPuH+yICLvgTcUYQLiM3k7BLM4vpKxOEvbmairY1RmDgF1Hpo2SgvrvOEqY84yyekcr9rkweN3RGO/e3mmPZi9QRFP+NlH5I4lvtnr4oRIN7pxSAaEHb4zcpccmHsBfzd2j9riym2qCVR40oGFXDNd7fQUjlZrAfaKQKmjgTv9Uc2PoZHhPvXpYTPEIi9pwbkEQVb5AaDuRPnjUUQWXPVLiv7FFGcJ5gKCbLr5odR3nIIsH3kIT33NJ5BhwUfiLeEJx9E0M1lKwXA+qDBmVMpmQdy0vgxHsS0Hk8C9JPbg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:38.3419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f1b2c4-da77-4cd7-c8a1-08df3a36fea3
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF0001886A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6400
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX1mqSJdFZLHLG
 cuPQ/hl4gJD72tQ0Lz59iVr6ZqPIrQ9CWyZYeiew3+LLGcyhzcK+IJV1ZIuNNkpADVVRIBkeb+j
 5HkxorDgQAdJlqJ3IOr2ZNB9lH+R/xM=
X-Authority-Analysis: v=2.4 cv=F9TC5ahN c=1 sm=1 tr=0 ts=6aeac6c7 cx=c_pps
 a=KbXMGX1SJVu0lhZGOc8PIA==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=iV7YQO2jEIXJtVvt9CkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXzTFDrzMOrhBr
 G8fcy/3J+YX5xopMk51mch0TQi8TjYRdxIoMD9Elr+T14MNu5n8o2RC3IDG545rm1/r04op5vQX
 5z93JllfJBhfuU1EqI9eQ+o3EeO4ttfFVBiijPwUIxUOg6FWJvhxHzUymMzRAEvZkILHqR15tBY
 DqRTQXoLOSIuZAPTieXpqODaZSk4o5lsGkk1xEdmaxCKCNOnxjHLzQIH5unXrZ2UoVBhTh8577k
 PxqhzYWujiIatLms4rW0ksjzgcovcnmFv4YI6F4xkBfg7bLdTIxHub2+Pob1V9nN/+2chNkj24B
 hcKQCmrJKlmmpzuN30giKJhlcVg5PyxasP0GFKIZ8d00+2G4cV2qhL+fFBdKqMs6TYYmecOYAsA
 rFH6B/oMvDKHWSngRcrO+NzQ6LIkTBfOxW2t09dxysBQJx8H+ay4e9bOjl/37qnDUJ7ZdPkmtH9
 fBGiKnORCuIFM27ZPoA==
X-Proofpoint-ORIG-GUID: xac2LJ1eNVhZUT4OyT9wSPAHzWXjwySK
X-Proofpoint-GUID: xac2LJ1eNVhZUT4OyT9wSPAHzWXjwySK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

Request type and subtype are software bookkeeping, not command-label
data. Remove that trailer and calculate the DMA metadata length from
the EPIB, protocol-specific header and actual command-label size.

With those extra bytes no longer sent through DMA, update the 3DES
IV index from 6 to 4 to match the new offsets.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 25 +++++++------------------
 drivers/crypto/sa2ul.h | 23 +----------------------
 2 files changed, 8 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 18a69c890ee2..e34c52de5ec4 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -905,7 +905,7 @@ static int sa_3des_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	ad.mci_enc = mci_cbc_3des_enc_array;
 	ad.mci_dec = mci_cbc_3des_dec_array;
-	ad.iv_idx = 6;
+	ad.iv_idx = 4;
 	ad.iv_out_size = 8;
 
 	return sa_cipher_setkey(tfm, key, keylen, &ad);
@@ -980,7 +980,7 @@ static void sa_aes_dma_in_callback(void *data,
 	skcipher_request_complete(req, err);
 }
 
-static void
+static int
 sa_prepare_tx_desc(u32 *mdptr, u32 pslen, u32 *psdata, u32 epiblen, u32 *epib)
 {
 	u32 *out, *in;
@@ -993,6 +993,8 @@ sa_prepare_tx_desc(u32 *mdptr, u32 pslen, u32 *psdata, u32 epiblen, u32 *epib)
 	for (out = &mdptr[5], in = psdata, i = 0;
 	     i < pslen / sizeof(u32); i++)
 		*out++ = *in++;
+
+	return epiblen + sizeof(u32) + pslen;
 }
 
 static int sa_run(struct sa_req *req)
@@ -1054,16 +1056,6 @@ static int sa_run(struct sa_req *req)
 
 	sa_update_cmdl(req, cmdl, &cmdl_upd_info);
 
-	if (req->type != CRYPTO_ALG_TYPE_AHASH) {
-		if (req->enc)
-			req->type |=
-				(SA_REQ_SUBTYPE_ENC << SA_REQ_SUBTYPE_SHIFT);
-		else
-			req->type |=
-				(SA_REQ_SUBTYPE_DEC << SA_REQ_SUBTYPE_SHIFT);
-	}
-
-	cmdl[sa_ctx->cmdl_size / sizeof(u32)] = req->type;
 
 	/*
 	 * Map the packets, first we check if the data fits into a single
@@ -1200,9 +1192,9 @@ static int sa_run(struct sa_req *req)
 	 */
 	mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(tx_out, &pl, &ml);
 
-	sa_prepare_tx_desc(mdptr, (sa_ctx->cmdl_size + (SA_PSDATA_CTX_WORDS *
-				   sizeof(u32))), cmdl, sizeof(sa_ctx->epib),
-			   sa_ctx->epib);
+	req->mdata_size = sa_prepare_tx_desc(mdptr, cmdl_size,
+					     cmdl, sizeof(sa_ctx->epib),
+					     sa_ctx->epib);
 
 	dmaengine_desc_set_metadata_len(tx_out, req->mdata_size);
 
@@ -1259,7 +1251,6 @@ static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
 	sa_req.type = CRYPTO_ALG_TYPE_SKCIPHER;
 	sa_req.enc = enc;
 	sa_req.callback = sa_aes_dma_in_callback;
-	sa_req.mdata_size = 44;
 	sa_req.base = &req->base;
 	sa_req.ctx = ctx;
 
@@ -1364,7 +1355,6 @@ static int sa_sha_run(struct ahash_request *req)
 	sa_req.enc = true;
 	sa_req.type = CRYPTO_ALG_TYPE_AHASH;
 	sa_req.callback = sa_sha_dma_in_callback;
-	sa_req.mdata_size = 28;
 	sa_req.ctx = ctx;
 	sa_req.base = &req->base;
 
@@ -1841,7 +1831,6 @@ static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
 	sa_req.type = CRYPTO_ALG_TYPE_AEAD;
 	sa_req.enc = enc;
 	sa_req.callback = sa_aead_dma_in_callback;
-	sa_req.mdata_size = 52;
 	sa_req.base = &req->base;
 	sa_req.ctx = ctx;
 	sa_req.src = req->src;
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index ea86199b6231..67bc722a1170 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -31,22 +31,9 @@ struct sa_tfm_ctx;
 #define SA_EEC_CPPI_PORT_IN_EN		0x00000200
 #define SA_EEC_CPPI_PORT_OUT_EN		0x00000800
 
-/*
- * Encoding used to identify the typo of crypto operation
- * performed on the packet when the packet is returned
- * by SA
- */
-#define SA_REQ_SUBTYPE_ENC	0x0001
-#define SA_REQ_SUBTYPE_DEC	0x0002
-#define SA_REQ_SUBTYPE_SHIFT	16
-#define SA_REQ_SUBTYPE_MASK	0xffff
-
 /* Number of 32 bit words in EPIB  */
 #define SA_DMA_NUM_EPIB_WORDS   4
 
-/* Number of 32 bit words in PS data  */
-#define SA_DMA_NUM_PS_WORDS     16
-
 /*
  * Maximum number of simultaeneous security contexts
  * supported by the driver
@@ -216,16 +203,8 @@ struct sa_cmdl_upd_info {
 	struct sa_cmdl_param_info	auth_offset;
 };
 
-/*
- * Number of 32bit words appended after the command label
- * in PSDATA to identify the crypto request context.
- * word-0: Request type
- * word-1: pointer to request
- */
-#define SA_PSDATA_CTX_WORDS 4
-
 /* Maximum size of Command label in 32 words */
-#define SA_MAX_CMDL_WORDS (SA_DMA_NUM_PS_WORDS - SA_PSDATA_CTX_WORDS)
+#define SA_MAX_CMDL_WORDS 24
 
 /**
  * struct sa_ctx_info: SA context information

-- 
2.43.0

