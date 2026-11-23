Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795444203;
	b=evaV16saRaudta/2mmi1q3SfFkXN0nSfZK3zxK84JWxQaLOQ98yMYWudCTwofek4CHDQ
	 H3eC4rNz1N2NQliRjYRYkIfpJswX6uG0XEqzUL7tykMApmPkA99asyprnsScljGaugsP0
	 WWBLo/9XJzX/yqEmhp7F0+sPQPzDu8X304gKDWuXiamfQ0aUDcB1pojQw6X6iIhlSwgOV
	 fIT7Gy9yxJVhHbyxkW79FMZOydkX5NHO7knJ99BlWZ3FarNI2V3w3IFYCupeHF912iR1O
	 7HkT+es26myaN09cUuY7QEATixE+t2bctdJO0l/GP2zN1MoLChUZkH04SwWDd/BTRgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444203;
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
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=tKFO7EHKS+G5n3IIKi/zRcdWm5jKCxhGy7NvcmNdKTo=;
	b=3NPH28L78pH3pZqBqudyQc/asfSl79lBS7X8URN/JqZMXp0Td2gNelyeKGOTWacmShB1
	 CJhJ3khaiMZPqsoIhzeyCGuSqMm/3AEFQjqCZUX/6Ng/kDKHURwbCbQ877lizKcdomA01
	 vdJ46KwCaDYkLxOYJhQ0SNT5A9fQHckDP/KmkNJw3qmsTeaIJTtGKotsuW3c3oR3qEcTa
	 qq6U69cnakgWGkpqpFHsuajdYMTt0cnFgkQqrvf648SA8zIztrg2xL9uFqIEY1iOrxXYg
	 Hh+xW/zoqhcXbTX4RFJntAl/D5yh8CShDLZv9u1wGSMoaPnO5+GKv1gf1pmfCtChWjQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b="T9Xgl/lb";
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=D6skya4H;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3D7606A31E;
	Mon, 23 Nov 2026 14:30:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A3D7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=T9Xgl/lb;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=D6skya4H
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANDKT2M3362739;
	Mon, 23 Nov 2026 08:29:56 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=tKFO7EHKS+G5n
	3IIKi/zRcdWm5jKCxhGy7NvcmNdKTo=; b=T9Xgl/lbxR0JziLC/VoFDapmE+Jtb
	QxLvGGZx3z65xPuFLIl0x7H+sTSA3tX0fhx2LN6jSskU4xqMhlh+Ewu9oljp9j6n
	rbEJB+mwk8vIXIRRj/XD8Ixp7CK8JtwFMoY+ortw91IU9cvWO0gWq7nibXmDZzju
	iMN/sEOXbvMu2qxNWYGh5jW3OXhO9wtmv8VBZVoEaHFZLUxw8I3PfUEymdXW9pGa
	t+HmKUOczD0jdsmTUrNNtUwiz1FmvFf6KRRxar3jUPBjFLXSaCdoKTWpqO68w41W
	9qypUKPJnYPwX5MLCuiGz8Fw7h+ht5e4e4FakqRCs26NzvsZ/C3AJedOQ==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011035.outbound.protection.outlook.com [52.101.57.35])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4j3uaspra6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 23 Nov 2026 08:29:55 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RxEoPV1xaIpsygm4o/zymz8sC9fW98Ow5qQYTPWUScKFMAEQFEG7QDpzdsEqXOTLuumdTumKkYolSGJ5Qmj8bt4ZC+p+9xS+pGyOQkUPzq/9BUg80TD7ZNvjCKeTaPCDlprYrnvQ7kP+FU655kxiuW/JYwJqnjI91mt2cxXwjWzU8R1IkE30ZbSZABqZyDvNlQLdka3+eYB3sFVBRmT0qDUtC0Ujs03BRyT2iDnTJJrJyYzjAL8o1JgBdhewEMQwIB+5Iy5//GhA54fXmtGd0ShBaYefrjvi1Cs4BxMND8qBfMPOiU2TcIT3XzVESiJYY1PzZT9TfMSaQ5pPHLKWkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKFO7EHKS+G5n3IIKi/zRcdWm5jKCxhGy7NvcmNdKTo=;
 b=nG5hIaiS8CbQNV7YLKCwG1eYrgPjmFmKkJsv+ayj8eD6T2xqIXw5XcMV0xiMHHwy4tEgGkmn2Ae1tqDmOszN5WTiIeBF35KpFYra/tGziI811PYeZ1MeshgxF3StEqvHFox1NxBFrpMGa5xxpDdlmgM/ICzrrRGvslZg+wo1OxWUFaXU1inhGaRnWqD9Iex38Nk3YFg8v2jdBZWRiKP7FG8XxV9Do1Jq+JQef8gEMgIZGc3hLm1xdsKK1Y0sftLbQZZyTlwTANgcaSws16dsO1K06aG+TU5tWQzaRaPhWn4HsARaqhVV40IRAnp4Kc2sZClpywu4olt9Zz0wrZw2pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKFO7EHKS+G5n3IIKi/zRcdWm5jKCxhGy7NvcmNdKTo=;
 b=D6skya4Hwdxhr8lmE2CAatwlL99oJzgpAA1VR+v4WAR+3mLFt/vKPvarmpUnSp71oxc0E7TTZ2YyfX0+C9btvzsWs9i2iievzG3aLbYdAGG0P7p3cevhkmY2ohhiZPlyiLSVUWMODBtClMcp0MZ8zHaa0ZzOHvRNGd7ZfETP2Pw=
