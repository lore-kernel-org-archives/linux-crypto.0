Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063472;
	b=CJrVFMMHeWq4ZwxisucfnevXQk0BaRZTZlvw+SopQnsbQFR7PR3mcSg8uqRLcwhssX5z
	 7dMLmvzgBsJxBGKodQcWCG29byIVpmHVb7Q7mt/jNXwEqP+PgrPA52yF8Apn+vzgY1rR6
	 Q/8XhbXdmkdAt0AhPghshJuWfhHvOr8siwmpn2+8K82dKhwxIUVWWjR+q2k/0smgPhoaN
	 CjcwPrf2rF9Y3NDO2z34swxv8K7MY/mEm/lsZq49nhD95BtzlOkD8NeiH/2aFKBX7iqDw
	 USjJpNZsju13wUtd6XbtGzE0wma70n2WK94y6YLG10pTq0VZqY58EGW1oAXY/BN88Xw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063472;
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
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=bG0l8dY3L/Y3T0U95xEIVTtiM2vsKjF6GwWCC69EvjM=;
	b=w+6lvHj03Qf+fcmlLI0GYuxT/vxV99CoMfPJehXZMkQVvvQq09qQPGK8MRBKSw3j3hKk
	 cbixGn5l9//BAeOUp2kG5CrnVxXoTZpy8FXv7UaLiHHdpGwf9Cz8WrbhBkX+GHCxbPpKU
	 q7hsPD7L3liT/PdNSTYZlZlnKIcjO/j5q79NY+yZgeLDCbaP9gNI5GrDs83yHXduO8IBF
	 lNLMtYLVMW+tDPmxdPcsdbU/aR6W603VFQruXMVnRy/s95ShJ7BfOKjcuVcW8jEuxDrn3
	 by+AIhWFnk8gmLrTB1NjCuEI+o9nXT+oYVT8sV7tR81j8Qjy4Wcr/oFh7Myz8LVJQOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=gjlXaxGp;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=sBjgz5+r;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF59A60A6F61;
	Sat,  7 Nov 2026 14:57:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF59A60A6F61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=gjlXaxGp;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=sBjgz5+r
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7BwCll3545607;
	Sat, 7 Nov 2026 08:57:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=bG0l8dY3L/Y3T0U95xEIVTtiM2vsKjF6GwWCC69Ev
	jM=; b=gjlXaxGpSlMhQqGMlwUMGl63hwnR0nJQgEhq+IBgF+4PUEOG2LDMamsQF
	7kesuIkrHde2PjnwLDLZrMHIvtmJ4EHOl9g6u0eUAlQvCpnLD0R8KMqpBmQ9/rL8
	hczTbF2j8x55HNaV/Y3kAB9WrlRW7ZPGxsa5XAkXJ3XrwwfeRrQtY0bogEo+UQbn
	sOBR/KlqluytWUzWKsdKcCVOlmuPs8DZBYKdoU1hxLQfrYFLpHnsg8epJitzVkEY
	YORcikbN6sv1CPctLLGv1xQehEJcqFIqYsBeMi+vyUpwqhhNaEdkgJwy/1e29mD3
	E7dPqoi+C8jecWLQtQRUB5C1ELVyA==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013045.outbound.protection.outlook.com [40.93.201.45])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hs3qmhpq2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:49 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CySffcNSPEsPHrxW543UKX91sker49azRQOnNysonFs6WcTo4MRMCPlHGAb3UXY7zGilUCmsYMzhcr8AoE2J9qu5f0f8D+9gEgRX8avg0ws8oNCA1Cj/d4OFIU3JG7A/d1F/xgI02HIdXBLm+6PmOHt4d9rYSIVevhFjphExTsS2rP4PdnMrj1Q70tM7GuQeZjfDFAY9E5Jl9Pi7SrFeAzER0kkJJbuJO3o5J3iZfkyOoIop6lZMgXPir2oP6jPQEKjNWNHZtEU5bhbYFEp05iIul3tqqdsgwY/g9CIEk+UhQtkK1lvwvzidUiVwIFxR77Q4rIuKZz/rUAEvV03ajw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bG0l8dY3L/Y3T0U95xEIVTtiM2vsKjF6GwWCC69EvjM=;
 b=NighELyKWzKVndT7SrelqeZIRpxeye4BVOvuNQJTs9ewZj2slN5/NJZn+skAzN9donqo2gyhMAzdzcjJaT9Tdig1y5yCaA0f7Z7GhlgMdNwPymhhAk1NHcmbJ43txdU9CofMAhxkxaWZ0epX+OAKCAx/9J8cbiwMGaLafzFkD40HSCwSaHQLKY5gxy++oC8Prm9d3JjUjP1mX7nG+72CytSwivkD0hsufGmxsIcWQhSERw+sk/D7+pnYbFC0CA5un4focg8utE6HQGMTCWTBaiCpfI0FpMMYJaP34M7pbWBURcm6d2bZPMMs9VwzY6HWNtG6jcrBUmlDOH/2l5zABg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bG0l8dY3L/Y3T0U95xEIVTtiM2vsKjF6GwWCC69EvjM=;
 b=sBjgz5+rDJo5/Zq3Qb1pJJL6/hzj20IA6HVk4Y9plDCZ8Qe3VFFTQQVc+B1B/qsd5tQ6/IvAfyYecBh6lO6tbiPNfrE+kYY9MKHUU3orJg4HFvOa057s4FjwEB/Q5vWBn0giy+IXMcmJ0dzRmV7w/xbf2BCanDldL31p9jvds2c=
