Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067647;
	b=zQY1bZR2K9cKN++iWc6sgkkjz+obCZ5yiQZXmMS7Sg0kEjvtkySqHVN8xOqmll9QuavZ
	 nhsAFrLJpFZjq+7zImoSHFY6inStBXa6QNZPMQaYhWrMnjItI24zRSRIByl2RL5uqFEkh
	 PcZQ+gSd3yz39/BBkV9yagGVDnWX+LL4Nw61DYMEAxLiUCJ3WUwmp/Blp1c/7L/KzvEW1
	 07nPh9XXITWiHl6gAObeLOAuUDgBvqtELTbrQqqxmQBTDgwM4VvJXvB2nn8qBhrwsFV7m
	 xb+7ctY9BiSY21kmXiAHRyFesMpaPQkoqFdeLe86P0y8hfPbXE5Se0h2MvwRznWwkhA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067647;
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
	bh=hc5rQFmgZIu2nYYv+qmWT4ckMpFthoMdaBzcgTssWY8=;
	b=jZWeim0uSiZ10tnmHiycDEcajCmNxwCx076fphXzY/QP3YYrRntKDSPykX7Sqz4Wqhvr
	 mno3SYIBqHSLKFQJqAgveGNPoMeO9++4f/KRwOXJCs9M/qrJj6Ycf4WZTv4GHlZ9OyXum
	 d55WVG8zyEoLHFo3xODwWYeE8zCiRr10qy4pkGDu8c6GMrkKWubY5ntJru29nc/gZw46f
	 5vliiYYiOl3nq1M3xStuVQNe0mozNrIOfYnD/jvY4QvDd6wNOUTpNzvZw74nnV60dxQzv
	 HRhZzyHoS1vR9nJESyep1jDelTHENyXzMU9TYQ8SWoa5WI3zBFczaTWKNlEXnp7qg4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=OtImdsn6;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=YjCou7Wl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E473C606A334;
	Sat,  7 Nov 2026 16:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E473C606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=OtImdsn6;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=YjCou7Wl
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A7ExxKR2608381;
	Sat, 7 Nov 2026 10:07:23 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=hc5rQFmgZIu2nYYv+qmWT4ckMpFthoMdaBzcgTssW
	Y8=; b=OtImdsn6Uh2yex8PkLNeB+thgwRNfhwlHh1V+wETb9e4q7VKME9Rzox7g
	jYYlf7d1ZmaDfGBRhIkWu2YgOvjcQ0sn4k+4Zj6jDNVW2vnZDGc2biyZq99QXi/9
	K5h+n7htCuSgBe6eTdDo6YWbtuxWmUpOjGA1PKmZUUaOy3sFQlbHqHkpcbIXvPnS
	Ck4iv6UVDXQ1beQlwA3XHVK/y6lXmpkqW4UpWImZyaUiv7GTIGC1wHLG5ZBVL88l
	Dc/qwFVwoEMqNNMDSfVWsdR7a73Mzilml5fOV2vDxOr94nOLjS7VBaf3fryf0v/0
	3tMUbLtXDE6XWk/1wveRrOl+/xKvg==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4ht0vrha23-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:23 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nzHhhOcxR+Om+F3uxLlvwI44KpFtZqa1Hl+yH6hl75FY+Cpfkn6XlNyGxgoHtpwnY5wAm6KbVKN3CcvMgD3AnRkvQj4B4o0o1oBChfDGDiYaEBib206fvJSooCNfWcPs0Ni9zTY1iav7YXemZKZVUC3pbJHybq2iNZVIkVNXAiv8KOjFsIaoSyJ+UAD3T+o89CSvWnSSQKl8Vw7nW922LuCC+l5E5HKHIcp5adwRT/Y9geXNKjVxSO7w7X+BLmimJeKF3g9NGhw1H/3OwM0mppbHwkL7R2e7CbV05kiBaUbVnRGpp6wASgZ+OB6jq18az5JsxyWDas0UdwgLPHR9Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hc5rQFmgZIu2nYYv+qmWT4ckMpFthoMdaBzcgTssWY8=;
 b=FyBOHfUjHRPFrXXDbhqUJTS9VGiBim9RtXiZ6nzDA0eSSQZKYdlF0r/I+8mcGs8hA89uy0eALtglZb3BzxobfAHvNusI+sHhUiYZvZvj7JVOIb0T9yiyMeMAytSI4hSGSFqkC6MRX+OtwImyhXcC5BAtWjoVTRhS+pRec+oG5c6cZ97NSheLkgQG2aNXOArWSytC2rH0L/9qzQayjSVXg4qpYKC77FBM6mJfIcQCoJkrDaNaOHkhsqtTV8RDB1S8wtLMsZRmELaFaEL4Urp/91mzpOBkcOMoRXCU3vARqB6RE7ixDr+vzXcSeTRUV9XsiuSi1p3+J/+LR3w/E1mXQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hc5rQFmgZIu2nYYv+qmWT4ckMpFthoMdaBzcgTssWY8=;
 b=YjCou7WlvWXY2/9dd0Jc5k4ja2OYquK85Ws6Oze4nDIV1Y5zvxVabbfUAC/d39Qhqor+w6szBj5VNEBdUrZIXeGTU4H7XKBCcUdWrxcKZCJZoKIm6hkQ33u4U+BbCnWSpTqTPV8vFMWV3vRBmBpPn0lEwiKjMy8AhdZPFGQoLzQ=