Received: from SJ0PR05CA0106.namprd05.prod.outlook.com (2603:10b6:a03:334::21)
 by PH3PPFAF038C41B.namprd10.prod.outlook.com (2603:10b6:518:1::7bf) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Mon, 23 Nov
 2026 14:29:48 +0000
Received: from BY1PEPF0001AE16.namprd04.prod.outlook.com
 (2603:10b6:a03:334:cafe::a9) by SJ0PR05CA0106.outlook.office365.com
 (2603:10b6:a03:334::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Mon, 23
 Nov 2026 14:29:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BY1PEPF0001AE16.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Mon, 23 Nov 2026 14:29:45 +0000
Received: from DLEE205.ent.ti.com (157.170.170.85) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 23 Nov
 2026 08:29:24 -0600
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 23 Nov
 2026 08:29:24 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Mon, 23 Nov 2026 08:29:24 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6ANETMGE2835495;
	Mon, 23 Nov 2026 08:29:23 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v10 0/2] Add support for hashing algorithms in TI DTHE V2
Date: Mon, 23 Nov 2026 19:59:16 +0530
Message-ID: <20261123142918.3451969-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE16:EE_|PH3PPFAF038C41B:EE_
X-MS-Office365-Filtering-Correlation-Id: 498d2e49-9be8-47ef-8377-08df496e38f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|1800799024|82310400026|261026121527099003|10067099003|261009223027099003|261021121427099003|261102130727099003|56012099006|261021123027099003|261022075727099003|261022105027099003|261026140227099003|261102123227099003|261028144727099003|261009221227099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	FeeupTICEhf4c7QWguyFem+W6ZCx0WaK7WHYoUgXoQD+MHvKqoRWbWDffBsAfsKEp9d1okIuYeHyiLiXj1F0W1VT1w4pBc+JLq1P0fxy68QaGHB3gKoDOZA7kuTu/iPibAwvx4v9QU1Ncx2+I3dqgGP1z6n8ju+FL5q7yVz/amdewK6JJNWQiZ5eVjjorzs33QEk54QKid8UA88nlK6MW2JISK650Ma8h6+CidoX35xMYkGa3NhJFPdlexJzjUhsXBY0gDhxE9skyR8KoKa7szHV2Hnicf8LgVDxbJ/WwT/7qsAybFu+1Q2sFzC+v+kWuHuahxfUD6fraAvQ5g4T3caD/kEqxgkLFc/98dRqyjggIOEmkORmzpxuNTFRgUcL2R4WHGkh6h4kSMEy8Va8aKa/ioD2lBkM2XhvQsxGZQCvNSWtciXQm4J26r6eu77VzxSajFtudcUX+DyUJIgrtd1OHzFcP5zDt7UZystQZTmrEeQHURphsY1jqJjzE4tu35rMkLH2CEugr5GzHK2oF+6Ol47wOH7o1glvQtt7SspUYG+OdJVao0SHPZytJDTx30ypa0KEWcC6nohPINy7T4M2jHQi4wcWA3bpgUsUSqPzJzc9Py/+mkiBNlfngTxXChBo3U030RV4iGHzVPaSbGIVkrmezj1JM3v+M6Utfhg=
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(261026121527099003)(10067099003)(261009223027099003)(261021121427099003)(261102130727099003)(56012099006)(261021123027099003)(261022075727099003)(261022105027099003)(261026140227099003)(261102123227099003)(261028144727099003)(261009221227099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EBbmuYCfA7daUtm6uMvqy5q8T3iaTDbUTssDVQ+Xjh7739GAbswD3xjI8uE9tTP118tY6fC+eViCCE79DUBPwRlU3C3prVW9V98pVdQJA7/oV3UwY9+c3B08EMKP9JKKSiHob4CWq8byXKGCUgTkAFErqA4un3LRBEhxtDIoZ89yVaasa+j9NDKLwaOv1gML6wIJZqOTMkYkNFpNBlfWEHGMx7Lz1cLwAFQsl127yFPmVmTNMwuvKGnxTju19W6gQ3lKAUb5CLNDuTrO2n6ZVeLZoBxIPP/tgRBpN+fBk0CZdNuLBSYi43RsmLh7MLumC9bR3cy3yiKE0fnHms2ZAMooqEBpQ+ys8gSzrs3uA5eaTCtMl1pOo0P7bdpi4h23tqUAedCuXAY01vhCwVfeBZ1dCJSh9zjvXupyAWTPFeFVs6pe10PQHVGyDPtsUzLc
X-Exchange-RoutingPolicyChecked:
	vs+lKdRqiVwa/gq6jlHV0AWpd7/v3KaBFdiF/aB0QzhWLdOuAc1mOeRqk736+QI235HQ0w/VuMXfca+pQjPdPb0m7RlWFZOi80FOU0XWoag9K63SFePAzoh9dALmEyNobpteIUPQzrUnPgPPiMMFx+2xVWIcoZvyoQnHkTzT9EhZJ4jRS9JIXmU6IyWmq7aSfG9wBShUh/AVeKPwmtcAl5YakO8rYdvKjyt19dKMW6Rac/RB61Znq5s+4uj1O/kyy/LZSZcYY7lFi7OH3Ny83NrAYXBkSJIAxwv9X5V0tVmh0uwTFrAqX7ceUQosAMkDgqVzDHWnEYQt3u4Tto823g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 14:29:45.9093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 498d2e49-9be8-47ef-8377-08df496e38f1
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE16.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFAF038C41B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDA1NyBTYWx0ZWRfX9fyeLvEz8jt+
 Q7LIoQt9ZcHOR2z4E8v0MdTZHCOHX33EmCDKTFEoYczllKVjPPy93eQTeikpbFl/7QvnKYBEZL0
 51+S46hSdjO4S44qGq6n9lofu6l23Pobgv09tJbIe10hN7CLHgW0Th6fxqHCRYATr/K0ynFHD0X
 DtKhR9yG3IQTNY3Shpx1hBd8tJMNc+5ndLBbeEvsGGB+S8hNKqpKnKW6EK2IVvTeJAsQMBiqFUD
 FmPLbyctD3H/AQ3wPD6jtdvH2m0+BRrz8OW5/q76/JrOiqzzM4TkgREdvpXnPIoDrUCLmlPyoSh
 ar7gt+5ZVo1dva4dr6Ptc+HFVbsbeojlQTd0FL41O/KtPUxOJGaMx73m7j1aHwmpBDx1N6lo+5f
 P6jO3zZIdk7N8QUUjfIFhW/IVPGzIFKr0JXRQLIHE9if9sqfVqy9l6wjV8sRGHdsb5+yvbCa+HM
 csfEjMtCI+2IkrO49Bg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDA1NyBTYWx0ZWRfX11IswBEFSAlr
 ch9SW+LTnIl3W0AHyhv+CO+biuxCneYKqiFCduiDqCrUtD9pG+0lMfGFca3CQMPk4+6XP2P+Grj
 AybgdmwwuvhM5a8M7RDbNh4xACJxTMM=
X-Proofpoint-GUID: 3MvE0IWnLTMrNdAy5ewDLnUo-Ie8S8o3
X-Authority-Analysis: v=2.4 cv=Zsp4uN7G c=1 sm=1 tr=0 ts=6b044de3 cx=c_pps
 a=MvJzBjTJNBx6A1eu3kpgJw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=NEAV23lmAAAA:8
 a=EkVIMCltSqSwak4VvQUA:9
X-Proofpoint-ORIG-GUID: 3MvE0IWnLTMrNdAy5ewDLnUo-Ie8S8o3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_03,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 adultscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611230057

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 were detailed in [1]. Additional hardware details
available in SoC TRM [2]. DTHEv2 includes, among its various
sub-components, a hashing engine which is compliant with various IETF
and NIST standards, including FIPS 180-3 and FIPS PUB 198.

This patch series adds support for the hashing algorithms
SHA224/256/384/512 as well as their HMAC counnterparts for the hashing
engine of Texas Instruments DTHE V2 crypto driver.

The driver is tested using full kernel crypto selftests
(CRYPTO_SELFTESTS_FULL) which all pass successfully [3].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto
Engine
Link:
https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: DTHEv2 kernel self-tests logs
Link: https://gist.github.com/Pratham-T/fd15b8e0ee815bcb420a60d451a0cf18

[4]: [PATCH v13 0/15] Fix several issues in DTHEv2 driver
Link: https://lore.kernel.org/all/20261112081204.1146395-1-t-pratham@ti.com/

Changelog:
v10:
 - Rebase on top of latest tree. 
 - Changed reqsize in algorithms to adjust for DMA padding.
v9:
 - Added overflow check on addition of lengths
v8: 
 - Minor fixes based on Sashiko comments on [4] and changes in [4]
v7:
 - Minor fixes based on Sashiko comments on [4]
v6:
 - Dropped MD5 and HMAC(MD5)
 - Fixed errors pointed by Sashiko
v5:
 - Removed CRYPTO_AHASH_ALG_FINAL_NON_ZERO and FINUP_MAX.  Implemented
   the same mechanism in the driver itself by witholding one block in
   the req ctx. 
v4:
 - Export initial state when phash_available = 0
v3:
 - Check for error in registration individualy for hash and aes driver
   algos.
 - Fixed comment style in dthev2-common.c
v2:
 - Completely revamped the driver to use the new CRYPTO_AHASH_BLOCK_ONLY
   framework for handling partial blocks and crypto_engine for queueing.
 - Added HMAC as well.

Link to previous versions:
v8: https://lore.kernel.org/all/20260910105014.1552521-1-t-pratham@ti.com/
v7: https://lore.kernel.org/all/20260827133542.619717-1-t-pratham@ti.com/
v6: https://lore.kernel.org/all/20260827112653.530273-1-t-pratham@ti.com/ 
v5: https://lore.kernel.org/all/20260807110501.975130-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20260526094355.555712-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20260226131103.3560884-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20260121132408.743777-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250218104943.2304730-1-t-pratham@ti.com/
---

T Pratham (2):
  crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver
  crypto: ti - Add support for HMAC in DTHEv2 driver

 drivers/crypto/ti/Kconfig         |    3 +
 drivers/crypto/ti/Makefile        |    2 +-
 drivers/crypto/ti/dthev2-aes.c    |   10 +-
 drivers/crypto/ti/dthev2-common.c |   43 +-
 drivers/crypto/ti/dthev2-common.h |   68 +-
 drivers/crypto/ti/dthev2-hash.c   | 1059 +++++++++++++++++++++++++++++
 6 files changed, 1164 insertions(+), 21 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

-- 
2.34.1