Received: from BY3PR05CA0044.namprd05.prod.outlook.com (2603:10b6:a03:39b::19)
 by PH5PR10MB997759.namprd10.prod.outlook.com (2603:10b6:510:39e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Sat, 7 Nov 2026
 14:57:46 +0000
Received: from PH4PEPF0000B60C.namprd21.prod.outlook.com
 (2603:10b6:a03:39b:cafe::4) by BY3PR05CA0044.outlook.office365.com
 (2603:10b6:a03:39b::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.6 via Frontend Transport; Sat, 7
 Nov 2026 14:57:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 PH4PEPF0000B60C.mail.protection.outlook.com (10.167.243.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.2 via Frontend Transport; Sat, 7 Nov 2026 14:57:45 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:18 -0600
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:17 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:57:17 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7EvGMe3374177;
	Sat, 7 Nov 2026 08:57:17 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 15/15] crypto: ti - Change lengths in AEAD to u64 to avoid potential overflows
Date: Sat, 7 Nov 2026 20:26:18 +0530
Message-ID: <20261107145618.2349562-16-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60C:EE_|PH5PR10MB997759:EE_
X-MS-Office365-Filtering-Correlation-Id: f3c1d970-c582-4078-b747-08df3cdf7b5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|376014|18002099003|22082099003|10067099003|261021121427099003|56012099006|261102123227099003|261026121527099003|261009223027099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	c1Ys+lylCq10lenjbm85S1OW0platcZGSgmTH8LCxCZUp5JFrx6h4hI9qWZcmKD0BtVNnhKwz5xD6yiJsfN5Q8qiD6VoGFWMzis1EfycqFMyuFmp3naqr2Niys6vFbn0uRyahU2l+6Up1bhMDQOjRXaLwp6NMFiJW7aZBzs675yhI8I/k+gT9viWwNiyBG3ACIN5JBzudcBXugTbkQDa2iwyERQI48cFu2Vi1gNo/Z0zeX8gkgSQSuixjKkCEYoie8Q6wZ9E3/fSY64RpwN3YXD+A46R0GzqL1fu1GHoZMtg9oBQEq+jD7vEaxRZkk8W6r7IMlvyB+bXlyZqzsd95siHBoiSPdmlO246Z/dgD/OePhfhAUbAZTL9Im0noQ6flb0bO4HzV0Zzk6RSw/wc2ElFwrnVm4bd1w6PcOJVB89MzS3p2oTlIYGfw43Aq/j61pm/aoyZ+c+TwoRmr581wlHCmlH4y2EzHkLcvr0kWVfbAGyCEN2CZDBLdHM7arx/zFyLEZJZ87+ed/EucK36RcGNW6BTgPylsXm45T1GRcd8qjCEdKlH1mfOvWxXGPsJfFfAA4NIPWd9hzsztjOoQou8zk3RuyowhjNfsU0QFiTf/GjdFH89KU6BiBV7YQVkPX0kvW3r/za6ETttH/wME78Jwj+vnSdyETE2L57GXZfaf7gBCzGzOUG47GxozP7sYEKevNpa/YuV6pa9mR4fvQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(10067099003)(261021121427099003)(56012099006)(261102123227099003)(261026121527099003)(261009223027099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DaqxrddUp4LKgjpvxmluGaCIZs7XdlgWHGawzaX6mLq5cYMSx8UVqwrNIk/4/JG5EcOmBRSm/U3N/p60nk8MWj+JmDxxeMb5Es0tBzHH/VzanfAfOc52Wm6qCt8KmGIzLZl9g02Nca7EbglbRX5ZnjXx6avC1BT8fhBMGSit+Vdh9Iz+YpJBGxpezsiAdZ/8OD8O3vMwesBuxDnCqriMMXzR/4z/CAJqwEiMJRP+291+98gvFCyyRP2OYTICNh0GpYulgDn2yZszlESMVPh3n+6ETQPu6T7+q7cdr8y/UV3hDJFO0S84tF7CQy1dywtzfwocIq/lOtuQOLMgoJucRBmgE/+2K5aqXkHPM8vNel+RzCu+qkbhYzaF5x1LVBUgowcFlIV9TysV6YjdilthvtvlgesRRadwHyfWN1WJM+FxxrgWJnP7MGPIIFJE2mKQ
X-Exchange-RoutingPolicyChecked:
	uRpdQJEyalkyioYejlZ8bQ0w8v1O6moG9FG1cvVaxkZETa5csidfgVi9xawlSGTh7+77uNxTGK7opIL3WyChm/J/PA7kcnLOJAcOI6UZ7BAV1c18OlKLeJyriYhXpstK2Xse9ruAf0nwrltnpcqVxBVuQPcQeE3JDHofQ11Cub4HLdOzRYkTSTj6Rpvn7XmCBjC3I9DGSUO5vQdSt/Fb669DlJx/Ek9R6wdYzYArNi/44EzfZH9XY71s2Zg3YaXXAu995/J6LJ1dIQQAlQ1hmuB909Qqn7w+AF/BQiYeZp9uXOPF1ViWdiK6q6SVqDCFf/lz6veEZmvSKcA/I6W5Pg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:45.3733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c1d970-c582-4078-b747-08df3cdf7b5a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60C.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR10MB997759
X-Authority-Analysis: v=2.4 cv=F63C5ahN c=1 sm=1 tr=0 ts=6aef3c6d cx=c_pps
 a=vt7ZpyDplQGd1SQmd2LaWQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=epFSbgyaDKMf97JQNz0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfXzQ6Dt4lV3T/d
 AEuyHmT2La//22juVEwteVp+te1yvqSa6v5MNlbs1+0r3nlxy2UeLXozH8lPm6/3wm2VFlWLFmK
 zLaqw/djd/HkZ/q3o6GhYVoZr3pn+oeJyQbilY5vFg3LxSSUtABmQwl1rx875P8XBiqMKvOYVI0
 5DCkqFUybaBX86c/S3L/GgQusZCqdjrfMSatxeFBk1t/HTwL1MCtpJUVnEExn1kTH1e2CBrRBhd
 ONntstbj3IeIX+gm+aGT8wWl+PwE830/Mj+w51or2aOZCRbQrwn0h5BA4v7PVuwadnruOO44JJg
 RRHHysLTgns/pMMaYxzkbdWZ6VhYVxPR4gY3Jigp0Se9wkHONz2DdMC10oS4RgvXu46EuYeqNCr
 zR/6HT+uEHNeCziR1AiPjD+0F1XuwacsAIfldcaI/1LZscwVqifKfASoxQq7kd3e+nS+jH78Se2
 mueW///xo8LjG4YBYFA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX2w/3E5Gu+xY0
 aPAJyuwwyCmXNtUh9NPfgFK9FARtzWS5EMnAy1NGMci5YCr8mN6bNGSyeHcT4u6bRAfT132CFlE
 2pOxE7KyNQHNXJlqYWqcnT0T32YLZtc=
X-Proofpoint-ORIG-GUID: X0SL7mIbgXrlBRqrf8KteqJdjh6S6uHD
X-Proofpoint-GUID: X0SL7mIbgXrlBRqrf8KteqJdjh6S6uHD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

Change assoclen, cryptlen, authsize from unsigned int to u64 to avoid
overflow when they are added (in TAG offset and padding length
calculation)

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 38 ++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index e141ab8980000..e4217abf1ca57 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -758,6 +758,9 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag[AES_BLOCK_WORDS];
+	u64 assoclen = req->assoclen;
+	u64 cryptlen = req->cryptlen;
+	u64 authsize = ctx->authsize;
 	int nents;
 	int ret;
 
@@ -765,12 +768,17 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 	if (ret)
 		return ret;
 
-	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	nents = sg_nents_for_len(req->dst, cryptlen + assoclen + authsize);
 	if (nents < 0)
 		return nents;
 
-	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
-			     req->assoclen + req->cryptlen);
+	/*
+	 * DTHEv2 is supported on ARM64 K3 SoCs. The off_t skip argument in
+	 * sg_pcopy_*() hence is 64-bit and the sum assoclen + cryptlen
+	 * does not overflow.
+	 */
+	sg_pcopy_from_buffer(req->dst, nents, tag, authsize,
+			     assoclen + cryptlen);
 
 	return 0;
 }
@@ -781,6 +789,9 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
+	u64 assoclen = req->assoclen;
+	u64 cryptlen = req->cryptlen;
+	u64 authsize = ctx->authsize;
 	int nents;
 	int ret;
 
@@ -788,14 +799,19 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 	if (ret)
 		return ret;
 
-	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	nents = sg_nents_for_len(req->src, assoclen + cryptlen);
 	if (nents < 0)
 		return nents;
 
-	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
-			   req->assoclen + req->cryptlen - ctx->authsize);
+	/*
+	 * DTHEv2 is supported on ARM64 K3 SoCs. The off_t skip argument in
+	 * sg_pcopy_*() hence is 64-bit and the sum assoclen + cryptlen
+	 * does not overflow.
+	 */
+	sg_pcopy_to_buffer(req->src, nents, tag_in, authsize,
+			   assoclen + cryptlen - authsize);
 
-	if (crypto_memneq(tag_in, tag_out, ctx->authsize))
+	if (crypto_memneq(tag_in, tag_out, authsize))
 		return -EBADMSG;
 	else
 		return 0;
@@ -889,10 +905,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
-	unsigned int cryptlen = req->cryptlen;
-	unsigned int assoclen = req->assoclen;
-	unsigned int authsize = ctx->authsize;
-	unsigned int unpadded_cryptlen;
+	u64 cryptlen = req->cryptlen;
+	u64 assoclen = req->assoclen;
+	u64 authsize = ctx->authsize;
+	u64 unpadded_cryptlen;
 	struct scatterlist *src = NULL;
 	struct scatterlist *dst = NULL;
 	struct scatterlist *aad_sg = NULL;
-- 
2.34.1