Received: from MN0P220CA0006.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::30)
 by SJ5PPFD020A49E6.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Sat, 7 Nov
 2026 16:07:19 +0000
Received: from MN7PEPF0000014F.namprd04.prod.outlook.com
 (2603:10b6:208:52e:cafe::9a) by MN0P220CA0006.outlook.office365.com
 (2603:10b6:208:52e::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 MN7PEPF0000014F.mail.protection.outlook.com (10.167.254.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:18 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:11 -0600
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:11 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:11 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G79VR3459964;
	Sat, 7 Nov 2026 10:07:10 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 09/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Sat, 7 Nov 2026 21:36:24 +0530
Message-ID: <20261107160631.2592763-10-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: MN7PEPF0000014F:EE_|SJ5PPFD020A49E6:EE_
X-MS-Office365-Filtering-Correlation-Id: bc599b99-cc06-44aa-55c3-08df3ce9328f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|56012099006|261022105027099003|261021121427099003|261102123227099003|261028144727099003|261009223027099003|261026140227099003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	9Jj+Cxpb22m/U3P55pOgLMNbdou5XmpQk9NORgx9hIgtAHuOKUj+vQpyM8E8nSA8xAmmBdACg4xfgaL39rh19Ka8HGunn/fo6m2+7fAWaEMR/Br6V8E+8H9tPHvR3UdE+WJ/xjbINA/+xnqU1N4CEyAkgWGkfxET9uXPlpFFvhQSVErMLO+oDrsxKr17KNwmxvE99rnPEz/oezRjrmTcODZe6Hzb6r6q2M2JYv+vGlprGgS7Sy9eR28RX3xIP63Tw6hacAI5Dq8gRJuP3mevhhjaQqJj+EBmLxmjlRZ1KXDMl3x1CCUw1a1ABnuX3F2r49KlNJm6w0E0B5Vmzqr7G5oe6gR/FbriZK6X5xKQvXVWYeMoZVESNR0QWE3jaKxfYEonocDvRjgC48ttmxsRy6NCG9nqMW6Wmy6s8Ib6fbGS/CYhU8emxxWS7qad/sJUF92JZmKVJgKv3XwboVy3Uan+t/MzNyX4BCZW8BU2W+owczlum7hyGqY8HYcpz9Gao33CXvlJeyK83GFw6gOByfVQn0mqn7207nwdht8jRQPI68gng4dmDyYAYSDLnEo6vCagLuuHHg4E6Lcco7pfnWGQTND7Abd17EQIEbxIOv8Rx+izkkmgdYft4qNytRKXM9x9WFYJ/vSYNSatVFsrwf4lEJiD3AWgYszOg+4HLpWTZfdU1yAZFrydfjg3xs7CsK6fG3/bn0oz0cy/cmlpcw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(56012099006)(261022105027099003)(261021121427099003)(261102123227099003)(261028144727099003)(261009223027099003)(261026140227099003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zTU9KqOeUrSoE0wUgEl0IHbebDOmqbVQFgJt1uGb0fkdUHb8jCQZ1I2f0vOCA446KkvefNJe1NLScQ4V8mPkG3r01NdxMPFl/bk4XELXmWkrrJYDukB1hExb6PJ+eZLlO7u25rUP8mwOwInCrFfxYGy1+0eR049rhloLl3bMgeWWuu/Hdzqs64rBySdIrECoEcu4bP9Ht16AgpWwFWaReCDZtu5qT68PDMKXNNbUpN8J9lMnRJd04yK9Oyzs4Ay7ZU5dzS17yHbyOHkU+qQ9eB09tJCoDHLhkCu16ukEHCDVU8OOCfQwndEBdBbpNcv9lz8QYrUOKJQCN3QRyzmJhff/Y2f0VT0lXQfG1A46Q8ja1TjG0RZRUVW6k5sZ0ir1B9NoNfnnIzQsU/8u+jW4p03YWddQxf/3dlA22wbyerXOu0QFpCWobIpSCdKckPdf
X-Exchange-RoutingPolicyChecked:
	MrruNwLyLcoN9sCpe1jRI7Uo7XLgETCivkwYNJMrV97XYisUqMbl2tF2W3WEVoBzFKO6ahEYb7hzl8Kjx+YIWxae1SddwPaVnjLkOSx28kQyUw3iWFFfSBNBjgvQLUcXmUgO0qwFdW1Dd4WYlm96kOTdLuzcageic54LElasO+v5UQGMongQviOZVmrNpazn2hL30jBegOg8EXeRH6d+fQapFI9N7g4dX+dBgMYypMcSiYVN77bQGljVXAYkr2SgQFQ2Ltw09gEgqMYOAY3dyxduYxssyUhKzECmCW2iuKKrdqdL2tHrfHnc7XmI0JNPryGaes9NcVDZHcHw6lK1tg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:18.2041
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc599b99-cc06-44aa-55c3-08df3ce9328f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF0000014F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD020A49E6
X-Proofpoint-ORIG-GUID: Kogp2gwt26jPjGJdAZ_JoaEj8l3UgfO5
X-Proofpoint-GUID: Kogp2gwt26jPjGJdAZ_JoaEj8l3UgfO5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfX3GXngzaCQaFz
 f5Qkd3cnrry67sXwHIJf1XWRKXte9bw54ANvR2Blzk0uNZX6sApYruD5Hj60NA+s/AJ1zycTvei
 xh7dJG+uqSfbtXhGLYOXTzcD37MTCDE=
X-Authority-Analysis: v=2.4 cv=aaf0Dhot c=1 sm=1 tr=0 ts=6aef4cbb cx=c_pps
 a=0vJwjWeN+wUybMchBBml3A==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2MyBTYWx0ZWRfXwuCdgZLn5QZJ
 n5JHE4Uu/TlrSc9LmNtuVsgG5GxPiyfoBgl974YbNBk3Cf3SS2dmiVGSssWN2bh3+kFFF3mW+2Q
 hMm9eK+nf8pxN9Jme1TjmnvRyM3eVDqnkAdf7uiUtNkqQKfYqFD5xGQgbCDGH+zyqmnqC9UVmjT
 X7cFlGHK3WMBv3njg1g/oitPXZHJoQOfQpUbVGciUswwLfTtbeLbyplsiRpwy1t3TtGh1RMbJ8o
 Zngg0yVKp+xu1PwKsAriNPBMwi8fpRUYqXxP525dbMxpiwvjFNBbAppdA7mLHb1UUpW62M4m1WC
 Zh/Pnc8Nojej+dC4Z1D0EwUrXz/j590mgihln0waKe3zu4kOs1tqoCyO1ncVnubirL5B6KDhdoE
 6IS+B80uRhkh62v2PjMw4aYtlvppANiUHDE5i9lcC7T3dIbNTIyjfMIo7W9pu4udPuZDdsDqPNG
 59SNKGdSTUN7LXTUL1g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611070063

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AEAD
driver.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index beaaca862f39d..38278ad42f904 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -643,6 +643,8 @@ static struct scatterlist *dthe_aead_prep_aad(struct scatterlist *sg,
 		return NULL;
 
 	aad_nents = sg_nents_for_len(sg, assoclen);
+	if (aad_nents < 0)
+		return ERR_PTR(aad_nents);
 	if (assoclen % AES_BLOCK_SIZE)
 		aad_nents++;
 
@@ -699,6 +701,10 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 		goto dthe_aead_prep_crypt_split_err;
 
 	crypt_nents = sg_nents_for_len(out_sg[0], cryptlen);
+	if (crypt_nents < 0) {
+		err = crypt_nents;
+		goto dthe_aead_prep_crypt_mem_err;
+	}
 	if (cryptlen % AES_BLOCK_SIZE)
 		crypt_nents++;
 
@@ -758,6 +764,8 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
 			     req->assoclen + req->cryptlen);
@@ -779,6 +787,8 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
 			   req->assoclen + req->cryptlen - ctx->authsize);
@@ -975,6 +985,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (assoclen != 0) {
 		/* Map AAD for TX only */
 		aad_nents = sg_nents_for_len(aad_sg, assoclen);
+		if (aad_nents < 0) {
+			ret = aad_nents;
+			goto aead_dma_map_aad_err;
+		}
 		aad_mapped_nents = dma_map_sg(tx_dev, aad_sg, aad_nents, aad_dir);
 		if (aad_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map AAD for TX\n");
@@ -996,6 +1010,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (cryptlen != 0) {
 		/* Map ciphertext src for TX (BIDIRECTIONAL if in-place) */
 		src_nents = sg_nents_for_len(src, cryptlen);
+		if (src_nents < 0) {
+			ret = src_nents;
+			goto aead_dma_prep_aad_err;
+		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
@@ -1016,6 +1034,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		/* Map ciphertext dst for RX (only if separate dst) */
 		if (diff_dst) {
 			dst_nents = sg_nents_for_len(dst, cryptlen);
+			if (dst_nents < 0) {
+				ret = dst_nents;
+				goto aead_dma_prep_src_err;
+			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
-- 
2.34.1

